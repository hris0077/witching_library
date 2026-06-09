require "json"

class Ai::MockVectorProvider
  PATH = Rails.root.join("db/data/book_search_text.json")

  def self.for(query)
    vectors = load_vectors
    match = vectors.find { |item| item["heading"].downcase == query.to_s.downcase.strip }

    if match
      match["embedding"]
    else
      raise "Query '#{query}' not found in vector cache. Add it to #{PATH}"
    end
  end

  def self.load_vectors
    @vectors ||= JSON.parse(File.read(PATH))
  end
end
