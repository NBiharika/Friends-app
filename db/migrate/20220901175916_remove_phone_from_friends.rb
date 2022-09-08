class RemovePhoneFromFriends < ActiveRecord::Migration[7.0]
  def change
    remove_column :friends, :phone, :string
  end
end
