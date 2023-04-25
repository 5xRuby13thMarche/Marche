class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  after_create :build_cart

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name   # assuming the user model has a name
      user.avatar = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end


  has_one :shop
  has_one :cart
  has_many :orders

  has_many :product_likes, dependent: :destroy
  has_many :liked_products, through: :product_likes, source: :product

  has_many :product_comments, dependent: :destroy

  def like_product?(product)
    self.liked_products.include?(product)
  end 
  
  private

  def build_cart
    self.create_cart
  end
end
