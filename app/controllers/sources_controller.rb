class SourcesController < ApplicationController

  # GET /sources
  # GET /sources.json
  def index
    @sources = Source.all
  end

  # GET /sources/1
  # GET /sources/1.json
  def show
    @source = Source.find(params[:id])
  end

  # GET /sources/new
  def new
    @form = Source::Form.new(Source.new)
  end

  # GET /sources/1/edit
  def edit
    @form = Source::Form.new(Source.find(params[:id]))
  end

  # POST /sources
  # POST /sources.json
  def create
    @form = Source::Form.new(Source.new)

    if @form.validate(params[:source])
      @form.save
      return redirect_to @form.model
    end
    render action: :new
  end

  # PATCH/PUT /sources/1
  # PATCH/PUT /sources/1.json
  def update
    @source = Source.find(params[:id])
    @form = Source::Form.new(@source)

    if @form.validate(params[:source])
      @form.save
      return redirect_to @source
    end
    render :edit
  end

  # DELETE /sources/1
  # DELETE /sources/1.json
  def destroy
    @source = Source.find(params[:id])
    @source.destroy
    respond_to do |format|
      format.html { redirect_to sources_url, notice: 'Source was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

end
