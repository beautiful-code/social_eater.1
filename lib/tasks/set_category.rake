namespace :social_eater do
  desc "assign default category to unassigned items"
  task :assign_default_category_to_items,  [:prefix] => :environment do |t, args|
    Item.all.each do |item|
      item.set_default_category
      item.save
    end
  end
end
