class Admin::WordsController < Admin::BaseController

  def index
    @words = Word.order('id desc').first(100)
  end

  def edit
    @word = Word.find(params[:id])
  end

  def update
    @word = Word.find(params[:id])
    @word.update(word_params) ? redirect_to([:admin, @word])  : render('edit')
  end

  def create
    @word = Word.find(params[:word_id])

    respond_to do |format|
      if @word.save
        format.js
      else
        format.html { redirect_to :back, notice: @word.errors }
      end
    end
  end

  def destroy
    @word = Word.find params[:id]
    @word.destroy

    redirect_to admin_words_path
  end

  def show
    @word = Word.find params[:id]
  end



  private

  def word_params
    params.require(:word).permit(:simplified, :traditional, :pinyin)
  end
end
