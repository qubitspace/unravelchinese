class PostsController < ApplicationController

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.includes(:attachments, :documents).find(params[:id])

    @content = @post.content
    #while content =~ /\[\[attachment\]\]/ and atta
      document = @post.attachments[0].document
      #if document.type = 'image'
        img_src = "<img src='#{document.file}'>"
        @content = @content.gsub(/\[\[attachment\]\]/, img_src)
      #end
    #end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  def manage
    @post = Post.includes(:attachments, :documents).find(params[:post_id])
    @attachment = @post.attachments.build

    @documents = Document.all
    @content = @post.content
    #while content =~ /\[\[attachment\]\]/ and atta
      document = @post.attachments[0].document
      #if document.type = 'image'
        #img_src = "<img src='#{document.file}'>"
        #@content = @content.gsub(/\[\[attachment\]\]/, img_src)
      #end
    #end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.includes(:attachments, :documents).find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        #params[:documents]['file'].each do |a|
        #  @document = @post.documents.create!(:file => a)
        #end
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end


  def create_attachment
    @post = Post.find params[:id]
    @form = Attachment::Form.new(Attachment.new)
    @form.attachable = @post

    if @form.validate(params[:attachment])
      @form.save

      flash[:notice] = "Created attachment for \"#{@post.title}\""
      return redirect_to post_path(@post)
    end

    redirect_to post_path(@post)
  end

  def delete_attachment
    @attachment = Attachment.find params[:attachment_id]
    @attachment.destroy
    respond_to :js
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    @post = Post.includes(:attachments, :documents).find(params[:id])
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

 private
end
