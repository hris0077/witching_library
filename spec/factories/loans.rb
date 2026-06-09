# == Schema Information
#
# Table name: loans
#
#  id          :bigint           not null, primary key
#  borrow_at   :date
#  due_to      :date
#  returned_at :date
#  state       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  book_id     :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_loans_on_book_id  (book_id)
#  index_loans_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (book_id => books.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :loan do
    association :book
    association :user
    borrow_at { "2026-05-05" }
    due_to { "2026-05-05" }
    returned_at { "2026-05-05" }
    state { "reserved" }

    trait :reserved do
      state { "reserved" }
    end

    trait :active do
      state { "active" }
    end

    trait :returned do
      state { "returned" }
    end

    trait :overdue do
      state { "overdue" }
    end

    trait :canceled do
      state { "canceled" }
    end
  end
end
