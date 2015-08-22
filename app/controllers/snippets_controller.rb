class SnippetsController < ApplicationController

  # GET /snippets
  # GET /snippets.json
  def index
    @snippets = Snippet.all
  end

  # GET /snippets/1
  # GET /snippets/1.json
  def show
    @snippet = Snippet.find(params[:id])
  end

  # GET /snippets/new
  def new
    @form = Snippet::Form.new(Snippet.new)
  end

  # GET /snippets/1/edit
  def edit
    @snippet = Snippet.find(params[:id])
    @form = Snippet::Form.new(@snippet)
  end


  def create
    article = Article.find params[:snippet][:section_attributes][:article_id]
    snippet = Snippet.new(:section => Section.new(:article_id => article.id))
    snippet_form = Snippet::Form.new(snippet)

    # New Snippet Form
    new_snippet = Snippet.new(:section => Section.new(:article_id => article.id))
    blank_snippet_form = Snippet::Form.new(new_snippet)

    if snippet_form.validate(params[:snippet])
      snippet_form.save
      respond_to do |format|
        format.js {
          render js:
            concept("section/section_cell/manage_section_cell", snippet_form.model.section, current_user: current_user).call(:add_new_section) +
            concept("snippet/snippet_form_cell", blank_snippet_form).call(:refresh_form)

        }
      end
    else
      respond_to do |format|
        format.js {
          render js: concept("snippet/snippet_form_cell", snippet_form, current_user: current_user).call(:refresh_form)
        }
      end
    end
  end





  # PATCH/PUT /snippets/1
  # PATCH/PUT /snippets/1.json
  def update
    @snippet = Snippet.find(params[:id])
    @form = Snippet::Form.new(@snippet)
    if @form.validate(params[:snippet])
      @form.save
      flash[:notice] = "Created comment for \"#{@snippet.title}\""
      return redirect_to snippet_path(@snippet)
    end

    render :show
  end


  # DELETE /snippets/1
  # DELETE /snippets/1.json
  def destroy
    @snippet = Snippet.find(params[:id])
    @snippet.destroy
    respond_to do |format|
      format.html { redirect_to snippets_url, notice: 'Snippet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

end
