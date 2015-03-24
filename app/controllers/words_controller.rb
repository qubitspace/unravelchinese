class WordsController < ApplicationController
  
  def index
    @results = Word.search(params[:term])
  end
  
  def show
    @word = Word.find(params[:id])
  end


end
