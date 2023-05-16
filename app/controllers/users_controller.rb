class UsersController < ApplicationController
  before_action :authenticate_user!

  def show_like
    @products = current_user.liked_products.includes(images_attachments: :blob).includes(:sale_infos)
    @pagy, @products = pagy(@products, items: 18)
  end
end
