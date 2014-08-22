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
    dictionary = %w(chicken mutton kebab murg murgh haleem omlet egg fish prawn crab bbq gosh)
    dictionary.each do |keyword|
      items = Item.where('name like ?',"%#{keyword}%")
      items.each do |item|
        item.update_attribute(:non_veg, true)
      end
    end
  end
end
