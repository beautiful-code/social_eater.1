class AddLocalityIdToPlace < ActiveRecord::Migration
  def change
    add_column :places, :locality_id, :int
  end
end
