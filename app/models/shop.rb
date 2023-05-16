class Shop < ApplicationRecord
  belongs_to :user
  has_many :products
  has_many :order_products, through: :products
  has_one_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
end
