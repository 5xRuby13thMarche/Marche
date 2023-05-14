class UsersController < ApplicationController
<<<<<<< HEAD
  before_action :authenticate_user!

  def show_like
    @products = current_user.liked_products
  end
=======
  # before_action :authenticate_user!

  # def show_orders
  #   @orders = current_user.orders
  # end
>>>>>>> 2ffd8f4 (refactor: pull branch)

  
end
