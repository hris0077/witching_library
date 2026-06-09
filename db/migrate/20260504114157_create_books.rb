class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :title
      t.references :author, null: false, foreign_key: true
      t.integer :published_at
      t.integer :isbn
      t.string :description

      t.timestamps
    end
  end
end
