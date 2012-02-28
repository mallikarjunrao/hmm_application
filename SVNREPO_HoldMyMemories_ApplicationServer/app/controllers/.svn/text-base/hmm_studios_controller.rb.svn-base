class HmmStudiosController < ApplicationController
  layout "admin"
  helper :sort
  include SortHelper
  require 'will_paginate'

  ssl_allowed :studio_account_setup_report, :studio_account_setup_report_video

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
    :redirect_to => { :action => :list }

  before_filter :authenticate_admin, :only => [:list, :upload_studio_logo, :email_report, :account_setup_report_video, :account_setup_report, :studio_list_upload_logo, :adminstudio_signup, :adminstudio_edit, :show, :new, :edit,:membership_sold_accounts_admin, :account_setup_new_repeat_report, :premium_subscriptions, :premium_subscriptions_info,:upgraded_customers_report,:excel_upgrade_accounts]
  before_filter :authenticate_employe, :only => [:studio_pending_requests_admin,:studio_account_setup_report,:studio_account_setup_report_video]
  before_filter :authenticate_manager, :only => [:market_pending_requests_admin]
  before_filter :authenticate_manager_admin, :only => [:created_customers_report]

  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "https://holdmymemories.com/account/login"
      return false
    end
  end

  def authenticate_employe

    unless session[:employe]
      flash[:error] = "Please Login to Access your Account"
      redirect_to '/account/employe_login'
      return false
    end
  end


  def authenticate_manager
    unless session[:manager]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "/account/market_manager_login"
      return false
    end
  end

  def authenticate_manager_admin
    unless session[:manager] || session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "/account/login"
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

    if params[:studio_branch] && params[:studio_branch]!=''
      cond="and studio_branch LIKE '%#{params[:studio_branch]}%'"
    else
      cond=''
    end

    if params[:studio_address] && params[:studio_address]!=''
      cond1="and studio_address LIKE '%#{params[:studio_address]}%'"
    else
      cond1=''
    end
    @hmm_studios = HmmStudio.paginate :per_page => 10, :page => params[:page], :order => sort, :conditions=>"studio_groupid!=5 and status='active' #{cond} #{cond1}"
  end

  def account_setup_report

    @allstudios= HmmStudio.find(:all,:select=>"id,studio_name",:conditions=>"studio_groupid!=5 and status='active'")
    @hmm_studio = HmmStudio.find(:first,:conditions=>"id=1 and status='active'")
    if(params[:sub] && !params[:to_year].empty? && !params[:to_month].empty? && !params[:to_day].empty? && !params[:from_year].empty? && !params[:from_day].empty? && !params[:from_month].empty? && !params[:studio_id].empty?)
      @obtained_studioid=params[:studio_id]
      @hmm_studio = HmmStudio.find(:first,:conditions=>"id='#{params[:studio_id]}' and status='active'")
      @datediff=HmmUser.find_by_sql("SELECT TO_DAYS('#{params[:to_year]}-#{params[:to_month]}-#{params[:to_day]}') - TO_DAYS('#{params[:from_year]}-#{params[:from_month]}-#{params[:from_day]}') as days")
      if(@datediff[0].days.to_i < 5)
        @date_period = "#{params[:from_year]}-#{params[:from_month]}-#{params[:from_day]}' and '#{params[:to_year]}-#{params[:to_month]}-#{params[:to_day]} 23:59:59"
        calculate_data(@date_period,@hmm_studio.id,"image")
      else
        params[:from_year]="#{Time.now.strftime("%Y")}"
        params[:to_year]="#{Time.now.strftime("%Y")}"
        params[:from_month]="#{Time.now.strftime("%m")}"
        params[:to_month]="#{Time.now.strftime("%m")}"
        params[:from_day]="#{Time.now.strftime("%d")}"
        params[:to_day]="#{Time.now.strftime("%d")}"
        @date_period = "#{Time.now.strftime("%Y-%m-%d")}' and '#{Time.now.strftime("%Y-%m-%d")} 23:59:59"
        calculate_data(@date_period,@hmm_studio.id,"image")
        flash[:notice]="Sorry Results can be displayed only for dates  difference of less than 5 days."
      end

    else
      params[:from_year]="#{Time.now.strftime("%Y")}"
      params[:to_year]="#{Time.now.strftime("%Y")}"
      params[:from_month]="#{Time.now.strftime("%m")}"
      params[:to_month]="#{Time.now.strftime("%m")}"
      params[:from_day]="#{Time.now.strftime("%d")}"
      params[:to_day]="#{Time.now.strftime("%d")}"
      @date_period = "#{Time.now.strftime("%Y-%m-%d")}' and '#{Time.now.strftime("%Y-%m-%d")} 23:59:59"
      calculate_data(@date_period,@hmm_studio.id,"image")

    end
  end
  def account_setup_report_video
    @allstudios= HmmStudio.find(:all,:select=>"id,studio_name",:conditions=>"studio_groupid!=5 and status='active'")
    @hmm_studios =HmmStudio.find(:first,:conditions=>"id=1 and status='active'")
    if(params[:sub])
      @obtained_studioid=params[:studio_id]
      @hmm_studios = HmmStudio.find(:first,:conditions=>"id='#{params[:studio_id]}' and status='active'")
      @datediff=HmmUser.find_by_sql("SELECT TO_DAYS('#{params[:to_year]}-#{params[:to_month]}-#{params[:to_day]}') - TO_DAYS('#{params[:from_year]}-#{params[:from_month]}-#{params[:from_day]}') as days")
      if(@datediff[0].days.to_i < 5)
        @date_period = "#{params[:from_year]}-#{params[:from_month]}-#{params[:from_day]}' and '#{params[:to_year]}-#{params[:to_month]}-#{params[:to_day]} 23:59:59"
        calculate_data(@date_period,@hmm_studios.id,"video")
      else
        params[:from_year]="#{Time.now.strftime("%Y")}"
        params[:to_year]="#{Time.now.strftime("%Y")}"
        params[:from_month]="#{Time.now.strftime("%m")}"
        params[:to_month]="#{Time.now.strftime("%m")}"
        params[:from_day]="#{Time.now.strftime("%d")}"
        params[:to_day]="#{Time.now.strftime("%d")}"
        @date_period = "#{Time.now.strftime("%Y-%m-%d")}' and '#{Time.now.strftime("%Y-%m-%d")} 23:59:59"
        calculate_data(@date_period,@hmm_studios.id,"video")
        flash[:notice]="Sorry Results can be displayed only for dates  difference of less than 5 days."
      end

    else
      params[:from_year]="#{Time.now.strftime("%Y")}"
      params[:to_year]="#{Time.now.strftime("%Y")}"
      params[:from_month]="#{Time.now.strftime("%m")}"
      params[:to_month]="#{Time.now.strftime("%m")}"
      params[:from_day]="#{Time.now.strftime("%d")}"
      params[:to_day]="#{Time.now.strftime("%d")}"
      @date_period = "#{Time.now.strftime("%Y-%m-%d")}' and '#{Time.now.strftime("%Y-%m-%d")} 23:59:59"
      calculate_data(@date_period,@hmm_studios.id,"video")

    end
  end

  def account_setup_new_repeat_report
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
    @hmm_studios = HmmStudio.paginate :per_page => 5,:order=>sort, :page => params[:page],:conditions=>"studio_groupid=1 and status='active'"
    if(params[:sub] && !params[:to_year].empty? && !params[:to_month].empty? && !params[:to_day].empty? && !params[:from_year].empty? && !params[:from_day].empty? && !params[:from_month].empty?)
      #@sel=Gallery.find_by_sql(" SELECT * FROM `galleries` where d_gallery_date=d_created_date LIMIT 0 , 1 ")
      @datediff=HmmUser.find_by_sql("SELECT TO_DAYS('#{params[:to_year]}-#{params[:to_month]}-#{params[:to_day]}') - TO_DAYS('#{params[:from_year]}-#{params[:from_month]}-#{params[:from_day]}') as days")
      if(@datediff[0].days.to_i < 8)
        date_periods = "d_created_date between '#{params[:from_year]}-#{params[:from_month]}-#{params[:from_day]}' and '#{params[:to_year]}-#{params[:to_month]}-#{params[:to_day]} 23:59:59'"
        session[:fyear]=params[:from_year]
        session[:fmon]=params[:from_month]
        session[:fday]=params[:from_day]
        session[:tyear]=params[:to_year]
        session[:tmon]=params[:to_month]
        session[:tday]=params[:to_day]
        session[:dateper]=date_periods
      else
        params[:from_year]="#{Time.now.strftime("%Y")}"
        params[:to_year]="#{Time.now.strftime("%Y")}"
        params[:from_month]="#{Time.now.strftime("%m")}"
        params[:to_month]="#{Time.now.strftime("%m")}"
        params[:from_day]="#{Time.now.strftime("%d")}"
        params[:to_day]="#{Time.now.strftime("%d")}"
        date_periods = "d_created_date between '#{Time.now.strftime("%Y-%m-%d")}' and '#{Time.now.strftime("%Y-%m-%d")} 23:59:59'"
        flash[:notice]="Sorry Results can be displayed only for dates  difference of less than 8 days."
        session[:dateper]= date_periods
      end

    else
      params[:from_year]="#{Time.now.strftime("%Y")}"
      params[:to_year]="#{Time.now.strftime("%Y")}"
      params[:from_month]="#{Time.now.strftime("%m")}"
      params[:to_month]="#{Time.now.strftime("%m")}"
      params[:from_day]="#{Time.now.strftime("%d")}"
      params[:to_day]="#{Time.now.strftime("%d")}"
      date_periods = "d_created_date between '#{Time.now.strftime("%Y-%m-%d")}' and '#{Time.now.strftime("%Y-%m-%d")} 23:59:59'"
    end
    if(session[:fyear] != nil)
      params[:from_year]= session[:fyear]
      params[:from_month]=  session[:fmon]
      params[:from_day]=  session[:fday]
      params[:to_year]= session[:tyear]
      params[:to_month]= session[:tmon]
      params[:to_day]= session[:tday]
    end
    if(session[:dateper] == nil )
      @date_period= date_periods
    else
      @date_period=session[:dateper]
    end
  end


  def account_setup_report_detail_users_info
    account_type = params[:account_type]
    date_period = params[:dateperiod]
    studio_id = params[:studio_id]
    @hmm_users= HmmUser.paginate :page => params[:page], :per_page => "20", :conditions => "account_type='#{account_type}' and #{date_period} and studio_id='#{studio_id}'"

  end

  def account_setup_report_detail_session_info
    account_type = params[:account_type]
    date_period = params[:dateperiod]
    studio_id = params[:studio_id]
    type= params[:type]
    hmm_users=HmmUser.find(:all, :select => "id,studio_id", :conditions => "account_type='#{account_type}' and #{date_period} and studio_id='#{studio_id}'")
    studiosessioncount = 0
    hmmlist = "(0,"

    for hmmuser in hmm_users
      studiosession=false
      subchapters=SubChapter.count(:all, :conditions => "uid='#{hmmuser.id}' and store_id='#{hmmuser.studio_id}'")
      if(subchapters > 0 )
        subchapters=SubChapter.find(:all,:select => "id", :conditions => "uid='#{hmmuser.id}' and store_id='#{hmmuser.studio_id}'")
        for subchapter in subchapters
          galleries = Galleries.find(:all, :select => "id", :conditions => "subchapter_id = '#{subchapter.id}' and e_gallery_type='#{type}'")
          for gallery in galleries
            contentcount = UserContent.count(:all, :conditions => "gallery_id='#{gallery.id}' and status='active'", :limit => "0,1")
            if(contentcount > 0 )
              studiosession=true
            end
          end
        end
      end
      if(studiosession==true)
        hmmlist="#{hmmlist}#{hmmuser.id},"
        studiosessioncount = studiosessioncount + 1
      end
    end
    hmmlist="#{hmmlist}0)"
    @hmm_users= HmmUser.paginate :page => params[:page], :per_page => "20", :conditions => "id in #{hmmlist}"

  end


  def account_setup_report_detail_users_new_repeat_info
    account_type = params[:account_type]
    date_period = params[:dateperiod]
    studio_id = params[:studio_id]

    @hmm_users= HmmUser.paginate :page => params[:page], :per_page => "20", :conditions => "account_type='#{account_type}' and #{date_period} and studio_id='#{studio_id}'"

  end

  def account_setup_report_detail_session_info
    account_type = params[:account_type]
    date_period = params[:dateperiod]
    studio_id = params[:studio_id]
    type= params[:type]
    hmm_users=HmmUser.find(:all, :select => "id,studio_id", :conditions => "account_type='#{account_type}' and #{date_period} and studio_id='#{studio_id}'")
    studiosessioncount = 0
    hmmlist = "(0,"

    for hmmuser in hmm_users
      studiosession=false
      subchapters=SubChapter.count(:all, :conditions => "uid='#{hmmuser.id}' and store_id='#{hmmuser.studio_id}'")
      if(subchapters > 0 )
        subchapters=SubChapter.find(:all,:select => "id", :conditions => "uid='#{hmmuser.id}' and store_id='#{hmmuser.studio_id}'")
        for subchapter in subchapters
          galleries = Galleries.find(:all, :select => "id", :conditions => "subchapter_id = '#{subchapter.id}' and e_gallery_type='#{type}'")
          for gallery in galleries
            contentcount = UserContent.count(:all, :conditions => "gallery_id='#{gallery.id}' and status='active'", :limit => "0,1")
            if(contentcount > 0 )
              studiosession=true
            end
          end
        end
      end
      if(studiosession==true)
        hmmlist="#{hmmlist}#{hmmuser.id},"
        studiosessioncount = studiosessioncount + 1
      end
    end
    hmmlist="#{hmmlist}0)"
    @hmm_users= HmmUser.paginate :page => params[:page], :per_page => "20", :conditions => "id in #{hmmlist}"

  end


  def account_setup_report_detail_new_session_info
    account_type = params[:account_type]
    date_period = params[:dateperiod]
    studio_id = params[:studio_id]
    type= params[:type]

    hmm_users=HmmUser.find(:all, :select => "id,studio_id,d_created_date", :conditions => "account_type='#{account_type}' and #{date_period} and studio_id='#{studio_id}'")
    hmmlist = "(0,"
    for hmmuser in hmm_users
      subchapters=SubChapter.count(:all, :conditions => "uid='#{hmmuser.id}' and store_id='#{hmmuser.studio_id}'")
      if(subchapters > 0 )
        subchapters=SubChapter.find(:first,:select => "id", :conditions => "uid='#{hmmuser.id}' and store_id='#{hmmuser.studio_id}'")
        galleries = Galleries.count(:first, :select => "id", :conditions => "subchapter_id = '#{subchapters.id}' ",:order => "d_gallery_date DESC",:limit => "0,1" )
        if(galleries > 0 )
          galleries = Galleries.find(:first, :select => "id,d_gallery_date", :conditions => "subchapter_id = '#{subchapters.id}'  ",:order => "d_gallery_date DESC",:limit => "0,1" )
          #if(hmmuser.d_created_date.strftime("%Y-%m")== galleries.d_gallery_date.strftime("%Y-%m"))
          datediff = HmmUser.find_by_sql("select DATEDIFF('#{galleries.d_gallery_date.strftime('%Y-%m-%d')}','#{hmmuser.d_created_date.strftime('%Y-%m-%d')}') as datedif")
          datedifference=datediff[0].datedif.to_i
          if(datedifference < 10 )
            hmmlist="#{hmmlist}#{hmmuser.id},"
          end
        elsif(galleries == 0)
          hmmlist="#{hmmlist}#{hmmuser.id},"
        end
      elsif(subchapters == 0)
        hmmlist="#{hmmlist}#{hmmuser.id},"
      end
    end
    hmmlist="#{hmmlist}0)"
    @hmm_users= HmmUser.paginate :page => params[:page], :per_page => "20", :conditions => "id in #{hmmlist}"

  end


  def account_setup_report_detail_repeat_session_info
    account_type = params[:account_type]
    date_period = params[:dateperiod]
    studio_id = params[:studio_id]
    type= params[:type]
    hmm_users=HmmUser.find(:all, :select => "id,studio_id,d_created_date", :conditions => "account_type='#{account_type}' and #{date_period} and studio_id='#{studio_id}'")
    hmmlist = "(0,"
    for hmmuser in hmm_users
      subchapters=SubChapter.count(:all, :conditions => "uid='#{hmmuser.id}' and store_id='#{hmmuser.studio_id}'")
      if(subchapters > 0 )
        subchapters=SubChapter.find(:first,:select => "id", :conditions => "uid='#{hmmuser.id}' and store_id='#{hmmuser.studio_id}'")
        galleries = Galleries.count(:first, :select => "id", :conditions => "subchapter_id = '#{subchapters.id}'",:order => "d_gallery_date DESC",:limit => "0,1" )
        if(galleries > 0 )
          galleries = Galleries.find(:first, :select => "id,d_gallery_date", :conditions => "subchapter_id = '#{subchapters.id}'  ",:order => "d_gallery_date DESC",:limit => "0,1" )
          #if(hmmuser.d_created_date.strftime("%Y-%m") < galleries.d_gallery_date.strftime("%Y-%m"))
          datediff = HmmUser.find_by_sql("select DATEDIFF('#{galleries.d_gallery_date.strftime('%Y-%m-%d')}','#{hmmuser.d_created_date.strftime('%Y-%m-%d')}') as datedif")
          datedifference=datediff[0].datedif.to_i
          if(datedifference > 10 )
            hmmlist="#{hmmlist}#{hmmuser.id},"
          end
        end
      end
    end
    hmmlist="#{hmmlist}0)"
    @hmm_users= HmmUser.paginate :page => params[:page], :per_page => "20", :conditions => "id in #{hmmlist}"
  end

  #account report of the studio employee/manager
  def studio_account_setup_report

    store_id=session[:store_id]

    @hmm_studios = HmmStudio.find(:first,:conditions=>"id=#{store_id} and status='active'")
    if(params[:sub])
      @datediff=HmmUser.find_by_sql("SELECT TO_DAYS('#{params[:to_year]}-#{params[:to_month]}-#{params[:to_day]}') - TO_DAYS('#{params[:from_year]}-#{params[:from_month]}-#{params[:from_day]}') as days")
      if(@datediff[0].days.to_i < 5)
        @date_period = "#{params[:from_year]}-#{params[:from_month]}-#{params[:from_day]}' and '#{params[:to_year]}-#{params[:to_month]}-#{params[:to_day]} 23:59:59"
        calculate_data(@date_period,@hmm_studios.id,"image")
      else
        params[:from_year]="#{Time.now.strftime("%Y")}"
        params[:to_year]="#{Time.now.strftime("%Y")}"
        params[:from_month]="#{Time.now.strftime("%m")}"
        params[:to_month]="#{Time.now.strftime("%m")}"
        params[:from_day]="#{Time.now.strftime("%d")}"
        params[:to_day]="#{Time.now.strftime("%d")}"
        @date_period = "'#{Time.now.strftime("%Y-%m-%d")}' and '#{Time.now.strftime("%Y-%m-%d")} 23:59:59'"
        calculate_data(@date_period,@hmm_studios.id,"image")
        flash[:notice]="Sorry Results can be displayed only for dates  difference of less than 5 days."
      end

    else
      params[:from_year]="#{Time.now.strftime("%Y")}"
      params[:to_year]="#{Time.now.strftime("%Y")}"
      params[:from_month]="#{Time.now.strftime("%m")}"
      params[:to_month]="#{Time.now.strftime("%m")}"
      params[:from_day]="#{Time.now.strftime("%d")}"
      params[:to_day]="#{Time.now.strftime("%d")}"
      @date_period = "#{Time.now.strftime("%Y-%m-%d")}' and '#{Time.now.strftime("%Y-%m-%d")} 23:59:59"
      calculate_data(@date_period,@hmm_studios.id,"image")
    end
  end





  def studio_account_setup_report_video

    store_id=session[:store_id]

    @hmm_studios = HmmStudio.find(:first,:conditions=>"id=#{store_id} and status='active'")
    if(params[:sub])
      @datediff=HmmUser.find_by_sql("SELECT TO_DAYS('#{params[:to_year]}-#{params[:to_month]}-#{params[:to_day]}') - TO_DAYS('#{params[:from_year]}-#{params[:from_month]}-#{params[:from_day]}') as days")
      if(@datediff[0].days.to_i < 5)
        @date_period = "#{params[:from_year]}-#{params[:from_month]}-#{params[:from_day]}' and '#{params[:to_year]}-#{params[:to_month]}-#{params[:to_day]} 23:59:59"
        calculate_data(@date_period,@hmm_studios.id,"video")
      else
        params[:from_year]="#{Time.now.strftime("%Y")}"
        params[:to_year]="#{Time.now.strftime("%Y")}"
        params[:from_month]="#{Time.now.strftime("%m")}"
        params[:to_month]="#{Time.now.strftime("%m")}"
        params[:from_day]="#{Time.now.strftime("%d")}"
        params[:to_day]="#{Time.now.strftime("%d")}"
        @date_period = "'#{Time.now.strftime("%Y-%m-%d")}' and '#{Time.now.strftime("%Y-%m-%d")} 23:59:59'"
        calculate_data(@date_period,@hmm_studios.id,"video")
        flash[:notice]="Sorry Results can be displayed only for dates  difference of less than 5 days."
      end

    else
      params[:from_year]="#{Time.now.strftime("%Y")}"
      params[:to_year]="#{Time.now.strftime("%Y")}"
      params[:from_month]="#{Time.now.strftime("%m")}"
      params[:to_month]="#{Time.now.strftime("%m")}"
      params[:from_day]="#{Time.now.strftime("%d")}"
      params[:to_day]="#{Time.now.strftime("%d")}"
      @date_period = "#{Time.now.strftime("%Y-%m-%d")}' and '#{Time.now.strftime("%Y-%m-%d")} 23:59:59"
      calculate_data(@date_period,@hmm_studios.id,"video")
    end
  end


  #account report of the market managers
  def studiomarket_account_setup_report

    studio = Array.new
    @studioids=ManagerBranche.find(:all,:conditions=>{:manager_id=>session[:manager]},:select=>"branch_id")
    for @studioid in @studioids
      studio.push(@studioid['branch_id'])
    end
    @studio_ids = studio.join(",")

    @allstudios = HmmStudio.find(:all,:conditions=>"id IN (#{@studio_ids})  and status='active'")
    @hmm_studios =HmmStudio.find(:first,:conditions=>"id=#{@allstudios[0]['id']} and status='active'")
    if(params[:sub])
      @hmm_studios = HmmStudio.find(:first,:conditions=>"id='#{params[:studio_id]}' and status='active'")
      @obtained_studioid=params[:studio_id]
      @datediff=HmmUser.find_by_sql("SELECT TO_DAYS('#{params[:to_year]}-#{params[:to_month]}-#{params[:to_day]}') - TO_DAYS('#{params[:from_year]}-#{params[:from_month]}-#{params[:from_day]}') as days")
      if(@datediff[0].days.to_i < 5)
        @date_period = "#{params[:from_year]}-#{params[:from_month]}-#{params[:from_day]}' and '#{params[:to_year]}-#{params[:to_month]}-#{params[:to_day]} 23:59:59"
        calculate_data(@date_period,@hmm_studios.id,"image")
      else
        params[:from_year]="#{Time.now.strftime("%Y")}"
        params[:to_year]="#{Time.now.strftime("%Y")}"
        params[:from_month]="#{Time.now.strftime("%m")}"
        params[:to_month]="#{Time.now.strftime("%m")}"
        params[:from_day]="#{Time.now.strftime("%d")}"
        params[:to_day]="#{Time.now.strftime("%d")}"
        @date_period = "#{Time.now.strftime("%Y-%m-%d")}' and '#{Time.now.strftime("%Y-%m-%d")} 23:59:59"
        calculate_data(@date_period,@hmm_studios.id,"image")
        flash[:notice]="Sorry Results can be displayed only for dates  difference of less than 5 days."
      end

    else
      params[:from_year]="#{Time.now.strftime("%Y")}"
      params[:to_year]="#{Time.now.strftime("%Y")}"
      params[:from_month]="#{Time.now.strftime("%m")}"
      params[:to_month]="#{Time.now.strftime("%m")}"
      params[:from_day]="#{Time.now.strftime("%d")}"
      params[:to_day]="#{Time.now.strftime("%d")}"
      @date_period = "#{Time.now.strftime("%Y-%m-%d")}' and '#{Time.now.strftime("%Y-%m-%d")} 23:59:59"
      calculate_data(@date_period,@hmm_studios.id,"image")
    end
  end

  #  def calculate_data(dateperiod,studio_id,type)
  #    @total_premimum=0
  #    @total_family=0
  #    @total_free=0
  #    @image_premimum=0
  #    @image_family=0
  #    @image_free=0
  #    logger.info("total_small galleries")
  #    total_galleries= Galleries.find(:all,:select=>"a.id,c.account_type",:joins=>"as a,sub_chapters as b,hmm_users as c",:conditions =>"a.d_gallery_date between  '#{dateperiod}' and a.subchapter_id=b.id and b.store_id='#{studio_id}' and a.e_gallery_type='#{type}' and b.uid=c.id",:group=>"c.id")
  #    total_galleries1= Galleries.find(:all,:select=>"a.id,c.account_type",:joins=>"as a,sub_chapters as b,hmm_users as c",:conditions =>"a.d_gallery_date between  '#{dateperiod}' and a.subchapter_id=b.id and b.store_id='#{studio_id}' and a.e_gallery_type='#{type}' and b.uid=c.id",:group=>"a.id")
  #
  #    for total_gallery in total_galleries
  #      if total_gallery.account_type=="platinum_user"
  #        @total_premimum =@total_premimum + 1
  #      elsif total_gallery.account_type=="familyws_user"
  #        @total_family=@total_family+1
  #      elsif  total_gallery.account_type=="free_user"
  #        @total_free=@total_free+1
  #      end
  #    end
  #
  #    for total_gallery1 in total_galleries1
  #      user_images=UserContent.find(:first,:conditions => "gallery_id='#{total_gallery1.id}'")
  #      if(user_images)
  #        if total_gallery1.account_type=="platinum_user"
  #          @image_premimum =@image_premimum + 1
  #        elsif total_gallery1.account_type=="familyws_user"
  #          @image_family=@image_family+1
  #        elsif  total_gallery1.account_type=="free_user"
  #          @image_free=@image_free+1
  #        end
  #      end
  #    end
  #  end


  def studiomarket_account_setup_report_video

    studio = Array.new
    @studioids=ManagerBranche.find(:all,:conditions=>{:manager_id=>session[:manager]},:select=>"branch_id")
    for @studioid in @studioids
      studio.push(@studioid['branch_id'])
    end
    @studio_ids = studio.join(",")


    @allstudios = HmmStudio.find(:all,:conditions=>"id IN (#{@studio_ids})  and status='active'")
    @hmm_studios =HmmStudio.find(:first,:conditions=>"id=#{@allstudios[0]['id']} and status='active'")
    if(params[:sub])
      @hmm_studios = HmmStudio.find(:first,:conditions=>"id='#{params[:studio_id]}' and status='active'")
      @obtained_studioid=params[:studio_id]
      @datediff=HmmUser.find_by_sql("SELECT TO_DAYS('#{params[:to_year]}-#{params[:to_month]}-#{params[:to_day]}') - TO_DAYS('#{params[:from_year]}-#{params[:from_month]}-#{params[:from_day]}') as days")
      if(@datediff[0].days.to_i < 5)
        @date_period = "#{params[:from_year]}-#{params[:from_month]}-#{params[:from_day]}' and '#{params[:to_year]}-#{params[:to_month]}-#{params[:to_day]} 23:59:59"
        calculate_data(@date_period,@hmm_studios.id,"video")
      else
        params[:from_year]="#{Time.now.strftime("%Y")}"
        params[:to_year]="#{Time.now.strftime("%Y")}"
        params[:from_month]="#{Time.now.strftime("%m")}"
        params[:to_month]="#{Time.now.strftime("%m")}"
        params[:from_day]="#{Time.now.strftime("%d")}"
        params[:to_day]="#{Time.now.strftime("%d")}"
        @date_period = "#{Time.now.strftime("%Y-%m-%d")}' and '#{Time.now.strftime("%Y-%m-%d")} 23:59:59"
        calculate_data(@date_period,@hmm_studios.id,"video")
        flash[:notice]="Sorry Results can be displayed only for dates  difference of less than 5 days."
      end

    else
      params[:from_year]="#{Time.now.strftime("%Y")}"
      params[:to_year]="#{Time.now.strftime("%Y")}"
      params[:from_month]="#{Time.now.strftime("%m")}"
      params[:to_month]="#{Time.now.strftime("%m")}"
      params[:from_day]="#{Time.now.strftime("%d")}"
      params[:to_day]="#{Time.now.strftime("%d")}"
      @date_period = "#{Time.now.strftime("%Y-%m-%d")}' and '#{Time.now.strftime("%Y-%m-%d")} 23:59:59"
      calculate_data(@date_period,@hmm_studios.id,"video")
    end
  end

















  def franchise_credit_list
    sort_init 'studio_branch'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "studio_branch desc"
      else
        sort = "studio_branch asc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end

    @hmm_studios = HmmStudio.paginate :per_page => 10,:conditions=>"studio_groupid=#{session[:franchise]} and status='active'", :order => sort, :page => params[:page]
    @studio_system=HmmStudiogroup.find(session[:franchise])
    if @studio_system.credit_system == "Points"
      @chek1="selected"
    end
    if @studio_system.credit_system == "Dollars"
      @chek2="selected"
    end
  end

  def studio_credit_list
    sort_init 'studio_branch'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "studio_branch desc"
      else
        sort = "studio_branch asc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end

    if params[:studio_branch] && params[:studio_branch]!=''
      cond = "and studio_branch LIKE '%#{params[:studio_branch]}%'"
    else
      cond = ''
    end

    if params[:studio_address] && params[:studio_address]!=''
      cond1 = "and studio_address LIKE '%#{params[:studio_address]}%'"
    else
      cond1 = ''
    end
    @hmm_studios = HmmStudio.paginate :per_page => 10, :order => sort, :conditions=>"studio_groupid=#{session[:franchise]} and status='active' #{cond} #{cond1}", :page => params[:page]
  end

  def studio_list
    @hmm_studios = HmmStudio.paginate :per_page => 10, :conditions=>"studio_groupid=#{session[:franchise]} and status='active'", :page => params[:page]
  end

  #Set Sales Tax for Studio
  def manage_studiosalestax
    @hmmstudios=HmmStudio.find(params[:id])
  end

  def update_studiosalestax
    @hmmstudio=HmmStudio.find(params[:id])
    @hmmstudio['tax_rate']=Float(params[:tax_rate]).round(2)
    @hmmstudio.save

    flash[:salesnotice]='Studio Sales Tax Updated'
    redirect_to "/hmm_studios/manage_studiosalestax/#{params[:id]}"


  end

  def show
    @hmm_studio = HmmStudio.find(params[:id])
  end

  def new
    @hmm_studio = HmmStudio.new
  end

  def franchise_studio_new
    @hmm_studio = HmmStudio.new
  end

  def create
    @hmm_studio = HmmStudio.new(params[:hmm_studio])
    if @hmm_studio.save
      flash[:notice] = 'HmmStudio was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def franchise_studio_create
    @hmm_studio = HmmStudio.new
    @hmm_studio['studio_groupid']=session[:franchise]
    @hmm_studio['studio_branch']=params[:hmm_studio][:studio_branch]
    @hmm_studio['studio_address']=params[:hmm_studio][:studio_address]
    if @hmm_studio.save
      flash[:notice] = 'Studio was successfully created.'
      redirect_to :action => 'studio_credit_list'
    else
      render :action => 'franchise_studio_new'
    end
  end

  def edit

    @hmm_studio = HmmStudio.find(params[:id])
    @sid = params[:id]

  end

  def franchise_studio_edit

    @hmm_studio = HmmStudio.find(params[:id])
    @sid = params[:id]

  end



  def franchise_credit_edit

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

  def franchise_credit_system
    @hmm_studiogroup = HmmStudiogroup.find(params[:id])
    @hmm_studiogroup.credit_system=params[:credit_system]
    if @hmm_studiogroup.save
      flash[:notice] = 'Studio was successfully updated.'
      redirect_to :action => 'franchise_credit_list'
    end

  end

  def franchise_credit_update
    @hmm_studio = HmmStudio.find(params[:id])
    if params[:hmm_studio][:credit_option]== "no"
      params[:hmm_studio][:credit_percentage]=""
    end
    if @hmm_studio.update_attributes(params[:hmm_studio])
      flash[:notice] = 'Studio was successfully updated.'
      redirect_to :action => 'franchise_credit_list', :id => @hmm_studio
    else
      render :action => 'franchise_credit_edit'
    end
  end


  def update
    @hmm_studio = HmmStudio.find(params[:id])
    if @hmm_studio.update_attributes(params[:hmm_studio])
      flash[:notice] = 'HmmStudio was successfully updated.'
      redirect_to :action => 'show', :id => @hmm_studio
    else
      render :action => 'edit'
    end
  end


  def franchise_studio_update
    @hmm_studio = HmmStudio.find(params[:id])
    if @hmm_studio.update_attributes(params[:hmm_studio])
      flash[:notice] = 'Studio was successfully updated.'
      redirect_to :action => 'studio_credit_list'
    else
      render :action => 'franchise_studio_edit'
    end
  end



  def franchise_credit_updateall

    if params[:credit_option]=="no"
      params[:credit_percentage]=""
    end
    if params[:credit_percentage]==""
      params[:credit_percentage]="0"
    end
    @studios=HmmStudio.find(:all,:conditions=>"studio_groupid=#{session[:franchise]}")
    for k in @studios
      @std=HmmStudio.find(k.id)
      @std['credit_option']=params[:credit_option]
      @std['credit_percentage']=params[:credit_percentage]
      @std.save
    end
    flash[:notice] = 'Studio Credits was successfully updated Equally.'
    redirect_to :action => 'franchise_credit_list'
  end

  def destroy
    #    @hmm_studio = HmmStudio.find(params[:id])
    #    @hmm_studio['status']='inactive'
    #    @hmm_studio.save

    HmmStudio.find(params[:id]).destroy
    $notice_del
    flash[:notice_del] = 'HmmStudio was successfully updated.'
    redirect_to :action => 'list'
  end

  def franchise_studio_destroy

    HmmStudio.find(params[:id]).destroy
    $notice_del
    flash[:notice_del] = 'Studio was successfully deleted.'
    redirect_to :action => 'studio_credit_list'
  end

  def check
    @employe_account_id = HmmStudio.find(params[:id])
    @employe_account = EmployeAccount.count(:all, :conditions => "store_id = '#{params[:id]}'")
    if @employe_account > 0
      @employe_account_details = EmployeAccount.find(:all, :conditions => "store_id = '#{params[:id]}'")
    else
      redirect_to :action => 'destroy', :id => @employe_account_id
    end
  end

  def franchise_studio_check
    @employe_account_id = HmmStudio.find(params[:id])
    @employe_account = EmployeAccount.count(:all, :conditions => "store_id = '#{params[:id]}'")
    if @employe_account > 0
      @employe_account_details = EmployeAccount.find(:all, :conditions => "store_id = '#{params[:id]}'")
    else
      redirect_to :action => 'franchise_studio_destroy', :id => @employe_account_id
    end
  end


  def validate
    color = 'red'
    studio_name = params[:studio_branch]

    user = HmmStudio.find_all_by_studio_branch(studio_name)
    #      studio_id = HmmStudio.count(:all, :conditions => "studio_name")
    if user.size > 0
      message = 'Studio is Already added'
      @valid_studioname = false

    end
    @message = "<b style='color:#{color}'>#{message}</b>"

    render :partial=>'message'
  end

  def validate_edit
    color = 'red'
    @studio_name = params[:studio_branch]
    @sid = params[:id]
    @studioname = HmmStudio.find(params[:id])
    @branchname = @studioname.studio_branch
    @user1 = HmmStudio.find(:all, :conditions => "id = '#{@sid}'")
    for i in @user1
      stud = i.studio_branch
    end
    user = HmmStudio.find_all_by_studio_branch(@studio_name)
    if user.size > 0 && stud != @studio_name
      message = 'Studio is Already added'
      @valid_studioname = false
    end
    @message = "<b style='color:#{color}'>#{message}</b>"

    render :partial=>'message'
  end


  def adminstudio_signup

    @states_list=State.find(:all)
    #render :layout => "application"

  end

  def adminstudio_edit

    @hmm_studio = HmmStudio.find(params[:id])
    @states_list=State.find(:all)

  end

  def studio_signup

    @states_list=State.find(:all)
    #render :layout => "application"

  end

  def studio_edit

    @hmm_studio = HmmStudio.find(params[:id])
    @states_list=State.find(:all)

  end

  def update_button_logos


  end

  def studio_list_upload_logo
    @hmm_studios = HmmStudio.paginate :per_page => 10, :page => params[:page]
  end

  def upload_studio_logo

    @hmm_studio = HmmStudio.find(params[:id])

  end

  def delete_studio_logo

    @hmm_studio = HmmStudio.find(params[:id])
    @hmm_studio['studio_top_logo']=""

    if @hmm_studio.save
      flash[:notice] = 'Logo removed'
      redirect_to :action => 'upload_studio_logo', :id => params[:id]
    end
  end

  #Customers Email Report
  def email_report
    sort_init 'id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "hmm_users.id desc"
      else

        sort = "hmm_users.id desc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end

    if (params[:fyy]!=nil && params[:fmm] !=nil && params[:fdd] !=nil && params[:tyy] !=nil && params[:tmm] !=nil && params[:tdd] !=nil && params[:fyy]!='' && params[:fmm] !='' && params[:fdd] !='' && params[:tyy] !='' && params[:tmm] !='' && params[:tdd] !='')

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
      conditions1= " and hmm_users.d_created_date  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
    end

    if(params[:account_type]!=nil && params[:account_type]!='')
      conditions2= " and hmm_users.account_type='#{params[:account_type]}' "
    end

    if(params[:studio_group]!=nil && params[:studio_group]!='')
      conditions3= " and hmm_studiogroups.id='#{params[:studio_group]}' "
    end

    if(params[:customer_type]!=nil && params[:customer_type]!='')
      if(params[:customer_type]=='0')
        conditions4= " and hmm_users.studio_id='#{params[:customer_type]}' "
      elsif(params[:customer_type]=='1')
        conditions4= " and hmm_users.studio_id!=0 "
      end
    end


    conditions="1=1 #{conditions1} #{conditions2} #{conditions3} #{conditions4}"


    @hmm_users = HmmUser.paginate :select => "hmm_users.v_fname,hmm_users.v_lname,hmm_users.v_user_name,hmm_users.v_e_mail,hmm_users.d_created_date,hmm_studios.studio_name,hmm_studiogroups.hmm_franchise_studio,hmm_users.account_expdate,hmm_users.account_type", :joins =>" LEFT JOIN hmm_studios
ON hmm_users.studio_id=hmm_studios.id LEFT JOIN hmm_studiogroups
ON hmm_studios.studio_groupid=hmm_studiogroups.id", :per_page => 10, :conditions=>conditions ,:page => params[:page], :order => sort

    render :layout => true
  end

  def email_report_excel
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="statisticalreport.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end
    sort_init 'id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "hmm_users.id desc"
      else

        sort = "hmm_users.id desc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end

    if (params[:fyy]!=nil && params[:fmm] !=nil && params[:fdd] !=nil && params[:tyy] !=nil && params[:tmm] !=nil && params[:tdd] !=nil && params[:fyy]!='' && params[:fmm] !='' && params[:fdd] !='' && params[:tyy] !='' && params[:tmm] !='' && params[:tdd] !='')

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
      conditions1= " and hmm_users.d_created_date  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
    end

    if(params[:account_type]!=nil && params[:account_type]!='')
      conditions2= " and hmm_users.account_type='#{params[:account_type]}' "
    end

    if(params[:studio_group]!=nil && params[:studio_group]!='')
      conditions3= " and hmm_studiogroups.id='#{params[:studio_group]}' "
    end

    if(params[:customer_type]!=nil && params[:customer_type]!='')
      if(params[:customer_type]=='0')
        conditions4= " and hmm_users.studio_id='#{params[:customer_type]}' "
      elsif(params[:customer_type]=='1')
        conditions4= " and hmm_users.studio_id!=0 "
      end
    end


    conditions="1=1 #{conditions1} #{conditions2} #{conditions3} #{conditions4}"
    session[:custom_conditions]=conditions
    session[:custom_sort]=sort

    hmm_users_count = HmmUser.count(:all,:joins =>" LEFT JOIN hmm_studios
ON hmm_users.studio_id=hmm_studios.id LEFT JOIN hmm_studiogroups
ON hmm_studios.studio_groupid=hmm_studiogroups.id", :conditions=>conditions , :order => sort )
    if hmm_users_count < 10000
      @hmm_users = HmmUser.find(:all, :select => "hmm_users.v_fname,hmm_users.v_lname,hmm_users.v_user_name,hmm_users.v_e_mail,hmm_users.d_created_date,hmm_studios.studio_name,hmm_studiogroups.hmm_franchise_studio,hmm_users.account_expdate,hmm_users.account_type", :joins =>" LEFT JOIN hmm_studios
ON hmm_users.studio_id=hmm_studios.id LEFT JOIN hmm_studiogroups
ON hmm_studios.studio_groupid=hmm_studiogroups.id", :conditions=>conditions ,:group=>"hmm_users.id", :order => sort )
      render :layout => false
    else
      redirect_to "/hmm_studios/choose_report?count=#{hmm_users_count}"
    end
  end

  def choose_report
    if params[:val]
      begin
        headers['Content-Type'] = "application/vnd.ms-excel"
        headers['Content-Disposition'] = 'attachment; filename="statisticalreport.xls"'
        headers['Cache-Control'] = ''
      rescue
        logger.info("unable to create excel sheet for these records")
      end

      val=params[:val].to_i
      count_val=params[:count].to_i/10000
      if val==count_val.to_i && count_val.to_i >= 5
        lim_value=params[:count].to_i%10000
        lim_value=lim_value-1
      else
        lim_value=10000
      end
      @hmm_users = HmmUser.find(:all, :select => "hmm_users.v_fname,hmm_users.v_lname,hmm_users.v_user_name,hmm_users.v_e_mail,hmm_users.d_created_date,hmm_studios.studio_name,hmm_studiogroups.hmm_franchise_studio,hmm_users.account_expdate,hmm_users.account_type", :joins =>" LEFT JOIN hmm_studios
 ON hmm_users.studio_id=hmm_studios.id LEFT JOIN hmm_studiogroups
 ON hmm_studios.studio_groupid=hmm_studiogroups.id", :conditions=>session[:custom_conditions] ,:group=>"hmm_users.id", :order =>  session[:custom_sort],:limit=>"#{val*10000},#{lim_value}")
      # redirect_to :action=>"email_report"
      render :layout => false
    end
  end

  #no of customers active and inactive
  def created_customers_report
    sort_init 'id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "hmm_users.id desc"
      else

        sort = "hmm_users.id desc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end

    if (params[:from_bdate]!=nil && params[:to_bdate] !=nil && params[:end_date] !=nil)

      #from_yr=params[:from_bdate]['start_year1910ordermonthdayyear(1i)']
      #from_mon=params[:from_bdate]['start_year1910ordermonthdayyear(2i)']
      #from_date=params[:from_bdate]['start_year1910ordermonthdayyear(3i)']

      #      from_yr=params[:fyy]
      #      from_mon=params[:fmm]
      #      from_date=params[:fdd]

      from_yr=params[:from_bdate]['ordermonthdayyear(1i)']
      from_mon=params[:from_bdate]['ordermonthdayyear(2i)']
      from_date=params[:from_bdate]['ordermonthdayyear(3i)']


      fromdate="#{from_yr}-#{from_mon}-#{from_date}"


      to_yr=params[:to_bdate]['ordermonthdayyear(1i)']
      to_mon=params[:to_bdate]['ordermonthdayyear(2i)']
      to_date=params[:to_bdate]['ordermonthdayyear(3i)']
      todate="#{to_yr}-#{to_mon}-#{to_date}"
      e_yr=params[:end_date]['ordermonthdayyear(1i)']
      e_mon=params[:end_date]['ordermonthdayyear(2i)']
      e_date=params[:end_date]['ordermonthdayyear(3i)']



      edate="#{e_yr}-#{e_mon}-#{e_date}"

      #params[:from_bdate]['ordermonthdayyearstart_year1909(1i)']
      total_conditions1= " and d_created_date  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' and (account_expdate<'#{edate}' || account_expdate>'#{edate}') "

      block_conditions1= " and d_created_date  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' and account_expdate<'#{edate}'  "

      unblock_conditions1= " and d_created_date  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' and account_expdate>'#{edate}' "
    else



      total_conditions1= "and d_created_date  between '2008-07-15' and '#{Date.today} 23:59:59'"

      block_conditions1= "and d_created_date  between '2008-07-15' and '#{Date.today} 23:59:59'  and account_expdate<'#{Date.today} 23:59:59' "

      unblock_conditions1= "and d_created_date  between '2008-07-15' and '#{Date.today} 23:59:59'and account_expdate>'#{Date.today} 23:59:59' "



    end


    if(params[:account_type]!=nil && params[:account_type]!='')
      conditions2= " and hmm_users.account_type='#{params[:account_type]}' "
    end

    if(params[:studio_group]!=nil && params[:studio_group]!='')
      conditions3= " and hmm_studiogroups.id='#{params[:studio_group]}' "
    end

    if(params[:studios]!=nil && params[:studios]!='')
      conditions4= " and hmm_studios.id='#{params[:studios]}' "
    end

    if session[:manager]
      @managers=ManagerBranche.find(:all,:conditions=>"manager_id=#{session[:manager]}")
      @man_arr=[]
      @stud_group_arr=[]
      for manager in @managers
        @man_arr.push(manager.branch_id)
      end
      @man_arr=@man_arr.join(",")
      conditions5= " and hmm_studios.id in (#{@man_arr})"
      @stud=HmmStudio.find(:all,:conditions=> "id in (#{@man_arr})")
      for stud_group in @stud
        @stud_group_arr.push(stud_group.studio_groupid)
      end
      @stud_group_arr=@stud_group_arr.join(",")
    else
      conditions5=""
    end


    total_conditions="1=1 #{total_conditions1} #{conditions2} #{conditions3} #{conditions4} #{conditions5}"

    block_conditions="1=1 #{block_conditions1} #{conditions2} #{conditions3} #{conditions4} #{conditions5}"

    unblock_conditions="1=1 #{unblock_conditions1} #{conditions2} #{conditions3} #{conditions4} #{conditions5}"

    # @hmmuser_totalcnt = HmmUser.count(:all, :conditions => " #{conditions}")
    @hmmuser_totalcnt = HmmUser.count(:all, :select => "*", :joins =>" LEFT JOIN hmm_studios
ON hmm_users.studio_id=hmm_studios.id LEFT JOIN hmm_studiogroups
ON hmm_studios.studio_groupid=hmm_studiogroups.id", :conditions=>"#{total_conditions}" , :order => sort)
    #@hmmuser_blockcnt = HmmUser.count(:all, :conditions => " hmm_users.e_user_status='blocked' and #{conditions}")
    @hmmuser_blockcnt = HmmUser.count(:all, :select => "*",:joins =>" LEFT JOIN hmm_studios
ON hmm_users.studio_id=hmm_studios.id LEFT JOIN hmm_studiogroups
ON hmm_studios.studio_groupid=hmm_studiogroups.id", :conditions=>"  #{block_conditions}" , :order => sort)
    # @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => " hmm_users.e_user_status='unblocked' and #{conditions}")
    @hmmuser_unblockcnt = HmmUser.count(:all,:select => "*", :joins =>" LEFT JOIN hmm_studios
ON hmm_users.studio_id=hmm_studios.id LEFT JOIN hmm_studiogroups
ON hmm_studios.studio_groupid=hmm_studiogroups.id", :conditions=>"  #{unblock_conditions}" , :order => sort)
    session[:total_conditions]=total_conditions
    session[:block_conditions]=block_conditions
    session[:unblock_conditions]=unblock_conditions
    #render :layout => true
    if request.xml_http_request?
      render :partial => "accountrep", :layout => false
    end
  end


  def user_details
    sort_init 'id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "hmm_users.id desc"
      else

        sort = "hmm_users.id desc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end
    session[:user_sort_order]=sort


    if(params[:id]=="0")
      conditions=session[:total_conditions]
    elsif(params[:id]=="1")
      conditions=session[:unblock_conditions]
    elsif(params[:id]=="2")
      conditions=session[:block_conditions]
    end

    @hmm_users = HmmUser.paginate :select => "*",:per_page => 20, :page => params[:page], :joins =>" LEFT JOIN hmm_studios
ON hmm_users.studio_id=hmm_studios.id LEFT JOIN hmm_studiogroups
ON hmm_studios.studio_groupid=hmm_studiogroups.id", :conditions=>conditions , :order => sort
  end

  def user_details_excel
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="accountsreport.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end

    if(params[:id]=="0")
      conditions=session[:total_conditions]
    elsif(params[:id]=="1")
      conditions=session[:unblock_conditions]
    elsif(params[:id]=="2")
      conditions=session[:block_conditions]
    end
    @hmm_users = HmmUser.find(:all,:select => "*",:joins =>" LEFT JOIN hmm_studios
ON hmm_users.studio_id=hmm_studios.id LEFT JOIN hmm_studiogroups
ON hmm_studios.studio_groupid=hmm_studiogroups.id", :conditions=>conditions , :order => session[:user_sort_order])

    render :layout => false
  end

  #studio customers pending

  # def studio_pending_requests_admin
  #    sort_init 'id'
  #    sort_update
  #    srk=params[:sort_key]
  #    sort="#{srk}  #{params[:sort_order]}"
  #
  #    if( srk==nil)
  #      sort="cancellation_request_date desc"
  #    end
  #    @hmm_users = (HmmUser.paginate :per_page => 10, :page => params[:page], :conditions =>"cancel_status='pending' ", :order => sort )
  #  end



  def studio_pending_requests_admin
    sort_init 'id'
    sort_update

    store_id=session[:store_id]

    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and studio_id=#{store_id}")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and studio_id=#{store_id}")

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

      @srk="#{@sort_key}"+" "+"#{@order}"
    end



    #    @hmm_date=HmmUser.find(:first,:select=>"DATE_ADD(CURDATE(),INTERVAL 1 DAY) as dt",:conditions =>"cancel_status='pending' and studio_id=#{store_id}  #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} ")
    #    @hmm_curdate=HmmUser.find(:first,:select=>"CURDATE() as cdt",:conditions =>"cancel_status='pending' and studio_id=#{store_id}  #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} ")
    #    @hmm_time=HmmUser.find(:first,:select=>"date_format(cancellation_request_date,'%H:%i:%s') as tm",:conditions =>"cancel_status='pending' and studio_id=#{store_id}  #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} ")
    #
    #
    #
    logger.info("CCancellation DDate : #{session[:store_id]}")
    #    logger.info("CCancellation Time DDate : #{@hmm_time.tm}")

    #if(store_id=='170')
    if(store_id==170 || store_id=='170')
      @hmm_users = HmmUser.paginate  :conditions =>"cancel_status='pending' and  DATE_ADD(cancellation_request_date ,INTERVAL 2 DAY )  between  concat( date_format( curdate( ) , '%Y-%m-%d' ) , date_format( cancellation_request_date, ' %H:%i:%s' ) ) and concat(date_format(DATE_ADD(CURDATE(),INTERVAL 1 DAY),'%Y-%m-%d'), date_format(cancellation_request_date,' %H:%i:%s'))  #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} ", :per_page => 10, :order =>  @srk, :page => params[:page]
      #@hmm_users = HmmUser.paginate  :conditions =>"cancel_status='pending' #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} ", :per_page => 10, :order =>  @srk, :page => params[:page]
    else
      @hmm_users = HmmUser.paginate  :conditions =>"cancel_status='pending' and cancellation_request_date between concat( date_format( curdate( ) , '%Y-%m-%d' ) , date_format( cancellation_request_date, ' %H:%i:%s' ) ) and concat(date_format(DATE_ADD(CURDATE(),INTERVAL 1 DAY),'%Y-%m-%d'), date_format(cancellation_request_date,' %H:%i:%s')) and studio_id=#{store_id}  #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} ", :per_page => 10, :order =>  @srk, :page => params[:page]
    end
    render :layout => true
  end



  def studio_cancelled_list_admin
    sort_init 'id'
    sort_update

    store_id=session[:store_id]

    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and studio_id=#{store_id}")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and studio_id=#{store_id}")

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
      @srk="#{@sort_key}"+" "+"#{@order}"
    end


    @hmm_users = HmmUser.paginate :conditions =>"cancel_status='approved' and studio_id=#{store_id} #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}", :per_page => 10, :order =>  @srk, :page => params[:page]

    render :layout => true
  end

  #market managers cancel report
  def market_pending_requests_admin
    sort_init 'id'
    sort_update

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

    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and studio_id IN (#{@list_studios})")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and studio_id IN (#{@list_studios})")

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

      @srk="#{@sort_key}"+" "+"#{@order}"
    end





    @hmm_users = HmmUser.paginate  :conditions =>"cancel_status='pending' and studio_id IN (#{@list_studios})  and  cancellation_request_date between concat( date_format( curdate( ) , '%Y-%m-%d' ) , date_format( cancellation_request_date, ' %H:%i:%s' ) ) and concat(date_format(DATE_ADD(CURDATE(),INTERVAL 1 DAY),'%Y-%m-%d'), date_format(cancellation_request_date,' %H:%i:%s'))  #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}", :per_page => 10, :order =>  @srk, :page => params[:page]

    render :layout => true
  end



  def market_cancelled_list_admin
    sort_init 'id'
    sort_update

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

    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and studio_id IN (#{@list_studios})")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and studio_id IN (#{@list_studios})")

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
      @srk="#{@sort_key}"+" "+"#{@order}"
    end


    @hmm_users = HmmUser.paginate :conditions =>"cancel_status='approved' and studio_id IN (#{@list_studios}) #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}", :per_page => 10, :order =>  @srk, :page => params[:page]

    render :layout => true
  end


  def cancel_request_scheduler_func
    require "ArbApiLib"
    aReq = ArbApi.new
    curr_date=Date.today
    prev_date=Date.today-3
    @datas=CancellationRequest.find(:all,:conditions=>"cancellation_date < '#{curr_date}'  and cancellation_status='pending'")
    for data in @datas
      hmm_user = HmmUser.find(data.uid)
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
        logger.info(@res)
      }
      hmm_user = HmmUser.find(data.uid)
      uuid =  HmmUser.find_by_sql(" select UUID() as u")
      unnid = uuid[0]['u']
      hmm_user.cancel_status = 'approved'
      if(hmm_user.family_name=='' or hmm_user.family_name==nil)
        hmm_user.family_name="#{data.uid}#{unnid}un#{data.uid}"
      end
      hmm_user.account_expdate = curr_date
      hmm_user.canceled_by = "0"
      hmm_user.save
      @cancel_req=CancellationRequest.find(data.id)
      @cancel_req['cancellation_status']='approved'
      @cancel_req.save
    end
    render :layout => false
  end


  def membership_sold_accounts_admin

    @dropdatas=HmmUser.find(:all,:select=>"count(*) as cnt , membership_sold_by",:conditions=>"membership_sold_by is not null and membership_sold_by!=''",:group=>"membership_sold_by")


    if (params[:from_bdate]!=nil && params[:to_bdate] !=nil)

      #from_yr=params[:from_bdate]['start_year1910ordermonthdayyear(1i)']
      #from_mon=params[:from_bdate]['start_year1910ordermonthdayyear(2i)']
      #from_date=params[:from_bdate]['start_year1910ordermonthdayyear(3i)']

      #      from_yr=params[:fyy]
      #      from_mon=params[:fmm]
      #      from_date=params[:fdd]

      from_yr=params[:from_bdate]['ordermonthdayyear(1i)']
      from_mon=params[:from_bdate]['ordermonthdayyear(2i)']
      from_date=params[:from_bdate]['ordermonthdayyear(3i)']


      fromdate="#{from_yr}-#{from_mon}-#{from_date}"

      #to_yr=params[:to_bdate]['start_year1910ordermonthdayyear(1i)']
      #to_mon=params[:to_bdate]['start_year1910ordermonthdayyear(2i)']
      #to_date=params[:to_bdate]['start_year1910ordermonthdayyear(3i)']

      #      to_yr=params[:tyy]
      #      to_mon=params[:tmm]
      #      to_date=params[:tdd]

      to_yr=params[:to_bdate]['ordermonthdayyear(1i)']
      to_mon=params[:to_bdate]['ordermonthdayyear(2i)']
      to_date=params[:to_bdate]['ordermonthdayyear(3i)']



      todate="#{to_yr}-#{to_mon}-#{to_date}"

      cond2=" and d_created_date  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "

    else

      cond2=" and 1=1 "

    end




    if(params[:studios]!=nil && params[:studios]!='')
      cond=" and membership_sold_by='#{params[:studios]}'"
    else
      cond=" and 1=1"
    end

    @datas=HmmUser.find(:all,:select=>"count(*) as cnt , membership_sold_by",:conditions=>"membership_sold_by is not null and membership_sold_by!='' #{cond} #{cond2}",:group=>"membership_sold_by")

    if request.xml_http_request?
      render :partial => "salesperson_report", :layout => false
    end

  end

  def membership_sold_accounts_studio


    @dropdatas=HmmUser.find(:all,:select=>"count(*) as cnt , membership_sold_by",:conditions=>"membership_sold_by is not null and membership_sold_by!='' and studio_id=#{session[:store_id]}",:group=>"membership_sold_by")


    if (params[:from_bdate]!=nil && params[:to_bdate] !=nil)

      #from_yr=params[:from_bdate]['start_year1910ordermonthdayyear(1i)']
      #from_mon=params[:from_bdate]['start_year1910ordermonthdayyear(2i)']
      #from_date=params[:from_bdate]['start_year1910ordermonthdayyear(3i)']

      #      from_yr=params[:fyy]
      #      from_mon=params[:fmm]
      #      from_date=params[:fdd]

      from_yr=params[:from_bdate]['ordermonthdayyear(1i)']
      from_mon=params[:from_bdate]['ordermonthdayyear(2i)']
      from_date=params[:from_bdate]['ordermonthdayyear(3i)']


      fromdate="#{from_yr}-#{from_mon}-#{from_date}"

      #to_yr=params[:to_bdate]['start_year1910ordermonthdayyear(1i)']
      #to_mon=params[:to_bdate]['start_year1910ordermonthdayyear(2i)']
      #to_date=params[:to_bdate]['start_year1910ordermonthdayyear(3i)']

      #      to_yr=params[:tyy]
      #      to_mon=params[:tmm]
      #      to_date=params[:tdd]

      to_yr=params[:to_bdate]['ordermonthdayyear(1i)']
      to_mon=params[:to_bdate]['ordermonthdayyear(2i)']
      to_date=params[:to_bdate]['ordermonthdayyear(3i)']



      todate="#{to_yr}-#{to_mon}-#{to_date}"

      cond2=" and d_created_date  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "

    else

      cond2=" and 1=1 "

    end


    if(params[:studios]!=nil && params[:studios]!='')
      cond=" and membership_sold_by='#{params[:studios]}'"
    else
      cond=" and 1=1"
    end

    @datas=HmmUser.find(:all,:select=>"count(*) as cnt , membership_sold_by",:conditions=>"membership_sold_by is not null and membership_sold_by!='' and studio_id=#{session[:store_id]} #{cond} #{cond2}",:group=>"membership_sold_by")

    if request.xml_http_request?
      render :partial => "salesperson_report", :layout => false
    end

  end


  #resend contest emails from
  def resend_contest_emails

    @votes = ContestVotes.find(:all,:conditions=>"vote_date between '2010-06-26' and '2010-06-27'")

    if(@votes.length>0)
      for vote in @votes

        email=vote.email_id
        contetsid=vote.contest_id
        unid=vote.unid

        @contest = Contest.find(vote.contest_id)
        @uid = @contest.uid

        contetsfname = @contest.first_name
        moment_type = @contest.moment_type

        #working for thumb nail for e-mail
        momentid = @contest.moment_id
        @moment = UserContent.find(:first, :conditions => "id='#{momentid}'")
        moment_filename = @moment.v_filename

        #working for fname and lastname of cntestant
        @username = HmmUser.find(:first, :conditions => "id='#{@uid}'")
        user_fname = @username.v_fname
        user_lname = @username.v_lname

        Postoffice.deliver_voteconform(email,contetsid, unid,moment_filename,contetsfname,user_fname,user_lname,moment_type)

      end
    end

  end

  #resend subscription emails
  def resend_subscription_emails

    @hmm_user_dets=HmmUser.find(:all,:conditions=>"d_created_date between '2010-06-26 00:00:10' and '2010-06-27 13:30:00'")

    if(@hmm_user_dets.length>0)
      for hmm_user_det in @hmm_user_dets
        pw=HmmUser.find(:all, :select => "v_password as pword,password_required as preq, familywebsite_password as fpword ", :conditions => "id=#{hmm_user_det.id}")

        link = "/#{hmm_user_det.family_name}"
        pass_req = pw[0].preq
        pass = pw[0].pword
        passwd=pw[0].pword
        Postoffice.deliver_paymentsucess("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, hmm_user_det.account_type, hmm_user_det.account_expdate,hmm_user_det.months,hmm_user_det.amount,hmm_user_det.street_address, hmm_user_det.city, hmm_user_det.state ,hmm_user_det.postcode, hmm_user_det.country,hmm_user_det.telephone,hmm_user_det.invoicenumber,hmm_user_det.subscriptionnumber, hmm_user_det.v_user_name, passwd,link,pass_req,pass)

      end
    end

  end

  def premium_subscriptions
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
    @subscriptions =HmmStudio.paginate :per_page => 10,:order=>sort,:select => "id,studio_name", :page => params[:page],:conditions=>"studio_groupid=1 and status='active'" , :group => 'studio_name'
    if(params[:sub])
      #@sel=Gallery.find_by_sql(" SELECT * FROM `galleries` where d_gallery_date=d_created_date LIMIT 0 , 1 ")
      @datediff=HmmUser.find_by_sql("SELECT TO_DAYS('#{params[:to_year]}-#{params[:to_month]}-#{params[:to_day]}') - TO_DAYS('#{params[:from_year]}-#{params[:from_month]}-#{params[:from_day]}') as days")
      if(@datediff[0].days.to_i < 183)
        @date_period = "d_created_date between '#{params[:from_year]}-#{params[:from_month]}-#{params[:from_day]}' and '#{params[:to_year]}-#{params[:to_month]}-#{params[:to_day]} 23:59:59'"
        session[:fgyear]=params[:from_year]
        session[:fmon]=params[:from_month]
        session[:fday]=params[:from_day]
        session[:tyear]=params[:to_year]
        session[:tmon]=params[:to_month]
        session[:tday]=params[:to_day]
        session[:dateperd]= @date_period
      else
        params[:from_year]="#{Time.now.strftime("%Y")}"
        params[:to_year]="#{Time.now.strftime("%Y")}"
        params[:from_month]="#{Time.now.strftime("%m")}"
        params[:to_month]="#{Time.now.strftime("%m")}"
        params[:from_day]="#{Time.now.strftime("%d")}"
        params[:to_day]="#{Time.now.strftime("%d")}"
        @date_period = "d_created_date between '#{Time.now.strftime("%Y-%m-%d")}' and '#{Time.now.strftime("%Y-%m-%d")} 23:59:59'"
        session[:dateperd]= @date_period
        flash[:notice]="Sorry Results can be displayed only for dates  difference of less than 183 days."
      end
    else
      params[:from_year]="#{Time.now.strftime("%Y")}"
      params[:to_year]="#{Time.now.strftime("%Y")}"
      params[:from_month]="#{Time.now.strftime("%m")}"
      params[:to_month]="#{Time.now.strftime("%m")}"
      params[:from_day]="#{Time.now.strftime("%d")}"
      params[:to_day]="#{Time.now.strftime("%d")}"
      @date_period = "d_created_date between '#{Time.now.strftime("%Y-%m-%d")}' and '#{Time.now.strftime("%Y-%m-%d")} 23:59:59'"
    end
    if(session[:fgyear] != nil)
      params[:from_year]= session[:fgyear]
      params[:from_month]=  session[:fmon]
      params[:from_day]=  session[:fday]
      params[:to_year]= session[:tyear]
      params[:to_month]= session[:tmon]
      params[:to_day]= session[:tday]
    end

    if(session[:dateperd] ==nil )
      @date_period=@date_period
    else
      @date_period=session[:dateperd]
    end
  end

  def premium_subscriptions_info
    date_period = params[:dateperiod]
    studio_id = params[:studio_id]
    @subinfos = HmmUser.paginate :per_page => 20,:select => "hmm_users.v_fname,hmm_users.v_lname,hmm_users.e_sex,hmm_users.e_sex,hmm_users.v_user_name,hmm_users.v_e_mail,hmm_users.v_fname,hmm_users.e_user_status,hmm_users.months", :page => params[:page],:joins =>" LEFT JOIN hmm_studios
ON hmm_users.studio_id=hmm_studios.id",:conditions=>"hmm_studios.studio_groupid=1  and  hmm_studios.id=#{studio_id} and account_type='platinum_user' and  #{date_period}"
  end

  def calculate_data(dateperiod,studio_id,type)
    @total_premimum=0
    @total_family=0
    @total_free=0
    @image_premimum=0
    @image_family=0
    @image_free=0
    family=Array.new
    free=Array.new
    premimum=Array.new

    total_galleries= Galleries.find(:all,:select=>"a.id,c.account_type",:joins=>"as a,sub_chapters as b,hmm_users as c",:conditions =>"a.d_gallery_date between  '#{dateperiod}' and a.subchapter_id=b.id and b.store_id='#{studio_id}' and a.e_gallery_type='#{type}' and b.uid=c.id",:group=>"c.id")
    total_galleries1= Galleries.find(:all,:select=>"a.id,c.account_type,c.id as userid",:joins=>"as a,sub_chapters as b,hmm_users as c,user_contents as d",:conditions =>"a.d_gallery_date between  '#{dateperiod}' and a.subchapter_id=b.id and b.store_id='#{studio_id}' and a.e_gallery_type='#{type}' and b.uid=c.id and a.id=d.gallery_id",:group=>"a.id")

    for total_gallery in total_galleries
      if total_gallery.account_type=="platinum_user"
        @total_premimum =@total_premimum + 1
      elsif total_gallery.account_type=="familyws_user"
        @total_family=@total_family+1
      elsif  total_gallery.account_type=="free_user"
        @total_free=@total_free+1
      end
    end

    for total_gallery1 in total_galleries1
      if total_gallery1.account_type=="platinum_user"
        premimum.push(total_gallery1.userid)
        premimum=premimum.uniq
        @image_premimum =premimum.length
      elsif total_gallery1.account_type=="familyws_user"
        family.push(total_gallery1.userid)
        family=family.uniq
        @image_family=family.length
      elsif  total_gallery1.account_type=="free_user"
        free.push(total_gallery1.userid)
        free=free.uniq
        @image_free=free.length
      end
    end
  end



  def user_session_info
    account_type = params[:account_type]
    date_period = params[:dateperiod]
    studio_id = params[:studio_id]
    type= params[:type]
    if params[:repeat]=="no"
      galleries= Galleries.find(:all,:select=>"b.uid as uid",:joins=>"as a,sub_chapters as b",:conditions =>"a.d_gallery_date between  '#{date_period}' and a.subchapter_id=b.id and b.store_id='#{studio_id}' and a.e_gallery_type='#{type}'")
      hmmuser=Array.new
      for gallery in galleries
        hmmuser.push(gallery.uid)
      end
      hmmuser=hmmuser.uniq
      hmmuser=hmmuser.join(",")
      if hmmuser.length > 0
        @hmm_users=HmmUser.paginate :page=>params[:page],:per_page=>"20",:conditions=>"id in(#{hmmuser}) and account_type='#{account_type}'"
      else
        @hmm_users = ''
      end
    else
      galleries= Galleries.find(:all,:select=>"a.id,c.uid as userid",:joins=>"as a,sub_chapters as b,user_contents as c",:conditions =>"a.d_gallery_date between  '#{date_period}' and a.subchapter_id=b.id and b.store_id='#{studio_id}' and a.e_gallery_type='#{type}' and a.id=c.gallery_id",:group=>"a.id")
      hmmuser=Array.new
      for gallery in galleries
        hmmuser.push(gallery.userid)
      end
      hmmuser=hmmuser.uniq
      hmmuser=hmmuser.join(",")
      if hmmuser.length > 0
        @hmm_users=HmmUser.paginate :page=>params[:page],:per_page=>"20",:conditions=>"id in(#{hmmuser}) and account_type='#{account_type}'"
      else
        @hmm_users = ''
      end
    end
  end

  def studio_account_setup_report_service
    type=params[:type]
    if !params[:emp_username].nil? && !params[:emp_username].blank?
      user = EmployeAccount.find(:first,:conditions=>"employe_username='#{params[:emp_username]}' and status='unblock'")
      if !user.nil?
        store_id=user.store_id
        hmm_studios = HmmStudio.find(:first,:conditions=>"id=#{store_id} and status='active'")
        if !params[:from_date].nil? && !params[:from_date].blank? && !params[:to_date].nil? && !params[:to_date].blank?
          @datediff=HmmUser.find_by_sql("SELECT TO_DAYS('#{params[:to_date]}') - TO_DAYS('#{params[:from_date]}') as days")
          if(@datediff[0].days.to_i < 7)
            @date_period = "#{params[:from_date]}' and '#{params[:to_date]} 23:59:59"
            calculate_data(@date_period,store_id,type)
            msg={:msg=>"Success."}
          else
            @date_period = "#{Time.now.strftime("%Y-%m-%d").to_date-7.days}' and '#{Time.now.strftime("%Y-%m-%d")} 23:59:59"
            calculate_data(@date_period,store_id,type)
            msg={:msg=>"Sorry Results can be displayed only for dates  difference of less than 7 days."}
          end
        else
          @date_period = "#{Time.now.strftime("%Y-%m-%d").to_date-7.days}' and '#{Time.now.strftime("%Y-%m-%d")} 23:59:59"
          calculate_data(@date_period,store_id,type)
          msg={:msg=>"Date parameter Missing."}
        end
        studio_info={:studio_branch=>hmm_studios.studio_branch,:studio_address=>hmm_studios.studio_address}
        premium_info={:total=>@total_premimum,:uploaded=>@image_premimum}
        family_info={:total=>@total_family,:uploaded=>@image_family}
        free_info={:total=>@total_free ,:uploaded=>@image_free}
        body={:studio_info=>studio_info,:premium_info=>premium_info,:family_info=>family_info,:free_info=>free_info}
        all_info={:body=>body,:msg=>msg}

      else
        all_info={:body=>"",:msg=>"Employee Does Not Exist"}
      end
    else
      all_info={:body=>"",:msg=>"Parameter Missing"}
    end
    render :text=>all_info.to_json
  end


  def user_session_upload_info
    account_type = params[:account_type]
    date_period = "#{params[:from_date]}' and '#{params[:to_date]} 23:59:59"
    type= params[:type]
    if !params[:emp_username].nil? && !params[:emp_username].blank?
      user = EmployeAccount.find(:first,:conditions=>"employe_username='#{params[:emp_username]}' and status='unblock'")
      studio_id = user.store_id
      hmm_studios = HmmStudio.find(:first,:conditions=>"id=#{studio_id} and status='active'")
      if !user.nil?
        galleries= Galleries.find(:all,:select=>"sub_chapters.uid as uid",:joins=>"INNER JOIN sub_chapters ON sub_chapters.id = galleries.subchapter_id",:conditions =>"galleries.d_gallery_date between  '#{date_period}' and galleries.subchapter_id=sub_chapters.id and sub_chapters.store_id='#{studio_id}' and galleries.e_gallery_type='#{type}'")
        hmmuser=Array.new
        for gallery in galleries
          hmmuser.push(gallery.uid)
        end
        hmmuser=hmmuser.uniq
        hmmuser=hmmuser.join(",")
        hmm_users_free_empty=HmmUser.find(:all,:conditions=>"id in(#{hmmuser}) and account_type='free_user'")
        hmm_users_family_empty=HmmUser.find(:all,:conditions=>"id in(#{hmmuser}) and account_type='familyws_user'")
        hmm_users_premium_empty=HmmUser.find(:all,:conditions=>"id in(#{hmmuser}) and account_type='platinum_user'")
        galleries= Galleries.find(:all,:select=>"a.id,c.uid as userid",:joins=>"as a,sub_chapters as b,user_contents as c",:conditions =>"a.d_gallery_date between  '#{date_period}' and a.subchapter_id=b.id and b.store_id='#{studio_id}' and a.e_gallery_type='#{type}' and a.id=c.gallery_id",:group=>"a.id")

        free_empty=self.return_hash(hmm_users_free_empty)
        family_empty=self.return_hash(hmm_users_family_empty)
        premium_empty=self.return_hash(hmm_users_premium_empty)


        hmmuser=Array.new
        for gallery in galleries
          hmmuser.push(gallery.userid)
        end
        hmmuser=hmmuser.uniq
        hmmuser=hmmuser.join(",")
        hmm_users_free_not_empty=HmmUser.find(:all,:conditions=>"id in(#{hmmuser}) and account_type='free_user'")
        hmm_users_family_not_empty=HmmUser.find(:all,:conditions=>"id in(#{hmmuser}) and account_type='familyws_user'")
        hmm_users_premium_not_empty=HmmUser.find(:all,:conditions=>"id in(#{hmmuser}) and account_type='platinum_user'")

        free_not_empty=self.return_hash(hmm_users_free_not_empty)
        family_not_empty=self.return_hash(hmm_users_family_not_empty)
        premium_not_empty=self.return_hash(hmm_users_premium_not_empty)


        studio_info={:studio_branch=>hmm_studios.studio_branch,:studio_address=>hmm_studios.studio_address}
        premium_info={:total_galleries=>premium_empty,:uploaded_galleries=>premium_not_empty,:total_galleries_count=>premium_empty.length,:uploaded_galleries_count=>premium_not_empty.length}
        family_info={:total_galleries=>family_empty,:uploaded_galleries=>family_not_empty,:total_galleries_count=>family_empty.length,:uploaded_galleries_count=>family_not_empty.length}
        free_info={:total_galleries=>free_empty ,:uploaded_galleries=>free_not_empty,:total_galleries_count=>free_empty.length,:uploaded_galleries_count=>free_not_empty.length}
        body={:studio_info=>studio_info,:premium_customers_info=>premium_info,:familywebsite_customers_info=>family_info,:free_users_info=>free_info}
        msg="Success."
        all_info={:body=>body,:msg=>msg}
      else
      end
    else
    end
    render :text=>all_info.to_json
  end

  def return_hash(user_infos)
    user_data=[]
    for user_info in user_infos
      if user_info.account_expdate!=nil && user_info.account_expdate!=""
        if user_info.account_expdate.to_date>Date.today
          status="Active"
        else
          status="Inactive"
        end
      else
        status="Inactive"
      end
      if(user_info.account_type=='platinum_user')
        val="Premium User"
      elsif(user_info.account_type=='familyws_user')
        val="Family Website User"
      else
        val="Free User"
      end
      user={:first_name=>user_info.v_fname,:last_name=>user_info.v_lname,:user_name=>user_info.v_user_name,:email_address=>user_info.v_e_mail,:status=>status,:subscriptio_month=>user_info.months,:created_date=>user_info.d_created_date,:account_type=>val}
      user_data.push(user)
    end
    return user_data
  end

  def upgraded_customers_report
    sort_init 'id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "hmm_users.id desc"
      else

        sort = "hmm_users.id desc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end

    if (params[:from_bdate]!=nil && params[:to_bdate] !=nil&& params[:to_bdate] !="" && params[:to_bdate] !="")

      @fromdate=params[:from_bdate]
      @f_month=@fromdate.slice(0..1)
      @f_date=@fromdate.slice(3..4)
      @f_year=@fromdate.slice(6..9)
      @fromdate="#{@f_year}-#{@f_month}-#{@f_date}"



      @todate=params[:to_bdate]

      @t_month=@todate.slice(0..1)
      @t_date=@todate.slice(3..4)
      @t_year=@todate.slice(6..9)
      @todate="#{@t_year}-#{@t_month}-#{@t_date}"
      cond="and upgraded_accounts.created_at between '#{@fromdate}' and  '#{@todate}'"
    else
      cond="and upgraded_accounts.created_at between '2008-07-15' and '#{Date.today} 23:59:59'"
    end


    if(params[:account_type]!=nil && params[:account_type]!='')
      conditions2= " and hmm_users.account_type='#{params[:account_type]}' "
    end

    if(params[:studio_group]!=nil && params[:studio_group]!='')
      conditions3= " and hmm_studiogroups.id='#{params[:studio_group]}' "
    end

    if(params[:studios]!=nil && params[:studios]!='')
      conditions4= " and hmm_studios.id='#{params[:studios]}' "
    end

    if session[:manager]
      @managers=ManagerBranche.find(:all,:conditions=>"manager_id=#{session[:manager]}")
      @man_arr=[]
      @stud_group_arr=[]
      for manager in @managers
        @man_arr.push(manager.branch_id)
      end
      @man_arr=@man_arr.join(",")
      conditions5= " and hmm_studios.id in (#{@man_arr})"
      @stud=HmmStudio.find(:all,:conditions=> "id in (#{@man_arr})")
      for stud_group in @stud
        @stud_group_arr.push(stud_group.studio_groupid)
      end
      @stud_group_arr=@stud_group_arr.join(",")
    else
      conditions5=""
    end


    total_conditions="1=1 #{cond} #{conditions2} #{conditions3} #{conditions4} #{conditions5}"

    @hmm_users_count = HmmUser.count(:joins =>"LEFT JOIN upgraded_accounts
ON upgraded_accounts.user_id=hmm_users.id LEFT JOIN hmm_studios
ON hmm_users.studio_id=hmm_studios.id LEFT JOIN hmm_studiogroups
ON hmm_studios.studio_groupid=hmm_studiogroups.id", :conditions=>"#{total_conditions}" , :order => sort)
    
    @hmm_users = HmmUser.paginate(:page=>params[:page],:per_page=>30,:select => "hmm_users.id,hmm_users.v_fname,hmm_users.v_lname,hmm_users.v_user_name,hmm_users.v_e_mail,hmm_users.d_created_date,hmm_users.account_type,hmm_studios.studio_name,hmm_studiogroups.hmm_franchise_studio,upgraded_accounts.created_at", :joins =>"LEFT JOIN upgraded_accounts
ON upgraded_accounts.user_id=hmm_users.id LEFT JOIN hmm_studios
ON hmm_users.studio_id=hmm_studios.id LEFT JOIN hmm_studiogroups
ON hmm_studios.studio_groupid=hmm_studiogroups.id", :conditions=>"#{total_conditions}" , :order => sort)

    session[:upgrade_conditions]=total_conditions
    session[:upgrade_conditions_order]=sort
  end

  def excel_upgrade_accounts
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="Upgrade Account Report.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end
    @hmm_users = HmmUser.find(:all,:select => "hmm_users.id,hmm_users.v_fname,hmm_users.v_lname,hmm_users.v_user_name,hmm_users.v_e_mail,hmm_users.d_created_date,hmm_users.account_type,hmm_studios.studio_name,hmm_studiogroups.hmm_franchise_studio,upgraded_accounts.created_at", :joins =>"LEFT JOIN upgraded_accounts
ON upgraded_accounts.user_id=hmm_users.id LEFT JOIN hmm_studios
ON hmm_users.studio_id=hmm_studios.id LEFT JOIN hmm_studiogroups
ON hmm_studios.studio_groupid=hmm_studiogroups.id", :conditions=>"#{session[:upgrade_conditions]}" , :order => session[:upgrade_conditions_order])
    render :layout=>false
  end


end