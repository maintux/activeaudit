require 'active_support/concern'

module ActiveAudit
  module Logger

    extend ActiveSupport::Concern

    included do

      has_many :audits, class_name: "ActiveAudit::Audit", as: :obj

      after_create :log_activity_on_create
      after_update :log_activity_on_update
      before_destroy :log_activity_on_destroy

      attr_accessible :audit_user_id
      attr_accessor :audit_user_id
      attr_accessor :audit_extras

      cattr_accessor :loggable_events do
        {}
      end

      def self.loggable_event(event)
        self.loggable_events.merge! event
      end

      def log_event(activity)
        ActiveAudit::Audit.create obj_id: id, obj_type: self.class.to_s, user_id: audit_user_id, activity: activity, extras: audit_extras
      end
      private :log_event

      def log_activity_on_create
        self.class.loggable_events.each do |k,v|
          next unless k.eql?(:create)
          if v.eql?(true)
            log_event k.to_s
          elsif v.is_a?(Array)
            v.each do |field|
              if field.is_a?(Hash) and self.send(field.keys.first).eql?(field.values.first)
                log_event(k.to_s) and break
              elsif field.is_a?(Symbol) and self.send(field.to_s)
                log_event(k.to_s) and break
              end
            end
          end
        end
      end

      def log_activity_on_update
        self.class.loggable_events.each do |k,v|
          next if [:create,:destroy].include?(k)
          if k.eql?(:update) and v.eql?(true)
            log_event k.to_s
          elsif v.is_a?(Array)
            v.each do |field|
              if field.is_a?(Hash) and self.send("#{field.keys.first}_changed?") and self.send(field.keys.first).eql?(field.values.first)
                log_event(k.to_s) and break
              elsif field.is_a?(Symbol) and self.send("#{field}_changed?")
                log_event(k.to_s) and break
              end
            end
          end
        end
      end

      def log_activity_on_destroy
        self.class.loggable_events.each do |k,v|
          next unless k.eql?(:destroy)
          log_event k.to_s
        end
      end

    end

  end
end
