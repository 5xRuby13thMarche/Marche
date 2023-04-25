class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  def index
    @products = Product.order(created_at: :desc)
  end

  def show
    @product_comment = ProductComment.new
    @product_comments = @product.product_comments.includes(:user).order(created_at: :desc)
    @pagy, @records = pagy(@product_comments, items: 6, fragment: '#comment-list')
    @sale_info = SaleInfo.find_by(product_id: @product.id)
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
      @product
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
      params.require(:product).permit(:name, :description, sale_infos_attributes: [:id, :price], category_ids: [])
    end
end

