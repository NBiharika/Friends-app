class RemoveLastNameFromFriends < ActiveRecord::Migration[7.0]
  def change
    remove_column :friends, :last_name, :string
  end
end
