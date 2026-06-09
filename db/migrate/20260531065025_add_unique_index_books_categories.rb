class AddUniqueIndexBooksCategories < ActiveRecord::Migration[8.1]
  def change
    add_index :books_categories, [ :book_id, :category_id ], unique: true
  end
end
