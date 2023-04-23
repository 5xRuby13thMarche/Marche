class CategoryProduct < ApplicationRecord
  belongs_to :product, optional: true
  belongs_to :category, optional: true
end
