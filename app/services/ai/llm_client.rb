require "faraday"
require_relative "error"

module Ai
  class LlmClient
    attr_reader :query, :source_sentence, :sentences

    def self.call(query:, source_sentence:, sentences:)
      new(query: query, source_sentence: source_sentence, sentences: sentences).generate_text_response
    end

    def initialize(query:, source_sentence:, sentences:)
      @query = query
      @source_sentence = source_sentence
      @sentences = sentences
    end


    def generate_text_response
      Rails.cache.fetch("llm_response_#{Digest::MD5.hexdigest(query)}", expires_in: 1.day) do
        response = Ai::RetryPolicy.execute do
          Rails.logger.info("Crunching sentences from llm_client...")
          connection.post do |req|
            req.body = {
              model: Ai::Config.llm_model_path,
              messages: build_messages,
              max_tokens: Ai::Config.llm_max_tokens
            }.to_json
          end
        end
        handle_response(response)
      end

    rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
      raise Ai::ConnectionError, "Network failure: #{e.message}"
    rescue Faraday::ServerError => e
      raise Ai::ProviderError, "Provider failure: #{e.message}"
    rescue Faraday::ClientError => e
      handle_client_error(e)
    end

    def handle_response(response)
      unless response.success?
        raise Ai::ProviderError, "Unexpected response: #{response.status}"
      end

      content = response.body.dig("choices", 0, "message", "content")

      raise Ai::ProviderError, "Response did not contain generated text" if content.blank?

      content.strip
    end

    def handle_client_error(e)
      status = e.response[:status]
      case status
      when 401
        raise Ai::AuthenticationError, "Invalid Hugging Face API key"
      when 429
        raise Ai::RateLimitError, "Hugging Face rate limit exceeded"
      else
        raise Ai::ProviderError, "Unexpected response: #{status}"
      end
    end

    private

    def build_messages
      [
        {
          role: "system",
          content: source_sentence
        },
        {
          role: "user",
          content: sentences
        }
      ]
    end

    def self.connection
      @connection ||= Faraday.new(Ai::Config.llm_base_url) do |conn|
        conn.request :authorization, :Bearer, ENV["HF_API_KEY"]
        conn.request :json
        conn.response :json, content_type: "application/json"
        conn.response :raise_error
        conn.adapter Faraday.default_adapter
      end
    end

    def connection
      self.class.connection
    end
  end
end
