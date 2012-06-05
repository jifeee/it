class Role < ActiveRecord::Base
  has_many :users
  has_and_belongs_to_many :permissions
  
  ROLES = %w[admin driver operator freight_forwarder]

  scope :dependant, where(:name => ["Driver", "Operator"])
  ROLES.each do |role|
    scope role, where(:name => role.humanize)
    
    define_method "#{role}?" do
      name == role.humanize
    end
  end
    
end
