namespace :social_eater do
  desc "seed cuisines"
  task :seed_cuisines,  [:prefix] => :environment do |t, args|
    CUISINES = CUISINE_TO_CATEGORIES.keys
    CUISINES.each do |cuisine_name|
      Cuisine.find_or_create_by_name cuisine_name
    end
  end
end
