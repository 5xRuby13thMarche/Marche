class CreateProductLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :product_likes do |t|
      t.references :user, foreign_key: true
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
