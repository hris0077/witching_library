class AddMemberToLoanAsReference < ActiveRecord::Migration[8.1]
  def change
    add_reference :loans, :member, null: false, foreign_key: true
  end
end
