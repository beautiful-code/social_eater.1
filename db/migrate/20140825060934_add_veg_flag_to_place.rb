class AddVegFlagToPlace < ActiveRecord::Migration
  def change
    add_column :places, :veg, :boolean
  end
end
