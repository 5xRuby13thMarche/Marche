module ApplicationHelper
  include Pagy::Frontend

  def shipped(shipping_status)
    if shipping_status == "not_shipped"
      return "未出貨"
    else
      return "已出貨"
    end
  end
end
