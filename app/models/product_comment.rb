class ProductComment < ApplicationRecord
  after_save :update_product_average_rating
  after_destroy :update_product_average_rating

  validates :content, :rating, presence: true
  belongs_to :user
  belongs_to :product

  def update_product_average_rating()
    average = product.product_comments.where.not(rating: 0).average(:rating) || 0
    self.product.update(average_rating: average.round)
  end

  def self.contain_user_comments?(product_comments, user)
    return product_comments.any? { |comment| user.product_comments.include?(comment) }
  end
end
