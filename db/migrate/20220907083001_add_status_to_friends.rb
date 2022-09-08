class AddStatusToFriends < ActiveRecord::Migration[7.0]
  def change
    add_column :friends, :status, :string, default: "unsent"
  end
end
