class DivinationController < ApplicationController
  allow_unauthenticated_access only: %i[ home consult ]
  def home
  end

  def consult
    @query = divination_params
    @books = []

    if @query.present?
      @books = retrieve_books_for(@query)

      if @books.present?
        prompt = Ai::PromptBuilder.for(query: @query, books: @books)

        @response = Ai::LlmClient.call(
          source_sentence: prompt[:source_sentence],
          sentences: prompt[:sentences]
        )
      end
    end

    respond_to do |format|
      format.turbo_stream
      format.html { render :home }
    end

  rescue StandardError => e
    Rails.logger.error("LLM failed: #{e.message}")
    @books = []
    flash.now[:alert] =  "The hut falls silent. The connection to the archives is broken. Please try again, seeker."
  end

  def divination_params
    params.expect(:query)
  end

  def retrieve_books_for(query)
    embedding = Rails.cache.fetch(Digest::MD5.hexdigest(query), expires_in: 1.day) do
      # Only executed if the cache does not already have a value for this key
      puts "Crunching the numbers..."
      result = Ai::EmbeddingProvider.new(sentences: [ query ]).generate_embeddings
      result.dig("embedding", 0)
    end
    Book.nearest_to(embedding).limit(3)
  end
end
