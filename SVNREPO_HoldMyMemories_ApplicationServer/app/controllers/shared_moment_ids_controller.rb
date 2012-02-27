class SharedMomentIdsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @shared_moment_id_pages, @shared_moment_ids = paginate :shared_moment_ids, :per_page => 10
  end

  def show
    @shared_moment_id = SharedMomentId.find(params[:id])
  end

  def new
    @shared_moment_id = SharedMomentId.new
  end

  def create
    @shared_moment_id = SharedMomentId.new(params[:shared_moment_id])
    if @shared_moment_id.save
      flash[:notice] = 'SharedMomentId was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @shared_moment_id = SharedMomentId.find(params[:id])
  end

  def update
    @shared_moment_id = SharedMomentId.find(params[:id])
    if @shared_moment_id.update_attributes(params[:shared_moment_id])
      flash[:notice] = 'SharedMomentId was successfully updated.'
      redirect_to :action => 'show', :id => @shared_moment_id
    else
      render :action => 'edit'
    end
  end

  def destroy
    SharedMomentId.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
