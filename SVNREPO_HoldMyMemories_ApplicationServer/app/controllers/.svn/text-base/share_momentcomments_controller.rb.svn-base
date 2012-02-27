class ShareMomentcommentsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @share_momentcomment_pages, @share_momentcomments = paginate :share_momentcomments, :per_page => 10
  end

  def show
    @share_momentcomment = ShareMomentcomment.find(params[:id])
  end

  def new
    @share_momentcomment = ShareMomentcomment.new
    render :layout => false
  end

  def create
    @share_momentcomment = ShareMomentcomment.new(params[:share_momentcomment])
    @share_momentcomment['name']=logged_in_hmm_user.v_fname
    @share_momentcomment['uid']=logged_in_hmm_user.id
#    @share_momentcomment['comment']=params[:comment]
    @share_momentcomment['share_id']=params[:shareid]
    @share_momentcomment['added_date']=Time.now
    @share_momentcomment['ctype']='sharemoment_comment'
#    @share_momentcomment['reply']=''
    if @share_momentcomment.save
      $notice_sharemoment
      flash[:notice_sharemoment] = 'Your comment has been sent to'
      redirect_to :controller => 'share_moments', :action => 'shareMoment_view', :id => params[:shareid]
    else
      render :action => 'new'
    end
  end
  
   def create_cmt
    @share_momentcomment = ShareMomentcomment.new()
    @share_momentcomment['name']=logged_in_hmm_user.v_fname
    @share_momentcomment['uid']=logged_in_hmm_user.id
    @share_momentcomment['comment']=params[:share_momentcomments][:comment]
    @share_momentcomment['share_id']=params[:shareid]
    @share_momentcomment['added_date']=Time.now
    @share_momentcomment['ctype']='sharemoment_comment'
#    @share_momentcomment['reply']=''
    if @share_momentcomment.save
      $notice_sharemoment
      flash[:notice_sharemoment] = 'Your comment has been sent to'
      redirect_to :controller => 'share_moments', :action => 'shareMoment_view', :id => params[:shareid]
    else
      render :action => 'new'
    end
  end


  def new_nonhmm
    @share_momentcomment = ShareMomentcomment.new
    render :layout => false
  end

  def create_nonhmm
    @share_momentcomment = ShareMomentcomment.new(params[:share_momentcomment])
    
    @share_momentcomment['uid']=0
#    @share_momentcomment['comment']=params[:comment]
    @share_momentcomment['share_id']= session['shareid']
    @share_momentcomment['added_date']=Time.now
    @share_momentcomment['ctype']='sharemoment_comment'
#    @share_momentcomment['reply']=''
    if @share_momentcomment.save
      $notice_sharemoment
      flash[:notice_sharemoment] = 'Your comment has been sent to'
      redirect_to :controller => 'share', :action => 'shareMoment_nonhmm', :id => params[:unid]
    else
      render :action => 'new'
    end
  end

  def edit
    @share_momentcomment = ShareMomentcomment.find(params[:id])
  end

  def update
    @share_momentcomment = ShareMomentcomment.find(params[:id])
    if @share_momentcomment.update_attributes(params[:share_momentcomment])
      flash[:notice] = 'ShareMomentcomment was successfully updated.'
      redirect_to :action => 'show', :id => @share_momentcomment
    else
      render :action => 'edit'
    end
  end

  def destroy
    ShareMomentcomment.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def approve_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     if(session['redirect']=='22')
     @share_comment =ShareMomentcomment.find(params[:cid])
   else
     @share_comment =ShareMomentcomment.find(params[:id])
     end
     @share_comment['e_approved'] = 'approved'
     @share_comment.save
      $notice_acceptcmt
     flash[:notice_acceptcmt] = 'Shared Moment Comment Approved!!'
     if(session['redirect']=='22')
        redirect_to :controller => 'photo_comments', :action => 'photo_comnt', :id => session[:usercontent_id1], :page1=>params[:page1], :id_journal => params[:id_journal]
     else
        #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
        redirect_to :controller => 'my_familywebsite', :action => 'comments_list'
     end
 end
 
 def reject_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     if(session['redirect']=='22')
     @share_comment =ShareMomentcomment.find(params[:cid])
   else
     @share_comment =ShareMomentcomment.find(params[:id])
     end
     
      
      #@tag_cid = ChapterComment.find(:all, :conditions => "tag_jid=#{params[:id]} " , :order => "id DESC")
    @share_comment.destroy
    $notice_rejectcmt
     flash[:notice] = 'Shared Moment Comment Rejected!!'
     if(session['redirect']=='22')
        redirect_to :controller => 'photo_comments', :action => 'photo_comnt', :id => session[:usercontent_id1], :page1=>params[:page1], :id_journal => params[:id_journal]
     else
       # redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
       redirect_to :controller => 'my_familywebsite', :action => 'comments_list'
     end
   end
  
  def destroy_cmt
    if(session['redirect']=='22')
     @share_comment =ShareMomentcomment.find(params[:cid])
   else
    @share_comment =ShareMomentcomment.find(params[:id])
    end
    @share_comment.destroy
    $notice_smtdestroy
     flash[:notice_smtdestroy] = 'Shared Moment Comment Deleted!!'
      if(session['redirect']=='22')
        redirect_to :controller => 'photo_comments', :action => 'photo_comnt', :id => session[:usercontent_id1], :page1=>params[:page1], :id_journal => params[:id_journal]
     else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'my_familywebsite', :action => 'comments_list'
    end
  end
  
  def reply_comnt
  render :layout => false
    
  end
  
  def reply_comment
     @hmm_user=HmmUser.find(session[:hmm_user])
     
      @chapter_comment =ShareMomentcomment.find(params[:cid])
      @chapter_comment['reply'] = params[:reply]
      @chapter_comment.save
      $notice_cca
      flash[:notice_cca] = 'Reply added successfully!!'
      redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
  end

  
end
