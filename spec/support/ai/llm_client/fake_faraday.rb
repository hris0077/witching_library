# frozen_string_literal: true

module Ai
  class LlmClient
    module FakeFaraday
      module_function

      def mock_lookup(stub)
        stub.post('/v1/chat/completions') do |env|
          body = JSON.parse(env.body)
          request_text = body['inputs'].to_s + body.dig('messages', 0, 'content').to_s

          if request_text.include?('trigger_rate_limit')
            [ 429, {}, { error: 'Rate limit exceeded' }.to_json ]

          elsif request_text.include?('trigger_timeout')
            [ 408, {}, { error: 'Internal server error' }.to_json ]

          elsif request_text.include?('trigger_server_error')
            [ 500, {}, { error: 'Internal server error' }.to_json ]
          else
            [
              200,
              { 'Content-Type' => 'application/json' },
              {
                choices: [
                  {
                    message: {
                      role: 'assistant',
                      content: 'The hut whispers of ancient magic and forgotten spells...'
                    }
                  }
                ]
              }.to_json
            ]
          end
        end
      end
    end
  end
end
