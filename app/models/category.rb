class Category < ActiveRecord::Base
  belongs_to :place

  has_many :items

  validates_presence_of :name

  def self.by_position
     order(:position)
  end

  def tags_list
    tags.present? ? tags.split(',').collect{|e| e.strip}: []
  end

  def tag_hash
    ret = tags_list.inject({}) {|hash, tag| hash[tag] = tagged_items(tag); hash}
    ret['other'] = items.select {|item| !tags_list.include?(item.tag)}
    ret
  end

  def tagged_items tag
    items.select {|i| i.tag == tag}
  end

  after_initialize do |category|
    category.position ||= 0
  end

  before_save do |category|
    if category.tags.present?
      category.tags = category.tags.downcase
      category.tags = category.tags.strip
    end
  end

  def total_item_cold_votes
    items.inject(0) {|sum,item| sum += item.cold_votes}
  end
end
