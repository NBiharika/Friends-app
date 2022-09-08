class AddForeignIdToFriends < ActiveRecord::Migration[7.0]
  def change
    add_column :friends, :foreign_id, :integer
    add_index :friends, :foreign_id
  end
end
