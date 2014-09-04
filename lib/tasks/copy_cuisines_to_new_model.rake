namespace :social_eater do
  desc "copy cuisines over to new model"
  task :copy_cuisines_to_new_model,  [:prefix] => :environment do |t, args|
    Place.all.each do |place|
      place.old_cuisines.each do |cuisine|
        if !place.cuisines.where(name: cuisine).present?
          c = Cuisine.find_or_create_by_name(cuisine)
          place.cuisines << c
        end
      end
    end
  end
end
