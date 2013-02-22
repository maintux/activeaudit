require 'active_audit/logger'

module ActiveAudit
  module Rails
    class Engine < ::Rails::Engine
      initializer 'activeservice.autoload', :before => :set_autoload_paths do |app|
        app.config.autoload_paths += %W(#{app.config.root}/app/concerns/active_audit)
      end
      #ActiveRecord::Base.class_eval do
        #include ActiveAudit::Logger
      #end
    end
  end
end
