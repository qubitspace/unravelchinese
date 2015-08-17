class ImagesController < ApplicationController

  # GET /images
  # GET /images.json
  def index
    @images = Image.all
  end

  # GET /images/1
  # GET /images/1.json
  def show
    @image = Image.find(params[:id])
  end

  # GET /images/new
  def new
    @form = Image::Form.new(new_image)
  end

  # GET /images/1/edit
  def edit
    @image = Image.find(params[:id])
    @form = Image::Form.new(@image)
  end

  # POST /images
  # POST /images.json
  def create
    @form = Image::Form.new(new_image)

    if @form.validate(params[:image])
      @form.sync
      image = @form.model

      @form.save do |form|
        if form[:source_id].present?
          image.source = Source.find form[:source_id]
        else
          image.source.update_attributes form[:source]
        end
        image.save
      end

      return redirect_to @form.model
    end
    render action: :new
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    @image = Image.find(params[:id])
    @form = Image::Form.new(@source)

    if @form.validate(params[:image])
      @form.save
      return redirect_to image_show_path(@image)
    end
    render :edit
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def new_image
      Image.new(source: Source.new)
    end
end
