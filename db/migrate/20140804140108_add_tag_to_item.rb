class AddTagToItem < ActiveRecord::Migration
  def change
    add_column :items, :tag, :string
  end
end
