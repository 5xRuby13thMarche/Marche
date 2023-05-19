module ShopsHelper
  def logo(shop, size: [250, 250])
    if shop && shop.images.present?
      image_tag shop.images[0].representation(resize_to_limit: [400, 400]).processed, data: { user__avatar_target: "initialPic" }
    else
      image_tag "user.png", size: "#{size[0]}x#{size[1]}", data: { user__avatar_target: "initialPic" }
    end
  end
end