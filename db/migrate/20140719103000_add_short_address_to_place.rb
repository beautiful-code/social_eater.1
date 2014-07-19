class AddShortAddressToPlace < ActiveRecord::Migration
  def change
    add_column :places, :short_address, :string
  end
end
