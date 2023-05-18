module UsersHelper
  def avatar(user, size: [250, 250])
    if user && user.avatar.present?
      image_tag user.avatar.variant(resize_to_fill: size).processed, data: { user__avatar_target: "initialPic" }
    else
      image_tag "user.png", size: "#{size[0]}x#{size[1]}"
    end
  end
end