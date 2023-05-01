module UsersHelper
  def avatar(user, size: [250, 250])
    if user && user.avatar.present?
      image_tag user.avatar.variant(resize_to_fill: size).processed
    else
      image_tag 'https://cdn.iconscout.com/icon/free/png-512/free-user-1851010-1568997.png?f=avif&w=256', size: "#{size[0]}x#{size[1]}"
    end
  end
end