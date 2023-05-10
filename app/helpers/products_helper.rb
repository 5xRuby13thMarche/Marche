module ProductsHelper
  def format_date(date)
    date.strftime('%Y/%-m/%-d')
  end
  def format_date_with_time(date)
    date.strftime('%Y/%-m/%-d %-H:%-M:%-S')
  end
  def parent_categories
    Category.where(parent_id: nil).pluck(:id, :content) 
  end
  def convert_category_name(name)
    name.gsub('/','_')
  end
  def get_user_cart_products_num
    current_user&.cart&.cart_products&.count
  end
  def image(product, size: [250, 250])
    if product && product.images.present?
      product.images.each do |i|
        image_tag i.representation(resize_to_limit: [100, 100])
      end
    else
      image_tag 'https://cdn.iconscout.com/icon/free/png-512/free-user-1851010-1568997.png?f=avif&w=256', size: "#{size[0]}x#{size[1]}"
    end
  end
end
