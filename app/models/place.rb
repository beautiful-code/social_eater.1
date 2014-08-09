class Place < ActiveRecord::Base
  mount_uploader :image, ImageUploader

  has_many :items
  has_many :categories, :order => "position ASC"

  CUISINES = CUISINE_TO_CATEGORIES.keys

  serialize :cuisines, Array
  validates_presence_of :name

  after_create :populate_categories

  scope :enabled, where(:disabled => false)

  def self.sorted
    order('name asc')
  end

  def populate_categories
    categories = []

    self.cuisines.each do |cuisine|
      categories = categories | CUISINE_TO_CATEGORIES[cuisine]
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


end
