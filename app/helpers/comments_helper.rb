module CommentsHelper
  def set_comment_style(is_user_comment)
    common_style = "p-2 m-1 mb-2 border rounded border-b-slate-500"
    special_style = is_user_comment ? "relative bg-orange-100" : "bg-neutral-100"
    return "#{common_style} #{special_style}"
  end
end
