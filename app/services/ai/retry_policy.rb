module Ai
  module RetryPolicy
    class << self
      def execute(delay_method: method(:default_delay))
        attempts = 0
        begin
          yield
        rescue Faraday::ServerError, Faraday::TimeoutError, Faraday::TooManyRequestsError => e
          attempts += 1
          if attempts < Ai::Config.retry_max_attempts
            delay = Ai::Config.retry_base_delay * (2 ** (attempts - 1))
            delay_method.call(delay)
            retry
          else
            raise
          end
        end
      end


      def default_delay(seconds)
        sleep(seconds)
      end
    end
  end
end
