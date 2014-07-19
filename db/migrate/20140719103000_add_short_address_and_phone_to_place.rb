class AddShortAddressAndPhoneToPlace < ActiveRecord::Migration
  def change
    add_column :places, :short_address, :string
    add_column :places, :phone, :string
  end
end
