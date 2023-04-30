class CategoriesController < ApplicationController

  def index
    @categories = Category.find_by(parent_id: :id)
  end

end
