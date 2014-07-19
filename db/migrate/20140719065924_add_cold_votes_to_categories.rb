class AddColdVotesToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :cold_votes, :integer, :default => 0
  end
end
