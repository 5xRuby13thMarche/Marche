namespace :sample_data do
  desc '為每個商品產生泛用留言'
  task create_fake_comment_data: :environment do

    p "清除現有的商品留言"
    ProductComment.delete_all
    p "開始產生商品留言..."
    path = Rails.root.join("db", "comment_data.json")
    data = JSON.parse(File.read(path))
    user_email = ('a'..'t').to_a.map{|e| "#{e * 3}@#{e * 3}.#{e * 3}"}
    users = user_email.map{|e| User.find_by(email: e)}
    Product.all.each do |product|
      srand(product.name.hash)
      rand_number = rand(10..20)
      rand_user = users.sample(rand_number)
      rand_data = data.sample(rand_number)
      rand_data.each.with_index do |c, i|
        product.product_comments.create(content: c["content"], rating: c["rating"], user_id: rand_user[i].id)
      end
    end
    p "商品留言產生完成！"
  end
end
