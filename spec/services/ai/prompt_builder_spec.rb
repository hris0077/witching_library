require "rails_helper"

RSpec.describe Ai::PromptBuilder, type: :services do
  describe "#for" do
    let!(:book1) { create(:book, title: "book1", description: "some text") }
    let!(:book2) { create(:book, title: "book2", description: "another text") }

    let(:query) { "magic spell" }
    let(:books) { [ book1, book2 ] }

    it "with valid input returns prompt" do
      expect(described_class.for(query: query, books: books)).to eq(
        source_sentence: "You are an ancient oracle dwelling in a sentient library known as The Hut, \nguarded by Baba Yaga. Answer in a wise, slightly mystical tone. Use ONLY \nthe provided tomes as context. If a tome doesn't relate to the query, \nacknowledge it but don't force a connection. Keep responses under 4 sentences.\n",
        sentences: "Context:\nTome 1: \"book1\" by #{book1.author.name}. some text\n\nTome 2: \"book2\" by #{book2.author.name}. another text\n\nQuestion: magic spell"
      )
    end

    it "with invalid input returns error" do
      expect { described_class.for(query: query, books: []) }.to raise_error(Ai::Error, "No books provided")
    end
  end
end
