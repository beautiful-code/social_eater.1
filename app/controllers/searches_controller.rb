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

    @sunspot_search = Sunspot.search Item, Place do |query|
      query.keywords params[:search]
      query.paginate(:page => params[:page], :per_page => 30)
    end
    @results = @sunspot_search.results
    render json: @results
  end







end
