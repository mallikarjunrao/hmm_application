class LoginController < ApplicationController
  before_filter :authorize, :except => [:login, :authorize, :delete_caches]
		
  def delete_caches
	expire_all_pages
	flash[:notice]="Cached files have been deleted."
	render :action => 'index'
  end
		
  def login
	if request.get?
		if params['destination']
			flash[:destination]=params['destination']
		end
		@owner = Owner.new
	else
		@owner = Owner.new(params[:owner])
		logged_in_user = Owner.find(:first, :conditions => ["username = ? and password = ?", @owner.username, @owner.password])
		if logged_in_user
			# log user in
			session[:user_id] = logged_in_user.id
			session[:user_name] = @owner.username
			session[:user_email] = logged_in_user.email
		      session[:restricted] = logged_in_user.payment_type_restricted
		      if logged_in_user.payment_type_restricted
		          session[:user_overrode] = false
		      end

			cookies[:admin] = { :value => @owner.username, :expires => 1.day.from_now }
			if params['destination']
				redirect_to(params['destination'])
			else
				redirect_to(:action => :index)
			end
		else
			flash[:notice] = "Invalid user/password combination"
		end
	end
  end

  def logout
	reset_session
	cookies.delete :admin
	if params['destination']
		redirect_to(params['destination'])
	else
		redirect_to("/")
	end
  end
  
  def authorize
	unless session[:user_id] 
		flash[:notice]="Please log in."
		flash[:destination]=request.request_uri
		redirect_to(:controller => '/login', :action => 'login')
		return false
	end
  end
  
  def index
  end

  def get_access_level
    @owner = Owner.find(:first, :conditions => ["id = ?", session[:user_id]] )
    return @owner.access_level
  end

  def access_denied
    flash[:notice]="Access Denied."
    redirect_to(:controller => '/login', :action => 'index')
  end

end
