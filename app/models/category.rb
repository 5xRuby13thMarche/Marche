class Category < ApplicationRecord
  belongs_to :parent, class_name: "Category"
  has_many :children, class_name: "Category", foreign_key: "parent_id"
  has_many :child_products, through: :children, source: :products
  has_many :products
end
