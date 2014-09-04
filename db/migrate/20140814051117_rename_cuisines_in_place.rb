class RenameCuisinesInPlace < ActiveRecord::Migration
  def change
    rename_column :places, :cuisines, :old_cuisines
  end
end
