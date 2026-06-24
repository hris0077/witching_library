require "faraday"
require_relative "error"

module Ai
  class LlmClient
    # BASE_URL = "https://router.huggingface.co/v1/chat/completions"
    # MODEL_PATH = "microsoft/Phi-3-mini-4k-instruct:featherless-ai"
    # API_KEY = ENV["HF_API_KEY"]

    attr_reader :source_sentence, :sentences

    def self.call(source_sentence:, sentences:)
      new(source_sentence: source_sentence, sentences: sentences).generate_text_response
    end

    def initialize(source_sentence:, sentences:)
      @source_sentence = source_sentence
      @sentences = sentences
    end


    def generate_text_response
      response = Rails.cache.fetch([ "llm_response_#{Digest::MD5.hexdigest(sentences.to_s)}", sentences ], expires_in: 1.hour) do
        puts "Crunching sentences..."
        connection.post do |req|
          req.body = {
            model: Ai::Config.llm_model_path,
            messages: build_messages,
            max_tokens: Ai::Config.llm_max_tokens
          }.to_json
        end
      end

      response.body["choices"][0]["message"]["content"]&.strip

    rescue Faraday::ClientError => e
      status = e.response[:status]
      case status
      when 401
        raise Ai::AuthenticationError, "Invalid Hugging Face API key"
      when 429
        raise Ai::RateLimitError, "Hugging Face rate limit exceeded"
      else
        raise Ai::ProviderError, "Unexpected response: #{status}"
      end
    rescue Faraday::ServerError => e
      raise Ai::ProviderError, "Hugging Face server error: #{e.response[:status]}"

    rescue Faraday::Error => e
      raise Ai::ConnectionError, "Network failure: #{e.message}"
    end

    def handle_response(response)
      case response.status
      when 200
        response.body["choices"][0]["message"]["content"]&.strip
      when 401
        raise Ai::AuthenticationError, "Invalid Hugging Face API key"
      when 429
        raise Ai::RateLimitError, "Hugging Face rate limit exceeded"
      else
        raise Ai::ProviderError, "Unexpected response: #{response.status}"
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

    def parse_response(response)
      response.body["choices"][0]["message"]["content"]&.strip
      # data = JSON.parse(response.body)
      # HF returns: [{ "generated_text": "..." }]
      # data.first&.dig("generated_text")&.strip
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
