class Api::CategoriesController < ApplicationController
  def show
    mainCategory = Category.find(params[:id])
    subcategries = mainCategory.children
    render json: subcategries&.map { |s| {value: s.id, content: s.content} }
  end
end
