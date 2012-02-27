class EmployeAccountsController < ApplicationController
   layout "admin"
   helper :sort
  include SortHelper
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
       
  before_filter :authenticate_emp, :only => [ :edit, :list1]
  
  before_filter :authenticate_admin, :only => [ :list, :new, :edit_admin]
  
  def authenticate_emp
    unless session[:employe]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "https://www.holdmymemories.com/account/employe_login"
    return false
    end
  end
  
  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "https://www.holdmymemories.com/account/login"
    return false
    end
  end

  def list
    @employe_account_pages, @employe_accounts = paginate :employe_accounts, :per_page => 10
  end
  
   def list_print
     sort_init 'id'
     sort_update
     if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "id desc"
      else
        
       sort = "#{session[:srk]}  #{params[:sort_order]}"
      end 
      else
       session[:sort_order]=params[:sort_order]
       session[:srk]=params[:sort_key] 
       sort = "#{session[:srk]}  #{params[:sort_order]}"
     end
    @employe_account_pages, @employe_accounts = paginate :employe_accounts, :per_page => 50 , :order => sort
    render :layout => false
  end
  
  def list1
    @employe_account_pages, @employe_accounts = paginate :employe_accounts, :per_page => 10, :conditions => "status = 'unblock'"
  end
  
  def show
    @employe_account = EmployeAccount.find(params[:id])
  end

  def new
    @employe_account = EmployeAccount.new
  end

  def create
    @employe_account = EmployeAccount.new(params[:employe_account])
    if @employe_account.save
      $emp_create
      $emp_add
      flash[:emp_create] = 'Your Account has been successfully created!! Please login to access your account'
      flash[:emp_add] = 'Employee Account has been successfully created!!'
      if logged_in_user
        redirect_to :controller => 'account', :action => 'index1'
      else
      redirect_to :controller => 'account', :action => 'employe_login'
      end
    else
      render :action => 'new'
    end
  end
  
  def validate
    color = 'red'
   username = params[:username]

      user = EmployeAccount.find_all_by_employe_username(username)      
      if user.size > 0        
        message = 'User Name Is Already Registered'
        @valid_username = false
      else
        message = 'User Name Is Available'
        color = 'green'
         @valid_username=true
    end
   @message = "<b style='color:#{color}'>#{message}</b>"
    
    render :partial=>'message'
  end
  
  def validate_empid
    color = 'red'
    employe_id = params[:employe_id]

      emp = EmployeAccount.find_all_by_employe_id(employe_id)      
      if emp.size > 0        
        message_empid = 'Employee ID is Already Registered'
        @valid_emp_id = false
      else
        message_empid = 'Employee ID is Available'
        color = 'green'
         @valid_emp_id=true
    end
   @message_id = "<b style='color:#{color}'>#{message_empid}</b>"
    
    render :partial=>'message_id'
  end
  
  def edit
    if session[:employe] 
      
    @employe_account = EmployeAccount.find(session[:employe])
    end
  end
  
  def edit_admin
    @employe_account = EmployeAccount.find(params[:id])
  end
  
  def update
    @employe_account = EmployeAccount.find(params[:id])
#    @employe_account['branch']=''
    if @employe_account.update_attributes(params[:employe_account])
      $update_profile
      flash[:update_profile] = 'your Profile was successfully updated.'
      if session[:employe]
        redirect_to :controller => 'account', :action => 'emp_home'
      else
        redirect_to :controller => 'account', :action => 'index1'
      end
      #redirect_to :action => 'show', :id => @employe_account
    else
      render :action => 'edit'
    end
  end

  def destroy
    @emp = EmployeAccount.find(params[:id])
    if @emp.update_attribute(:status, 'block')
    redirect_to :action => 'list'
    end
  end
  
  
   def unblock
    @emp = EmployeAccount.find(params[:id])
    if @emp.update_attribute(:status, 'unblock')
    redirect_to :action => 'list'
    end
  end
  
end
