class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_q_ransack, only: [:index, :show, :search, :category]
  
  def index
    @products = Product.includes(:sale_infos).order(created_at: :desc)
    @pagy, @product_records = pagy(@products, items: 24)
    @ransack_q = Product.ransack(params[:q])
    @categories = Category.where(parent_id: nil)
  end

  def show
    # comment
    @product_comment = ProductComment.new
    if(params[:star].present?)
      @product_comments = @product.product_comments.where(rating: params[:star].to_i).includes(:user).order(created_at: :desc)
    else
      @product_comments = @product.product_comments.includes(:user).order(created_at: :desc)
    end
    @pagy, @comment_records = pagy(@product_comments, items: 9, fragment: '#comment-list')
    average = @product.product_comments.where(rating: [1,2,3,4,5]).average(:rating)
    @average_rating = average.nil? ? "？": average.round
    
    # Sale info
    #判斷是否有選擇規格沒有則隨機展示一項saleinfo
    if(params[:saleinfo].present?)
      @sale_info = SaleInfo.find_by(id: params[:saleinfo].to_i)
    else
      @sale_info = SaleInfo.find_by(product_id: @product.id)
    end
    #印出所有規格
    @spec_all = @product.sale_infos
    @cart_product = CartProduct.new
  end

  def new
    @product = Product.new
    @product.sale_infos.build
    @product.build_property

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
    @products = @ransack_q.result(distinct: true)
  end

  def category
    @parent_category = Category.find(params[:id])
    @categories = @parent_category.children.includes(:products)
    @products = get_products_by_categories(@categories)
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def set_q_ransack
    @ransack_q = Product.ransack(params[:q])
  end

  def product_params
    params.require(:product).permit(:name, :description, :category_id, sale_infos_attributes: [:storage, :price, :spec], property_attributes: [:brand, :size, :weight, :quantity_per_set])
  end

  def get_products_by_categories(categories)
    products = []
    categories.each do |c|
      products.concat(c.products)
    end
    return products
  end

end

