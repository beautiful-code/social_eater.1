json.array!(@categories) do |category|
  json.extract! category, :id, :name, :place, :order
  json.url category_url(category, format: :json)
end
