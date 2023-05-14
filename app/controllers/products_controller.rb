class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_q_ransack, only: [:index, :show, :search]
  before_action :set_user_cart_product_num, only: [:index, :show, :search]
  layout 'backend', only: [:create]
  
  # 買家-------------------------------
  def index
    @products = Product.includes(images_attachments: :blob).includes(:sale_infos)
    @pagy, @product_records = pagy(@products, items: 24)
    @categories = Category.where(parent_id: nil)
    @new_products = Product.includes(images_attachments: :blob).includes(:sale_infos).order(created_at: :desc).limit(12)
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

    #category
    @subcategory = @product.category
    @main_category = @subcategory.parent

    #property
    @property = @product.property
  end

  def search
    @search_keyword = params[:q][:name_cont]
    @recent_order = (params[:order].present?) ? params[:order] : nil
    @products = @ransack_q.result(distinct: true)
    # 搜尋不到商品的話 > 推薦最新商品
    if @products.count == 0 
      @products = Product.includes(images_attachments: :blob).includes(:sale_infos).order(created_at: :desc).limit(12)
      @no_search_result = true
    else
      @products = @products.includes(images_attachments: :blob).includes(:sale_infos)
      @no_search_result = false
    end

    # 最新 or 價格排序商品
    case @recent_order
    when 'new'
      @productcs = @products.order(created_at: :desc)
    when 'price_asc'
      @products = @products.left_outer_joins(:sale_infos)
                    .select('products.*, MAX(sale_infos.price) as max_price')
                    .group('products.id')
                    .order('max_price ASC')
    when  'price_desc'
      @products = @products.left_outer_joins(:sale_infos)
                    .select('products.*, MAX(sale_infos.price) as max_price')
                    .group('products.id')
                    .order('max_price DESC')
    end
  end

  # 賣家-------------------------------
  def new
    @shop = current_user.shop
    @product = Product.new
    @product.sale_infos.build
    @product.build_property

    render layout: 'backend'
  end
  
  def create
    @product = Product.new(product_params)
    @product.shop_id = current_user.shop.id
    @shop = current_user.shop
    if @product.save
      redirect_to root_path, notice: "新增商品成功" 
    else
      render :new, status: :unprocessable_entity 
    end
  end

  def edit
    @shop = current_user.shop
    render layout: 'backend'
  end

  def update
    if @product.update(product_params)
      redirect_to shops_path, notice: "商品資訊已更新" 
    else
      render :edit, status: :unprocessable_entity 
    end
    render layout: 'backend'
  end

  def destroy
    @product.destroy
    redirect_to root_path, notice: "已成功刪除商品" 
  end

  # 顯示賣家自己上架的所有商品
  def shop_products 
    @shop = current_user.shop
    @shop_products = @shop.order_products.includes(product: :sale_infos).where(product: { shop_id: @shop.id }).order(created_at: :desc)
    render layout: 'backend'
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def set_q_ransack
    @ransack_q = Product.ransack(params[:q])
  end

  def set_user_cart_product_num
    if user_signed_in?
      @user_cart_product_num = current_user.cart.cart_products.count
    end
  end

  def product_params
    params.require(:product).permit(:name, :description, :category_id, :images, sale_infos_attributes: [:storage, :price, :spec], property_attributes: [:brand, :size, :weight, :quantity_per_set])
  end
end
