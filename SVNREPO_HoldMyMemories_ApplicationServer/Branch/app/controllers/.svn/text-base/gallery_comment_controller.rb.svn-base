class GalleryCommentController < ApplicationController
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
    @gallery_comment_pages, @gallery_comments = paginate :gallery_comments, :per_page => 10
  end

  def show
    @gallery_comment = GalleryComment.find(params[:id])
  end

  def new
    @gallery_comment = GalleryComment.new
     render :layout => false
  end

  def new_jcmt
    @gallery_comment = GalleryComment.new
    @gal_name = Galleries.find(:all, :conditions => "id='#{params[:id]}'")
     render :layout => false
  end

  def create
    type = 'Gallery'
    @gallery_comment = GalleryComment.new(params[:gallery_comment])
    @gallery_comment['uid']=logged_in_hmm_user.id
    @gallery_comment['gallery_id']=params[:gallery_id]
    if(params[:gallery_j_id]=='')
      @gallery_comment['gallery_jid']=0
      journal= 'Journal'
    else
      @gallery_comment['gallery_jid']=params[:gallery_j_id]
    end
    @commentedTo_gallery = Galleries.find(params[:gallery_id])
    @cmtTo_subchap= SubChapter.find(@commentedTo_gallery.subchapter_id)
    @commentedTo_details=HmmUsers.find(@cmtTo_subchap.uid)
    Postoffice.deliver_galleryComment(params[:gallery_comment][:v_comment],journal,type,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_e_mail,@commentedTo_details.v_fname,@commentedTo_details.v_e_mail,logged_in_hmm_user.v_myimage)
     
    @gallery_comment['d_created_on']=Time.now
    
    if @gallery_comment.save
      
      $notice_gcc
      flash[:notice_gcc] = 'Thank you for comment. Your comment has been sent sucessfully to the owner of this gallery.'
      if(session['redirect']=='2')
        redirect_to :controller => 'galleries', :action => 'gallery_fisheye', :id => params[:gallery_id]
      else if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
      else
        redirect_to :controller => 'customers', :action => 'chapter_gallery', :id => params[:gallery_id]
      end  
    end
  end
  
    else
      render :action => 'new', :layout => false
    end
  end

  def create_jcmt
    @gallery_comment = GalleryComment.new(params[:gallery_comment])
    @gallery_comment['uid']=logged_in_hmm_user.id
    @gallery_comment['gallery_id']=params[:gallery_id]
    if(params[:gallery_j_id]=='')
      @gallery_comment['gallery_jid']=0
    else
      @gallery_comment['gallery_jid']=params[:gallery_j_id]
    end
  
    @gallery_comment['d_created_on']=Time.now
    
    if @gallery_comment.save
      $notice_gcc_jadd
      flash[:notice_gcc_jadd] = 'Thank you for comment. Your comment has been sent sucessfully to the owner of this gallery.'
       $notice_share_jlist
       flash[:notice_share_jlist] = 'Your comment has been sent sucessfully..'
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
      render :action => 'new', :layout => false
    end
  end


  def edit
    @gallery_comment = GalleryComment.find(params[:id])
  end

  def update
    @gallery_comment = GalleryComment.find(params[:id])
    if @gallery_comment.update_attributes(params[:gallery_comment])
      flash[:notice] = 'GalleryComment was successfully updated.'
      redirect_to :action => 'show', :id => @gallery_comment
    else
      render :action => 'edit'
    end
  end

  def destroy
    GalleryComment.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def comnt_list
      @hmm_user=HmmUsers.find(session[:hmm_user])
    
      if session[:friend]=='' 
      else 
        e_approval=" and e_approval = 'approve'"
      end
      
      if(request.request_uri == "/gallery_comment/comnt_list/" )
        @gal_c = GalleryComment.find_by_sql("select a.*,b.*,a.id as cid from gallery_comments as a , hmm_users as b where a.uid=b.id ORDER BY a.id DESC")
      else 
        if(params[:id]=='0')
         @update="me"
         @gal_c = GalleryComment.find_by_sql("select a.*,b.*,a.id as cid from gallery_comments as a , hmm_users as b where gallery_id='#{params[:gal_id]}' and gallery_jid=''  and a.uid=b.id #{e_approval} ORDER BY a.id DESC")
       else
          @update="me2"
         @gal_c = GalleryComment.find_by_sql("select a.*,b.*,a.id as cid from gallery_comments as a , hmm_users as b where gallery_jid='#{params[:id]}' and a.uid=b.id #{e_approval}  ORDER BY a.id DESC")
        end 
      end
    
  
  @gal_id=params[:gal_id]
    @id=params[:id]
    i=0
    for cn in @gal_c
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
    if(@page==@numberofpages)
      @nonext=1
    end
    
    if(@total<=3)
  @nonext=1
  end
  end
   
     if(request.request_uri == "/gallery_comment/comnt_list/" )
        @gal_c = GalleryComment.find_by_sql("select a.*,b.*,a.id as cid from gallery_comments as a , hmm_users as b where a.uid=b.id ORDER BY a.id DESC limit  #{x},#{y}")
      else 
        if(params[:id]=='0')
         @update="me"
         @gal_c = GalleryComment.find_by_sql("select a.*,b.*,a.id as cid from gallery_comments as a , hmm_users as b where gallery_id='#{params[:gal_id]}' and gallery_jid=''  and a.uid=b.id #{e_approval} ORDER BY a.id DESC limit  #{x},#{y}")
       else
          @update="me2"
         @gal_c = GalleryComment.find_by_sql("select a.*,b.*,a.id as cid from gallery_comments as a , hmm_users as b where gallery_jid='#{params[:id]}' and a.uid=b.id #{e_approval} ORDER BY a.id DESC limit  #{x},#{y}")
        end 
      end
  
    
      
   render :layout => false
 end
 
  def allcmt_list
      @hmm_user=HmmUsers.find(session[:hmm_user])
      items_per_page = 10
     
    @gallery_comment_pages, @gallery_comment = paginate :hmm_users, :per_page => items_per_page, :joins =>"as b, gallery_comments as a", :conditions=> "b.id=#{logged_in_hmm_user.id} and a.uid=b.id "
    render :layout => true
  end
  
  def jcomment_list
      @hmm_user=HmmUsers.find(session[:hmm_user])
    render :layout => false
  end
  
  def add_comment
     @hmm_user=HmmUsers.find(session[:hmm_user])
     @gallery_comment =GalleryComment.find(params[:cid])
      @gallery_comment['e_approval'] = 'approve'
      $notice_gca
      flash[:notice_gca] = 'Comments Approved Sucessfuly!!'
    @gallery_comment.save
    if(session['redirect']=='2')
      #redirect_to :controller => 'galleries', :action => 'gallery_fisheye', :id => session[:galery_id]
      redirect_to :controller => 'gallery_comment', :action => 'comnt_list', :gal_id => session[:galery_id], :page=>params[:page], :id => params[:id]
 
    else if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
    else
     # redirect_to :controller => 'customers', :action => 'chapter_gallery', :id => session[:galery_id]
    redirect_to :controller => 'gallery_comment', :action => 'comnt_list', :gal_id => session[:galery_id], :page=>params[:page], :id => params[:id]
 
    end 
  end
  end
   
  end
  
  def approve_cmt
     @hmm_user=HmmUsers.find(session[:hmm_user])
     @gallery_comment =GalleryComment.find(params[:id])
     @gallery_comment['e_approval'] = 'approve'
     @gallery_comment.save
     $notice_gca_list
      flash[:notice] = 'Gallery Comment Was Successfully Approved!!'
    
     redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
  end
  
  def approve_jcmt
     @hmm_user=HmmUsers.find(session[:hmm_user])
     @gallery_comment =GalleryComment.find(params[:id])
     @gallery_comment['e_approval'] = 'approve'
     @gallery_comment.save
     $notice_gca_jlist
      flash[:notice_gca_jlist] = 'Gallery Comment Was Successfully Approved!!'
    if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
    end
  end
  
  end
  
  def reject_comment
     @hmm_user=HmmUsers.find(session[:hmm_user])
     @gallery_comment =GalleryComment.find(params[:cid])
     @gallery_comment.destroy
    $notice_gcr
      flash[:notice_gcr] = 'Gallery Comment Rejected Successfully!!'
    if(session['redirect']=='2')
     # redirect_to :controller => 'galleries', :action => 'gallery_fisheye', :id => session[:galery_id]
          redirect_to :controller => 'gallery_comment', :action => 'comnt_list', :gal_id => session[:galery_id], :page=>params[:page], :id => params[:id]
 
    else if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
    else
     # redirect_to :controller => 'customers', :action => 'chapter_gallery', :id => session[:galery_id]
           redirect_to :controller => 'gallery_comment', :action => 'comnt_list', :gal_id => session[:galery_id], :page=>params[:page], :id => params[:id]
 
    end
  end
  end
   end
  
  def reject_cmt
     @hmm_user=HmmUsers.find(session[:hmm_user])
     @gallery_comment =GalleryComment.find(params[:id])
      @gallery_comment.destroy
    $notice_gcr_list
      flash[:notice] = 'Gallery Comment Rejected!!'
    
    redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
   end
  
  def reject_jcmt
     @hmm_user=HmmUsers.find(session[:hmm_user])
     @gallery_comment =GalleryComment.find(params[:id])
      @gallery_comment.destroy
    $notice_gcr_jlist
      flash[:notice_gcr_jlist] = 'Gallery Comment Rejected!!'
     if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
        
    end
    end
   end
  
  def comt_destroy
    @gallery_comment =GalleryComment.find(params[:cid])
    @gallery_comment.destroy
    $notice_gcd
      flash[:notice_gcd] = 'Gallery Comment Deleted Successfully!!'
     if(session['redirect']=='2')
    #  redirect_to :controller => 'galleries', :action => 'gallery_fisheye', :id => session[:galery_id]
        redirect_to :controller => 'gallery_comment', :action => 'comnt_list', :gal_id => session[:galery_id], :page=>params[:page], :id => params[:id]
 
    else if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
    else
      #redirect_to :controller => 'customers', :action => 'chapter_gallery', :id => session[:galery_id]
       redirect_to :controller => 'gallery_comment', :action => 'comnt_list', :gal_id => session[:galery_id], :page=>params[:page], :id => params[:id]
 
    end  
  end
  end
  end
  
  def destroy_cmt
    @gallery_comment =GalleryComment.find(params[:id])
    @gallery_comment.destroy
    $notice_gcd_list
      flash[:notice_gcd_list] = 'Gallery Comment Was Successfully Deleted!!'
    
    redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
  end
  
  def destroy_jcmt
    @gallery_comment =GalleryComment.find(params[:id])
    @gallery_comment.destroy
    $notice_gcd_jlist
      flash[:notice_gcd_jlist] = 'Gallery Comment Was Successfully Deleted!!'
    if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
    end
    
end
end
  
end
