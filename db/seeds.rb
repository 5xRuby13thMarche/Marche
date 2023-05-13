require 'json'

# 產生分類
p "開始產生商品分類..."
path = Rails.root.join("db","category_data.json")
data = JSON.parse(File.read(path))
spec1_category = Category.new
data.each do |d|
  if spec1_category.content != d["c1"]
    spec1_category = Category.create(content: d["c1"])
  end
  Category.create(content: d["c2"], parent_id: spec1_category.id)
end
p "商品分類產生完成！"

