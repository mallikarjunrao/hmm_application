class SubchapCommentController < ApplicationController
  layout "standard" 
  
  before_filter :authenticate, :only => [:allcmt_list]#, :edit, :deleteSelection, :deleteSelection1, :update]


    #protected
    def authenticate
      unless session[:hmm_user]
        flash[:notice] = 'Please Login to Access your Account'
        redirect_to :controller => "user_account" , :action => 'login'
        return false
      end
    end
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @subchap_comment_pages, @subchap_comments = paginate :subchap_comments, :per_page => 10
  end

  def show
    @subchap_comment = SubchapComment.find(params[:id])
  end

  def new
    @subchap_comment = SubchapComment.new
    render :layout => false
  end

  def new_jcmt
    @subchap_comment = SubchapComment.new
    render :layout => false
  end

  def create
    type = 'Chapter'
    @subchap_comment = SubchapComment.new(params[:subchap_comment])
    @subchap_comment['uid']="#{logged_in_hmm_user.id}"
    @subchap_comment['subchap_id']=params[:subchap_id]
    if(params[:subchap_j_id]=='')
    params[:subchap_j_id]=0
    journal= 'Journal'
    end
    @subchap_comment['subchap_jid']=params[:subchap_j_id]
    @subchap_comment['d_created_on']=Time.now
    if @subchap_comment.save
      
     @commentedTo_subchap = SubChapter.find(params[:subchap_id])
    @commentedTo_details=HmmUsers.find(@commentedTo_subchap.uid)
    Postoffice.deliver_subchapComment(params[:subchap_comment][:v_comments],journal,type,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_e_mail,@commentedTo_details.v_fname,@commentedTo_details.v_e_mail,logged_in_hmm_user.v_myimage)
      $notice_scc_add
      flash[:notice_scc_add] = 'Thank you for your comments your comments have been sent sucessfully to the owner of this subcapter !!'
      if(session['redirect']=='2')
        redirect_to :controller => 'galleries', :action => 'gallery_coverflow', :id => params[:subchap_id]
      else if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
      else
        redirect_to :controller => 'customers', :action => 'sub_chapter_gallery', :id => params[:subchap_id]
      end 
    end
    end
    else
      render :action => 'new'
    end
  end

  def create_jcmt
    @subchap_comment = SubchapComment.new(params[:subchap_comment])
    @subchap_comment['uid']="#{logged_in_hmm_user.id}"
    @subchap_comment['subchap_id']=params[:subchap_id]
    if(params[:subchap_j_id]=='')
    params[:subchap_j_id]=0
    end
    @subchap_comment['subchap_jid']=params[:subchap_j_id]
    @subchap_comment['d_created_on']=Time.now
    if @subchap_comment.save
      $notice_scc_jadd
      flash[:notice_scc_jadd] = 'Thank you for adding your comments. Your comment has been sent sucessfully to the owner of this chapter!!'
        $notice_share_jlist
      flash[:notice_share_jlist] = 'Your Comment is sucessfully sent..' 
       if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
         else  if(session['redirect']=='11')
        redirect_to :controller => 'share_journals', :action => 'shareJournal_view', :id => session['shareid']
        else
      redirect_to :controller => 'chapter_journal', :action => 'journalUnder_development'
    end
  end
  end
    else
      render :action => 'new'
    end
  end


  def edit
    @subchap_comment = SubchapComment.find(params[:id])
  end

  def update
    @subchap_comment = SubchapComment.find(params[:id])
    if @subchap_comment.update_attributes(params[:subchap_comment])
      
      flash[:notice] = 'Sub-Chapter Comment Was Successfully Updated!!'
       if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
      else
       redirect_to :action => 'show', :id => @subchap_comment
      end
    else
      render :action => 'edit'
    end
  end

  def destroy
    SubchapComment.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def comnt_list
    @hmm_user=HmmUsers.find(session[:hmm_user])
   if session[:friend]!='' 
      e_approval=" and e_approval = 'approve'"
   end
  
  if(request.request_uri == "/subchap_comment/comnt_list/" )
    @tag_c = SubchapComment.find_by_sql("select a.*,b.*,a.id as cid from subchap_comments as a , hmm_users as b where a.uid=b.id ORDER BY a.id DESC")
  else 
    if(params[:id]=='0')
     @update="me"
      @tag_c = SubchapComment.find_by_sql("select a.*,b.*,a.id as cid from subchap_comments as a , hmm_users as b where subchap_id=#{params[:subchap_id]} and subchap_jid=0 and a.uid=b.id #{e_approval} ORDER BY a.id DESC")
    else
      @update="me2"
      @tag_c = SubchapComment.find_by_sql("select a.*,b.*,a.id as cid from subchap_comments as a , hmm_users as b where subchap_jid=#{params[:id]} and a.uid=b.id #{e_approval} ORDER BY a.id DESC")
    end
  end
  
  
  @subchap_id=params[:subchap_id]
    @id=params[:id]
    i=0
    for cn in @tag_c
      i=i+1
    end
  @total=i
  
  @numberofpagesres=@total/3
  
  @numberofpages=@numberofpagesres.round()

  if(@params[:page]==nil)
  x=0
  y=3
  @page=0
  if(@total<=3)
  @nonext=1
  end
  @nextpage=@page+1
  else
    x=3*Integer(@params[:page])
    y=3
    @page=Integer(@params[:page])
    @nextpage=@page+1
    @previouspage=@page-1
    if(@page==@numberofpages || @total<=3)
      @nonext=1
    end
  end
   
    if(request.request_uri == "/subchap_comment/comnt_list/" )
    @tag_c = SubchapComment.find_by_sql("select a.*,b.*,a.id as cid from subchap_comments as a , hmm_users as b where a.uid=b.id ORDER BY a.id DESC limit  #{x},#{y}")
  else 
    if(params[:id]=='0')
    
      @tag_c = SubchapComment.find_by_sql("select a.*,b.*,a.id as cid from subchap_comments as a , hmm_users as b where subchap_id=#{params[:subchap_id]} and subchap_jid=0 and a.uid=b.id #{e_approval} ORDER BY a.id DESC limit  #{x},#{y}")
    else
     
      @tag_c = SubchapComment.find_by_sql("select a.*,b.*,a.id as cid from subchap_comments as a , hmm_users as b where subchap_jid=#{params[:id]} and a.uid=b.id  #{e_approval} ORDER BY a.id DESC limit  #{x},#{y}")
    end
  end
  
  
    #@subchap_comment = ChapterComment.find(:all, :conditions => "subchap_id=#{params[:id]} && uid=#{logged_in_hmm_user.id}")
    render :layout => false
  end
  
  def allcmt_list
    @hmm_user=HmmUsers.find(session[:hmm_user])
    items_per_page = 10
     
    @subchap_comment_pages, @subchap_comment = paginate :hmm_users, :per_page => items_per_page, :joins =>"as b, subchap_comments as a", :conditions=> "b.id=#{logged_in_hmm_user.id} and a.uid=b.id "
    #@subchap_comment = ChapterComment.find(:all, :conditions => "subchap_id=#{params[:id]} && uid=#{logged_in_hmm_user.id}")
    render :layout => true
  end
  
  def jcomment_list
    @hmm_user=HmmUsers.find(session[:hmm_user])
    #@subchap_comment = ChapterComment.find(:all, :conditions => "subchap_id=#{params[:id]} && uid=#{logged_in_hmm_user.id}")
    render :layout => false
  end
  
  def add_comment
     @hmm_user=HmmUsers.find(session[:hmm_user])
     @chapter_comment =SubchapComment.find(params[:cid])
      @chapter_comment['e_approval'] = 'approve'
    @chapter_comment.save
     $notice_sca
      flash[:notice_sca] = 'Sub-Chapter Comment Approved Successfully!!'
      if(session['redirect']=='2')
       # redirect_to :controller => 'galleries', :action => 'gallery_coverflow', :id => session[:sub_id]
         redirect_to :controller => 'subchap_comment', :action => 'comnt_list', :subchap_id => session[:sub_id], :page=>params[:page], :id => params[:id]
 
      else if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
      else
        redirect_to :controller => 'subchap_comment', :action => 'comnt_list', :subchap_id => session[:sub_id], :page=>params[:page], :id => params[:id]
    end 
  end
  end
  end
  
  def approve_cmt
    @hmm_user=HmmUsers.find(session[:hmm_user])
     @chapter_comment =SubchapComment.find(params[:id])
      @chapter_comment['e_approval'] = 'approve'
    @chapter_comment.save
    $notice_sca_list
      flash[:notice] = 'Sub-Chapter Comment Was Successfully Approved!!'
    redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
  end
  
  def approve_jcmt
    @hmm_user=HmmUsers.find(session[:hmm_user])
     @chapter_comment =SubchapComment.find(params[:id])
      @chapter_comment['e_approval'] = 'approve'
    @chapter_comment.save
    $notice_sca_jlist
      flash[:notice_sca_jlist] = 'Sub-Chapter Comment Approved Sucessfully!!'
     if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
      end
      end
        end
  
   def reject_comment
     @hmm_user=HmmUsers.find(session[:hmm_user])
     @chapter_comment =SubchapComment.find(params[:cid])
      @chapter_comment.destroy
     $notice_scr
      flash[:notice_scr] = 'Sub-Chapter Comment Rejected'
     if(session['redirect']=='2')
        #redirect_to :controller => 'galleries', :action => 'gallery_coverflow', :id => session[:sub_id]
         redirect_to :controller => 'subchap_comment', :action => 'comnt_list', :subchap_id => session[:sub_id], :page=>params[:page], :id => params[:id]
 
     else if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
      else
        redirect_to :controller => 'subchap_comment', :action => 'comnt_list', :subchap_id => session[:sub_id], :page=>params[:page], :id => params[:id]
    end
    end
  end
  end
  
  def reject_cmt
    @hmm_user=HmmUsers.find(session[:hmm_user])
     @chapter_comment =SubchapComment.find(params[:id])
     @chapter_comment.destroy
    $notice_scr_list
      flash[:notice] = 'Sub-Chapter Comment was Rejected'
    redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
  end
 
  
  def reject_jcmt
    @hmm_user=HmmUsers.find(session[:hmm_user])
     @chapter_comment =SubchapComment.find(params[:id])
      @chapter_comment.destroy
    $notice_scr_jlist
      flash[:notice_scr_jlist] = 'Sub-Chapter Comment Rejected'
   if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
      end
    end
    
        end
 
 def comt_destroy
    @chapter_comment =SubchapComment.find(params[:cid])
    @chapter_comment.destroy
     $notice_scd
      flash[:notice_scd] = 'Sub-Chapter Comment Deleted Successfully!!'
     if(session['redirect']=='2')
       # redirect_to :controller => 'galleries', :action => 'gallery_coverflow', :id => session[:sub_id]
        redirect_to :controller => 'subchap_comment', :action => 'comnt_list', :subchap_id => session[:sub_id], :page=>params[:page], :id => params[:id]
 
      else if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
      else
         redirect_to :controller => 'subchap_comment', :action => 'comnt_list', :subchap_id => session[:sub_id], :page=>params[:page], :id => params[:id]
   end 
    end
  end
  end
 
  def destroy_cmt
    @chapter_comment =SubchapComment.find(params[:id])
    @chapter_comment.destroy
    $notice_scd_list
      flash[:notice] = 'Sub-Chapter Comment Was Successfully Deleted!!'
    redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
  end
 
 def destroy_jcmt
    @chapter_comment =SubchapComment.find(params[:id])
    @chapter_comment.destroy
    $notice_scd_jlist
      flash[:notice_scd_jlist] = 'Sub-Chapter Comment Was Successfully Deleted!!'
 if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
      end
      end
        end
 
end
