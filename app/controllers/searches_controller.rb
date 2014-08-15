class SearchesController < ApplicationController



  def new

  end


=begin
  def search
    @search = Item.search do
      fulltext params[:search]
      paginate page: 1, per_page: 10
    end
    @results = @search.results
    render 'new'
  end
=end


  def search
    search_term,city = params[:search], (params[:city] || 'Bangalore')
    @results = []
    [Place,Locality,Cuisine,Item].each do |category|
      @results += category.custom_search search_term,city: city
    end
    render json: @results
  end







end
