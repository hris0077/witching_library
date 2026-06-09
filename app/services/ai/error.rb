module Ai
  class Error < StandardError; end
  class ConnectionError < Error; end
  class ProviderError < Error; end
  class AuthenticationError < ProviderError; end
  class RateLimitError < ProviderError; end
end
