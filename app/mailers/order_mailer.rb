class OrderMailer < ApplicationMailer
  def notify_delivery(order_product)
    @user = order_product.order.user
    mail to:@user.email, subject:"Marche 出貨通知"
  end
end
