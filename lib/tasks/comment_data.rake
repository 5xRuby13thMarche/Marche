namespace :sample_data do
  desc '為每個商品產生泛用留言'
  task create_fake_comment_data: :environment do

    def generate_fake_user
      fake_user = []
      10.times do
        user_name = Faker::Internet.username(specifier: 5..8)
        user_name[2,3] = 'xxx'
        user = User.new(email: Faker::Internet.email, password: Faker::Internet.password, name: user_name)
        user.save
        fake_user << user
      end
      return fake_user
    end

    p "清除現有的商品留言"
    ProductComment.delete_all
    p "開始產生商品留言..."
    path = Rails.root.join("db", "comment_data.json")
    data = JSON.parse(File.read(path))
    fake_users = generate_fake_user()
    Product.all.each do |p|
      srand(p.name.hash)
      data.sample(rand(10..20)).each do |c|
        p.product_comments.create(content: c["content"], rating: c["rating"], user_id: fake_users[rand(0..9)].id)
      end
    end
    p "商品留言產生完成！"
  end
end
