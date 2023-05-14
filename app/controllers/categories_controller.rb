class CategoriesController < ApplicationController
  before_action :set_q_ransack, only: [:show]
  before_action :set_user_cart_product_num, only: [:show]
  def show
    @parent_category = Category.find(params[:id])
    @child_categories = @parent_category.children
    @recent_child  = (params[:sub_category].present?) ? params[:sub_category] : nil
    @recent_order = (params[:order].present?) ? params[:order] : nil

    # 是否依照子分類搜尋商品
    if @recent_child.present?
      @products = Category.find(params[:sub_category]).products
    else
      @products = @parent_category.child_products.includes(images_attachments: :blob).includes(:sale_infos)
    end
    @products = @products.includes(images_attachments: :blob).includes(:sale_infos)
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

  private

  def set_q_ransack
    @ransack_q = Product.ransack(params[:q])
  end

  def set_user_cart_product_num
    if user_signed_in?
      @user_cart_product_num = current_user.cart.cart_products.count
    end
  end
end
