class JournalsPaperworksController < ApplicationController

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
    @journals_paperwork_pages, @journals_paperworks = paginate :journals_paperworks, :per_page => 10
  end

  def show
    @journals_paperwork = JournalsPaperwork.find(params[:id])
  end

  def new
    @journals_paperwork = JournalsPaperwork.new
  end

  def create
    @journals_paperwork = JournalsPaperwork.new(params[:journals_paperwork])
    if @journals_paperwork.save
      flash[:notice] = 'JournalsPaperwork was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @journals_paperwork = JournalsPaperwork.find(params[:id])
  end

  def update
    @journals_paperwork = JournalsPaperwork.find(params[:id])
    if @journals_paperwork.update_attributes(params[:journals_paperwork])
      flash[:notice] = 'JournalsPaperwork was successfully updated.'
      redirect_to :action => 'show', :id => @journals_paperwork
    else
      render :action => 'edit'
    end
  end

  def destroy
    JournalsPaperwork.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
