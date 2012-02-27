class PhotoCommentsController < ApplicationController
 
layout "standard" 
helper :photo_comment
  include PhotoCommentHelper

before_filter :authenticate, :only => [:allcmt_list]#, :edit, :deleteSelection, :deleteSelection1, :update]


    #protected
    def authenticate
      unless session[:hmm_user]
        flash[:notice] = 'Please Login to Access your Account'
        redirect_to :controller => "user_account" , :action => 'login'
        return false
      end
    end

  
  # GET /photo_comments
  # GET /photo_comments.xml
  def index
    @photo_comments = PhotoComment.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @photo_comments.to_xml }
    end
  end

  # GET /photo_comments/1
  # GET /photo_comments/1.xml
  def show
    @photo_comment = PhotoComment.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @photo_comment.to_xml }
    end
  end

  # GET /photo_comments/new
  def new
    @photo_comment = PhotoComment.new
    @user_content_id= params[:id]
     render :layout => false
  end

 def new1
    @photo_comment = PhotoComment.new
    @user_content_id= params[:id]
     render :layout => false
  end
  # GET /photo_comments/1;edit
  def edit
    @photo_comment = PhotoComment.find(params[:id])
  end

  # POST /photo_comments
  # POST /photo_comments.xml
  def create
    @photo_comment = PhotoComment.new()
    @photo_comment['v_name']=logged_in_hmm_user.v_fname
    @photo_comment['v_email']=logged_in_hmm_user.v_e_mail
    @photo_comment['v_comment']=params[:v_comment]
    @photo_comment['uid']=logged_in_hmm_user.id
    
    @photo_comment['d_add_date']=Time.now
    @photo_comment['user_content_id']=params[:orgid]
    @photo_comment['journal_id']=params[:i_id]
    if(params[:i_id]==0)
    journal=''
    else
    journal="journal"
    end
    @photo_comment.save
    
     @commentedTo_usercontent = UserContent.find(params[:user_content_id])
    @commentedTo_details=HmmUsers.find(@commentedTo_usercontent.uid)
    Postoffice.deliver_usercontentComment(params[:v_comment],journal,@commentedTo_usercontent.e_filetype,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_e_mail,@commentedTo_details.v_fname,@commentedTo_details.v_e_mail,logged_in_hmm_user.v_myimage)
  
    
    respond_to do |format|
      if @photo_comment.save
        
        $notice_pcc
      flash[:notice_pcc] = 'Thank you for adding your comment. Your comment has been sent to the owner of this content!!'
      # format.html { redirect_to photo_comment_url(@photo_comment) }
     # redirect_to :controller => 'account', :action => 'list'
      format.html {redirect_to :controller => 'myphotos', :action => 'photo_journal', :id=>params[:orgid], :page => params[:page]}
      #  format.xml  { head :created, :location => photo_comment_url(@photo_comment) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @photo_comment.errors.to_xml }
      end
    end
  end



 def create1
    @photo_comment = PhotoComment.new()
    @photo_comment['v_name']=params[:v_name]
    @photo_comment['v_comment']=params[:v_comment]
    @photo_comment['uid']=logged_in_hmm_user.id
    @photo_comment['d_add_date']=Time.now
    @photo_comment.journal_id=0
    @photo_comment['user_content_id']=params[:user_content_id]
    @photo_comment.save
    
    
    
    respond_to do |format|
      if @photo_comment.save
        
        $notice_pcc
      flash[:notice_pcc] = 'Photo Comment Was Successfully Created!!'
      # format.html { redirect_to photo_comment_url(@photo_comment) }
     # redirect_to :controller => 'account', :action => 'list'
      format.html {redirect_to :controller => 'myphotos', :action => 'photo_journal', :id=>params[:user_content_id]}
      #  format.xml  { head :created, :location => photo_comment_url(@photo_comment) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @photo_comment.errors.to_xml }
      end
    end
  end


def new_jcmt
    @photo_comment = PhotoComment.new
    @user_content_id= params[:id]
     render :layout => false
  end


 def create_jcmt
    @photo_comment = PhotoComment.new()
    @photo_comment['v_name']=logged_in_hmm_user.v_fname
    @photo_comment['v_email']=logged_in_hmm_user.v_e_mail
    @photo_comment['v_comment']=params[:v_comment]
    @photo_comment['uid']=logged_in_hmm_user.id
    @photo_comment['d_add_date']=Time.now
    @photo_comment.journal_id=params[:i_id]
   
    @photo_comment['user_content_id']=params[:user_content_id]
    @photo_comment.save
    $notice_pc_jadd
      flash[:notice_pc_jadd] = 'Photo Comment was Successfully Added!!'
       if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
         else  if(session['redirect']=='11')
        redirect_to :controller => 'share_journals', :action => 'shareJournal_view', :id => session['shareid']
        else
      redirect_to :controller => 'chapter_journal', :action => 'joournals'
  end
end
 end
 end

  # PUT /photo_comments/1
  # PUT /photo_comments/1.xml
  def update
    @photo_comment = PhotoComment.find(params[:id])

    respond_to do |format|
      if @photo_comment.update_attributes(params[:photo_comment])
        flash[:notice] = 'PhotoComment was successfully updated.'
        format.html { redirect_to photo_comment_url(@photo_comment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @photo_comment.errors.to_xml }
      end
    end
  end

  def photo_comnt
   @hmm_user=HmmUsers.find(session[:hmm_user])
   
    if session[:friend]=='' || session[:friend]== nil 
    else  
      approve1 = " and d.e_approved='approve'"
      e_approved = "and p.e_approved = 'approved' "
      e_approval = " and e_approved='approve'"
    end
   
      user_content_id=params[:id]
  
  #code changed to union share and share moment comments only query is been changed rest all conditions have been retained
 
  if(params[:id_journal]=="0" ||  params[:id_journal]=='' || params[:id_journal]==nil)
    @update="me"
    #@photo_comment = PhotoComment.find(:all, :joins => "as a, share_momentcomments as b", :conditions => "a.journal_id=#{params[:id_journal]} and a.user_content_id=#{params[:id]} #{e_approval} and b.user_content_id=#{params[:id]} #{e_approval} and b.user_content_dfgid=a.user_content_id ", :order => "a.id and b.id DESC")
    @photo_comment = PhotoComment.find_by_sql("
   (select 
        d.id as id,
        d.user_content_id as master_id,
        d.v_comment as comment, 
        d.reply as reply, 
        d.e_approved as e_approval,
        d.ctype as ctype,
        d.v_name as name,
        d.uid as user_id,
        d.d_add_date as d_created_at
        from 
        photo_comments  as d,
        user_contents as u
        where 
        d.user_content_id=u.id 
        and 
        u.id=#{user_content_id}
        #{approve1}
        
     )
     union 
     (select 
        p.id as id,
        q.usercontent_id as master_id,
        p.comment as comment, 
        p.reply as reply, 
        p.e_approved as e_approval,
        p.ctype as ctype,
        p.name as name,
        p.uid as user_id,
        p.added_date as d_add_date
        from 
        share_momentcomments as p,
        share_moments as q
        where 
        p.share_id=q.id 
        and 
        q.usercontent_id=#{user_content_id}
        #{e_approved}
     ) 
     ")
 else
  
@update="me2"
    @photo_comment = PhotoComment.find_by_sql("
    select 
        d.id as id,
        d.user_content_id as master_id,
        d.v_comment as comment, 
        d.reply as reply, 
        d.e_approved as e_approval,
        d.ctype as ctype,
        d.v_name as name,
        d.uid as user_id,
        d.d_add_date as d_created_at
        from 
        photo_comments  as d,
        user_contents as u
        where 
        d.journal_id='#{params[:id_journal]}'
        and
        d.user_content_id=u.id 
        and 
        u.id=#{user_content_id}
        #{approve1}
     ")
    
#    @photo_comment = PhotoComment.find(:all, :conditions => "journal_id=#{params[:id_journal]} and user_content_id=#{params[:id]} #{e_approval}", :order => "id DESC")  
  end 
  
   
  
  @id=params[:id]
    @id_journal=params[:id_journal]
    i=0
    for cn in @photo_comment
      i=i+1
    end
  @total=i
 
  
  @numberofpagesres=@total/3
  
  @numberofpages=@numberofpagesres.round()

  if(@params[:page1]==nil)
  x=0
  y=3
  @page=0
  
  @nextpage=@page+1
  if(@total<=3)
     puts @total
     @nonext=1
  end
  else
    x=3*Integer(@params[:page1])
    y=3
    @page=Integer(@params[:page1])
    @nextpage=@page+1
    @previouspage=@page-1
    if(@page==@numberofpages)
      @nonext=1
    end
    if(@total<=3)
     puts @total
     @nonext=1
  end
  end

   if(params[:id_journal]=="0" ||  params[:id_journal]=='' || params[:id_journal]==nil)
    @update="me"
    #@photo_comment = PhotoComment.find(:all, :joins => "as a, share_momentcomments as b", :conditions => "a.journal_id=#{params[:id_journal]} and a.user_content_id=#{params[:id]} #{e_approval} and b.user_content_id=#{params[:id]} #{e_approval} and b.user_content_dfgid=a.user_content_id ", :order => "a.id and b.id DESC")
    @photo_comment = PhotoComment.find_by_sql("
   (select 
        d.id as id,
        d.user_content_id as master_id,
        d.v_comment as comment, 
        d.reply as reply, 
        d.e_approved as e_approval,
        d.ctype as ctype,
        d.v_name as name,
        d.uid as user_id,
        d.d_add_date as d_created_at
        from 
        photo_comments  as d,
        user_contents as u
        where 
        d.user_content_id=u.id 
        and 
        u.id=#{user_content_id}
        #{approve1}
        
     )
     union 
     (select 
        p.id as id,
        q.usercontent_id as master_id,
        p.comment as comment, 
        p.reply as reply, 
        p.e_approved as e_approval,
        p.ctype as ctype,
        p.name as name,
        p.uid as user_id,
        p.added_date as d_add_date
        from 
        share_momentcomments as p,
        share_moments as q
        where 
        p.share_id=q.id 
        and 
        q.usercontent_id=#{user_content_id}
        #{e_approved}
    )order by d_created_at desc limit #{x}, #{y}")
 else
  
@update="me2"
    @photo_comment = PhotoComment.find_by_sql("
    select 
        d.id as id,
        d.user_content_id as master_id,
        d.v_comment as comment, 
        d.reply as reply, 
        d.e_approved as e_approval,
        d.ctype as ctype,
        d.v_name as name,
        d.uid as user_id,
        d.d_add_date as d_created_at
        from 
        photo_comments  as d,
        user_contents as u
        where 
        d.journal_id='#{params[:id_journal]}'
        and
        d.user_content_id=u.id 
        and 
        u.id=#{user_content_id}
        #{approve1}
     order by d_created_at desc limit #{x}, #{y}")
    
#    @photo_comment = PhotoComment.find(:all, :conditions => "journal_id=#{params[:id_journal]} and user_content_id=#{params[:id]} #{e_approval}", :order => "id DESC")  
  end 
  
  
   render(:layout => false)
 end
 
 def view_comment
   @hmm_user=HmmUsers.find(session[:hmm_user])
 end

  # DELETE /photo_comments/1
  # DELETE /photo_comments/1.xml
  def destroy
    @photo_comment = PhotoComment.find(params[:id])
    @photo_comment.destroy
    respond_to do |format|
      format.html { redirect_to photo_comments_url }
      format.xml  { head :ok }
    end
  end
  
  #Function To Approve Comments
  def add_comment
    @hmm_user=HmmUsers.find(session[:hmm_user])
    @comment =PhotoComment.find(params[:cid])
    @comment['e_approved'] = 'approve'
    @comment.save
    $notice_pca
      flash[:notice_pca] = 'Photo Comment was Successfully Approved!!'
#    params[:id]=@comment['journal_id']
#    @journal=JournalsPhoto.find(params[:id])
     if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
      else
   # redirect_to :controller => 'myphotos', :action => 'photo_journal' , :id => session[:usercontent_id1]
    redirect_to :controller => 'photo_comments', :action => 'photo_comnt', :id => session[:usercontent_id1], :page1=>params[:page1], :id_journal => params[:id_journal]
 
  end
  end
    flash[:notice] = 'Comment Is Aproved!!!'
  end
  
  def approve_cmt
    @hmm_user=HmmUsers.find(session[:hmm_user])
    @comment =PhotoComment.find(params[:id])
    @comment['e_approved'] = 'approve'
    @comment.save
    $notice_pca_list
      flash[:notice] = 'Photo Comment was Successfully Approved!!'
     redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
  end
  
  def approve_jcmt
    @hmm_user=HmmUsers.find(session[:hmm_user])
    @comment =PhotoComment.find(params[:id])
    @comment['e_approved'] = 'approve'
    @comment.save
    $notice_pca_jlist
      flash[:notice_pca_jlist] = 'Photo Comment Approved Successfully!!'
     if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
     else
     redirect_to :controller => 'chapter_journal', :action => 'journals'
     end
  end
  
  #Function To Reject Comments
  def reject_comment
    @hmm_user=HmmUsers.find(session[:hmm_user])
    @comment =PhotoComment.find(params[:cid])
     @comment.destroy
    $notice_pcr
    flash[:notice_pcr] = 'Photo Comment Rejected'
#    params[:id]=@comment['journal_id']
#    @journal=JournalsPhoto.find(params[:id])
     if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals' else
   # redirect_to :controller => 'myphotos', :action => 'photo_journal' , :id => session[:usercontent_id1]
       redirect_to :controller => 'photo_comments', :action => 'photo_comnt', :id => session[:usercontent_id1], :page1=>params[:page1], :id_journal => params[:id_journal]
 
  end
  end
    flash[:notice] = 'Comment Is Rejected'
  end
  
  def reject_cmt
     @hmm_user=HmmUsers.find(session[:hmm_user])
    @comment =PhotoComment.find(params[:id])
     @comment.destroy
    $notice_pcr_list
    flash[:notice] = 'Photo Comment Rejected'
    redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
  end
  
  def reject_jcmt
     @hmm_user=HmmUsers.find(session[:hmm_user])
    @comment =PhotoComment.find(params[:id])
    @comment.destroy
    $notice_pcr_jlist
    flash[:notice_pcr_jlist] = 'Photo Comment Rejected'
    if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
    end
    end
  end
  
  def comt_destroy
    @comment =PhotoComment.find(params[:cid])
    @comment.destroy
      $notice_pcd
      flash[:notice_pcd] = 'Photo Comment Deleted Successfully!!'
#    params[:id]=@comment['journal_id']
#    @journal=JournalsPhoto.find(params[:id])
     if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
      else
    #redirect_to :controller => 'myphotos', :action => 'photo_journal' , :id => session[:usercontent_id1]
      redirect_to :controller => 'photo_comments', :action => 'photo_comnt', :id => session[:usercontent_id1], :page1=>params[:page1], :id_journal => params[:id_journal]
 
  end
  end
    flash[:notice] = 'Comment Is Deleted!!!'
  end
  
  def destroy_cmt
    @comment =PhotoComment.find(params[:id])
    @comment.destroy
    $notice_pcd_list
      flash[:notice] = 'Photo Comment was Successfully Deleted!!'
    redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
  end
  
  def destroy_jcmt
    @comment =PhotoComment.find(params[:id])
    @comment.destroy
    $notice_pcd_jlist
      flash[:notice_pcd_jlist] = 'Photo Comment was Successfully Deleted!!'
    if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
    end
    end
  end
  
  def allcmt_list
    items_per_page=10
      @chapter_comment_pages, @chap_comment = paginate :hmm_users, :per_page => items_per_page, :joins =>"as b, photo_comments as a", :conditions=> "b.id=#{logged_in_hmm_user.id} and a.uid=b.id "

    @hmm_user=HmmUsers.find(session[:hmm_user])
    
  end
  
  def jcomment_list
    @hmm_user=HmmUsers.find(session[:hmm_user])
    uid1=logged_in_hmm_user.id
    
    sharejournalcnt = ShareJournal.find_by_sql("
  select
    count(*) as cnt
    from 
    share_journalcomments as d,
    share_journals as u
    where
    d.shareid = u.id and u.presenter_id=#{uid1}
    ")
    
    usercontentcount = UserContent.find_by_sql("
  select 
       count(*) as cnt
        from 
        photo_comments   as d,
        user_contents as u
        where 
        d.user_content_id=u.id and u.uid=#{uid1}
  
  ")
  
   usercontentcnt=Integer(usercontentcount[0].cnt)
 
  sharejournalcnt=Integer(sharejournalcnt[0].cnt)
    
    @total=usercontentcnt+sharejournalcnt
  
  @numberofpagesres=@total/10
  
  @numberofpages=@numberofpagesres.round()

  if(@params[:page]==nil)
  x=0
  y=10
  @page=0
  @nextpage=1
  if(@total<10)
  
   @nonext=1
  end
  else
    x=10*Integer(@params[:page])
    y=10
    @page=Integer(@params[:page])
    @nextpage=@page+1
    @previouspage=@page-1
    if(@page==@numberofpages)
      @nonext=1
    end
  
end
    
    
    @photo_comment=PhotoComment.find_by_sql("
    (select 
        d.id as id,
        d.user_content_id as master_id,
        d.v_comment as comment, 
        d.reply as reply, 
        d.e_approved as e_approval,
        d.ctype as ctype,
        d.v_name as name,
        d.uid as user_id,
        d.d_add_date as d_created_at
        from 
        photo_comments  as d,
        user_contents as u
        where 
        d.user_content_id=u.id 
        and 
        u.uid=#{uid1}
        and 
        d.journal_id=#{params[:id_journal]}
     )
     union 
    (select 
        r.id as id,
        r.shareid as master_id,
        r.comment as comment, 
        r.reply as reply, 
        r.status as e_approval,
        r.ctype as ctype,
        r.name as name,
        r.id as user_id,
        r.comment_date as d_add_date
        from 
        share_journalcomments as r,
        share_journals as z
        where 
        r.shareid=z.id 
        and 
        z.presenter_id=#{uid1}
        and 
        r.journal_id=#{params[:id_journal]}
     ) order by d_created_at desc limit #{x}, #{y} ")
    
    render(:layout => false)
  end
  
end
