class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_q_ransack, only: [:index, :show, :search, :category]
  before_action :set_user_cart_product_num, only: [:index, :show, :search, :category]
  
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

  def new
    @product = Product.new
    @product.sale_infos.build
    @product.build_property

  end
  
  def create
    @product = Product.new(product_params)
    @product.shop_id = current_user.shop.id
    if @product.save
      redirect_to root_path, notice: "新增商品成功" 
    else
      render :new, status: :unprocessable_entity 
    end
  end

  def edit
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
    @products = @products.includes(images_attachments: :blob).includes(:sale_infos)
    @recent_order = (params[:order].present?) ? params[:order] : nil

    # 最新 or 價格排序商品
    case @recent_order
    when 'new'
      @productcs = @products.order(created_at: :desc)
    when 'price_asc'
      @products = @products.joins(:sale_infos)
                                  .select("products.*, MAX(sale_infos.price) as max_price")
                                  .group("products.id")
                                  .order("max_price ASC")
    when  'price_desc'
      @products = @products.joins(:sale_infos)
                                  .select("products.*, MAX(sale_infos.price) as max_price")
                                  .group("products.id")
                                  .order("max_price DESC")
    else
      @products = @products.order(created_at: :asc)
    end
  end

  def category
    @parent_category = Category.find(params[:id])
    @child_categories = @parent_category.children
    @recent_child  = (params[:sub_category].present?) ? params[:sub_category] : nil
    @recent_order = (params[:order].present?) ? params[:order] : nil

    # 是否依照子分類搜尋商品
    if @recent_child.present?
      @products = Category.find(params[:sub_category]).products.includes(images_attachments: :blob).includes(:sale_infos)
    else
      @products = @parent_category.child_products.includes(images_attachments: :blob).includes(:sale_infos)
    end

    # 最新 or 價格排序商品
    case @recent_order
    when 'new'
      @productcs = @products.order(created_at: :desc)
    when 'price_asc'
      @products = @products.joins(:sale_infos)
                                  .select("products.*, MAX(sale_infos.price) as max_price")
                                  .group("products.id")
                                  .order("max_price ASC")
    when  'price_desc'
      @products = @products.joins(:sale_infos)
                                  .select("products.*, MAX(sale_infos.price) as max_price")
                                  .group("products.id")
                                  .order("max_price DESC")
    else
      @products = @products.order(created_at: :asc)
    end
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
