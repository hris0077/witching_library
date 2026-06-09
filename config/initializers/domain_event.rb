
Rails.application.config.after_initialize do
  # AuditSubscriber will now be safely autoloaded

  Rails.event.subscribe(AuditSubscriber.new) { |event| event[:name].start_with?("user.") }
end

# or
# require Rails.root.join('app', 'subscribers', 'audit_subscriber')
# Rails.event.subscribe(AuditSubscriber.new)
