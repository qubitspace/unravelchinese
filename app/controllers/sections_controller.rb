class SectionsController < ApplicationController

  def destroy
    # make ajax
    @section = Section.includes(:article, :resource).find(params[:id])
    article = @section.article
    @section.destroy
    respond_to do |format|
      format.html { redirect_to article_manage_path(article), notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

end