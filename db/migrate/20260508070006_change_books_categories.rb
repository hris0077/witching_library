class ChangeBooksCategories < ActiveRecord::Migration[8.1]
  def change
    remove_column :books_categories, :books_id
    remove_column :books_categories, :categories_id

    add_reference :books_categories, :book, null: false, foreign_key: true
    add_reference :books_categories, :categorie, null: false, foreign_key: true
  end
end
