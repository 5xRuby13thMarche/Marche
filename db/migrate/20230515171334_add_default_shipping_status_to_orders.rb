class AddDefaultShippingStatusToOrders < ActiveRecord::Migration[6.1]
  def change
    change_column :orders, :shipping_status, :string, default: "pending"
    change_column :orders, :payment_status, :string, default: "pending"
  end
end
