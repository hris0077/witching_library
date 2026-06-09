class AddBookToLoan < ActiveRecord::Migration[8.1]
  def change
    add_reference :loans, :book, null: false, foreign_key: true
  end
end
