class RenameBooksCategories < ActiveRecord::Migration[8.1]
  def change
    rename_table :books_categories_tables, :books_categories
  end
end
