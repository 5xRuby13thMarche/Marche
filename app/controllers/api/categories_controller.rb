class Api::CategoriesController < ApplicationController
  def assign
    mainCategory = Category.find(params[:main_id])
    subcategries = mainCategory.children
    render json: subcategries&.map { |s| {value: s.id, content: s.content} }
  end
end
