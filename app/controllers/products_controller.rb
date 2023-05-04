class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  def index
    @products = Product.order(created_at: :desc)
  end

  def show
    # comment
    @product_comment = ProductComment.new
    if(params[:star].present?)
      @product_comments = @product.product_comments.where(rating: params[:star].to_i).includes(:user).order(created_at: :desc)

      p '-'*50
      p "Have Star!"
      p '-'*50
    else
      @product_comments = @product.product_comments.includes(:user).order(created_at: :desc)
      p '-'*50
      p "Don't Have Star!"
      p '-'*50
    end
    @pagy, @comment_records = pagy(@product_comments, items: 9, fragment: '#comment-list')
    @average_rating = @product.product_comments.average(:rating).round
    # Sale info
    @sale_info = SaleInfo.find_by(product_id: @product.id)
    @cart_product = CartProduct.new


    p '-'*50
    p "HERE IS PARAMS!!!!!!!!"
    p params
    p params[:star].class
    p '-'*50

  end

  def new
    @product = Product.new
    @product.sale_infos.build

  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to root_path, notice: "新增商品成功" 
    else
      render :new, status: :unprocessable_entity 
    end

  end

  def update
    if @product.update(product_params)
      redirect_to root_path, notice: "商品資訊已更新" 
    else
      render :edit, status: :unprocessable_entity 
    end
  end

  def destroy
    @product.destroy
    redirect_to root_path, notice: "已成功刪除商品" 
  end

  def search
    @products = Product.where("name LIKE ?", "%#{params[:keyword]}%")
  end

  private
  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :category_id, sale_infos_attributes: [:storage, :price, :spec])
  end
end

