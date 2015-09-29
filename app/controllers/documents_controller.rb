# class DocumentsController < ApplicationController

#   # GET /documents
#   # GET /documents.json
#   def index
#     @documents = Document.all
#   end

#   # GET /documents/1
#   # GET /documents/1.json
#   def show
#       @document = Document.find(params[:id])
#   end

#   # GET /documents/new
#   def new
#     @form = Document::Form.new(new_document)
#   end

#   # GET /documents/1/edit
#   def edit
#     @form = Document::Form.new(Document.find(params[:id]))
#   end

#   # POST /documents
#   # POST /documents.json
#   def create
#     @form = Document::Form.new(new_document)

#     if @form.validate(params[:document])
#       @form.sync
#       document = @form.model

#       @form.save do |form|
#         if form[:source_id].present?
#           document.source = Source.find form[:source_id]
#         else
#           document.source.update_attributes form[:source]
#         end
#         document.save
#       end

#       # Redirect to manage article to set up sentences
#       # Then have a link from the sentence cell to a manage sentence page to add tokenize?
#       return redirect_to @form.model
#     end
#     render action: :new
#   end

#   # PATCH/PUT /documents/1
#   # PATCH/PUT /documents/1.json
#   def update
#     @document = Document.find(params[:id])
#     respond_to do |format|
#       if @document.update(document_params)
#         format.html { redirect_to @document.post, notice: 'Document was successfully updated.' }
#       end
#     end
#   end

#   # DELETE /documents/1
#   # DELETE /documents/1.json
#   def destroy
#     @document = Document.find(params[:id])
#     @document.destroy
#     respond_to do |format|
#       format.html { redirect_to documents_url, notice: 'Document was successfully destroyed.' }
#       format.json { head :no_content }
#     end
#   end

#   private

#     def new_document
#       Document.new(source: Source.new)
#     end
# end
