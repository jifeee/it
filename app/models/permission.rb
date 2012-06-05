include AppResources

class Permission < ActiveRecord::Base
  has_and_belongs_to_many :roles
  
  def self.possible_permissions
    AppResources::possible_permissions
  end
end
