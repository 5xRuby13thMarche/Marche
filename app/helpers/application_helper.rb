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

  def current_page(url)
    if current_page?(url)
      classname = "mt-2 ml-12 py-1 text-sm text-sky-700 cursor-pointer hover:text-sky-700 hover:border-sky-600"
      return classname
    else
      classname = "mt-2 ml-12 py-1 text-sm text-gray-500 cursor-pointer hover:text-sky-700 hover:border-sky-600"
      return classname
    end
  end

end
