# == Schema Information
#
# Table name: authors
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Author, type: :model do
  subject { build(:author) }

  it "is valid" do
    expect(subject).to be_valid
  end

  context "create list of books" do
    let!(:author_demo) { create(:author, books_count: 2) }

    it "expect to have  2 books" do
      expect(author_demo.books.size).to eq(2)
    end
  end
end
