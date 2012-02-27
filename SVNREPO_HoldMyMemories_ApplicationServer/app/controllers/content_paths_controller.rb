class ContentPathsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @content_path_pages, @content_paths = paginate :content_paths, :per_page => 10
  end

  def show
    @content_path = ContentPath.find(params[:id])
  end

  def new
    @content_path = ContentPath.new
  end

  def create
    @content_path = ContentPath.new(params[:content_path])
    if @content_path.save
      flash[:notice] = 'ContentPath was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @content_path = ContentPath.find(params[:id])
  end

  def update
    @content_path = ContentPath.find(params[:id])
    if @content_path.update_attributes(params[:content_path])
      flash[:notice] = 'ContentPath was successfully updated.'
      redirect_to :action => 'show', :id => @content_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    ContentPath.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
