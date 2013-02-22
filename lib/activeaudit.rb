module ActiveAudit
  def self.load!
    if defined?(::Rails)
      require 'active_audit/engine'
    end
  end
end

ActiveAudit.load!