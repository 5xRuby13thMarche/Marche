class AddImageToProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :images, :string
  end
end
