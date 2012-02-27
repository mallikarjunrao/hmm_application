class MyaudiosController < ApplicationController

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
    
    @user_content_pages, @user_contents = paginate :user_contents, :conditions => "e_filetype='audio'", :per_page => 10
  end

  def show
    @user_content = UserContent.find(params[:id])
  end

  def new
    @user_content = UserContent.new
  end

  def create
     @filename = params[:user_content][:v_filename].original_filename
    @user_content = UserContent.new(params[:user_content])
  post = UserContent.save3(params['user_content'])
     @user_content['v_filename']=@filename
    
    if @user_content.save
      flash[:notice] = 'UserContent was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @user_content = UserContent.find(params[:id])
  end

  def update
    @user_content = UserContent.find(params[:id])
    if @user_content.update_attributes(params[:user_content])
      flash[:notice] = 'UserContent was successfully updated.'
      redirect_to :action => 'show', :id => @user_content
    else
      render :action => 'edit'
    end
  end

  def destroy
    UserContent.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
