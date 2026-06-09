# == Schema Information
#
# Table name: authors
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :author do
    sequence(:name) { |n| "Author #{n}" }

    transient do
      books_count { 0 }
    end

    after(:create) do |author, evaluator|
      if evaluator.books_count > 0
        author.books = create_list(:book, evaluator.books_count)
      end
    end
  end
end
