class Place < ActiveRecord::Base
  has_many :items
  has_many :categories, :order => "position ASC"

end
