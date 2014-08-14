class Locality < ActiveRecord::Base

  validates_presence_of :area_name,:city

  has_many :places

end
