class SnippetsController < ApplicationController
  include Concerns::Manageable

  def index
    authorize Snippet
    @snippets = Snippet.all
  end
  private

end
