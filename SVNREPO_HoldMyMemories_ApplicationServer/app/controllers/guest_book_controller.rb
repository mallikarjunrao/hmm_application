class GuestBookController < ApplicationController
  layout 'familywebsite'
  require 'will_paginate'
  require 'rubygems'
  require 'money'
  require 'base64'
  include SortHelper
  helper :sort
  before_filter  :check_account #checks for valid family name, terms of use check and user block check
  
  
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
        if (@family_website_owner.account_expdate!=nil && @family_website_owner.account_expdate < Date.current())
          flash[:expired] = 'expired'
          redirect_to "/familywebsite/login/#{params[:id]}" if params[:action]!='login' unless (session[:hmm_user])
        elsif(session[:employe]==nil && @family_website_owner.terms_checked == 'false' ) #if the logged in user is not employee and terms is not agreed
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
          if(params[:facebook]=='true')
            session[:visitor]=@family_website_owner.family_name
          else
            redirect_to :controller =>"familywebsite", :action => 'visitor_login', :id => params[:id], :redirect_url => request.url if (params[:action]!='login' && params[:action]!='visitor_login')
          end
        else
          @path1 = ContentPath.find(:all)
          @path=""
          for path in @path1
            @path="#{@path}#{path.content_path},"
          end
          if(params[:id]=='bob')
            @content_server_url = "http://content.holdmymemories.com"
          else
            @content_server_url = "#{@path}"
          end
          return true #returns true if all the conditions are cleared
        end
      else
        redirect_to '/'
      end
    end
  end

 def new_comment
    @current_page = 'guest book'
    unless params[:button].blank?
      @name=params[:name]
      @email=params[:email]
      @subject=params[:subject]
      @message=params[:message]
      @guest_image=params[:guest_image]

      redirect_to "#{request_content_url}/manage_website/guestbook_new/#{params[:id]}?name=#{@name}&email=#{@email}&subject=#{@subject}&message=#{@message}&guest_image=#{@guest_image}"
#      if simple_captcha_valid?
#        @captcha=GuestbookCommentCaptcha.new()
#        @captcha['value']=params[:captcha]
#        @captcha.save
#        redirect_to "#{request_content_url}/manage_website/guestbook_new/#{params[:id]}?name=#{@name}&email=#{@email}&subject=#{@subject}&message=#{@message}&guest_image=#{@guest_image}&captcha=#{@captcha['value']}"
#      else
#        flash[:message] = 'Please enter the correct code!'
#        end
    end
  end
  
   def display_comments
    @current_page = 'guest book'

    if(params[:facebook]=='true')
      session[:family]=params[:id]
    end




    @userid = HmmUser.find(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')")
    @uid = @userid[0]['id']
    @hmmuserid = HmmUser.find(:all, :conditions => "id='#{@uid}'")

    @message_board_count = MessageBoard.count(:all, :conditions => "uid=#{@uid}")
    @familyname=params[:id]

    uid1=@uid

    tagcout = Tag.find_by_sql(" select
         count(*) as cnt
         from chapter_comments as a,tags as t
         where
         a.tag_id=t.id
         and
         t.uid=#{uid1}
         and a.e_approval = 'approve'")
    subcount = SubChapter.find_by_sql("
       select
        count(*) as cnt
        from
        subchap_comments as b,
        sub_chapters as s
        where
        s.uid=#{uid1}
        and
        b.subchap_id=s.id
        and b.e_approval='approve'")
    galcount = Galleries.find_by_sql("select
        count(*) as cnt
        from
        gallery_comments as c,
        galleries as g,
        sub_chapters as s1
        where
        s1.uid=#{uid1}
        and
        c.gallery_id=g.id
        and g.subchapter_id=s1.id
        and c.e_approval='approve'")

    usercontentcount = UserContent.find_by_sql("
  select
       count(*) as cnt
        from
        photo_comments as d,
        user_contents as u
        where
        d.user_content_id=u.id and u.uid=#{uid1}
        and d.e_approved='approve'
      ")
    sharecount = Share.find_by_sql("
  select
       count(*) as cnt
        from
        share_comments    as d,
        shares as u
        where
        d.share_id =u.id and u.presenter_id=#{uid1}
        and d.e_approved='approved'

      ")
    sharejournalcnt = ShareJournal.find_by_sql("
  select
    count(*) as cnt
    from
    share_journalcomments as d,
    share_journals as u
    where
    d.shareid = u.id and u.presenter_id=#{uid1}
    and d.status='accepted'
      ")


    guestmessagecount = MessageBoard.count(:all, :conditions => "uid=#{uid1}")

    guestcommentcount = GuestComment.find_by_sql("
    select
    count(*) as cnt
    from
    guest_comments
    where
    uid=#{uid1}
    and status='approve'
      ")

    guestcommentcnt=Integer(guestcommentcount[0].cnt)
    galcnt=Integer(galcount[0].cnt)
    tagcnt=Integer(tagcout[0].cnt)
    subcnt=Integer(subcount[0].cnt)
    usercontentcnt=Integer(usercontentcount[0].cnt)
    sharecnt=Integer(sharecount[0].cnt)
    sharejournalcnt=Integer(sharejournalcnt[0].cnt)

    @total=tagcnt+subcnt+galcnt+usercontentcnt+sharecnt+sharejournalcnt+guestcommentcnt+guestmessagecount

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
         a.e_approval = 'approve'
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
        b.subchap_jid as name,
        b.uid as user_id,
        b.d_created_on as d_created_at
        from
        subchap_comments as b,
        sub_chapters as s
        where
        s.uid=#{uid1}
        and
        b.subchap_id=s.id
        and
        b.e_approval='approve'
     )
     union
     (select
        c.id as id,
        c.gallery_id as master_id,
        c.v_comment as comment,
        c.reply as reply,
        c.e_approval as e_approval,
        c.ctype as ctype,
        c.gallery_jid as name,
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
        and g.subchapter_id=s1.id
        and c.e_approval='approve'
        )

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
        and d.e_approved='approve'
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
        d.d_add_date as d_created_at
        from
        share_comments as d,
        shares as s
        where
        d.share_id=s.id
        and
        s.presenter_id=#{uid1}
        and d.e_approved='approved'
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
        p.added_date as d_created_at
        from
        share_momentcomments as p,
        share_moments as q
        where
        p.share_id=q.id
        and
        q.presenter_id=#{uid1}
        and p.e_approved='approved'
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
        r.comment_date as d_created_at
        from
        share_journalcomments as r,
        share_journals as z
        where
        r.shareid=z.id
        and
        z.presenter_id=#{uid1}
        and r.status='accepted'
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
        g.comment_date as d_created_at
        from
        guest_comments as g
        where
        g.uid=#{uid1}
        and g.status='approve'
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
        and h.status='accept'
     )
     order by d_created_at desc limit #{x}, #{y} ")

    puts x
    puts y

    if(session[:journal]=='journal')
      render :layout => true
      session[:journal] = nil
    else if(params[:page]==nil)

      else
        render :layout => false
      end
    end

  end

end
