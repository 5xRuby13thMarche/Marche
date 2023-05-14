class AddAverageRatingColumnToProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :average_rating, :integer
  end
end
