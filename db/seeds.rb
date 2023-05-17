require 'json'

# 產生分類
p "開始產生商品分類..."
path = Rails.root.join("db","category_data.json")
data = JSON.parse(File.read(path))
spec1_category = Category.new
data.each do |d|
  if spec1_category.content != d["c1"]
    spec1_category = Category.new(content: d["c1"])
    spec1_category.save
  end
  Category.create(content: d["c2"], parent_id: spec1_category.id)
end
p "商品分類產生完成！"
p "創建Demo帳號"
user_email = ["aaa@aaa.aaa", "bbb@bbb.bbb", "ccc@ccc.ccc", "ddd@ddd.ddd"]
user_email.each do |e|
  user = User.new(email: e, password: "111111")
  user.build_shop()
  user.save
end
p "Demo帳號創建完成"

