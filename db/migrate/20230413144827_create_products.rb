class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.float :price
      t.integer :inventory
      t.string :category
      t.string :status

      t.timestamps
    end
  end
end
