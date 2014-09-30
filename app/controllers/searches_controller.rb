class SearchesController < ApplicationController
  before_filter :authenticate_user!

  def search
    @results = []
    if params[:search].present?
      search_term, locality = params[:search], (params[:locality])
      city = Locality.where(area_name: locality).first.city if locality.present?
      [Cuisine, Item, Place].each do |category|
        @results += category.custom_search search_term, city: city
      end
    end
    render json: @results
  end

  def places
    lat, lon, radius = params[:lat].to_f, params[:lon].to_f, params[:radius].to_i
    city, cuisine_id = params[:city], params[:cuisine_id]

    locality_id = (lat > 0 and lon > 0) ? nil : params[:locality_id]
    if locality_id
      locality = Locality.find locality_id
      lat,lon = locality.latitude,locality.longitude
    end

    places = Place.new_custom_search(lat, lon, radius: radius, locality: locality,
                           city: city, cuisine_id: cuisine_id).results

    places.each {|place| place.distance = place.distance_from([lat,lon]) }
    @places = places.sort_by(&:distance).select { |p| p.disabled == false }

    respond_to do |format|
      format.html { render 'places', :layout => false }
      format.json { render json: @places }
    end
  end


  def items_places
    lat, lon, radius = params[:lat].to_f, params[:lon].to_f, params[:radius].to_i
    city, item_name = params[:city], params[:item_name]

    locality_id = (lat > 0 and lon > 0) ? nil : params[:locality_id]
    if locality_id
      locality = Locality.find locality_id
      lat,lon = locality.latitude,locality.longitude
    end

    items = Item.new_custom_search(lat, lon, radius: radius, locality: locality,
                           city: city, item_name: item_name).results

    grouped_items = {}
    items.group_by(&:place_id).each do |place_id,dishes|
      place = Place.find(place_id)
      grouped_items[place] = dishes.sort_by(&:total_votes).reverse
    end

    # Compute the distance from user's location
    grouped_items.each do |place,dishes|
      place.distance = place.distance_from([lat,lon])
    end

    @results = grouped_items.sort_by {|k,v| v.map(&:total_votes).sum / k.distance }.reverse

    respond_to do |format|
      format.html { render 'items_places', :layout => false }
      format.json { render json: @results }
    end
  end

end
