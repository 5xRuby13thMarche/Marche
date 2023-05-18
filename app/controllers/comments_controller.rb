class CommentsController < ApplicationController
  before_action :set_product, only: [:create]
  before_action :set_product_comment, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  def create
    contain_orders = Order.contain_user_orders?(@product.orders, current_user)
    contain_comments = ProductComment.contain_user_comments?(@product.product_comments, current_user)
    if contain_comments || !contain_orders
      redirect_to product_path(params[:product_id])
    else
      @product_comment = current_user.product_comments.build(params_comment)
      @product_comment.product_id = params[:product_id]

      unless @product_comment.save
        @product_comments = ProductComment.includes(:user).order(created_at: :desc)
        redirect_to product_path(params[:product_id]), alert: "留言內容不能為空!"
      end
    end
  end

  def edit
  end

  def update
    unless @product_comment.update(params_comment)
      flash[:alert] = "修改留言失敗"
      render :edit
    end
  end

  def destroy
    @product_comment.destroy
  end

  private

  def params_comment
    params[:product_comment].permit(:content, :rating)
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_product_comment
    @product_comment = ProductComment.find(params[:id])
  end

end
