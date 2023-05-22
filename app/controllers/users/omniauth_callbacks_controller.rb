class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # See https://github.com/omniauth/omniauth/wiki/FAQ#rails-session-is-clobbered-after-callback-on-developer-strategy

  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      if @user.cart.present? && session[:_cart_].present?
        # session的購物車商品轉給舊使用者
        cart = Cart.find(session[:_cart_])
        @user.cart.transfer_cart_products(cart.cart_products)
        cart.delete()
        session.delete(:_cart_)
        @user.save
        redirect_to carts_path
      elsif @user.cart.nil? && session[:_cart_].present?
        # session的購物車指向新使用者
        cart = Cart.find(session[:_cart_])
        cart.update(user_id: @user.id)
        session.delete(:_cart_)
        redirect_to carts_path
      else
        # 生成購物車給新使用者
        @user.build_cart()
        @user.save
        redirect_to root_path
      end
      # sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      sign_in @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      session["devise.google_data"] = request.env["omniauth.auth"].except(:extra) # Removing extra as it can overflow some session stores
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end

end