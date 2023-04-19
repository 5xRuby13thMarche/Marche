namespace :sample_data do
  desc 'Create 10 fake products with 2 sale_infos'
  task create_10_products_with_2_sale_infos: :environment do
    10.times do |n|
      product = Product.create(name: "Product #{n + 1}", description: Faker::Quote.famous_last_words)
      product.sale_infos << SaleInfo.new(spec: "規格xxx", price: Faker::Number.between(from: 10, to: 1000), storage: Faker::Number.between(from: 0, to: 40))
      product.sale_infos << SaleInfo.new(spec: "規格xxx", price: Faker::Number.between(from: 10, to: 1000), storage: Faker::Number.between(from: 0, to: 40))
    end
  end
end