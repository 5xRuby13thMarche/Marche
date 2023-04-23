class ChangeColumnDefaultToCartProducts < ActiveRecord::Migration[6.1]
  def change
    change_column_default :cart_products, :quantity, 0
  end
end
