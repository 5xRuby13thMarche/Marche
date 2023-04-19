class CreateSaleInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :sale_infos do |t|
      t.decimal :price, default: 0
      t.integer :storage, default: 0
      t.string :spec
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
