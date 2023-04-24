class CreateProductComments < ActiveRecord::Migration[6.1]
  def change
    create_table :product_comments do |t|
      t.text :content
      t.references :user, foreign_key: true
      t.references :product, foreign_key: true
      t.integer :rating, default: 0

      t.timestamps
    end
  end
end
