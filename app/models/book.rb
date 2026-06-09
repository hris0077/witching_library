# == Schema Information
#
# Table name: books
#
#  id           :bigint           not null, primary key
#  cover_image  :string
#  description  :string
#  embedding    :vector(384)
#  isbn         :integer
#  published_at :integer
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  author_id    :bigint           not null
#  gutenberg_id :integer
#
# Indexes
#
#  index_books_on_author_id  (author_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => authors.id)
#
class Book < ApplicationRecord
  belongs_to :author
  has_and_belongs_to_many :categories

  has_neighbors :embedding

  attribute :similarity

  scope :nearest_to, ->(vector, limit: 3) {
    vector_sql = "[#{vector.join(',')}]"
    select("books.*, (1 - (embedding <=> '#{vector_sql}')) AS similarity")
       .order("similarity DESC")
       .limit(limit)
       .includes(:author)
  }
end
