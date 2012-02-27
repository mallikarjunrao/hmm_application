class FamilywebsiteSharesController < ApplicationController
  
  layout "admin"
#  helper :sort
#  include SortHelper
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
  
  before_filter :authenticate_admin, :only => [ :list, :new, :edit, :preview]

  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "https://www.holdmymemories.com/account/login"
    return false
    end
  end

  def list
    @familywebsite_shares = FamilywebsiteShare.paginate  :per_page => 10, :page => params[:page],:group => 'share_message',:order=>'id desc'
    @fw_share_count = FamilywebsiteShare.count
  end

  def show
    @familywebsite_share = FamilywebsiteShare.find(params[:id])
  end

  def new
    @familywebsite_share = FamilywebsiteShare.new
  end

  def create
    @familywebsite_share = FamilywebsiteShare.new(params[:familywebsite_share])
    if @familywebsite_share.save
      flash[:notice] = 'FamilywebsiteShare was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @familywebsite_share = FamilywebsiteShare.find(params[:id])
  end

  def update
    @familywebsite_share = FamilywebsiteShare.find(params[:id])
    if @familywebsite_share.update_attributes(params[:familywebsite_share])
      flash[:notice] = 'FamilywebsiteShare was successfully updated.'
      redirect_to :action => 'show', :id => @familywebsite_share
    else
      render :action => 'edit'
    end
  end

  def destroy
    FamilywebsiteShare.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
