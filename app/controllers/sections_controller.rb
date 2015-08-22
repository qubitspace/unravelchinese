class SectionsController < ApplicationController

  def destroy
    @section = Section.includes(:article, :resource).find(params[:id])
    article = @section.article
    @section.destroy
    respond_to do |format|
      format.js {
        render js: concept("section/section_cell", @section, current_user: current_user).(:hide)
      }
    end
  end



  def create_image
    byebug

    @section = Section.find params[:section_id]
    @article = Section.article
    @form = Section::Form.new(Section.new)
    @form.article = @article
    if @form.validate(params[:section])
      @form.save
      flash[:notice] = "Created section"
      return redirect_to article_manage_path(@article)
    end

    render :manage
  end

end