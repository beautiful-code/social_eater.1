class Item < ActiveRecord::Base
  belongs_to :place
  acts_as_votable 

  def voter_ids
    votes_for.collect(&:voter_id)
  end
end
