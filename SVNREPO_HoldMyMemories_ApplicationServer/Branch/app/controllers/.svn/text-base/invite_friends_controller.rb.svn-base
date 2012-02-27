class InviteFriendsController < ApplicationController
  # GET /invite_friends
  # GET /invite_friends.xml
   layout "standard"
   
  before_filter :authenticate
  
  def authenticate
      unless session[:hmm_user]
           flash[:notice] = 'Please Login to Access your Account'
           redirect_to :controller => "user_account" , :action => 'login'
      return false
      else
        if (session[:flag] == 1 && request.request_uri != "/customers/upgrade/platinum_account")
          flash[:error] = "Your credit card payment to you HoldMyMemories.com has been declined by your credit card company. This could be for a number of reasons, including an expired card. <br><br><br>Please re-enter your credit card information, or use a different card for the renewal of your account."
          redirect_to "https://www.holdmymemories.com/customers/upgrade/platinum_account"
        end 
      end
    end
    
  
  def index
    @invite_friends = InviteFriend.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @invite_friends.to_xml }
    end
  end
   def list
    @invite_friends = InviteFriend.find(:all,:conditions => "uid='#{logged_in_hmm_user.id}'",:order => 'id desc')
   @hmm_user=HmmUsers.find(session[:hmm_user])
     @fnf_req = FamilyFriend.find_by_sql("SELECT b.*,a.uid as frid , a.id as frnid, a.* FROM family_friends  as a ,hmm_users as b  WHERE (a.fid=#{logged_in_hmm_user.id} and a.uid=b.id and a.status='pending')")
      @fnf_groups_pages, @fnf_groups = paginate :fnf_groupss, :conditions => " uid=#{logged_in_hmm_user.id} ", :per_page => 10
    flash[:notice_fnf] = 'is your friend now!!'
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @invite_friends.to_xml }
    end
  end

  # GET /invite_friends/1
  # GET /invite_friends/1.xml
  def show
    @invite_friend = InviteFriend.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @invite_friend.to_xml }
    end
  end

  # GET /invite_friends/new
  def new
    @invite_friend = InviteFriend.new
  end

  # GET /invite_friends/1;edit
  def edit
    @invite_friend = InviteFriend.find(params[:id])
  end

  # POST /invite_friends
  # POST /invite_friends.xml
  def create
    @invite_friend = InviteFriend.new
    @invite_friend.friends_email=params[:email]
    @invite_friend.uid=logged_in_hmm_user.id
    
   
      if @invite_friend.save
        frindslist=@invite_friend.friends_email.split(',')
        for i in frindslist
          Postoffice.deliver_invite(logged_in_hmm_user.v_fname,logged_in_hmm_user.v_e_mail,i)
        end
      redirect_to  :controller => 'invite_friends',:action =>'list'
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invite_friend.errors.to_xml }
    end
    
    
  end

  # PUT /invite_friends/1
  # PUT /invite_friends/1.xml
  def update
    @invite_friend = InviteFriend.find(params[:id])

    respond_to do |format|
      if @invite_friend.update_attributes(params[:invite_friend])
        flash[:notice] = 'InviteFriend was successfully updated.'
        format.html { redirect_to invite_friend_url(@invite_friend) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invite_friend.errors.to_xml }
      end
    end
  end

  # DELETE /invite_friends/1
  # DELETE /invite_friends/1.xml
  def destroy
    @invite_friend = InviteFriend.find(params[:id])
    @invite_friend.destroy

    respond_to do |format|
      format.html { redirect_to invite_friends_url }
      format.xml  { head :ok }
    end
  end
  
  def tips_view
    @tips = Tip.find(:all) 
  end
  
  def tips_detail
    @tips = Tip.find(:all, :conditions => "id=#{params[:id]}") 
    render :layout => false
  end
  
  def ideas
    
    render :layout => false
  end
  
  def blank
    render :layout => false
  end
  
end
