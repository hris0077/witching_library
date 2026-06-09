require "rails_helper"

RSpec.describe Ai::LlmClient, type: :service do
  describe '.call' do
    let(:normal_source) { "You are an ancient oracle." }
    let(:normal_sentences) { [ "Tome 1: The Enchanted April" ] }
    context 'when the API returns success' do
      it 'returns the LLM response' do
        result = described_class.call(
          source_sentence: normal_source,
          sentences: normal_sentences
        )
        expect(result).to eq('The hut whispers of ancient magic and forgotten spells...')
      end
    end

    context 'when the API returns a rate limit error (429)' do
      it 'raises Ai::RateLimitError' do
        expect { described_class.call(
          source_sentence: "trigger_rate_limit",
          sentences: normal_sentences
        ) }.to raise_error(::Ai::RateLimitError)
      end
    end

    context 'when the API returns timeout error' do
      it 'raises Ai::ProviderError' do
        expect { described_class.call(
          source_sentence: "trigger_timeout",
          sentences: normal_sentences
        ) }.to raise_error(::Ai::ProviderError)
      end
    end

    context 'when the API returns server error (500)' do
      it 'raises Ai::ProviderError' do
        expect { described_class.call(
          source_sentence: "trigger_server_error",
          sentences: normal_sentences
        ) }.to raise_error(::Ai::ProviderError)
      end
    end

    context 'when caching the response' do
      let(:normal_source) { "You are an ancient oracle." }
      let(:normal_sentences) { [ "Tome 1: The Enchanted April" ] }
      let(:expected_response) { "The hut whispers of ancient magic and forgotten spells..." }
      let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }

      before do
        allow(Rails).to receive(:cache).and_return(memory_store)
        Rails.cache.clear
      end

      it 'only makes one network request for identical queries' do
        expect(Ai::LlmClient.connection).to receive(:post).once.and_call_original

        result1 = described_class.call(
          source_sentence: normal_source,
          sentences: normal_sentences
        )
        expect(result1).to eq(expected_response)

        result2 = described_class.call(
          source_sentence: normal_source,
          sentences: normal_sentences
        )
        expect(result2).to eq(expected_response)
      end
    end
  end
end
