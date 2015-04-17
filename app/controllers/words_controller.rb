class WordsController < ApplicationController

  def index
    @results = Word.none
  end

  def search
    @term = params[:term]
    @results = Word.search(@term)
    respond_to do |format|
      format.js
    end
  end

  def definition_search
    @term = params[:term]
    @results = Word.search(@term)
    respond_to do |format|
      format.js
    end
  end

  def show
    @word = Word.find(params[:id])
  end

end
