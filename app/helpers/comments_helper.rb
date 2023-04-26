module CommentsHelper
  def set_comment_style(is_user_comment)
    is_user_comment ? "relative p-2 m-1 mb-2 bg-orange-100 border rounded border-b-slate-500" : "p-2 m-1 mb-2 border rounded bg-neutral-100 border-b-slate-500"
  end
end
