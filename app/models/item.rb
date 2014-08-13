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


  searchable do
    text :name, boost: 5
    text :desc
  end



  def voter_ids
    votes_for.collect(&:voter_id)
  end

  def total_votes
    cold_votes + votes_for.size
  end


  def set_default_category
    return if category.present?
    self.category = place.set_default_category
  end

  def kind
    self.class.name
  end


  def as_json(options={})
    options ||= {}
    options[:methods] ||= [:kind]
    super(options)
  end


end
