class AccountController < ApplicationController
  #  include ExceptionNotifiable
  layout "admin"
  helper :sort
  include SortHelper
  require 'will_paginate'
  include ApplicationHelper
  include UserSessionHelper
 # ssl_required :all

  before_filter :authenticate_emp, :only => [   :premium_usersearch, :my_customers, :premium_users, :mycustomer_search, :emp_home, :customer_list, :cancelled_list_search, :cancelled_list, :pending_requests, :pending_request_search, :cancelled_list_search_failed, :cancelled_list_failed,:studio_customers_studio,:commissionReport_studio_manager,:studio_management_customers,:studio_premium_customers_report]

  before_filter :authenticate_admin, :only => [ :hmm_reporting, :hmm_reporting_search,  :cutekid_contetslist, :review_cutekid, :cutekid_moment_view ,  :commissionReport,  :login_report, :guestReport, :statReport, :chapReport, :commentReport, :sessionReport, :fnf_index, :index1, :customer_list, :link_customer, :link_list, :link_list1, :platinum_user_excel, :gotskils_moment_view, :gotskils_contetslist, :review_gotskils, :pending_requests_admin, :pending_request_search_admin, :cancelled_list_search_admin, :cancelled_list_admin, :activation_report,:contest_shares,:form,:new_hmmgroup,:list_hmmgroup,:edit_hmmgroup,:coupon_upgrade,:premium_customer,:premium_show,:holiday_contetsvideolist,:holiday_contetsphotolist,:contest_delete,:contestReport,:commissionReport_new,:othercommissionReport,:zipcodeReport,:track_account,:feed_report,:coupon_userlist,:template_measurement,:upload_import_counts,:count_upload_import_report,:admin_verify_cuponID,:customerReport,:premium_customersearch,:premium_show,:contest_delete,:platinum_user_excel1,:hmm_reporting_excel,:import_image,:contestReport_excel]


  before_filter :authenticate_common, :only => [:studio_customers_market_manager,:commissionReport_market_manager,:studio_customers]

  before_filter :authenticate_common_admin_emp, :only => [:edit,:search_giftcertificate,:preview_certificate]
  before_filter :authenticate_common_manager_emp, :only => [:studio_customers_report]

  before_filter :authenticate_common_admin_support, :only => [:list,:list1,:studio_session_subchapters,:delete_sub_session,:delete_gallery_session,:delete_image_session,:edit_family_name,:check_family_name,:edit_gallery_name,:edit_gallery_page,:move_gallery_user,:move_gallery]

  def index1
    @image_arrays= Array.new()
    @video_arrays= Array.new()
    @name_arrays= Array.new()
    @phase_ids= Array.new()
    @hmm_user_requests= HmmUser.count(:all, :conditions => "cancel_status='pending'")
    active_contests=ContestDetail.find(:all,:conditions=>"status=1")
    for active_contest in active_contests
      contest_image_pending = Contest.count(:all, :conditions => "moment_type = 'image' and status='pending' and contest_phase='#{active_contest.contest_phase}'")
      contest_video_pending = Contest.count(:all, :conditions => "moment_type = 'video' and status='pending' and contest_phase='#{active_contest.contest_phase}'")
      @image_arrays.push(contest_image_pending)
      @video_arrays.push(contest_video_pending)
      @name_arrays.push(active_contest.name)
      @phase_ids.push(active_contest.id)
    end
    @hmm_user_requests1= HmmUser.count(:all, :conditions => "cancel_status='approved' and canceled_by='-2'")
  end
  #  def emp_home
  #    @hmm_user_requests= HmmUser.count(:all, :conditions => "cancel_status='pending' and emp_id='#{session[:employe]}'")
  #    @hmm_user_requests1= HmmUser.count(:all, :conditions => "cancel_status='approved' and canceled_by='-2' and emp_id='#{session[:employe]}'")
  #  end

  def emp_home

    if(session[:store_id]==170 || session[:store_id]=='170')

      @hmm_user_requests= HmmUser.count(:all, :conditions => "cancel_status='pending' and  DATE_ADD(cancellation_request_date ,INTERVAL 2 DAY )  between  concat( date_format( curdate( ) , '%Y-%m-%d' ) , date_format( cancellation_request_date, ' %H:%i:%s' ) ) and concat(date_format(DATE_ADD(CURDATE(),INTERVAL 1 DAY),'%Y-%m-%d'), date_format(cancellation_request_date,' %H:%i:%s'))")
      @hmm_user_requests1= HmmUser.count(:all, :conditions => "cancel_status='approved' and canceled_by='-2' and emp_id='#{session[:employe]}' and  DATE_ADD(cancellation_request_date ,INTERVAL 2 DAY )  between  concat( date_format( curdate( ) , '%Y-%m-%d' ) , date_format( cancellation_request_date, ' %H:%i:%s' ) ) and concat(date_format(DATE_ADD(CURDATE(),INTERVAL 1 DAY),'%Y-%m-%d'), date_format(cancellation_request_date,' %H:%i:%s'))")

    else

      @hmm_user_requests= HmmUser.count(:all, :conditions => "cancel_status='pending' and  cancellation_request_date between concat( date_format( curdate( ) , '%Y-%m-%d' ) , date_format( cancellation_request_date, ' %H:%i:%s' ) ) and concat(date_format(DATE_ADD(CURDATE(),INTERVAL 1 DAY),'%Y-%m-%d'), date_format(cancellation_request_date,' %H:%i:%s')) and studio_id=#{session[:store_id]} ")
      @hmm_user_requests1= HmmUser.count(:all, :conditions => "cancel_status='approved' and canceled_by='-2' and  cancellation_request_date between concat( date_format( curdate( ) , '%Y-%m-%d' ) , date_format( cancellation_request_date, ' %H:%i:%s' ) ) and concat(date_format(DATE_ADD(CURDATE(),INTERVAL 1 DAY),'%Y-%m-%d'), date_format(cancellation_request_date,' %H:%i:%s')) and studio_id=#{session[:store_id]} ")

    end




  end

  def authenticate
    session[:expires_at] = session_time
    self.logged_in_user = User.authenticate(params[:user][:username],
      params[:user][:hashed_password ])
    if is_logged_in?
      redirect_to  :action => 'index1'
    else
      flash[:error] = "I'm sorry; either your username or password was incorrect."
      redirect_to :action => 'login'
    end
  end

  def authenticate_emp
    unless session[:employe]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "https://holdmymemories.com/account/employe_login"
      return false
    end
  end

  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to :action => 'login'
      return false
    end
  end

  def authenticate_manager
    unless session[:manager]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "https://holdmymemories.com/account/market_manager_login"
      return false
    end
  end

  def authenticate_common
    unless session[:manager] || session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "https://holdmymemories.com/account/market_manager_login"
      return false
    end
  end

  def authenticate_common_admin_emp
    unless  session[:user] || session[:employe] || session[:support_admin]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "https://holdmymemories.com/account/login"
      return false
    end
  end

  def authenticate_common_manager_emp
    unless  session[:employe] || session[:manager]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "/account/market_manager_login"
      return false
    end
  end

  def authenticate_franchise_admin
    session[:expires_at] = session_time
    logged_in_franchise = HmmStudiogroup.find_by_studiogroup_username_and_password(params[:hmm_studiogroup][:studiogroup_username],
      params[:hmm_studiogroup][:password ], :conditions => "status='active'")
    #puts logged_in_employe.id
    if logged_in_franchise
      session[:franchise_name]=logged_in_franchise.studiogroup_username
      session[:franchise]=logged_in_franchise.id
      #puts session[:employe]
      redirect_to :controller => 'hmm_studiogroups', :action => 'franchise_home', :id => logged_in_franchise.id
    else
      flash[:error] = "I'm sorry; either your username or password was incorrect."
      redirect_to :action => 'franchise_login'
    end
  end

  def authenticate_employe
    session[:expires_at] = session_time
    logged_in_employe = EmployeAccount.find_by_employe_username_and_password(params[:employe_account][:employe_username],
      params[:employe_account][:password], :conditions => "status='unblock'")
    #puts logged_in_employe.id
    if logged_in_employe
      session[:employe_name]=logged_in_employe.employe_name
      session[:employe]=logged_in_employe.id
      session[:store_id]=logged_in_employe.store_id
      #puts session[:employe]
      redirect_to  :action => 'emp_home', :id => logged_in_employe.id
    else
      flash[:error] = "I'm sorry; either your username or password was incorrect."
      redirect_to :action => 'employe_login'
    end
  end

  def authenticate_commission
    session[:expires_at] = session_time
    logged_in_employe = EmployeAccount.find_by_employe_username_and_password(params[:employe_account][:employe_username],
      params[:employe_account][:password ], :conditions => " emp_type='store_manager' and status='unblock' ")
    #puts logged_in_employe.id
    if logged_in_employe
      session[:cemploye_name]=logged_in_employe.employe_name
      session[:cemploye]=logged_in_employe.id
      session[:cstore_id]=logged_in_employe.store_id
      #puts session[:employe]
      redirect_to  :action => 'commissionReport_studio_manager', :id => logged_in_employe.id
    else
      flash[:error] = "I'm sorry; either your username or password was incorrect."
      redirect_to :action => 'commission_login'
    end
  end


  def authenticate_market_manager
    session[:expires_at] = session_time
    logged_in_marketmanager = MarketManager.find_by_manager_username_and_password(params[:market_manager][:manager_username],
      params[:market_manager][:password ], :conditions => "status='unblock'")
    #puts logged_in_employe.id
    if logged_in_marketmanager
      session[:manager_name]=logged_in_marketmanager.manager_name
      session[:manager]=logged_in_marketmanager.id
      #puts session[:employe]
      redirect_to  :action => 'manager_home'
    else
      flash[:error] = "I'm sorry; either your username or password was incorrect."
      redirect_to :action => 'market_manager_login'

    end
  end

  def business_manager_login

  end

  def authenticate_business_manager
    session[:expires_at] = session_time
    logged_in_businessmanager = BusinessManager.find_by_business_manager_username_and_business_manager_password(params[:business_manager][:businessmanager_username],
      params[:business_manager][:businessmanager_password ])
    #puts logged_in_employe.id
    if logged_in_businessmanager
      session[:business_manager_name]=logged_in_businessmanager.business_manager_name
      session[:business_manager]=logged_in_businessmanager.id
      #puts session[:employe]
      redirect_to :controller => "business_managers", :action => 'businessmanager_home'

    else
      flash[:error] = "I'm sorry; either your username or password was incorrect."
      redirect_to :action => 'business_manager_login'

    end
  end


  def sales_person_login

  end

  def authenticate_sales_person
    session[:expires_at] = session_time
    @cnt=SalesManager.count(:all,:conditions=>"username='#{params[:username]}' and password='#{params[:password]}' and status='active'")

    if @cnt>0
      logged_in_salesperson=SalesManager.find(:first,:conditions=>"username='#{params[:username]}' and password='#{params[:password]}' and status='active'")
      session[:sales_person_name]=logged_in_salesperson.name
      session[:sales_person]=logged_in_salesperson.id
      #puts session[:employe]
      redirect_to :controller => "sales_person", :action => 'home'

    else
      flash[:error] = "I'm sorry; either your username or password was incorrect."
      redirect_to :action => 'sales_person_login'

    end
  end


  def emp_logout
    reset_session
    flash[:notice] = "You Have Successfully Logged Out."
    redirect_to :action => 'employe_login'
  end

  def manager_logout
    reset_session
    flash[:notice_managerlogout] = "You Have Successfully Logged Out."
    redirect_to :action => 'market_manager_login'
  end

  def franchise_admin_logout
    reset_session
    flash[:notice_franchiselogout] = "You Have Successfully Logged Out."
    redirect_to :action => 'franchise_login'
  end

  def business_manager_logout
    reset_session
    flash[:notice_franchiselogout] = "You Have Successfully Logged Out."
    redirect_to :action => 'business_manager_login'
  end

  def sales_person_logout
    reset_session
    flash[:notice_franchiselogout] = "You Have Successfully Logged Out."
    redirect_to :action => 'sales_person_login'
  end
  # def list
  #   @pages = Page.find(:all)
  #   render(:layout => false)
  # end

  def create
    @page = Page.new(params[:page])
    @page.save!
    flash[:notice] = 'Page saved'
    redirect_to :action => 'index'
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

#  def edit
#    @page = Page.find(params[:ID].to_i)
#    render(:layout => false)
#  end

  def list_hmmgroup
    sort_init 'studiogroup_username'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "studiogroup_username desc"
      else
        sort = "studiogroup_username asc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end

    if params[:studiogroup_username] && params[:studiogroup_username]!=''
      cond = "and studiogroup_username LIKE '%#{params[:studiogroup_username]}%'"
    else
      cond = ''
    end

    if params[:hmm_franchise_studio] && params[:hmm_franchise_studio]!=''
      cond1 = "and hmm_franchise_studio LIKE '%#{params[:hmm_franchise_studio]}%'"
    else
      cond1 = ''
    end

    if params[:contact_email] && params[:contact_email]!=''
      cond2 = "and contact_email LIKE '%#{params[:contact_email]}%'"
    else
      cond2 = ''
    end

    if params[:status] && params[:status]!=''
      cond3 = "and status = '#{params[:status]}'"
    else
      cond3 = ''
    end

    @hmm_studiogroups = HmmStudiogroup.paginate :per_page => 10, :page => params[:page],:conditions => "status='active' #{cond} #{cond1} #{cond2} #{cond3}", :order => sort
  end

  def edit_hmmgroup
    @hmm_studiogroup = HmmStudiogroup.find(params[:id])
  end

  def new_hmmgroup
    @hmm_studiogroup = HmmStudiogroup.new
  end

  def create_hmmgroup
    @hmm_studiogroup = HmmStudiogroup.new(params[:hmm_studiogroup])

    username =params[:hmm_studiogroup][:studiogroup_username]
    user = HmmStudiogroup.count(:all, :conditions => "studiogroup_username='#{username}'")
    if user > 0
      flash[:notice] = 'User Name Already exists'
      render :action => 'new'
    else
      @hmm_studiogroup.save
      flash[:notice] = 'HmmStudiogroup was successfully created.'
      redirect_to :action => 'list_hmmgroup'

    end
  end

  def validate
    color = 'red'
    username =params[:studiogroup_username]
    user = HmmStudiogroup.count(:all, :conditions => "studiogroup_username='#{username}'")
    if user > 0
      message = 'User Name Is Already Registered'
      @valid_username = false
    else
      message = 'User Name Is Available'
      color = 'green'
      @valid_username=true
    end
    @message = "<b style='color:#{color}'>#{message}</b>"
    render :partial=>'message' , :layout => false
  end

  def show_hmmgroup
    @hmm_studiogroup = HmmStudiogroup.find(params[:id])
  end

  def update_hmmgroup
    @hmm_studiogroup = HmmStudiogroup.find(params[:id])
    if @hmm_studiogroup.update_attributes(params[:hmm_studiogroup])
      flash[:notice] = 'HmmStudiogroup was successfully updated.'
      redirect_to :action => 'show_hmmgroup', :id => @hmm_studiogroup
    else
      render :action => 'edit_hmmgroup'
    end
  end

  def destroy_hmmgroup
    HmmStudiogroup.find(params[:id]).destroy
    redirect_to :action => 'list_hmmgroup'
  end

  #  def update
  #    @page = Page.find(params[:page])
  #    @page.attributes = params[:page]
  #    @page.update_attributes(params[:page])
  #    #flash[:notice] = "Page updated"
  #    redirect_to :action => 'index'
  #    #rescue
  #    #render :action => 'edit'
  #  end

  def destroy
    Page.find(params[:ID]).destroy
    redirect_to :controller => 'account', :action => 'list'
  end

  def logout
    if request.post?
      reset_session
      flash[:notice] = "You Have Successfully Logged Out."
    end
    redirect_to :action => 'login'
  end

  def list
    sort_init 'id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "id desc"
      else

        sort = "id desc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end
    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked'")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked'")
    @hmm_users = HmmUser.paginate :select => "*", :per_page => 10, :page => params[:page], :order => sort

    render :layout => true
  end


  def premium_customer
    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and account_type!='free_user'")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and account_type!='free_user'")
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

    @hmm_users = (HmmUser.paginate :select => "a.*,c.studio_name",:joins =>"as a ,employe_accounts as b,hmm_studios as c ",  :per_page => 10, :page => params[:page], :conditions => "a.account_type!='free_user' and b.id=a.emp_id and b.store_id=c.id ", :order => sort)

    render :layout => true
  end



  def customer_list
    sort_init 'id'
    sort_update


    if( params[:sort_key] == nil )
      session[:sort_order]="desc"
      session[:srk]="id"
      sort="#{session[:srk]}  #{params[:sort_order]}"
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort="#{session[:srk]}  #{params[:sort_order]}"

    end
    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked'")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked'")
    @hmm_users = HmmUser.paginate :per_page => 10, :page => params[:page], :order => sort

    render :layout => true
  end

  def list1
    sort_init 'id'
    sort_update

    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked'")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked'")


    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )

    else
      @uname=params[:username]
      if(@uname!="" && params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%'"
      end

      @email=params[:email]
      if(@email!="" && params[:email]!=nil)
        emailcondition="and v_e_mail like '#{@email}%' "
      end

      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}'"
      end

      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%'"
      end

      @country=params[:v_country]
      @zip=params[:zip]

      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%'"
        end
      end

    end
    if( params[:sort_key] ==nil )
      session[:sort_order]="desc"
      session[:srk]="id"
      @srk = "#{session[:srk]}  #{params[:sort_order]}"
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      @srk = "#{session[:srk]}  #{params[:sort_order]}"

    end

    if(params[:username]== nil && params[:lastname]== nil && params[:firstname]== nil && params[:v_country]== nil &&  params[:zip]== nil && params[:account_type]== nil && params[:email]== nil)
      #session[:search_cond]="#{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}"
    else
      session[:search_cond]="#{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}"
    end
    @hmm_users = HmmUser.paginate :per_page => 10, :page => params[:page] , :conditions =>"id!='' #{session[:search_cond]}", :order =>  @srk

    render :layout => true
  end

  def customer_list1
    sort_init 'id'
    sort_update

    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked'")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked'")

    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
    else
      @uname=params[:username]
      if(@uname!="" && params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%'"
      end

      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}'"
      end

      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%'"
      end

      @country=params[:v_country]
      @zip=params[:zip]

      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%'"
        end
      end

    end

    if params[:sort_key]==nil && params[:sort_order]==nil
      @srk="id  desc"
    else

      @sort_key=params[:sort_key]



      @order=params[:sort_order]
    end
    puts @sort_key
    puts @order
    @srk="#{@sort_key}"+" "+"#{@order}"
    if( @srk==nil || @srk=="" )
      @srk="id  desc"
    end

    puts @srk

    @hmm_users = HmmUser.paginate  :per_page => 10, :page => params[:page], :conditions =>"id!='' #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}", :order =>  @srk

    render :layout => true
  end

  def show
    @hmm_user = HmmUser.find(params[:id])

  end

   def edit
    @get_content_url=ContentPath.find(:first, :conditions => "status='active'")
    @hmm_user = HmmUser.find(params[:id])

  end

  def update
    @hmm_user = HmmUser.find(params[:id])
    @username_check= HmmUser.count(:conditions => "v_user_name='#{params[:hmm_user][:v_user_name]}' and id!='#{params[:id]}' " )
    if(@username_check > 0 )
      flash[:notice]="User name already exisits please try again with different User name!"
      render :action => 'edit', :id => params[:id]
    else

      if @hmm_user.update_attributes(params[:hmm_user])
        sql = ActiveRecord::Base.connection();
        pass=removeSymbols(params[:hmm_user][:v_password])
        sql.update "UPDATE hmm_users  SET v_password='#{pass}' WHERE id=#{params[:id]}";
        flash[:notice] = 'HmmUser was successfully updated.'
        redirect_to :action => 'edit', :id => params[:id]
      else
        render :action => 'edit', :id => params[:id]
      end
    end
  end

  def blockUblock
    @hmm_user = HmmUser.find(params[:id])
    sql = ActiveRecord::Base.connection();
    if @hmm_user.e_user_status=='unblocked'
      sql.update "UPDATE hmm_users SET e_user_status='blocked' WHERE id=#{params[:id]}";
      # @hmm_user.save
      redirect_to :action => 'list'
    else
      sql.update "UPDATE hmm_users SET e_user_status='unblocked' WHERE id=#{params[:id]}";
      # @hmm_user.save
      redirect_to :action => 'list'
    end
  end

  def customerReport
    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked'")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked'")
    #@hmm_user_pages, @hmm_user = paginate :hmm_users , :order => sort, :per_page => items_per_page, :conditions => "subchapter_id  =#{params[:id]} and status='active' #{e_access}" ,:order => sort

  end

  def customerReport_exe
    # @hmm_user=HmmUser.count_by_sql("select * from hmm_users where v_user_name='#{params[:user][:username]}' and v_fname='#{params[:user][:firstname]}'  ");
    @hmmuser_count=HmmUser.count(:all, :conditions => "v_user_name='#{params[:user][:username]}' and v_fname='#{params[:user][:firstname]}' and v_zip='#{params[:user][:zip]}' " )
    @hmm_users=HmmUser.find(:all, :conditions => "v_user_name='#{params[:user][:username]}' and v_fname='#{params[:user][:firstname]}' and v_zip='#{params[:user][:zip]}' " )

  end

  def guestReport
    puts params[:from_bdate]

    if (params[:from_bdate]!=nil && params[:to_bdate] !=nil)

      from_yr=params[:from_bdate]['ordermonthdayyear(1i)']
      from_mon=params[:from_bdate]['ordermonthdayyear(2i)']
      from_date=params[:from_bdate]['ordermonthdayyear(3i)']

      fromdate="#{from_yr}-#{from_mon}-#{from_date}"
      #fromdate.strftime("%b #{fromdate} %Y   %I:%M %p")
      to_yr=params[:to_bdate]['ordermonthdayyear(1i)']
      to_mon=params[:to_bdate]['ordermonthdayyear(2i)']
      to_date=params[:to_bdate]['ordermonthdayyear(3i)']
      todate="#{to_yr}-#{to_mon}-#{to_date}"
      params[:from_bdate]['ordermonthdayyear(1i)']
      condition= "and created_date between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
      # condit= "and d_created_on and e_approval='approve' between '#{fromdate}' and '#{todate}' "
      cond= "and Visited_date between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
      cond_exp= "and Visited_date between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
    end
    @guest_visited = Share.count(:all, :conditions => "id!='' #{cond}")
    @guest_create = Share.count(:all, :conditions => "id!='' #{condition}")
    @guest_expire = Share.count(:all, :conditions => "id!='' #{cond_exp}")
    if request.xml_http_request?
      render :partial => "guest", :layout => false
    end
  end

  def guestSearch
    @share_count = Share.count(:all, :conditions => "email_list ='#{params[:guest][:email]}' and guest_name ='#{params[:guest][:name]}'")
    @share = Share.find(:all, :conditions => "email_list ='#{params[:guest][:email]}' and guest_name ='#{params[:guest][:name]}'")
  end

  def showGuest
    @share = Share.find(params[:id])
    render(:layout => false)
  end

  def editGuest
    @guest = Share.find(params[:id])
    render(:layout => false)
  end

  def updateGuest
    @guest = Share.find(params[:id])
    if @guest.update_attributes(params[:shares ])
      flash[:notice] = 'HmmUser was successfully updated!!'
      render :action => 'show', :id => @hmm_user
    else
      render :action => 'edit'
    end
  end

  def statReport
    @stat_imag = UserContent.count(:all, :conditions => "e_filetype='image'")
    @stat_video = UserContent.count(:all, :conditions => "e_filetype='VIDEO'")
    @stat_audio = UserContent.count(:all, :conditions => "e_filetype='AUDIO'")
    #@hmmuser_stat = HmmUser.find(:joins=>"as b , user_contents as a ", :conditions => "b.id=a.uid and a.e_filetype='image'")
    if (params[:from_bdate]!=nil && params[:to_bdate] !=nil)

      from_yr=params[:from_bdate]['ordermonthdayyear(1i)']
      from_mon=params[:from_bdate]['ordermonthdayyear(2i)']
      from_date=params[:from_bdate]['ordermonthdayyear(3i)']

      fromdate="#{from_yr}-#{from_mon}-#{from_date}"

      to_yr=params[:to_bdate]['ordermonthdayyear(1i)']
      to_mon=params[:to_bdate]['ordermonthdayyear(2i)']
      to_date=params[:to_bdate]['ordermonthdayyear(3i)']
      todate="#{to_yr}-#{to_mon}-#{to_date}"

      condition= "and d_createddate between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
      # condit= "and d_created_on and e_approval='approve' between '#{fromdate}' and '#{todate}' "
      cond= "and d_createddate between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "

    end
    #@photo_cnt = ChapterComment.count(:conditions => "id!='' #{condition}")
    @photo_cnt = UserContent.count(:all, :conditions => "e_filetype='image'  and id!='' #{cond}")
    @video_cnt = UserContent.count(:all, :conditions => "e_filetype='VIDEO' and id!='' #{condition}")
    @audio_cnt = UserContent.count(:all, :conditions => "e_filetype='AUDIO' and id!='' #{condition}")
    if request.xml_http_request?
      render :partial => "statrep", :layout => false
    end
  end

  def chapstatReport
    @chap_stat = Tag.count
    @sub_stat = SubChapter.count
    @gal_stat = Galleries.count
    @total_stat = (@chap_stat + @sub_stat + @gal_stat)
    if (params[:from_bdate]!=nil && params[:to_bdate] !=nil)

      from_yr=params[:from_bdate]['ordermonthdayyearstart_year1909(1i)']
      from_mon=params[:from_bdate]['ordermonthdayyearstart_year1909(2i)']
      from_date=params[:from_bdate]['ordermonthdayyearstart_year1909(3i)']

      fromdate=from_yr+'-'+from_mon+'-'+from_date

      to_yr=params[:to_bdate]['ordermonthdayyearstart_year1909(1i)']
      to_mon=params[:to_bdate]['ordermonthdayyearstart_year1909(2i)']
      to_date=params[:to_bdate]['ordermonthdayyearstart_year1909(3i)']
      todate=to_yr+'-'+to_mon+'-'+to_date
      params[:from_bdate]['ordermonthdayyearstart_year1909(1i)']
      #condition= "and d_created_on  between '#{fromdate}' and '#{todate}' "
      # condit= "and d_created_on and e_approval='approve' between '#{fromdate}' and '#{todate}' "
      cond= "and d_createddate  between '#{fromdate}' and '#{todate}' "

      #(:all, :conditions => " id!='' #{cond} ")
      #@tags_pages, @tags = paginate :tags, :per_page => 10, :joins => "as a," :conditions => " id!='' #{cond} ", :order => " d_date_time  desc "
    end
    @tags = Tag.paginate :per_page => 10, :page => params[:page], :conditions => " id!='' #{cond} ", :order => " d_createddate  desc "
  end

  def chapReport
    @chap_stat = Tag.count
    @sub_stat = SubChapter.count
    @gal_stat = Galleries.count
    if (params[:from_bdate]!=nil && params[:to_bdate] !=nil)

      from_yr=params[:from_bdate]['ordermonthdayyear(1i)']
      from_mon=params[:from_bdate]['ordermonthdayyear(2i)']
      from_date=params[:from_bdate]['ordermonthdayyear(3i)']

      fromdate="#{from_yr}-#{from_mon}-#{from_date}"

      to_yr=params[:to_bdate]['ordermonthdayyear(1i)']
      to_mon=params[:to_bdate]['ordermonthdayyear(2i)']
      to_date=params[:to_bdate]['ordermonthdayyear(3i)']
      todate=to_yr+'-'+to_mon+'-'+to_date
      params[:from_bdate]['ordermonthdayyear(1i)']
      condition= "and d_createddate  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
      # condit= "and d_created_on and e_approval='approve' between '#{fromdate}' and '#{todate}' "
      cond= "and d_created_on  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
      cond1= "and d_gallery_date  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "

    end
    @cond_chap = Tag.count(:conditions => " id!='' #{condition} ")
    # @chap_condit = ChapterComment.count(:conditions => " id!='' #{condit} ")

    @cond_sub = SubChapter.count(:conditions => " id!='' #{cond} ")
    @cond_gal = Galleries.count(:conditions => " id!='' #{cond1} ")


    @allcomment_count = (@cond_chap + @cond_sub + @cond_gal )
    #@allcomment_count = ChapterComment.count(:joins => "as a, subchap_comments as b, gallery_comments as c, photo_comments as d")
    #@chapter_comments_pages, @chapter_commentss = paginate :chapter_commentss,  :per_page => 10, :conditions => " id!='' #{condition} ", :order => " d_date_time  desc "
    if request.xml_http_request?
      render :partial => "statchap", :layout => false
    end
  end

  def commentReport
    @chapcomment_count = ChapterComment.count
    @chapcomment_count_rej = ChapterComment.count(:all, :conditions => "e_approval='reject'")
    @chapcomment_count_app = ChapterComment.count(:all, :conditions => "e_approval='approve'")
    @chapcomment_count_pen = ChapterComment.count(:all, :conditions => "e_approval='pending'")
    @subComment_count = SubchapComment.count
    @subcomment_count_rej = SubchapComment.count(:all, :conditions => "e_approval='reject'")
    @subcomment_count_app = SubchapComment.count(:all, :conditions => "e_approval='approve'")
    @subcomment_count_pen = SubchapComment.count(:all, :conditions => "e_approval='pending'")
    @galComment_count = GalleryComment.count
    @galcomment_count_rej = GalleryComment.count(:all, :conditions => "e_approval='reject'")
    @galcomment_count_app = GalleryComment.count(:all, :conditions => "e_approval='approve'")
    @galcomment_count_pen = GalleryComment.count(:all, :conditions => "e_approval='pending'")
    @momComment_count = PhotoComment.count
    @momcomment_count_rej = PhotoComment.count(:all, :conditions => "e_approved='reject'")
    @momcomment_count_app = PhotoComment.count(:all, :conditions => "e_approved='approve'")
    @momcomment_count_pen = PhotoComment.count(:all, :conditions => "e_approved='pending'")

    if (params[:from_bdate]!=nil && params[:to_bdate] !=nil)

      from_yr=params[:from_bdate]['ordermonthdayyear(1i)']
      from_mon=params[:from_bdate]['ordermonthdayyear(2i)']
      from_date=params[:from_bdate]['ordermonthdayyear(3i)']

      fromdate="#{from_yr}-#{from_mon}-#{from_date}"

      to_yr=params[:to_bdate]['ordermonthdayyear(1i)']
      to_mon=params[:to_bdate]['ordermonthdayyear(2i)']
      to_date=params[:to_bdate]['ordermonthdayyear(3i)']
      # todate=to_yr+'-'+to_mon+'-'+to_date
      todate="#{to_yr}-#{to_mon}-#{to_date}"
      params[:from_bdate]['ordermonthdayyear(1i)']
      condition= "and d_created_on  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
      # condit= "and d_created_on and e_approval='approve' between '#{fromdate}' and '#{todate}' "
      cond= "and d_add_date  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59 '  "

    end
    @cond_chap = ChapterComment.count(:conditions => " id!='' #{condition} ")
    # @chap_condit = ChapterComment.count(:conditions => " id!='' #{condit} ")
    @cond_chap_app = ChapterComment.count(:conditions => "e_approval='approve' and id!='' #{condition} ")
    @cond_chap_rej = ChapterComment.count(:conditions => "e_approval='reject' and id!='' #{condition} ")
    @cond_chap_pen = ChapterComment.count(:conditions => "e_approval='pending' and id!='' #{condition} ")
    @cond_sub = SubchapComment.count(:conditions => " id!='' #{condition} ")
    @cond_sub_app = SubchapComment.count(:conditions => "e_approval='approve' and id!='' #{condition} ")
    @cond_sub_rej = SubchapComment.count(:conditions => "e_approval='reject' and id!='' #{condition} ")
    @cond_sub_pen = SubchapComment.count(:conditions => "e_approval='pending' and id!='' #{condition} ")
    @cond_gal = GalleryComment.count(:conditions => " id!='' #{condition} ")
    @cond_gal_app = GalleryComment.count(:conditions => "e_approval='approve' and id!='' #{condition} ")
    @cond_gal_rej = GalleryComment.count(:conditions => "e_approval='reject' and id!='' #{condition} ")
    @cond_gal_pen = GalleryComment.count(:conditions => "e_approval='pending' and id!='' #{condition} ")
    @cond_moment = PhotoComment.count(:conditions => " id!='' #{cond} ")
    @cond_mom_app = PhotoComment.count(:conditions => "e_approved='approve' and id!='' #{cond} ")
    @cond_mom_rej = PhotoComment.count(:conditions => "e_approved='reject' and id!='' #{cond} ")
    @cond_mom_pen = PhotoComment.count(:conditions => "e_approved='pending' and id!='' #{cond} ")

    @allcomment_count = (@chapcomment_count + @subComment_count + @galComment_count + @momComment_count)
    #@allcomment_count = ChapterComment.count(:joins => "as a, subchap_comments as b, gallery_comments as c, photo_comments as d")
    #@chapter_comments_pages, @chapter_commentss = paginate :chapter_commentss,  :per_page => 10, :conditions => " id!='' #{condition} ", :order => " d_date_time  desc "
    if request.xml_http_request?
      render :partial => "comntrep", :layout => false
    end
  end

  def change_password

  end

  def chg_password_execute
    sql = ActiveRecord::Base.connection();
    if(params[:pass][:old]!='')
      self.encrypt('#{params[:pass][:old]}')
      chk = User.count(:all, :conditions => "id=#{logged_in_user.id} and hashed_password='#{params[:pass][:old]}'")
      if(chk > 0)
        sql.update "UPDATE users SET hashed_password='#{params[:pass][:confirm]}' WHERE id=#{logged_in_user.id}";
        flash[:notice] = "Your password has been changed sucessfully."
        render :action => 'change_password'

      else
        flash[:notice] = "Invalid Current password. Please try again"
        render :action => 'change_password'
      end
    end

  end

  def sessionReport
    @orginal_fdate=params[:from_bdate]
    @orginal_tdate=params[:to_bdate]
    if (params[:from_bdate]!=nil && params[:to_bdate] !=nil)


      @from_yr=params[:from_bdate]['ordermonthdayyearstart_year1909(1i)']
      @from_mon=params[:from_bdate]['ordermonthdayyearstart_year1909(2i)']
      @from_date=params[:from_bdate]['ordermonthdayyearstart_year1909(3i)']

      @fromdate=@from_yr+'-'+@from_mon+'-'+@from_date

      @to_yr=params[:to_bdate]['ordermonthdayyearstart_year1909(1i)']
      @to_mon=params[:to_bdate]['ordermonthdayyearstart_year1909(2i)']
      @to_date=params[:to_bdate]['ordermonthdayyearstart_year1909(3i)']
      @todate=@to_yr+'-'+@to_mon+'-'+@to_date
      params[:from_bdate]['ordermonthdayyearstart_year1909(1i)']
      condition= "and b.d_date_time between '#{@fromdate} 00:00:00' and '#{@todate} 23:59:59' "
    end
    #@sessions = UserSessions.count(:joins => " as a, LEFT JOIN hmm_users b", :conditions => "id!='' #{condition}" )
    @count1 = UserSessions.count(:all,:joins => 'as b' ,:conditions => "b.id!='' #{condition}")
    @site_result=HmmUser.find_by_sql("select ((count(*)/#{@count1})*100) as total  from hmm_users " )
    @query = "SELECT a.id as id1,a.v_user_name, count( * ) AS cnt, (count(b.uid)/#{@count1}*100) as avga, b.v_user_name AS un
                FROM hmm_users a
                LEFT JOIN user_sessions b ON a.v_user_name = b.v_user_name #{condition} GROUP BY b.uid  order by avga desc"

    mynum = params[:page] || 0
    items_per_page = 5
    @count_query = HmmUser.count
    @page = @count_query/items_per_page

    @next = Integer(mynum)+1
    @prev = Integer(mynum)-1
    num= Integer(mynum)
    number =num*items_per_page
    @query+=" LIMIT "+String(number)+","+String(items_per_page)

    @session = HmmUser.find_by_sql(@query)
    #@session = HmmUser.find(:all, :join => "as a, user_sessions as b", :select => "a.v_user_name, count (*) as b.cnt")
    #@sessions = HmmUser.find(:all, :joins => " as a, LEFT JOIN user_sessions b", :select => "a.v_user_name, count(*) as cnt, b.v_user_name as un", :conditions => "a.v_user_name = b.v_user_name", :group => 'a.v_user_name' )
    #@user_sessions_pages, @user_sessionss = paginate :user_sessionss,  :per_page => 5, :conditions => " id!='' #{condition} ", :order => " d_date_time  desc "
  end





  def login_report

    sort_init 'id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="id  desc"
    end

    if (params[:fyy]!=nil && params[:fmm] !=nil && params[:fdd] !=nil && params[:tyy] !=nil && params[:tmm] !=nil && params[:tdd] !=nil)

      #from_yr=params[:from_bdate]['start_year1910ordermonthdayyear(1i)']
      #from_mon=params[:from_bdate]['start_year1910ordermonthdayyear(2i)']
      #from_date=params[:from_bdate]['start_year1910ordermonthdayyear(3i)']

      from_yr=params[:fyy]
      from_mon=params[:fmm]
      from_date=params[:fdd]

      fromdate="#{from_yr}-#{from_mon}-#{from_date}"

      #to_yr=params[:to_bdate]['start_year1910ordermonthdayyear(1i)']
      #to_mon=params[:to_bdate]['start_year1910ordermonthdayyear(2i)']
      #to_date=params[:to_bdate]['start_year1910ordermonthdayyear(3i)']

      to_yr=params[:tyy]
      to_mon=params[:tmm]
      to_date=params[:tdd]


      todate="#{to_yr}-#{to_mon}-#{to_date}"

      #params[:from_bdate]['ordermonthdayyearstart_year1909(1i)']
      session[:condition1]= "and d_date_time  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
    end
    if params[:username]
      session[:condition2]=" and v_user_name like '#{params[:username]}%' "
    end
    unless params[:cpg]==nil
      session[:condition]=""
      session[:condition1]=""
      session[:condition2]=""
    else
      session[:condition]="#{session[:condition1]} #{session[:condition2]}"
    end

    @user_sessionss = UserSessions.paginate :per_page => 50, :page => params[:page], :conditions => " id!='' #{session[:condition]} ", :order => sort
    #  @sub_chapters_pages, @sub_chapters = paginate :sub_chapters ,  :per_page => items_per_page, :conditions => "tagid=#{params[:id]} and status='active' #{e_access}", :order => sort #:order => " #{@sort.to_s} #{@order.to_s} "

  end

  def faq
    @faqs = Faq.paginate :per_page => 10, :page => params[:page]
  end

  def tipsManage

  end

  def feedback
    Emergencymailer.deliver_feedback(params[:urname], params[:uremail] , params[:urcomment])
    Emergencymailer.deliver_thankyou(params[:urname], params[:uremail] , params[:urcomment])
    render :action => 'thankyou', :layout => false
  end

  def thankyou
    render(:layout => false)
  end


  def statistic_report
    if(session[:friend]!='')
      uid=session[:friend]
    else
      uid=logged_in_hmm_user.id
    end
    items_per_page = 1
    sort = case params['sort']
    when "username"  then "v_fname"
    when "username_reverse"  then "v_fname DESC"
    end
    if (params[:query].nil?)
      params[:query]=""
    else
      conditions = "b.v_fname LIKE '%#{params[:query]}%'"
    end
    if (params[:query1].nil?)
      params[:query1]=""
    else
      conditions =" b.v_fname LIKE '#{params[:query1]}%'"
    end

    if (params[:query_hmm_user]!=nil && params[:query_hmm_user1] !=nil)
      puts "fewfwefew"
      from_yr=params[:query_hmm_user]['ordermonthdayyearstart_year1909(1i)']
      from_mon=params[:query_hmm_user]['ordermonthdayyearstart_year1909(2i)']
      from_date=params[:query_hmm_user]['ordermonthdayyearstart_year1909(3i)']

      fromdate=from_yr+"-"+""+from_mon+"-"+from_date

      frm=fromdate.split("(1i)")
      if(frm[0]=="ordermonthdayyearstart_year1909")
        fromdate=session['fromdate']
      else
        session['fromdate']=fromdate
      end
      to_yr=params[:query_hmm_user1]['ordermonthdayyearstart_year1909(1i)']
      to_mon=params[:query_hmm_user1]['ordermonthdayyearstart_year1909(2i)']
      to_date=params[:query_hmm_user1]['ordermonthdayyearstart_year1909(3i)']

      todate=to_yr+"-"+to_mon+"-"+to_date

      tdt=todate.split("(1i)")
      if(tdt[0]=="ordermonthdayyearstart_year1909")
        todate=session['todate']
      else
        session['fromdate']=todate
      end





    else


    end





    if (params[:query_hmm_user].nil?)
      params[:query_hmm_user]=""
    else
      conditions = "id!=0 and d_created_date between '#{fromdate}' and '#{todate}' "
      @total = HmmUser.count(:conditions =>conditions)
      @hmm_users = HmmUser.paginate :per_page => items_per_page, :page => params[:page], :select => "*",  :order => sort,
        :conditions => conditions

    end

    if( params[:query]=="" && params[:query1]=="" && params[:query_hmm_user] =="" )
      @total = HmmUser.count(:joins=>"as b  ", :conditions =>  "b.id!=0 " )
      @hmm_users = Hmmuser.paginate :per_page => items_per_page, :page => params[:page] ,:joins=>"as b  ", :order => sort,
        :conditions => "b.id!=0"
    else
      flag=1
      #        @total = HmmUser.count(:conditions => conditions )
      #        @hmm_users_pages, @hmm_users = paginate :hmm_users , :select => "id as fid, v_myimage, v_fname",  :order => sort, :per_page => items_per_page,
      #        #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && b.v_fname LIKE '%#{params[:query]}%'"
      #        :conditions => conditions
      if(params[:query_hmm_user]!="")
      else
        @total = HmmUser.count(:joins=>"as b  ", :conditions =>  " LIKE '%#{params[:query]}%'")
        @hmm_users = Hmmuser.paginate :per_page => items_per_page, :page => params[:page] ,:joins=>"as b ", :order => sort,
          #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && a.status='accepted'"
        #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && b.v_fnameq LIKE '%#{params[:query]}%'"
        :conditions => conditions
      end
    end
    @fnf_groups_index = FnfGroups.find(:all,:conditions=>"uid=1",:order=>"id DESC")

    if request.xml_http_request?
      render :partial => "statistic_list", :layout => false
    end
  end

  def nice_date(date)
    h date.strftime("%Y-%m-%d")
  end


  def fnf_index
    if(session[:friend]!='')
      uid=1
    else
      uid=1
    end
    items_per_page = 12
    sort = case params['sort']
    when "username"  then "v_fname"
    when "username_reverse"  then "v_fname DESC"
    end

    if (params[:query_hmm_user]!=nil && params[:query_hmm_user1] !=nil && params[:page]==nil || params[:page]=='nil')

      from_yr=params[:query_hmm_user]['ordermonthdayyear(1i)']
      from_mon=params[:query_hmm_user]['ordermonthdayyear(2i)']
      from_date=params[:query_hmm_user]['ordermonthdayyear(3i)']

      fromdate=from_yr+"-"+""+from_mon+"-"+from_date

      frm=fromdate.split("(1i)")
      if(frm[0]=="ordermonthdayyear")
        fromdate=session['fromdate']
      else
        session['fromdate']=fromdate
      end
      to_yr=params[:query_hmm_user1]['ordermonthdayyear(1i)']
      to_mon=params[:query_hmm_user1]['ordermonthdayyear(2i)']
      to_date=params[:query_hmm_user1]['ordermonthdayyear(3i)']

      todate=to_yr+"-"+to_mon+"-"+to_date

      tdt=todate.split("(1i)")
      if(tdt[0]=="ordermonthdayyear")
        todate=session['todate']
      else
        session['todate']=todate
      end
    else
      fromdate=session['fromdate']
      todate=session['todate']
    end

    if (params[:query_hmm_user]==nil && params[:query_hmm_user1] ==nil )
      session['fromdate']=''
      session['todate']=''
    end
    if (params[:query].nil?)
      params[:query]=""
    else
      conditions = "a.uid=1 && b.id=a.fid && a.block_status='unblock' && a.status='accepted' && b.v_fname LIKE '%#{params[:query]}%'"
    end
    if (params[:query1].nil?)
      params[:query1]=""
    else
      conditions ="a.uid=1 && b.id=a.fid && a.block_status='unblock' && a.status='accepted' && b.v_fname LIKE '#{params[:query1]}%'"
    end


    if (params[:query_hmm_user].nil?)
      params[:query_hmm_user]=""
    else
      conditions = "id!=0 and d_created_date between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
      @total = HmmUser.count(:conditions =>conditions)
      @hmm_users = HmmUser.paginate :per_page => items_per_page, :page => params[:page], :select => "*",  :order => 'id desc',
        :conditions => conditions

    end

    if( params[:query]=="" && params[:query1]=="" && params[:query_hmm_user] =="" )
      @total = HmmUser.count(:joins=>"as b  ", :conditions =>  "b.id!=0 " )
      @hmm_users = HmmUser.paginate :per_page => items_per_page, :page =>params[:page],:joins=>"as b  ", :select =>"*", :order => 'id desc',
        :conditions => "b.id!=0"
    else
      flag=1
      #        @total = HmmUser.count(:conditions => conditions )
      #        @hmm_users_pages, @hmm_users = paginate :hmm_users , :select => "id as fid, v_myimage, v_fname",  :order => sort, :per_page => items_per_page,
      #        #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && b.v_fname LIKE '%#{params[:query]}%'"
      #        :conditions => conditions
      if(params[:query_hmm_user]!="")
      else
        @total = HmmUser.count(:joins=>"as b  ", :conditions =>  " LIKE '%#{params[:query]}%'")
        @hmm_users = HmmUser.paginate :per_page => items_per_page, :page =>params[:page] ,:joins=>"as b ", :select =>"*", :order => sort,
          #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && a.status='accepted'"
        #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && b.v_fnameq LIKE '%#{params[:query]}%'"
        :conditions => conditions
      end
    end
    @fnf_groups_index = FnfGroups.find(:all,:conditions=>"uid=1",:order=>"id DESC")

    if request.xml_http_request?
      render :partial => "fnf_list", :layout => false
    end
  end


  def fnf_index1

    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="statisticalreport.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end
    if(session[:friend]!='')

      uid=1
    else
      uid=1
    end
    items_per_page = 10
    sort = case params['sort']
    when "username"  then "v_fname"
    when "username_reverse"  then "v_fname DESC"
    end




    if (params[:frmdate].nil? && params[:todate].nil?)
      @frmdate=''
      @todate=''
      items_per_page = HmmUser.count(:all , :conditions => " id !=0")
      @hmm_users_pages, @hmm_users = paginate :hmm_users , :select => "*",  :order => 'id desc', :per_page => items_per_page

    else
      @frmdate=params[:frmdate]
      @todate=params[:todate]
      items_per_page = HmmUser.count(:all, :conditions => " id!=0 and d_created_date between '#{@frmdate} 00:00:00' and '#{@todate} 23:59:59'")
      conditions = "id!=0 and d_created_date between '#{@frmdate} 00:00:00' and '#{@todate} 23:59:59' "
      @total = HmmUser.count(:conditions =>conditions)
      begin
        @hmm_users_pages, @hmm_users = paginate :hmm_users , :select => "*",  :order => 'id desc', :per_page => items_per_page,
          :conditions => conditions
      rescue
        logger.info("un able to fetch records")
      end
    end

    if( params[:query]=="" && params[:query1]=="" && params[:query_hmm_user] =="" )
      begin
        @hmm_users_pages, @hmm_users = paginate :hmm_users ,:joins=>"as b  ", :order => 'id desc', :per_page => items_per_page,
          :conditions => "b.id!=0"
      rescue
        logger.info("unable to fetch all records from table")
      end
    else
      flag=1
      #        @total = HmmUser.count(:conditions => conditions )
      #        @hmm_users_pages, @hmm_users = paginate :hmm_users , :select => "id as fid, v_myimage, v_fname",  :order => sort, :per_page => items_per_page,
      #        #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && b.v_fname LIKE '%#{params[:query]}%'"
      #        :conditions => conditions

    end
    @fnf_groups_index = FnfGroups.find(:all,:conditions=>"uid=1",:order=>"id DESC")

    if request.xml_http_request?
      render :partial => "fnf_list", :layout => false
    end
    render :layout => false

    #!/usr/bin/env ruby



    #require File.dirname(__FILE__) + '/../config/environment'
    #require "spreadsheet/excel"
    #
    #
    #
    #  file = "ewfwewe_sales_leads.xls"
    #  workbook = Spreadsheet::Excel.new("#{RAILS_ROOT}/public/#{file}")
    #
    #  worksheet = workbook.add_worksheet("Sales Leads")
    #  worksheet.write(0, 0, "Customer name")
    #  worksheet.write(0, 1, "Email")
    #
    #@orders = HmmUser.find(:all)
    #  row = 1
    #  @orders.each do |order|
    #    worksheet.write(row, 0, "#{order.v_fname} #{order.v_lname}")
    #    worksheet.write(row, 1, "#{order.v_e_mail}")
    #
    #    row += 1
    #  end
    #
    #  workbook.close

    #OrderMailer.deliver_sales_leads(operator.report_email_address_to, operator.report_email_address_cc, operator.site, operator.city)




  end


  def my_customers
    employe=EmployeAccount.find(session[:employe])

    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and emp_id=#{session[:employe]}")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and emp_id=#{session[:employe]}")
    sort_init 'id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="id  desc"
    end

    @hmm_users = HmmUser.paginate(:select => "*", :conditions => "emp_id=#{session[:employe]}", :per_page => 10, :page => params[:page])

    render :layout => true
  end

  def studio_all_members
    employe=EmployeAccount.find(session[:employe])

    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and studio_id='#{employe.store_id}'")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and studio_id='#{employe.store_id}'")
    sort_init 'id'
    sort_update

    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="id  desc"
    end

    @hmm_users = HmmUser.paginate(:select => "*", :conditions => "studio_id='#{employe.store_id}'", :per_page => 10, :page => params[:page])

    render :layout => true
  end

  def mycustomer_search
    sort_init 'id'
    sort_update
    employe=EmployeAccount.find(session[:employe])
    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and emp_id=#{session[:employe]} ")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and emp_id=#{session[:employe]}")

    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
    else
      @uname=params[:username]
      if(@uname!="" && params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%' "
      end

      @email=params[:email]
      if(@email!="" && params[:email]!=nil)
        emailcondition="and v_e_mail like '#{@email}%' "
      end

      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end

      @email=params[:email]
      if(@email!="" && params[:email]!=nil)
        emailcondition="and v_e_mail like '#{@email}%' "
      end

      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%' "
      end

      @country=params[:v_country]
      @zip=params[:zip]

      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end

    end

    if params[:sort_key]==nil && params[:sort_order]==nil
      @srk="id  desc"
    else

      @sort_key=params[:sort_key]



      @order=params[:sort_order]
    end
    puts @sort_key
    puts @order
    @srk="#{@sort_key}"+" "+"#{@order}"
    if( @srk==nil || @srk=="" )
      @srk="id  desc"
    end
    puts @srk

    @hmm_users = (HmmUser.paginate  :per_page => 10, :page => params[:page], :conditions =>"id!='' and emp_id=#{session[:employe]} #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}", :order =>  @srk )

    render :layout => true
  end

  def studio_all_members_search
    sort_init 'id'
    sort_update
    employe=EmployeAccount.find(session[:employe])
    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and studio_id='#{employe.store_id}' ")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and studio_id='#{employe.store_id}'")

    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
    else
      @uname=params[:username]
      if(@uname!="" && params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%' "
      end

      @email=params[:email]
      if(@email!="" && params[:email]!=nil)
        emailcondition="and v_e_mail like '#{@email}%' "
      end

      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end

      @email=params[:email]
      if(@email!="" && params[:email]!=nil)
        emailcondition="and v_e_mail like '#{@email}%' "
      end

      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%' "
      end

      @country=params[:v_country]
      @zip=params[:zip]

      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end

    end

    if params[:sort_key]==nil && params[:sort_order]==nil
      @srk="id  desc"
    else

      @sort_key=params[:sort_key]



      @order=params[:sort_order]
    end
    puts @sort_key
    puts @order
    @srk="#{@sort_key}"+" "+"#{@order}"
    if( @srk==nil || @srk=="" )
      @srk="id  desc"
    end
    puts @srk

    @hmm_users = (HmmUser.paginate  :per_page => 10, :page => params[:page], :conditions =>"id!='' and studio_id='#{employe.store_id}' #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}", :order =>  @srk )

    render :layout => true
  end

  def premium_users
    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and emp_id=#{session[:employe]} and account_type='platinum_user'")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and emp_id=#{session[:employe]} and account_type='platinum_user'")
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

    @hmm_users = (HmmUser.paginate  :per_page => 10, :page => params[:page], :select => "*", :conditions => "emp_id=#{session[:employe]} and account_type='platinum_user'", :order => sort)

    render :layout => true
  end

  def my_customers
    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and emp_id=#{session[:employe]} and account_type='platinum_user'")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and emp_id=#{session[:employe]} and account_type='platinum_user'")
    sort_init 'id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="id  desc"
    end

    @hmm_users = HmmUser.paginate :per_page => 10, :page => params[:page], :select => "*", :conditions => "emp_id=#{session[:employe]}", :order => sort

    render :layout => true
  end

  def studio_customers_report
    sort_init 'id'
    sort_update
    @studio_ids = Array.new
    @studio_ids << "("

    #edited to show studio customer report for the marketting manager
    selectedstudio =""

    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil && params[:studios] == nil )

      if session[:selected_studio]
        selectedstudio = "and  studio_id = #{session[:selected_studio]} "
      else
        selectedstudio = ""
      end
    else
      @uname=params[:username]
      if(@uname!="" && params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%' "
      end

      @email=params[:email]
      if(@email!="" && params[:email]!=nil)
        emailcondition="and v_e_mail like '#{@email}%' "
      end

      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end

      @email=params[:email]
      if(@email!="" && params[:email]!=nil)
        emailcondition="and v_e_mail like '#{@email}%' "
      end

      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%' "
      end

      @country=params[:v_country]
      @zip=params[:zip]

      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end
      #      @selected_studio = params[:studios]

      if(params[:studios] !="Select"  && params[:studios]!=nil )
        selectedstudio = "and  studio_id = #{params[:studios]} "
        session[:selected_studio] = params[:studios]
      else
        selectedstudio = ""
        session[:selected_studio] = nil
      end

    end
    if session[:employe] # showing customer reports for the employee

      @employee = EmployeAccount.find(session[:employe])
      @studio_ids << @employee.store_id.to_s

    elsif session[:manager]

      @manager = MarketManager.find(session[:manager])
      @branch_manager = ManagerBranche.find(:first, :conditions=> ["manager_id = #{@manager.id}"])

      if @branch_manager == nil
        return
      else
        @studio = HmmStudio.find(:first, :conditions => ["id = #{@branch_manager.branch_id}  AND status = 'active'"])
        @studios = HmmStudio.find(:all, :conditions => ["studio_groupid = #{@studio.studio_groupid} AND status = 'active' "])
        @studios.each_with_index do |manager, idx| #to make sql IN class work we have to add ',' for all array elements
          if idx == (@studios.length-1)
            @studio_ids << manager.id.to_s
          else
            @studio_ids << manager.id.to_s + ", "
          end
        end
      end
    end
    #

    if params[:sort_key]==nil && params[:sort_order]==nil
      @srk="id  desc"
    else
      @sort_key=params[:sort_key]
      @order=params[:sort_order]
    end
    puts @sort_key
    puts @order
    @srk="#{@sort_key}"+" "+"#{@order}"
    if( @srk==nil || @srk=="" )
      @srk="id  desc"
    end
    puts @srk
    #@hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and studio_id = #{@employee.store_id} #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}")
    #@hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and studio_id=#{@employee.store_id}  #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}")

    @studio_ids << ")"

    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and studio_id IN #{@studio_ids} #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and studio_id IN #{@studio_ids} #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}")

    sort_init 'id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="id  desc"
    end

    @hmm_users = HmmUser.paginate :per_page => 10, :page => params[:page],:joins=>"as a,hmm_studios as b", :select => "a.*,b.studio_name", :conditions => "a.studio_id=b.id and b.status='active' and studio_id IN #{@studio_ids} #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition} #{selectedstudio}", :group=>"a.id",:order => sort
    render :layout => true

  end



  def studio_premium_customers_report
    sort_init 'id'
    sort_update
    @employee = EmployeAccount.find(session[:employe])
    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
    else
      @uname=params[:username]
      if(@uname!="" && params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%' "
      end

      @email=params[:email]
      if(@email!="" && params[:email]!=nil)
        emailcondition="and v_e_mail like '#{@email}%' "
      end

      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end

      @email=params[:email]
      if(@email!="" && params[:email]!=nil)
        emailcondition="and v_e_mail like '#{@email}%' "
      end

      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%' "
      end

      @country=params[:v_country]
      @zip=params[:zip]

      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end

    end

    if params[:sort_key]==nil && params[:sort_order]==nil
      @srk="id  desc"
    else
      @sort_key=params[:sort_key]
      @order=params[:sort_order]
    end
    puts @sort_key
    puts @order
    @srk="#{@sort_key}"+" "+"#{@order}"
    if( @srk==nil || @srk=="" )
      @srk="id  desc"
    end
    puts @srk
    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and account_type='platinum_user' and studio_id=#{@employee.store_id} #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and account_type='platinum_user' and studio_id=#{@employee.store_id}  #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}")
    sort_init 'id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="id  desc"
    end

    @hmm_users = HmmUser.paginate :per_page => 10, :page => params[:page], :select => "*", :conditions => "account_type='platinum_user' and studio_id=#{@employee.store_id} #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}", :order => sort

    render :layout => true
  end












  def premium_usersearch
    sort_init 'id'
    sort_update

    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and emp_id=#{session[:employe]} and account_type='platinum_user'")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and emp_id=#{session[:employe]} and account_type='platinum_user'")

    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
    else
      @uname=params[:username]
      if(@uname!="" && params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%' "
      end

      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end

      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%' "
      end

      @country=params[:v_country]
      @zip=params[:zip]

      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end

    end

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
    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
      #session[:search_cond]="#{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}"
    else
      session[:search_cond]="#{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}"
    end
    @hmm_users = (HmmUser.paginate  :per_page => 10, :page => params[:page], :conditions =>"id!='' and emp_id=#{session[:employe]} and account_type='platinum_user' #{session[:search_cond]} ", :order =>  sort )

    render :layout => true
  end


  def premium_customersearch
    sort_init 'id'
    sort_update

    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and account_type!='free_user'")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and account_type='free_user'")

    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
    else
      @uname=params[:username]
      if(@uname!="" && params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%' "
      end

      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end

      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%' "
      end

      @country=params[:v_country]
      @zip=params[:zip]

      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end

    end

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
    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
      #session[:search_cond]="#{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}"
    else
      session[:search_cond]="#{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}"
    end
    #@hmm_users = (HmmUser.paginate  :per_page => 10, :page => params[:page], :conditions =>"id!='' and account_type!='free_user' #{session[:search_cond]} ", :order =>  sort )
    @hmm_users = (HmmUser.paginate :select => "a.*,c.studio_name",:joins =>"as a ,employe_accounts as b,hmm_studios as c ",  :per_page => 10, :page => params[:page], :conditions => "a.account_type!='free_user' and b.id=a.emp_id and b.store_id=c.id #{session[:search_cond]}", :order => sort)
    render :layout => true
  end



  def premium_show
    @hmm_user = HmmUser.find(params[:id])
  end

  def contestReport
    sort_init 'v_fname'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "v_fname asc"
      else

        sort = "#{session[:srk]}  #{params[:sort_order]}"
      end
    else
      if params[:sort_key] == "id"
        params[:sort_key] = "v_fname"
      end
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end
    @search_condition = ""
    if params[:firstname] != nil && params[:firstname] != ""
      @firstname=params[:firstname]
      @search_condition = @search_condition.concat(" and v_fname='#{params[:firstname]}'")
    end
    if params[:lastname] != nil && params[:lastname] != ""
      @lastname=params[:lastname]
      @search_condition = @search_condition.concat(" and v_lname='#{params[:lastname]}'")
    end
    if params[:username] != nil && params[:username] != ""
      @username=params[:username]
      @search_condition = @search_condition.concat(" and v_user_name='#{params[:username]}'")
    end
    if params[:account_type] != nil && params[:account_type] != ""
      @account_type=params[:account_type]
      @search_condition = @search_condition.concat(" and account_type='#{params[:account_type]}'")
    end
    if params[:contest_phase] != nil && params[:contest_phase] != ""
      @contest_phase=params[:contest_phase]
      @search_condition = @search_condition.concat(" and 	contest_phase='#{params[:contest_phase]}'")
    end
    if params[:v_country] != nil && params[:v_country] != ""
      @v_country=params[:v_country]
      @search_condition = @search_condition.concat(" and 	v_country='#{params[:v_country]}'")
    end
    if params[:zip] != nil && params[:zip] != ""
      @zip=params[:zip]
      @search_condition = @search_condition.concat(" and v_zip='#{params[:zip]}'")
    end
    logger.info("  params[:sort_order]")
    logger.info( params[:sort_key])
    logger.info(  params[:sort_order])

    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil && params[:contest_phase] ==nil)
      #session[:search_cond]="#{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}"
    else
      session[:search_condition]= @search_condition
    end

    @contests= ContestDetail.find(:all)
    @hmm_users = Contest.paginate :per_page => 25, :page => params[:page], :joins=>"as a, hmm_users as b", :select =>"*,a.id as contest_id", :conditions => "a.uid=b.id #{session[:search_condition]}",   :order => sort

  end


  def contestReport_excel
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="Contest_report.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end
    if params[:contest_phase]==''
      @contest_phase="phase1"
    else
      @contest_phase=params[:contest_phase]
    end
    @hmm_users = Contest.find(:all,:joins=>"as a, hmm_users as b", :select =>"*,a.id as contest_id", :conditions => "a.uid=b.id and contest_phase='#{@contest_phase}'",   :order => "v_fname ASC")
    render :layout => false
  end

  def contests_list
    @contest_pages, @contests = paginate :contests, :per_page => 10
  end

  def review_gotskils
    @contests = Contest.paginate :per_page => 10, :page => params[:page], :conditions => "moment_type='video' and status='pending' and contest_phase='phase8'", :order => 'id desc'
    session[:redirect] = nil
  end

  def review_cutekid
    @contests = Contest.paginate :per_page => 10, :page => params[:page], :conditions => "moment_type='image' and status='pending' and contest_phase='phase8'", :order => 'id desc'
    session[:redirect] = nil
  end

  def gotskils_contetslist
    @pg_limit = 1
    @contests = Contest.paginate :per_page => 10, :page => params[:page], :conditions => "moment_type='video' and contest_phase='phase8'", :order => 'id desc'
  end

  def cutekid_contetslist
    @pg_limit = 1
    @contests = Contest.paginate :per_page => 60, :page => params[:page], :conditions => "moment_type='image' and contest_phase='phase8'", :order => 'id desc'
  end

  def holiday_contetsphotolist
    @pg_limit = 1

    @contests = Contest.paginate :per_page => 10, :page => params[:page], :conditions => "moment_type='image' and contest_phase='#{contest_phase}'", :order => 'id desc'
  end

  def holiday_contetsvideolist
    @pg_limit = 1
    @contests = Contest.paginate :per_page => 60, :page => params[:page], :conditions => "moment_type='video' and contest_phase='#{contest_phase}'", :order => 'id desc'
  end

  #contest excel report
  def photo_contest_excel
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="contestphotoreport.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end
    @contests = Contest.find(:all, :conditions => "moment_type='image' and contest_phase='#{params[:phase]}'", :order => 'id desc')
    render :layout => false

  end

  def video_contest_excel
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="contestvideoreport.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end
    @contests = Contest.find(:all, :conditions => "moment_type='video' and contest_phase='#{params[:phase]}'", :order => 'id desc')
    render :layout => false

  end


  def gotskils_moment_view
    @contests = Contest.paginate :per_page => 1, :select =>"a.*,b.*, a.id as contestid, a.status as contest_status" , :page => params[:page],:joins=>" as a , user_contents as b ", :conditions => "a.moment_id=b.id and a.moment_type='video' and a.contest_phase='#{params[:phase]}'", :order => 'a.id desc'

    #@journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{@contests[0].moment_id} ")
    @journal = Blog.find(:all, :conditions => "blog_type_id = #{@contests[0].moment_id} and user_id=#{@contests[0].uid}")
  end

  def cutekid_moment_view
    #@moment_details = UserContent.find(:all, :conditions => "id='#{params[:id]}'")
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:id]}' and contest_phase='#{params[:phase]}'")
    @contests = Contest.paginate :per_page => 1, :select =>"a.*,b.*, a.id as contestid, a.status as contest_status" , :page => params[:page],:joins=>" as a , user_contents as b ", :conditions => "a.moment_id=b.id and a.moment_type='image' and a.contest_phase='#{params[:phase]}'", :order => 'a.id desc'

    # @journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{@contests[0].moment_id} ")
    @journal = Blog.find(:all, :conditions => "blog_type_id = #{@contests[0].moment_id} and user_id=#{@contests[0].uid}")

  end

  #  def contest_approve
  #    @contest = Contest.find(params[:id])
  #    sql = ActiveRecord::Base.connection();
  #
  #
  #    sql.update "UPDATE contests SET status='active' WHERE id=#{params[:id]}";
  #    @contest_select = Contest.find(:all, :conditions => "id='#{params[:id]}'")
  #    for i in @contest_select
  #      userid = i.uid
  #      kidsname = i.first_name
  #      momentid = i.moment_id
  #      moment_type = i.moment_type
  #    end
  #    @content_url = UserContent.find(:all, :conditions => "id='#{momentid}'")
  #    @hmm_userdetails = HmmUser.find(:all, :conditions => "id='#{userid}'")
  #    for j in @hmm_userdetails
  #      fname = j.v_fname
  #      email = j.v_e_mail
  #    end
  #    Postoffice.deliver_contest_approvemail(fname,email,kidsname,momentid,moment_type,@content_url[0]['img_url'],@content_url[0]['v_filename'])
  #    # @hmm_user.save
  #    $contest_approve
  #    flash[:contest_approve] = 'contest entry has been approved'
  #    if(session['redirect']=='101')
  #      redirect_to :action => 'review_gotskils'
  #    else if(session['redirect']=='102')
  #        redirect_to :action => 'gotskils_contetslist'
  #      else if(session['redirect']=='111')
  #          redirect_to :action => 'review_cutekid'
  #        else
  #          redirect_to :action => 'cutekid_contetslist'
  #        end
  #      end
  #    end
  #  end

  def contest_approve
    @contest = Contest.find(params[:id])
    sql = ActiveRecord::Base.connection();
    paths=ContentPath.find(:first,:conditions=>"status='active'")
    sql.update "UPDATE contests SET status='active' WHERE id=#{params[:id]}";
    @contest_select = Contest.find(:all, :conditions => "id='#{params[:id]}'")
    for i in @contest_select
      userid = i.uid
      kidsname = i.first_name
      momentid = i.moment_id
      moment_type = i.moment_type
    end
    @content_url = UserContent.find(:all, :conditions => "id='#{momentid}'")
    @hmm_userdetails = HmmUser.find(:all, :conditions => "id='#{userid}'")
    for j in @hmm_userdetails
      fname = j.v_fname
      email = j.v_e_mail
    end
    Postoffice.deliver_contest_approvemail(fname,email,kidsname,momentid,moment_type,@content_url[0]['img_url'],@content_url[0]['v_filename'],paths.proxyname,params[:id])
    # @hmm_user.save
    $contest_approve
    flash[:contest_approve] = 'contest entry has been approved'
    if params[:phase] == "phase7"
      if(session['redirect']=='101')
        redirect_to :action => 'review_gotskils'
      else if(session['redirect']=='102')
          redirect_to :action => 'holiday_contetsphotolist'
        else if(session['redirect']=='111')
            redirect_to :action => 'review_cutekid'
          else
            redirect_to :action => 'holiday_contetsvideolist'
          end
        end
      end
    else
      if(session['redirect']=='101')
        redirect_to :action => 'review_gotskils'
      else if(session['redirect']=='102')
          redirect_to :action => 'gotskils_contetslist'
        else if(session['redirect']=='111')
            redirect_to :action => 'review_cutekid'
          else
            redirect_to :action => 'cutekid_contetslist'
          end
        end
      end
    end
  end

  def reject_email
    @contest = Contest.find(:all, :conditions => "id='#{params[:id]}'")
    for i in @contest
      @content_url = UserContent.find(:all, :conditions => "id='#{i.moment_id}'")
    end
  end

  def contest_reject
    @contest = Contest.find(params[:id])
    sql = ActiveRecord::Base.connection();

    sql.update "UPDATE contests SET status='inactive' WHERE id=#{params[:id]}";
    # @hmm_user.save

    @contest_select = Contest.find(:all, :conditions => "id='#{params[:id]}'")
    for i in @contest_select
      userid = i.uid
      kidsname = i.first_name
      momentid = i.moment_id
      moment_type = i.moment_type

    end
    @content_url = UserContent.find(:all, :conditions => "id='#{momentid}'")

    @hmm_userdetails = HmmUser.find(:all, :conditions => "id='#{userid}'")
    for j in @hmm_userdetails
      fname = j.v_fname
      email = j.v_e_mail
    end
    Postoffice.deliver_contest_rejectemail(fname,email,kidsname,momentid,moment_type,params[:message],@content_url[0]['img_url'],@content_url[0]['v_filename'])
    $contest_rej
    flash[:contest_rej] = 'contest entry has been rejected!'
    if params[:phase] == "phase7"
      if(session['redirect']=='101')
        redirect_to :action => 'review_gotskils'
      else if(session['redirect']=='102')
          redirect_to :action => 'holiday_contetsphotolist'
        else if(session['redirect']=='111')
            redirect_to :action => 'review_cutekid'
          else
            redirect_to :action => 'holiday_contetsvideolist'
          end
        end
      end
    else
      if(session['redirect']=='101')
        redirect_to :action => 'review_gotskils'
      else if(session['redirect']=='102')
          redirect_to :action => 'gotskils_contetslist'
        else if(session['redirect']=='111')
            redirect_to :action => 'review_cutekid'
          else
            redirect_to :action => 'cutekid_contetslist'
          end
        end
      end
    end
  end

  def contest_delete
    @contest = Contest.find(params[:id])
    sql = ActiveRecord::Base.connection();

    sql.update "DELETE from contests  WHERE id=#{params[:id]}";
    # @hmm_user.save
    $contest_rej
    flash[:contest_rej] = 'contest entry has been removed!'
    if params[:phase] == "phase7"
      if(session['redirect']=='101')
        redirect_to :action => 'review_gotskils'
      else if(session['redirect']=='102')
          redirect_to :action => 'holiday_contetsphotolist'
        else if(session['redirect']=='111')
            redirect_to :action => 'review_cutekid'
          else
            redirect_to :action => 'holiday_contetsvideolist'
          end
        end
      end
    else
      if(session['redirect']=='101')
        redirect_to :action => 'review_gotskils'
      else if(session['redirect']=='102')
          redirect_to :action => 'gotskils_contetslist'
        else if(session['redirect']=='111')
            redirect_to :action => 'review_cutekid'
          else
            redirect_to :action => 'cutekid_contetslist'
          end
        end
      end
    end
  end

  def verify_cuponID

  end

  def search_cuponID
    @cupon_result = Cupon.count(:all, :conditions => "unid='#{params[:cupon_no]}'")
    @cupon_res = Cupon.find(:all, :conditions => "unid='#{params[:cupon_no]}'")
    for i in @cupon_res
      cuponid = i.id
    end
    if @cupon_result > 0
      flash[:unid_succes] = 'Cupon Authenticated!! Please create account for the customer.'
      redirect_to :action => 'preview_cupon', :id => cuponid
    else
      flash[:unid_failed] = 'Cupon Id is not valid'
      redirect_to :action => 'verify_cuponID'
    end
  end

  def preview_cupon
    @cupon = Cupon.find(params[:id])
    @cupon_res = Cupon.count(:all, :conditions => "id='#{params[:id]}' and DATE_FORMAT(expire_date,'%Y-%m-%d') >= curdate() ")
    @cupon_res_start = Cupon.count(:all, :conditions => "id='#{params[:id]}' and DATE_FORMAT(start_date,'%Y-%m-%d') <= curdate() ")
  end

  def admin_verify_cuponID

  end

  def admin_search_cuponID
    @cupon_result = Cupon.count(:all, :conditions => "unid='#{params[:cupon_no]}'")
    @cupon_res = Cupon.find(:all, :conditions => "unid='#{params[:cupon_no]}'")
    for i in @cupon_res
      cuponid = i.id
    end
    if @cupon_result > 0
      flash[:unid_succes] = 'Cupon Authenticated!! Please create account for the customer.'
      redirect_to :action => 'admin_preview_cupon', :id => cuponid
    else
      flash[:unid_failed] = 'Cupon Id is not valid'
      redirect_to :action => 'admin_verify_cuponID'
    end
  end

  def admin_preview_cupon
    @cupon = Cupon.find(params[:id])
    @cupon_res = Cupon.count(:all, :conditions => "id='#{params[:id]}' and DATE_FORMAT(expire_date,'%Y-%m-%d') >= curdate() ")
    @cupon_res_start = Cupon.count(:all, :conditions => "id='#{params[:id]}' and DATE_FORMAT(start_date,'%Y-%m-%d') <= curdate() ")
  end


  def verify_emp
    if session[:employe]
      redirect_to :controller => 'customers', :action => 'authorise_verify'
    else
      flash[:notice_emp] = 'Please login to create customers account'
      redirect_to "https://holdmymemories.com/account/employe_login"
    end
  end

  def link_list
    sort_init 'id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="emp_id  asc"
    end
    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "account_type='platinum_user' ")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "account_type='platinum_user' and emp_id != '' ")
    @hmmuser_cnt = (@hmmuser_blockcnt - @hmmuser_unblockcnt)
    @hmmuser_premcnt= HmmUser.count(:all, :conditions => "account_type='platinum_user' and  e_user_status='unblocked'")
    @hmm_users = HmmUser.paginate :per_page => 10, :page => params[:page], :order => sort

    render :layout => true
  end

  def link_list1
    sort_init 'id'
    sort_update

    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "account_type='platinum_user' ")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "account_type='platinum_user' and emp_id != '' ")
    @hmmuser_cnt = (@hmmuser_blockcnt - @hmmuser_unblockcnt)

    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
    else
      session[:username]=params[:username]
      @uname=session[:username]
      if(@uname!="" && session[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%'"
      else
        usernamecondition=""
      end

      session[:email]=params[:email]
      @email=session[:email]
      if(@email!="" && session[:email]!=nil)
        emailcondition="and v_e_mail like '#{@email}%'"
      else
        emailcondition=""
      end

      session[:account_type]=params[:account_type]
      @acc_type=session[:account_type]
      if(@acc_type!="" && session[:account_type]!=nil && session[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}'"
      else
        acc_typecondition=""
      end

      session[:firstname]=params[:firstname]
      @fname=session[:firstname]
      if(@fname!="" && session[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      else
        firstnamenamecondition=""
      end

      session[:lastname]=params[:lastname]
      @lname=session[:lastname]
      if(@lname!="" && session[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%'"
      else
        lastnamecondition=""
      end

      session[:v_country]=params[:v_country]
      @country=session[:v_country]
      session[:zip]=params[:zip]
      @zip=session[:zip]

      if(@country=='USA' && session[:v_country]!=nil)
        if( @zip!="" && session[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        else
          countrycond=""
        end
      else
        if( @zip!="" && session[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%'"
        else
          countrycond=""
        end
      end

    end

    if params[:sort_key]==nil && params[:sort_order]==nil
      @srk="id  desc"
    else

      @sort_key=params[:sort_key]
      @order=params[:sort_order]

      @srk="#{@sort_key}"+" "+"#{@order}"

    end

    if(session[:username]!=nil || session[:lastname]!=nil || session[:firstname]!=nil || session[:v_country]!=nil ||  session[:zip]!=nil || session[:account_type]!=nil)
      session[:srchcond]="#{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}"
    else
      session[:srchcond]=""
    end

    @hmm_users = HmmUser.paginate  :per_page => 10, :page => params[:page], :conditions =>"id!=''  #{session[:srchcond]}", :order =>  @srk

    render :layout => true
  end

  def link_customer
    if params[:branch]
      #      @branchid=HmmStudio.find(:all, :conditions => "studio_name='#{params[:branch]}'")
      #      @branch_id=@branchid[0]['id']
      #      @linkemp = EmployeAccount.find(:all, :conditions => "branch='#{params[:branch]}' or store_id='#{@branch_id}'")
      @branchid=HmmStudio.find(:all, :conditions => { :id => params[:branch] })
      @branch_id=@branchid[0]['id']
      @linkemp = EmployeAccount.find(:all, :conditions => [ "id = ?", params[:branch]])
    else
      flash[:unid_failed] = 'Please Select the branch for respectively customer'
      redirect_to :action => 'link_list'
    end
  end

  def update_cus_emp
    HmmWpf.update_customer_studio(params[:id],params[:emp_name],params[:notes_to_link_customer])
    $link_success
    flash[:link_success] = 'Customer Linked to Studio sucessfully'
    redirect_to :action => 'link_list'
  end

  def pending_requests
    sort_init 'id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="cancellation_request_date desc"
    end

    @hmm_users = (HmmUser.paginate :page=>params[:page],:conditions =>"cancel_status='pending' and emp_id='#{session[:employe]}'", :per_page => 10, :order => sort )
  end

  def pending_request_search
    sort_init 'id'
    sort_update

    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and emp_id=#{session[:employe]}")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and emp_id=#{session[:employe]}")

    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
    else
      @uname=params[:username]
      if(@uname!="" && params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%' "
      end

      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end

      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%' "
      end

      @country=params[:v_country]
      @zip=params[:zip]

      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end

    end

    if params[:sort_key]==nil && params[:sort_order]==nil
      @srk="id  desc"
    else

      @sort_key=params[:sort_key]



      @order=params[:sort_order]
    end
    puts @sort_key
    puts @order
    @srk="#{@sort_key}"+" "+"#{@order}"
    if( @srk==nil || @srk=="" )
      @srk="id  desc"
    end
    puts @srk

    @hmm_user_pages, @hmm_users = (paginate :hmm_users, :conditions =>"cancel_status='pending' and emp_id=#{session[:employe]} #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}", :per_page => 10, :order =>  @srk )

    render :layout => true
  end


  def platinum_user_excel
    if(session[:friend]!='')
      uid=1
    else
      uid=1
    end
    items_per_page = 12
    sort = case params['sort']
    when "username"  then "v_fname"
    when "username_reverse"  then "v_fname DESC"
    end

    if (params[:query_hmm_user]!=nil && params[:query_hmm_user1] !=nil && params[:page]==nil || params[:page]=='nil')

      from_yr=params[:query_hmm_user]['ordermonthdayyearstart_year1909(1i)']
      from_mon=params[:query_hmm_user]['ordermonthdayyearstart_year1909(2i)']
      from_date=params[:query_hmm_user]['ordermonthdayyearstart_year1909(3i)']

      fromdate="#{from_yr}-#{from_mon}-#{from_date}"

      frm=fromdate.split("(1i)")
      if(frm[0]=="ordermonthdayyearstart_year1909")
        fromdate=session['fromdate']
      else
        session['fromdate']=fromdate
      end
      to_yr=params[:query_hmm_user1]['ordermonthdayyearstart_year1909(1i)']
      to_mon=params[:query_hmm_user1]['ordermonthdayyearstart_year1909(2i)']
      to_date=params[:query_hmm_user1]['ordermonthdayyearstart_year1909(3i)']

      todate="#{to_yr}-#{to_mon}-#{to_date}"

      tdt=todate.split("(1i)")
      if(tdt[0]=="ordermonthdayyearstart_year1909")
        todate=session['todate']
      else
        session['todate']=todate

      end
    else
      fromdate=session['fromdate']
      todate=session['todate']

    end

    if (params[:query_hmm_user]==nil && params[:query_hmm_user1] ==nil )
      session['fromdate']=''
      session['todate']=''
    end
    if (params[:query].nil?)
      params[:query]=""
    else
      conditions = "a.uid=1 && v_e_mail!='Please update email' && b.emp_id!=50 && b.id=a.fid && a.block_status='unblock' && a.status='accepted' && b.v_fname LIKE '%#{params[:query]}%'"
    end
    if (params[:query1].nil?)
      params[:query1]=""
    else
      conditions ="a.uid=1 && v_e_mail!='Please update email' && b.emp_id!=50 && b.id=a.fid && a.block_status='unblock' && a.status='accepted' && b.v_fname LIKE '#{params[:query1]}%'"
    end

    if(params[:query_hmm_user2]=="All")
      accounttype = ""
      session['usertype']=""
    else
      accounttype =" and account_type='#{params[:query_hmm_user2]}'"
      session['usertype']=params[:query_hmm_user2]
    end

    if(params[:query_hmm_user3]=="active")
      accountexpdate = " and account_expdate >= CURDATE()"
      session['status']='active'
    elsif(params[:query_hmm_user3]=="inactive")
      accountexpdate = " and account_expdate < CURDATE()"
      session['status']='inactive'
    else
      session['status']=""
    end

    if (params[:query_hmm_user].nil? || params[:query_hmm_user]=="")
      params[:query_hmm_user]=""
    else
      conditions = "id!=0  and v_e_mail!='Please update email' and emp_id!=50 and d_created_date between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' #{accounttype} #{accountexpdate}  "
      @total = HmmUser.count(:conditions =>conditions)
      @hmm_users = HmmUser.paginate :per_page => items_per_page, :page => params[:page], :select => "*",  :order => 'id desc',
        :conditions => conditions

    end

    if( params[:query]=="" && params[:query1]=="" && params[:query_hmm_user] =="" )
      @total = HmmUser.count(:joins=>"as b  ", :conditions =>  "b.id!=0 and b.v_e_mail!='Please update email' and b.emp_id!=50 " )
      @hmm_users = HmmUser.paginate :per_page => items_per_page, :page => params[:page] ,:joins=>"as b  ", :select =>"*", :order => 'id desc',
        :conditions => "b.id!=0 and b.v_e_mail!='Please update email' and b.emp_id!=50"
    else
      flag=1
      #        @total = HmmUser.count(:conditions => conditions )
      #        @hmm_users_pages, @hmm_users = paginate :hmm_users , :select => "id as fid, v_myimage, v_fname",  :order => sort, :per_page => items_per_page,
      #        #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && b.v_fname LIKE '%#{params[:query]}%'"
      #        :conditions => conditions
      if(params[:query_hmm_user]!="")
      else

        @hmm_users = HmmUser.paginate :per_page => items_per_page, :page => params[:page] ,:joins=>"as b ", :select => "*", :conditions => "b.id!=0 and b.v_e_mail!='Please update email' and b.emp_id!=50", :order => sort
        #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && a.status='accepted'"
        #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && b.v_fnameq LIKE '%#{params[:query]}%'"
        #:conditions => conditions
      end
    end
    @fnf_groups_index = FnfGroups.find(:all,:conditions=>"uid=1",:order=>"id DESC")

    if request.xml_http_request?
      render :partial => "excel_report", :layout => false
    end
  end

  def platinum_user_excel1
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="statisticalreport.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end
    if(session[:friend]!='')

      uid=1
    else
      uid=1
    end





    if (params[:frmdate].nil? && params[:todate].nil?)
      @frmdate=''
      @todate=''
      @usertype=''
      @status=''
      items_per_page = HmmUser.count(:all , :conditions => " id !=0  and emp_id!=50 and v_e_mail!='Please update email' and emp_id!=50")
      @hmm_users = HmmUser.paginate :select => "*", :conditions => " id !=0  and emp_id!=50 and v_e_mail!='Please update email' and emp_id!=50",  :order => 'id desc', :per_page => items_per_page, :page => params[:page]

    else
      @frmdate=params[:frmdate]
      @todate=params[:todate]
      @status=params[:status]
      if(@status=='active')
        @accountexpdate = " and account_expdate >= CURDATE()"
      else
        @accountexpdate = " and account_expdate < CURDATE()"
      end
      if(params[:usertype]== "")
        @usertype=""
      else
        if(params[:usertype]=='familyws_user')
          @usertype1="Family Website Users report from: #{params[:frmdate]} to: #{params[:todate]} "
        else
          if(params[:usertype]=="free_user")
            @usertype1="Free user accounts report from: #{params[:frmdate]} to: #{params[:todate]}"
          else
            @usertype1="Premium Users report from: #{params[:frmdate]} to: #{params[:todate]}"
          end
        end

        @usertype="and account_type='#{params[:usertype]}'"
      end
      items_per_page = HmmUser.count(:all, :conditions => " id!=0  and v_e_mail!='Please update email' and emp_id!=50 and d_created_date between '#{@frmdate} 00:00:00' and '#{@todate} 23:59:59' #{@usertype} #{@accountexpdate}")
      conditions = "id!=0 and v_e_mail!='Please update email' and emp_id!=50 and d_created_date between '#{@frmdate} 00:00:00' and '#{@todate} 23:59:59' #{@usertype} #{@accountexpdate} "
      @total = HmmUser.count(:conditions =>conditions)
      begin
        @hmm_users = HmmUser.paginate :per_page => items_per_page, :page => params[:page] , :select => "*",  :order => 'id desc',
          :conditions => conditions
      rescue
        logger.info("un able to fetch records")
      end
    end

    if( params[:frmdate]=="" && params[:todate]==""   )
      begin
        @hmm_users = HmmUser.paginate :per_page => items_per_page, :page => params[:page] , :joins=>"as b  ", :order => 'id desc',
          :conditions => "b.id!=0 and b.v_e_mail!='Please update email' and b.emp_id!=50"
      rescue
        logger.info("unable to fetch all records from table")
      end
      @usertype1="All Users report"
    else
      flag=1
      #        @total = HmmUser.count(:conditions => conditions )
      #        @hmm_users_pages, @hmm_users = paginate :hmm_users , :select => "id as fid, v_myimage, v_fname",  :order => sort, :per_page => items_per_page,
      #        #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && b.v_fname LIKE '%#{params[:query]}%'"
      #        :conditions => conditions

    end
    @fnf_groups_index = FnfGroups.find(:all,:conditions=>"uid=1",:order=>"id DESC")

    if request.xml_http_request?
      render :partial => "excel_report1", :layout => false
    end
    render :layout => false
  end

  def cancel_sub
    #if(logged_in_hmm_user.emp_id==nil || logged_in_hmm_user.emp_id=='' )
    require "ArbApiLib"
    aReq = ArbApi.new
    hmm_user = HmmUser.find(params[:id])
    subnumber = hmm_user.subscriptionnumber
    if ARGV.length < 3
    end
    ARGV[0]= "https://api.authorize.net/xml/v1/request.api"
    ARGV[1]= "8GxD65y84"
    ARGV[2]= "89j6d34cW8CKhp9S"
    auth = MerchantAuthenticationType.new(ARGV[1], ARGV[2])
    subname = ARGV.length > 3? ARGV[3]: hmm_user.account_type
    xmlout = aReq.CalcelSubscription(auth,subnumber)
    xmlresp1 = HttpTransport.TransmitRequest(xmlout, ARGV[0])
    apiresp = aReq.ProcessResponse1(xmlresp1)
    puts "Subscription Creation Failed"

    apiresp.messages.each { |message|
      puts "Error Code=" + message.code
      puts "Error Message = " + message.text
      @res =  message.text
    }

    #if(@res == "The subscription has already been cancelled." || @res == "Successful." || @res == "no subscription")
    hmm_user1 = HmmUser.find(hmm_user.id)
    #hmm_user.account_type="free_user"
    #hmm_user1.account_expdate=account_expdate
    @uuid =  HmmUser.find_by_sql(" select UUID() as u")
    unnid = @uuid[0]['u']
    hmm_user1.cancel_status = 'approved'
    if(hmm_user1.family_name=='' or hmm_user1.family_name==nil)
      hmm_user1.family_name="#{hmm_user.id}#{unnid}un#{hmm_user.id}"
    end
    if(session[:employe])
      hmm_user1.canceled_by = "#{session[:employe]}"
    else
      hmm_user1.canceled_by = "0"
    end
    hmm_user1.save

    if(@res == "Successful.")

      flash[:sucess_id] = "Subscription has been canceled sucessfully."
      #Postoffice.deliver_cancellation_approved("Admin","admin@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,logged_in_hmm_user.street_address,logged_in_hmm_user.postcode,logged_in_hmm_user.city,logged_in_hmm_user.state,logged_in_hmm_user.country,logged_in_hmm_user.telephone, reason)
      Emergencymailer.deliver_cancellation_request_complete("admin@holdmymemories.com",hmm_user1.v_fname,hmm_user1.v_lname,hmm_user1.v_e_mail,hmm_user1.account_type,hmm_user1.amount,hmm_user1.subscriptionnumber,hmm_user1.invoicenumber, hmm_user1['v_password'], hmm_user1.v_user_name)

    else
      flash[:sucess_id] = "Subscription status is: " + @res

    end


    #end
    redirect_to "https://www.holdmymemories.com/account/cancel_sucess/"
    # end
  end


  def new_cancel_sub
    #if(logged_in_hmm_user.emp_id==nil || logged_in_hmm_user.emp_id=='' )
    require "ArbApiLib"
    aReq = ArbApi.new
    hmm_user = HmmUser.find(params[:id])
    subnumber = hmm_user.subscriptionnumber
    if ARGV.length < 3
    end
    ARGV[0]= "https://api.authorize.net/xml/v1/request.api"
    ARGV[1]= "8GxD65y84"
    ARGV[2]= "89j6d34cW8CKhp9S"
    auth = MerchantAuthenticationType.new(ARGV[1], ARGV[2])
    subname = ARGV.length > 3? ARGV[3]: hmm_user.account_type
    xmlout = aReq.CalcelSubscription(auth,subnumber)
    xmlresp1 = HttpTransport.TransmitRequest(xmlout, ARGV[0])
    apiresp = aReq.ProcessResponse1(xmlresp1)
    puts "Subscription Creation Failed"

    apiresp.messages.each { |message|
      puts "Error Code=" + message.code
      puts "Error Message = " + message.text
      @res =  message.text
    }

    #if(@res == "The subscription has already been cancelled." || @res == "Successful." || @res == "no subscription")
    hmm_user1 = HmmUser.find(hmm_user.id)
    #hmm_user.account_type="free_user"
    #hmm_user1.account_expdate=account_expdate
    @uuid =  HmmUser.find_by_sql(" select UUID() as u")
    unnid = @uuid[0]['u']
    hmm_user1.cancel_status = 'approved'
    if(hmm_user1.family_name=='' or hmm_user1.family_name==nil)
      hmm_user1.family_name="#{hmm_user.id}#{unnid}un#{hmm_user.id}"
    end
    if(session[:employe])
      hmm_user1.canceled_by = "#{session[:employe]}"
    else
      hmm_user1.canceled_by = "0"
    end
    hmm_user1.save

    #update cancel req table
    @cancel_req=CancellationRequest.find(:first,:conditions=>"uid=#{hmm_user1.id} and cancellation_status='pending'")
    @cancel_req.cancellation_status='approved'
    @cancel_req.save

    if(@res == "Successful.")

      flash[:sucess_id] = "Subscription has been canceled sucessfully."
      #Postoffice.deliver_cancellation_approved("Admin","admin@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,logged_in_hmm_user.street_address,logged_in_hmm_user.postcode,logged_in_hmm_user.city,logged_in_hmm_user.state,logged_in_hmm_user.country,logged_in_hmm_user.telephone, reason)
      Emergencymailer.deliver_cancellation_request_complete("admin@holdmymemories.com",hmm_user1.v_fname,hmm_user1.v_lname,hmm_user1.v_e_mail,hmm_user1.account_type,hmm_user1.amount,hmm_user1.subscriptionnumber,hmm_user1.invoicenumber, hmm_user1['v_password'], hmm_user1.v_user_name)

    else
      flash[:sucess_id] = "Subscription status is: Subscription canceled Sucessfully."

    end


    #end
    redirect_to "/account/new_cancel_sucess/"
    # end

  end

  def new_cancel_sucess

  end

  #  def new_reactivate_sub
  #    user_det=CancellationRequest.find(:first,:conditions=>"uid=#{params[:id]}")
  #    CancellationRequest.find(user_det.id).destroy
  #     hmm_user=HmmUser.find(params[:id])
  #     hmm_user.cancel_status = ""
  #     hmm_user.save
  #    flash[:error] = "Account Reactivated Successfully"
  #    if(params[:v]=='s')
  #      redirect_to "/hmm_studios/studio_pending_requests_admin/"
  #    else
  #       redirect_to "/hmm_studios/market_pending_requests_admin/"
  #    end
  #  end

  def new_reactivate_sub
    if(params[:sub])
      user_det=CancellationRequest.find(:first,:conditions=>"uid=#{params[:id]}")
      CancellationRequest.find(user_det.id).destroy
      hmm_user=HmmUser.find(params[:id])
      hmm_user.cancel_status = ""
      if(session[:store_id]=='170' || session[:store_id]==170)
        hmm_user.old_emp_id = hmm_user.emp_id
        hmm_user.old_studio_id = hmm_user.studio_id
        hmm_user.emp_id = session[:employe]
        hmm_user.studio_id = session[:store_id]
      end
      if(params[:notes]!='' || params[:notes]!=nil)
        hmm_user.studio_management_notes = params[:notes]
      end
      hmm_user.save
      flash[:error] = "Account Reactivated Successfully"
      if(params[:v]=='s')
        redirect_to "/hmm_studios/studio_pending_requests_admin/"
      else
        redirect_to "/hmm_studios/market_pending_requests_admin/"
      end
    end
  end

  def cancel_sucess

  end

  def cancelled_list
    sort_init 'id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="cancellation_request_date desc"
    end

    @hmm_users = (HmmUser.paginate :page=>params[:page],:conditions =>"cancel_status='approved' and emp_id='#{session[:employe]}'", :per_page => 10, :order => sort )
  end

  def cancelled_list_search
    sort_init 'id'
    sort_update

    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and emp_id=#{session[:employe]}")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and emp_id=#{session[:employe]}")

    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
    else
      @uname=params[:username]
      if(@uname!="" && params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%' "
      end

      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end

      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%' "
      end

      @country=params[:v_country]
      @zip=params[:zip]

      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end

    end

    if params[:sort_key]==nil && params[:sort_order]==nil
      @srk="id  desc"
    else

      @sort_key=params[:sort_key]



      @order=params[:sort_order]
    end
    puts @sort_key
    puts @order
    @srk="#{@sort_key}"+" "+"#{@order}"
    if( @srk==nil || @srk=="" )
      @srk="id  desc"
    end
    puts @srk

    @hmm_user_pages, @hmm_users = (paginate :hmm_users, :conditions =>"cancel_status='approved' and emp_id=#{session[:employe]} #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}", :per_page => 10, :order =>  @srk )

    render :layout => true
  end

  def cancelled_list_admin
    sort_init 'id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="cancellation_request_date desc"
    end
    @hmm_users = HmmUser.paginate  :select => "hmm_users.*,hmm_studios.studio_name",  :conditions =>"hmm_users.cancel_status='approved'", :per_page => 100,  :joins=>"LEFT JOIN hmm_studios ON hmm_studios.id = hmm_users.studio_id", :order => sort, :page => params[:page]
  end

  def cancelled_list_search_admin
    sort_init 'id'
    sort_update

    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' ")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' ")

    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
    else
      @uname=params[:username]
      if(@uname!="" && params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%' "
      end

      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end

      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%' "
      end

      @country=params[:v_country]
      @zip=params[:zip]

      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end

    end

    if params[:sort_key]==nil && params[:sort_order]==nil
      @srk="id  desc"
    else

      @sort_key=params[:sort_key]



      @order=params[:sort_order]
    end
    puts @sort_key
    puts @order
    @srk="#{@sort_key}"+" "+"#{@order}"
    if( @srk==nil || @srk=="" )
      #@srk="id  desc"
      @srk="cancellation_request_date desc"
    end

    @srk="cancellation_request_date desc"

    @hmm_users = HmmUser.paginate :select => "hmm_users.*,hmm_studios.studio_name", :conditions =>"cancel_status='approved'  #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}",  :joins=>"LEFT JOIN hmm_studios ON hmm_studios.id = hmm_users.studio_id", :per_page => 100, :order =>  @srk, :page => params[:page]
    render :layout => true
  end



  def pending_requests_admin
    sort_init 'id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="cancellation_request_date desc"
    end
    @hmm_users = (HmmUser.paginate :per_page => 10, :page => params[:page], :conditions =>"cancel_status='pending' ", :order => sort )
  end

  def pending_request_search_admin
    sort_init 'id'
    sort_update

    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked'")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked'")

    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
    else
      @uname=params[:username]
      if(@uname!="" && params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%' "
      end

      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end

      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%' "
      end

      @country=params[:v_country]
      @zip=params[:zip]

      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end

    end

    if params[:sort_key]==nil && params[:sort_order]==nil
      @srk="id  desc"
    else

      @sort_key=params[:sort_key]



      @order=params[:sort_order]
    end
    puts @sort_key
    puts @order
    @srk="#{@sort_key}"+" "+"#{@order}"
    if( @srk==nil || @srk=="" )
      @srk="id  desc"
    end
    puts @srk

    @hmm_users = HmmUser.paginate  :conditions =>"cancel_status='pending'  #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}", :per_page => 10, :order =>  @srk, :page => params[:page]

    render :layout => true
  end

  def commissionReport

    @hmm_studios = HmmStudio.find(:all)
    @manager_commission = EmployeAccount.find(:all, :conditions => "emp_type='store_manager'")
    @marketmanager_commission = MarketManager.find(:all)
  end

  def othercommissionReport

    @hmm_studios = HmmStudio.find(:all, :select => "a.*", :joins => "as a, hmm_studiogroups as b ", :conditions => " b.id!=1 and b.id=a.studio_groupid")
    @manager_commission = EmployeAccount.find(:all, :conditions => "emp_type='store_manager'")
    @marketmanager_commission = MarketManager.find(:all)
  end

  def othercommissionstudioReport

    @manager=EmployeAccount.find(session[:employe])
    @hmm_studios = HmmStudio.find(:all, :conditions => "id = '#{@manager.store_id}'")
    @manager_commission = EmployeAccount.find(:all, :conditions => "emp_type='store_manager' and store_id=#{@manager.store_id} and id='#{session[:employe]}'")
    @manager_branch = ManagerBranche.find(:all, :conditions => " branch_id='#{@manager.store_id}'")

  end

  def othercommissionsownerReport

    @owner_studios=HmmStudio.find(:all,:conditions => "studio_groupid='#{session[:franchise]}'")

    studios="(0"
    for studio in @owner_studios
      studios="#{studios},#{studio.id}"
    end
    studios="#{studios})"

    @hmm_studios = HmmStudio.find(:all, :conditions => " id in  #{studios}")
    @manager_commission = EmployeAccount.find(:all, :conditions => "emp_type='store_manager' and store_id in #{studios}")
    @marketmanager_commission = MarketManager.find(:all, :conditions => "id='#{params[:id]}'")

  end

  def commissionReport_studio_manager
    if(session[:cemploye])
      if (params[:from_year]!=nil && params[:from_month] !=nil && params[:from_day] !=nil)
        @fromdate="#{params[:from_year]}-#{params[:from_month]}-#{params[:from_day]}"
      end

      if (params[:to_year]!=nil && params[:to_month] !=nil && params[:to_day] !=nil )
        @todate="#{params[:to_year]}-#{params[:to_month]}-#{params[:to_day]}"
      end
      @manager=EmployeAccount.find(session[:cemploye])

      @hmm_studios = HmmStudio.find(:all, :conditions => "id = '#{@manager.store_id}'")
      @manager_commission = EmployeAccount.find(:all, :conditions => "emp_type='store_manager' and store_id=#{@manager.store_id} and id='#{session[:cemploye]}'")
      @manager_branch = ManagerBranche.find(:all, :conditions => " branch_id='#{@manager.store_id}'")
      @manager_commission_list = EmployeAccount.find(:all,:select=>"a.*",:joins=>"as a, hmm_studios as b", :conditions => "a.emp_type='store_manager' and a.store_id=b.id and b.studio_groupid=1 and a.id='#{@manager.id}'",:order=>"a.employe_name")
      params[:manager] = @manager_commission.id
      if params[:choose]=="studio_manager_commission"
        if params[:manager].blank?
          @manager_commission = EmployeAccount.find(:all,:select=>"a.*,b.studio_name",:joins=>" as a, hmm_studios as b", :conditions => "a.emp_type='store_manager' and b.id=a.store_id")
        else
          @manager_commission = EmployeAccount.find(:all,:select=>"a.*,b.studio_name",:joins=>" as a, hmm_studios as b", :conditions => "a.id=#{session[:cemploye]} and b.id=a.store_id")
        end
        @partial_name="manager_commission"
      end

      #@marketmanager_commission = MarketManager.find(:all, :conditions => "id='#{@manager_branch[0]['manager_id']}'")
    else
      redirect_to :action => 'commission_login'
    end
  end

  def commissionReport_market_manager

    @manager_studios=ManagerBranche.find(:all,:conditions => "manager_id='#{params[:id]}'")

    studios="(0"
    for studio in @manager_studios
      studios="#{studios},#{studio.branch_id}"
    end
    studios="#{studios})"

    @hmm_studios = HmmStudio.find(:all, :conditions => " id in  #{studios}")
    @manager_commission = EmployeAccount.find(:all, :conditions => "emp_type='store_manager' and store_id in #{studios}")
    @marketmanager_commission = MarketManager.find(:all, :conditions => "id='#{params[:id]}'")

  end

  def studio_customers
    if params[:date] == nil || params[:date] == ''
    else
      session[:dat] = params[:date]
    end

    sort_init 'a.id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "a.id desc"
      else

        sort = "#{session[:srk]}  #{params[:sort_order]}"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end
    @customers = HmmUser.paginate :select =>"a.*,b.*,c.*", :joins => "as a, employe_accounts as b, payment_counts as c", :conditions => "b.store_id='#{params[:id]}' and b.id=c.emp_id and a.id=c.uid and  a.emp_id=b.id and a.account_type='platinum_user'  and c.recieved_on between '#{session[:dat]}-01' and '#{session[:dat]}-31'", :per_page => 25, :order => sort, :page => params[:page],:group =>'c.uid'
    # @customers = HmmUser.find(:all,
    @customer_count = HmmUser.count('DISTINCT c.uid', :joins => "as a, employe_accounts as b, payment_counts as c", :conditions => "b.store_id='#{params[:id]}' and b.id=c.emp_id and a.id=c.uid and  a.emp_id=b.id and a.account_type='platinum_user'  and c.recieved_on between '#{session[:dat]}-01' and '#{session[:dat]}-31'")
  end

  def other_studio_customers
    if params[:date] == nil || params[:date] == ''
    else
      session[:dat] = params[:date]
    end

    sort_init 'a.id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "a.id desc"
      else

        sort = "#{session[:srkcomm]}  #{params[:sort_order]}"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srkcomm]=params[:sort_key]
      sort = "#{session[:srkcomm]}  #{params[:sort_order]}"
    end

    if(sort=="" or sort==nil)
      sort = "a.id desc"
    end
    @customers = HmmUser.paginate :select =>"a.*,b.*,c.*, c.amount as commission, c.id as commmission_id", :joins => "as a, employe_accounts as b, studio_commissions  as c", :conditions => "b.store_id='#{params[:id]}' and b.id=c.emp_id and a.id=c.uid and  a.emp_id=b.id and a.account_type='platinum_user'  and c.payment_recieved_on between '#{session[:dat]}-01' and '#{session[:dat]}-31'",:order=>sort, :per_page => 25, :page => params[:page]
    # @customers = HmmUser.find(:all,
    @customer_count = HmmUser.count(:all, :joins => "as a, employe_accounts as b, studio_commissions as c", :conditions => "b.store_id='#{params[:id]}' and b.id=c.emp_id and a.id=c.uid and  a.emp_id=b.id and a.account_type='platinum_user'  and c.payment_recieved_on between '#{session[:dat]}-01' and '#{session[:dat]}-31'")
  end

  def other_studio_customers_excel
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="studio_commission_report.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end
    if params[:date] == nil || params[:date] == ''
    else
      session[:dat] = params[:date]
    end

    sort_init 'a.id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "a.id desc"
      else

        sort = "#{session[:srkcomm]}  #{params[:sort_order]}"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srkcomm]=params[:sort_key]
      sort = "#{session[:srkcomm]}  #{params[:sort_order]}"
    end

    if(sort=="" or sort==nil)
      sort = "a.id desc"
    end
    @customers = HmmUser.find(:all,:select =>"a.*,b.*,c.*, c.amount as commission, c.id as commmission_id", :joins => "as a, employe_accounts as b, studio_commissions  as c", :conditions => "b.store_id='#{params[:id]}' and b.id=c.emp_id and a.id=c.uid and  a.emp_id=b.id and a.account_type='platinum_user'  and c.payment_recieved_on between '#{session[:dat]}-01' and '#{session[:dat]}-31'",:order=>"a.id desc")
    # @customers = HmmUser.find(:all,
    @customer_count = HmmUser.count(:all, :joins => "as a, employe_accounts as b, studio_commissions as c", :conditions => "b.store_id='#{params[:id]}' and b.id=c.emp_id and a.id=c.uid and  a.emp_id=b.id and a.account_type='platinum_user'  and c.payment_recieved_on between '#{session[:dat]}-01' and '#{session[:dat]}-31'")
    render :layout => false
  end

  def studio_employee_customers
    if params[:date] == nil || params[:date] == ''
    else
      session[:dat] = params[:date]

    end

    sort_init 'a.id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "a.id desc"
      else

        sort = "#{session[:srk]}  #{params[:sort_order]}"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end
    empdet=EmployeAccount.find(params[:id])

    if(empdet.emp_type=='store_manager')
      emplist="(0,"
      stores=HmmStudio.find(empdet.store_id)
      employees=EmployeAccount.find(:all,:conditions => "store_id='#{empdet.store_id}'  and emp_type!='store_manager'")
      for employee in employees
        emplist="#{emplist}#{employee.id},"
      end
      emplist="#{emplist}#{empdet.id})"
      conditions = "a.emp_id in #{emplist}  and c.emp_id=b.id and c.uid=a.id  and a.account_type='platinum_user' and c.recieved_on between '#{session[:dat]}-01' and '#{session[:dat]}-31'  and (a.amount='$9.95' or a.amount='$49.95' or a.amount='$99.95')  "
    else
      conditions = "a.emp_id='#{params[:id]}' and c.emp_id=b.id and c.uid=a.id  and a.account_type='platinum_user' and c.recieved_on between '#{session[:dat]}-01' and '#{session[:dat]}-31'  and (a.amount='$9.95' or a.amount='$49.95' or a.amount='$99.95')  "
    end
    #@customers = HmmUser.paginate :select =>"a.*,b.*", :joins => "as b, payment_counts as a", :conditions => "a.emp_id='#{params[:id]}' and a.uid=b.id and a.account_type='platinum_user' and (a.amount='$9.95' or a.amount='$49.95' or a.amount='$99.95') and  a.recieved_on between '#{session[:dat]}-01' and '#{session[:dat]}-31' and (b.d_created_datefewfew between '#{empdet.employe_join_date}' and '#{empdet.end_date}' ) ", :per_page => 25, :order => sort, :page => params[:page]
    @customers = HmmUser.paginate :select =>"a.*,b.*,c.*", :joins => "as a, employe_accounts as b, payment_counts as c", :conditions => "#{conditions}", :per_page => 25, :order => sort, :page => params[:page],:group =>'c.uid'
    # @customers = HmmUser.find(:all,
    @customer_count = HmmUser.count('DISTINCT c.uid', :joins => "as a, employe_accounts as b, payment_counts as c", :conditions => "#{conditions}")
  end

  def studio_customers_excel

    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="studio_commission_report.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end
    if params[:date] == nil || params[:date] == ''
    else
      session[:dat] = params[:date]
    end

    sort_init 'a.id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "a.id desc"
      else

        sort = "#{session[:srk]}  #{params[:sort_order]}"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end

    if params[:type]=='studio'
      conditions = "b.store_id='#{params[:id]}' and b.id=c.emp_id and a.id=c.uid and  a.emp_id=b.id and a.account_type='platinum_user'  and c.recieved_on between '#{session[:dat]}-01' and '#{session[:dat]}-31'"
    else
      conditions = "a.emp_id='#{params[:id]}' and c.emp_id=b.id and c.uid=a.id  and a.account_type='platinum_user' and (a.amount='$9.95' or a.amount='$49.95' or a.amount='$99.95') and  c.recieved_on between '#{session[:dat]}-01' and '#{session[:dat]}-31'"
    end

    @customers = HmmUser.paginate(:select => "a.*,b.*,c.*", :joins => "as a, employe_accounts as b, payment_counts as c", :conditions => conditions, :per_page => 5000,  :page => params[:page], :order => sort,:group =>'c.uid')
    # @customers = HmmUser.find(:all,
    @customer_count = HmmUser.count('DISTINCT c.uid', :joins => "as a, employe_accounts as b, payment_counts as c", :conditions => conditions)
    render :layout => false
  end


  def studio_customers_studio
    if params[:date] == nil || params[:date] == ''
    else
      session[:dat] = params[:date]
    end

    sort_init 'a.id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "a.id desc"
      else

        sort = "#{session[:srk]}  #{params[:sort_order]}"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end
    @customers = HmmUser.paginate :select => "a.*,b.*,c.*", :joins => "as a, employe_accounts as b, payment_counts as c", :conditions => "b.store_id='#{params[:id]}' and b.id=c.emp_id and a.id=c.uid and  a.emp_id=b.id and a.account_type='platinum_user'  and c.recieved_on between '#{session[:dat]}-01' and '#{session[:dat]}-31'", :per_page => 25, :order => sort, :page => params[:page], :group => 'c.uid'
    # @customers = HmmUser.find(:all,
    @customer_count = HmmUser.count('DISTINCT c.uid', :joins => "as a, employe_accounts as b, payment_counts as c", :conditions => "b.store_id='#{params[:id]}' and b.id=c.emp_id and a.id=c.uid and  a.emp_id=b.id and a.account_type='platinum_user'  and c.recieved_on between '#{session[:dat]}-01' and '#{session[:dat]}-31'")
  end

  def studio_customers_market_manager
    if params[:date] == nil || params[:date] == ''
    else
      session[:dat] = params[:date]
    end

    sort_init 'a.id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "a.id desc"
      else

        sort = "#{session[:srk]}  #{params[:sort_order]}"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end
    @customers_pages, @customers = (paginate :hmm_users, :joins => "as a, employe_accounts as b, payment_counts as c", :conditions => "b.store_id='#{params[:id]}' and b.id=c.emp_id and a.id=c.uid and  a.emp_id=b.id and a.account_type='platinum_user'  and c.recieved_on between '#{session[:dat]}-01' and '#{session[:dat]}-31'", :per_page => 25, :order => sort)
    # @customers = HmmUser.find(:all,
    @customer_count = HmmUser.count(:all, :joins => "as a, employe_accounts as b, payment_counts as c", :conditions => "b.store_id='#{params[:id]}' and b.id=c.emp_id and a.id=c.uid and  a.emp_id=b.id and a.account_type='platinum_user'  and c.recieved_on between '#{session[:dat]}-01' and '#{session[:dat]}-31'")
  end

  def customer_studios
    if params[:date] == nil || params[:date] == ''
    else
      session[:dat] = params[:date]
    end

    sort_init 'a.id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "a.id desc"
      else

        sort = "#{session[:srk]}  #{params[:sort_order]}"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end
    @customers_pages, @customers = (paginate :hmm_users, :joins => "as a, employe_accounts as b", :conditions => "b.store_id='#{params[:id]}' and  a.emp_id=b.id and account_type='platinum_user'  and DATE_FORMAT(a.d_created_date, '%Y-%m') <= '#{session[:dat]}'", :per_page => 25, :order => sort)
    # @customers = HmmUser.find(:all,
    @customer_count = HmmUser.count(:all, :joins => "as a, employe_accounts as b", :conditions => "b.store_id='#{params[:id]}' and  a.emp_id=b.id and account_type='platinum_user'  and DATE_FORMAT(a.d_created_date, '%Y-%m') <= '#{session[:dat]}'")
  end


  def commissionReport_search

    @hmm_studios = HmmStudio.find(:all)
    @manager_commission = EmployeAccount.find(:all, :conditions => "emp_type='store_manager'")
    @marketmanager_commission = MarketManager.find(:all)
  end

  def manager_home
    @market_managers=MarketManager.find(:all,:select=>"b.branch_id", :joins=>"as a , manager_branches as b ", :conditions=>"a.id=#{session[:manager]} and a.id=b.manager_id")

    if(@market_managers.length>0)
      a = Array.new

      for @studio in @market_managers
        a.push(@studio.branch_id)
      end

      @list_studios=a.join(",")

    else
      @list_studios=9999999
    end
    @hmm_user_requests = HmmUser.count(:all, :conditions =>"cancel_status='pending' and studio_id IN (#{@list_studios})  and  cancellation_request_date between concat( date_format( curdate( ) , '%Y-%m-%d' ) , date_format( cancellation_request_date, ' %H:%i:%s' ) ) and concat(date_format(DATE_ADD(CURDATE(),INTERVAL 1 DAY),'%Y-%m-%d'), date_format(cancellation_request_date,' %H:%i:%s'))  ")
  end

  def cancelled_list_failed
    sort_init 'id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="cancellation_request_date desc"
    end
    @hmm_users = (HmmUser.paginate :per_page => 10, :page => params[:page], :conditions =>"cancel_status='approved' and emp_id='#{session[:employe]}' and canceled_by='-2'", :order => sort )
  end

  def cancelled_list_search_failed
    sort_init 'id'
    sort_update

    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and emp_id=#{session[:employe]}")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and emp_id=#{session[:employe]}")

    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
    else
      @uname=params[:username]
      if(@uname!="" && params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%' "
      end

      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end

      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%' "
      end

      @country=params[:v_country]
      @zip=params[:zip]

      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end

    end

    if params[:sort_key]==nil && params[:sort_order]==nil
      @srk="id  desc"
    else

      @sort_key=params[:sort_key]



      @order=params[:sort_order]
    end
    puts @sort_key
    puts @order
    @srk="#{@sort_key}"+" "+"#{@order}"
    if( @srk==nil || @srk=="" )
      @srk="id  desc"
    end
    puts @srk

    @hmm_users = (HmmUser.paginate :per_page => 10, :page => params[:page], :conditions =>"cancel_status='approved' and canceled_by='-2' and emp_id=#{session[:employe]} #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}", :order =>  @srk )

    render :layout => true
  end

  def cancelled_list_failed_admin
    sort_init 'id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="cancellation_request_date desc"
    end
    @hmm_users = (HmmUser.paginate  :per_page => 10, :page => params[:page], :conditions =>"cancel_status='approved'  and canceled_by='-2'", :order => sort )
  end

  def cancelled_list_search_failed_admin
    sort_init 'id'
    sort_update

    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' ")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' ")

    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
    else
      @uname=params[:username]
      if(@uname!="" && params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%' "
      end

      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end

      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%' "
      end

      @country=params[:v_country]
      @zip=params[:zip]

      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end

    end

    if params[:sort_key]==nil && params[:sort_order]==nil
      @srk="id  desc"
    else

      @sort_key=params[:sort_key]



      @order=params[:sort_order]
    end
    puts @sort_key
    puts @order
    @srk="#{@sort_key}"+" "+"#{@order}"
    if( @srk==nil || @srk=="" )
      @srk="id  desc"
    end
    puts @srk

    @hmm_users = (HmmUser.paginate  :per_page => 10, :page => params[:page], :conditions =>"cancel_status='approved' and canceled_by='-2'  #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}", :order =>  @srk )

    render :layout => true
  end

  #  def my_customers_wpf
  ##    @hmmuser_blockcnt = HmmUsers.count(:all, :conditions => "e_user_status='blocked' and emp_id=#{session[:employe]} and account_type='platinum_user'")
  ##    @hmmuser_unblockcnt = HmmUsers.count(:all, :conditions => "e_user_status='unblocked' and emp_id=#{session[:employe]} and account_type='platinum_user'")
  ##    sort_init 'id'
  ##      sort_update
  ##      srk=params[:sort_key]
  ##      sort="#{srk}  #{params[:sort_order]}"
  ##
  ##      if( srk==nil)
  ##        sort="id  desc"
  ##      end
  #
  #      @results = HmmUser.find(:all, :conditions => "emp_id=#{params[:id]}")
  #
  #    render :layout => false
  #  end
  #
  #  def customers_chap_wpf
  #    @results = Tag.find(:all, :conditions => "uid=#{params[:id]}")
  #
  #    render :layout => false
  #  end
  #
  #  def customers_subchap_wpf
  #    @results = SubChapter.find(:all, :conditions => "tagid=#{params[:id]}")
  #
  #    render :layout => false
  #  end
  #
  #  def customers_gallery_wpf
  #    @results = Galleries.find(:all, :conditions => "subchapter_id=#{params[:id]}")
  #
  #    render :layout => false
  #  end
  #
  #  def customers_moments_wpf
  #    @results = UserContent.find(:all, :conditions => "gallery_id=#{params[:id]}")
  #
  #    render :layout => false
  #  end



  def rebill_amount
    @hmm_user = HmmUser.find(params[:id])
  end

  def rebill
    @hmm_user = HmmUser.find(params[:hmmid])
    @hmm_user.billed_date = "#{params[:rebill]['billed_date(1i)']}-#{params[:rebill]['billed_date(2i)']}-#{params[:rebill]['billed_date(3i)']}"
    months="#{params[:rebill]['billed_date(1i)']}-#{params[:rebill]['billed_date(2i)']}-#{params[:rebill]['billed_date(3i)']}".to_date
    months=months+1.month
    @hmm_user.account_expdate = months
    @hmm_user.billed_status = ''
    @hmm_user.save
  end

  def rebill_status
    @hmm_user = HmmUser.find(params[:id])
  end

  def rebill_status_change
    @hmm_user = HmmUser.find(params[:hmmid])
    @hmm_user.billed_status = "#{params[:rebill_status]}"
    if(params[:rebill_status]=="yes")
      @hmm_user.cancel_status = ""
    end
    @hmm_user.save
  end

  def coupon_upgrade
    sort_init 'id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="id  desc"
    end
    #      @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "account_type='free_user' ")
    #      @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "account_type='free_user' ")
    #      @hmmuser_cnt = (@hmmuser_blockcnt - @hmmuser_unblockcnt)
    @hmmuser_premcnt= HmmUser.count(:all, :conditions => "account_type='free_user' and  e_user_status='unblocked'")
    @hmm_users = HmmUser.paginate  :per_page => 10, :page => params[:page], :order => sort

    render :layout => true
  end

  def coupon_upgrade_search
    sort_init 'id'
    sort_update

    #       @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "account_type='platinum_user' ")
    #      @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "account_type='platinum_user' and emp_id != '' ")
    #      @hmmuser_cnt = (@hmmuser_blockcnt - @hmmuser_unblockcnt)
    @studios = HmmStudio.find(:all)
    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil && params[:status]==nil && params[:studio_id]==nil)
    else
      @search_users = "true"
      @uname=params[:username]
      if(@uname!="" && params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%'"
      end

      @email=params[:email]
      if(@email!="" && params[:email]!=nil)
        emailcondition="and v_e_mail like '#{@email}%'"
      end

      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}'"
      end

      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%'"
      end

      @country=params[:v_country]
      @zip=params[:zip]

      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%'"
        end
      end
      t = Time.now
      dat = t.strftime("%Y-%m-%d")
      if params[:status] == 'active'
        statuscondition = "and account_expdate > '#{dat.to_date}'"
      elsif params[:status] == 'inactive'
        statuscondition = "and account_expdate < '#{dat.to_date}'"
      end

      @studio_id = params[:studio_id]
      if(@studio_id != "" && params[:studio_id] != nil)
        studiocondition = "and studio_id = #{@studio_id}"
        @studio_selected = params[:studio_id]
      end
      @hmm_users_upgrade = HmmUser.find(:all, :conditions =>"id!=''  #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition} #{statuscondition} #{studiocondition}", :order =>  @srk)
      @user_ids = Array.new
      for user in @hmm_users_upgrade
        @user_ids.push(user.id)
      end
      @user_ids = @user_ids.join(",")
    end

    if params[:sort_key]==nil && params[:sort_order]==nil
      @srk="id  desc"
    else
      @sort_key=params[:sort_key]
      @order=params[:sort_order]
      @srk="#{@sort_key}"+" "+"#{@order}"
    end
    puts @sort_key
    puts @order
    @hmm_users = HmmUser.paginate  :per_page => 10, :page => params[:page], :conditions =>"id!=''  #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition} #{statuscondition} #{studiocondition}", :order =>  @srk

    render :layout => true
  end

  def authenticate_coupon_all
    if params[:cupon_no]!="" && params[:hmm_users]!=[""]
      @cupon_result = Cupon.count(:all, :conditions => "unid='#{params[:cupon_no]}'")
      @cupon_res = Cupon.find(:all, :conditions => "unid='#{params[:cupon_no]}'")
      @hmm_users = HmmUser.find(:all, :conditions => "id IN (#{params[:hmm_users].join(",")})")
      for hmm_user in @hmm_users
        for i in @cupon_res
          # expire date calculation
          if i.valid_period == '1'
            @exp_date_cal =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL 1 MONTH) as m")
            account_expdate= @exp_date_cal[0]['m']
            hmm_user['account_expdate'] = account_expdate
          else if i.valid_period == '3'
              @exp_date_cal =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL 3 MONTH) as m")
              account_expdate= @exp_date_cal[0]['m']
              hmm_user['account_expdate'] = account_expdate
            else if i.valid_period == '6'
                @exp_date_cal =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL 6 MONTH) as m")
                account_expdate= @exp_date_cal[0]['m']
                hmm_user['account_expdate'] = account_expdate
              else if i.valid_period == '12'
                  @exp_date_cal =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL 12 MONTH) as m")
                  account_expdate= @exp_date_cal[0]['m']
                  hmm_user['account_expdate'] = account_expdate
                else if i.valid_period == 'ff'
                    @exp_date_cal =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL 9999 MONTH) as m")
                    account_expdate= @exp_date_cal[0]['m']
                    hmm_user['account_expdate'] = account_expdate
                  end
                end
              end
            end
          end
          hmm_user['cupon_no']=i.unid
          if i.cupon_type == 'premium'
            hmm_user['account_type']="platinum_user"
          elsif  i.cupon_type == 'family_website'
            hmm_user['account_type']="familyws_user"
          end
          #@hmm_user['account_expdate']=account_expdate
          if i.valid_period == 'ff'
            hmm_user['months']='9999'
          else
            hmm_user['months']=i.valid_period
          end
          hmm_user['substatus']="active"
          hmm_user['payment_recieved']="1"
          hmm_user.save
          account_present = CuponUpgradedAccount.new
          account_present.user_id = hmm_user.id
          account_present.cupon_id = i.unid
          account_present.save
        end
      end
      if @cupon_result > 0
        flash[:unid_succes] = 'Cupon Authenticated!! Users Account has been Upgraded.'
        redirect_to :action => 'coupon_upgrade_search'
      else
        flash[:unid_failed] = 'Cupon Id is not valid'
        redirect_to :action => 'coupon_upgrade_search'
      end
    else
      flash[:unid_failed] = 'No Users '
      redirect_to :action => 'coupon_upgrade_search'
    end
  end

  def check_couponid

  end

  def authenticate_coupon
    @cupon_result = Cupon.count(:all, :conditions => "unid='#{params[:cupon_no]}'")
    @cupon_res = Cupon.find(:all, :conditions => "unid='#{params[:cupon_no]}'")
    for i in @cupon_res
      @hmm_user = HmmUser.find(params[:userid])
      # expire date calculation
      if i.valid_period == '1'
        @exp_date_cal =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL 1 MONTH) as m")
        account_expdate= @exp_date_cal[0]['m']
        @hmm_user['account_expdate'] = account_expdate
      else if i.valid_period == '3'
          @exp_date_cal =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL 3 MONTH) as m")
          account_expdate= @exp_date_cal[0]['m']
          @hmm_user['account_expdate'] = account_expdate
        else if i.valid_period == '6'
            @exp_date_cal =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL 6 MONTH) as m")
            account_expdate= @exp_date_cal[0]['m']
            @hmm_user['account_expdate'] = account_expdate
          else if i.valid_period == '12'
              @exp_date_cal =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL 12 MONTH) as m")
              account_expdate= @exp_date_cal[0]['m']
              @hmm_user['account_expdate'] = account_expdate
            else if i.valid_period == 'ff'
                @exp_date_cal =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL 9999 MONTH) as m")
                account_expdate= @exp_date_cal[0]['m']
                @hmm_user['account_expdate'] = account_expdate
              end
            end
          end
        end
      end


      @hmm_user['cupon_no']=i.unid
      if i.cupon_type == 'premium'
        @hmm_user['account_type']="platinum_user"
      elsif  i.cupon_type == 'family_website'
        @hmm_user['account_type']="familyws_user"
      end
      #@hmm_user['account_expdate']=account_expdate
      if i.valid_period == 'ff'
        @hmm_user['months']='9999'
      else
        @hmm_user['months']=i.valid_period
      end
      @hmm_user['substatus']="active"
      @hmm_user['payment_recieved']="1"
      @hmm_user.save

    end
    if @cupon_result > 0
      flash[:unid_succes] = 'Cupon Authenticated!! User Account has been Upgraded.'
      redirect_to :action => 'coupon_upgrade'
    else
      flash[:unid_failed] = 'Cupon Id is not valid'
      redirect_to :action => 'coupon_upgrade'
    end
  end

  def hmm_reporting
    sort_init 'id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "id desc"
      else

        sort = "id desc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end
    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked'")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked'")


    render :layout => true
  end

  def hmm_reporting_search
    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked'")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked'")


    if(params[:company]==nil && params[:studios]==nil && params[:managers]==nil )
    else
      if(params[:company]!=nil)
        company="and c.studio_groupid = '#{params[:company_value]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'platinum_user'"
        company_active_user=" and DATE_FORMAT(a.account_expdate,'%Y-%m-%d') >= curdate()"
        company_cancled_user="and a.cancel_status='approved' and a.canceled_by!='-2'"
        company_declined_user="and a.cancel_status='approved' and a.canceled_by='-2'"

        company_familyws="and c.studio_groupid = '#{params[:company_value]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'familyws_user'"
        company_familyws_pass="and c.studio_groupid = '#{params[:company_value]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'familyws_user' and a.password_required = 'yes'"
        company_active_fwuser="and DATE_FORMAT(a.account_expdate,'%Y-%m-%d') >= curdate()"
        company_cancled_fwuser="and a.cancel_status='approved' and a.canceled_by !='-2'"
        company_declined_fwuser="and a.cancel_status='approved' and a.canceled_by ='-2'"

        company_free="and c.studio_groupid = '#{params[:company_value]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'free_user'"
        company_media = "and c.studio_groupid = '#{params[:company_value]}' AND d.store_id = c.id AND d.id = e.emp_id and e.id=a.uid"
      end

      if(params[:studios]!=nil)
        studio="AND d.store_id = '#{params[:studio_value]}' AND d.id = a.emp_id AND a.account_type = 'platinum_user'"
        studio_active_user = "and DATE_FORMAT(a.account_expdate,'%Y-%m-%d') >= curdate()"
        studio_cancled_user = "and a.cancel_status='approved' and a.canceled_by!='-2'"
        studio_declined_user="and a.cancel_status='approved' and a.canceled_by='-2'"

        studio_familyws="AND d.store_id = '#{params[:studio_value]}' AND d.id = a.emp_id AND a.account_type = 'familyws_user'"
        studio_familyws_pass="AND d.store_id = '#{params[:studio_value]}' AND d.id = a.emp_id AND a.account_type = 'familyws_user' and a.password_required = 'yes'"
        studio_active_familyws="and DATE_FORMAT(a.account_expdate,'%Y-%m-%d') >= curdate()"
        studio_cancled_familyws="and a.cancel_status='approved' and a.canceled_by!='-2'"
        studio_declined_familyws="and a.cancel_status='approved' and a.canceled_by ='-2'"

        studio_free="AND d.store_id = '#{params[:studio_value]}' AND d.id = a.emp_id AND a.account_type = 'free_user'"
        studio_media="AND d.store_id = '#{params[:studio_value]}' AND d.id = e.emp_id and e.id=a.uid"
      end

      if(params[:managers]!=nil)
        manager="AND emp_id = '#{params[:manager_value]}' AND account_type = 'platinum_user'"
        manager_active_user="and DATE_FORMAT(account_expdate,'%Y-%m-%d') >= curdate()"
        manager_cancled_user="and cancel_status='approved' and canceled_by!='-2'"
        company_declined_user="and cancel_status='approved' and canceled_by='-2'"

        manager_familyws="AND emp_id = '#{params[:manager_value]}' AND account_type = 'familyws_user'"
        manager_familyws_pass="AND emp_id = '#{params[:manager_value]}' AND account_type = 'familyws_user' and password_required = 'yes'"
        manager_active_familyws="and DATE_FORMAT(account_expdate,'%Y-%m-%d') >= curdate()"
        manager_cancled_familyws="and cancel_status='approved' and canceled_by!='-2'"
        manager_declined_familyws="and cancel_status='approved' and canceled_by ='-2'"

        manager_free="AND emp_id = '#{params[:studio_value]}' AND account_type = 'free_user'"
        manager_media="AND e.emp_id = '#{params[:manager_value]}' and e.id=a.uid"
      end
    end


    if(params[:company]== nil && params[:studios]== nil && params[:managers]== nil )

    else
      if(params[:company]!=nil)
        session[:search_cond]="#{company}  "
        session[:search_cond_active]="#{company}  #{company_active_user} "
        session[:search_fwcond]="#{company_familyws} "
        session[:search_freecond]="#{company_free} "
        session[:search_cond_media]="#{company_media}  "

      end

      if(params[:studios]!=nil)
        session[:search_cond]="#{studio}  "
        session[:search_cond_active]="#{studio}  #{studio_active_user} "
        session[:search_fwcond]="#{studio_familyws} "
        session[:search_freecond]="#{studio_free} "
        session[:search_cond_media]="#{studio_media}  "
      end
      if(params[:managers]!=nil)
        session[:search_cond]="#{manager}  "
        session[:search_cond_active]="#{manager}  #{manager_active_user} "
        session[:search_fwcond]="#{manager_familyws} "
        session[:search_freecond]="#{manager_free} "
        session[:search_cond_media]="#{manager_media}  "
      end
    end
    if(params[:company]!=nil)
      @hmm_users_premium = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_cond]}")
      @hmm_users_premium_active = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_cond]} #{company_active_user}")
      @hmm_users_premium_cancled = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_cond]} #{company_cancled_user}")
      @hmm_users_premium_declined = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_cond]} #{company_declined_user}")

      @premium_avg_membership = HmmUser.count_by_sql("SELECT sum( DATEDIFF( a.account_expdate, a.d_created_date ) ) FROM hmm_users AS a, hmm_studios AS c, employe_accounts AS d WHERE c.studio_groupid ='#{params[:company_value]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'platinum_user' AND a.account_expdate > current_date( ) and a.cupon_no IS NULL  ;")
      @premium_avg_membership_cont = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions => " c.studio_groupid = '#{params[:company_value]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'platinum_user' AND a.account_expdate > current_date( ) and a.cupon_no IS NULL ")
      if (@premium_avg_membership_cont != 0)
        @avg_membership = (@premium_avg_membership / @premium_avg_membership_cont)
      else
        @avg_membership = 0
      end

      @hmm_users_familyws = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_fwcond]}")
      @hmm_users_familyws_pass = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{company_familyws_pass}")
      @hmm_users_familyws_active = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_fwcond]} #{company_active_fwuser}")
      @hmm_users_familyws_cancled = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_fwcond]} #{company_cancled_fwuser}")
      @hmm_users_familyws_declined = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_fwcond]} #{company_declined_fwuser}")

      @family_avg_membership = HmmUser.count_by_sql("SELECT sum( DATEDIFF( a.account_expdate, a.d_created_date ) ) FROM hmm_users AS a, hmm_studios AS c, employe_accounts AS d WHERE c.studio_groupid ='#{params[:company_value]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'familyws_user' AND a.account_expdate > current_date( ) and a.cupon_no IS NULL ;")
      @family_avg_membership_cont = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions => " c.studio_groupid = '#{params[:company_value]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'familyws_user' AND a.account_expdate > current_date( ) and a.cupon_no IS NULL ")
      if(@family_avg_membership_cont != 0)
        @avg_family_membership = (@family_avg_membership / @family_avg_membership_cont)
      else
        @avg_family_membership = 0
      end

      @hmm_users_free = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_freecond]} ")
      #@hmm_users_free = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_freecond]} ")
      @free_avg_age = HmmUser.count_by_sql("SELECT sum( DATEDIFF( current_date( ) , a.d_created_date  ) ) FROM hmm_users AS a, hmm_studios AS c, employe_accounts AS d WHERE c.studio_groupid ='#{params[:company_value]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'free_user';")
      @free_avg_age_cont = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions => " c.studio_groupid = '#{params[:company_value]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'free_user'")
      if(@free_avg_age_cont != 0)
        @avg_free_age = (@free_avg_age / @free_avg_age_cont)
      else
        @avg_free_age = 0
      end

      @stat_imag = UserContent.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d , hmm_users as e",:conditions => "e.id!='' #{session[:search_cond_media]} and a.e_filetype='image' and a.status = 'active'")
      @stat_video = UserContent.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d, hmm_users as e ",:conditions => "e.id!='' #{session[:search_cond_media]} and a.e_filetype='VIDEO' and a.status = 'active'")
      @stat_audio = UserContent.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d, hmm_users as e ",:conditions => "e.id!='' #{session[:search_cond_media]} and a.e_filetype='AUDIO' and a.status = 'active'")
    end

    if(params[:studios]!=nil)
      @hmm_users_premium = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_cond]}")
      @hmm_users_premium_active = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_cond]} #{studio_active_user}")
      @hmm_users_premium_cancled = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_cond]} #{studio_cancled_user}")
      @hmm_users_premium_declined = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_cond]}  #{studio_declined_user}")

      @premium_avg_membership = HmmUser.count_by_sql("SELECT sum( DATEDIFF( a.account_expdate, a.d_created_date ) ) FROM hmm_users AS a, employe_accounts AS d WHERE d.store_id = '#{params[:studio_value]}' AND d.id = a.emp_id AND a.account_type = 'platinum_user' AND a.account_expdate > current_date( ) and a.cupon_no IS NULL ;")
      @premium_avg_membership_cont = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions => "d.store_id = '#{params[:studio_value]}' AND d.id = a.emp_id  AND a.account_type = 'platinum_user' AND a.account_expdate > current_date( ) and a.cupon_no IS NULL ")
      if (@premium_avg_membership_cont != 0)
        @avg_membership = (@premium_avg_membership / @premium_avg_membership_cont)
      else
        @avg_membership = 0
      end

      @hmm_users_familyws = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_fwcond]}")
      @hmm_users_familyws_pass = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions =>"a.id!='' #{studio_familyws_pass}")
      @hmm_users_familyws_active = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_fwcond]} #{studio_active_familyws}")
      @hmm_users_familyws_cancled = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_fwcond]} #{studio_cancled_familyws}")
      @hmm_users_familyws_declined = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_fwcond]} #{studio_declined_familyws}")

      @family_avg_membership = HmmUser.count_by_sql("SELECT sum( DATEDIFF( a.account_expdate, a.d_created_date ) ) FROM hmm_users AS a, employe_accounts AS d WHERE d.store_id = '#{params[:studio_value]}' AND d.id = a.emp_id AND a.account_type = 'familyws_user' AND a.account_expdate > current_date( ) and a.cupon_no IS NULL ;")
      @family_avg_membership_cont = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions => " d.store_id = '#{params[:studio_value]}' AND d.id = a.emp_id  AND a.account_type = 'familyws_user' AND a.account_expdate > current_date( ) and a.cupon_no IS NULL ")
      if(@family_avg_membership_cont != 0)
        @avg_family_membership = (@family_avg_membership / @family_avg_membership_cont)
      else
        @avg_family_membership = 0
      end

      @hmm_users_free = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_freecond]} ")
      @free_avg_age = HmmUser.count_by_sql("SELECT sum( DATEDIFF( a.account_expdate, a.d_created_date ) ) FROM hmm_users AS a, employe_accounts AS d WHERE d.store_id = '#{params[:studio_value]}' AND d.id = a.emp_id AND a.account_type = 'free_user' ;")
      @free_avg_age_cont = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions => " d.store_id = '#{params[:studio_value]}' AND d.id = a.emp_id  AND a.account_type = 'free_user'")
      if (@free_avg_age_cont != 0)
        @avg_free_age = (@free_avg_age / @free_avg_age_cont)
      else
        @avg_free_age = 0
      end
      #@hmm_users_free = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_freecond]} ")

      @stat_imag = UserContent.count(:all, :joins=>"as a , employe_accounts as d , hmm_users as e",:conditions => "e.id!='' #{session[:search_cond_media]} and a.e_filetype='image' and a.status = 'active'")
      @stat_video = UserContent.count(:all, :joins=>"as a , employe_accounts as d , hmm_users as e ",:conditions => "e.id!='' #{session[:search_cond_media]} and a.e_filetype='VIDEO' and a.status = 'active'")
      @stat_audio = UserContent.count(:all, :joins=>"as a , employe_accounts as d , hmm_users as e ",:conditions => "e.id!='' #{session[:search_cond_media]} and a.e_filetype='AUDIO' and a.status = 'active'")


    end

    if(params[:managers]!=nil)
      @hmm_users_premium = HmmUser.count(:all,  :conditions =>"id!='' #{session[:search_cond]}")
      @hmm_users_premium_active = HmmUser.count(:all,  :conditions =>"id!='' #{session[:search_cond]} #{manager_active_user}")
      @hmm_users_premium_cancled = HmmUser.count(:all, :conditions =>"id!='' #{session[:search_cond]} #{manager_cancled_user}")
      @hmm_users_premium_declined = HmmUser.count(:all, :conditions =>"id!='' #{session[:search_cond]} #{company_declined_user}")

      @premium_avg_membership = HmmUser.count_by_sql("SELECT sum( DATEDIFF( account_expdate, d_created_date ) ) FROM hmm_users WHERE emp_id = '#{params[:manager_value]}' AND account_type = 'platinum_user' AND account_expdate > current_date( ) and cupon_no IS NULL ;")
      @premium_avg_membership_cont = HmmUser.count(:all, :conditions => "emp_id = '#{params[:manager_value]}' AND account_type = 'platinum_user' AND account_expdate > current_date( ) and cupon_no IS NULL  ")
      if (@premium_avg_membership_cont != 0)
        @avg_membership = (@premium_avg_membership / @premium_avg_membership_cont)
      else
        @avg_membership = 0
      end

      @hmm_users_familyws = HmmUser.count(:all, :conditions =>"id!='' #{session[:search_fwcond]}")
      @hmm_users_familyws_pass = HmmUser.count(:all, :conditions =>"id!='' #{manager_familyws_pass}")
      @hmm_users_familyws_active = HmmUser.count(:all, :conditions =>"id!='' #{session[:search_fwcond]} #{manager_active_familyws}")
      @hmm_users_familyws_cancled = HmmUser.count(:all, :conditions =>"id!='' #{session[:search_fwcond]} #{manager_cancled_familyws}")
      @hmm_users_familyws_declined = HmmUser.count(:all, :conditions =>"id!='' #{session[:search_fwcond]} #{manager_declined_familyws}")

      @family_avg_membership = HmmUser.count_by_sql("SELECT sum( DATEDIFF( account_expdate, d_created_date ) ) FROM hmm_users WHERE emp_id = '#{params[:manager_value]}' AND account_type = 'familyws_user' AND account_expdate > current_date( ) and cupon_no IS NULL ;")
      @family_avg_membership_cont = HmmUser.count(:all, :conditions => "emp_id = '#{params[:manager_value]}' AND account_type = 'familyws_user' AND account_expdate > current_date( ) and cupon_no IS NULL ")
      if(@family_avg_membership_cont != 0)
        @avg_family_membership = (@family_avg_membership / @family_avg_membership_cont)
      else
        @avg_family_membership = 0
      end

      @hmm_users_free = HmmUser.count(:all, :conditions =>"id!='' #{session[:search_freecond]} ")
      #@hmm_users_free = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_freecond]} ")
      @free_avg_age = HmmUser.count_by_sql("SELECT sum( DATEDIFF( account_expdate, d_created_date ) ) FROM hmm_users WHERE emp_id = '#{params[:manager_value]}' AND account_type = 'free_user';")
      @free_avg_age_cont = HmmUser.count(:all, :conditions => "emp_id = '#{params[:manager_value]}' AND account_type = 'free_user'")
      if(@free_avg_age_cont != 0)
        @avg_free_age = (@free_avg_age / @free_avg_age_cont)
      else
        @avg_free_age = 0
      end

      @stat_imag = UserContent.count(:all, :joins=>"as a ,  hmm_users as e ",:conditions => "e.id!='' #{session[:search_cond_media]} and a.e_filetype='image' and a.status = 'active'")
      @stat_video = UserContent.count(:all, :joins=>"as a , hmm_users as e ",:conditions => "e.id!='' #{session[:search_cond_media]} and a.e_filetype='VIDEO' and a.status = 'active'")
      @stat_audio = UserContent.count(:all, :joins=>"as a , hmm_users as e ",:conditions => "e.id!='' #{session[:search_cond_media]} and a.e_filetype='AUDIO' and a.status = 'active'")

    end

    render :layout => true
  end

  def hmm_reporting_excel
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="statisticalreport.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end

    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked'")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked'")


    if(params[:company]==nil && params[:studios]==nil && params[:managers]==nil )
    else
      if(params[:company]!=nil)
        company="and c.studio_groupid = '#{params[:company_value]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'platinum_user'"
        company_active_user=" and DATE_FORMAT(a.account_expdate,'%Y-%m-%d') >= curdate()"
        company_cancled_user="and a.cancel_status='approved' and a.canceled_by!='-2'"
        company_declined_user="and a.cancel_status='approved' and a.canceled_by='-2'"

        company_familyws="and c.studio_groupid = '#{params[:company_value]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'familyws_user'"
        company_active_fwuser="and DATE_FORMAT(a.account_expdate,'%Y-%m-%d') >= curdate()"
        company_cancled_fwuser="and a.cancel_status='approved' and a.canceled_by !='-2'"
        company_declined_fwuser="and a.cancel_status='approved' and a.canceled_by ='-2'"

        company_free="and c.studio_groupid = '#{params[:company_value]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'free_user'"
        company_media = "and c.studio_groupid = '#{params[:company_value]}' AND d.store_id = c.id AND d.id = e.emp_id and e.id=a.uid"
      end

      if(params[:studios]!=nil)
        studio="AND d.store_id = '#{params[:studio_value]}' AND d.id = a.emp_id AND a.account_type = 'platinum_user'"
        studio_active_user = "and DATE_FORMAT(a.account_expdate,'%Y-%m-%d') >= curdate()"
        studio_cancled_user = "and a.cancel_status='approved' and a.canceled_by!='-2'"
        company_declined_user="and a.cancel_status='approved' and a.canceled_by='-2'"

        studio_familyws="AND d.store_id = '#{params[:studio_value]}' AND d.id = a.emp_id AND a.account_type = 'familyws_user'"
        studio_active_familyws="and DATE_FORMAT(a.account_expdate,'%Y-%m-%d') >= curdate()"
        studio_cancled_familyws="and a.cancel_status='approved' and a.canceled_by!='-2'"
        studio_declined_familyws="and a.cancel_status='approved' and a.canceled_by ='-2'"

        studio_free="AND d.store_id = '#{params[:studio_value]}' AND d.id = a.emp_id AND a.account_type = 'free_user'"
        studio_media="AND d.store_id = '#{params[:studio_value]}' AND d.id = e.emp_id and e.id=a.uid"
      end

      if(params[:managers]!=nil)
        manager="AND emp_id = '#{params[:manager_value]}' AND account_type = 'platinum_user'"
        manager_active_user="and DATE_FORMAT(account_expdate,'%Y-%m-%d') >= curdate()"
        manager_cancled_user="and cancel_status='approved' and canceled_by!='-2'"
        company_declined_user="and cancel_status='approved' and canceled_by='-2'"

        manager_familyws="AND emp_id = '#{params[:manager_value]}' AND account_type = 'familyws_user'"
        manager_active_familyws="and DATE_FORMAT(account_expdate,'%Y-%m-%d') >= curdate()"
        manager_cancled_familyws="and cancel_status='approved' and canceled_by!='-2'"
        manager_declined_familyws="and cancel_status='approved' and canceled_by ='-2'"

        manager_free="AND emp_id = '#{params[:studio_value]}' AND account_type = 'free_user'"
        manager_media="AND e.emp_id = '#{params[:manager_value]}' and e.id=a.uid"
      end
    end


    if(params[:company]== nil && params[:studios]== nil && params[:managers]== nil )

    else
      if(params[:company]!=nil)
        session[:search_cond]="#{company}  "
        session[:search_cond_active]="#{company}  #{company_active_user} "
        session[:search_fwcond]="#{company_familyws} "
        session[:search_freecond]="#{company_free} "
        session[:search_cond_media]="#{company_media}  "

      end

      if(params[:studios]!=nil)
        session[:search_cond]="#{studio}  "
        session[:search_cond_active]="#{studio}  #{studio_active_user} "
        session[:search_fwcond]="#{studio_familyws} "
        session[:search_freecond]="#{studio_free} "
        session[:search_cond_media]="#{studio_media}  "
      end
      if(params[:managers]!=nil)
        session[:search_cond]="#{manager}  "
        session[:search_cond_active]="#{manager}  #{manager_active_user} "
        session[:search_fwcond]="#{manager_familyws} "
        session[:search_freecond]="#{manager_free} "
        session[:search_cond_media]="#{manager_media}  "
      end
    end
    if(params[:company]!=nil)
      @hmm_users_premium = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_cond]}")
      @hmm_users_premium_active = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_cond]} #{company_active_user}")
      @hmm_users_premium_cancled = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_cond]} #{company_cancled_user}")
      @hmm_users_premium_declined = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_cond]} #{company_declined_user}")

      @premium_avg_membership = HmmUser.count_by_sql("SELECT sum( DATEDIFF( a.account_expdate, a.d_created_date ) ) FROM hmm_users AS a, hmm_studios AS c, employe_accounts AS d WHERE c.studio_groupid ='#{params[:company_value]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'platinum_user' AND a.account_expdate > current_date( ) and  a.cupon_no IS NULL ;")
      @premium_avg_membership_cont = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions => " c.studio_groupid = '#{params[:company_value]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'platinum_user' AND a.account_expdate > current_date( ) AND a.cupon_no IS NULL ")
      if (@premium_avg_membership_cont != 0)
        @avg_membership = (@premium_avg_membership / @premium_avg_membership_cont)
      else
        @avg_membership = 0
      end

      @hmm_users_familyws = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_fwcond]}")
      @hmm_users_familyws_active = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_fwcond]} #{company_active_fwuser}")
      @hmm_users_familyws_cancled = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_fwcond]} #{company_cancled_fwuser}")
      @hmm_users_familyws_declined = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_fwcond]} #{company_declined_fwuser}")

      @family_avg_membership = HmmUser.count_by_sql("SELECT sum( DATEDIFF( a.account_expdate, a.d_created_date ) ) FROM hmm_users AS a, hmm_studios AS c, employe_accounts AS d WHERE c.studio_groupid ='#{params[:company_value]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'familyws_user' AND a.account_expdate > current_date( ) and a.cupon_no IS NULL ;")
      @family_avg_membership_cont = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions => " c.studio_groupid = '#{params[:company_value]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'familyws_user' AND a.account_expdate > current_date( ) and a.cupon_no IS NULL ")
      if(@family_avg_membership_cont != 0)
        @avg_family_membership = (@family_avg_membership / @family_avg_membership_cont)
      else
        @avg_family_membership = 0
      end

      @hmm_users_free = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_freecond]} ")
      #@hmm_users_free = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_freecond]} ")
      @free_avg_age = HmmUser.count_by_sql("SELECT sum( DATEDIFF( current_date( ) , a.d_created_date  ) ) FROM hmm_users AS a, hmm_studios AS c, employe_accounts AS d WHERE c.studio_groupid ='#{params[:company_value]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'free_user';")
      @free_avg_age_cont = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions => " c.studio_groupid = '#{params[:company_value]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'free_user'")
      if(@free_avg_age_cont != 0)
        @avg_free_age = (@free_avg_age / @free_avg_age_cont)
      else
        @avg_free_age = 0
      end

      @stat_imag = UserContent.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d , hmm_users as e",:conditions => "e.id!='' #{session[:search_cond_media]} and a.e_filetype='image' and a.status = 'active'")
      @stat_video = UserContent.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d, hmm_users as e ",:conditions => "e.id!='' #{session[:search_cond_media]} and a.e_filetype='VIDEO' and a.status = 'active'")
      @stat_audio = UserContent.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d, hmm_users as e ",:conditions => "e.id!='' #{session[:search_cond_media]} and a.e_filetype='AUDIO' and a.status = 'active'")
    end

    if(params[:studios]!=nil)
      @hmm_users_premium = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_cond]}")
      @hmm_users_premium_active = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_cond]} #{studio_active_user}")
      @hmm_users_premium_cancled = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_cond]} #{studio_cancled_user}")
      @hmm_users_premium_declined = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_cond]}  #{company_declined_user}")

      @premium_avg_membership = HmmUser.count_by_sql("SELECT sum( DATEDIFF( a.account_expdate, a.d_created_date ) ) FROM hmm_users AS a, employe_accounts AS d WHERE d.store_id = '#{params[:studio_value]}' AND d.id = a.emp_id AND a.account_type = 'platinum_user' AND a.account_expdate > current_date( ) and a.cupon_no IS NULL ;")
      @premium_avg_membership_cont = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions => "d.store_id = '#{params[:studio_value]}' AND d.id = a.emp_id  AND a.account_type = 'platinum_user' AND a.account_expdate > current_date( ) and a.cupon_no IS NULL")
      if (@premium_avg_membership_cont != 0)
        @avg_membership = (@premium_avg_membership / @premium_avg_membership_cont)
      else
        @avg_membership = 0
      end

      @hmm_users_familyws = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_fwcond]}")
      @hmm_users_familyws_active = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_fwcond]} #{studio_active_familyws}")
      @hmm_users_familyws_cancled = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_fwcond]} #{studio_cancled_familyws}")
      @hmm_users_familyws_declined = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_fwcond]} #{studio_declined_familyws}")

      @family_avg_membership = HmmUser.count_by_sql("SELECT sum( DATEDIFF( a.account_expdate, a.d_created_date ) ) FROM hmm_users AS a, employe_accounts AS d WHERE d.store_id = '#{params[:studio_value]}' AND d.id = a.emp_id AND a.account_type = 'familyws_user' AND a.account_expdate > current_date( ) and a.cupon_no IS NULL ;")
      @family_avg_membership_cont = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions => " d.store_id = '#{params[:studio_value]}' AND d.id = a.emp_id  AND a.account_type = 'familyws_user' AND a.account_expdate > current_date( ) and a.cupon_no IS NULL ")
      if(@family_avg_membership_cont != 0)
        @avg_family_membership = (@family_avg_membership / @family_avg_membership_cont)
      else
        @avg_family_membership = 0
      end

      @hmm_users_free = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_freecond]} ")
      @free_avg_age = HmmUser.count_by_sql("SELECT sum( DATEDIFF( a.account_expdate, a.d_created_date ) ) FROM hmm_users AS a, employe_accounts AS d WHERE d.store_id = '#{params[:studio_value]}' AND d.id = a.emp_id AND a.account_type = 'free_user' ;")
      @free_avg_age_cont = HmmUser.count(:all, :joins=>"as a , employe_accounts as d ", :conditions => " d.store_id = '#{params[:studio_value]}' AND d.id = a.emp_id  AND a.account_type = 'free_user'")
      if (@free_avg_age_cont != 0)
        @avg_free_age = (@free_avg_age / @free_avg_age_cont)
      else
        @avg_free_age = 0
      end
      #@hmm_users_free = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_freecond]} ")

      @stat_imag = UserContent.count(:all, :joins=>"as a , employe_accounts as d , hmm_users as e",:conditions => "e.id!='' #{session[:search_cond_media]} and a.e_filetype='image' and a.status = 'active'")
      @stat_video = UserContent.count(:all, :joins=>"as a , employe_accounts as d , hmm_users as e ",:conditions => "e.id!='' #{session[:search_cond_media]} and a.e_filetype='VIDEO' and a.status = 'active'")
      @stat_audio = UserContent.count(:all, :joins=>"as a , employe_accounts as d , hmm_users as e ",:conditions => "e.id!='' #{session[:search_cond_media]} and a.e_filetype='AUDIO' and a.status = 'active'")


    end

    if(params[:managers]!=nil)
      @hmm_users_premium = HmmUser.count(:all,  :conditions =>"id!='' #{session[:search_cond]}")
      @hmm_users_premium_active = HmmUser.count(:all,  :conditions =>"id!='' #{session[:search_cond]} #{manager_active_user}")
      @hmm_users_premium_cancled = HmmUser.count(:all, :conditions =>"id!='' #{session[:search_cond]} #{manager_cancled_user}")
      @hmm_users_premium_declined = HmmUser.count(:all, :conditions =>"id!='' #{session[:search_cond]} #{company_declined_user}")

      @premium_avg_membership = HmmUser.count_by_sql("SELECT sum( DATEDIFF( account_expdate, d_created_date ) ) FROM hmm_users WHERE emp_id = '#{params[:manager_value]}' AND account_type = 'platinum_user' AND account_expdate > current_date( ) and cupon_no IS NULL;")
      @premium_avg_membership_cont = HmmUser.count(:all, :conditions => "emp_id = '#{params[:manager_value]}' AND account_type = 'platinum_user' AND account_expdate > current_date( ) and cupon_no IS NULL")
      if (@premium_avg_membership_cont != 0)
        @avg_membership = (@premium_avg_membership / @premium_avg_membership_cont)
      else
        @avg_membership = 0
      end

      @hmm_users_familyws = HmmUser.count(:all, :conditions =>"id!='' #{session[:search_fwcond]}")
      @hmm_users_familyws_active = HmmUser.count(:all, :conditions =>"id!='' #{session[:search_fwcond]} #{manager_active_familyws}")
      @hmm_users_familyws_cancled = HmmUser.count(:all, :conditions =>"id!='' #{session[:search_fwcond]} #{manager_cancled_familyws}")
      @hmm_users_familyws_declined = HmmUser.count(:all, :conditions =>"id!='' #{session[:search_fwcond]} #{manager_declined_familyws}")

      @family_avg_membership = HmmUser.count_by_sql("SELECT sum( DATEDIFF( account_expdate, d_created_date ) ) FROM hmm_users WHERE emp_id = '#{params[:manager_value]}' AND account_type = 'familyws_user' AND account_expdate > current_date( ) and cupon_no IS NULL ;")
      @family_avg_membership_cont = HmmUser.count(:all, :conditions => "emp_id = '#{params[:manager_value]}' AND account_type = 'familyws_user' AND account_expdate > current_date( ) and cupon_no IS NULL ")
      if(@family_avg_membership_cont != 0)
        @avg_family_membership = (@family_avg_membership / @family_avg_membership_cont)
      else
        @avg_family_membership = 0
      end

      @hmm_users_free = HmmUser.count(:all, :conditions =>"id!='' #{session[:search_freecond]} ")
      #@hmm_users_free = HmmUser.count(:all, :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"a.id!='' #{session[:search_freecond]} ")
      @free_avg_age = HmmUser.count_by_sql("SELECT sum( DATEDIFF( account_expdate, d_created_date ) ) FROM hmm_users WHERE emp_id = '#{params[:manager_value]}' AND account_type = 'free_user';")
      @free_avg_age_cont = HmmUser.count(:all, :conditions => "emp_id = '#{params[:manager_value]}' AND account_type = 'free_user'")
      if(@free_avg_age_cont != 0)
        @avg_free_age = (@free_avg_age / @free_avg_age_cont)
      else
        @avg_free_age = 0
      end

      @stat_imag = UserContent.count(:all, :joins=>"as a ,  hmm_users as e ",:conditions => "e.id!='' #{session[:search_cond_media]} and a.e_filetype='image' and a.status = 'active'")
      @stat_video = UserContent.count(:all, :joins=>"as a , hmm_users as e ",:conditions => "e.id!='' #{session[:search_cond_media]} and a.e_filetype='VIDEO' and a.status = 'active'")
      @stat_audio = UserContent.count(:all, :joins=>"as a , hmm_users as e ",:conditions => "e.id!='' #{session[:search_cond_media]} and a.e_filetype='AUDIO' and a.status = 'active'")

    end

    render :layout => false
  end

  def feed_report
    @feeds=FeedUpdate.find(:all)
  end

  def othercustomer_login

  end

  def confirm_action

  end

  def othercustomer_accept
    hmmuser=HmmUser.find(logged_in_hmm_user.id)
    if(logged_in_hmm_user.family_name=='' or logged_in_hmm_user.family_name==nil )
      @uuid =  HmmUser.find_by_sql(" select UUID() as u")
      unnid = @uuid[0]['u']
      hmmuser = HmmUser.find(logged_in_hmm_user.id)
      hmmuser.family_name="#{logged_in_hmm_user.id}#{unnid}un#{logged_in_hmm_user.id}"
      hmmuser.save
    end
    #hmmuser.emp_id=session[:employe]
    #hmmuser.save
    employeaccount=EmployeAccount.find(session[:employe])
    store_id=employeaccount.store_id
    tagcount=Tag.count(:all,:conditions => "(v_tagname='studio sessions' or v_tagname='Studio session') and uid=#{logged_in_hmm_user.id}  ")
    if(tagcount > 0)
      tag=Tag.find(:all, :conditions => "(v_tagname='studio sessions' or v_tagname='Studio session') and uid=#{logged_in_hmm_user.id} ")

      tagid=tag[0].id
    else
      tag=Tag.new
      tag.uid=logged_in_hmm_user.id
      tag.v_tagname="Studio Sessions"
      tag.v_chapimage="folder_img.png"
      tag.e_access="public"
      tag.d_createddate=Time.now
      tag.d_updateddate=Time.now
      tag.status='active'
      tag.save
      tagid=tag.id
    end
    puts store_id
    hmmstudio=HmmStudio.find(store_id)
    require 'pp'
    pp hmmstudio
    studio_branch=hmmstudio.studio_branch
    subchapcount=SubChapter.count(:all,:conditions =>"store_id='#{hmmstudio.id}' and uid='#{logged_in_hmm_user.id}'")

    if(subchapcount > 0)
    else
      subchap=SubChapter.new
      subchap.uid=logged_in_hmm_user.id
      subchap.tagid=tagid
      subchap.store_id=store_id
      subchap.v_image='folder_img.png'
      subchap.e_access='public'
      subchap.sub_chapname=studio_branch
      subchap.d_created_on=Time.now
      subchap.d_updated_on=Time.now
      subchap.status='active'
      subchap.save
    end
    if(logged_in_hmm_user.emp_id=='' || logged_in_hmm_user.emp_id==nil)

    else
      #    hmm_user_past_studio=HmmUsersPastStudios.new
      #    hmm_user_past_studio.uid=logged_in_hmm_user.id
      #    hmm_user_past_studio.past_studio=logged_in_hmm_user.emp_id
      #    hmm_user_past_studio.save
    end

    redirect_to :controller=>'manage_site',:action=>'home', :id=>logged_in_hmm_user.family_name


  end

  def template_measurement

    @themes= Theme.find(:all,:select=>"a.name as name,count(b.id) as no_of_users",:joins=>"as a,hmm_users as b", :conditions => "a.id =b.theme_id",:order=>"no_of_users desc", :group => "a.id" )
    @unused_themes= Theme.find_by_sql("SELECT * FROM themes where id not in( select theme_id from hmm_users group by theme_id)")
  end

  def coupon_userlist
    sort_init 'id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "id desc"
      else

        sort = "id desc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end
    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "cupon_no like 'SP%'")
    # @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked'")
    @hmm_users = HmmUser.paginate :select => "*", :per_page => 10,:conditions=>" cupon_no like 'SP%'", :page => params[:page], :order => sort

    render :layout => true
  end

  def coupon_userlist1
    sort_init 'id'
    sort_update


    if(params[:coupon]==nil && params[:coupon2]==nil)
      @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "cupon_no like 'SP%'")

      couponcondition=" and cupon_no like 'SP%' "
    else
      session[:coupon]=params[:coupon]
      session[:coupon2]=params[:coupon2]

      @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "cupon_no between '#{session[:coupon]}' and '#{session[:coupon2]}'")

      @coupon=session[:coupon]
      if(@coupon!="" && session[:coupon]!=nil && session[:coupon2]!=nil)
        couponcondition="and cupon_no between '#{session[:coupon]}' and '#{session[:coupon2]}'"
      end

    end

    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "id desc"
      else

        sort = "id desc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end

    if(params[:coupon]== nil)
      #session[:search_cond]="#{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}"
    else
      session[:search_cond]="#{couponcondition}"
    end
    @hmm_users = HmmUser.paginate :per_page => 10, :page => params[:page] , :conditions =>"id!='' #{session[:search_cond]}", :order =>  sort

    render :layout => true
  end

  def zipcodeReport

    sort_init 'id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"
    if(srk==nil)
      sortorder="id desc"
    else
      sortorder=sort
    end

    if(params[:zipcode]!=nil && params[:zipcode]!="")
      zipcond=" and zip_code='#{params[:zipcode]}'"
    else
      zipcond=""
    end

    if(params[:miles]!=nil && params[:miles]!="")
      milecond=" and miles='#{params[:miles]}' "
    else
      milecond=""
    end

    if(params[:zipcode]== nil && params[:miles]== nil)
      session[:search_cond]=""
    else
      session[:search_cond]="#{zipcond} #{milecond}"
    end

    @zips = ZipcodeSearch.paginate :per_page => 10, :page => params[:page], :select =>"*", :order => sortorder ,:conditions=>" 1=1 #{session[:search_cond]}"

  end

  def assign_studioid
    hmm_users = HmmUser.find(:all, :conditions => "emp_id is not null and studio_id=0", :limit => "0,10")
    for hmm_user in hmm_users
      employe_account=Employe_account.find(hmm_user.emp_id)
      studio_id = employe_account.store_id
      hmm_user_update = HmmUser.find(hmm_user.id)
      hmm_user_update.studio_id = studio_id
      hmm_user_update.save
    end
    render :layout => false

  end



  def track_account
    @result=TrackAccount.find(:first)

  end

  def commissionReport_new

    unless params[:sub].blank?

      if (params[:from_year]!=nil && params[:from_month] !=nil && params[:from_day] !=nil )
        @fromdate="#{params[:from_year]}-#{params[:from_month]}-#{params[:from_day]}"
      end

      if (params[:to_year]!=nil && params[:to_month] !=nil && params[:to_day] !=nil )
        @todate="#{params[:to_year]}-#{params[:to_month]}-#{params[:to_day]}"
      end

    end

    @manager_commission_list = EmployeAccount.find(:all,:select=>"a.*",:joins=>"as a, hmm_studios as b", :conditions => "a.emp_type='store_manager' and a.store_id=b.id and b.studio_groupid=1",:order=>"a.employe_name")


    if params[:choose]=="studio_commission"
      @hmm_studios = HmmStudio.find(:all,:conditions=>"studio_groupid=1")
      @partial_name="studio_commission"
    elsif params[:choose]=="studio_manager_commission"
      if params[:manager].blank?
        @manager_commission = EmployeAccount.find(:all,:select=>"a.*,b.studio_name",:joins=>" as a, hmm_studios as b", :conditions => "a.emp_type='store_manager' and b.id=a.store_id")
      else
        @manager_commission = EmployeAccount.find(:all,:select=>"a.*,b.studio_name",:joins=>" as a, hmm_studios as b", :conditions => "a.id=#{params[:manager]} and b.id=a.store_id")
      end
      @partial_name="manager_commission"
    elsif params[:choose]=="market_manager_commission"
      @marketmanager_commission = MarketManager.find(:all)
      @partial_name="marketmanager_commission"
    end

  end

  def commissionReport_market_manager_new

    unless params[:sub].blank?
      if (params[:from_year]!=nil && params[:from_month] !=nil && params[:from_day] !=nil )
        @fromdate="#{params[:from_year]}-#{params[:from_month]}-#{params[:from_day]}"
      end

      if (params[:to_year]!=nil && params[:to_month] !=nil && params[:to_day] !=nil )
        @todate="#{params[:to_year]}-#{params[:to_month]}-#{params[:to_day]}"
      end
    end


    @manager_studios=ManagerBranche.find(:all,:select=>"a.*",:joins=>"as a, hmm_studios as b",:conditions => "a.branch_id=b.id and b.studio_groupid=1 and a.manager_id='#{params[:id]}'")
    @marketmanager_commission = MarketManager.find(:all, :conditions => "id='#{params[:id]}'")
    studios="(0"
    for studio in @manager_studios
      studios="#{studios},#{studio.branch_id}"
    end
    studios="#{studios})"
    @manager_commission_list = EmployeAccount.find(:all,:select=>"a.*",:joins=>"as a, hmm_studios as b", :conditions => "a.emp_type='store_manager' and a.store_id=b.id and b.studio_groupid=1",:order=>"a.employe_name")
    if params[:choose]=="studio_commission"
      @hmm_studios = HmmStudio.find(:all, :conditions => " id in  #{studios} and studio_groupid=1")
      @partial_name="studio_commission"
    elsif params[:choose]=="studio_manager_commission"
      if params[:manager].blank?
        @manager_commission = EmployeAccount.find(:all, :conditions => "emp_type='store_manager' and store_id in #{studios}")
      else
        @manager_commission = EmployeAccount.find(:all, :conditions => "emp_type='store_manager' and store_id in #{studios} and id=#{params[:manager]}")
      end

      @partial_name="manager_commission2"
    end

  end

  def studio_customers_new
    if params[:fromdate] == nil || params[:fromdate] == ''
    else
      session[:fromdate] = params[:fromdate]
    end

    if params[:todate] == nil || params[:todate] == ''
    else
      session[:todate] = params[:todate]
    end

    sort_init 'a.id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "a.id desc"
      else

        sort = "#{session[:srk]}  #{params[:sort_order]}"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end
    @customers = HmmUser.paginate :select =>"a.*,b.*,c.*", :joins => "as a, employe_accounts as b, payment_counts as c", :conditions => "a.studio_id='#{params[:id]}' and b.id=c.emp_id and a.id=c.uid and  a.studio_id=b.store_id and a.account_type='platinum_user'  and c.recieved_on between '#{session[:fromdate]}' and '#{session[:todate]}'", :per_page => 25, :order => sort, :page => params[:page],:group =>'c.uid'
    # @customers = HmmUser.find(:all,
    @customer_count = HmmUser.count('DISTINCT c.uid', :joins => "as a, employe_accounts as b, payment_counts as c", :conditions => "a.studio_id='#{params[:id]}' and b.id=c.emp_id and a.id=c.uid and  a.studio_id=b.store_id and a.account_type='platinum_user'  and c.recieved_on between '#{session[:fromdate]}1' and '#{session[:todate]}'")
  end

  def studio_employee_customers_new
    if params[:fromdate] == nil || params[:fromdate] == ''
    else
      session[:fromdate] = params[:fromdate]
    end

    if params[:todate] == nil || params[:todate] == ''
    else
      session[:todate] = params[:todate]
    end

    sort_init 'a.id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "a.id desc"
      else

        sort = "#{session[:srk]}  #{params[:sort_order]}"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end

    empdet=EmployeAccount.find(params[:id])
    if(empdet.emp_type=='store_manager')
      emplist="(0,"

      employees=EmployeAccount.find(:all,:conditions => "store_id='#{empdet.store_id}'  and emp_type!='store_manager'")
      for employee in employees
        emplist="#{emplist}#{employee.id},"
      end
      emplist="#{emplist}#{empdet.id})"
      if(params[:store_id])
        conditions = "a.emp_id='#{params[:id]}' and a.studio_id='#{params[:store_id]}' and c.emp_id=b.id and c.uid=a.id  and a.account_type='platinum_user' and c.recieved_on between '#{session[:fromdate]}' and '#{session[:todate]}'  and (a.amount='$9.95' or a.amount='$49.95' or a.amount='$99.95')  "
      else
        conditions = "a.emp_id='#{params[:id]}' and c.emp_id=b.id and c.uid=a.id  and a.account_type='platinum_user' and c.recieved_on between '#{session[:fromdate]}' and '#{session[:todate]}'  and (a.amount='$9.95' or a.amount='$49.95' or a.amount='$99.95')  "
      end

    else
      if(params[:manager_id])
        j=EmployeAccount.find(params[:manager_id])
        hmm_users_studios =  HmmUser.find(:all,:select=>"a.studio_id,b.studio_name",:joins=>" as a, hmm_studios as b", :conditions => "a.emp_id='#{params[:manager_id]}' and b.id=a.studio_id ", :group =>"a.studio_id")
        for studio in hmm_users_studios
          hmmuserfrom=HmmUser.find(:all,:select => "id as fromid", :conditions => "emp_id='#{j.id}' and studio_id=#{studio.studio_id}", :limit => "0,1")
          hmmuserto=HmmUser.find(:all,:select => "max(id) as toid", :conditions => "emp_id='#{j.id}' and studio_id=#{studio.studio_id}")
          hmmuserfromdate=HmmUser.find(hmmuserfrom[0].fromid)
          hmmusertodate=HmmUser.find(hmmuserto[0].toid)
          if params[:manager_id].to_i==26
            conditiondate=" and a.d_created_date BETWEEN '#{j.employe_join_date.strftime("%Y-%m-%d")}' and '#{j.end_date.strftime("%Y-%m-%d")}' and  a.d_created_date NOT BETWEEN '2010-11-02' and '2011-01-31'"
          elsif params[:manager_id].to_i==57
            conditiondate=" and a.d_created_date BETWEEN '#{j.employe_join_date.strftime("%Y-%m-%d")}' and '#{j.end_date.strftime("%Y-%m-%d")}' and  a.d_created_date NOT BETWEEN '2010-09-28' and '2010-11-10'"
          else
            if(studio.studio_id==j.store_id)
              conditiondate=" and a.d_created_date between '#{j.employe_join_date.strftime("%Y-%m-%d")}' and '#{j.end_date.strftime("%Y-%m-%d")}'"
            else
              conditiondate=" and a.d_created_date between '#{hmmuserfromdate.d_created_date.strftime("%Y-%m-%d")}' and '#{hmmusertodate.d_created_date.strftime("%Y-%m-%d")}'"
            end
          end
        end
        conditions = "a.emp_id='#{params[:id]}' and c.emp_id=b.id and c.uid=a.id  and a.account_type='platinum_user' and c.recieved_on between '#{session[:fromdate]}' and '#{session[:todate]}'  and (a.amount='$9.95' or a.amount='$49.95' or a.amount='$99.95')  #{conditiondate}"
      else
        conditions = "a.emp_id='#{params[:id]}' and c.emp_id=b.id and c.uid=a.id  and a.account_type='platinum_user' and c.recieved_on between '#{session[:fromdate]}' and '#{session[:todate]}'  and (a.amount='$9.95' or a.amount='$49.95' or a.amount='$99.95')  and a.d_created_date between '#{empdet.employe_join_date.strftime("%Y-%m-%d")} 00:00:00' and '#{empdet.end_date.strftime("%Y-%m-%d")} 23:59:59'"
      end
    end
    logger.info("select DISTINCT c.uid from hmm_users as a,  employe_accounts as b, payment_counts as c where #{conditions} ")
    #@customers = HmmUser.paginate :select =>"a.*,b.*", :joins => "as b, payment_counts as a", :conditions => "a.emp_id='#{params[:id]}' and a.uid=b.id and a.account_type='platinum_user' and (a.amount='$9.95' or a.amount='$49.95' or a.amount='$99.95') and  a.recieved_on between '#{session[:dat]}-01' and '#{session[:dat]}-31' and (b.d_created_datefewfew between '#{empdet.employe_join_date}' and '#{empdet.end_date}' ) ", :per_page => 25, :order => sort, :page => params[:page]
    @customers = HmmUser.paginate :select =>"a.*,b.*,c.*", :joins => "as a, employe_accounts as b, payment_counts as c", :conditions => "#{conditions}", :per_page => 25, :order => sort, :page => params[:page],:group =>'c.uid'
    # @customers = HmmUser.find(:all,
    @customer_count = HmmUser.count('DISTINCT c.uid', :joins => "as a, employe_accounts as b, payment_counts as c", :conditions => "#{conditions}")
  end

  #employee customers excel
  def studio_employee_customers_excel_new

    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="studio_commission_report.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end

    if params[:fromdate] == nil || params[:fromdate] == ''
    else
      session[:fromdate] = params[:fromdate]
    end

    if params[:todate] == nil || params[:todate] == ''
    else
      session[:todate] = params[:todate]
    end

    sort_init 'a.id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "a.id desc"
      else

        sort = "#{session[:srk]}  #{params[:sort_order]}"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end

    empdet=EmployeAccount.find(params[:id])
    if(empdet.emp_type=='store_manager')
      emplist="(0,"

      employees=EmployeAccount.find(:all,:conditions => "store_id='#{empdet.store_id}'  and emp_type!='store_manager'")
      for employee in employees
        emplist="#{emplist}#{employee.id},"
      end
      emplist="#{emplist}#{empdet.id})"
      if(params[:store_id])
        conditions = "a.emp_id='#{params[:id]}' and a.studio_id='#{params[:store_id]}' and c.emp_id=b.id and c.uid=a.id  and a.account_type='platinum_user' and c.recieved_on between '#{session[:fromdate]}' and '#{session[:todate]}'  and (a.amount='$9.95' or a.amount='$49.95' or a.amount='$99.95')  "
      else
        conditions = "a.emp_id='#{params[:id]}' and c.emp_id=b.id and c.uid=a.id  and a.account_type='platinum_user' and c.recieved_on between '#{session[:fromdate]}' and '#{session[:todate]}'  and (a.amount='$9.95' or a.amount='$49.95' or a.amount='$99.95')  "
      end

    else
      if(params[:manager_id])
        j=EmployeAccount.find(params[:manager_id])
        hmm_users_studios =  HmmUser.find(:all,:select=>"a.studio_id,b.studio_name",:joins=>" as a, hmm_studios as b", :conditions => "a.emp_id='#{params[:manager_id]}' and b.id=a.studio_id ", :group =>"a.studio_id")
        for studio in hmm_users_studios
          hmmuserfrom=HmmUser.find(:all,:select => "id as fromid", :conditions => "emp_id='#{j.id}' and studio_id=#{studio.studio_id}", :limit => "0,1")
          hmmuserto=HmmUser.find(:all,:select => "max(id) as toid", :conditions => "emp_id='#{j.id}' and studio_id=#{studio.studio_id}")
          hmmuserfromdate=HmmUser.find(hmmuserfrom[0].fromid)
          hmmusertodate=HmmUser.find(hmmuserto[0].toid)
          if params[:manager_id].to_i==26
            conditiondate=" and a.d_created_date BETWEEN '#{j.employe_join_date.strftime("%Y-%m-%d")}' and '#{j.end_date.strftime("%Y-%m-%d")}' and  a.d_created_date NOT BETWEEN '2010-11-02' and '2011-01-31'"
          elsif params[:manager_id].to_i==57
            conditiondate=" and a.d_created_date BETWEEN '#{j.employe_join_date.strftime("%Y-%m-%d")}' and '#{j.end_date.strftime("%Y-%m-%d")}' and  a.d_created_date NOT BETWEEN '2010-09-28' and '2010-11-10'"
          else
            if(studio.studio_id==j.store_id)
              conditiondate=" and a.d_created_date between '#{j.employe_join_date.strftime("%Y-%m-%d")}' and '#{j.end_date.strftime("%Y-%m-%d")}'"
            else
              conditiondate=" and a.d_created_date between '#{hmmuserfromdate.d_created_date.strftime("%Y-%m-%d")}' and '#{hmmusertodate.d_created_date.strftime("%Y-%m-%d")}'"
            end
          end
        end
        conditions = "a.emp_id='#{params[:id]}' and c.emp_id=b.id and c.uid=a.id  and a.account_type='platinum_user' and c.recieved_on between '#{session[:fromdate]}' and '#{session[:todate]}'  and (a.amount='$9.95' or a.amount='$49.95' or a.amount='$99.95')  #{conditiondate}"
      else
        conditions = "a.emp_id='#{params[:id]}' and c.emp_id=b.id and c.uid=a.id  and a.account_type='platinum_user' and c.recieved_on between '#{session[:fromdate]}' and '#{session[:todate]}'  and (a.amount='$9.95' or a.amount='$49.95' or a.amount='$99.95')  and a.d_created_date between '#{empdet.employe_join_date.strftime("%Y-%m-%d")} 00:00:00' and '#{empdet.end_date.strftime("%Y-%m-%d")} 23:59:59'"
      end
    end
    logger.info("select DISTINCT c.uid from hmm_users as a,  employe_accounts as b, payment_counts as c where #{conditions} ")
    #@customers = HmmUser.paginate :select =>"a.*,b.*", :joins => "as b, payment_counts as a", :conditions => "a.emp_id='#{params[:id]}' and a.uid=b.id and a.account_type='platinum_user' and (a.amount='$9.95' or a.amount='$49.95' or a.amount='$99.95') and  a.recieved_on between '#{session[:dat]}-01' and '#{session[:dat]}-31' and (b.d_created_datefewfew between '#{empdet.employe_join_date}' and '#{empdet.end_date}' ) ", :per_page => 25, :order => sort, :page => params[:page]
    @customers = HmmUser.paginate :select =>"a.*,b.*,c.*", :joins => "as a, employe_accounts as b, payment_counts as c", :conditions => "#{conditions}", :per_page => 2000, :order => sort, :page => params[:page],:group =>'c.uid'
    # @customers = HmmUser.find(:all,
    @customer_count = HmmUser.count('DISTINCT c.uid', :joins => "as a, employe_accounts as b, payment_counts as c", :conditions => "#{conditions}")
    render :layout => false
  end

  #studio customers
  def studio_customers_excel_new

    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="studio_commission_report.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end

    if params[:fromdate] == nil || params[:fromdate] == ''
    else
      session[:fromdate] = params[:fromdate]
    end

    if params[:todate] == nil || params[:todate] == ''
    else
      session[:todate] = params[:todate]
    end

    sort_init 'a.id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "a.id desc"
      else

        sort = "#{session[:srk]}  #{params[:sort_order]}"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end
    @customers = HmmUser.paginate :select =>"a.*,b.*,c.*", :joins => "as a, employe_accounts as b, payment_counts as c", :conditions => "a.studio_id='#{params[:id]}' and b.id=c.emp_id and a.id=c.uid and  a.studio_id=b.store_id and a.account_type='platinum_user'  and c.recieved_on between '#{params[:fromdate]}' and '#{params[:todate]}'", :per_page => 5000, :order => sort, :page => params[:page],:group =>'c.uid'
    # @customers = HmmUser.find(:all,
    @customer_count = HmmUser.count('DISTINCT c.uid', :joins => "as a, employe_accounts as b, payment_counts as c", :conditions => "a.studio_id='#{params[:id]}' and b.id=c.emp_id and a.id=c.uid and a.studio_id=b.store_id and a.account_type='platinum_user'  and c.recieved_on between '#{params[:fromdate]}1' and '#{params[:todate]}'")
    render :layout => false
  end


  def content_download_list
    hmm_user=HmmUser.find(params[:id])
    @countcheck=Galleries.count(:all, :joins => "as a, sub_chapters as b", :conditions => "subchapter_id=b.id and b.uid='#{params[:id]}' and a.status='active' and a.e_gallery_acess='public'")
    @galleries = Galleries.paginate :select => "a.*", :joins => "as a, sub_chapters as b", :per_page => 200, :page => params[:page], :conditions => "subchapter_id=b.id and b.uid='#{params[:id]}' and a.status='active' and a.e_gallery_acess='public'" ,:order => 'id desc '


  end

  def photobook_background_list
    @background=PhotobookBackground.paginate :all, :per_page => 30, :page => params[:page],:order => 'id desc '
  end



  def photobook_stickers_list
    @sticker=PhotobookSticker.paginate :all, :per_page => 30, :page => params[:page],:order => 'id desc '
  end

  def refund_other_commission

    if(params[:reason])
      studio_commission=StudioCommission.find(params[:id])
      studio_commission.status='active'
      studio_commission.reason=params[:reason]
      studio_commission.save


      flash[:notice]="Commission amount deducted sucessfully"
      redirect_to :controller=>'account',:action=>'other_studio_customers', :studio_id=>params[:studio_id], :date => params[:date]

    end
  end

  def deduct_manager_commission
    @studio_manager=EmployeAccount.find(params[:id])

    if(params[:amount])
      deduct_manager_commission=DeductManagerCommission.new
      deduct_manager_commission.amount = params[:amount]
      deduct_manager_commission.reason = params[:reason]
      deduct_manager_commission.studio_manager_id = params[:store_manager_id]
      deduct_manager_commission.studio_id = params[:studio_id]
      deduct_manager_commission.deduction_date = "#{params[:to_year]}-#{params[:to_month]}-#{params[:to_day]}"
      deduct_manager_commission.save
      redirect_to "/account/deducted_list/#{params[:store_manager_id]}"
    end
  end

  def deducted_list
    @deduct_manager_commission=DeductManagerCommission.paginate :page => params[:page], :per_page => "10", :conditions => "studio_manager_id=#{params[:id]}"
    @studio_manager=EmployeAccount.find(params[:id])
  end

  def delete_deduction
    deduct_manager_commission = DeductManagerCommission.destroy(params[:id])
    redirect_to "/account/deducted_list/#{params[:store_manager_id]}"
  end

  def create_studiosession_chapter
    @get_content_url=ContentPath.find(:all, :conditions => "status='active'")
    content_path=@get_content_url[0]['content_path']
    id=params[:id]
    hmm_user_det = HmmUser.find(id)
    if(hmm_user_det.emp_id=='' or hmm_user_det.emp_id==nil)
      hmm_user_det.emp_id = session[:employe]
      hmm_user_det.save
    end
    employedet=EmployeAccount.find(hmm_user_det.emp_id)
    hmmstudio=HmmStudio.find(employedet.store_id)
    hmm_user_det.studio_id = employedet.store_id
    hmm_user_det.save
    if(hmm_user_det.emp_id)

      subchaptercount=SubChapter.count(:all, :conditions => "store_id > 0 and uid=#{hmm_user_det.id}")
      if(subchaptercount > 0)
        subchaptercheck = SubChapter.count(:all, :conditions => "store_id = #{employedet.store_id}  and uid=#{hmm_user_det.id} ")
        if(subchaptercheck > 0)
        else
          subchapterfind=SubChapter.find(:first, :conditions => "store_id > 0  and uid=#{hmm_user_det.id}")
          subchapter_new = SubChapter.new
          subchapter_new['uid']= hmm_user_det.id
          subchapter_new['tagid']= subchapterfind.tagid
          subchapter_new['sub_chapname']="#{hmmstudio.studio_name}"
          subchapter_new['v_image']="folder_img.png"
          subchapter_new['e_access'] = "public"
          subchapter_new['d_updated_on'] = Time.now
          subchapter_new['d_created_on'] = Time.now
          subchapter_new['img_url']=content_path
          subchapter_new['store_id']= hmmstudio.id
          subchapter_new.save
        end
      else
        tag_default = Tag.new
        tag_default.default_tag='no'
        tag_default.v_tagname="STUDIO SESSIONS"
        tag_default.uid=hmm_user_det.id
        tag_default.default_tag="yes"
        tag_default.e_access = 'public'
        tag_default.e_visible = 'yes'
        tag_default.d_updateddate= Time.now
        tag_default.d_createddate= Time.now
        tag_default.img_url=content_path
        tag_default.v_chapimage = "folder_img.png"
        tag_default.save
        subchapter_new = SubChapter.new
        subchapter_new['uid']= hmm_user_det.id
        subchapter_new['tagid']= tag_default.id
        subchapter_new['sub_chapname']="#{hmmstudio.studio_name}"
        subchapter_new['v_image']="folder_img.png"
        subchapter_new['e_access'] = "public"
        subchapter_new['d_updated_on'] = Time.now
        subchapter_new['d_created_on'] = Time.now
        subchapter_new['img_url']=content_path
        subchapter_new['store_id']= hmmstudio.id
        subchapter_new.save
      end
    end
    redirect_to "#{params[:url]}"

  end

  #studio management customers
  def studio_management_customers
    sort_init 'id'
    sort_update
    @employee = EmployeAccount.find(session[:employe])
    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
    else
      @uname=params[:username]
      if(@uname!="" && params[:username]!=nil)
        params[:username] = (params[:username].gsub("'","")).gsub('"',"")
        usernamecondition="and v_user_name like '#{params[:username]}%' "
      end

      @email=params[:email]
      if(@email!="" && params[:email]!=nil)
        params[:email] = (params[:email].gsub("'","")).gsub('"',"")
        emailcondition="and v_e_mail like '#{params[:email]}%' "
      end

      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end

      @email=params[:email]
      if(@email!="" && params[:email]!=nil)
        params[:email] = (params[:email].gsub("'","")).gsub('"',"")
        emailcondition="and v_e_mail like '#{params[:email]}%' "
      end

      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        params[:firstname] = (params[:firstname].gsub("'","")).gsub('"',"")
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && params[:lastname]!=nil)
        params[:lastname] = (params[:lastname].gsub("'","")).gsub('"',"")
        lastnamecondition="and v_lname like '#{@lname}%' "
      end

      @country=params[:v_country]
      @zip=params[:zip]

      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end

    end

    if params[:sort_key]==nil && params[:sort_order]==nil
      @srk="id  desc"
    else
      @sort_key=params[:sort_key]
      @order=params[:sort_order]
    end
    puts @sort_key
    puts @order
    @srk="#{@sort_key}"+" "+"#{@order}"
    if( @srk==nil || @srk=="" )
      @srk="id  desc"
    end
    puts @srk
    #@hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and studio_id=#{@employee.store_id} #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}")
    #@hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and studio_id=#{@employee.store_id}  #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}")


    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and old_studio_id=#{session[:store_id]} #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and old_studio_id=#{session[:store_id]}  #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}")


    sort_init 'id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="id  desc"
    end

    #@hmm_users = HmmUser.paginate :per_page => 10, :page => params[:page], :select => "*", :conditions => "studio_id=#{@employee.store_id} #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}", :order => sort

    @hmm_users = HmmUser.paginate :per_page => 10, :page => params[:page], :select => "*", :conditions => " old_studio_id=#{session[:store_id]} #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}", :order => sort


    render :layout => true
  end


  def activation_report
    if params[:sub]
      session[:activatedby] =  params[:activatedby]
    end
    if session[:activatedby] == "admin"
      @activateby = session[:activatedby]
      @activate=HmmUser.paginate(:all,:per_page => 20, :page => params[:page],:conditions=>"reactivated_admin!='' || reactivated_admin!='NULL' || (studio_id=170 && (notes_link_to_customer!='' || notes_link_to_customer!='NULL'))")
    elsif session[:activatedby] == "employee"
      @activateby = session[:activatedby]
      @activate=HmmUser.paginate(:all,:per_page => 20, :page => params[:page],:conditions=>"studio_management_notes!='' || studio_management_notes!='NULL' and studio_id=170")
    end
    logger.info(@activate.inspect)
  end

  #reassign notes
  def reassign_notes

    if params[:sub]

      @hmmuser=HmmUser.find(params[:user_id])
      @hmmuser['studio_manager_notes']=params[:notes]
      @hmmuser['studio_id']=@hmmuser.old_studio_id
      @hmmuser['emp_id']=@hmmuser.old_emp_id
      @hmmuser['old_studio_id']=''
      @hmmuser.save

      flash[:error] = "Account Reassigned Successfully"
      redirect_to "/account/studio_management_customers/"

    end
  end


  def reactivated_admin
    @employees=EmployeAccount.find(:all,:conditions=>"store_id=170 and status='unblock'")
    if params[:sub]
      ids=HmmUser.find(:first,:select=>"studio_id,emp_id",:conditions=>"id=#{params[:id]}")
      currentempid=ids.emp_id
      currentstudioid=ids.studio_id
      HmmUser.update(params[:id],:studio_id=>170,:emp_id=>"#{params[:employeeid]}",:old_emp_id=>"#{currentempid}",:old_studio_id=>"#{currentstudioid}", :reactivated_admin=>"#{params[:reactivated_admin]}",:cancel_status=>"")
      CancellationRequest.delete_all("uid = #{params[:id]}")
      redirect_to  "/account/pending_requests_admin"
    end
  end




  def import_image

    @firstname = params[:v_fname]
    @lastname = params[:v_lname]
    @familyname = params[:family_name]
    @val = 0

    sort_init 'id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "id desc"
      else
        sort = "id desc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end

    if(@firstname != nil ||  @lastname != nil || @familyname != nil)
      #@users= HmmUser.paginate(:all, :conditions => ["v_fname LIKE ? and v_lname LIKE ? and family_name LIKE ?", "#{@firstname}%","#{@lastname}%", "#{@familyname}%"],:page => params[:page],:per_page => 10)
      @users= Tag.paginate(:all, :select=>"h.id as id,h.v_fname as v_fname,h.v_lname as v_lname,h.family_name as family_name", :joins => "as t, hmm_users as h", :conditions => ["t.uid = h.id and t.import_type != 'default' and t.status = 'active' and " +"h.v_fname LIKE ? and h.v_lname LIKE ? and h.family_name LIKE ?", "#{@firstname}%","#{@lastname}%", "#{@familyname}%"], :page => params[:page] ,:per_page => 10, :group => "h.id" ,:order =>  sort)
    else
      #@users= HmmUser.paginate(:all,:page => params[:page] ,:per_page => 10,  :select=>"id,v_fname,v_lname,family_name"  )
      @users= Tag.paginate(:all, :select=>"h.id as id,h.v_fname as v_fname,h.v_lname as v_lname,h.family_name as family_name", :joins => "as t, hmm_users as h", :conditions => "t.uid = h.id and t.import_type != 'default' and t.status = 'active'", :page => params[:page] ,:per_page => 10, :group => "h.id", :order => sort)
    end
  end


  def import(id)
    details = Hash.new
    arr1= ['FACEBOOK IMAGES','PICASA IMAGES','FLICKR IMAGES']
    arr2 = ['facebook','picasa','flickr']
    i = 0
    while i < 3 do
      details["#{arr2[i]}"] = UserContent.count(:all,:joins => "as u, galleries as g", :conditions => "u.gallery_id = g.id and g.v_gallery_name = '#{arr1[i]}' and u.uid = #{id} and u.status = 'active'")
      #details["#{arr[i]}"] = UserContent.count(:all, :joins => "as u, galleries as g", :conditions => "u.gallery_id = g.id and g.v_gallery_name = '#{arr[i]}' and u.uid = #{id} and u.status = 'active'")
      #details["#{arr[i]}"] = UserContent.count(:all,  :joins => "as u, galleries as g,sub_chapters as s, tags as t" , :conditions => "u.gallery_id = g.id and s.id = g.subchapter_id and  t.id = s.tagid and
      #                                                                                                                                           g.e_gallery_type = 'image' and t.status ='active' and t.import_type = '#{arr[i]}' and t.uid= #{id} ")
      i += 1
    end
    return details
  end

  def cancel_excel_report
    sort="cancellation_request_date desc"
    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
    else
      @uname=params[:username]
      if(@uname!="" && params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%' "
      end

      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end

      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%' "
      end

      @country=params[:v_country]
      @zip=params[:zip]

      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end

    end
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="cancelledlist.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end
    pno = params[:page]
    slimit = (pno.to_i * 100) - 100
    @hmm_users = HmmUser.find(:all,:select => "hmm_users.*,hmm_studios.studio_name",  :conditions =>"cancel_status='approved'  #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}", :order => sort,:joins=>"LEFT JOIN hmm_studios ON hmm_studios.id = hmm_users.studio_id",:limit => "#{slimit.to_i}, 100")
    render :layout =>false
  end
  def contest_shares
    if params[:contest_phase]
      if params[:contest_phase]!='All'
        @phase=params[:contest_phase]
        logger.info("sdasd")
        @facebook=ContestShare.count(:all,:conditions =>"share_type='facebook' and a.contest_id=b.id and b.contest_phase='#{@phase}'",:joins=>"as a,contests as b")
        @email=ContestShare.count(:all,:conditions =>"share_type='email' and a.contest_id=b.id and b.contest_phase='#{@phase}'",:joins=>"as a,contests as b")
        @myspace=ContestShare.count(:all,:conditions =>"share_type='myspace' and a.contest_id=b.id and b.contest_phase='#{@phase}'",:joins=>"as a,contests as b")
      else
        @facebook=ContestShare.count(:all,:conditions =>"share_type='facebook'")
        @email=ContestShare.count(:all,:conditions =>"share_type='email'")
        @myspace=ContestShare.count(:all,:conditions =>"share_type='myspace'")
      end
    else
      @facebook=ContestShare.count(:all,:conditions =>"share_type='facebook'")
      @email=ContestShare.count(:all,:conditions =>"share_type='email'")
      @myspace=ContestShare.count(:all,:conditions =>"share_type='myspace'")
    end
    @contests= ContestDetail.find(:all)
  end

  def contest_share_info
    if params[:phase]!=''
      @contest_info = ContestShare.paginate(:all,:select => "contest_shares.*,contests.	first_name,contests.moment_type",:per_page => 25, :page => params[:page],:conditions =>"share_type='#{params[:type]}' and contest_phase='#{params[:phase]}'",:group =>'contest_id',:joins =>"LEFT JOIN contests ON contests.id = contest_shares.contest_id" )
    else
      @contest_info = ContestShare.paginate(:all,:select => "contest_shares.*,contests.	first_name,contests.moment_type",:per_page => 25, :page => params[:page],:conditions =>"share_type='#{params[:type]}'",:group =>'contest_id',:joins =>"LEFT JOIN contests ON contests.id = contest_shares.contest_id" )
    end
  end

  def number_counts(id,type)
    @contest_count = ContestShare.count(:all,:conditions =>"contest_id=#{id} and share_type='#{type}'")
  end

  def form
    @versions=VersionDetail.find(:all)
  end
  def update_values
    VersionDetail.update(params[:id], :major=>"#{params[:major]}",:minor=>"#{params[:minor]}")
    redirect_to '/account/form'
  end


  def upload_import_counts
    @upload_import_users = UploadImportCount.paginate :all,:page => params[:page] , :per_page => 10, :select => 'DISTINCT hmm_user_id'
  end

  def studio_name(studio_id)
    if studio_id == 0
      return "Dirrect Customer"
    else
      return  HmmStudio.find(studio_id).studio_name
    end
  end


  def upload_date
    @hmm_users = HmmUser.find(:all,:select => "v_fname,v_lname",:conditions => "id= #{params[:id]}")
    @upload_date = UploadImportCount.paginate(:all,:page => params[:page] , :per_page => 10, :select => "clicked_date", :conditions => "hmm_user_id = #{params[:id]}  and clicked_on='upload'" )
  end

  def import_date
    @hmm_users = HmmUser.find(:all,:select => "v_fname,v_lname",:conditions => "id= #{params[:id]}")
    @import_date = UploadImportCount.paginate(:all,:page => params[:page] , :per_page => 10, :select => "clicked_date", :conditions => "hmm_user_id= #{params[:id]}   and clicked_on='import'" )
  end


  def count_upload_import(id)
    count = Hash.new

    count['upload'] = UploadImportCount.count(:all, :conditions => "hmm_user_id=#{id}  and clicked_on='upload'")
    count['import'] = UploadImportCount.count(:all, :conditions => "hmm_user_id=#{id}  and clicked_on='import'")

    return count
  end

  def count_upload_import_report
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="upload_import_report.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end
    @upload_import_users = UploadImportCount.find(:all,:select => 'DISTINCT hmm_user_id')
    render :layout => false
  end

  def sales_person_login
    uri = URI.parse(request.url)

    logger.info(request.url)
    logger.info(uri.scheme)
    logger.info(request.protocol)
    #   if request.protocol == "http://"
    #      redirect_to :protocol => "https"
    #    end
    #    if uri.scheme=="http"
    #      redirect_to "https://#{request.subdomains}.holdmymemories.com/account/sales_person_login"
    #    end
  end


  def studio_session_subchapters

    if params[:type]=="gallery"
      @galleries=Galleries.find(:all,:conditions=>"subchapter_id=#{params[:id]} and status='active'",:order=>"id desc")
    elsif params[:type]=="images"
      @user_images=UserContent.find(:all,:conditions=>"gallery_id=#{params[:id]} and status='active'",:order=>"id desc")
    else
      @sub_images=SubChapter.find(:all,:conditions=>"uid=#{params[:id]} and status='active' and store_id!=''",:order=>"id desc")

    end
  end

  def edit_gallery_page
    @galleries=Galleries.find(:first,:conditions=>"id=#{params[:id]}")
    render :layout =>false
  end

  def edit_gallery_name
    galleries=Galleries.find(:first,:conditions=>"id=#{params[:id]}")
    if  params[:gallery_name]!=''
      galleries.v_gallery_name = params[:gallery_name]
      galleries.save
    end
    redirect_to "/account/studio_session_subchapters/#{galleries.subchapter_id}?type=gallery"
  end

  def delete_sub_session
    sub_images=SubChapter.find(:first,:conditions=>"id=#{params[:id]}")
    sub_images.status="inactive"
    sub_images.save
    redirect_to "/account/studio_session_subchapters/#{sub_images.uid}"
  end
  def delete_gallery_session
    galleries=Galleries.find(:first,:conditions=>"id=#{params[:id]}")
    galleries.status="inactive"
    galleries.save
    redirect_to "/account/studio_session_subchapters/#{galleries.	subchapter_id}?type=gallery"
  end
  def delete_image_session
    user_images=UserContent.find(:first,:conditions=>"id=#{params[:id]}")
    user_images.status="inactive"
    user_images.save
    redirect_to "/account/studio_session_subchapters/#{user_images.gallery_id}?type=images"
  end

  def edit_family_name
    if params[:Update]=="Update" && params[:family_name]!=""
      params[:family_name]=removefamilySymbols(params[:family_name])
      users = HmmUser.count(:all, :conditions => "family_name='#{removefamilySymbols(params[:family_name])}'")
      if users == 0
        family=HmmUser.find(:first,:conditions=>"id=#{params[:id]}")
        family.family_name=removefamilySymbols(params[:family_name])
        if family.save
          flash[:notice]="Family Name is Updated"
        else
          flash[:notice]=""
        end
      end
    end
    @user=HmmUser.find(:first,:conditions=>"id=#{params[:id]}")
  end




  def check_family_name
    color = 'red'
    cpnnum = params[:family_name]
    if cpnnum!=''
      params[:family_name]=removefamilySymbols(params[:family_name])
      emp_count = HmmUser.count(:all, :conditions => "family_name='#{params[:family_name]}'")
      if emp_count > 0
        message = 'Family Name Already Exists'
        @valid_username = false
      else
        message = 'Family Name is Available'
        color = 'green'
        @valid_username=true
      end
    else
      message = 'Please enter Family Name'
    end
    @message = "<b style='color:#{color}'>#{message}</b>"
    render :partial=>'familyname' , :layout => false
  end

  def download_user_content
    render :layout=>false
  end

  def search_giftcertificate
    if session[:store_id]
      certificates=GiftCertificate.find(:first,:select=>"a.*",:joins=>"as a,gift_certificate_studios as b",:conditions=>"a.id=b.gift_certificates_id and a.certificate_id='#{params[:certificate]}' and b.studio_id=#{session[:store_id]}")
    else
      certificates=GiftCertificate.find(:first,:conditions=>"certificate_id='#{params[:certificate]}'")

    end
    if certificates
      flash[:unid_succes] = 'Gift Certificate Authenticated!! Please create account for the customer.'
      redirect_to :action => 'preview_certificate', :id => certificates.id
    else
      flash[:unid_failed1] = 'Gift Certificate is not valid'
      redirect_to :action => 'verify_cuponID'
    end
  end

  def preview_certificate
    @certificates=GiftCertificate.find(:first,:select=>"a.*,b.months,b.charge",:joins=>"as a,membership_terms as b",:conditions=>"a.membership_term_id=b.id and a.id=#{params[:id]} and b.status='active'")
  end

  def payment_dates
    @payments=PaymentCount.find(:all,:conditions=>"uid=#{params[:id]}",:order=>"id desc")
  end

  def add_manual_payment
    sort_init 'id'
    sort_update
    @studios = HmmStudio.find(:all)
    if(params[:username]!=nil && params[:lastname]!=nil && params[:firstname]!=nil && params[:v_country]!=nil &&  params[:zip]!=nil && params[:account_type]!=nil && params[:status]!=nil && params[:studio_id]!=nil)

      @search_users = "true"
      @uname=params[:username]
      if(@uname!="" && params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%'"
      end

      @email=params[:email]
      if(@email!="" && params[:email]!=nil)
        emailcondition="and v_e_mail like '#{@email}%'"
      end

      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}'"
      end

      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%'"
      end

      @country=params[:v_country]
      @zip=params[:zip]

      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%'"
        end
      end
      t = Time.now
      dat = t.strftime("%Y-%m-%d")
      if params[:status] == 'active'
        statuscondition = "and account_expdate > '#{dat.to_date}'"
      elsif params[:status] == 'inactive'
        statuscondition = "and account_expdate < '#{dat.to_date}'"
      end

      @studio_id = params[:studio_id]
      if(@studio_id != "" && params[:studio_id] != nil)
        studiocondition = "and studio_id = #{@studio_id}"
        @studio_selected = params[:studio_id]
      end
      if params[:sort_key]==nil && params[:sort_order]==nil
        @srk="id  desc"
      else
        @sort_key=params[:sort_key]
        @order=params[:sort_order]
        @srk="#{@sort_key}"+" "+"#{@order}"
      end
      puts @sort_key
      puts @order
      dat=Date.today
      @hmm_users = HmmUser.paginate  :per_page => 10, :page => params[:page], :conditions =>"account_expdate>#{dat} and account_type!='free_user' and id!=''  #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition} #{statuscondition} #{studiocondition}", :order =>  @srk

    end

  end

  def get_payment_date
    @hmm_user=HmmUser.find(params[:id])
  end

  def upgrade_user_payment
    hmmuser=HmmUser.find(params[:id])
    acctype = hmmuser.account_type
    if acctype!="free_user"
      hmmuser.account_type="platinum_user"
      @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL 1 MONTH) as m")
      account_expdate= @hmm_user_max[0]['m']
      hmmuser.account_expdate = account_expdate
      count=Integer(hmmuser['payments_recieved'])
      hmmuser.payments_recieved= count + 1
      hmmuser.substatus = ''
      hmmuser.cancel_status = ''
      hmmuser.canceled_by = ''

      hmmuser.save
      if(hmmuser.emp_id=='' || hmmuser.emp_id==nil )
      else
        studio_commission=StudioCommission.new
        studio_commission.uid=hmmuser.id
        studio_commission.emp_id=hmmuser.emp_id
        empstore=EmployeAccount.find(hmmuser.emp_id)
        empstoreid=empstore.store_id
        studio_commission.store_id=empstoreid
        studio_commission.amount=5
        studio_commission.months=hmmuser.months
        studio_commission.payment_recieved_on=Time.now
        studio_commission.subscriptionumber=hmmuser.subscriptionnumber
        studio_commission.save
      end
      mon=Time.now.strftime("%m")
      payment_count = PaymentCount.new
      payment_count.uid = hmmuser.id
      payment_count.amount = hmmuser.amount
      payment_count.recieved_on = Time.now
      payment_count.account_type = hmmuser.account_type
      if hmmuser.account_type=="platinum_user"
        payment_count.current_received_amount = 9.95
      elsif hmmuser.account_type=="familyws_user"
        payment_count.current_received_amount = 4.95
      end
      payment_count.updated = 1
      payment_count.emp_id = "#{hmmuser.emp_id}"
      payment_count.month = "#{mon}"
      payment_count.save
      flash[:succ]="Thank You!! User information has been added "
    else
      flash[:succ]="The User is free user "
    end
    redirect_to "/account/get_payment_date/#{hmmuser.id}"
  end

  def export_zipcode

    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="Zipcode.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end
    @zips = ZipcodeSearch.find(:all, :order =>"created_at  DESC")
    render :layout=>false

  end


  def support_login

  end


  def support_logout
    reset_session
    flash[:notice] = "You Have Successfully Logged Out."
    redirect_to :action => 'support_login'
  end

  def support_home

  end

  def support_authenticate
    session[:expires_at] = session_time
    logged_in_employe = SupportAdmin.find_by_username_and_password(params[:user][:support_username],
      params[:user][:support_password], :conditions => "status='active'")
    #puts logged_in_employe.id
    if logged_in_employe
      session[:support_admin_name]=logged_in_employe.name
      session[:support_admin]=logged_in_employe.id
      session[:support_group_id]=logged_in_employe.studio_group_id
      #puts session[:employe]
      redirect_to  :action => 'support_home', :id => logged_in_employe.id
    else
      flash[:error] = "I'm sorry; either your username or password was incorrect."
      redirect_to :action => 'support_login'
    end
  end

  def list
    sort_init 'updated_at'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "updated_at desc"
      else

        sort = "updated_at desc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end
    if session[:support_admin]
      studios=HmmStudio.find(:all,:conditions=>"studio_groupid=#{session[:support_group_id]}")
      stud_arr=[]
      for studio in studios
        stud_arr.push(studio.id)
      end
      stud_arr=stud_arr.join(",")
      cond5="and studio_id in (#{stud_arr})"
    else
      cond5=""
    end
    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' #{cond5}")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' #{cond5}")

    @hmm_users = HmmUser.paginate :select => "*", :per_page => 10, :page => params[:page], :conditions=>"1=1 #{cond5}",:order => sort

    render :layout => true
  end

  def authenticate_common_admin_support
    unless  session[:user] ||  session[:support_admin]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "/account/login"
      return false
    end
  end

  def list1
    sort_init 'updated_at'
    sort_update

    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked'")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked'")


    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )

    else
      @uname=params[:username]
      if(@uname!="" && params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%'"
      end

      @email=params[:email]
      if(@email!="" && params[:email]!=nil)
        emailcondition="and v_e_mail like '#{@email}%' "
      end

      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}'"
      end

      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%'"
      end

      @country=params[:v_country]
      @zip=params[:zip]

      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%'"
        end
      end

    end
    if( params[:sort_key] ==nil )
      session[:sort_order]="desc"
      session[:srk]="updated_at"
      @srk = "#{session[:srk]}  #{params[:sort_order]}"
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      @srk = "#{session[:srk]}  #{params[:sort_order]}"

    end

    if session[:support_admin]
      studios=HmmStudio.find(:all,:conditions=>"studio_groupid=#{session[:support_group_id]}")
      stud_arr=[]
      for studio in studios
        stud_arr.push(studio.id)
      end
      stud_arr=stud_arr.join(",")
      cond5="and studio_id in (#{stud_arr})"
    else
      cond5=""
    end

    if(params[:username]== nil && params[:lastname]== nil && params[:firstname]== nil && params[:v_country]== nil &&  params[:zip]== nil && params[:account_type]== nil && params[:email]== nil)
      #session[:search_cond]="#{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}"
    else
      session[:search_cond]="#{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}"
    end
    @hmm_users = HmmUser.paginate :per_page => 10, :page => params[:page] , :conditions =>"id!='' #{session[:search_cond]} #{cond5}", :order =>  @srk

    render :layout => true
  end

  def move_gallery
    render :layout=>false
  end

  def move_gallery_user
    gallery=Galleries.find(params[:id])
    sub=gallery.subchapter_id
    subchapter=SubChapter.find(:first,:conditions=>"id=#{gallery.subchapter_id} and status='active'")
    user=HmmUser.find_by_v_user_name(params[:user_name])
    if !user.nil? && !user.blank?
      subchapter_exists=SubChapter.find(:first,:conditions=>"uid=#{user.id} and store_id=#{subchapter.store_id} and status='active'",:order=>"id asc")
      if !subchapter_exists.nil? && !subchapter_exists.blank?
        gallery.subchapter_id=subchapter_exists.id
        gallery.save
        flash[:move_error]="User Gallery has been moved to #{user.v_fname} #{user.v_lname}"
      else
        flash[:move_error]="User Does Not have the subchapter of the studio"
      end
    else
      flash[:move_error]="User Does Not Exist"
    end
    redirect_to "/account/studio_session_subchapters/#{sub}?type=gallery"
  end

    def send_subscription_email
    @get_content_url=ContentPath.find(:first, :conditions => "status='active'")
    first_name=params[:first_name]
    last_name=params[:last_name]
    email=params[:email]
    user_name=params[:v_user_name]
    account_type=params[:account_type]
    months=params[:months]
    account_expdate=params[:account_expdate]
    amount=params[:amount]
    street_address=params[:street_address]
    city=params[:city]
    state=params[:state]
    postcode=params[:postcode]
    country=params[:country]
    telephone=params[:telephone]
    invoicenumber=params[:invoicenumber]
    subscriptionnumber=params[:subscriptionnumber]
    v_password=params[:v_password]
    family_link=params[:family_name]
    pass_req=params[:pass_req]
    pass=params[:pass]
    nextsub=params[:nextsub]

    if subscriptionnumber=="One time payment"
      Postoffice.deliver_paymentsucessupdate("#{first_name} #{last_name}",email,user_name,account_type,account_expdate,months,amount,street_address, city, state ,postcode, country,telephone,invoicenumber,"One time payment",user_name, v_password,family_link,pass_req,pass,nextsub)
    else
      Postoffice.deliver_paymentsucess("#{first_name} #{last_name}",email,user_name,account_type,account_expdate,months,amount,street_address, city, state ,postcode, country,telephone,invoicenumber,subscriptionnumber, user_name,v_password,family_link,pass_req,pass,nextsub)
    end
     redirect_to "#{@get_content_url.proxyname}/account/edit/#{params[:user_id]}"
  end

  protected
  def ssl_required?
    true
  end


end