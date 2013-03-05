require 'active_support/concern'

module ActiveAudit
  module Logger

    extend ActiveSupport::Concern

    included do

      has_many :audits, class_name: "ActiveAudit::Audit", as: :obj, dependent: :destroy

      after_create :log_activity_on_create
      after_update :log_activity_on_update
      before_destroy :log_activity_on_destroy

      attr_accessible :audit_user_id
      attr_accessor :audit_user_id
      attr_accessor :audit_extras

      @@_loggable_events = {}

      def self.loggable_event(event)
        @@_loggable_events.merge! event
      end

      def self.loggable_events
        @@_loggable_events
      end

      def log_activity_on_create
        @@_loggable_events.each do |k,v|
          next unless k.eql?(:create)
          if v.eql?(true)
            ActiveAudit::Audit.create obj_id: id, obj_type: self.class.to_s, user_id: audit_user_id, activity: k.to_s, extras: audit_extras
          elsif v.is_a?(Array)
            log_event = false
            v.each do |field|
              if field.is_a?(Hash)
                key, value = field.first
                log_event = true and break if self.send(key.to_s).eql?(value)
              elsif field.is_a?(Symbol)
                log_event and break if self.send(field.to_s)
              end
            end
            if log_event
              ActiveAudit::Audit.create obj_id: id, obj_type: self.class.to_s, user_id: audit_user_id, activity: k.to_s, extras: audit_extras
            end
          end
        end
      end

      def log_activity_on_update
        @@_loggable_events.each do |k,v|
          next if [:create,:destroy].include?(k)
          if k.eql?(:update) and v.eql?(true)
            ActiveAudit::Audit.create obj_id: id, obj_type: self.class.to_s, user_id: audit_user_id, activity: k.to_s, extras: audit_extras
          else
            if v.is_a?(Array)
              log_event = false
              v.each do |field|
                if field.is_a?(Hash)
                  key, value = field.first
                  log_event = true and break if self.send("#{key}_changed?") and self.send(key.to_s).eql?(value)
                elsif field.is_a?(Symbol)
                  log_event = true and break if self.send("#{field}_changed?")
                end
              end
              if log_event
                ActiveAudit::Audit.create obj_id: id, obj_type: self.class.to_s, user_id: audit_user_id, activity: k.to_s, extras: audit_extras
              end
            end
          end
        end
      end

      def log_activity_on_destroy
        @@_loggable_events.each do |k,v|
          next unless k.eql?(:destroy)
          ActiveAudit::Audit.create obj_id: id, obj_type: self.class.to_s, user_id: audit_user_id, activity: k.to_s, extras: audit_extras
        end
      end

    end

  end
end
