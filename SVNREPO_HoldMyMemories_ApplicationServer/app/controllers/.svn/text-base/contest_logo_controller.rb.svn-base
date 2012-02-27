class ContestLogoController < ApplicationController

  layout "admin"
  helper :sort
  include SortHelper
  require 'will_paginate'

  before_filter :authenticate_admin, :only => [:new,:list]

  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to :action => '/account/login'
      return false
    end
  end

  
  def new
    #@contest_detail = ContestDetail.find(params[:id])
  end

  def list
    @contest_logo_details = ContestLogoDetail.paginate :page => params[:page], :per_page => 10,:order=>"created_at desc"
  end

  def edit
    @contest_logo_detail = ContestLogoDetail.find(params[:id])
  end
  
end
