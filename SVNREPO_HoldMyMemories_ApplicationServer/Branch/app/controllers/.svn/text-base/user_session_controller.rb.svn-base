class UserSessionController < ApplicationController
  def index
    list
    render :action => 'list', :layout => false
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @user_sessions_pages, @user_sessionss = paginate :user_sessionss, :per_page => 10
    
    render :layout => false
  end

  def show
    @user_sessionss = UserSessions.find(params[:id])
  end

  def new
    @user_sessionss = UserSessions.new
  end

  def create
    @user_sessionss = UserSessions.new(params[:user_sessions])
    if @user_sessionss.save
      flash[:notice] = 'UserSessions was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @user_sessionss = UserSessions.find(params[:id])
  end

  def update
    @user_sessionss = UserSessions.find(params[:id])
    if @user_sessionss.update_attributes(params[:user_sessions])
      flash[:notice] = 'UserSessions was successfully updated.'
      redirect_to :action => 'show', :id => @user_sessions
    else
      render :action => 'edit'
    end
  end

  def destroy
    UserSessions.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def deleteSelection
    i = 0
      colmns = @user_sessionss.clone
      colmns.each { |colmn|
        i = i + 1
          if (@params['colmn_'+i.to_s] != nil) then
            checked = @params['colmn_'+i.to_s]
              if (checked != nil && checked.length > 0) then
                UserSessions.find(checked).destroy
                
              end
          end  
      }
      redirect_to :action => :list
  end

  
  
end
