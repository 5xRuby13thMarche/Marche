class UsersController < ApplicationController
  before_action :authenticate_user!


  def show_like
    @products = current_user.liked_products.includes(images_attachments: :blob).includes(:sale_infos)
    @pagy, @products = pagy(@products, items: 18)
  end

  def profile
    @user = current_user
  end

  def user_update
    @user = current_user

    if @user.update(user_params)
      redirect_to user_update_path, notice: "資料更新成功！"
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :avatar)
  end

end
