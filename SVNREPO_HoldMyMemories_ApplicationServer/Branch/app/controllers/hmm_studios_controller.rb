class HmmStudiosController < ApplicationController
  layout "admin"
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  before_filter :authenticate_admin, :only => [:list, :show, :new, :edit]

  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "https://www.holdmymemories.com/account/login"
    return false
    end
  end

  def list
    @hmm_studio_pages, @hmm_studios = paginate :hmm_studios, :per_page => 10
  end

  def show
    @hmm_studio = HmmStudio.find(params[:id])
  end

  def new
    @hmm_studio = HmmStudio.new
  end

  def create
    @hmm_studio = HmmStudio.new(params[:hmm_studio])
    if @hmm_studio.save
      flash[:notice] = 'HmmStudio was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @hmm_studio = HmmStudio.find(params[:id])
    @sid = params[:id]
  end

  def update
    @hmm_studio = HmmStudio.find(params[:id])
    if @hmm_studio.update_attributes(params[:hmm_studio])
      flash[:notice] = 'HmmStudio was successfully updated.'
      redirect_to :action => 'show', :id => @hmm_studio
    else
      render :action => 'edit'
    end
  end

  def destroy
    HmmStudio.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def validate
    color = 'red'
   studio_name = params[:studio_branch]

      user = HmmStudio.find_all_by_studio_branch(studio_name)
#      studio_id = HmmStudio.count(:all, :conditions => "studio_name")
      if user.size > 0        
        message = 'Studio is Already added'
        @valid_studioname = false
      
    end
   @message = "<b style='color:#{color}'>#{message}</b>"
    
    render :partial=>'message'
  end
  
  def validate_edit
    color = 'red'
    @studio_name = params[:studio_branch]
     @sid = params[:id] 
    @studioname = HmmStudio.find(params[:id])
    @branchname = @studioname.studio_branch
      @user1 = HmmStudio.find(:all, :conditions => "id = '#{@sid}'")
      for i in @user1
        stud = i.studio_branch
      end
      user = HmmStudio.find_all_by_studio_branch(@studio_name)
         if user.size > 0 && stud != @studio_name
            message = 'Studio is Already added'
            @valid_studioname = false
        end
        @message = "<b style='color:#{color}'>#{message}</b>"
    
      render :partial=>'message'
  end
end
