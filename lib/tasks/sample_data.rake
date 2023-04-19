namespace :sample_data do
  desc 'Create sample products'
  task create_products: :environment do
    # 10.times do |n|
    #   Product.create(
    #     name: "Product #{n + 1}",
    #     description: "This is product #{n + 1}.",
    #     category: "category #{n + 1}",
    #     price: rand(1000..10000),
    #     inventory: rand(1..50)
    #   )
    # end
  end
end