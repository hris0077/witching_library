class CreateMembers < ActiveRecord::Migration[8.1]
  def change
    create_table :members do |t|
      t.string :full_name
      t.string :password_digest
      t.string :email

      t.timestamps
    end
  end
end
