class FamilywebsiteVisitsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @familywebsite_visit_pages, @familywebsite_visits = paginate :familywebsite_visits, :per_page => 10
  end

  def show
    @familywebsite_visit = FamilywebsiteVisit.find(params[:id])
  end

  def new
    @familywebsite_visit = FamilywebsiteVisit.new
  end

  def create
    @familywebsite_visit = FamilywebsiteVisit.new(params[:familywebsite_visit])
    if @familywebsite_visit.save
      flash[:notice] = 'FamilywebsiteVisit was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @familywebsite_visit = FamilywebsiteVisit.find(params[:id])
  end

  def update
    @familywebsite_visit = FamilywebsiteVisit.find(params[:id])
    if @familywebsite_visit.update_attributes(params[:familywebsite_visit])
      flash[:notice] = 'FamilywebsiteVisit was successfully updated.'
      redirect_to :action => 'show', :id => @familywebsite_visit
    else
      render :action => 'edit'
    end
  end

  def destroy
    FamilywebsiteVisit.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
