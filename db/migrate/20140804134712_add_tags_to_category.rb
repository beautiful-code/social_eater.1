class AddTagsToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :tags, :string
  end
end
