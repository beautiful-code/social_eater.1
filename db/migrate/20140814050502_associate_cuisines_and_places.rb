class AssociateCuisinesAndPlaces < ActiveRecord::Migration
  def change
    create_table :cuisines_places do |t|
      t.belongs_to :cuisine
      t.belongs_to :place
    end
  end
end
