class CartProduct < ApplicationRecord
  belongs_to :cart, optional: true
  belongs_to :sale_info, optional: true

end
