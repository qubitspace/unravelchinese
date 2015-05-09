class Admin::SourcesController < Admin::BaseController
  def index
    @sources = policy_scope(Source).order('created_at desc').all
  end

  def show
    @source = Source.find(params[:id])
  end

  def new
    @source = Source.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @source }
    end
  end

  def edit
    @source = Source.find(params[:id])
  end

  def create
    @source = Source.new(source_params)
    @source.save ? redirect_to([:admin, @source]) : render('new')
  end

  def update
    @source = Source.find(params[:id])
    @source.update(source_params) ? redirect_to([:admin, @source])  : render('edit')
  end

  private

  def source_params
    params.require(:source).permit(:name, :link)
  end

end
