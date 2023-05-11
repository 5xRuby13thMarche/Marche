module Api::CartsHelper
  def show_image(product, size: [250, 250])
    if product.images.present?
        image_tag product.images[0].representation(resize_to_limit: [400, 400]), class:"mx-auto w-full rounded-t-sm aspect-1 object-cover"
    else
      image_tag 'https://cdn.iconscout.com/icon/free/png-512/free-user-1851010-1568997.png?f=avif&w=256', size: "#{size[0]}x#{size[1]}"
    end
  end
end
