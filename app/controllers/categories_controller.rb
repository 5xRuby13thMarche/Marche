class CategoriesController < ApplicationController
  before_action :set_q_ransack, only: [:show]
  before_action :set_cart_num, only: [:show]
  def show
    @parent_category = Category.find(params[:id])
    @child_categories = @parent_category.children
    @recent_child  = (params[:sub_category].present?) ? params[:sub_category] : nil
    @recent_order = (params[:order].present?) ? params[:order] : nil
    @child_content = Category.find(@recent_child).content unless @recent_child.nil?
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
      @products = Product.products_max_price(@products, "ASC")
    when  'price_desc'
      @products = Product.products_max_price(@products, "DESC")
    end
  end
end
