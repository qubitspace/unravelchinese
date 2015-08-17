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

  # POST /snippets
  # POST /snippets.json
  def create
    @form = Snippet::Form.new(Snippet.new)

    if @form.validate(params[:snippet])
      @form.save

      return redirect_to @form.model
    end
    render action: :new
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
