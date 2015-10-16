class CategoriesController < ApplicationController
  include Concerns::Manageable

  def index
    authorize Category
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    authorize @category
  end

  def manage
    @category = Category.find(params[:id])
    authorize @category
  end

end
