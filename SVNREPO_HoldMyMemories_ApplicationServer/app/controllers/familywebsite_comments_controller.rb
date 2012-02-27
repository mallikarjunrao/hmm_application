class FamilywebsiteCommentsController < ApplicationController
  layout 'familywebsite'
  require 'will_paginate'
  before_filter  :check_account
  #method to check whether the family name in the url is valid or invalid
  #if family name doesn't exist, redirects to hmm home page
  #if user is blocked, displays message
  #if user didn't agee for terms of use,
  # => if the user is not logged in, takes to login page
  # => if the user is logged in, takes to agree terms page
  def check_account
    unless params[:id].blank?
      @family_website_owner = HmmUser.find(:first,:joins =>"INNER JOIN themes on hmm_users.theme_id=themes.id", :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')",:select => "hmm_users.*,themes.stylesheet as theme") #get the user details
      if @family_website_owner
        if(session[:employe]==nil && @family_website_owner.terms_checked == 'false' ) #if the logged in user is not employee and terms is not agreed
          flash[:terms] = 'terms'
          if(session[:hmm_user]) #f the user is logged in, takes to agree terms page
            redirect_to "/user_account/update_terms/"
          else #if the user is not logged in, takes to login page
            redirect_to "/familywebsite/login/#{params[:id]}" if params[:action]!='login'
          end
        elsif @family_website_owner.e_user_status=='blocked' #displays message, if the user is blocked
          render :text => "This Familywebsite has been Blocked. Please contact Website Administrator at <a href='mailto:admin@holdmymemories.com' >admin@HoldMyMemories.com</a>"
        elsif session[:visitor]==nil && session[:hmm_user]==nil && @family_website_owner.password_required == 'yes'
          #render :text =>"Password protected. Redirect to family website login page"
          redirect_to :controller =>"familywebsite", :action => 'visitor_login', :id => params[:id], :redirect_url => request.url if (params[:action]!='login' && params[:action]!='visitor_login')
        elsif (!session[:hmm_user] || logged_in_hmm_user.id!=@family_website_owner.id) && (params[:action]!='create_chapter_comment' && params[:action]!='create_subchapter_comment' && params[:action]!='create_gallery_comment' && params[:action]!='create_moment_comment')
          redirect_to "/familywebsite/login/#{params[:id]}"
        else
          @path = ContentPath.find(:first, :conditions => "status='active'")
          @content_server_url = @path.content_path
          return true #returns true if all the conditions are cleared
        end
      else
        redirect_to '/'
      end
    end
  end

  def create_chapter_comment
    unless params[:chapter_comment].blank?
      if verify_recaptcha
        @chapter_comment = ChapterComment.new(params[:chapter_comment])
        @chapter_comment['uid']= @family_website_owner.id
        @chapter_comment['tag_jid']= 0
        @chapter_comment['d_created_on']=Time.now
        if @chapter_comment.save
          Postoffice.deliver_comment(params[:chapter_comment][:v_comment],'0','Chapter',params[:chapter_comment][:v_name],@family_website_owner.v_e_mail,@family_website_owner.v_user_name,@family_website_owner.v_e_mail,@family_website_owner.v_myimage,@family_website_owner.img_url)
          flash[:notice] = 'Thank-you for adding your comment!'
        end
      else
        flash[:error] = 'Please enter the correct code!'
      end
    end
    render :layout => false
  end

  def create_subchapter_comment
    unless params[:subchap_comment].blank?
      if verify_recaptcha
        @subchap_comment = SubchapComment.new(params[:subchap_comment])
        @subchap_comment['uid']= @family_website_owner.id
        @subchap_comment['subchap_id']= params[:subchapter_id]
        @subchap_comment['subchap_jid']= 0
        @subchap_comment['d_created_on']=Time.now
        if @subchap_comment.save
          Postoffice.deliver_comment(params[:subchap_comment][:v_comments],'0','sub_chapter',params[:subchap_comment][:v_name],@family_website_owner.v_e_mail,@family_website_owner.v_user_name,@family_website_owner.v_e_mail,@family_website_owner.v_myimage,@family_website_owner.img_url)
          flash[:notice] = 'Thank-you for adding your comment!'
        end
       else
        flash[:error] = 'Please enter the correct code!'
      end
    end
    render :layout => false
  end

  def create_gallery_comment
    unless params[:gallery_comment].blank?
      if verify_recaptcha
        @gallery_comment = GalleryComment.new(params[:gallery_comment])
        @gallery_comment['uid']= @family_website_owner.id
        @gallery_comment['gallery_jid']= 0
        @gallery_comment['d_created_on']=Time.now
        if @gallery_comment.save
          Postoffice.deliver_comment(params[:gallery_comment][:v_comment],'0','gallery',params[:gallery_comment][:v_name],@family_website_owner.v_e_mail,@family_website_owner.v_user_name,@family_website_owner.v_e_mail,@family_website_owner.v_myimage,@family_website_owner.img_url)
          flash[:notice] = 'Thank-you for adding your comment!'
        end
       else
        flash[:error] = 'Please enter the correct code!'
      end
    end
    render :layout => false
  end

  def create_moment_comment
    unless params[:moment_comment].blank?
      if verify_recaptcha
        @moment_comment = PhotoComment.new(params[:moment_comment])
        @moment_comment['uid']= @family_website_owner.id
        @moment_comment['d_add_date']=Time.now
        if @moment_comment.save
          Postoffice.deliver_comment(params[:moment_comment][:v_comment],'0','Photo',params[:moment_comment][:v_name],@family_website_owner.v_e_mail,@family_website_owner.v_user_name,@family_website_owner.v_e_mail,@family_website_owner.v_myimage,@family_website_owner.img_url)
          flash[:notice] = 'Thank-you for adding your comment!'
        end
       else
        flash[:error] = 'Please enter the correct code!'
      end
    end
    render :layout => false
  end

  #Old view
#  def view
#    @current_item="comments"
#    @hmm_user=HmmUser.find(session[:hmm_user])
#
#    uid1=logged_in_hmm_user.id
#
#    tagcout = Tag.find_by_sql(" select
#         count(*) as cnt
#         from chapter_comments  as a,tags as t
#         where
#         a.tag_id=t.id
#         and
#         t.uid=#{uid1} ")
#    subcount = SubChapter.find_by_sql("
#       select
#        count(*) as cnt
#        from
#        subchap_comments   as b,
#        sub_chapters as s
#        where
#        s.uid=#{uid1}
#        and
#        b.subchap_id=s.id ")
#    galcount = Galleries.find_by_sql("select
#        count(*) as cnt
#        from
#        gallery_comments    as c,
#        galleries as g,
#        sub_chapters as s1
#        where
#        s1.uid=#{uid1}
#        and
#        c.gallery_id=g.id
#        and g.subchapter_id=s1.id ")
#
#    usercontentcount = UserContent.find_by_sql("
#  select
#       count(*) as cnt
#        from
#        photo_comments   as d,
#        user_contents as u
#        where
#        d.user_content_id=u.id and u.uid=#{uid1}
#
#  ")
#    sharecount = Share.find_by_sql("
#  select
#       count(*) as cnt
#        from
#        share_comments    as d,
#        shares as u
#        where
#        d.share_id =u.id and u.presenter_id=#{uid1}
#
#  ")
#    sharejournalcnt = ShareJournal.find_by_sql("
#  select
#    count(*) as cnt
#    from
#    share_journalcomments as d,
#    share_journals as u
#    where
#    d.shareid = u.id and u.presenter_id=#{uid1}
#    ")
#
#
#    guestmessagecount = MessageBoard.count(:all, :conditions => "uid=#{uid1}")
#
#    guestcommentcount = GuestComment.find_by_sql("
#    select
#    count(*) as cnt
#    from
#    guest_comments
#    where
#    uid=#{uid1}
#    ")
#
#    guestcommentcnt=Integer(guestcommentcount[0].cnt)
#    galcnt=Integer(galcount[0].cnt)
#    tagcnt=Integer(tagcout[0].cnt)
#    subcnt=Integer(subcount[0].cnt)
#    usercontentcnt=Integer(usercontentcount[0].cnt)
#    sharecnt=Integer(sharecount[0].cnt)
#    sharejournalcnt=Integer(sharejournalcnt[0].cnt)
#
#    @total=tagcnt+subcnt+galcnt+usercontentcnt+sharecnt+sharejournalcnt+guestcommentcnt+guestmessagecount
#
#    @numberofpagesres=@total/10
#
#    @numberofpages=@numberofpagesres.round()
#
#    if(params[:page]==nil)
#      x=0
#      y=10
#      @page=0
#      @nextpage=1
#      if(@total<10)
#
#        @nonext=1
#      end
#    else
#      x=10*Integer(params[:page])
#      y=10
#      @page=Integer(params[:page])
#      @nextpage=@page+1
#      @previouspage=@page-1
#      if(@page==@numberofpages)
#        @nonext=1
#      end
#
#    end
#
#
#    @tagid=ChapterComment.find_by_sql("
#   (select
#
#         a.id as id,
#         a.tag_id as master_id,
#         a.v_comment as comment,
#         a.reply as reply,
#         a.e_approval as e_approval,
#         a.ctype as ctype,
#         a.v_name as name,
#         a.uid as user_id,
#         a.d_created_on as d_created_at
#         from chapter_comments as a,tags as t
#         where
#         a.tag_id=t.id
#         and
#
#         t.uid=#{uid1}
#     )
#     union
#     (select
#
#        b.id as id,
#        b.subchap_id as master_id,
#        b.v_comments as comment,
#        b.reply as reply,
#        b.e_approval as e_approval,
#        b.ctype as ctype,
#        b.v_name as name,
#        b.uid as user_id,
#        b.d_created_on as d_created_at
#        from
#        subchap_comments   as b,
#        sub_chapters as s
#        where
#        s.uid=#{uid1}
#        and
#        b.subchap_id=s.id
#     )
#     union
#     (select
#        c.id as id,
#        c.gallery_id as master_id,
#        c.v_comment as comment,
#        c.reply as reply,
#        c.e_approval as e_approval,
#        c.ctype as ctype,
#        c.v_name as name,
#        c.uid as user_id,
#        c.d_created_on as d_created_at
#        from
#        gallery_comments    as c,
#        galleries as g,
#        sub_chapters as s1
#        where
#        s1.uid=#{uid1}
#        and
#        c.gallery_id=g.id
#        and g.subchapter_id=s1.id)
#     union
#    (select
#        d.id as id,
#        d.user_content_id as master_id,
#        d.v_comment as comment,
#        d.reply as reply,
#        d.e_approved as e_approval,
#        d.ctype as ctype,
#        d.v_name as name,
#        d.uid as user_id,
#        d.d_add_date as d_created_at
#        from
#        photo_comments  as d,
#        user_contents as u
#        where
#        d.user_content_id=u.id
#        and
#        u.uid=#{uid1}
#     )
#     union
#    (select
#        d.id as id,
#        d.share_id as master_id,
#        d.comment as comment,
#        d.reply as reply,
#        d.e_approved as e_approval,
#        d.reply as ctype,
#        d.name as name,
#        d.uid as user_id,
#        d.d_add_date as d_add_date
#        from
#        share_comments as d,
#        shares as s
#        where
#        d.share_id=s.id
#        and
#        s.presenter_id=#{uid1}
#     )
#     union
#    (select
#        p.id as id,
#        p.share_id as master_id,
#        p.comment as comment,
#        p.reply as reply,
#        p.e_approved as e_approval,
#        p.ctype as ctype,
#        p.name as name,
#        p.uid as user_id,
#        p.added_date as d_add_date
#        from
#        share_momentcomments as p,
#        share_moments as q
#        where
#        p.share_id=q.id
#        and
#        q.presenter_id=#{uid1}
#     )
#      union
#    (select
#        r.id as id,
#        r.shareid as master_id,
#        r.comment as comment,
#        r.reply as reply,
#        r.status as e_approval,
#        r.ctype as ctype,
#        r.name as name,
#        r.id as user_id,
#        r.comment_date as d_add_date
#        from
#        share_journalcomments as r,
#        share_journals as z
#        where
#        r.shareid=z.id
#        and
#        z.presenter_id=#{uid1}
#     )
#     union
#    (select
#        g.id as id,
#        g.journal_typeid as master_id,
#        g.comment as comment,
#        g.ctype as reply,
#        g.status as e_approval,
#        g.ctype as ctype,
#        g.name as name,
#        g.uid as user_id,
#        g.comment_date as d_add_date
#        from
#        guest_comments as g
#        where
#        g.uid=#{uid1}
#     )
#     union
#    (select
#        h.id as id,
#        h.uid as master_id,
#        h.message as message,
#        h.reply as reply,
#        h.status as e_approval,
#        h.ctype as ctype,
#        h.guest_name as name,
#        h.uid as user_id,
#        h.created_at as d_created_at
#        from
#        message_boards as h
#        where
#        h.uid=#{uid1}
#     )
#     order by d_created_at desc limit #{x}, #{y} ")
#
#
#
#    puts x
#    puts y
#
#
#    if(params[:page]==nil)
#    else
#      render :layout => false
#    end
#  end

  def view
    @current_item="comments"
    @hmm_user=HmmUser.find(session[:hmm_user])

    uid1=logged_in_hmm_user.id

    tagcout = Tag.find_by_sql(" select
         count(*) as cnt
         from chapter_comments  as a,tags as t
         where
         a.tag_id=t.id
         and
         t.uid=#{uid1} ")
    subcount = SubChapter.find_by_sql("
       select
        count(*) as cnt
        from
        subchap_comments   as b,
        sub_chapters as s
        where
        s.uid=#{uid1}
        and
        b.subchap_id=s.id ")
    galcount = Galleries.find_by_sql("select
        count(*) as cnt
        from
        gallery_comments    as c,
        galleries as g,
        sub_chapters as s1
        where
        s1.uid=#{uid1}
        and
        c.gallery_id=g.id
        and g.subchapter_id=s1.id ")

    usercontentcount = UserContent.find_by_sql("
  select
       count(*) as cnt
        from
        photo_comments   as d,
        user_contents as u
        where
        d.user_content_id=u.id and u.uid=#{uid1}

  ")
    sharecount = Share.find_by_sql("
  select
       count(*) as cnt
        from
        share_comments    as d,
        shares as u
        where
        d.share_id =u.id and u.presenter_id=#{uid1}

  ")
    sharejournalcnt = ShareJournal.find_by_sql("
  select
    count(*) as cnt
    from
    share_journalcomments as d,
    share_journals as u
    where
    d.shareid = u.id and u.presenter_id=#{uid1}
    ")


    guestmessagecount = MessageBoard.count(:all, :conditions => "uid=#{uid1}")

    guestcommentcount = GuestComment.find_by_sql("
    select
    count(*) as cnt
    from
    guest_comments
    where
    uid=#{uid1}
    ")

    blogcomment=BlogComment.count(:joins=>" as bc , blogs as b , hmm_users as h",:conditions=>" b.id=bc.blog_id and
        b.user_id=h.id and
        h.id=#{uid1}")

    guestcommentcnt=Integer(guestcommentcount[0].cnt)
    galcnt=Integer(galcount[0].cnt)
    tagcnt=Integer(tagcout[0].cnt)
    subcnt=Integer(subcount[0].cnt)
    usercontentcnt=Integer(usercontentcount[0].cnt)
    sharecnt=Integer(sharecount[0].cnt)
    sharejournalcnt=Integer(sharejournalcnt[0].cnt)
    bcnt=Integer(blogcomment)

    @total=tagcnt+subcnt+galcnt+usercontentcnt+sharecnt+sharejournalcnt+guestcommentcnt+guestmessagecount+bcnt

    @numberofpagesres=@total/10

    @numberofpages=@numberofpagesres.round()

    if(params[:page]==nil)
      x=0
      y=10
      @page=0
      @nextpage=1
      if(@total<10)

        @nonext=1
      end
    else
      x=10*Integer(params[:page])
      y=10
      @page=Integer(params[:page])
      @nextpage=@page+1
      @previouspage=@page-1
      if(@page==@numberofpages)
        @nonext=1
      end

    end


    @tagid=ChapterComment.find_by_sql("
   (select

         a.id as id,
         a.tag_id as master_id,
         a.v_comment as comment,
         a.reply as reply,
         a.e_approval as e_approval,
         a.ctype as ctype,
         a.v_name as name,
         a.uid as user_id,
         a.d_created_on as d_created_at
         from chapter_comments as a,tags as t
         where
         a.tag_id=t.id
         and

         t.uid=#{uid1}
     )
     union
     (select

        b.id as id,
        b.subchap_id as master_id,
        b.v_comments as comment,
        b.reply as reply,
        b.e_approval as e_approval,
        b.ctype as ctype,
        b.v_name as name,
        b.uid as user_id,
        b.d_created_on as d_created_at
        from
        subchap_comments   as b,
        sub_chapters as s
        where
        s.uid=#{uid1}
        and
        b.subchap_id=s.id
     )
     union
     (select
        c.id as id,
        c.gallery_id as master_id,
        c.v_comment as comment,
        c.reply as reply,
        c.e_approval as e_approval,
        c.ctype as ctype,
        c.v_name as name,
        c.uid as user_id,
        c.d_created_on as d_created_at
        from
        gallery_comments    as c,
        galleries as g,
        sub_chapters as s1
        where
        s1.uid=#{uid1}
        and
        c.gallery_id=g.id
        and g.subchapter_id=s1.id)
     union
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
     )
     union
    (select
        d.id as id,
        d.share_id as master_id,
        d.comment as comment,
        d.reply as reply,
        d.e_approved as e_approval,
        d.reply as ctype,
        d.name as name,
        d.uid as user_id,
        d.d_add_date as d_add_date
        from
        share_comments as d,
        shares as s
        where
        d.share_id=s.id
        and
        s.presenter_id=#{uid1}
     )
     union
    (select
        p.id as id,
        p.share_id as master_id,
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
        q.presenter_id=#{uid1}
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
     )
     union
    (select
        g.id as id,
        g.journal_typeid as master_id,
        g.comment as comment,
        g.ctype as reply,
        g.status as e_approval,
        g.ctype as ctype,
        g.name as name,
        g.uid as user_id,
        g.comment_date as d_add_date
        from
        guest_comments as g
        where
        g.uid=#{uid1}
     )
     union
    (select
        h.id as id,
        h.uid as master_id,
        h.message as message,
        h.reply as reply,
        h.status as e_approval,
        h.ctype as ctype,
        h.guest_name as name,
        h.uid as user_id,
        h.created_at as d_created_at
        from
        message_boards as h
        where
        h.uid=#{uid1}
     )
     union
    (select
        b.id as id,
        b.blog_type_id as master_id,
        bc.comment as message,
        bc.id as reply,
        bc.status as e_approval,
        b.client as ctype,
        bc.name as name,
        h.id as user_id,
        bc.created_at as d_created_at
        from
        blog_comments as bc,
        blogs as b,
        hmm_users as h
        where b.id=bc.blog_id and
        b.user_id=h.id and
        h.id=#{uid1}
     )
     order by d_created_at desc limit #{x}, #{y} ")



    puts x
    puts y


    if(params[:page]==nil)
    else
      render :layout => false
    end
  end


  #chapter comments
def chapter_comment_approve_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @chapter_comment =ChapterComment.find(params[:comment_id])
     @chapter_comment['e_approval'] = 'approve'
     @chapter_comment.save
      $notice_cca_list
     flash[:message] = 'Chapter Comment was Approved!!'
    if(params[:jc]=='1')
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:id]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
    end

end

def chapter_comment_reject_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @chapter_comment =ChapterComment.find(params[:comment_id])
      @chapter_comment.destroy
     # @chapter_comment['e_approval'] = 'reject'
      #@tag_cid = ChapterComment.find(:all, :conditions => "tag_jid=#{params[:id]} " , :order => "id DESC")
    #@chapter_comment.save
    $notice_ccr_list
     flash[:message] = 'Chapter Comment Rejected'
     if(params[:jc]=='1')
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:id]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller =>'familywebsite_comments', :action => 'view' ,:id => params[:id]
    end

   end

def chapter_comment_destroy_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
    @chapter_comment =ChapterComment.find(params[:comment_id])
    @chapter_comment.destroy
    $notice_ccd_list
     flash[:message] = 'Chapter Comment was Deleted!!'
    if(params[:jc]=='1')
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:id]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
    end
end

  #sub chapter comments
 def subchap_comment_approve_cmt
      @hmm_user=HmmUser.find(session[:hmm_user])
       @chapter_comment =SubchapComment.find(params[:comment_id])
        @chapter_comment['e_approval'] = 'approve'
      @chapter_comment.save
      $notice_sca_list
        flash[:message] = 'Sub-Chapter Comment Was Successfully Approved!!'
     if(params[:jc]=='1')
    redirect_to :controller => 'familywebsite_comments', :action => 'manage_journals_details' ,:id => params[:id]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
    end
 end

  def subchap_comment_reject_cmt
      @hmm_user=HmmUser.find(session[:hmm_user])
       @chapter_comment =SubchapComment.find(params[:comment_id])
       @chapter_comment.destroy
      $notice_scr_list
        flash[:message] = 'Sub-Chapter Comment was Rejected'
     if(params[:jc]=='1')
    redirect_to :controller => 'familywebsite_comments', :action => 'manage_journals_details' ,:id => params[:id]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
    end
 end

  def subchap_comment_destroy_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
      @chapter_comment =SubchapComment.find(params[:comment_id])
      @chapter_comment.destroy
      $notice_scd_list
        flash[:message] = 'Sub-Chapter Comment Was Successfully Deleted!!'
     if(params[:jc]=='1')
    redirect_to :controller => 'familywebsite_comments', :action => 'manage_journals_details' ,:id => params[:id]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
    end
  end

#gallery comments
def gallery_comment_approve_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @gallery_comment =GalleryComment.find(params[:comment_id])
     @gallery_comment['e_approval'] = 'approve'
     @gallery_comment.save
     $notice_gca_list
      flash[:message] = 'Gallery Comment Was Successfully Approved!!'

     if(params[:jc]=='1')
    redirect_to :controller => 'familywebsite_comments', :action => 'manage_journals_details' ,:id => params[:id]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
    end
end

 def gallery_comment_reject_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @gallery_comment =GalleryComment.find(params[:comment_id])
      @gallery_comment.destroy
    $notice_gcr_list
      flash[:message] = 'Gallery Comment Rejected!!'

   if(params[:jc]=='1')
    redirect_to :controller => 'familywebsite_comments', :action => 'manage_journals_details' ,:id => params[:id]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
    end
   end

 def gallery_comment_destroy_cmt

@hmm_user=HmmUser.find(session[:hmm_user])
    @gallery_comment =GalleryComment.find(params[:comment_id])
    @gallery_comment.destroy
    $notice_gcd_list
      flash[:notice_gcd_list] = 'Gallery Comment Was Successfully Deleted!!'

    if(params[:jc]=='1')
    redirect_to :controller => 'familywebsite_comments', :action => 'manage_journals_details' ,:id => params[:id]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
    end
  end

#photo comments
def photo_comments_approve_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @comment =PhotoComment.find(params[:comment_id])
    @comment['e_approved'] = 'approve'
    @comment.save
    $notice_pca_list
      flash[:message] = 'Photo Comment was Successfully Approved!!'
     if(params[:jc]=='1')
    redirect_to :controller => 'familywebsite_comments', :action => 'manage_journals_details' ,:id => params[:id]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
    end
 end

 def photo_comments_reject_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
    @comment =PhotoComment.find(params[:comment_id])
     @comment.destroy
    $notice_pcr_list
    flash[:message] = 'Photo Comment Rejected'
    if(params[:jc]=='1')
    redirect_to :controller => 'familywebsite_comments', :action => 'manage_journals_details' ,:id => params[:id]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
    end
  end

def photo_comments_destroy_cmt

@hmm_user=HmmUser.find(session[:hmm_user])
    @comment =PhotoComment.find(params[:comment_id])
    @comment.destroy
    $notice_pcd_list
      flash[:message] = 'Photo Comment was Successfully Deleted!!'
    if(params[:jc]=='1')
    redirect_to :controller => 'familywebsite_comments', :action => 'manage_journals_details' ,:id => params[:id]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
    end
  end

  # share journal comments
  def share_journalcomments_approve_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @share_journalcomment =ShareJournalcomment.find(params[:comment_id])
     @share_journalcomment.status = 'accepted'
     @share_journalcomment.save
      $notice_cca_list
     flash[:message] = 'Shared Journal Comment Approved!!'
     if(params[:jc]=='1')
    redirect_to :controller => 'familywebsite_comments', :action => 'manage_journals_details' ,:id => params[:id]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
    end
 end

 def share_journalcomments_reject_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @share_comment =ShareJournalcomment.find(params[:comment_id])

      #@tag_cid = ChapterComment.find(:all, :conditions => "tag_jid=#{params[:id]} " , :order => "id DESC")
    @share_comment.destroy
    $notice_ccr_list
     flash[:message] = 'Shared Journal Comment Rejected!!'
     if(params[:jc]=='1')
    redirect_to :controller => 'familywebsite_comments', :action => 'manage_journals_details' ,:id => params[:id]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
    end
   end

   def share_journalcomments_destroy_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])

    @share_comment =ShareJournalcomment.find(params[:comment_id])
    @share_comment.destroy
    $notice_ccd_list
     flash[:message] = 'Shared Journal Comment Deleted!!'
     if(params[:jc]=='1')
    redirect_to :controller => 'familywebsite_comments', :action => 'manage_journals_details' ,:id => params[:id]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
    end
  end

# Share Blog Comments
   def share_blog_approve_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @share_journalcomment =BlogComment.find(params[:comment_id])
     @share_journalcomment.status = 'approved'
     @share_journalcomment.save
      $notice_cca_list
     flash[:message] = 'Blog Comment Approved!!'
     if(params[:jc]=='1')
    redirect_to :controller => 'familywebsite_comments', :action => 'manage_journals_details' ,:id => params[:id]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
    end
 end

 def share_blog_reject_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @share_comment =BlogComment.find(params[:comment_id])

      #@tag_cid = ChapterComment.find(:all, :conditions => "tag_jid=#{params[:id]} " , :order => "id DESC")
    @share_comment.destroy
    $notice_ccr_list
     flash[:message] = 'Blog Comment Rejected!!'
     if(params[:jc]=='1')
    redirect_to :controller => 'familywebsite_comments', :action => 'manage_journals_details' ,:id => params[:id]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
    end
   end

   def share_blog_destroy_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])

    @share_comment =BlogComment.find(params[:comment_id])
    @share_comment.destroy
    $notice_ccd_list
     flash[:message] = 'Blog Comment Deleted!!'
     if(params[:jc]=='1')
    redirect_to :controller => 'familywebsite_comments', :action => 'manage_journals_details' ,:id => params[:id]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
    end
  end

# share moments controller

def share_momentcomments_approve_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     if(session['redirect']=='22')
     @share_comment =ShareMomentcomment.find(params[:cid])
   else
     @share_comment =ShareMomentcomment.find(params[:comment_id])
     end
     @share_comment['e_approved'] = 'approved'
     @share_comment.save
      $notice_acceptcmt
     flash[:notice_acceptcmt] = 'Shared Moment Comment Approved!!'
     if(session['redirect']=='22')
        redirect_to :controller => 'photo_comments', :action => 'photo_comnt', :id => session[:usercontent_id1], :page1=>params[:page1], :id_journal => params[:id_journal]
     else
        #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
        redirect_to :controller => 'familywebsite_comments', :action => 'view',:id => params[:id]
     end
 end

def share_momentcomments_reject_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     if(session['redirect']=='22')
     @share_comment =ShareMomentcomment.find(params[:cid])
   else
     @share_comment =ShareMomentcomment.find(params[:comment_id])
     end


      #@tag_cid = ChapterComment.find(:all, :conditions => "tag_jid=#{params[:comment_id]} " , :order => "id DESC")
    @share_comment.destroy
    $notice_rejectcmt
     flash[:message] = 'Shared Moment Comment Rejected!!'
     if(session['redirect']=='22')
        redirect_to :controller => 'photo_comments', :action => 'photo_comnt', :id => session[:usercontent_id1], :page1=>params[:page1], :id_journal => params[:id_journal]
     else
       # redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
       redirect_to :controller => 'familywebsite_comments', :action => 'view',:id => params[:id]
     end
   end

def share_momentcomments_destroy_cmt
  @hmm_user=HmmUser.find(session[:hmm_user])
    if(session['redirect']=='22')
     @share_comment =ShareMomentcomment.find(params[:cid])
   else
    @share_comment =ShareMomentcomment.find(params[:comment_id])
    end
    @share_comment.destroy
    $notice_smtdestroy
     flash[:notice_smtdestroy] = 'Shared Moment Comment Deleted!!'
      if(session['redirect']=='22')
        redirect_to :controller => 'photo_comments', :action => 'photo_comnt', :id => session[:usercontent_id1], :page1=>params[:page1], :id_journal => params[:id_journal]
     else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'familywebsite_comments', :action => 'view',:id => params[:id]
    end
  end

#guest comments
 def guest_comments_approve_jcmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @guest_comment =GuestComment.find(params[:comment_id])
     @guest_comment['status'] = 'approve'
     @guest_comment.save
      $notice_cca_jlist
     flash[:message] = 'Guest Comment was Approved!!'
   flash[:message] = 'Guest Comment was Approved!!'
      if(params[:jc]=='1')
    redirect_to :controller => 'familywebsite_comments', :action => 'manage_journals_details' ,:id => params[:id]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
    end
  end

  def guest_comments_reject_jcmt
    @hmm_user=HmmUser.find(session[:hmm_user])
     @guest_comment =GuestComment.find(params[:comment_id])
      @guest_comment.destroy
     # @guest_comment['e_approval'] = 'reject'
      #@tag_cid = GuestComment.find(:all, :conditions => "tag_jid=#{params[:comment_id]} " , :order => "id DESC")
    #@guest_comment.save
    $notice_ccr_list
     flash[:notice_cca_jlist] = 'Guest Comment Rejected'
   flash[:message] = 'Guest Comment Rejected'
   if(params[:jc]=='1')
    redirect_to :controller => 'familywebsite_comments', :action => 'manage_journals_details' ,:id => params[:id]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
    end
   end

def guest_comments_destroy_jcmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @guest_comment =GuestComment.find(params[:comment_id])
      @guest_comment.destroy
     # @guest_comment['e_approval'] = 'reject'
      #@tag_cid = GuestComment.find(:all, :conditions => "tag_jid=#{params[:comment_id]} " , :order => "id DESC")
    #@guest_comment.save
    $notice_ccr_list
     flash[:message] = 'Guest Comment was removed!!'

   if(params[:jc]=='1')
    redirect_to :controller => 'familywebsite_comments', :action => 'manage_journals_details' ,:id => params[:id]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
    end
   end

 #message boards

def message_boards_approve_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @comment =MessageBoard.find(params[:comment_id])
    @comment['status'] = 'accept'
    @comment.save
      flash[:message] = 'Guest comment was Successfully Approved!!'
     #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
     redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
 end

def message_boards_destroy_cmt
  @hmm_user=HmmUser.find(session[:hmm_user])
    MessageBoard.find(params[:comment_id]).destroy
      flash[:message] = 'Guest comment was deleted!!'
     #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
     redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
  end

  #share comments

def share_comments_approve_cmt
   puts session['redirect']
     @hmm_user=HmmUser.find(session[:hmm_user])
     @share_comment =ShareComments.find(params[:comment_id])
     @share_comment['e_approved'] = 'approved'
     @share_comment.save
     flash[:message] = 'Shared Moment Comment Approved!!'
      if(session['redirect']=='111')
       redirect_to :controller => 'tags', :action => 'memories', :id=> @share_comment[:share_id]
      else
     #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
     redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
      end
 end

def share_comments_reject_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @share_comment =ShareComments.find(params[:comment_id])
     @share_comment.destroy

      #@tag_cid = ChapterComment.find(:all, :conditions => "tag_jid=#{params[:id]} " , :order => "id DESC")

    $notice_ccr_list
     flash[:message] = 'Shared Moment Comment Rejected!!'
    if(session['redirect']=='111')
       redirect_to :controller => 'tags', :action => 'memories', :id=> @share_comment[:share_id]
    else
   #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
   redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
    end
   end

 def share_comments_destroy_cmt
   @hmm_user=HmmUser.find(session[:hmm_user])
    @share_comment =ShareComments.find(params[:comment_id])
    @share_comment.destroy
     flash[:message] = 'Shared Moment Comment Deleted!!'
      if(session['redirect']=='111')
       redirect_to :controller => 'tags', :action => 'memories', :id=> @share_comment[:share_id]
      else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'familywebsite_comments', :action => 'view' ,:id => params[:id]
      end
  end
end