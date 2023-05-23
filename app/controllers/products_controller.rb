class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_q_ransack, only: [:index, :show, :search]
  before_action :set_cart_num, only: [:index, :show, :search]
  before_action :shop_params, only: [:new, :create, :edit, :update, :destroy]
  before_action :record_recent_path, only: [:search, :index]
  layout 'shop', only: [:new, :create, :update, :destory, :edit]
  
  def index
    @products = Product.includes(images_attachments: :blob).includes(:sale_infos)
    @pagy, @product_records = pagy(@products, items: 24)
    @root_categories = Category.where(parent_id: nil)
    @new_products = Product.includes(images_attachments: :blob).includes(:sale_infos).order(created_at: :desc).limit(12)
    @hot_products = Product.includes(images_attachments: :blob).includes(:sale_infos).order(average_rating: :desc).limit(12)
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
    @average_rating = @product.average_rating == 0 ? "?": @product.average_rating
    @contain_orders = (user_signed_in?) && Order.contain_user_orders?(@product.orders, current_user)
    @contain_comments = (user_signed_in? && ProductComment.contain_user_comments?(@product_comments, current_user))

    # Sale info
    #判斷是否有選擇規格沒有則隨機展示一項saleinfo
    if(params[:saleinfo].present?)
      @sale_info = SaleInfo.find_by(id: params[:saleinfo].to_i)
    else
      @sale_info = SaleInfo.find_by(product: @product)
    end
    #印出所有規格
    @spec_all = @product.sale_infos
    @cart_product = CartProduct.new

    #category
    @subcategory = @product.category
    @main_category = @subcategory.parent

    # 上一頁的路徑
    p '-'*40
    p "before"
    p session[:_prev_path_]
    p session[:_prev_path_].class
    p '-'*40

    @prev_path = session[:_prev_path_]
    session.delete(:_prev_path_)
    p '-'*40
    p "after"
    p session[:_prev_path_]
    p session[:_prev_path_].class
    p '-'*40
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
      @products = Product.products_max_price(@products, "ASC")
    when  'price_desc'
      @products = Product.products_max_price(@products, "DESC")
    end
  end

  def new
    @product = Product.new
    @product.sale_infos.build
    @product.build_property
  end
  
  def create
    @product = Product.new(product_params)
    @product.shop_id = current_user.shop.id
    @product.average_rating = 0
    if @product.save
      redirect_to products_shops_path, notice: "新增商品成功" 
    else
      render :new, status: :unprocessable_entity 
    end
  end

  def edit
    @subcategory = @product.category
    @main_category = @subcategory.parent
  end

  def update
    if @product.update(product_params)
      redirect_to products_shops_path, notice: "商品資訊已更新" 
    else
      render :edit, status: :unprocessable_entity 
    end
  end

  def destroy
    @product.destroy
    redirect_to products_shops_path, notice: "已成功刪除商品" 
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def shop_params
    @shop = current_user.shop
  end

  def product_params
    params.require(:product).permit(:name, 
                                    :description, 
                                    :category_id, 
                                    :images, 
                                    sale_infos_attributes: [:storage, :price, :spec], 
                                    property_attributes: [:brand, :size, :weight, :quantity_per_set]
                                  )
  end
end
