class RemoveFirstNameFromFriends < ActiveRecord::Migration[7.0]
  def change
    remove_column :friends, :first_name, :string
  end
end
