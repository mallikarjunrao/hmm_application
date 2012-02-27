class ShareMomentsController < ApplicationController
    layout "standard"
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @share_moment_pages, @share_moments = paginate :share_moments, :per_page => 10
  end

  def show
    @share_moment = ShareMoment.find(params[:id])
  end

  def new
    @share_moment = ShareMoment.new
  end

  def create
    @share_moment = ShareMoment.new(params[:share_moment])
    if @share_moment.save
      flash[:notice] = 'ShareMoment was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @share_moment = ShareMoment.find(params[:id])
  end

  def update
    @share_moment = ShareMoment.find(params[:id])
    if @share_moment.update_attributes(params[:share_moment])
      flash[:notice] = 'ShareMoment was successfully updated.'
      redirect_to :action => 'show', :id => @share_moment
    else
      render :action => 'edit'
    end
  end

  def destroy
    ShareMoment.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def manageShare
    
  end
  
  def shareMoment_view
    sql = ActiveRecord::Base.connection();
    sql.update "UPDATE share_moments SET shown='true' WHERE id = '#{params[:id]}'"
     @shareid = params[:id]
   
    @user_contentID = ShareMoment.find(:all, :joins => "as a, user_contents as b" , :conditions => "a.id=#{params[:id]} and a.usercontent_id=b.id")
     @share_moment = ShareMoment.find(:all, :conditions => "id=#{params[:id]}")
    for i in @share_moment
      params[:id] = i.moment_type
      @momenttype = params[:id]  
#     params[:id] = i.jtype
#     @journaltype = params[:id]
    end
      
      @presenter_name = ShareMoment.find(:all, :joins => "as a, hmm_users as b", :conditions => "a.id='#{@shareid}' and a.presenter_id=b.id")
      for j in @presenter_name
        params[:id] = j.v_fname
        @name = params[:id]
        params[:id] = j.id
        @id = params[:id]
    end
    session[:redirect] = nil
  end
  
  def moment_rejectshare
    sql = ActiveRecord::Base.connection();
    sql.execute("update share_moments set share_moments.status='reject' where share_moments.id = #{params[:id]} ")
    redirect_to :controller => 'customers', :action => 'list_share'
  end
  
  
  
  def shareMoments_byme
    @hmm_user=HmmUser.find(session[:hmm_user])
     @fnf_req = FamilyFriend.find_by_sql("SELECT b.*, a.id as frnid, a.* FROM family_friends  as a ,hmm_users as b  WHERE (a.fid=#{logged_in_hmm_user.id} and a.uid=b.id and a.status='pending')")
     
      @fnf_groups = FnfGroups.paginate :conditions => " uid=#{logged_in_hmm_user.id} ", :per_page => 10, :page => params[:page]
    flash[:notice_fnf] = 'is your friend now!!'
    
    #pagination code
    @share_cnt = Share.count(:all, :conditions => "presenter_id = '#{logged_in_hmm_user.id}' and DATE_FORMAT(expiry_date, '%Y-%m-%d' ) >= curdate( )")
    @sharemoment_cnt = ShareMoment.count(:all, :conditions => "presenter_id = '#{logged_in_hmm_user.id}' and DATE_FORMAT( expiry_date, '%Y-%m-%d' ) >= curdate( )")
  
    @totalshare_cnt = (@share_cnt+@sharemoment_cnt)  
    @numberofpagesres= @totalshare_cnt/10
    @numberofpages=@numberofpagesres.round()
    
    if(params[:page]==nil)
@x=0
@y=10
@page=0
@nextpage=1
if(@totalshare_cnt<10)

 @nonext=1
end
else
  @x=10*Integer(params[:page])
  @y=10
  @page=Integer(params[:page])
  @nextpage=@page+1
  @previouspage=@page-1
  if(@page==@numberofpages)
    @nonext=1
  end
  
end
  if(params[:page]==nil)
  else
    render :layout => false
  end 
  end
  
  def share_view
     @shareid = params[:id]
   
    @user_contentID = ShareMoment.find(:all, :joins => "as a, user_contents as b" , :conditions => "a.id=#{params[:id]} and a.usercontent_id=b.id")
     @share_moment = ShareMoment.find(:all, :conditions => "id=#{params[:id]}")
    for i in @share_moment
      params[:id] = i.moment_type
      @momenttype = params[:id]  
#     params[:id] = i.jtype
#     @journaltype = params[:id]
    end
      
      @presenter_name = ShareMoment.find(:all, :joins => "as a, hmm_users as b", :conditions => "a.id='#{@shareid}' and a.presenter_id=b.id")
      for j in @presenter_name
        params[:id] = j.v_fname
        @name = params[:id]
        params[:id] = j.id
        @id = params[:id]
    end
    session[:redirect] = nil
  end
  
  
  def share_info
    
    params[:share_selected_id]
    if(params[:ctype]=="share")
      @share=Share.find(params[:share_selected_id])
    else
      @share=ShareMoment.find(params[:share_selected_id])
    end  
    render :layout => false
    
  end
  
end
