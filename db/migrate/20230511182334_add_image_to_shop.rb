class AddImageToShop < ActiveRecord::Migration[6.1]
  def change
    add_column :shops, :image, :string
  end
end
