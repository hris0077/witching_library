module Ai
  module Config
    class << self
      def settings
        @settings ||= {}
      end

      def configure
        yield(self) if block_given?
      end

      def method_missing(method_name, *args)
        if method_name.to_s.end_with?("=")
          settings[method_name.to_s.chomp("=").to_sym] = args.first
        else
          settings[method_name]
        end
      end

      # TODO: add respond_to?
    end
  end
end

Ai::Config.configure do |config|
  config.llm_base_url = "https://router.huggingface.co/v1/chat/completions"
  config.llm_model_path = "microsoft/Phi-3-mini-4k-instruct:featherless-ai"
  config.llm_api_key = ENV["HF_API_KEY"]
  config.llm_max_tokens = 500
  config.llm_temperature = 0.8
  config.embedding_provider_url = "#{ENV['EMBEDDING_SERVICE_URL']}/embedding"
  config.retry_max_attempts = 3
  config.retry_base_delay = 1.0
end
