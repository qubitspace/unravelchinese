class CategoriesController < ApplicationController
  include Concerns::Manageable

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
  end

  def manage
    @category = Category.find(params[:id])
  end

end
