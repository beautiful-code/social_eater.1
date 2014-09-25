namespace :social_eater do
  desc "assign default category to unassigned items"
  task :assign_default_category_to_items,  [:prefix] => :environment do |t, args|
    Item.all.each do |item|
      item.set_default_category
      item.save
    end
  end

  desc "Set non-veg items"
  task :set_non_veg_items, [] => :environment do
    dictionary = %w(chicken mutton murg murgh haleem fish prawn crab gosh ghost goat lamb kodi chaapa)
    dictionary.each do |keyword|
      Place.all.each do |restaurant|
        # Set all items to veg
        restaurant.items.each {|item| item.update_attribute(:non_veg, false) }

        # Set all non vegetarian items
        nonveg_items = restaurant.items.where('items.name LIKE ? OR items.desc LIKE ?',"%#{keyword}%", "%#{keyword}%")
        nonveg_items.each { |item| item.update_attribute(:non_veg, true) }
      end
    end
  end
end
