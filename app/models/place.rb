class Place < ActiveRecord::Base
  mount_uploader :image, ImageUploader

  has_many :items
  has_many :categories, :order => "position ASC"


  validates_presence_of :name

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
