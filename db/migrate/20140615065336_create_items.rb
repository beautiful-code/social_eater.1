class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.text :desc
      t.float :price
      t.integer :cold_votes

      t.references :place, index: true

      t.timestamps
    end
  end
end
