json.array!(@attribute_kinds) do |attribute_kind|
  json.extract! attribute_kind, :id, :title
  json.url attribute_kind_url(attribute_kind, format: :json)
end
