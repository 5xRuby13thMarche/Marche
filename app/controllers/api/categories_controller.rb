class Api::CategoriesController < ApplicationController
  def show
    main_category = Category.find(params[:id])
    sub_categries = main_category.children
    render json: sub_categries&.map { |category| {value: category.id, content: category.content} }
  end
end
