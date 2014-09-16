json.array!(@cuisines) do |cuisine|
  json.extract! cuisine, :id, :name
  json.url admin_cuisine_url(cuisine, format: :json)
end
