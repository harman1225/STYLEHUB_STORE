require "csv"

namespace :import do
  desc "Import products from CSV"
  task csv_products: :environment do
    file = Rails.root.join("db/products.csv")

    CSV.foreach(file, headers: true) do |row|
      category = Category.find_or_create_by!(name: row["category"])

      Product.create!(
        name: row["name"],
        description: row["description"],
        price: row["price"],
        category: category
      )
    end

    puts " CSV products imported!"
  end
end
