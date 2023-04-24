class CommentsController < ApplicationController
  before_action :set_product, only: [:create]

  def create
    @product_comment = ProductComment.new(params_comment)
    @product_comment.user_id = current_user.id
    @product_comment.product_id = params[:product_id]

    if @product_comment.save
      redirect_to product_path(params[:product_id]), notice: "新增留言成功!"
    else
      @product_comments = ProductComment.order(created_at: :desc)
      flash[:alert] = "留言不能為空"
      render 'products/show'
    end

  end

  private

  def params_comment
    params[:product_comment].permit(:content, :rating)
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

end
