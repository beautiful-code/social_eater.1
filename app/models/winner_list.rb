class WinnerList
  attr_accessor :place, :list,:list_hash

  MAX_WINNERS = 5
  UNCATEGORIZED_CATEGORY_NAME = 'Uncategorized'
  
  def initialize place
    @place = place
    @list = []
    @list_hash = {}

    @place.ordered_items.each do |cat_id, items|
      cat = Category.find(cat_id)
      @list_hash[cat_id] = [items.first] unless cat.name == UNCATEGORIZED_CATEGORY_NAME
    end


    @place.top(MAX_WINNERS).each do |item|
      next if item.category.name == UNCATEGORIZED_CATEGORY_NAME
      self.add_item item
    end
  end


  def count
    result = 0
    @list_hash.each_pair {|k,v| result += v.size}
    result
  end

  def add_item item
    @list_hash[item.category.id] << item unless @list_hash[item.category.id].include?(item)
  end

  def list
    list_hash.to_a.sort {|a,b| Category.find(a[0]).position <=> Category.find(b[0]).position}
  end

end
