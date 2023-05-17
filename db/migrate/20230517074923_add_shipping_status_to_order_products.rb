class AddShippingStatusToOrderProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :order_products, :shipping_status, :string, default: "not_shipped"
  end
end
