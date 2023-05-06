require 'json'

# method: 找到第二階層的分類
def find_sub_category(category1, category2)
  c1 = Category.find_by(content: category1, parent_id: nil)
  c2 = c1.children.find_by(content: category2)
end


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


# 產生產品假資料
p "開始產生商品..."
path = Rails.root.join("db","product_data.json")
data = JSON.parse(File.read(path))
product = Product.new
data.each do |d|
  if d["name"] != ""
    product = Product.new(name: d["name"],description: d["description"], category_id: find_sub_category(d["c1"], d["c2"]).id)
  end
  product.sale_infos.build(price: d["price"], storage: d["storage"], spec: d["spec"])
  product.save
end
p "商品產生完成！"