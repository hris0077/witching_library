class RemoveBooksIdFromLoans < ActiveRecord::Migration[8.1]
  def change
    remove_column :loans, :books_id
  end
end
