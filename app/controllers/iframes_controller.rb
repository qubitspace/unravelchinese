class IframesController < ApplicationController

  # GET /iframes
  # GET /iframes.json
  def index
    @iframes = Iframe.all
  end

  # GET /iframes/1
  # GET /iframes/1.json
  def show
    @iframe = Iframe.find(params[:id])
  end

  # GET /iframes/new
  def new
    @form = Iframe::Form.new(Iframe.new)
  end

  # GET /iframes/1/edit
  def edit
    @iframe = Iframe.find(params[:id])
    @form = Iframe::Form.new(@iframe)
  end

  # POST /iframes
  # POST /iframes.json
  def create
    @form = Iframe::Form.new(Iframe.new)

    if @form.validate(params[:iframe])
      @form.save

      return redirect_to @form.model
    end
    render action: :new
  end

  # PATCH/PUT /iframes/1
  # PATCH/PUT /iframes/1.json
  def update
    @iframe = Iframe.find(params[:id])
    @form = Iframe::Form.new(@iframe)
    if @form.validate(params[:iframe])
      @form.save
      flash[:notice] = "Created comment for \"#{@iframe.title}\""
      return redirect_to iframe_path(@iframe)
    end

    render :show
  end


  # DELETE /iframes/1
  # DELETE /iframes/1.json
  def destroy
    @iframe = Iframe.find(params[:id])
    @iframe.destroy
    respond_to do |format|
      format.html { redirect_to iframes_url, notice: 'Iframe was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

end
