class Locality < ActiveRecord::Base

  include TextSearchable

  validates_presence_of :area_name,:city

  has_many :places

  searchable do
    text :area_name,boost: 5
    string :area_name
    string :city
  end

  def self.custom_search query,extra={}
    city = extra[:city]
    search = Locality.search do
      fulltext query
      with(:city,city)
      paginate(:page => 1, :per_page => 5)
    end
    search.results || []
  end

  def name
    area_name
  end

end
