class ChangeCategoryColumn < ActiveRecord::Migration[8.1]
  def change
    remove_column :books_categories, :categorie_id
    add_reference :books_categories, :category, null: false, foreign_key: true
  end
end
