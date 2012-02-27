class GuestCommentsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @guest_comment_pages, @guest_comments = paginate :guest_comments, :per_page => 10
  end

  def approve_jcmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @guest_comment =GuestComment.find(params[:id])
     @guest_comment['status'] = 'approve'
     @guest_comment.save
      $notice_cca_jlist
     flash[:notice_cca_jlist] = 'Guest Comment was Approved!!'
	 flash[:notice] = 'Guest Comment was Approved!!'
      if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
      else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list', :page =>params[:page]
      redirect_to :controller => 'my_familywebsite', :action => 'comments_list', :page =>params[:page]
    end
    end
  end

  def destroy_jcmt
    @guest_comment =GuestComment.find(params[:id])
    @guest_comment.destroy
    $notice_scd_jlist
      flash[:notice_cca_jlist] = 'Guest Comment was deleted successfully!!'
	  flash[:notice] = 'Guest Comment was deleted!!'
 if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
		else
		 redirect_to :controller => 'chapter_comment', :action => 'allcmt_list', :page =>params[:page]
      end
      end
        end

  def reject_jcmt
    @hmm_user=HmmUser.find(session[:hmm_user])
     @guest_comment =GuestComment.find(params[:id])
      @guest_comment.destroy
     # @guest_comment['e_approval'] = 'reject'
      #@tag_cid = GuestComment.find(:all, :conditions => "tag_jid=#{params[:id]} " , :order => "id DESC")
    #@guest_comment.save
    $notice_ccr_list
     flash[:notice_cca_jlist] = 'Guest Comment Rejected'
	 flash[:notice] = 'Guest Comment Rejected'
	 if(session['redirect']=='5')
    	 redirect_to :controller => 'chapter_journal', :action => 'journals'
	 else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list', :page=> params[:page]
    redirect_to :controller => 'my_familywebsite', :action => 'comments_list', :page=> params[:page]
	 end
   end

   def destroy_jcmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @guest_comment =GuestComment.find(params[:id])
      @guest_comment.destroy
     # @guest_comment['e_approval'] = 'reject'
      #@tag_cid = GuestComment.find(:all, :conditions => "tag_jid=#{params[:id]} " , :order => "id DESC")
    #@guest_comment.save
    $notice_ccr_list
     flash[:notice] = 'Guest Comment was removed!!'

	 if(session['redirect']=='5')
    	 redirect_to :controller => 'chapter_journal', :action => 'journals'
	 else
	#redirect_to :controller => 'chapter_comment', :action => 'allcmt_list', :page=>  params[:page]
  redirect_to :controller => 'my_familywebsite', :action => 'comments_list', :page=>  params[:page]
	 end
   end

  def show
    @guest_comment = GuestComment.find(params[:id])
  end

  def new
    @guest_comment = GuestComment.new
     render(:layout => false)
  end

  def create
    @guest_comment = GuestComment.new(params[:guest_comment])
	hmm_user=HmmUser.find(:all, :conditions => " family_name='#{params[:familyname]}'")
	@guest_comment['uid'] = hmm_user[0]['id']
    @guest_comment['journal_typeid'] = params[:typeid]
    @guest_comment['journal_id'] = params[:journalid]
    @guest_comment['journal_type'] = params[:journaltype]
    @guest_comment['comment_date'] = Time.now
    @guest_comment['ctype'] = 'guest_comment'

    if @guest_comment.save
      $notice_guest
      Postoffice.deliver_comment(params[:guest_comment][:comment],'0','guest comment',params[:guest_comment][:name],'',hmm_user[0].v_user_name,hmm_user[0].v_e_mail,hmm_user[0].v_myimage,hmm_user[0].img_url)

      flash[:notice_guest] = 'Comment was successfully sent...'
      redirect_to :controller =>'my_familywebsite', :action => 'journals', :id => params[:familyname]
    else
      render :action => 'new'
    end
  end

  def edit
    @guest_comment = GuestComment.find(params[:id])
  end

  def update
    @guest_comment = GuestComment.find(params[:id])
    if @guest_comment.update_attributes(params[:guest_comment])
      flash[:notice] = 'GuestComment was successfully updated.'
      redirect_to :action => 'show', :id => @guest_comment
    else
      render :action => 'edit'
    end
  end

  def destroy
    GuestComment.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end