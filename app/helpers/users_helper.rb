module UsersHelper
  def avatar(user, size: [250, 250])
    image_tag user.avatar.variant(resize_to_fill: size).processed if user.avatar.present?
  end
end