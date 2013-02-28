class ActiveAudit::Audit < ActiveRecord::Base

  attr_accessible :obj_id, :obj_type, :activity, :user_id
  validates_presence_of :obj_id, :obj_type, :activity

  if defined?(::Rails)
    if File.exists?(File.join(Rails.root.to_s,'app','concerns','active_audit','audit_concern.rb'))
      require File.join(Rails.root.to_s,'app','concerns','active_audit','audit_concern.rb')
    end
    if defined?(::ActiveAudit::AuditConcern)
      include ::ActiveAudit::AuditConcern
    end
  end

end
