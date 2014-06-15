class AddOmniauthColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :provider_pic, :text
    add_column :users, :uid, :string
    add_column :users, :name, :string

    add_column :users, :token, :text
    add_column :users, :token_expires, :integer
  end
end
