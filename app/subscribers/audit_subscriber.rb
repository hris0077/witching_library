class AuditSubscriber
  include DomainEvent::Subscriber

  handles_event "user.created"

  def emit(event)
    user_id = event[:payload][:user_id]
    user = User.find(user_id)
    p "---> User created ##{user.id}:#{user.first_name}"
    Rails.logger.info(event)
  end
end
