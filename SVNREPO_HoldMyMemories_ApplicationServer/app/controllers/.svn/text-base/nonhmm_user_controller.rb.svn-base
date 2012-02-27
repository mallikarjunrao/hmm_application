class NonhmmUserController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  #verify :method => :post, :only => [ :destroy, :create, :update ],
        # :redirect_to => { :action => :list }

  def list
    @nonhmm_user_pages, @nonhmm_users = paginate :nonhmm_users, :per_page => 10
  end

  def show
    @nonhmm_user = NonhmmUser.find(params[:id])
  end

  def new
    @nonhmm_user = NonhmmUser.new
    render :layout => false
  end

  def create
    @nonhmm_user = NonhmmUser.new(params[:nonhmm_user])
    @nonhmm_user['uid'] = logged_in_hmm_user.id
    if @nonhmm_user.save
         $notice_nonhmm
      flash[:notice_nonhmm] = 'Non-HMM User was Successfully Added!!'
      redirect_to :controller => 'customers', :action => 'fnf_index'
    else
      render :action => 'new', :layout => false
    end
  end

  def edit
    @nonhmm_user = NonhmmUser.find(params[:id])
    render :layout => false
  end

  def update
    @nonhmm_user = NonhmmUser.find(params[:id])
    if @nonhmm_user.update_attributes(params[:nonhmm_user])
      $notice_nonhmmEdit
      flash[:notice_nonhmmEdit] = 'Non HmmUser was successfully updated!!'
      redirect_to :controller => 'customers', :action => 'fnf_index'
    else
      render :action => 'edit', :layout => false
    end
  end

  def destroy
    NonhmmUser.find(params[:id]).destroy
    $notice_nonhmmDel
    flash[:notice_nonhmmDel] = 'Non HmmUser was successfully Deleted!!'
    redirect_to :controller => 'customers', :action => 'fnf_index', :layout => false
  end
  
  def validate_email
    require 'pp'
    color = 'red'
    email = params[:email]
    mail = NonhmmUser.find_all_by_v_email(email)
    pp mail
    if mail.size > 0        
        message_email = 'Email Is Already Registered'  
       @valid = false
     
   end
   @message_email = "<b style='color:#{color}'>#{message_email}</b>"
    render :partial=>'message_email'
  end
  
end
