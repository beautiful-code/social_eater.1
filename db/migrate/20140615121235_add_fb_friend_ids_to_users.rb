class AddFbFriendIdsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :friend_fb_ids, :text
    add_column :users, :friend_ids, :text
  end
end
