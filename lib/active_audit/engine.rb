require 'active_audit/logger'

module ActiveAudit
  module Rails
    class Engine < ::Rails::Engine
      #ActiveRecord::Base.class_eval do
        #include ActiveAudit::Logger
      #end
    end
  end
end
