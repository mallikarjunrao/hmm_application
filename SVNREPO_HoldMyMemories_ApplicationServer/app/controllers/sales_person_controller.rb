class SalesPersonController < ApplicationController
  layout "admin"
  helper :sort
  include SortHelper
  require 'will_paginate'

  ssl_required :all


  before_filter :authenticate_sales, :only => [:list,:dispatch_accountinfo,:delete_studiodet,:studiogroup_list,:studiogroup_list_excel,:studio_signup,:validate,:initial_studio_form,:edit_client_details,:initial_studio_create,:delete_studiodet,:studiogroup_list,:list_excel,:studiogroup_delete,:studiogroup_assign_form,:studiogroup_assign,:initial_studio_update]
  before_filter :authenticate_admin, :only => [:list_salesperson,:add_sales_person,:edit_sales_person,:delete_sales_person,:check_name]

  def authenticate_sales
    unless session[:sales_person]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "/account/sales_person_login"
      return false
    end
  end

  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "/account/login"
      return false
    end
  end

  def list
    sort_init 'studio_name'
    sort_update
    if( params[:sort_key] == nil )
      if(session[:sort_order]== nil)
        sort = "studio_name desc"
      else
        sort = "studio_name asc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end

    if params[:studio_name] && params[:studio_name]!=''
      cond ="and studio_name LIKE '%#{params[:studio_name]}%'"
    else
      cond =''
    end
    if params[:city] && params[:city]!=''
      cond1 ="and city LIKE '%#{params[:city]}%'"
    else
      cond1 =''
    end
    if params[:email] && params[:email]!=''
      cond2 ="and email LIKE '%#{params[:email]}%'"
    else
      cond2 =''
    end
    if params[:name] && params[:name]!=''
      cond3 ="and name LIKE '%#{params[:name]}%'"
    else
      cond3 =''
    end
    @studiodet = (StudioDetail.paginate :conditions => "id != '' #{cond} #{cond1} #{cond2} #{cond3}", :page=>params[:page], :per_page => 10, :order => sort)
  end

  def dispatch_accountinfo
    @info = StudioDetail.find(params[:id])
    @exp_date_cal =  PhotographerDetail.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL 30 DAY) as m")
    @cur_date_cal =  PhotographerDetail.find_by_sql(" select CURDATE() as c")
    account_curdate= @cur_date_cal[0]['c']
    account_expdate= @exp_date_cal[0]['m']
    @info['account_expire_date'] = account_expdate
    @info['date_sent'] = account_curdate
    @info['account_status'] = 'accepted'
    if @info.save
      Postoffice.deliver_studiogroup_accountinfo(@info.id,@info.name,@info.email,@info.username,@info.password,@info.account_expire_date)
      $notice_update
      flash[:notice_update] = 'Account info was succefully dispatched.'
      redirect_to :action => 'list'
    else
      $notice_update_fail
      flash[:notice_update_fail] = 'Account info dispatched failed'
      render :action => 'list'
    end
  end

  def delete_studiodet
    if(params[:id])
      StudioDetail.find(params[:id]).destroy
      flash[:notice] = 'Studio Details Deleted Successfully.'
      redirect_to :controller => "sales_person", :action => 'list'
    end
  end

  def studiogroup_list
    sort_init 'studio_name'
    sort_update
    if( params[:sort_key] == nil )
      if(session[:sort_order]== nil)
        sort = "studio_name desc"
      else
        sort = "studio_name asc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end
    
    if params[:hmm_franchise_studio] && params[:hmm_franchise_studio]!=''
      cond ="and a.hmm_franchise_studio LIKE '%#{params[:hmm_franchise_studio]}%'"
    else
      cond =''
    end
    if params[:city] && params[:city]!=''
      cond1 ="and b.city LIKE '%#{params[:city]}%'"
    else
      cond1 =''
    end
    if params[:contact_email] && params[:contact_email]!=''
      cond2 ="and a.contact_email LIKE '%#{params[:contact_email]}%'"
    else
      cond2 =''
    end
    if params[:contact_name] && params[:contact_name]!=''
      cond3 ="and b.contact_name LIKE '%#{params[:contact_name]}%'"
    else
      cond3 =''
    end
    @hmm_studiogroups = HmmStudiogroup.paginate :joins=>"as a , hmm_studios as b", :group=>"studio_groupid", :order=> sort, :conditions=>"a.id=b.studio_groupid and a.status='active' #{cond} #{cond1} #{cond2} #{cond3} ",:select=>"a.hmm_franchise_studio,a.contact_email,a.studiogroup_username,a.password,a.id,a.id as group_id,b.id,b.studio_address,b.city,b.zip_code,b.studio_phone,b.state_id,b.country,b.contact_name,b.contact_phone,b.studio_groupid, a.date_joined as date_joined, a.created_at as created_at", :per_page => 10, :page => params[:page]
  end

  def studiogroup_list_excel
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="HMMStudiogrouplist.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end
    @hmm_studiogroups_count=HmmStudiogroup.count(:all)
    @hmm_studiogroups = HmmStudiogroup.paginate :joins=>"as a , hmm_studios as b",:group=>"studio_groupid",:order=>"b.id asc",:conditions=>"a.id=b.studio_groupid and a.status='active'",:select=>"a.hmm_franchise_studio,a.contact_email,a.studiogroup_username,a.password,a.id,b.id,b.studio_address,b.city,b.zip_code,b.studio_phone,b.state_id,b.country,b.contact_name,b.contact_phone,b.studio_groupid, a.date_joined as date_joined, a.created_at as created_at", :per_page => @hmm_studiogroups_count, :page => params[:page]
    render :layout => false
  end


  def studio_signup

    @states_list=State.find(:all)


  end

  def validate
    color = 'red'
    username = params[:username]

    user = HmmStudiogroup.find_all_by_studiogroup_username(username)
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

  def initial_studio_form

  end

  def edit_client_details
    @pdetails = StudioDetail.find(params[:id])
  end

  def initial_studio_create

    @maxid =  Tag.find_by_sql("select max(id) as m from studio_details")
    for tag_max in @maxid
      max_id = "#{tag_max.m}"
    end
    if(max_id == '')
      max_id = '0'
    end
    next_id= Integer(max_id) + 1

    @uname=params[:name].delete(' ')


    @username="#{@uname}#{next_id}"
    @password=Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{next_id}--")[0,6]

    if params[:Submit]!=''
      @pdetails = StudioDetail.new()
      @pdetails['studio_name'] = params[:sname].gsub(/<\/?[^>]*>/,"") unless params[:sname].nil?
      @pdetails['address'] = params[:address].gsub(/<\/?[^>]*>/,"") unless params[:address].nil?
      @pdetails['city'] = params[:city].gsub(/<\/?[^>]*>/,"") unless params[:city].nil?
      @pdetails['country'] = params[:country].gsub(/<\/?[^>]*>/,"") unless params[:country].nil?
      @pdetails['studio_phone'] = params[:sphone].gsub(/<\/?[^>]*>/,"") unless params[:sphone].nil?
      @pdetails['website'] = params[:website].gsub(/<\/?[^>]*>/,"") unless params[:website].nil?
      @pdetails['email'] = params[:email].gsub(/<\/?[^>]*>/,"") unless params[:email].nil?
      @pdetails['name'] = params[:name].gsub(/<\/?[^>]*>/,"") unless params[:name].nil?
      @pdetails['phone'] = params[:phone].gsub(/<\/?[^>]*>/,"") unless params[:phone].nil?
      @pdetails['username'] = @username
      @pdetails['password'] = @password
      @pdetails['children'] = params[:children].gsub(/<\/?[^>]*>/,"") unless params[:children].nil?
      @pdetails['family'] = params[:family].gsub(/<\/?[^>]*>/,"") unless params[:family].nil?
      @pdetails['maternity'] = params[:maternity].gsub(/<\/?[^>]*>/,"")  unless params[:maternity].nil?
      @pdetails['glamour'] = params[:glamour].gsub(/<\/?[^>]*>/,"")  unless params[:glamour].nil?
      @pdetails['high_school'] = params[:high_school].gsub(/<\/?[^>]*>/,"") unless params[:high_school].nil?
      @pdetails['bridal']=params[:bridal].gsub(/<\/?[^>]*>/,"") unless params[:bridal].nil?
      @pdetails['weddings']=params[:weddings].gsub(/<\/?[^>]*>/,"") unless params[:weddings].nil?
      @pdetails['others']=params[:other_session].gsub(/<\/?[^>]*>/,"") unless params[:other_session].nil?
      @pdetails['avg_sessions']=params[:avg_session].gsub(/<\/?[^>]*>/,"") unless params[:avg_session].nil?
      @pdetails['notes']=params[:notes].gsub(/<\/?[^>]*>/,"") unless params[:notes].nil?
      @pdetails['follow_datetime']="#{params[:fmm]} #{params[:fdd]} , #{params[:fyy]} #{params[:thh]}:#{params[:tmm]} #{params[:tam]}"
      @pdetails['follow_person']=params[:follow_person].gsub(/<\/?[^>]*>/,"") unless params[:follow_person].nil?

      if(@pdetails.save)
        @followdate="#{params[:fmm]} #{params[:fdd]} , #{params[:fyy]} #{params[:thh]}:#{params[:tmm]} #{params[:tam]}"


        #Postoffice.deliver_studio_signupinfo(params[:sname],params[:address],params[:city],params[:country],params[:sphone],params[:website],params[:name],params[:phone],params[:email],params[:children],params[:family],params[:maternity],params[:glamour],params[:high_school],params[:bridal],params[:weddings],params[:other_session],params[:avg_session],params[:notes],@followdate,params[:follow_person])

        #Postoffice.deliver_studio_introinfo(params[:name],params[:email],@password)

        flash[:notice]="Details Added Successfully"
        redirect_to '/sales_person/list'
      else
        render :action=> "initial_studio_form"
      end
    end
  end

  def initial_studio_update

    @pdetails = StudioDetail.find(params[:id])
    @pdetails['notes']=params[:notes]
    if(params[:fmm]!='' && params[:fdd]!='' && params[:fyy]!='' && params[:thh]!='' && params[:tmm]!='' && params[:tam]!='' && params[:fmm]!=nil && params[:fdd]!=nil && params[:fyy]!=nil && params[:thh]!=nil && params[:tmm]!=nil && params[:tam]!=nil)
      @pdetails['follow_datetime']="#{params[:fmm]} #{params[:fdd]} , #{params[:fyy]} #{params[:thh]}:#{params[:tmm]} #{params[:tam]}"
    end
    @pdetails['follow_person']=params[:follow_person]

    if(@pdetails.save)
      @followdate="#{params[:fmm]} #{params[:fdd]} , #{params[:fyy]} #{params[:thh]}:#{params[:tmm]} #{params[:tam]}"


      #Postoffice.deliver_studio_signupinfo(params[:sname],params[:address],params[:city],params[:country],params[:sphone],params[:website],params[:name],params[:phone],params[:email],params[:children],params[:family],params[:maternity],params[:glamour],params[:high_school],params[:bridal],params[:weddings],params[:other_session],params[:avg_session],params[:notes],@followdate,params[:follow_person])

      #Postoffice.deliver_studio_introinfo(params[:name],params[:email],@password)

      flash[:notice]="Details Updated Successfully"
      redirect_to '/sales_person/list'
    end
  end

  def list_excel
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="studioreport.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end
    @studiodet =StudioDetail.find(:all,:order => "id desc" )
    render :layout => false

  end



  #Studio Group Deletion
  def studiogroup_delete

    if(params[:id]!='' && params[:id]!=nil)

      @stdgrp=HmmStudiogroup.find(params[:id])
      @stdgrp['status']='inactive'
      @stdgrp.save

      @studios=HmmStudio.find(:all , :conditions=>"studio_groupid=#{params[:id]}")
      for k in @studios
        @studio=HmmStudio.find(k.id)
        @studio['status']='inactive'
        @studio.save
      end
      flash[:msg]="Studio Group deleted successfully"
      redirect_to "/sales_person/studiogroup_list"
    else
      flash[:msg]="Studio Group Deletion failed"
      redirect_to "/sales_person/studiogroup_list"
    end

  end

  def studiogroup_assign_form
    if(params[:id]!='' && params[:id]!=nil)
      @stdgrp=HmmStudiogroup.find(params[:id])
      @hmm_studios=HmmStudio.find(:all,:conditions=>"studio_groupid=#{params[:id]}")
      @hmm_studiogroups=HmmStudiogroup.find(:all,:conditions=>"id!=#{params[:id]} and status='active'")
    end
  end

  def studiogroup_assign

    if(params[:old_studiogroup_id]!='' && params[:old_studiogroup_id]!=nil && params[:new_studiogroup_id]!='' && params[:new_studiogroup_id]!=nil)

      @studios=HmmStudio.find(:all , :conditions=>"studio_groupid=#{params[:old_studiogroup_id]}")
      for k in @studios
        @studio=HmmStudio.find(k.id)
        @studio['studio_groupid']=params[:new_studiogroup_id]
        @studio.save
      end

      @stdgrp=HmmStudiogroup.find(params[:old_studiogroup_id])
      @stdgrp['status']='inactive'
      @stdgrp.save

      flash[:msg]="New Studio Group Assigned to studios successfully"
      redirect_to "/sales_person/studiogroup_list"
    else
      flash[:msg]="Studio Group Assign failed"
      redirect_to "/sales_person/studiogroup_list"
    end

  end

  def list_salesperson
    @salespersion=SalesManager.find(:all,:conditions=>"status='active'")
  end

  def add_sales_person
    if params[:sub]
      emp_count = SalesManager.count(:all, :conditions => "username='#{params[:emp_user_name]}'")
      if emp_count.to_i == 0
        @empuser= SalesManager.new
        @empuser.name=params[:emp_name]
        @empuser.username=params[:emp_user_name]
        @empuser.password=params[:password]
        @empuser.email 	= params[:email]
        @empuser.save
        flash[:message] = "New User Successfully Added."
      else
        flash[:message] = "User Already Exists."
      end
      redirect_to :action=>"add_sales_person"
    end
  end
  def edit_sales_person
    @empusers= SalesManager.find(:first,:conditions=>"id=#{params[:id]}")
    if params[:sub]
      @empuser=SalesManager.find(params[:id])
      @empuser.name=params[:emp_name]
      @empuser.username=params[:emp_user_name]
      @empuser.password=params[:password]
      @empuser.email 	= params[:email]
      @empuser.save
      flash[:message] = "User Successfully Edited."
      redirect_to :action => "list_salesperson"
    end
  end

  def delete_sales_person
    @emp=SalesManager.find(params[:id])
    @emp.status ="inactive"
    @emp.save
    redirect_to :action => "list_salesperson"
    flash[:message] = "User is successfully deleted."
  end

  def check_name
    color = 'red'
    cpnnum = params[:emp_id]
    if cpnnum!=''
      emp_count = SalesManager.count(:all, :conditions => "username='#{params[:emp_user_name]}'")
      if emp_count > 0
        message = 'username Already Exists'
        @valid_username = false
      else
        message = 'username is Available'
        color = 'green'
        @valid_username=true
      end
    else
      message = 'Please enter username'
    end
    @message = "<b style='color:#{color}'>#{message}</b>"
    render :partial=>'message' , :layout => false
  end

  protected
  def ssl_required?
    true
  end


end