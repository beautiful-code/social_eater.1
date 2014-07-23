class AddCuisineToPlace < ActiveRecord::Migration
  def change
    add_column :places, :cuisines, :text
  end
end
