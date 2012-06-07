module AppResources
  def self.included(owner)
    Rails.cache.clear(:permissions)
  end
  
  def possible_permissions
    Rails.cache.write(:permissions, get_from_directory("#{Rails.root}/app/controllers").uniq) unless Rails.cache.read(:permissions)
    Rails.cache.read(:permissions)
  end
  
  def get_from_directory dir, namespace=nil
  
    @permissions = []
#    Dir.new(dir).entries.each do |controller|
#      @permissions += get_from_directory(File.join(dir, controller), controller +'/') if controller == "api"
#      if controller =~ /_controller/
#        controller.gsub!('_controller.rb', '')

#        next if skip?(controller) || !routes_hash.keys.include?("#{namespace}#{controller}")
#        
#        routes_hash["#{namespace}#{controller}"].each do |action|
#          @permissions << Permission.find_or_create_by_action_and_subject_class(action_alias(action), to_subj_class(controller))
#        end
#      end
#    end

    {"users" => [:create, :read, :update, :delete],
     "shipments" => [:create, :read, :update, :delete],
     "milestones" => [:create, :read, :update, :delete],
     "companies" => [:create, :read, :update, :delete],
     "agents" => [:create, :read, :update, :delete],
     }.each_pair do |controller, actions|
      actions.each do |a|
        @permissions << Permission.find_or_create_by_action_and_subject_class(a, to_subj_class(controller))
      end
    end
     
    @permissions
  end  
  
  def action_aliases(action)
    {
      :delete => [:batch_delete],
      :create => [:upload_edi],
      :update => [:unlinks,:unlink,:join,:joins]
    }[action.to_sym] || Array(action)
  end
  
  private
  def routes_hash
    @routes ||= Rails.application.routes.routes.map(&:defaults).inject({}) do |rez, route|
      (rez[route[:controller]] ||= []) << route[:action]; rez
    end
  end
  
  def to_subj_class name
    resource_alias(name).singularize.capitalize
  end
  

  def action_alias action
    {:batch_delete => :delete,
     :new          => :create,
     :edit         => :update,
     :complete     => :update,
     :index        => :read,
     :show         => :read}[action.to_sym] || action
  end

  def resource_alias name
    {"parents" => "users"}[name] || name
  end
  
  def skip? controller
    ["application", "pages", "sessions"].include? controller.downcase
  end
end
