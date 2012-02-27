class ShareCommentsController < ApplicationController
  layout 'standard'
  helper :photo_comment
  include PhotoCommentHelper
  
  
    def new1
    @share_comment = ShareComments.new
    @share_id= params[:id]
     render :layout => false
 end
 
 def create1
    @share_comment = ShareComments.new()
    @share_comment['name']=params[:v_name]
    @share_comment['uid']=0
    @share_comment['comment']=params[:v_comment]
    @share_comment['share_id']=params[:shareid]
    
    @share_comment['d_add_date']=Time.now
    @share_comment.save
    
    
    
    respond_to do |format|
      if @share_comment.save
        
        $notice_pcc
      flash[:notice_pcc] = 'Your Comment has been sent successfully to the owner of this shared memories thank you!!'
      # format.html { redirect_to photo_comment_url(@photo_comment) }
     # redirect_to :controller => 'account', :action => 'list'
      shareget=Share.find(params[:shareid])
      
      format.html {redirect_to :controller => 'share', :action => 'memories', :id=>shareget[:unid]}
      #  format.xml  { head :created, :location => photo_comment_url(@photo_comment) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @photo_comment.errors.to_xml }
      end
    end
  end
  
  
  
  def new
    @share_comment = ShareComments.new
    @share_id= params[:id]
     render :layout => false
 end
 
 def create
    @share_comment = ShareComments.new()
    @share_comment['name']=logged_in_hmm_user.v_fname
    @share_comment['uid']=logged_in_hmm_user.id
    @share_comment['comment']=params[:v_comment]
    @share_comment['share_id']=params[:shareid]
    @share_comment['d_add_date']=Time.now
    
    @share_comment.save
    
    
    
   
      if @share_comment.save
     #@presenter_name=Shares.find(:all, :joins => "as a, hmm_users as b", :conditions => "a.id=#{params[:id]} and a.presenter_id=b.id")
        $notice_pcc
      flash[:notice_pcc] = 'Your comment has been sent to'
      
      # format.html { redirect_to photo_comment_url(@photo_comment) }
     # redirect_to :controller => 'account', :action => 'list'
    
     if(session['redirect']=='111')
       #redirect_to :controller => 'tags', :action => 'memories', :id=> params[:shareid]
    
     end
      #  format.xml  { head :created, :location => photo_comment_url(@photo_comment) }
      else
      # redirect_to :controller => 'tags', :action => 'memories', :id=> params[:shareid]
        #render :action => "new" 
      
    
    end
    redirect_to :controller => 'tags', :action => 'memories', :id=> params[:shareid]
    end
  
  
  
   def share_comnt
   if(session[:hmm_user]!=nil)
    @hmm_user=HmmUsers.find(session[:hmm_user])
   end
   #params[:id]=session[:hmm_user]
   #@tags=Tag.find(:all, :conditions => "uid=#{session[:hmm_user]}")
   #params[:id]=@tags.id
   #@journals=Journal.find(:all, :conditions => "chap_id=#{@tags.id}")
   #params[:id]=@journals.id
   #@comments=Comment.find(params[:id])
   
   
   render(:layout => false)
 end
 
  def allcmt_list1
   @hmm_user=HmmUsers.find(session[:hmm_user])
      items_per_page = 10
   #@condition = ChapterComment.find_by_sql("select a.*,b.*,a.id as cid from chapter_comments as a, hmm_users as b where b.id=#{logged_in_hmm_user.id} and a.uid=b.id ORDER BY a.id DESC")
   @share_comment_pages, @share_comment = paginate :hmm_users, :per_page => items_per_page, :joins =>"as b, share_comments as a, tags as c", :conditions=> "b.id=#{logged_in_hmm_user.id} and a.uid=b.id and a.tag_id=c.id"
    #@tag_comment = ChapterComment.find(:all, :conditions => "tag_id=#{params[:id]} && uid=#{logged_in_hmm_user.id}")
   render :layout => true
 end
 
 def approve_cmt
   puts session['redirect']
     @hmm_user=HmmUsers.find(session[:hmm_user])
     @share_comment =ShareComments.find(params[:id])
     @share_comment['e_approved'] = 'approved'
     @share_comment.save
      $notice_cca_list
     flash[:notice_cca_list] = 'Shared Moment Comment Approved!!'
      if(session['redirect']=='111')
       redirect_to :controller => 'tags', :action => 'memories', :id=> @share_comment[:share_id]
      else
     redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      end
 end
 
 def reject_cmt
     @hmm_user=HmmUsers.find(session[:hmm_user])
     @share_comment =ShareComments.find(params[:id])
     @share_comment.destroy
      
      #@tag_cid = ChapterComment.find(:all, :conditions => "tag_jid=#{params[:id]} " , :order => "id DESC")
    
    $notice_ccr_list
     flash[:notice] = 'Shared Moment Comment Rejected!!'
    if(session['redirect']=='111')
       redirect_to :controller => 'tags', :action => 'memories', :id=> @share_comment[:share_id]
    else  
   redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    end
   end
  
  
  def destroy_cmt
    @share_comment =ShareComments.find(params[:id])
    @share_comment.destroy
    $notice_ccd_list
     flash[:notice_ccd_list] = 'Shared Moment Comment Deleted!!'
      if(session['redirect']=='111')
       redirect_to :controller => 'tags', :action => 'memories', :id=> @share_comment[:share_id]
      else
    redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      end
  end
  
   def reply_comnt
    render :layout => false
   end
  
   def reply_comment
     @hmm_user=HmmUsers.find(session[:hmm_user])
     @share_comment =ShareComments.find(params[:id])     
     @share_comment['reply'] = params[:reply]
     @share_comment.save
     $notice_cca
     flash[:notice_cca] = 'Reply added sucessfully!!'
      if(session['redirect']=='111')
       redirect_to :controller => 'tags', :action => 'memories', :id=> @share_comment[:share_id]
      else
     redirect_to :controller => 'chapter_comment', :action => 'allcmt_list1'
      end
   end
  
  
   def new_photo_comment
    @photo_comment = PhotoComment.new
    @user_content_id= params[:id]
     render :layout => false
 end
 
 
  def photo_comnt
  if session[:friend]!='' 
      e_approval=" and a.e_approved = 'approve'"
      e_approval1=" and e_approved = 'approve'"
    end
  
  
  if(params[:id_journal]=='0')
    @update="me"
    @photo_comment = PhotoComment.find(:all, :joins => "as a, share_momentcomments as b", :conditions => "a.journal_id=#{params[:id_journal]} and a.user_content_id=#{params[:id]} #{e_approval}", :order => "a.id DESC")
  else
    @update="me2"
    @photo_comment = PhotoComment.find(:all, :conditions => "journal_id=#{params[:id_journal]} and user_content_id=#{params[:id]} #{e_approval1}", :order => "id DESC")  
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

  if(@params[:page]==nil)
  x=0
  y=100
  @page_share=0
  
  @nextpage=@page_share+1
  if(@total<=3)
     puts @total
     @nonext=1
  end
  else
    x=100*Integer(@params[:page_share])
    y=x+100
    @page_share=Integer(@params[:page_share])
    @nextpage=@page_share+1
    @previouspage=@page_share-1
    if(@page_share==@numberofpages)
      @nonext=1
    end
    if(@total<=3)
     puts @total
     @nonext=1
  end
  end

    if(params[:id_journal]=='0')
    @photo_comment = PhotoComment.find(:all, :conditions => "journal_id=#{params[:id_journal]} and user_content_id=#{params[:id]} #{e_approval1}", :order => "id DESC ", :limit => "#{x},#{y}")
  else
    @photo_comment = PhotoComment.find(:all, :conditions => "journal_id=#{params[:id_journal]} and user_content_id=#{params[:id]} #{e_approval1}", :order => "id DESC", :limit => "#{x},#{y}" )  
  end 
  
  
   render(:layout => false)  

 end
 def create_photo_comments
    @photo_comment = PhotoComment.new()
    @photo_comment['v_name']=params[:v_name]
    @photo_comment['v_comment']=params[:v_comment]
    @photo_comment['uid']=0
    @photo_comment['d_add_date']=Time.now
    @photo_comment.journal_id=0
    @photo_comment['user_content_id']=params[:user_content_id]
    @photo_comment.save
    
    
    
    respond_to do |format|
      if @photo_comment.save
        
        $notice_pcc
      flash[:notice_pcc] = 'Your Comment has been sent successfully to the owner of this shared memories thank you!!'
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
  
  
end