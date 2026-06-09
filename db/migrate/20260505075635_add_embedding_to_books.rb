class AddEmbeddingToBooks < ActiveRecord::Migration[8.1]
  def change
    add_column :books, :embedding, :vector, limit: 384

    # add_index :books, :embedding, using: :ivfflat, opclass: :vector_cosine_ops, lists: 100
  end
end
