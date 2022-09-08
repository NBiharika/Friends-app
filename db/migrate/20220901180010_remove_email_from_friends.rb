class RemoveEmailFromFriends < ActiveRecord::Migration[7.0]
  def change
    remove_column :friends, :email, :string
  end
end
