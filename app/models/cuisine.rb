class Cuisine < ActiveRecord::Base

  include TextSearchable

  has_and_belongs_to_many :places

  searchable do
    text :name,boost: 5
  end


  def self.custom_search query,extra={}
    search = Cuisine.search do
      fulltext query
      paginate(:page => 1, :per_page => 3)
    end
    search.results || []
  end


end
