class CreateLocalities < ActiveRecord::Migration
  def change
    create_table :localities do |t|
      t.string :area_name
      t.string :city

      t.timestamps
    end
  end
end
