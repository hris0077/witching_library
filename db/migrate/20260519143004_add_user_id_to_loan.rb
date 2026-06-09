class AddUserIdToLoan < ActiveRecord::Migration[8.1]
  def change
    remove_column :loans, :member_id
    add_reference :loans, :user, null: false, foreign_key: true
  end
end
