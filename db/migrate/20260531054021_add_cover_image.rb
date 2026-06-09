class AddCoverImage < ActiveRecord::Migration[8.1]
  def change
    add_column :books, :cover_image, :string
  end
end
