namespace :sample_data do
  desc '為每個商品產生泛用留言'
  task create_fake_comment_data: :environment do

    p "清除現有的商品留言"
    ProductComment.delete_all
    p "開始產生商品留言..."
    path = Rails.root.join("db", "comment_data.json")
    data = JSON.parse(File.read(path))
    user = User.find_by(email: "aaa@aaa.aaa")
    Product.all.each do |product|
      srand(product.name.hash)
      data.sample(rand(10..20)).each do |c|
        product.product_comments.create(content: c["content"], rating: c["rating"], user_id: user.id)
      end
    end
    p "商品留言產生完成！"
  end
end
