require "active_support/concern"

module DomainEvent
  module Subscriber
    extend ActiveSupport::Concern

    class_methods do
      def handles_event(name)
        @event_name = name
        DomainEvent.registry << self
      end

      def event_name
        @event_name
      end
    end
  end

  def self.registry
    @registry ||= []
  end
end
