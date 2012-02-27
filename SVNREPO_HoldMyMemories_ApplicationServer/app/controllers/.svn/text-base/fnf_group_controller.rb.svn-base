class FnfGroupController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @fnf_groups_pages, @fnf_groups = paginate :fnf_groups, :per_page => 10
  end

  def show
    @fnf_groups = FnfGroups.find(params[:id])
  end

  def new
    @fnf_groups = FnfGroups.new
  end

  def create
    @fnf_groups = FnfGroups.new(params[:fnf_groups])
    if @fnf_groups.save
      flash[:notice] = 'FnfGroups was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @fnf_groups = FnfGroups.find(params[:id])
    render :layout => false
  end

  def update
    @fnf_groups = FnfGroups.find(params[:id])
    if @fnf_groups.update_attributes(params[:fnf_groups])
      flash[:notice_accept] = 'FnfGroups was successfully updated.'
      redirect_to :controller =>'customers',:action => 'FnF_Request'
    else
      render :action => 'edit'
    end
  end

  def destroying
    @fnf_groups = FnfGroups.find(:all, :conditions =>"uid=#{logged_in_hmm_user.id} and fnf_category='Friends'")
    changeidto=@fnf_groups[0]['id']
    FnfGroups.find(params[:id]).destroy
    @fnf_friend_replace = FamilyFriend.find(:all, :conditions => "uid=#{logged_in_hmm_user.id} and fnf_category='#{params[:id]}'")
    
    for @relace in @fnf_friend_replace
      params[:id]=@relace.id
      frn_edit=FamilyFriend.find(params[:id])
      frn_edit['fnf_category']=changeidto
      frn_edit.save
    end
    
    flash[:notice_accept] = 'Successfully deleted the group and you may find your friends list in the "Friends" group.'
    redirect_to :controller => 'customers', :action => 'FnF_Request'
  end 
  
  def done
    redirect_to :controller => 'customers', :action => 'FnF_Request', :remove => 'yes'
  end
  
  def facebook_start
    
  end  
  
  
end
