namespace :social_eater do
  desc "seed localities"
  task :seed_localities,  [:prefix] => :environment do |t, args|
    ['Banjara Hills', 'Jubilee Hills', 'Hitec City'].each do |name|
      Locality.find_or_create_by(area_name: name,city: 'Hyderabad')
    end
  end
end
