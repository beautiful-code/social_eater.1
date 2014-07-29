class AddDisableFlagToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :disabled, :boolean, :default => false
  end
end
