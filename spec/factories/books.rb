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
FactoryBot.define do
  factory :book do
    sequence(:title) { |n| "Book #{n}" }
    association :author
    published_at { 2000 }
    isbn { 1 }
    description { "MyString" }
  end
end
