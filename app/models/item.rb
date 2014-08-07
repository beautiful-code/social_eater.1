class Item < ActiveRecord::Base
  belongs_to :place
  belongs_to :category
  acts_as_votable
  before_save :set_default_category

  validates_presence_of :name

  after_initialize do |item|
    item.cold_votes ||= 1
    item.non_veg = false unless item.non_veg
    item.seasonal = false unless item.seasonal
  end

  def voter_ids
    votes_for.collect(&:voter_id)
  end

  def aggregated_cold_votes
    if category.present?
      (cold_votes + (category.cold_votes * (cold_votes.to_f / category.total_item_cold_votes))).round
    else
      cold_votes
    end
  end

  def total_votes
    aggregated_cold_votes + votes_for.size
  end



  private

  def set_default_category
    return if category != nil
    self.category = Category.find_or_create_by(name: 'Uncategorized', place_id: place.id)
  end




end
