json.array!(@localities) do |locality|
  json.extract! locality, :id, :area_name, :city
  json.url admin_locality_url(locality, format: :json)
end
