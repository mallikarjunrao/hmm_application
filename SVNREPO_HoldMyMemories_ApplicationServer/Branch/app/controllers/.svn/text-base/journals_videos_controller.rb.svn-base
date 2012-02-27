class JournalsVideosController < ApplicationController

#before_filter :only => [:index, :destroy, :enable_toggle]
#before_filter :login_required || :login_required1, :only => [:new, :list, :create, :index, :search, :edit, :deleteSelection, :deleteSelection1, :update]
 
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @journals_video_pages, @journals_videos = paginate :journals_videos, :per_page => 10
  end

  def show
    @journals_video = JournalsVideo.find(params[:id])
  end

  def new
    @journals_video = JournalsVideo.new
  end

  def create
    @journals_video = JournalsVideo.new(params[:journals_video])
    if @journals_video.save
      flash[:notice] = 'JournalsVideo was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @journals_video = JournalsVideo.find(params[:id])
  end

  def update
    @journals_video = JournalsVideo.find(params[:id])
    if @journals_video.update_attributes(params[:journals_video])
      flash[:notice] = 'JournalsVideo was successfully updated.'
      redirect_to :action => 'show', :id => @journals_video
    else
      render :action => 'edit'
    end
  end

  def destroy
    JournalsVideo.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
