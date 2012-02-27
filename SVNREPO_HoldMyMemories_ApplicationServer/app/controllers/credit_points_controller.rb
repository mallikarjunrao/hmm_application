class CreditPointsController < ApplicationController
  layout "admin"
  helper :sort
  include SortHelper
  require 'will_paginate'

  before_filter :authenticate_admin, :only => [ :credit_list,:credit_edit]
  before_filter :authenticate_admin_emp, :only => [ :used_credits,:used_excel_credits]
  before_filter :authenticate_admin_support, :only => [ :view_credit,:credit_report,:edit_credit]

  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "https://www.holdmymemories.com/account/login"
      return false
    end
  end

  def authenticate_admin_emp
    unless session[:user] || session[:employe]
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

   
  def credit_report
    sort_init 'id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "a.id desc"
      else
        sort = "a.id desc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end

    if(params[:firstname]!=nil && params[:firstname]!='')
      session[:fnamecond]=" and b.v_fname='#{params[:firstname]}'"
    else
      session[:fnamecond]=''
    end

    if(params[:lastname]!=nil && params[:lastname]!='')
      session[:lnamecond]=" and b.v_lname='#{params[:lastname]}'"
    else
      session[:lnamecond]=''
    end

    if(params[:email]!=nil && params[:email]!='')
      session[:emailcond]=" and b.v_e_mail='#{params[:email]}'"
    else
      session[:emailcond]=''
    end

    if(params[:username]!=nil && params[:username]!='')
      session[:ucond]=" and b.v_user_name='#{params[:username]}'"
    else
      session[:ucond]=''
    end

    if(params[:account_type]!=nil && params[:account_type]!='')
      session[:acond]=" and b.account_type='#{params[:account_type]}'"
    else
      session[:acond]=""
    end

    if(params[:account_type]==nil && params[:username]==nil && params[:email]==nil && params[:firstname]==nil && params[:lastname]==nil)
      #session[:search_cond]=""
    else
      session[:search_cond]="#{session[:fnamecond]} #{session[:lnamecond]} #{session[:emailcond]} #{session[:ucond]} #{session[:acond]}"
    end
    if params[:cpg]=="all"
      session[:search_cond]=""
    end
    @search_condition=session[:search_cond]
    if session[:support_admin]
      cond5="and c.id=#{session[:support_group_id]}"
    else
      cond5=""
    end
    @hmm_users = CreditPoint.paginate :select => "a.*,a.id as creditid,b.v_fname,b.v_lname,b.e_sex,b.v_user_name,b.account_type,b.emp_id,b.v_e_mail,b.telephone,b.cancel_status,b.account_expdate,c.credit_system,b.studio_id " , :joins =>"as a , hmm_users as b, hmm_studiogroups as c ", :per_page => 30, :page => params[:page], :conditions => "a.user_id=b.id and b.account_type!='free_user' #{cond5} #{session[:search_cond]}  and c.id=a.hmm_studiogroup_id", :order => sort

  end


  def studio_credit_report
    sort_init 'id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "a.id desc"
      else
        sort = "a.id desc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end

    if(params[:firstname]!=nil && params[:firstname]!='')
      session[:fnamecond]=" and b.v_fname='#{params[:firstname]}'"
    else
      session[:fnamecond]=''
    end

    if(params[:lastname]!=nil && params[:lastname]!='')
      session[:lnamecond]=" and b.v_lname='#{params[:lastname]}'"
    else
      session[:lnamecond]=''
    end

    if(params[:email]!=nil && params[:email]!='')
      session[:emailcond]=" and b.v_e_mail='#{params[:email]}'"
    else
      session[:emailcond]=''
    end

    if(params[:username]!=nil && params[:username]!='')
      session[:ucond]=" and b.v_user_name='#{params[:username]}'"
    else
      session[:ucond]=''
    end

    if(params[:account_type]!=nil && params[:account_type]!='')
      session[:acond]=" and b.account_type='#{params[:account_type]}'"
    else
      session[:acond]=""
    end

    if(params[:account_type]==nil && params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:email]==nil)
      #params[:search_cond]=""
    else
      session[:search_cond]="#{session[:fnamecond]} #{session[:lnamecond]} #{session[:emailcond]} #{session[:ucond]} #{session[:acond]}"
    end

    if params[:studio_id]==nil
      @select=session[:store_id]
    else
      @select=params[:studio_id]
    end
    if params[:cpg]=="all"
      session[:search_cond]=""
    end
    @search_condition=params[:search_cond]
    @hmm_studio_group=HmmStudio.find(session[:store_id])
    @hmm_studio_list=HmmStudio.find(:all,:conditions=>" studio_groupid=#{@hmm_studio_group.studio_groupid}",:order=>"studio_name")
    #@hmm_users = CreditPoint.paginate :select => "a.*,a.id as creditid,b.v_fname,b.v_lname,b.e_sex,b.v_user_name,b.account_type,b.emp_id,b.v_e_mail,c.credit_system,d.studio_name,d.studio_branch" , :joins =>"as a , hmm_users as b , employe_accounts as c , hmm_studios as d", :per_page => 30, :page => params[:page], :conditions => "a.user_id=b.id and b.account_type!='free_user' and b.emp_id=c.id and c.store_id=d.id and a.hmm_studiogroup_id=#{@hmm_studio_group.studio_groupid} #{searchcond}", :order => sort
    @hmm_users = CreditPoint.paginate :select => "a.*,a.id as creditid,b.v_fname,b.v_lname,b.e_sex,b.v_user_name,b.account_type,b.emp_id,b.v_e_mail,b.telephone,b.cancel_status,b.account_expdate,c.credit_system " , :joins =>"as a , hmm_users as b, hmm_studiogroups as c ", :per_page => 30, :page => params[:page], :conditions => "a.user_id=b.id and b.account_type!='free_user' and  b.studio_id=#{session[:store_id]} #{session[:search_cond]} and c.id=a.hmm_studiogroup_id", :order => sort
  end


  def studio_excel_report

    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="creditreport.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end

    sort_init 'id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "a.id desc"
      else
        sort = "a.id desc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end

    #    if(params[:firstname]!=nil && params[:firstname]!='')
    #      session[:fnamecond]=" and b.v_fname='#{params[:firstname]}'"
    #    else
    #      session[:fnamecond]=''
    #    end
    #
    #    if(params[:lastname]!=nil && params[:lastname]!='')
    #      session[:lnamecond]=" and b.v_lname='#{params[:lastname]}'"
    #    else
    #      session[:lnamecond]=''
    #    end
    #
    #    if(params[:email]!=nil && params[:email]!='')
    #     session[:emailcond]=" and b.v_e_mail='#{params[:email]}'"
    #    else
    #      session[:emailcond]=''
    #    end
    #
    #    if(params[:username]!=nil && params[:username]!='')
    #      session[:ucond]=" and b.v_user_name='#{params[:username]}'"
    #    else
    #      session[:ucond]=''
    #    end
    #
    #    if(params[:account_type]!=nil && params[:account_type]!='')
    #      session[:acond]=" and b.account_type='#{params[:account_type]}'"
    #    else
    #      session[:acond]=""
    #    end

    if(params[:account_type]==nil && params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:email]==nil)
      #params[:search_cond]=""
    else
      session[:search_cond]="#{session[:fnamecond]} #{session[:lnamecond]} #{session[:emailcond]} #{session[:ucond]} #{session[:acond]}"
    end

    if params[:studio_id]==nil
      @select=session[:store_id]
    else
      @select=params[:studio_id]
    end
    if params[:cpg]=="all"
      session[:search_cond]=""
    else
      session[:search_cond]="#{session[:fnamecond]} #{session[:lnamecond]} #{session[:emailcond]} #{session[:ucond]} #{session[:acond]}"
    end
    @hmm_studio_group=HmmStudio.find(session[:store_id])
    @hmm_studio_list=HmmStudio.find(:all,:conditions=>" studio_groupid=#{@hmm_studio_group.studio_groupid}",:order=>"studio_name")
    #@hmm_users = CreditPoint.find(:all,:select => "a.*,a.id as creditid,b.v_fname,b.v_lname,b.e_sex,b.v_user_name,b.account_type,b.emp_id,b.v_e_mail,d.studio_name,d.studio_branch" , :joins =>"as a , hmm_users as b , employe_accounts as c , hmm_studios as d", :conditions => "a.user_id=b.id and b.account_type!='free_user' and b.emp_id=c.id and c.store_id=d.id and a.hmm_studiogroup_id=#{@hmm_studio_group.studio_groupid} #{searchcond}", :order => sort)
    #@hmm_users = CreditPoint.paginate :select => "a.*,a.id as creditid,b.v_fname,b.v_lname,b.e_sex,b.v_user_name,b.account_type,b.emp_id,b.v_e_mail,c.credit_system " , :joins =>"as a , hmm_users as b, hmm_studiogroups as c ", :per_page => 30, :page => params[:page], :conditions => "a.user_id=b.id and b.account_type!='free_user' and a.hmm_studiogroup_id=#{@hmm_studio_group.studio_groupid} #{params[:search_cond]} and c.id=a.hmm_studiogroup_id", :order => sort
    @hmm_users = CreditPoint.find(:all, :select => "a.*,a.id as creditid,b.v_fname,b.v_lname,b.e_sex,b.v_user_name,b.account_type,b.emp_id,b.v_e_mail,b.telephone,b.cancel_status,b.account_expdate,c.credit_system " , :joins =>"as a , hmm_users as b, hmm_studiogroups as c ", :conditions => "a.user_id=b.id and b.account_type!='free_user' and  b.studio_id=#{session[:store_id]} #{session[:search_cond]} and c.id=a.hmm_studiogroup_id", :order => sort)
    render :layout => false
  end


  def edit_credit
    @credit = CreditPoint.find(params[:id])
  end

  def add_edit_notes
    @credit = CreditPoint.find(params[:id])
    unless params[:notes].blank?
      @credit['notes']=params[:notes]
      @credit.save
      flash[:notice] = 'Notes have been updated'
      if params[:report]=="used"
        redirect_to "/credit_points/used_credits?page=#{params[:page]}&&#{session[:custom_params]}"
      else
        if params[:type]=="studio"
          redirect_to :action => 'studio_credit_report', :search_cond=> params[:search_cond],:page=> params[:page]
        else
          redirect_to :action => 'credit_report', :search_cond=> params[:search_cond],:page=> params[:page]
        end
      end
    end
  end

  def studio_edit_credit
    @credit = CreditPoint.find(params[:id])
  end

  def credit_list
    if(params[:id])
      gid=params[:id]
    else
      gid=1
    end
    @hmm_studios = HmmStudio.paginate :per_page => 50, :page => params[:page],:conditions=>"studio_groupid=#{gid}"
    @studio_groups=HmmStudiogroup.find(:all)
  end

  def excel_report
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="creditreport.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end

    sort_init 'id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "a.id desc"
      else
        sort = "a.id desc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end

    if(params[:firstname]!=nil && params[:firstname]!='')
      session[:fnamecond]=" and b.v_fname='#{params[:firstname]}'"
    else
      session[:fnamecond]=''
    end

    if(params[:lastname]!=nil && params[:lastname]!='')
      session[:lnamecond]=" and b.v_lname='#{params[:lastname]}'"
    else
      session[:lnamecond]=''
    end

    if(params[:email]!=nil && params[:email]!='')
      session[:emailcond]=" and b.v_e_mail='#{params[:email]}'"
    else
      session[:emailcond]=''
    end

    if(params[:username]!=nil && params[:username]!='')
      session[:ucond]=" and b.v_user_name='#{params[:username]}'"
    else
      session[:ucond]=''
    end

    if(params[:account_type]!=nil && params[:account_type]!='')
      session[:acond]=" and b.account_type='#{params[:account_type]}'"
    else
      session[:acond]=""
    end

    if(params[:account_type]==nil && params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:email]==nil)
      #session[:search_cond]=""
    else
      session[:search_cond]="#{session[:fnamecond]} #{session[:lnamecond]} #{session[:emailcond]} #{session[:ucond]} #{session[:acond]}"
    end
    if params[:cpg]=="all"
      session[:search_cond]=""
    end
     if session[:support_admin]
      cond5="and c.id=#{session[:support_group_id]}"
    else
      cond5=""
    end
    #@hmm_users = CreditPoint.paginate :select => "a.*,a.id as creditid,b.v_fname,b.v_lname,b.e_sex,b.v_user_name,b.account_type,b.emp_id,b.v_e_mail,c.credit_system " , :joins =>"as a , hmm_users as b, hmm_studiogroups as c ", :per_page => 30, :page => params[:page], :conditions => "a.user_id=b.id and b.account_type!='free_user' #{params[:search_cond]} and c.id=a.hmm_studiogroup_id", :order => sort
    @hmm_users = CreditPoint.find(:all, :select => "a.*,a.id as creditid,b.v_fname,b.v_lname,b.e_sex,b.v_user_name,b.account_type,b.emp_id,b.v_e_mail,b.telephone,b.cancel_status,b.account_expdate,c.credit_system " , :joins =>"as a , hmm_users as b, hmm_studiogroups as c ", :conditions => "a.user_id=b.id and b.account_type!='free_user' #{cond5} #{session[:search_cond]} and c.id=a.hmm_studiogroup_id", :order => sort)
    render :layout => false
  end

  def credit_edit

    @hmm_studio = HmmStudio.find(params[:id])
    @sid = params[:id]
    if @hmm_studio.credit_percentage==0
      @hmm_studio_cp=""
    else
      @hmm_studio_cp=@hmm_studio.credit_percentage
    end
    if @hmm_studio.credit_option == "yes"
      @status_yes="selected"
    else
      @status_no="selected"
      @hide="style='display:none;'"
    end

  end

  def credit_update
    @hmm_studio = HmmStudio.find(params[:id])
    if params[:hmm_studio][:credit_option]== "no"
      params[:hmm_studio][:credit_percentage]=""
    end
    if @hmm_studio.update_attributes(params[:hmm_studio])
      flash[:notice] = 'HmmStudio was successfully updated.'
      redirect_to :action => 'credit_list', :id => @hmm_studio.studio_groupid
    else
      render :action => 'edit'
    end
  end

  def credit_updateall

    if params[:credit_option]=="no"
      params[:credit_percentage]=""
    end
    if params[:credit_percentage]==""
      params[:credit_percentage]="0"
    end

    if(params[:id])
      gid=params[:id]
    else
      gid=1
    end

    @studios=HmmStudio.find(:all,:conditions=>"studio_groupid=#{gid}")
    for k in @studios
      @std=HmmStudio.find(k.id)
      @std['credit_option']=params[:credit_option]
      @std['credit_percentage']=params[:credit_percentage]
      @std.save
    end
    flash[:notice] = 'Studio Credits was successfully updated Equally.'
    redirect_to :action => 'credit_list', :id =>  gid

  end
  def credit_updateall

    if params[:credit_option]=="no"
      params[:credit_percentage]=""
    end
    if params[:credit_percentage]==""
      params[:credit_percentage]="0"
    end

    if(params[:id])
      gid=params[:id]
    else
      gid=1
    end

    @studios=HmmStudio.find(:all,:conditions=>"studio_groupid=#{gid}")
    for k in @studios
      @std=HmmStudio.find(k.id)
      @std['credit_option']=params[:credit_option]
      @std['credit_percentage']=params[:credit_percentage]
      @std.save
    end
    flash[:notice] = 'Studio Credits was successfully updated Equally.'
    redirect_to :action => 'credit_list', :id =>  gid

  end

  def update_creditsystem

    if(params[:id])
      gid=params[:id]
    else
      gid=1
    end

    @studios=HmmStudiogroup.find(gid)
    @studios.credit_system = params[:credit_system]
    @studios.save
    flash[:notice] = 'Studio Credits was successfully updated Equally.'
    redirect_to :action => 'credit_list', :id =>  gid, :page =>  params[:page]

  end



  def update_credit
    @credit = CreditPoint.find(params[:id])

    if(Float(params[:deduct])>Float(@credit.available_credits))
      flash[:notice] = 'Credit amount exceeded the available credits'
      render :action => 'edit_credit',:id=>params[:id]
    else
      @cvalue=Float(@credit.available_credits)-Float(params[:deduct])
      @uvalue=Float(@credit.used_credits)+Float(params[:deduct])
      @credit['available_credits']=@cvalue
      @credit['used_credits']=@uvalue
      @credit.save

      @creditlog=CreditLog.new
      if session[:store_id]
        @creditlog['hmm_studio_id']=session[:store_id]
      else
        @creditlog['hmm_studio_id']=0
      end
      @creditlog['credit_point_id']=@credit.id
      @creditlog['used_credit']=Float(params[:deduct])
      @creditlog.save
      flash[:notice] = 'Available Credits updated'
      if params[:report]=="used"
        redirect_to "/credit_points/used_credits?page=#{params[:page]}&&#{session[:custom_params]}"
      else
        if params[:type]=="studio"
          redirect_to :action => 'studio_credit_report', :search_cond=> params[:search_cond], :page=> params[:page]
        else
          redirect_to :action => 'credit_report', :search_cond=> params[:search_cond], :page=> params[:page]
        end
      end
    end

  end

  def studio_update_credit
    @credit = CreditPoint.find(params[:id])

    if(Float(params[:deduct])>Float(@credit.available_credits))
      flash[:notice] = 'Credit amount exceeded the available credits'
      render :action => 'studio_edit_credit',:id=>params[:id]
    else
      @cvalue=Float(@credit.available_credits)-Float(params[:deduct])
      @uvalue=Float(@credit.used_credits)+Float(params[:deduct])
      @credit['available_credits']=@cvalue
      @credit['used_credits']=@uvalue
      @credit.save

      @creditlog=CreditLog.new
      @creditlog['credit_point_id']=@credit.id
      @creditlog['hmm_studio_id']=session[:store_id]
      @creditlog['used_credit']=Float(params[:deduct])
      @creditlog.save
      flash[:notice] = 'Available Credits updated'
      redirect_to'/credit_points/studio_credit_report'
    end

  end

  def existing_customers

    # Fetching the user id from the payment count table
    # Family website users starts
    #    @paymentcnt=PaymentCount.find(:all,:conditions=>"account_type='familyws_user' and emp_id!='' and recieved_on < CURDATE() and credit_status = 'active'",:group=>"uid")
    #    for paymentcnt in @paymentcnt
    #      # paymentcnt.uid=360
    #      credits = 0
    #
    #      # Total Count for particular user under family website user
    #
    #      @pay_amount=PaymentCount.find(:all,:conditions=>" uid=#{paymentcnt.uid} and account_type='familyws_user' and emp_id!='' and recieved_on < CURDATE()",:group=>"amount")
    #      for pay_amount in @pay_amount
    #
    #        @pc_count=PaymentCount.count(:all,:conditions=>" uid=#{paymentcnt.uid} and account_type='familyws_user' and emp_id!=''and amount='#{pay_amount.amount}' and recieved_on < CURDATE()")
    #
    #        if @pc_count > 0
    #          if pay_amount.amount=="$4.95"
    #            credits = credits + (@pc_count * 4.95)
    #          elsif pay_amount.amount=="$24.95"
    #            if @pc_count < 6
    #              # if is it < 6. Need to update the "credit_month" field to track the no of month eg(1,2,3,4,5,6)
    #              credits = credits + (@pc_count * (24.95/6))
    #              @paymentcnt_details=PaymentCount.find(:all,:conditions=>" uid=#{paymentcnt.uid} and account_type='familyws_user' and emp_id!='' and recieved_on < CURDATE()",:order=>" recieved_on ")
    #              i=1
    #              for paymentcnt_detials in @paymentcnt_details
    #                PaymentCount.update(paymentcnt_detials.id,:credit_month=>"#{i}")
    #                i=i+1
    #              end
    #            else
    #              credits= credits + (@pc_count * (24.95/6))
    #            end
    #          elsif pay_amount.amount=="$49.95"
    #            if @pc_count < 12
    #              credits = credits + (@pc_count * (49.95/12))
    #              @paymentcnt_details=PaymentCount.find(:all,:conditions=>" uid=#{paymentcnt.uid} and account_type='familyws_user' and  emp_id!='' and recieved_on < CURDATE()",:order=>" recieved_on ")
    #              i=1
    #              for paymentcnt_detials in @paymentcnt_details
    #                PaymentCount.update(paymentcnt_detials.id,:credit_month=>"#{i}")
    #                i=i+1
    #              end
    #            else
    #              credits = credits + (@pc_count * (49.95/12))
    #            end
    #          end
    #        end
    #      end
    #
    #      @studio_groups=HmmUser.find(:first,:select => "a.*, c.studio_groupid as studiogroupid", :joins =>"as a ,employe_accounts as b,hmm_studios as c ",:conditions => "a.id=#{paymentcnt.uid} and b.id=a.emp_id and b.store_id=c.id ")
    #      # Storing the studio id in the credit point table
    #      # The credit points is alloted only for s121 studio for existing customers
    #      if @studio_groups.studiogroupid == "1"
    #        @addcredits=CreditPoint.new
    #        @addcredits['user_id']=paymentcnt.uid
    #        @addcredits['hmm_studiogroup_id']=@studio_groups.studiogroupid
    #        @addcredits['available_credits']=credits
    #        @addcredits.save
    #      end
    #
    #    end

    # Family website users ends

    #platinum users starts

    @paymentcnt=PaymentCount.find(:all,:conditions=>"account_type='platinum_user' and emp_id!='' and recieved_on < CURDATE() and credit_status = 'active'",:group=>"uid",:limit=>"11500,500")
    for paymentcnt in @paymentcnt
      credits = 0

      @pay_amount2=PaymentCount.find(:all,:conditions=>" uid=#{paymentcnt.uid} and account_type='platinum_user' and emp_id!='' and recieved_on < CURDATE()",:group=>"amount")
      for pay_amount2 in @pay_amount2
        @pc_count2=PaymentCount.count(:all,:conditions=>" uid=#{paymentcnt.uid} and account_type='platinum_user' and emp_id!='' and amount='#{pay_amount2.amount}' and recieved_on < CURDATE()")
        if @pc_count2 > 0
          if pay_amount2.amount=="$9.95"
            credits = credits+(@pc_count2 * 9.95)
          elsif pay_amount2.amount=="$49.95"
            if @pc_count2 < 6
              credits = credits+(@pc_count2 * (49.95/6))
              @paymentcnt_details=PaymentCount.find(:all,:conditions=>" uid=#{paymentcnt.uid} and account_type='platinum_user' and emp_id!='' and recieved_on < CURDATE()",:order=>" recieved_on ")
              i=1
              for paymentcnt_detials in @paymentcnt_details
                PaymentCount.update(paymentcnt_detials.id,:credit_month=>"#{i}")
                i=i+1
              end
            else
              credits = credits+(@pc_count2 * (49.95/6))
            end
          elsif pay_amount2.amount=="$99.95"
            if @pc_count2 < 12
              credits = credits+(@pc_count2 * (99.95/12))
              @paymentcnt_details=PaymentCount.find(:all,:conditions=>" uid=#{paymentcnt.uid} and account_type='platinum_user' and emp_id!='' and recieved_on < CURDATE()",:order=>" recieved_on ")
              i=1
              for paymentcnt_detials in @paymentcnt_details
                PaymentCount.update(paymentcnt_detials.id,:credit_month=>"#{i}")
                i=i+1
              end
            else
              credits = credits+(@pc_count2 * (99.95/12))
            end
          end
        end
      end

      @studio_groups=HmmUser.find(:first,:select => "a.*, c.studio_groupid as studiogroupid", :joins =>"as a ,employe_accounts as b,hmm_studios as c ",:conditions => "a.id=#{paymentcnt.uid} and b.id=a.emp_id and b.store_id=c.id ")

      if @studio_groups.studiogroupid == "1"
        @credit_check=CreditPoint.count(:all,:conditions=>"user_id=#{paymentcnt.uid}")
        if @credit_check == 0
          @addcredits=CreditPoint.new
          @addcredits['user_id']=paymentcnt.uid
          @addcredits['hmm_studiogroup_id']=@studio_groups.studiogroupid
          @addcredits['available_credits']=credits
          @addcredits.save
        else
          @credit_value=CreditPoint.find(:first,:conditions=>"user_id=#{paymentcnt.uid} ")
          @credit_value.available_credits = @credit_value.available_credits + credits
          @credit_value.save
        end
      end

    end
    #platinum users ends

    # update the status to inactive to all the fields where credit point has been calculated
    #PaymentCount.update_all( "credit_status = 'inactive'", "recieved_on < CURDATE() and emp_id!=''" )

  end



  def current_customers
    #now = Time.now
    #@check_date = now.strftime("%Y-%m-%d")
    update_status = false
    @paymentcnt=PaymentCount.find(:all, :conditions=>"date_format(recieved_on,'%Y-%m-%d')=DATE_ADD(CURDATE(), INTERVAL -1 DAY) and emp_id!='' and credit_status = 'active'",:group=>"uid")
    #@paymentcnt=PaymentCount.find(:all, :conditions=>"date_format(recieved_on,'%Y-%m-%d')=CURDATE() and emp_id!='' and credit_status = 'active'",:group=>"uid")
    for paymentcnt in @paymentcnt
      #credit points should be added only if the available credit is < 119.4
      #@total_credits = PaymentCount.count(:all, :conditions => "uid ='#{paymentcnt.uid}' and  credit_status = 'inactive'")
      #unless @total_credits.to_i >= 12
      creditcheck = CreditPoint.count(:all, :conditions => "user_id ='#{paymentcnt.uid}'")
      if (creditcheck > 0)
        @total_credits = CreditPoint.find(:first, :conditions => "user_id ='#{paymentcnt.uid}'")
        totalcredit=@total_credits.available_credits
      else
        totalcredit = 0
      end
      unless (totalcredit).to_f >= 119.4
        @hmm_all=HmmUser.find(:first,:select => "a.*,b.*,c.*" ,:joins=>"as a,employe_accounts as b,hmm_studios as c",:conditions=>"a.emp_id=b.id and b.store_id=c.id and a.id=#{paymentcnt.uid}" )
        # The credit point is added only if the studio is offering credits
        if @hmm_all.credit_option=="yes" && @hmm_all.credit_percentage!=nil
          @new_credit_month=nil
          # The "credit_month" is updated for previous. eg: if the user had reached 4 month today. have to take 3 from the previous record so that we can upadate 4 as in the current record
          @credit_month=PaymentCount.find(:first,:conditions=>"uid=#{paymentcnt.uid} and credit_month!='' ",:order=>"recieved_on desc")
          @credit_count= CreditPoint.count(:all,:conditions=>"user_id=#{paymentcnt.uid}")

          if paymentcnt.account_type=="familyws_user"
            if paymentcnt.amount =="$4.95"
              credits = 4.95
            elsif paymentcnt.amount =="$24.95"
              if @credit_count==0
                credits = 24.95/6
                @new_credit_month=1
              elsif  @credit_month !=nil && Integer(@credit_month.credit_month) < 6
                credits = 24.95/6
                @new_credit_month=Integer(@credit_month.credit_month) + 1
              else
                credits = 24.95/6
              end
            elsif paymentcnt.amount =="$49.95"
              if @credit_count==0
                credits = 49.95/12
                @new_credit_month=1
              elsif @credit_month !=nil && Integer(@credit_month.credit_month) < 12
                credits = 49.95/12
                @new_credit_month=Integer(@credit_month.credit_month) + 1
              else
                credits = 49.95/12
              end
            end
          else
            if paymentcnt.amount =="$9.95"
              credits = 9.95
            elsif paymentcnt.amount =="$49.95"
              if @credit_count==0
                credits = 49.95/6
                @new_credit_month=1
              elsif @credit_month !=nil  && Integer(@credit_month.credit_month) < 6
                credits = 49.95/6
                @new_credit_month=Integer(@credit_month.credit_month) + 1
              else
                credits = 49.95/6
              end
            elsif paymentcnt.amount =="$99.95"
              if @credit_count==0
                credits = 99.95/12
                @new_credit_month=1
              elsif @credit_month !=nil && Integer(@credit_month.credit_month) < 12
                credits = 99.95/12
                @new_credit_month=Integer(@credit_month.credit_month) + 1
              else
                credits = 99.95/12
              end
            end
          end

          @credit_count= CreditPoint.count(:all,:conditions=>"user_id=#{paymentcnt.uid}")
          total_credits = ((@hmm_all.credit_percentage.to_f/100)*credits.to_f)
          unless(@credit_count == 0)
            @credit_points= CreditPoint.find(:first,:conditions=>"user_id=#{paymentcnt.uid}")
            total_credits = @credit_points.available_credits + total_credits
            if total_credits.to_f < 119.4
              @credit_points.available_credits = total_credits
              @credit_points.mail_status = 'false'
              @credit_points.save
              update_status = true
            else
              update_status = false
            end
          else
            # for new user we have to add new record in the credit point table
            @studio_groups=HmmUser.find(:first,:select => "a.*, c.studio_groupid as studiogroupid", :joins =>"as a ,employe_accounts as b,hmm_studios as c ",:conditions => "a.id=#{paymentcnt.uid} and b.id=a.emp_id and b.store_id=c.id ")
            @addcredits=CreditPoint.new
            @addcredits['user_id']=paymentcnt.uid
            @addcredits['hmm_studiogroup_id']=@studio_groups.studiogroupid
            @addcredits['available_credits']=total_credits
            @addcredits.save
            update_status = true
          end

        end
        if update_status == true
          PaymentCount.update(paymentcnt.id,:credit_month=>"#{@new_credit_month}",:credit_status=>'inactive')
        end
      end
    end
    render(:layout => false)
  end


  def view_credit
    #@credit_logs = CreditLog.paginate :per_page => 10, :page => params[:page],:conditions=>"credit_point_id=#{params[:id]}"
    if !params[:start_date].nil? && !params[:end_date].nil? && !params[:start_date].blank? && !params[:end_date].blank?
      from_date_ary = params[:start_date].split("/")
      start_date1= "#{from_date_ary[2]}-#{from_date_ary[0]}-#{from_date_ary[1]}"
      end_date_ary = params[:end_date].split("/")
      end_date1= "#{end_date_ary[2]}-#{end_date_ary[0]}-#{end_date_ary[1]}"
      cond="and a.created_at >'#{start_date1} 00:00:00' and a.created_at < '#{end_date1} 23:59:59'"
    else
      cond=""
    end
    @credit_logs = CreditLog.paginate :select => "a.*,b.studio_name",:joins =>"as a , hmm_studios as b ", :per_page => 10, :page => params[:page],:conditions=>" a.hmm_studio_id=b.id and a.credit_point_id=#{params[:id]} #{cond}"
    @credits=CreditPoint.find(params[:id])
  end

  def studio_view_credit

    @credit_logs = CreditLog.paginate :select => "a.*,b.studio_name",:joins =>"as a , hmm_studios as b ", :per_page => 10, :page => params[:page],:conditions=>" a.hmm_studio_id=b.id and a.credit_point_id=#{params[:id]}"
    @credits=CreditPoint.find(params[:id])
  end

  def used_credits

    sort_init 'id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "a.id desc"
      else
        sort = "a.id desc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end
    @search_condition = ""

    if(params[:start_date]!=nil && params[:start_date]!='' &&  params[:end_date]!=nil && params[:end_date]!='')
      @starts_date=params[:start_date]
      @ends_date=params[:end_date]
      from_date_ary = params[:start_date].split("/")
      @start_date1= "#{from_date_ary[2]}-#{from_date_ary[0]}-#{from_date_ary[1]}"
      end_date_ary = params[:end_date].split("/")
      @end_date1= "#{end_date_ary[2]}-#{end_date_ary[0]}-#{end_date_ary[1]}"
      @search_condition = @search_condition.concat(" and d.created_at > '#{@start_date1} 00:00:00' and d.created_at < '#{@end_date1} 23:59:59'")
    end

    if(params[:firstname]!=nil && params[:firstname]!='')
      @search_condition = @search_condition.concat(" and b.v_fname='#{params[:firstname]}'")
    end

    if(params[:lastname]!=nil && params[:lastname]!='')
      @search_condition = @search_condition.concat(" and b.v_lname='#{params[:lastname]}'")
    end

    if(params[:email]!=nil && params[:email]!='')
      @search_condition = @search_condition.concat("and b.v_e_mail='#{params[:email]}'")
    end

    if(params[:username]!=nil && params[:username]!='')
      @search_condition = @search_condition.concat("and b.v_user_name='#{params[:username]}'")
    end

    if(params[:account_type]!=nil && params[:account_type]!='')
      @search_condition = @search_condition.concat(" and b.account_type='#{params[:account_type]}'")
    end
    if  session[:store_id]
      @search_condition = @search_condition.concat(" and b.studio_id=#{session[:store_id]}")
    end

    @custom_params="firstname=#{params[:firstname]}&&lastname=#{params[:lastname]}&&email=#{params[:email]}&&username=#{params[:username]}&&account_type=#{params[:account_type]}&&start_date=#{params[:start_date]}&&end_date=#{params[:end_date]}"
    session[:custom_params]=@custom_params
    @hmm_users = CreditPoint.paginate :select => "a.*,a.id as creditid,b.v_fname,b.v_lname,b.e_sex,b.v_user_name,b.account_type,b.emp_id,b.v_e_mail,b.telephone,b.cancel_status,b.account_expdate,c.credit_system,b.studio_id" , :joins =>"as a , hmm_users as b, hmm_studiogroups as c, credit_logs as d", :per_page => 30, :page => params[:page], :conditions => "a.user_id=b.id and b.account_type!='free_user' #{@search_condition}  and c.id=a.hmm_studiogroup_id and a.id=d.credit_point_id",:group=>"b.id", :order => sort

  end

  def used_excel_credits
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="creditreport.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end
    sort_init 'id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "a.id desc"
      else
        sort = "a.id desc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end
    @search_condition = ""

    if(params[:start_date]!=nil && params[:start_date]!='' &&  params[:end_date]!=nil && params[:end_date]!='')
      @starts_date=params[:start_date]
      @ends_date=params[:end_date]
      from_date_ary = params[:start_date].split("/")
      @start_date1= "#{from_date_ary[2]}-#{from_date_ary[0]}-#{from_date_ary[1]}"
      end_date_ary = params[:end_date].split("/")
      @end_date1= "#{end_date_ary[2]}-#{end_date_ary[0]}-#{end_date_ary[1]}"
      @search_condition = @search_condition.concat(" and d.created_at > '#{@start_date1} 00:00:00' and d.created_at < '#{@end_date1} 23:59:59'")
    end

    if(params[:firstname]!=nil && params[:firstname]!='')
      @search_condition = @search_condition.concat(" and b.v_fname='#{params[:firstname]}'")
    end

    if(params[:lastname]!=nil && params[:lastname]!='')
      @search_condition = @search_condition.concat(" and b.v_lname='#{params[:lastname]}'")
    end

    if(params[:email]!=nil && params[:email]!='')
      @search_condition = @search_condition.concat("and b.v_e_mail='#{params[:email]}'")
    end

    if(params[:username]!=nil && params[:username]!='')
      @search_condition = @search_condition.concat("and b.v_user_name='#{params[:username]}'")
    end

    if(params[:account_type]!=nil && params[:account_type]!='')
      @search_condition = @search_condition.concat(" and b.account_type='#{params[:account_type]}'")
    end
    if  session[:store_id]
      @search_condition = @search_condition.concat(" and b.studio_id=#{session[:store_id]}")
    end

    @custom_params="firstname=#{params[:firstname]}&&lastname=#{params[:lastname]}&&email=#{params[:email]}&&username=#{params[:username]}&&account_type=#{params[:account_type]}&&start_date=#{params[:start_date]}&&end_date=#{params[:end_date]}"
    session[:custom_params]=@custom_params
    @hmm_users = CreditPoint.paginate :select => "a.*,a.id as creditid,b.v_fname,b.v_lname,b.e_sex,b.v_user_name,b.account_type,b.emp_id,b.v_e_mail,b.telephone,b.cancel_status,b.account_expdate,c.credit_system,b.studio_id" , :joins =>"as a , hmm_users as b, hmm_studiogroups as c, credit_logs as d", :per_page => 30, :page => params[:page], :conditions => "a.user_id=b.id and b.account_type!='free_user' #{@search_condition}  and c.id=a.hmm_studiogroup_id and a.id=d.credit_point_id",:group=>"b.id", :order => sort
    render :layout=>false
  end



end