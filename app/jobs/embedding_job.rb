# app/jobs/embedding_job.rb
class EmbeddingJob < ApplicationJob
  queue_as :default
  retry_on Faraday::ConnectionFailed, wait: 30.seconds, attempts: 3

  def perform(sentences:, book_id:)
    client = Ai::EmbeddingProvider.new
    embedding = client.generate_embeddings(sentences: sentences)
    book = Book.find_by_id(book_id)
    book.update!(embedding: embedding["embedding"][0]) if embedding["embedding"][0].present?
    puts "book id #{book_id}: embedded"
  end
end
