class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.references :place, index: true
      t.integer :position

      t.timestamps
    end
  end
end
