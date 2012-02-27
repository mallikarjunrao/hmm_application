class JournalsAudiosController < ApplicationController
  
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
    @journals_audio_pages, @journals_audios = paginate :journals_audios, :per_page => 10
  end

  def show
    @journals_audio = JournalsAudio.find(params[:id])
  end

  def new
    @journals_audio = JournalsAudio.new
  end

  def create
    @journals_audio = JournalsAudio.new(params[:journals_audio])
    if @journals_audio.save
      flash[:notice] = 'JournalsAudio was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @journals_audio = JournalsAudio.find(params[:id])
  end

  def update
    @journals_audio = JournalsAudio.find(params[:id])
    if @journals_audio.update_attributes(params[:journals_audio])
      flash[:notice] = 'JournalsAudio was successfully updated.'
      redirect_to :action => 'show', :id => @journals_audio
    else
      render :action => 'edit'
    end
  end

  def destroy
    JournalsAudio.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
