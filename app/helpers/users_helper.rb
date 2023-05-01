module UsersHelper
  def avatar(user, size: [250, 250])
    if user && user.avatar.present?
      image_tag user.avatar.variant(resize_to_fill: size).processed
    else
      svg_tag = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="fill-gray-200 " id="person" width="' + size[0].to_s + '" height="' + size[1].to_s + '"><g data-name="Layer 2"><path d="M12 11a4 4 0 1 0-4-4 4 4 0 0 0 4 4zm6 10a1 1 0 0 0 1-1 7 7 0 0 0-14 0 1 1 0 0 0 1 1z" data-name="person"></path></g></svg>'
      # display the SVG icon as intended, rather than rendering it as plain text
      svg_tag.html_safe
    end
  end
end