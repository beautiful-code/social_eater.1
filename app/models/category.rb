class Category < ActiveRecord::Base
  belongs_to :place

  has_many :items
end
