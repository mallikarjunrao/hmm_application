class TipsController < ApplicationController
   layout "admin"
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
  
  
  before_filter :authenticate_admin, :only => [ :new, :edit, :show, :list]

  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "https://www.holdmymemories.com/account/login"
    return false
    end
  end
  
  def list
    @tips = Tip.paginate :per_page => 10, :page => params[:page]
  end

  def show
    @tip = Tip.find(params[:id])
  end

  def new
    @tip = Tip.new
  end

  def create
    @tip = Tip.new(params[:tip])
    if @tip.save
      flash[:notice] = 'Tip was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @tip = Tip.find(params[:id])
  end

  def update
    @tip = Tip.find(params[:id])
    if @tip.update_attributes(params[:tip])
      flash[:notice] = 'Tip was successfully updated.'
      redirect_to :action => 'show', :id => @tip
    else
      render :action => 'edit'
    end
  end

  def destroy
    Tip.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
