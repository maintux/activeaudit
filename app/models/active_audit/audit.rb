class ActiveAudit::Audit < ActiveRecord::Base

  attr_accessible :obj_id, :obj_type, :activity, :user_id, :extras
  validates_presence_of :obj_id, :obj_type, :activity
  serialize :extras, Hash

  if defined?(::Rails)
    if File.exists?(File.join(Rails.root.to_s,'app','models','concerns','active_audit','audit_concern.rb'))
      require_or_load File.join(Rails.root.to_s,'app','models','concerns','active_audit','audit_concern')
      if defined?(ActiveAudit::AuditConcern)
        include ActiveAudit::AuditConcern
      end
    end
  end

end
