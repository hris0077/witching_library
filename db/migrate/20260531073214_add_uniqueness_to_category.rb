class AddUniquenessToCategory < ActiveRecord::Migration[8.1]
  def change
    change_column_null :categories, :name, false
    add_index :categories, :name, unique: true
  end
end
