class Property < ApplicationRecord
  belongs_to :product, optional: true
end
