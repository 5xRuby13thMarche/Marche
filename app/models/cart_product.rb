class CartProduct < ApplicationRecord
  belongs_to :cart, optional: true
  belongs_to :sale_info, optional: true
  has_many :products, through: :sale_infos
end
