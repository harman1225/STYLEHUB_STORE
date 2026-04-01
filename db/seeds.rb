# Clear old data (safe reset)
Product.destroy_all
Category.destroy_all

# Create Admin User (only in development)
AdminUser.find_or_create_by!(email: 'admin@example.com') do |admin|
  admin.password = 'password'
  admin.password_confirmation = 'password'
end if Rails.env.development?

puts " Admin user created!"

# Create 4 Categories
categories = [
  Category.create!(name: "Men"),
  Category.create!(name: "Women"),
  Category.create!(name: "Kids"),
  Category.create!(name: "Accessories")
]

puts " Categories created!"

# Realistic product data (GOOD QUALITY)
products_data = [
  {
    name: "Men's Cotton T-Shirt",
    description: "Soft and breathable cotton t-shirt designed for everyday comfort and casual wear.",
    price: 25
  },
  {
    name: "Slim Fit Formal Shirt",
    description: "Elegant slim fit shirt perfect for office wear and formal occasions.",
    price: 45
  },
  {
    name: "Women's Summer Dress",
    description: "Lightweight and stylish summer dress ideal for warm weather and casual outings.",
    price: 55
  },
  {
    name: "Denim Jacket",
    description: "Classic denim jacket with a modern fit, suitable for all seasons.",
    price: 70
  },
  {
    name: "Kids Running Shoes",
    description: "Comfortable and durable shoes designed for active kids.",
    price: 40
  },
  {
    name: "Leather Handbag",
    description: "Premium quality handbag with spacious compartments for daily essentials.",
    price: 90
  },
  {
    name: "Sports Hoodie",
    description: "Warm and stylish hoodie perfect for workouts or casual wear.",
    price: 50
  },
  {
    name: "Casual Jeans",
    description: "Comfortable and trendy jeans suitable for daily wear.",
    price: 60
  },
  {
    name: "Sneakers",
    description: "Lightweight sneakers designed for comfort and everyday use.",
    price: 65
  },
  {
    name: "Wrist Watch",
    description: "Stylish wristwatch with a modern design and durable build.",
    price: 120
  }
]

# Create 100 products
100.times do
  item = products_data.sample

  Product.create!(
    name: item[:name],
    description: item[:description],
    price: item[:price],
    stock: rand(5..50),
    category: categories.sample
  )
end

puts " 100 Products created successfully!"

# -------------------------------
# API PRODUCTS (SEPARATE)
# -------------------------------
require 'open-uri'
require 'json'

url = "https://fakestoreapi.com/products"
data = URI.open(url).read
products = JSON.parse(data)

products.each do |item|
  category = Category.find_or_create_by!(name: item["category"].capitalize)

  product = Product.create!(
    name: item["title"],
    description: item["description"],
    price: item["price"],
    stock: rand(10..100),
    category: category
  )

  # OPTIONAL (recommended for marks)
  file = URI.open(item["image"])
  product.image.attach(io: file, filename: "product.jpg")
end

puts " API Products added!"