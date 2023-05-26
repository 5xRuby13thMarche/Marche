module ProductsHelper
  def format_date(date)
    date.strftime('%Y/%-m/%-d')
  end

  def format_date_with_time(date)
    date.strftime('%Y/%-m/%-d %-H:%-M:%-S')
  end

  def parent_categories
    Category.where(parent: nil).pluck(:id, :content) 
  end

  def convert_category_name(name)
    name.gsub('/','_')
  end

  def product_image(product, size: [250, 250])
    if product && product.images.present?
      image_tag product.images[0].representation(resize_to_limit: [400, 400]), class:"mx-auto w-full rounded-t-sm aspect-1 object-cover"
    else
      image_tag "user.png", size: "#{size[0]}x#{size[1]}", class:"mx-auto w-full rounded-t-sm aspect-1 object-cover"
    end
  end

  # 給商品頁面的大小圖使用
  def show_image(image, size: [250, 250])
    if  image.present?
      image_tag image.representation(resize_to_limit: [400, 400]), class:"mx-auto block h-full w-full rounded-t-sm aspect-1 object-cover"
    else
      image_tag "user.png", size: "#{size[0]}x#{size[1]}", class:"mx-auto block h-full w-full rounded-t-sm aspect-1 object-cover"
    end
  end

  # 商品卡片價格區間
  def currency_price_range(price_range)
    price_range.map!{|e| number_to_currency(e, precision: 0)}
    return (price_range[0] == price_range[1]) ? price_range[0] : "#{price_range[0]} ~ #{price_range[1]}"
  end
  
  # 分類商品顯示頁面用----------------------------------
  
  def get_order_bread_name(recent_order)
    case recent_order
    when "new"
      return "最新"
    when "price_asc"
      return "價格 低到高"
    when "price_desc"
      return "價格高到低"
    end
  end

  def default_quantity(sale_info)
    if sale_info.storage == 0
      return 0
    else
      return 1
    end
  end
end
