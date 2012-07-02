class User < ActiveRecord::Base

  # Setup accessible (or protected) attributes for your model
  devise :database_authenticatable, :registerable, :recoverable, :validatable
  
  attr_accessor :query

  attr_accessible :password, :password_confirmation, :email, :login, :language, :role_id, :user_id, :api_token, :company_name, :address, :phone, :first_name, :last_name, :name, :ext, :activation_code
  
  validates :login, :email,
    :uniqueness => {:case_sensitive => false}
  
  validates :password, :password_confirmation, :presence => true, :length => {:maximum => 255}, :on => :create

  validates :login, :first_name, :last_name, :email, :phone,
    :presence => true, :length => {:maximum => 255}
    
  validates :activation_code, :presence => true, :uniqueness => {:case_sensitive => false}, :if => :driver?

  enum_attr :language, %w(en es)
  
  belongs_to :role
  has_many :notifications
  accepts_nested_attributes_for :notifications, :reject_if => proc{|att| att['shipment_id'].blank? || att['email'].blank?}, :allow_destroy => true
  
  has_many :milestones, :foreign_key => :driver_id
  Role::ROLES.each do |role|
    delegate :"#{role.downcase}?", :to => :role, :allow_nil => true
  end

  has_many :user_relations

  scope :free_admins, :include => [:user_relations], :conditions => 'user_relations.owner_id is null and users.role_id = 4'
  # scope :files_without_document, :include => [:document_files], :conditions => 'filelists.id is null'

  scope :sas, proc{ where(:role_id => Role.where(:name => "sa".humanize).first) }
  scope :admins, proc{ where(:role_id => Role.where(:name => "admin".humanize).first) }
  scope :operators, proc{ where(:role_id => Role.where(:name => "operator".humanize).first) }
  scope :drivers, proc{ where(:role_id => Role.where(:name => "driver".humanize).first) }
  
  scope :search, lambda {|param|
    where(["email LIKE ? OR login LIKE ? OR first_name LIKE ? OR LAST_NAME LIKE ?", *(["%#{param}%"] * 4)]) if param.present?
  }
  after_create do |record|
    Mailer.user_created(record).deliver
  end
  
  def username
    login.blank? ? email : login
  end

  def user_fullname
    [self.first_name, self.last_name].compact.join(" ")    
  end
  
  def manager?
    sa? || admin?
  end
  
  def generate_token!
    update_attribute :api_token, Devise.friendly_token
  end
  
  def current_milestone
    milestones.where("completed IS NOT TRUE").order("created_at desc").first || milestones.create
  end

  def self.current=(user)
    @current_user = user
  end

  def self.current
    @current_user ||= nil
  end

  def owner
    self.user_relations.first.owner
  end

  def belongs_to_company?
    self.user_relations.first.owner.class == Company rescue nil
  end

  def belongs_to_agent?
    self.user_relations.first.owner.class == Agent rescue nil
  end

  def allowed_shipments
    driver_ids = self.owner.users.drivers.all.map(&:id) rescue nil
    shipment_ids = Milestone.where(:driver_id => driver_ids).all.map(&:shipment_id) rescue nil
    shipment_ids = shipment_ids.compact.uniq rescue nil
    return shipment_ids
  end

end

