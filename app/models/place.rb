class Place < ActiveRecord::Base
  has_many :items
  has_many :categories, :order => "position ASC"

  def ordered_items
    items.group_by(&:category_id).sort_by {|cat,items| Category.find(cat).position}
  end

end
