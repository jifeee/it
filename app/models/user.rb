class User < ActiveRecord::Base

  # Setup accessible (or protected) attributes for your model
  devise :database_authenticatable, :registerable, :recoverable, :validatable
  
  attr_accessor :query

  attr_accessible :password, :password_confirmation, :email, :login, :language, :role_id, :user_id, :api_token, :company_name, :address, :phone, :first_name, :last_name, :name, :ext, :activation_code
  
  enum_attr :language, %w(en es)
  
  belongs_to :role
  has_many :notifications
  accepts_nested_attributes_for :notifications, :reject_if => proc{|att| att['shipment_id'].blank? || att['email'].blank?}, :allow_destroy => true
  
  has_many :milestones, :foreign_key => :driver_id
  Role::ROLES.each do |role|
    delegate :"#{role}?", :to => :role, :allow_nil => true
  end

  has_many :user_relations

  scope :freight_forwarders, proc{ where(:role_id => Role.where(:name => "freight_forwarder".humanize).first) }
  scope :drivers, proc{ where(:role_id => Role.where(:name => "driver".humanize).first) }
  scope :admins, proc{ where(:role_id => Role.where(:name => "admin".humanize).first) }
  scope :operators, proc{ where(:role_id => Role.where(:name => "operator".humanize).first) }
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
    admin? || freight_forwarder?
  end
  
  def generate_token!
    update_attribute :api_token, Devise.friendly_token
  end
  
  def current_milestone
    milestones.where("completed IS NOT TRUE").order("created_at desc").first || milestones.create
  end

  def self.current=(user)
    Thread.current[:current_user] = user
  end

  def self.current
    Thread.current[:current_user]
  end

end

