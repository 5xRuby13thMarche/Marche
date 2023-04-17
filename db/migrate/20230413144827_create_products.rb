class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :inventory
      t.string :category
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
