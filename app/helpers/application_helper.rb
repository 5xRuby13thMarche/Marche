module ApplicationHelper
  include Pagy::Frontend

  def translate_payment_status(payment_status)
    translations = {
    "pending" => "未付款",
    "paid" => "已付款"
    }
    translations[payment_status]
  end

  def translate_shipping_status(shipping_status)
    translations = {
    "pending" => "未出貨",
    "shipped" => "已出貨",
    "not_shipped" => "未出貨"
    }
    translations[shipping_status]
  end
end
