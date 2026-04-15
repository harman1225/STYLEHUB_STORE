require "open-uri"
require "json"

namespace :import do
  desc "Import products from DummyJSON API"
  task products: :environment do
    url = "https://dummyjson.com/products"

    puts "Fetching products..."

    response = URI.open(url).read
    data = JSON.parse(response)

    data["products"].each do |item|
      category_name = item["category"].titleize
      category = Category.find_or_create_by!(name: category_name)

      Product.create!(
        name: item["title"],
        description: item["description"],
        price: item["price"],
        category: category,
        image: item["thumbnail"]
      )
    end

    puts " Products imported!"
  end
end
