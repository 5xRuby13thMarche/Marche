namespace :sample_data do
  desc 'Create 10 fake products with 2 sale_infos'
  task create_10_products_with_2_sale_infos: :environment do
    10.times do |n|
      product = Product.create(name: Faker::Commerce.product_name, description: Faker::Lorem.paragraph)
      product.sale_infos << SaleInfo.new(spec: Faker::Commerce.material, price: Faker::Number.between(from: 10, to: 1000), storage: Faker::Number.between(from: 0, to: 40))
      product.sale_infos << SaleInfo.new(spec: Faker::Commerce.material, price: Faker::Number.between(from: 10, to: 1000), storage: Faker::Number.between(from: 0, to: 40))
    end
  end
end
