class Product < ApplicationRecord
  validates :name, :price, :category, presence: true

end
