class Item < ActiveRecord::Base
  belongs_to :place
  belongs_to :category
  acts_as_votable 

  validates_presence_of :name, :category_id

  def voter_ids
    votes_for.collect(&:voter_id)
  end
end
