class Place < ActiveRecord::Base
  mount_uploader :image, ImageUploader

  has_many :items
  has_many :categories, :order => "position ASC"

  CUISINES = CUISINE_TO_CATEGORIES.keys

  serialize :cuisines, Array
  validates_presence_of :name

  after_create :populate_categories

  def populate_categories
    categories = []

    self.cuisines.each do |cuisine|
      categories = categories | CUISINE_TO_CATEGORIES[cuisine]
    end

    categories.each_with_index do |category, index|
      Category.create(:place => self, :name => category, :position => index*5, :cold_votes => 0)
    end

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

  def uncategorized_items
    items.select {|i| !i.category.present?}
  end

  def top n
    items.sort {|a,b| b.total_votes <=> a.total_votes}[0..n-1]
  end
end
