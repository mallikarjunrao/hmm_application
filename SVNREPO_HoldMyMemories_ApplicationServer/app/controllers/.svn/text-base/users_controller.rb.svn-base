class UsersController < ApplicationController
  #before_filter :only => [:index, :destroy, :enable_toggle]
  #before_filter :login_required, :only => [:new, :index, :edit, :update]
  before_filter :authenticate_admin, :only => [:listout,:show,:show_by_username,:new,:change_password,:create,:edit,:update,:destroy,:enable]
  before_filter :authenticate_common_admin_franchise, :only => [:create_admin_support,:listout_admin_supports,:new_admin_support,:edit_admin_support,:update_admin_support,:delete_admin_support]

  layout "admin"

  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to :controller=>'account',:action => 'login'
      return false
    end
  end

  def authenticate_common_admin_franchise
    unless session[:user] || session[:franchise]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to :controller=>'account',:action => 'login'
      return false
    end
  end
  
  def listout
    @users = User.find(:all)
  end

  def show
    @user = User.find(params[:id])

  end

  def show_by_username
    @user = User.find_by_username(params[:username])
    render :action => 'show'
  end

  def change_password

  end

  def new
    @user = User.new

  end

  def create
    if(logged_in_user)
      if(logged_in_user.acess_level.to_i==1)
        @user = User.new(params[:user])
        if @user.save
          self.logged_in_user = @user
          flash[:notice] = "Your account has been created."
          redirect_to :controller =>'users', :action => 'listout'
        else
          render :controller =>'account',:action => 'new'
        end
      end
    end
  end

  def edit
    #@user = logged_in_user
    if(logged_in_user.acess_level.to_i==1)
    @user = User.find(params[:id])
    @user_access = User.find(:all, :conditions => "id=#{params[:id]}")
    else
    @user = User.find(logged_in_user)
    @user_access = User.find(:all, :conditions => "id=#{logged_in_user.id}")
    end
  end

  def update
    @user = User.find(params[:user_id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "User updated"
      redirect_to :action => 'listout'#, :id => logged_in_user
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, 'no')
      flash[:notice] = "User disabled"
    else
      flash[:error] = "There was a problem disabling this user."
    end
    redirect_to :action => 'listout'
  end

  def enable
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, 'yes')
      flash[:notice] = "User enabled"
    else
      flash[:error] = "There was a problem enabling this user."
    end
    redirect_to :action => 'listout'
  end

 def create_admin_support
    if(logged_in_user)
      if(logged_in_user.acess_level.to_i==1)
        @user = SupportAdmin.new(params[:user])
        @user.status = 'active'
        if @user.save
          self.logged_in_user = @user
          flash[:notice] = "Your account has been created."
          redirect_to :controller =>'users', :action => 'listout_admin_supports'
        else
          render :controller =>'account',:action => 'new_admin_support'
        end
      end
    end
    #render :text => params.inspect
  end

  def listout_admin_supports
    @users = SupportAdmin.find(:all, :conditions=>"status='active'")
  end

  def new_admin_support
    @user = SupportAdmin.new
  end

  def edit_admin_support
    @user = SupportAdmin.find(params[:id])
    @user_access = SupportAdmin.find(:all, :conditions => "id=#{params[:id]}")
  end

  def update_admin_support

    @user = SupportAdmin.find(params[:user_id])

    if @user.update_attributes(params[:user])
      flash[:notice] = "User updated"
      redirect_to :action => 'listout_admin_supports'#, :id => logged_in_user
      #render :text => @user.inspect
    else
      render :action => 'edit_admin_support'
    end
  end

  def delete_admin_support
    @user = SupportAdmin.find(params[:id])
    @user.update_attribute(:status, 'inactive')
    redirect_to :action => 'listout_admin_supports'
  end

end


