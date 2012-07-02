# class defining all user permissions
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    alias_action :destroy, :to => :batch_delete

    #  Define current User for access from models
    if user.new_record?
      User.current = nil
    else
      User.current = user
    end
    
    unless user.new_record?
      if user.sa?
        can :manage, :all
        
      elsif user.role
        user.role.permissions.each do |permission|
          can permission.action.to_sym, permission.subject_class.constantize

          # Abilities for non-REST actions
          if add = AppResources::action_aliases(permission.action.to_sym)
            add.map {|a| can(add, permission.subject_class.constantize)}
          end
        end
      end      
      # can :read, Shipment
    end    
    can :read, Shipment
  end
  
end