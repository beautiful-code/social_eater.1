class Category < ActiveRecord::Base
  belongs_to :place

  has_many :items

  validates_presence_of :name
end
