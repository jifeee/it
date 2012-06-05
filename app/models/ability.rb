# class defining all user permissions
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    alias_action :destroy, :to => :batch_delete
    
    unless user.new_record?
      #  Define current User for access from models
      User.current = user

      if user.admin?
        can :manage, :all
        
      elsif user.role
        user.role.permissions.each do |permission|
          can permission.action.to_sym, permission.subject_class.constantize
          if add = AppResources::action_aliases(permission.action.to_sym)
            can add, permission.subject_class.constantize
          end
        end
        # can :batch_delete, Company
      end
      
      can :read, Shipment
    end
    
    can :read, Shipment

  end
end
 
=begin
:Shipments
read - everyone


=end
