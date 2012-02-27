class FamilywebsiteThemesController < ApplicationController
  layout "admin"
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @familywebsite_theme = FamilywebsiteTheme.paginate :per_page => 10, :page => params[:page]
  end

  def show
    @familywebsite_theme = FamilywebsiteTheme.find(params[:id])
  end

  def new
    @familywebsite_theme = FamilywebsiteTheme.new
  end

  def create
    @familywebsite_theme = FamilywebsiteTheme.new(params[:familywebsite_theme])
    @familywebsite_theme['theme_added_date']=Time.now
    if @familywebsite_theme.save
      flash[:notice] = 'FamilywebsiteTheme was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @familywebsite_theme = FamilywebsiteTheme.find(params[:id])
  end

  def update
    @familywebsite_theme = FamilywebsiteTheme.find(params[:id])
    if @familywebsite_theme.update_attributes(params[:familywebsite_theme])
      flash[:notice] = 'FamilywebsiteTheme was successfully updated.'
      redirect_to :action => 'show', :id => @familywebsite_theme
    else
      render :action => 'edit'
    end
  end

  def destroy
    FamilywebsiteTheme.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
