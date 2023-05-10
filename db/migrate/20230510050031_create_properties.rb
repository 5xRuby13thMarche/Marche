class CreateProperties < ActiveRecord::Migration[6.1]
  def change
    create_table :properties do |t|
      t.string :brand
      t.string :size
      t.string :weight
      t.integer :quantity_per_set
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
