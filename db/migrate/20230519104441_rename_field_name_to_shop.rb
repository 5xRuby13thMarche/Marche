class RenameFieldNameToShop < ActiveRecord::Migration[6.1]
  def change
    rename_column :shops, :image, :logo
  end
end
