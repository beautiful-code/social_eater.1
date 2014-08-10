class Category < ActiveRecord::Base
  belongs_to :place

  has_many :items

  validates_presence_of :name
  before_destroy :check_items

  def self.by_position
     order(:position)
  end

  def tags_list
    tags.present? ? tags.split(',').collect{|e| e.strip}: []
  end

  def tag_hash
    ret = {'all' => sort_items(items)}
    ret = tags_list.inject(ret) {|hash, tag| hash[tag] = tagged_items(tag); hash}
    ret['other'] = sort_items(items.select {|item| !tags_list.include?(item.tag)})
    ret
  end

  def tagged_items tag
    sort_items(items.select {|i| i.tag == tag})
  end

  def sort_items list
    list.sort{|a,b| b.total_votes <=> a.total_votes}
  end

  after_initialize do |category|
    category.position ||= 0
    category.tags ||= ''
  end

  before_save do |category|
    if category.tags.present?
      category.tags = category.tags.downcase
      category.tags = category.tags.strip
    end
  end

  def check_items
    if items.present?
      errors[:base] << "Items present under category. Please reassign items before deleting category"
      return false
    end
  end

  def total_item_cold_votes
    items.inject(0) {|sum,item| sum += item.cold_votes}
  end
end
