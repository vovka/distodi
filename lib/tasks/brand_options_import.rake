namespace :brands_and_models do
  desc "Import brands and models"
  task import: :environment do
    ["Car", "Bike"].each do |category|
      from_json_file(Rails.root.join("entities"), category)
    end
  end

  def from_json_file(file_name, category_name)
    category = Category.find_by(name: category_name)
    entities = JSON.parse(IO.read("#{file_name}.json"))
    entities[category_name].each do |entity|
      category.brand_options.create!(entity)
    end
  end
end
