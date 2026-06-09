class CreateBooksCategoriesTable < ActiveRecord::Migration[8.1]
  def change
    create_table :books_categories_tables do |t|
      t.references :books, null: false, foreign_key: true
      t.references :categories, null: false, foreign_key: true

      t.timestamps
    end

    remove_column :books, :category_id
  end
end
