class Item < ActiveRecord::Base
  belongs_to :place
  acts_as_votable 
end
