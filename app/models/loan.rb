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
class Loan < ApplicationRecord
  include AASM

  belongs_to :book
  belongs_to :user


  aasm column: "state" do
    state :reserved, initial: true
    state :reserved, :active, :returned, :overdue, :canceled

    event :cancel do
      transitions from: :reserved, to: :canceled
    end

    event :loan do
      transitions from: :reserved, to: :active
    end

    event :return do
      transitions from: [ :active, :overdue ], to: :returned
    end

    event :overdue do
      transitions from: :active, to: :overdue
    end

    def print_status_after
      puts "status changed to #{aasm.current_state}"
    end
  end
end
