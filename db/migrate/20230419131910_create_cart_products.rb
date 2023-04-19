class CreateCartProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :cart_products do |t|
      t.integer :quantity, default: 0
      t.references :cart, foreign_key: true
      t.references :sale_info, foreign_key: true

      t.timestamps
    end
  end
end
