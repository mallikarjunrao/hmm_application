class MarketManagersController < ApplicationController
  layout "admin"
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  before_filter :authenticate_manager, :only => [:my_employee ,:manager_home] 
  
  before_filter :authenticate_admin, :only => [:list, :new, :edit]

  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "https://www.holdmymemories.com/account/login"
    return false
    end
  end
  
  def authenticate_manager
    unless session[:manager]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "https://www.holdmymemories.com/account/market_manager_login"
    return false
    end
  end

  def list
    @market_manager_pages, @market_managers = paginate :market_managers, :per_page => 10
  end

  def show
    @market_manager = MarketManager.find(params[:id])
  end

  def new
    @market_manager = MarketManager.new
  end

  def create
    #puts params[:manager_branche]
    @market_manager_max =  MarketManager.find_by_sql("select max(id) as m from market_managers")
    for manager_max in @market_manager_max
     manager_max_id = "#{manager_max.m}"
    end
    if(manager_max_id == '')
     manager_max_id = '0'
    end
    manager_next_id= Integer(manager_max_id) + 1
    
    manager_branchsize = params[:manager_branche].size
    puts manager_branchsize
    i=0
    until i == manager_branchsize
      @manager_branches = ManagerBranche.new()
      @manager_branches['manager_id']=manager_next_id
      @manager_branches['branch_id']= params[:manager_branche][i]
      @manager_branches.save
      i = i + 1
    end
    @market_manager = MarketManager.new(params[:market_manager])
    if @market_manager.save
      flash[:notice] = 'MarketManager was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
    
  end

  def edit
    @market_manager = MarketManager.find(params[:id])
  end

  def update
#    brach_ids = params[:old_branches].size
    @manager_id = ManagerBranche.find(:all, :conditions => "manager_id='#{params[:id]}'")
    for m in @manager_id
      params[:bid] = m.id  
      ManagerBranche.find(params[:bid]).destroy
    end
    manager_branchsize = params[:manager_branche].size
    puts manager_branchsize
    i=0
    until i == manager_branchsize
    @manager_branches = ManagerBranche.new()
      @manager_branches['manager_id']=params[:id]
      @manager_branches['branch_id']= params[:manager_branche][i]
      @manager_branches.save
      i = i + 1
    end
    @market_manager = MarketManager.find(params[:id])
    if @market_manager.update_attributes(params[:market_manager])
      flash[:notice] = 'MarketManager was successfully updated.'
      redirect_to :action => 'show', :id => @market_manager
    else
      render :action => 'edit'
    end
  end
  
  def edit_manager
    @market_manager = MarketManager.find(params[:id])
  end

  def manager_update
#    brach_ids = params[:old_branches].size
    @manager_id = ManagerBranche.find(:all, :conditions => "manager_id='#{params[:id]}'")
    for m in @manager_id
      params[:bid] = m.id  
      ManagerBranche.find(params[:bid]).destroy
    end
    manager_branchsize = params[:manager_branche].size
    puts manager_branchsize
    i=0
    until i == manager_branchsize
    @manager_branches = ManagerBranche.new()
      @manager_branches['manager_id']=params[:id]
      @manager_branches['branch_id']= params[:manager_branche][i]
      @manager_branches.save
      i = i + 1
    end
    @market_manager = MarketManager.find(params[:id])
    if @market_manager.update_attributes(params[:market_manager])
      $notice_edit_man
      flash[:notice_edit_man] = 'MarketManager was successfully updated.'
      redirect_to :controller => 'account', :action => 'manager_home' #, :id => @market_manager
    else
      render :action => 'edit'
    end
  end

  def destroy
    MarketManager.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
   def validate
    color = 'red'
   username = params[:username]

      user = MarketManager.find_all_by_manager_username(username)      
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

      emp = MarketManager.find_all_by_employee_id(employe_id)      
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
  
  def my_employee
    @my_employee = ManagerBranche.find(:all, :joins => "as a, employe_accounts as b", :conditions => "a.manager_id = '#{session[:manager]}' and b.store_id = a.branch_id" )
  end
  
  def manager_home
    
  end
end
