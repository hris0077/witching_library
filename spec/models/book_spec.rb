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
require 'rails_helper'

RSpec.describe Book, type: :model do
  subject { build(:book) }

  it "is valid" do
    expect(subject).to be_valid
  end

  it { is_expected.to belong_to(:author) }
end
