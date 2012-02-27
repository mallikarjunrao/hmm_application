class EmployeAccountsController < ApplicationController
  layout "admin"
  helper :sort
  include SortHelper
  require 'will_paginate'

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
    :redirect_to => { :action => :list }

  before_filter :authenticate_emp, :only => [ :edit, :list1]

  before_filter :authenticate_admin, :only => [ :new]
  before_filter :authenticate_admin_support, :only => [ :list, :edit_admin]
   before_filter :authenticate_employee_support, :only => [ :upgrade_account, :upgrade_account_search]

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

  def authenticate_admin_support
    unless session[:user] || session[:support_admin]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "https://www.holdmymemories.com/account/login"
      return false
    end
  end

  def authenticate_employee_support
    unless session[:employe] || session[:support_admin]
      flash[:notice] = 'Please Login to Access your Account'
       redirect_to "https://www.holdmymemories.com/account/employe_login"
      return false
    end
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

    if params[:employe_id] && params[:employe_id] != ''
      cond = "and employe_id LIKE '%#{params[:employe_id]}%'"
    elsif cond
      cond = ''
    end
    if params[:employe_name] && params[:employe_name] != ''
      cond1 = "and employe_name LIKE '%#{params[:employe_name]}%'"
    else
      cond1 = ''
    end
    if params[:emp_type] && params[:emp_type] != ''
      params[:emp_type] == 'employee' ? @emp="selected" : @storemgr="selected"
      cond2 = "and emp_type LIKE '%#{params[:emp_type]}%'"
    else
      cond2 = ''
    end
    if params[:e_mail] && params[:e_mail] != ''
      cond3 = "and e_mail LIKE '%#{params[:e_mail]}%'"
    else
      cond3 = ''
    end
    if params[:status] && params[:status] != ''
      params[:status] == 'block' ? @blocked="selected" : @unblocked="selected"
      cond4 = "and status = '#{params[:status]}'"
    else
      cond4 = ''
    end

    if session[:support_admin]
      studios=HmmStudio.find(:all,:conditions=>"studio_groupid=#{session[:support_group_id]}")
      stud_arr=[]
      for studio in studios
        stud_arr.push(studio.id)
      end
      stud_arr=stud_arr.join(",")
      cond5="and store_id in (#{stud_arr})"
    else
      cond5=""
    end

    @employe_accounts = EmployeAccount.paginate(:conditions => "employe_id != '' #{cond} #{cond1} #{cond2} #{cond3} #{cond4} #{cond5}", :order => sort, :per_page => 10, :page => params[:page])
  end

  def list_owner
    sort_init 'employe_id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "employe_id desc"
      else
        sort = "employe_id asc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end

    if params[:employe_id] && params[:employe_id] != ''
      cond = "and a.employe_id LIKE '%#{params[:employe_id]}%'"
    elsif cond
      cond = ''
    end
    if params[:employe_name] && params[:employe_name] != ''
      cond1 = "and a.employe_name LIKE '%#{params[:employe_name]}%'"
    else
      cond1 = ''
    end
    if params[:emp_type] && params[:emp_type] != ''
      params[:emp_type] == 'employee' ? @emp="selected" : @storemgr="selected"
      cond2 = "and a.emp_type = '#{params[:emp_type]}'"
    else
      cond2 = ''
    end
    if params[:e_mail] && params[:e_mail] != ''
      cond3 = "and a.e_mail LIKE '%#{params[:e_mail]}%'"
    else
      cond3 = ''
    end
    if params[:status] && params[:status] != ''
      params[:status] == 'block' ? @blocked="selected" : @unblocked="selected"
      cond4 = "and a.status = '#{params[:status]}'"
    else
      cond4 = ''
    end
    @employe_accounts = EmployeAccount.paginate(:select => "a.*",:joins => "as a, hmm_studios as b, hmm_studiogroups as c",  :conditions =>"b.studio_groupid=c.id and b.id=a.store_id and c.id=#{session[:franchise]} #{cond} #{cond1} #{cond2} #{cond3} #{cond4}", :order => sort, :per_page => 10, :page => params[:page])
  end

  def list_print
    sort_init 'id'
    sort_update
    if( params[:sort_key] == nil )
      if(session[:sort_order] == nil)
        sort = "id desc"
      else

        sort = "#{session[:srk]}  #{params[:sort_order]}"
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
      cond5="and store_id in (#{stud_arr})"
    else
      cond5=""
    end
    @employe_accounts = EmployeAccount.find(:all,:conditions=>"1=1  #{cond5}", :order => sort)
    render :layout => false
  end

  def list1
    @employe_accounts = EmployeAccount.paginate :per_page => 10, :page => params[:page], :conditions => "status = 'unblock'"
  end

  def show
    @employe_account = EmployeAccount.find(params[:id])
  end

  def new
    @employe_account = EmployeAccount.new
  end

  def new_by_owner
    @employe_account = EmployeAccount.new
  end

  def create
    @check_store_id = EmployeAccount.count(:all, :conditions => "store_id = '#{params[:employe_account][:store_id]}' and emp_type='store_manager' and status='unblock'")
    @check_storeid = EmployeAccount.find(:all, :conditions => "store_id = '#{params[:employe_account][:store_id]}' and emp_type='store_manager' and status='unblock'")

    if @check_store_id > 0
      @employe_account1 = EmployeAccount.find(@check_storeid[0]['id'])
      @employe_account1['end_date']=Time.now
      @employe_account1['status']='block'
      @employe_account1.save
    end
    @employe_account = EmployeAccount.new(params[:employe_account])
    @employe_account['employe_join_date']=Time.now
    @employe_account['employee_updated_date']=Time.now
    if @employe_account.save
      $emp_create
      $emp_add
      flash[:emp_create] = 'Your Account has been successfully created!! Please login to access your account'
      flash[:emp_add] = 'Employee Account has been successfully created!!'


      if session[:franchise]
        redirect_to :controller => 'employe_accounts', :action => 'list_owner'
      elsif logged_in_user
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
  def edit_owner
    @employe_account = EmployeAccount.find(params[:id])
  end


  def update
    @employe_account = EmployeAccount.find(params[:id])
    #    @employe_account['branch']=''
    @employe_account['employee_updated_date']=Time.now
    if @employe_account.update_attributes(params[:employe_account])
      $update_profile
      flash[:update_profile] = 'your Profile was successfully updated.'
      if session[:employe]
        redirect_to :controller => 'account', :action => 'emp_home'
      elsif session[:franchise]
        redirect_to :controller => 'employe_accounts', :action => 'list_owner'
      elsif session[:support_admin]
        redirect_to :controller => 'employe_accounts', :action => 'list'
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
      if session[:franchise]
        redirect_to :controller => 'employe_accounts', :action => 'list_owner'
      elsif session[:support_admin]
        redirect_to :controller => 'employe_accounts', :action => 'list'
      else
        redirect_to :action => 'list'
      end
    end
  end


  def unblock
    @emp = EmployeAccount.find(params[:id])
    if @emp.update_attribute(:status, 'unblock')
      if session[:franchise]
        redirect_to :controller => 'employe_accounts', :action => 'list_owner'
      else
        redirect_to :action => 'list'
      end
    end
  end

  def commissionReport
    @employe_account = EmployeAccount.find(session[:employe])

    @employee_commission = EmployeAccount.find(:all, :conditions => "emp_type='store_manager' and store_id='#{@employe_account.store_id}'")
  end

  def upgrade_account
    sort_init 'id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="id  desc"
    end
    @hmmuser_premcnt= HmmUser.count(:all)
    @hmm_users = HmmUser.paginate  :per_page => 10, :page => params[:page], :order => sort

    render :layout => true
  end

  def upgrade_account_search
    sort_init 'id'
    sort_update

    #       @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "account_type='platinum_user' ")
    #      @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "account_type='platinum_user' and emp_id != '' ")
    #      @hmmuser_cnt = (@hmmuser_blockcnt - @hmmuser_unblockcnt)

    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
    else
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

    end

    if params[:sort_key]==nil && params[:sort_order]==nil
      session[:sort_order]="desc"
      session[:srk]="id"
      @srk = "#{session[:srk]}  #{params[:sort_order]}"
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      @srk = "#{session[:srk]}  #{params[:sort_order]}"
      #      @sort_key=params[:sort_key]
      #      @order=params[:sort_order]
    end
    puts @sort_key
    puts @order
    #     @srk="#{@sort_key}"+" "+"#{@order}"
    #
    #    if( @srk==nil || @srk=="" )
    #      @srk="id  desc"
    #    end

    puts @srk
    if(params[:username]== nil && params[:lastname]== nil && params[:firstname]== nil && params[:v_country]== nil &&  params[:zip]== nil && params[:account_type]== nil && params[:email]== nil)
      @hmm_users = HmmUser.paginate  :per_page => 10, :page => params[:page], :conditions =>"id!='' and (account_type='free_user' or (cancel_status='approved')) and  e_user_status='unblocked' ", :order =>  @srk
    else
      @hmm_users = HmmUser.paginate  :per_page => 10, :page => params[:page], :conditions =>"id!='' and (account_type='free_user' or ( cancel_status='approved')) and  e_user_status='unblocked' #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}", :order =>  @srk
    end
    render :layout => true
  end


  def upgrade_worker
    @hmm_user = HmmUser.find(params[:id])
    #     @hmm_user['account_type']="platinum_user"
    #     @hmm_user['months']=1
    @hmm_user['substatus']="active"
    #     @hmm_user['payments_recieved']="1"
    #adding 1 month cupon no
    @hmm_user['cupon_no']="64719993266120_2"
    #adding 1 month to expire date
    @exp_date_cal =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL 1 MONTH) as m")
    account_expdate= @exp_date_cal[0]['m']
    @hmm_user['account_expdate'] = account_expdate
    getthrough = @hmm_user['v_password']
    if @hmm_user.save
      if(params[:req_wpf]=='true') #if the request is from wpf just render the message
        render :text =>"Account upgraded successfully!"
      else
        flash[:unid_succes] = 'User Account has been Upgraded! Please Upload session images'
        redirect_to :controller => 'employe_accounts', :action => 'authenticate_upgrade_login', :id => 1, :v_user_name => @hmm_user.v_user_name, :pa => getthrough
      end
    else
      if(params[:req_wpf]=='true') #if the request is from wpf just render the message
        render :text =>"Upgrade account failed!"
      else
        flash[:unid_failed] = 'Upgrade failed! Please try after some time'
        redirect_to :action => 'upgrade_account'
      end
    end
  end

  def authenticate_upgrade_login
    self.logged_in_hmm_user = HmmUser.authenticate(params[:v_user_name],params[:pa])
    if is_userlogged_in?
      if logged_in_hmm_user.e_user_status == 'unblocked'
        logger.info("[User]: #{params[:v_user_name]} [Logged In] at #{Time.now} !")
        @client_ip = request.remote_ip
        @user_session = UserSessions.new()
        @user_session['i_ip_add'] = @client_ip
        @user_session['uid'] = logged_in_hmm_user.id
        @user_session['v_user_name'] = logged_in_hmm_user.v_user_name
        @user_session['d_date_time'] = Time.now
        @user_session['e_logged_in'] = "yes"
        @user_session['e_logged_out'] = "no"
        @user_session.save

        session[:alert] = "fnfalert"
        flag = 0
        cur_time=Time.now.strftime("%Y-%m-%d")
        @hmm_user_check =  HmmUser.count(:all, :conditions =>" account_expdate <= '#{cur_time}' and id='#{logged_in_hmm_user.id}'")
        if @hmm_user_check > 0
          @hmm_user_max =  HmmUser.find_by_sql(" select account_expdate as m from hmm_users where id='#{logged_in_hmm_user.id}'")
          nextbilingdate = @hmm_user_max[0]['m']
        else
          nextbilingdate = "#{logged_in_hmm_user.account_expdate}"
        end

        if(nextbilingdate == nil || nextbilingdate == "")
          flag = 1
          flash[:error] = "Your Subscription has been expired. Please provide the new credit card details for renewal of your account."
          nextbilingdate2 = "Subscription Expired/cancelled"
          renewal_days = "Subscription already expired"
        else
          nextbilingdate1=nextbilingdate.split('-');
          nextbilingdate2="#{nextbilingdate1[1]} - #{nextbilingdate1[2]} - #{nextbilingdate1[0]}"
          @hmm_leftdays=HmmUser.find_by_sql("  SELECT DATEDIFF('#{nextbilingdate1}',CURDATE( ) ) as d  ")
          renewal_days = Integer(@hmm_leftdays[0]['d'])
          if(renewal_days <= 0)
            flag = 1
            flash[:error] = "Your Subscription has been expired. Please provide the new credit card details for renewal of your account."
          end
        end
        if logged_in_hmm_user.substatus=="suspended"
          flag = 1
          flash[:error] = "Your credit card payment to your HoldMyMemories.com has been declined by your credit card company. This could be for a number of reasons, including an expired card. <br><br><br>Please re-enter your credit card information, or use a different card for the renewal of your account."
        end

        if(session[:redirect_url]!=nil && session[:redirect_url]!='')
          url = session[:redirect_url]
          session[:redirect_url]=nil
          redirect_to url
        else
          if(params[:friend_id]==nil && params[:shareid]==nil )
            if(logged_in_hmm_user.v_e_mail=="Please update email")
              redirect_to "/customers/update_email"
            else
              if(logged_in_hmm_user.cancel_status=="approved" && flag==1)
                redirect_to "/customers/upgrade/platinum_account&msg=payment_req"
              else
                if(logged_in_hmm_user.family_name=='' || logged_in_hmm_user.family_name==nil)
                  @uuid =  HmmUser.find_by_sql(" select UUID() as u")
                  unnid = @uuid[0]['u']
                  hmmuser_family = HmmUser.find(logged_in_hmm_user.id)
                  hmmuser_family.family_name="#{logged_in_hmm_user.id}#{unnid}un#{logged_in_hmm_user.id}"
                  hmmuser_family.save
                  redirect_to :controller=>'manage_website',:action=>'file_manager',:id=>logged_in_hmm_user.family_name
                else
                  if(logged_in_hmm_user.msg=='0')
                    redirect_to :controller=>'manage_website',:action=>'file_manager',:id=>logged_in_hmm_user.family_name
                  else
                    redirect_to "/#{logged_in_hmm_user.family_name}"
                  end
                end
              end
            end
          end
        end

      else
        reset_session
        flash[:error1] = "User is been blocked.. Contact Admin!!"
        redirect_to "/user_account/login"
      end

    else
      flash[:error] = "I'm sorry; either your username or password was incorrect."
      logger.error("[Invalid Login]: by [User]:#{params[:v_user_name]} at #{Time.now}")
      redirect_to :action => 'login'
      return "false"
    end
  end

end