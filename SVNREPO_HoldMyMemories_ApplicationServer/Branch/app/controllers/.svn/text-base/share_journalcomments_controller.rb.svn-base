class ShareJournalcommentsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @share_journalcomment_pages, @share_journalcomments = paginate :share_journalcomments, :per_page => 10
  end

  def show
    @share_journalcomment = ShareJournalcomment.find(params[:id])
  end

  def new
    @share_journalcomment = ShareJournalcomment.new
    render :layout => false
  end

  def create
    @share_journalcomment = ShareJournalcomment.new(params[:share_journalcomment])
    @share_journalcomment['shareid'] = params[:shareid]
    @share_journalcomment['journal_id'] = params[:journalid]
    @share_journalcomment['journal_type'] = params[:journaltype]
    @share_journalcomment['status'] = 'pending'
    @share_journalcomment['comment_date'] = Time.now
    @share_journalcomment['ctype'] = 'shareJournal'
    if @share_journalcomment.save
      $noticenonhmm_jcmt
      flash[:noticenonhmm_jcmt] = 'Journal Comment was successfully sent..'
      redirect_to :controller => 'share', :action => 'shareJournal_nonhmm', :id => params[:re_directid]
    else
      render :action => 'new'
    end
  end

  def edit
    @share_journalcomment = ShareJournalcomment.find(params[:id])
  end

  def update
    @share_journalcomment = ShareJournalcomment.find(params[:id])
    if @share_journalcomment.update_attributes(params[:share_journalcomment])
      flash[:notice] = 'ShareJournalcomment was successfully updated.'
      redirect_to :action => 'show', :id => @share_journalcomment
    else
      render :action => 'edit'
    end
  end

  def destroy
    ShareJournalcomment.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def approve_cmt
     @hmm_user=HmmUsers.find(session[:hmm_user])
     @share_journalcomment =ShareJournalcomment.find(params[:id])
     @share_journalcomment.status = 'accepted'
     @share_journalcomment.save
      $notice_cca_list
     flash[:notice_cca_list] = 'Shared Journal Comment Approved!!'
     if(session['redirect']=='5')
     redirect_to :controller => 'chapter_journal', :action => 'journals'
     else
     redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
     end
 end
 
 def reject_cmt
     @hmm_user=HmmUsers.find(session[:hmm_user])
     @share_comment =ShareJournalcomment.find(params[:id])
      
      #@tag_cid = ChapterComment.find(:all, :conditions => "tag_jid=#{params[:id]} " , :order => "id DESC")
    @share_comment.destroy
    $notice_ccr_list
     flash[:notice] = 'Shared Journal Comment Rejected!!'
     if(session['redirect']=='5')
     redirect_to :controller => 'chapter_journal', :action => 'journals'
     else
     redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
     end
   end
  
  
  def destroy_cmt
    @share_comment =ShareJournalcomment.find(params[:id])
    @share_comment.destroy
    $notice_ccd_list
     flash[:notice_ccd_list] = 'Shared Journal Comment Deleted!!'
     if(session['redirect']=='5')
     redirect_to :controller => 'chapter_journal', :action => 'journals'
     else
    redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      end
  end
  
   def reply_comnt
    render :layout => false
   end
  
   def reply_comment
    @hmm_user=HmmUsers.find(session[:hmm_user])
     if(params[:table]=='chapter_comments')
      @chapter_comment =ChapterComment.find(params[:cid])
    else
       if(params[:table]=='subchap_comments')
      @chapter_comment =SubchapComment.find(params[:cid])
    else
        if(params[:table]=='gallery_comments')
         @chapter_comment =GalleryComment.find(params[:cid])
    else
        if(params[:table]=='photo_comments')
         @chapter_comment =PhotoComment.find(params[:cid])     
    else
        if(params[:table]=='share_journalcomments')
         @chapter_comment =ShareJournalcomment.find(params[:cid])   
    end
    end
  end
end
end
     @chapter_comment['Reply'] = params[:reply]
     @chapter_comment.save
     $notice_cca
     flash[:notice_cca] = 'Reply added sucessfully!!'
     #@tag = ChapterComment.find_by_sql(:all, :conditions => 'id=#{params[:id]}')
     #@tag = ChapterComment.find_by_sql("select tag_id from chapter_comments where id=#{params[:id]} ")
#     if(request.request_uri == "/chapter_comment/comnt_list/" )
#        redirect_to :controller => 'chapter_comment', :action => 'comnt_list'
#     else
     #redirect_to session[:redirect]
       if(session['redirect']=='2' && params[:table]=='chapter_comments' && session['redirect']!='5' && session['redirect_mange']!='1')
        redirect_to :controller => 'tags', :action => 'subchap_coverflow', :id => params[:tag_id]
      else
        if( params[:table]=='chapter_comments' && session['redirect']!='3' && session['redirect']!='5' && session['redirect_mange']!='1')
        redirect_to :controller => 'customers', :action => 'chapter_next', :id => params[:tag_id]
      else
        if(session['redirect']=='2' && params[:table]=='subchap_comments' && session['redirect']!='5' && session['redirect_mange']!='1')
         redirect_to :controller => 'galleries', :action => 'gallery_coverflow', :id => params[:tag_id]
        else
        if( params[:table]=='subchap_comments' && session['redirect']!='3' && session['redirect']!='5' && session['redirect_mange']!='1')
          redirect_to :controller => 'customers', :action => 'sub_chapter_gallery', :id =>  params[:tag_id]
        
        else
        if(session['redirect']=='2' && params[:table]=='gallery_comments' && session['redirect']!='3' && session['redirect_mange']!='1')
         redirect_to :controller => 'galleries', :action => 'gallery_fisheye', :id => params[:tag_id]
        else
        if( params[:table]=='gallery_comments' && session['redirect']!='3' && session['redirect']!='5' && session['redirect_mange']!='1')
          redirect_to :controller => 'customers', :action => 'chapter_gallery', :id =>  params[:tag_id]
         else
        if(session['redirect']=='2' && params[:table]=='photo_comments' && session['redirect']!='5' && session['redirect_mange']!='1')
      redirect_to :controller => 'myphotos', :action => 'photo_journal' , :id => params[:tag_id]
       else
        if( params[:table]=='photo_comments' && session['redirect']!='3' && session['redirect']!='5' && session['redirect_mange']!='1')
          redirect_to :controller => 'myphotos', :action => 'photo_journal' , :id =>params[:tag_id]
        else
          if( session['redirect']=='7' )
          redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
        else
             if( session['redirect']=='5' && session['redirect_mange']!='1' )
          redirect_to :controller => 'chapter_journal', :action => 'journals', :page => params[:page]
          else     if( session['redirect_mange']=='1' && session['redirect']==''  )
          redirect_to :controller => 'customers', :action => 'manage', :page => params[:page]
        end
      
        end
        end 
        end 
        end 
        end 
        end 
      end
      end
    end
    end
  end
  
end
