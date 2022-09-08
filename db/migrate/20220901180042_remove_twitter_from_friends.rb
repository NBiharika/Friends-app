class RemoveTwitterFromFriends < ActiveRecord::Migration[7.0]
  def change
    remove_column :friends, :twitter, :string
  end
end
