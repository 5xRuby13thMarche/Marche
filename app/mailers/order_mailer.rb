class OrderMailer < ApplicationMailer
  def notify_delivery(order_product)
    @user = order_product.order.user
    @order_product = order_product
    mail to:@user.email, subject:"Marche 出貨通知"
  end
end
