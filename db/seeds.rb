#wok = Place.create!(:name => 'SO')
#category = Category.create!(:place => wok, :name => 'Soups', :position => 3)

#Item.create!(:place => wok, :category => category, :name => 'Chicken Wok', :desc => 'Fusion of Chickend and Fried Rice', :price => 300, :cold_votes => 2)


# Locality
[
  ["Banjara Hills", "Hyderabad"],
  ["Hitec City", "Hyderabad"],
  ["Madhapur", "Hyderabad"],
  ["Jubilee Hills", "Hyderabad"],
  ["Film Nagar", "Hyderabad"],
  ["MLA Colony", "Hyderabad"],
  ["Masab Tank", "Hyderabad"]
].each do |locality|
  Locality.find_or_create_by(area_name: locality[0], city: locality[1])
end
