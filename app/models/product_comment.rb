class ProductComment < ApplicationRecord
  validates :content, :rating, presence: true
  enum stars: {star_0: 0, star_1: 1, star_2: 2, star_3: 3, star_4: 4, star_5: 5}
  belongs_to :user, optional: true
  belongs_to :product, optional: true
end
