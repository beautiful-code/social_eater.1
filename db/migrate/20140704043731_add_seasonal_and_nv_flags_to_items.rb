class AddSeasonalAndNvFlagsToItems < ActiveRecord::Migration
  def change
    add_column :items, :seasonal, :boolean
    add_column :items, :non_veg , :boolean
  end
end
