class AddOriginalIdToBooksTable < ActiveRecord::Migration[8.1]
  def change
    add_column :books, :gutenberg_id, :integer
  end
end
