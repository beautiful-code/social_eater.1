class SearchesController < ApplicationController
  before_filter :authenticate_user!

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
    search_term, city = params[:search], (params[:city] || 'Hyderabad')
    @results = []
    [Place, Locality, Cuisine, Item].each do |category|
      @results += category.custom_search search_term, city: city
    end
    render json: @results
  end

  def places
    lat, lon, radius, city, cuisine_id = params[:lat].to_f, params[:lon].to_f, params[:radius].to_i, params[:city],
                                         params[:cuisine_id]
    locality_id = (lat > 0 and lon > 0) ? nil : params[:locality_id]
    if locality_id
      locality = Locality.find locality_id
      lat,lon = locality.latitude,locality.longitude
    end

    places = Place.new_custom_search(lat, lon, radius: radius, locality: locality, city: city,cuisine_id: cuisine_id).results

    places.each {|place| place.distance = place.distance_from([lat,lon]) }
    @places = places.sort_by(&:distance).select { |p| p.disabled == false }

    respond_to do |format|
      format.html { render 'places', :layout => false }
      format.json { render json: @places }
    end
  end

end
