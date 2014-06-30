class Place < ActiveRecord::Base
  has_many :items
  has_many :categories, :order => "position ASC"

  def ordered_items
    ret = items.group_by(&:category_id).sort_by {|cat,items| Category.find(cat).position}
    ret.each do |cat_id, items|
      items.sort! {|a,b| b.cold_votes <=> a.cold_votes}
    end

    ret
  end

end
