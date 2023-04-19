class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :tracking_number
      t.string :payment_method
      t.string :payment_status
      t.string :shipping_address
      t.string :shipping_status
      t.decimal :total_price, default: 0
      t.text :note
      t.string :receiver
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
