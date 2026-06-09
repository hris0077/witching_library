# app/jobs/event_log_job.rb
class EventLogJob < ApplicationJob
  queue_as :event

  def perform(name:, payload:)
    EventLog.create!(name: name, payload: payload)
  end
end
