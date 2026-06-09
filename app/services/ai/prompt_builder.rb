module Ai
  class PromptBuilder
    SYSTEM_ROLE = <<~TEXT.freeze
      You are an ancient oracle dwelling in a sentient library known as The Hut,#{' '}
      guarded by Baba Yaga. Answer in a wise, slightly mystical tone. Use ONLY#{' '}
      the provided tomes as context. If a tome doesn't relate to the query,#{' '}
      acknowledge it but don't force a connection. Keep responses under 4 sentences.
    TEXT

    MAX_DESCRIPTION_CHARS = 200

    def self.for(query:, books:)
      # puts "query send"
      # puts query
      # puts books
      new(query: query, books: books).build
    end

    def initialize(query:, books:)
      @query = query
      @books = books
    end

    def build
      {
        source_sentence: SYSTEM_ROLE,
        sentences: "Context:\n#{build_context_sentences.join("\n\n")}\n\nQuestion: #{query}"
      }
    end

    private

    attr_reader :query, :books

    def build_system_prompt
      SYSTEM_ROLE
    end

    def build_context_sentences
      raise Ai::Error, "No books provided" if @books.empty?

      @books.map.with_index do |book, idx|
        # snippet = truncate(book.description)
        "Tome #{idx + 1}: \"#{book.title}\" by #{book.author&.name}. #{book.description}"
      end
    end

    def truncate(text)
      return "" if text.blank?
      text.length > MAX_DESCRIPTION_CHARS ? "#{text[0...MAX_DESCRIPTION_CHARS]}..." : text
    end
  end
end
