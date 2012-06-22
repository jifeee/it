class Role < ActiveRecord::Base
  has_many :users
  has_and_belongs_to_many :permissions
  
  ROLES = %w[sa driver operator admin]
  ROLE_NAMES = %w[Sa Driver Operator Admin]

  scope :dependant, where(:name => ["Driver", "Operator"])
  ROLES.each do |role|
    scope role, where(:name => role.humanize)
    
    define_method "#{role.downcase}?" do
      name == role.humanize
    end
  end
    
end
