class ActiveAudit::Audit < ActiveRecord::Base

  attr_accessible :obj_id, :obj_type, :activity, :user_id
  validates_presence_of :obj_id, :obj_type, :activity

  if defined?(::Rails)
    ::ActiveAudit::AuditConcern
    if defined?(::ActiveAudit::AuditConcern)
      include ::ActiveAudit::AuditConcern
    end
  end

end
