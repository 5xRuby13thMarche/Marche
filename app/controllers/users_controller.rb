class UsersController < ApplicationController
  before_action :authenticate_user!

  def show_like
    @products = current_user.liked_products
  end
end
