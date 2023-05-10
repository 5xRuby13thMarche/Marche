class Product < ApplicationRecord
  validates :name, :category_id, presence: true

  belongs_to :shop, optional: true
  belongs_to :category, optional: true
  has_many :order_products
  has_many :orders, through: :order_products
  has_many :product_likes, dependent: :destroy
  has_many :product_likers, through: :product_likes, source: :user
  has_many :product_comments, dependent: :destroy
  has_many :sale_infos, dependent: :destroy
  has_one :property, dependent: :destroy
  
  accepts_nested_attributes_for :sale_infos, :property

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
end
