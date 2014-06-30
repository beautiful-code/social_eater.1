wok = Place.create!(:name => 'SO')

Item.create!(:place => wok, :name => 'Chicken Wok', :desc => 'Fusion of Chickend and Fried Rice', :price => 300, :cold_votes => 2)
