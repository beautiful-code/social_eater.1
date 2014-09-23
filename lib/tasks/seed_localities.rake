namespace :social_eater do
  # Run Rake db:seed before doing this which seeds the locality
  desc "update place locality"
  task :update_place_locality,  [:prefix] => :environment do |t, args|
    Locality.all.each do |locality|
      Place.where('short_address LIKE ?',"%#{locality.area_name}%").each do |place|
        place.update_attribute(:locality_id,locality.id) unless place.locality_id
      end
    end
  end
end
