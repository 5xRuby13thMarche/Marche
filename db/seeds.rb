# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

# 建立五個主分類
5.times do
  main_category = Category.create(content: Faker::Commerce.department)

  # 在每個主分類下建立五個子分類
  5.times do
    Category.create(content: Faker::Commerce.department, parent_id: main_category.id)
  end
end

puts "分類建立完成!"

10.times do |n|
  product = Product.create(name: Faker::Commerce.product_name, description: Faker::Lorem.paragraph, category_id: Category.pluck(:id).sample)
  product.sale_infos << SaleInfo.new(spec: Faker::Commerce.material, price: Faker::Number.between(from: 10, to: 1000), storage: Faker::Number.between(from: 0, to: 40))
  product.sale_infos << SaleInfo.new(spec: Faker::Commerce.material, price: Faker::Number.between(from: 10, to: 1000), storage: Faker::Number.between(from: 0, to: 40))
end

puts "您的商品已生成！可以開始購買了"


