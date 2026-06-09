require "faraday"

module Ai
  class EmbeddingProvider
    BASE_URL = "#{ENV['EMBEDDING_SERVICE_URL']}/embedding"

    attr_reader :sentences

    def initialize(sentences:)
      @sentences = sentences
    end

    def generate_embeddings
      response = connection.post do |req|
        req.body = { payload: @sentences }.to_json
      end
      parse_response(response)

    rescue Faraday::ClientError => e
      raise Ai::ProviderError, "Unexpected response: #{response.status}"
    end

    def parse_response(response)
      case response.status
      when 200
        response.body
      when 401
        raise Ai::AuthenticationError, "Invalid Hugging Face API key"
      when 429
        raise Ai::RateLimitError, "Hugging Face rate limit exceeded"
      else
        raise Ai::ProviderError, "Unexpected response: #{response.status}"
      end
    end

    def self.connection
      @connection ||= Faraday.new(BASE_URL) do |conn|
        conn.request :json
        conn.response :json, content_type: "application/json"
        conn.options.timeout = 10 # Specific to embeddings
        conn.adapter Faraday.default_adapter
      end
    end

    def connection
      self.class.connection
    end
  end
end
