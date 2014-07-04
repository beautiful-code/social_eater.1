class Item < ActiveRecord::Base
  belongs_to :place
  belongs_to :category
  acts_as_votable 

  validates_presence_of :name, :category_id

  after_initialize do |item|
    item.cold_votes ||= 1
    item.non_veg = false unless item.non_veg
    item.seasonal = false unless item.seasonal
  end

  def voter_ids
    votes_for.collect(&:voter_id)
  end
end
