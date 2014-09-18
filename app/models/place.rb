class Place < ActiveRecord::Base

  include TextSearchable
  mount_uploader :image, ImageUploader

  attr_accessor :distance

  has_many :items
  has_many :categories, :order => "position ASC"
  has_and_belongs_to_many :cuisines
  belongs_to :locality

  CUISINES = CUISINE_TO_CATEGORIES.keys

  serialize :old_cuisines, Array
  validates_presence_of :name, :locality_id, :latitude, :longitude, :short_address

  after_initialize do |place|
    place.veg = false unless place.veg
  end

  after_create :populate_categories
  geocoded_by :short_address   # can also be an IP address
  after_validation :geocode

  scope :enabled, where(:disabled => false)

  searchable do
    text :name, boost: 5
    text :short_address
    string :city
    string :area
    latlon(:location) { Sunspot::Util::Coordinates.new(latitude, longitude) }
  end

  # Use like so: Place.search { with(:location).in_radius(17.3916,78.4658,1)}

  def self.sorted
    order('name asc')
  end

  def populate_categories
    categories = []

    self.cuisines.each do |cuisine|
      categories = categories | (CUISINE_TO_CATEGORIES[cuisine] || [])
    end

    categories.each_with_index do |category, index|
      Category.create(:place => self, :name => category, :position => index*5, :cold_votes => 0)
    end

  end

  def tags
    categories.collect(&:tags_list).compact.flatten.uniq
  end

  def ordered_items
    categorized_items = items.select {|i| i.category.present?}
    ret = categorized_items.group_by(&:category_id).sort_by {|cat,items| Category.find(cat).position}
    ret.each do |cat_id, items|
      items.sort! {|a,b| b.total_votes <=> a.total_votes}
    end
    ret
  end

  def populated_categories
    categories.find(ordered_items.collect {|e| e.first} )
  end

  def top n
    items.sort {|a,b| b.total_votes <=> a.total_votes}[0..n-1]
  end

=begin
  def items_by_category
     items = {}
     categories.by_position.each { |cat|  items[cat.id] = cat.items}
     items
  end
=end

  def winner_list
    winner_list = []

    ordered_items.each do |cat_id, items|
      winner_list << [cat_id, [items.first]]
    end

    winner_list
  end

  def set_default_category
    cat = Category.find_or_create_by(name: 'Uncategorized', place_id: id)
    cat.update_attribute(:position, 50)
    cat
  end

  def kind
    self.class.name
  end

  def self.custom_search query,extra={}
    city = extra[:city]
    search = Place.search do
      fulltext query
      with(:city,city)
      paginate(:page => 1, :per_page => 3)
    end
    search.results || []
  end


  def self.new_custom_search(lat,lon,extra={})
    extra ||= {}
    city ||= extra[:city]
    radius = extra[:radius] || 5
    area ||= extra[:area]

    search do
      with(:location).in_radius(lat,lon,radius) if (lat && lon && radius)
      with(:city,city) if city.present?
      with(:area,area) if area.present?
      #paginate(:page=>1,:per_page=>6)
    end
  end

  def city
    locality.city
  end

  def area
    locality.area_name
  end

  def cuisines_list
    cuisines.first(2).collect { |c| c.name.upcase }.join(', ')
  end

end
