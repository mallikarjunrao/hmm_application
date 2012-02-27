class HmmReportingController < ApplicationController
  
  layout "admin"
  helper :sort
  include SortHelper
  require 'will_paginate'
  before_filter :authenticate_admin, :only => [ ]
  
  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "https://www.holdmymemories.com/account/login"
    return false
    end
  end
  
  def member_details_premium
    if(params[:id]=='company')
    #@customers = HmmUser.paginate :select =>"a.*,b.*,c.*", :joins => "as a, employe_accounts as b, payment_counts as c", :conditions => "b.store_id='#{params[:id]}' and b.id=c.emp_id and a.id=c.uid and  a.emp_id=b.id and a.account_type='platinum_user'  and c.recieved_on between '#{session[:dat]}-01' and '#{session[:dat]}-31'", :per_page => 50, :order => sort, :page => params[:page]
      @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, a.amount as amount, a.account_expdate as account_expdate, c.studio_name as studio_name", :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"c.studio_groupid = '#{params[:ids]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'platinum_user'", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='studio')
       @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.amount as amount, a.d_created_date as created_date, a.account_expdate as account_expdate", :joins=>"as a, employe_accounts as d ",:conditions =>"d.store_id = '#{params[:ids]}' AND d.id = a.emp_id AND a.account_type = 'platinum_user'", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='managers')
        @hmm_users_premium = HmmUser.paginate(:all, :conditions =>"emp_id = '#{params[:ids]}' AND account_type = 'platinum_user'", :per_page => 50, :page => params[:page])
    end
  end
  
  def premium_excel_report
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="statisticalreport_premium_users.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end 
    #items_per_page = HmmUser.count(:all , :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"c.studio_groupid = '#{params[:ids]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'platinum_user'")
    if(params[:page]=='' || params[:page]==nil)
      params[:page]=1
    end
    if(params[:id]=='company')
    #@customers = HmmUser.paginate :select =>"a.*,b.*,c.*", :joins => "as a, employe_accounts as b, payment_counts as c", :conditions => "b.store_id='#{params[:id]}' and b.id=c.emp_id and a.id=c.uid and  a.emp_id=b.id and a.account_type='platinum_user'  and c.recieved_on between '#{session[:dat]}-01' and '#{session[:dat]}-31'", :per_page => 50, :order => sort, :page => params[:page]
      @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, a.amount as amount, a.account_expdate as account_expdate, c.studio_name as studio_name", :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"c.studio_groupid = '#{params[:ids]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'platinum_user'", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='studio')
       @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.amount as amount, a.d_created_date as created_date, a.account_expdate as account_expdate", :joins=>"as a, employe_accounts as d ",:conditions =>"d.store_id = '#{params[:ids]}' AND d.id = a.emp_id AND a.account_type = 'platinum_user'", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='managers')
        @hmm_users_premium = HmmUser.paginate(:all, :conditions =>"emp_id = '#{params[:ids]}' AND account_type = 'platinum_user'", :per_page => 50, :page => params[:page])
    end
    render :layout => false
  end
  
  def member_details_premium_active
    
    if(params[:id]=='company')
      @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, a.amount as amount, a.account_expdate as account_expdate, c.studio_name as studio_name", :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"c.studio_groupid = '#{params[:ids]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'platinum_user' and DATE_FORMAT(a.account_expdate,'%Y-%m-%d') >= curdate()", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='studio')
       @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.amount as amount, a.d_created_date as created_date, a.account_expdate as account_expdate", :joins=>"as a, employe_accounts as d ", :conditions =>"d.store_id = '#{params[:ids]}' AND d.id = a.emp_id AND a.account_type = 'platinum_user' and DATE_FORMAT(a.account_expdate,'%Y-%m-%d') >= curdate()", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='managers')
        @hmm_users_premium = HmmUser.paginate(:all, :conditions =>"emp_id = '#{params[:ids]}' AND account_type = 'platinum_user' and DATE_FORMAT(account_expdate,'%Y-%m-%d') >= curdate()", :per_page => 50, :page => params[:page])
    end
  end
  
  def premium_active_excel_report
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="premium_active_users_statisticalreport.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end 
    if(params[:page]=='' || params[:page]==nil)
      params[:page]=1
    end
    if(params[:id]=='company')
      @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, a.amount as amount, a.account_expdate as account_expdate, c.studio_name as studio_name", :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"c.studio_groupid = '#{params[:ids]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'platinum_user' and DATE_FORMAT(a.account_expdate,'%Y-%m-%d') >= curdate()", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='studio')
       @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.amount as amount, a.d_created_date as created_date, a.account_expdate as account_expdate", :joins=>"as a, employe_accounts as d ", :conditions =>"d.store_id = '#{params[:ids]}' AND d.id = a.emp_id AND a.account_type = 'platinum_user' and DATE_FORMAT(a.account_expdate,'%Y-%m-%d') >= curdate()", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='managers')
        @hmm_users_premium = HmmUser.paginate(:all, :conditions =>"emp_id = '#{params[:ids]}' AND account_type = 'platinum_user' and DATE_FORMAT(account_expdate,'%Y-%m-%d') >= curdate()", :per_page => 50, :page => params[:page])
    end
    render :layout => false
  end
  
  def member_details_premium_cancled
    if(params[:id]=='company')
      @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, c.studio_name as studio_name, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"c.studio_groupid = '#{params[:ids]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'platinum_user' and a.cancel_status='approved' and a.canceled_by!='-2'", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='studio')
       @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a, employe_accounts as d ", :conditions =>"d.store_id = '#{params[:ids]}' AND d.id = a.emp_id AND a.account_type = 'platinum_user' and a.cancel_status='approved' and a.canceled_by!='-2'", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='managers')
        @hmm_users_premium = HmmUser.paginate(:all, :conditions =>"emp_id = '#{params[:ids]}' AND account_type = 'platinum_user' and cancel_status='approved' and canceled_by!='-2'", :per_page => 50, :page => params[:page])
    end
  end
  
  def premium_cancled_excel_report
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="premium_cancled_users_statisticalreport.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end 
    if(params[:page]=='' || params[:page]==nil)
      params[:page]=1
    end
    if(params[:id]=='company')
      @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, c.studio_name as studio_name, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"c.studio_groupid = '#{params[:ids]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'platinum_user' and a.cancel_status='approved' and a.canceled_by!='-2'", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='studio')
       @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a, employe_accounts as d ", :conditions =>"d.store_id = '#{params[:ids]}' AND d.id = a.emp_id AND a.account_type = 'platinum_user' and a.cancel_status='approved' and a.canceled_by!='-2'", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='managers')
        @hmm_users_premium = HmmUser.paginate(:all, :conditions =>"emp_id = '#{params[:ids]}' AND account_type = 'platinum_user' and cancel_status='approved' and canceled_by!='-2'", :per_page => 50, :page => params[:page])
    end
    render :layout => false
  end
  
  def member_details_premium_declined
    if(params[:id]=='company')
      @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, c.studio_name as studio_name, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"c.studio_groupid = '#{params[:ids]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'platinum_user' and a.cancel_status='approved' and a.canceled_by='-2'", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='studio')
       @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a, employe_accounts as d ", :conditions =>"d.store_id = '#{params[:ids]}' AND d.id = a.emp_id AND a.account_type = 'platinum_user' and a.cancel_status='approved' and a.canceled_by='-2'", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='managers')
        @hmm_users_premium = HmmUser.paginate(:all, :conditions =>"emp_id = '#{params[:ids]}' AND account_type = 'platinum_user' and cancel_status='approved' and canceled_by='-2'", :per_page => 50, :page => params[:page])
    end
  end
  
  def premium_declined_excel_report
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="premium_declined_users_statisticalreport.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end 
    if(params[:page]=='' || params[:page]==nil)
      params[:page]=1
    end
    if(params[:id]=='company')
      @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, c.studio_name as studio_name, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"c.studio_groupid = '#{params[:ids]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'platinum_user' and a.cancel_status='approved' and a.canceled_by='-2'", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='studio')
       @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a, employe_accounts as d ", :conditions =>"d.store_id = '#{params[:ids]}' AND d.id = a.emp_id AND a.account_type = 'platinum_user' and a.cancel_status='approved' and a.canceled_by='-2'", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='managers')
        @hmm_users_premium = HmmUser.paginate(:all, :conditions =>"emp_id = '#{params[:ids]}' AND account_type = 'platinum_user' and cancel_status='approved' and canceled_by='-2'", :per_page => 50, :page => params[:page])
    end
    render :layout => false
  end
  
  
   def member_details_familywebsite
    if(params[:id]=='company')
      @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, c.studio_name as studio_name, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"c.studio_groupid = '#{params[:ids]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'familyws_user' ", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='studio')
       @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a, employe_accounts as d ", :conditions =>"d.store_id = '#{params[:ids]}' AND d.id = a.emp_id AND a.account_type = 'familyws_user' ", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='managers')
        @hmm_users_premium = HmmUser.paginate(:all, :conditions =>"emp_id = '#{params[:ids]}' AND account_type = 'familyws_user' ", :per_page => 50, :page => params[:page])
    end
  end
  
  def familywebsite_excel_report
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="familywebsite_users_statisticalreport.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end 
    if(params[:page]=='' || params[:page]==nil)
      params[:page]=1
    end
    if(params[:id]=='company')
      @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, c.studio_name as studio_name, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"c.studio_groupid = '#{params[:ids]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'familyws_user' ", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='studio')
       @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a, employe_accounts as d ", :conditions =>"d.store_id = '#{params[:ids]}' AND d.id = a.emp_id AND a.account_type = 'familyws_user' ", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='managers')
        @hmm_users_premium = HmmUser.paginate(:all, :conditions =>"emp_id = '#{params[:ids]}' AND account_type = 'familyws_user' ", :per_page => 50, :page => params[:page])
    end
    render :layout => false
  end
  
  def member_details_familywebsite_password
    if(params[:id]=='company')
      @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, c.studio_name as studio_name, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"c.studio_groupid = '#{params[:ids]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'familyws_user' and a.password_required = 'yes'", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='studio')
       @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a, employe_accounts as d ", :conditions =>"d.store_id = '#{params[:ids]}' AND d.id = a.emp_id AND a.account_type = 'familyws_user' and a.password_required = 'yes'", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='managers')
        @hmm_users_premium = HmmUser.paginate(:all, :conditions =>"emp_id = '#{params[:ids]}' AND account_type = 'familyws_user' and password_required = 'yes'", :per_page => 50, :page => params[:page])
    end
  end
  
  def familywebsite_excel_report_password
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="familywebsite_users_statisticalreport.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end 
    if(params[:page]=='' || params[:page]==nil)
      params[:page]=1
    end
    if(params[:id]=='company')
      @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, c.studio_name as studio_name, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"c.studio_groupid = '#{params[:ids]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'familyws_user' and a.password_required = 'yes'", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='studio')
       @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a, employe_accounts as d ", :conditions =>"d.store_id = '#{params[:ids]}' AND d.id = a.emp_id AND a.account_type = 'familyws_user' and a.password_required = 'yes'", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='managers')
        @hmm_users_premium = HmmUser.paginate(:all, :conditions =>"emp_id = '#{params[:ids]}' AND account_type = 'familyws_user' and password_required = 'yes'", :per_page => 50, :page => params[:page])
    end
    render :layout => false
  end
  
  def member_details_familywebsite_cancel
    if(params[:id]=='company')
      @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, c.studio_name as studio_name, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"c.studio_groupid = '#{params[:ids]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'familyws_user' and a.cancel_status='approved' ", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='studio')
       @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a, employe_accounts as d ", :conditions =>"d.store_id = '#{params[:ids]}' AND d.id = a.emp_id AND a.account_type = 'familyws_user' and a.cancel_status='approved'", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='managers')
        @hmm_users_premium = HmmUser.paginate(:all, :conditions =>"emp_id = '#{params[:ids]}' AND account_type = 'familyws_user' and cancel_status='approved'", :per_page => 50, :page => params[:page])
    end
  end
  
  def familywebsite_cancel_excel_report
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="familywebsite_cancel_users_statisticalreport.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end 
    if(params[:page]=='' || params[:page]==nil)
      params[:page]=1
    end
    if(params[:id]=='company')
      @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, c.studio_name as studio_name, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"c.studio_groupid = '#{params[:ids]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'familyws_user' and a.cancel_status='approved' ", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='studio')
       @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a, employe_accounts as d ", :conditions =>"d.store_id = '#{params[:ids]}' AND d.id = a.emp_id AND a.account_type = 'familyws_user' and a.cancel_status='approved'", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='managers')
        @hmm_users_premium = HmmUser.paginate(:all, :conditions =>"emp_id = '#{params[:ids]}' AND account_type = 'familyws_user' and cancel_status='approved'", :per_page => 50, :page => params[:page])
    end
    render :layout => false
  end
  
  def member_details_familywebsite_declined
    if(params[:id]=='company')
      @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, c.studio_name as studio_name, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"c.studio_groupid = '#{params[:ids]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'familyws_user' and a.cancel_status='approved' and a.canceled_by ='-2' ", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='studio')
       @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a, employe_accounts as d ", :conditions =>"d.store_id = '#{params[:ids]}' AND d.id = a.emp_id AND a.account_type = 'familyws_user' and a.cancel_status='approved' and a.canceled_by ='-2'", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='managers')
        @hmm_users_premium = HmmUser.paginate(:all, :conditions =>"emp_id = '#{params[:ids]}' AND account_type = 'familyws_user' and cancel_status='approved' and canceled_by ='-2'", :per_page => 50, :page => params[:page])
    end
  end
  
  def familywebsite_declined_excel_report
     begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="familywebsite_declined_users_statisticalreport.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end 
    if(params[:page]=='' || params[:page]==nil)
      params[:page]=1
    end
    if(params[:id]=='company')
      @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, c.studio_name as studio_name, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"c.studio_groupid = '#{params[:ids]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'familyws_user' and a.cancel_status='approved' and a.canceled_by ='-2' ", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='studio')
       @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a, employe_accounts as d ", :conditions =>"d.store_id = '#{params[:ids]}' AND d.id = a.emp_id AND a.account_type = 'familyws_user' and a.cancel_status='approved' and a.canceled_by ='-2'", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='managers')
        @hmm_users_premium = HmmUser.paginate(:all, :conditions =>"emp_id = '#{params[:ids]}' AND account_type = 'familyws_user' and cancel_status='approved' and canceled_by ='-2'", :per_page => 50, :page => params[:page])
    end
    render :layout => false
  end
  
  def member_details_free
    if(params[:id]=='company')
      @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, c.studio_name as studio_name, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"c.studio_groupid = '#{params[:ids]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'free_user' ", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='studio')
       @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a, employe_accounts as d ", :conditions =>"d.store_id = '#{params[:ids]}' AND d.id = a.emp_id AND a.account_type = 'free_user' ", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='managers')
        @hmm_users_premium = HmmUser.paginate(:all, :conditions =>"emp_id = '#{params[:ids]}' AND account_type = 'free_user' ", :per_page => 50, :page => params[:page])
    end
  end
  def free_users_excel_report
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="free_users_statisticalreport.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end 
    if(params[:page]=='' || params[:page]==nil)
      params[:page]=1
    end
    if(params[:id]=='company')
      @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, c.studio_name as studio_name, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a ,hmm_studios as c, employe_accounts as d ", :conditions =>"c.studio_groupid = '#{params[:ids]}' AND d.store_id = c.id AND d.id = a.emp_id AND a.account_type = 'free_user' ", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='studio')
       @hmm_users_premium = HmmUser.paginate :select => "a.id as userid, a.v_fname as fname, a.v_user_name as username, a.v_e_mail as email, a.e_user_status as status, a.months as months, a.d_created_date as created_date, a.amount as amount, a.account_expdate as account_expdate", :joins=>"as a, employe_accounts as d ", :conditions =>"d.store_id = '#{params[:ids]}' AND d.id = a.emp_id AND a.account_type = 'free_user' ", :per_page => 50, :page => params[:page]
    end
    if(params[:id]=='managers')
        @hmm_users_premium = HmmUser.paginate(:all, :conditions =>"emp_id = '#{params[:ids]}' AND account_type = 'free_user' ", :per_page => 50, :page => params[:page])
    end
    render :layout => false
  end
  
end
