namespace :update_product do
  desc '刷新商品平均星星數'
  task update_product_average_rating: :environment do
    p "開始更新每件商品的平均星星數..."
    Product.all.each do |product|
      average = product.product_comments.where(rating: [1,2,3,4,5]).average(:rating)
      product.average_rating = average.nil? ? 0 : average
      product.save
    end
    p "更新完成"
  end
end
