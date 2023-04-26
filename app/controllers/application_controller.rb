class ApplicationController < ActionController::Base
  helper_method :get_star_number
  
  def get_star_number(star_number)
    ProductComment.stars[star_number]
  end
end
