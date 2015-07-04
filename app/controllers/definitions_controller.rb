class DefinitionsController < ApplicationController

  def show
    @definition = Definition.find(params[:id])
  end

  def show_edit_form
    @definition = Definition.find params[:definition_id]
    respond_to :js
  end

  def update
    @definition = Definition.find(params[:definition][:definition_id])
    @definition_form = Definition::Form.new(@definition)

    if @definition_form.validate(params[:definition])

      @definition_form.save
    end
    respond_to :js

    @errors = @definition_form.errors

  end

  def destroy
    definition = Definition.find(params[:id])
    definition.destroy

    redirect_to tags_path
  end

end
