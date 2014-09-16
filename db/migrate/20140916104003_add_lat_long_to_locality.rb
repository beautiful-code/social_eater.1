class AddLatLongToLocality < ActiveRecord::Migration
  def change
    add_column :localities,:latitude, :decimal, {:precision=>10, :scale=>6}
    add_column :localities,:longitude, :decimal, {:precision=>10, :scale=>6}
  end
end
