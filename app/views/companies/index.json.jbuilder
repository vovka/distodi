json.array!(@companies) do |company|
  json.extract! company, :id, :name, :phone, :country, :city, :street, :postal_code
  json.url company_url(company, format: :json)
end
