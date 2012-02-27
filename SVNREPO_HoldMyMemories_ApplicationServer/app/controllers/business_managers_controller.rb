class BusinessManagersController < ApplicationController
  layout "admin"
  helper :sort
  include SortHelper
  require 'will_paginate'
   ssl_required :all

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  protected
  def ssl_required?
    true
  end


  def list
    @business_manager_pages, @business_managers = paginate :business_managers, :per_page => 10
  end

  def show
    @business_manager = BusinessManager.find(params[:id])
  end

  def show_personalinfo
    @photographer_detail = PhotographerPersonalDetail.find(params[:id])
  end

  def new
    @business_manager = BusinessManager.new
  end

  def create
    @business_manager = BusinessManager.new(params[:business_manager])
    @business_manager['modified_at'] = Time.now
    if @business_manager.save
      $notice_businessmanager
      flash[:notice_businessmanager] = 'BusinessManager was successfully created.'
      redirect_to :controller => 'account', :action => 'index1'
    else
      render :action => 'new'
    end
  end

  def edit
    @business_manager = BusinessManager.find(params[:id])
  end

  def update
    @business_manager = BusinessManager.find(params[:id])
    if @business_manager.update_attributes(params[:business_manager])
      flash[:notice] = 'BusinessManager was successfully updated.'
      redirect_to :action => 'show', :id => @business_manager
    else
      render :action => 'edit'
    end
  end

  def destroy
    BusinessManager.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def validate
    color = 'red'
   username = params[:username]

      user = BusinessManager.find_all_by_business_manager_username(username)
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

  def photographer_list
    @photographer = (PhotographerDetail.paginate :page=>params[:page], :per_page => 10, :order => "id desc" )
  end

  def photographer_personal_list
    @photographerdetails = (PhotographerPersonalDetail.paginate :page=>params[:page], :per_page => 10, :order => "id desc" )
    #@photographer = PhotographerDetail.find(:all)
  end

  def photographer_log_list
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
    @photographerlog = (PhotographerLog.paginate :page=>params[:page], :per_page => 10, :order => sort )
  end

  def delete_photographer
    if(params[:id])
        PhotographerDetail.find(params[:id]).destroy
        flash[:notice] = 'Photographer Details Deleted Successfully.'
		redirect_to :controller => "business_managers", :action => 'photographer_list'
    end
  end

  def delete_photographer_personal
   if(params[:id])
        PhotographerPersonalDetail.find(params[:id]).destroy
        flash[:notice] = 'Photographer Personal Details Deleted Successfully.'
		redirect_to :controller => "business_managers", :action => 'photographer_personal_list'
    end
  end



  def dispatch_accountinfo
    @photographer_info = PhotographerDetail.find(params[:id])
    @exp_date_cal =  PhotographerDetail.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL 14 DAY) as m")
     @cur_date_cal =  PhotographerDetail.find_by_sql(" select CURDATE() as c")
     account_curdate= @cur_date_cal[0]['c']
     account_expdate= @exp_date_cal[0]['m']
     @photographer_info['account_expire_date'] = account_expdate
     @photographer_info['date_sent'] = account_curdate
     @photographer_info['account_status'] = 'accepted'
    if @photographer_info.save
      Postoffice.deliver_photographer_accountinfo(@photographer_info.id,@photographer_info.name,@photographer_info.email,@photographer_info.username,@photographer_info.password,@photographer_info.account_expire_date)
      $notice_update
      flash[:notice_update] = 'Account info was succefully dispatched.'
      redirect_to :action => 'photographer_list'
    else
      $notice_update_fail
      flash[:notice_update_fail] = 'Account info dispatched failed'
      render :action => 'photographer_list'
    end
  end

  protected
  def ssl_required?
    true
  end
end