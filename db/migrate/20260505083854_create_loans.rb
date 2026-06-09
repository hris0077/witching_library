class CreateLoans < ActiveRecord::Migration[8.1]
  def change
    create_table :loans do |t|
      t.references :books, null: false, foreign_key: true
      t.date :borrow_at
      t.date :due_to
      t.date :returned_at
      t.string :state

      t.timestamps
    end
  end
end
