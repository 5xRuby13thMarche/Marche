class CommentsController < ApplicationController
  before_action :set_product, only: [:create]
  before_action :set_product_comment, only: [:edit, :update, :destroy]
  
  def create
    @product_comment = ProductComment.new(params_comment)
    @product_comment.user_id = current_user.id
    @product_comment.product_id = params[:product_id]

    if @product_comment.save
      update_product_average_rating(@product_comment.product)
      # redirect_to product_path(params[:product_id]), notice: "新增留言成功!"
    else
      @product_comments = ProductComment.includes(:user).order(created_at: :desc)
      redirect_to product_path(params[:product_id]), alert: "留言不能為空!"
    end
  end

  def edit

  end

  def update
    if @product_comment.update(params_comment)
      update_product_average_rating(@product_comment.product)
      # redirect_to product_path(@product_comment.product_id), notice: 'edit comment successfully!'
    else
      flash[:alert] = "fail editing comment."
      render :edit
    end
  end

  def destroy
    @product_comment.destroy
    update_product_average_rating(@product_comment.product)
    # redirect_to product_path(@product_comment.product_id), notice: 'delete comment successfully!'
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

  def update_product_average_rating(product)
    average = product.product_comments.where(rating: [1,2,3,4,5]).average(:rating)
    product.average_rating = average.nil? ? 0 : average.round
    product.save
  end
end
