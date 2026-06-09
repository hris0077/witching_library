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
require 'rails_helper'

RSpec.describe Loan, type: :model do
  subject { build(:loan, state: nil) }

  it { is_expected.to be_valid }

  it "transitions to initial state" do
    expect(subject).to have_state("reserved")
  end

  it "allow activating the loan on reserved plan" do
    expect(subject).to transition_from(:reserved).to(:active).on_event(:loan)
  end

  it "allow cancelling on reserved plan"  do
    expect(subject).to transition_from(:reserved).to(:canceled).on_event(:cancel)
  end

  it "allow returning on overdue plan"  do
    expect(subject).to transition_from(:overdue).to(:returned).on_event(:return)
  end

  it "allow returning on active plan"  do
    expect(subject).to transition_from(:active).to(:returned).on_event(:return)
  end

  it "allow overdue on active plan"  do
    expect(subject).to transition_from(:active).to(:overdue).on_event(:overdue)
  end

  it "not valid transition"  do
    expect(subject).not_to transition_from(:active).to(:canceled).on_event(:cancel)
  end

  it "rejects borrowing without new loan" do
    expect(subject).not_to transition_from(:returned).to(:active).on_event(:loan)
  end
end
