class BlogController < ApplicationController
  layout 'familywebsite'
  include SortHelper
  include SortHelper
  helper :sort
  require 'will_paginate'
  require 'json/pure'
  require 'cgi'
  before_filter  :check_account,:redirect_url #checks for valid family name, terms of use check and user block check

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
          if(params[:facebook]=='true')
            session[:visitor]=@family_website_owner.family_name
          else
            redirect_to :controller =>"familywebsite", :action => 'visitor_login', :id => params[:id], :redirect_url => request.url if (params[:action]!='login' && params[:action]!='visitor_login')
          end
        elsif (!session[:hmm_user] || logged_in_hmm_user.id!=@family_website_owner.id) && params[:action]!='list' && params[:action]!='view_more' && params[:action]!='index' && params[:action]!='add_comment' && params[:action]!='addblog_comment'
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


  def redirect_url
    url= request.url.split("/")
    for i in 0..url.length
      if url[i]
        url[i]=url[i].upcase
        logger.info(url[i])
        if((url[i].match("<SCRIPT>")) || (url[i].match("</SCRIPT>")) || (url[i].match("</SCRIP>")) || (url[i].match("<SCRIP")) ||(url[i].match("JAVASCRIPT:ALERT"))||(url[i].match("<<<<<<<<<<$URL$>>>>>")))
          redirect_to "/nonexistent_page.html"
        end
      end
    end
  end

  def list
    params[:order]=CGI.escapeHTML(params[:order])
    params[:id]=CGI.escapeHTML(params[:id])
    params[:category]=CGI.escapeHTML(params[:category])
    params[:page]=CGI.escapeHTML(params[:page])
    @current_page = 'blog'
    if(params[:order])
      order=params[:order]
    else
      order="desc"
    end
    if(params[:facebook]=='true')
      session[:family]=params[:id]
    end

    @password_protected = HmmUser.count(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}') and password_required='yes'")


    if( @password_protected > 0)

      cond1="and (t.e_access='public' or t.e_access='semiprivate')"

      cond2="and (s.e_access='public' or s.e_access='semiprivate')"

      cond3="and (g.e_gallery_acess='public' or g.e_gallery_acess='semiprivate')"

      cond4="and (u.e_access='public' or u.e_access='semiprivate')"
    else

      cond1="and t.e_access='public'"

      cond2="and s.e_access='public'"

      cond3="and g.e_gallery_acess='public'"

      cond4="and u.e_access='public'"


    end

    userid = HmmUser.find(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')")
    uid1 = userid[0]['id']

    if(params[:category]=="" ||  params[:category]==nil)


      chapter=""
      subchapter=""
      gallery= ""
      moment=""
      image=""
      video=""
      audio=""
      text=""
    else
      chapter=" and t.id=0"
      subchapter=" and s.id=0"
      gallery= " and g.id=0"
      moment="  and d.id=0"
      image=" and e_filetype = 'image'"
      video=" and e_filetype = 'video'"
      audio=" and e_filetype = 'audio'"
      text=" and txt.id=0"
    end
    if(params[:category] == "chapter")
      chapter=""
    elsif(params[:category] == "subchapter")
      subchapter=""
    elsif(params[:category] == "gallery")
      gallery=""
    elsif(params[:category] == "image")
      image="and e_filetype = 'image'"
      video=""
      audio=""
      moment=""
    elsif(params[:category] == "video")
      video="and e_filetype = 'video'"
      image=""
      audio=""
      moment=""
    elsif(params[:category] == "audio")
      image=""
      video=""
      audio=" and e_filetype = 'audio'"
      moment=""
    elsif(params[:category] == "text")
      text=""

    end
    tagcout = Tag.find_by_sql(" select
       count(*) as cnt
         from chapter_journals as a,tags as t
         where
         a.tag_id=t.id
         and
         t.uid=#{uid1} and t.status='active' #{cond1} #{chapter}")
    subcount = SubChapter.find_by_sql("
 select
        count(*) as cnt
        from
        sub_chap_journals  as b,
        sub_chapters as s
        where
        s.uid=#{uid1}
        and
        b.sub_chap_id=s.id  and s.status='active' #{cond2}  #{subchapter}")

    galcount = Galleries.find_by_sql("select
        count(*) as cnt
        from
        gallery_journals   as c,
        galleries as g,
        sub_chapters as s1
        where
        s1.uid=#{uid1}
        and
        c.galerry_id=g.id
        and g.subchapter_id=s1.id and g.status='active' #{cond3}  #{gallery}")

    usercontentcount = UserContent.find_by_sql("
  select
       count(*) as cnt
        from
        journals_photos   as d,
        user_contents as u
        where
        d.user_content_id=u.id and u.uid=#{uid1}
        and u.status='active' #{cond4}  #{moment} #{image} #{video} #{audio}

      ")
    txtcount=UserContent.find_by_sql("
  select
       count(*) as cnt
        from
        text_journals   as txt
        where
        txt.uid=#{uid1}
        #{text}

      ")
    txtcnt=Integer(txtcount[0].cnt)
    galcnt=Integer(galcount[0].cnt)
    tagcnt=Integer(tagcout[0].cnt)
    subcnt=Integer(subcount[0].cnt)
    usercontentcnt=Integer(usercontentcount[0].cnt)

    @total=tagcnt+subcnt+galcnt+usercontentcnt+txtcnt

    @numberofpagesres=@total/5

    @numberofpages=@numberofpagesres.round()

    if(params[:page]==nil)
      x=0
      y=5
      @page=0
      @nextpage=1
      if(@total<5)

        @nonext=1
      end
    else
      x=5*Integer(params[:page])
      y=5
      @page=Integer(params[:page])
      @nextpage=@page+1
      @previouspage=@page-1
      if(@page==@numberofpages)
        @nonext=1
      end
    end


    @tagid=ChapterJournal.find_by_sql("
   (select
        t.uid as uid,
         a.id as id,
         a.tag_id as master_id,
         a.v_tag_title as title,
         a.v_tag_journal as descr,
         a.jtype as jtype,
         a.d_created_at as d_created_at,
         a.d_updated_at as d_updated_at,
         t.img_url as img_url
         from chapter_journals as a,tags as t
         where
         a.tag_id=t.id
         and
         t.uid=#{uid1}
         and
         t.status='active' #{cond1}   #{chapter}
     )
     union
     (select
        s.uid as uid,
        b.id as id,
        b.sub_chap_id as master_id,
        b.journal_title as title,
        b.subchap_journal as descr,
        b.jtype as jtype,
        b.created_on as d_created_at,
        b.updated_on as d_updated_at,
        s.img_url as img_url
        from
        sub_chap_journals  as b,
        sub_chapters as s
        where
        s.uid=#{uid1}
        and
        b.sub_chap_id=s.id and s.status='active' #{cond2}   #{subchapter}
     )
     union
     (select
        s1.uid as uid,
        c.id as id,
        c.galerry_id as master_id,
        c.v_title as title,
        c.v_journal as descr,
        c.jtype as jtype,
        c.d_created_on as d_created_at,
        c.d_updated_on as d_updated_on,
        g.img_url as img_url
        from
        gallery_journals   as c,
        galleries as g,
        sub_chapters as s1
        where
        s1.uid=#{uid1}
        and
        c.galerry_id=g.id
        and g.subchapter_id=s1.id  and g.status='active' #{cond3} #{gallery})
     union
    (select
        u.uid as uid,
        d.id as id,
        d.user_content_id as master_id,
        d.v_title as title,
        d.v_image_comment as descr,
        d.jtype as jtype,
        d.date_added as d_created_at,
        d.date_added  as d_updated_on,
        u.img_url as img_url
        from
        journals_photos   as d,
        user_contents as u
        where
        d.user_content_id=u.id and u.uid=#{uid1} and u.status='active' #{cond4}   #{moment} #{image} #{video} #{audio}
     )
union
(select
        txt.uid as uid,
        txt.id as id,
        txt.uid as master_id,
        txt.journal_title as title,
        txt.description as descr,
        txt.jtype as jtype,
        txt.d_created_at as d_created_at,
        txt.d_updated_at  as d_updated_on,
        txt.uid as img_url
        from
        text_journals    as txt

        where
        txt.uid='#{uid1}' #{text}
     )
     order by d_created_at #{order} limit #{x}, #{y} ")


    @recent_entries=ChapterJournal.find_by_sql("
   (select
        t.uid as uid,
         a.id as id,
         a.tag_id as master_id,
         a.v_tag_title as title,
         a.v_tag_journal as descr,
         a.jtype as jtype,
         a.d_created_at as d_created_at,
         a.d_updated_at as d_updated_at,
         t.img_url as img_url
         from chapter_journals as a,tags as t
         where
         a.tag_id=t.id
         and
         t.uid=#{uid1}
         and
         t.status='active' #{cond1}   #{chapter}
     )
     union
     (select
        s.uid as uid,
        b.id as id,
        b.sub_chap_id as master_id,
        b.journal_title as title,
        b.subchap_journal as descr,
        b.jtype as jtype,
        b.created_on as d_created_at,
        b.updated_on as d_updated_at,
        s.img_url as img_url
        from
        sub_chap_journals  as b,
        sub_chapters as s
        where
        s.uid=#{uid1}
        and
        b.sub_chap_id=s.id and s.status='active' #{cond2}   #{subchapter}
     )
     union
     (select
        s1.uid as uid,
        c.id as id,
        c.galerry_id as master_id,
        c.v_title as title,
        c.v_journal as descr,
        c.jtype as jtype,
        c.d_created_on as d_created_at,
        c.d_updated_on as d_updated_on,
        g.img_url as img_url
        from
        gallery_journals   as c,
        galleries as g,
        sub_chapters as s1
        where
        s1.uid=#{uid1}
        and
        c.galerry_id=g.id
        and g.subchapter_id=s1.id  and g.status='active' #{cond3} #{gallery})
     union
    (select
        u.uid as uid,
        d.id as id,
        d.user_content_id as master_id,
        d.v_title as title,
        d.v_image_comment as descr,
        d.jtype as jtype,
        d.date_added as d_created_at,
        d.date_added  as d_updated_on,
        u.img_url as img_url
        from
        journals_photos   as d,
        user_contents as u
        where
        d.user_content_id=u.id and u.uid=#{uid1} and u.status='active' #{cond4}   #{moment} #{image} #{video} #{audio}
     )
union
(select
        txt.uid as uid,
        txt.id as id,
        txt.uid as master_id,
        txt.journal_title as title,
        txt.description as descr,
        txt.jtype as jtype,
        txt.d_created_at as d_created_at,
        txt.d_updated_at  as d_updated_on,
        txt.uid as img_url
        from
        text_journals    as txt

        where
        txt.uid='#{uid1}' #{text}
     )
     order by d_created_at #{order} limit 10 ")

    #@tagid = ChapterJournal.paginating_sql_find(@cnt, sql, {:page_size => 10, :current => params[:page]})
    # @tagid1, @tagid = paginate_by_sql ChapterJournal, sql, 20

    if(session[:journal]=='journal')
      render :layout => true
      session[:journal] = nil
    else if(params[:page]==nil)

      else
        render :layout => false
      end

    end


  end

  def get_proxy_urls
    proxyurls = nil
    contentservers = ContentPath.find(:all)
    for server in contentservers
      if(proxyurls == nil)
        proxyurls = server['content_path']
      else
        proxyurls = proxyurls +','+server['content_path']
      end
    end
    return proxyurls
  end


  def index
    params[:order]=CGI.escapeHTML(params[:order])
    params[:page]=CGI.escapeHTML(params[:page])
    params[:id]=CGI.escapeHTML(params[:id])
    @current_page = 'blog'
    if(params[:order])
      order=params[:order]
    else
      order="desc"
    end
    @conditions= ["user_id = #{@family_website_owner.id} AND blogs.status='active'",{:user_id => @family_website_owner.id}]
    @entries = Blog.paginate  :per_page => 5, :page => params[:page],:conditions => @conditions,
      :joins =>"LEFT JOIN tags on (blogs.blog_type='chapter' and blogs.blog_type_id = tags.id)
        LEFT JOIN sub_chapters on (blogs.blog_type='subchapter' and blogs.blog_type_id = sub_chapters.id)
        LEFT JOIN galleries on (blogs.blog_type='gallery' and blogs.blog_type_id = galleries.id)
        LEFT JOIN user_contents on (blogs.blog_type in ('image','audio','video') and blogs.blog_type_id = user_contents.id) and blogs.client='website'
        LEFT JOIN mobile_blog_contents on blogs.client='iphone' and blogs.blog_type in ('image','audio','video') and blogs.blog_type_id=mobile_blog_contents.id",
      :select => "blogs.id as blog_id,blog_type,blogs.client,title,description,blog_type_id,DATE_FORMAT(blogs.added_date,'%W, %b %d, %Y') as created_date,
        tags.v_chapimage as chapter_image,tags.img_url as tag_url,
        sub_chapters.v_image as subchapter_image,sub_chapters.img_url as sub_chapter_url,
        galleries.v_gallery_image as gallery_image,galleries.img_url as galleries_url,
        CONCAT(user_contents.img_url,'/user_content/photos/big_thumb/',v_filename) as content_image_url,
        CONCAT(user_contents.img_url,'/user_content/videos/thumbnails/',v_filename,'.jpg') as content_video_url,
        CONCAT(user_contents.img_url,'/user_content/audios/speaker.jpg') as content_audio_url,
        tags.tag_type as chapter_type,galleries.e_gallery_type as gallery_type,mobile_blog_contents.server_url as mobile_server_url,
        mobile_blog_contents.file_name as mobile_file_name",:order=>"blogs.added_date #{order}"

    @results = Blog.format_results(@entries,params[:id],@family_website_owner.img_url)

    #recent entries
    @total=Blog.count(:all,:conditions => @conditions,:order =>"blogs.added_date #{order}")
    @recent_entries=Blog.find(:all,:conditions => @conditions,
      :joins =>"LEFT JOIN tags on (blogs.blog_type='chapter' and blogs.blog_type_id = tags.id)
        LEFT JOIN sub_chapters on (blogs.blog_type='subchapter' and blogs.blog_type_id = sub_chapters.id)
        LEFT JOIN galleries on (blogs.blog_type='gallery' and blogs.blog_type_id = galleries.id)
        LEFT JOIN user_contents on (blogs.blog_type in ('image','audio','video') and blogs.blog_type_id = user_contents.id) and blogs.client='website'",
      :select => "blogs.id as id,blog_type as jtype,blogs.client,title,description as descr,blog_type_id as master_id,DATE_FORMAT(blogs.added_date,'%W %b %d , %Y') as d_created_at,
        tags.img_url as img_url,
        sub_chapters.img_url as img_url,
        galleries.img_url  as img_url,
        user_contents.img_url as img_url,
        galleries.e_gallery_type as gallery_type", :order =>" blogs.added_date #{order}")
  end

  def share_blog
    @jtype = params[:blog_id]
    @temp = params[:blog_type]
    @family_name_tag = params[:id]
    @userid = HmmUser.find(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')")
    @uid = @userid[0]['id']
    @symb='&'
  end

  def share_blog_email

    if params[:message]
      @message = params[:message]
    end
    @jid=params[:blog_id]
    @jtype = params[:blog_type]

    journal = Journal

    #   INSERTING NON-HMM USERS IN SHARE'S TABLE
    if params[:nhmmuser]
      @nonhmmusers = params[:nhmmuser]
      nonhmmids = @nonhmmusers.join(",")
      @nonhmm = NonhmmUser.find(:all, :conditions => "id in (#{nonhmmids})",:group=>"v_email")
      for j in @nonhmm
        @share_max =  ShareJournal.find_by_sql("select max(id) as n from share_journals")
        for share_max in @share_max
          share_max_id = "#{share_max.n}"
        end
        if(share_max_id == '')
          share_max_id = '0'
        end
        share_next_id= Integer(share_max_id) + 1
        @share = ShareJournal.new
        @share['presenter_id']=logged_in_hmm_user.id
        @share['jid']= @jid
        @share['jtype']=@jtype
        @share['e_mail']= j.v_email
        @share['created_date']=Time.now
        @share['expiry_date']=Time.now.advance(:months => 1, :years => 0)
        @share['message']=@message
        shareuuid=Share.find_by_sql("select uuid() as uid")
        unid=shareuuid[0].uid+""+"#{share_next_id}"
        @share['unid']=unid
        @share.save
        Postoffice.deliver_shareJournal(@share['e_mail'],@message,journal,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.family_pic,@share.id,@share.unid,logged_in_hmm_user.img_url)
        $share_journalredirect
        flash[:message] = 'Blog was successfully shared!!'
      end
    end

    #   INSERTING E-MAIL ID'S
    if params[:email]
      @frdEmail = params[:email]
      frindsEmail=@frdEmail.split(',')
      for k in frindsEmail
        @share_max =  ShareJournal.find_by_sql("select max(id) as n from share_journals")
        for share_max in @share_max
          share_max_id = "#{share_max.n}"
        end
        if(share_max_id == '')
          share_max_id = '0'
        end
        share_next_id= Integer(share_max_id) + 1
        @check_hmmusers = HmmUser.count(:all, :conditions => "v_e_mail='#{k}'")
        if(@check_hmmusers > 0)
          @check_hmmusers = HmmUser.find(:all, :conditions => "v_e_mail='#{k}'")
          @blocked_friend = FamilyFriend.count(:all,:conditions => "uid='#{@check_hmmusers[0]['id']}' and fid='#{logged_in_hmm_user.id}' and block_status='block'")
          if(@blocked_friend <= 0)
            @blocked_friend =  0
          else
            @blocked_friend = 1
          end
        else
          @blocked_friend = 0
        end
        if(@blocked_friend <= 0)
          @share = ShareJournal.new
          @share['presenter_id']=logged_in_hmm_user.id
          @share['jid']=@jid
          @share['jtype']=@jtype
          @share['e_mail']= k
          @share['created_date']=Time.now
          @share['expiry_date']=Time.now.advance(:months => 1, :years => 0)
          @share['message']=@message
          shareuuid=Share.find_by_sql("select uuid() as uid")
          unid=shareuuid[0].uid+""+"#{share_next_id}"
          @share['unid']=unid
          @share.save
          Postoffice.deliver_shareJournal(@share['e_mail'],@message,journal,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.family_pic,@share.id,@share.unid,logged_in_hmm_user.img_url)
        end
      end
    end

    flash[:message] = 'Blog was successfully shared!!'
    #redirect_to :controller => 'blog', :action => 'list', :id => "#{params[:id]}"
    redirect_to :controller => 'blog', :action => 'index', :id => "#{params[:id]}"

  end

  #  def add_comment
  #    unless params[:add_comment_bt].blank?
  #      if simple_captcha_valid?
  #        @guest_comment = GuestComment.new()
  #        hmm_user=HmmUser.find(:all, :conditions => " family_name='#{params[:id]}'")
  #        @guest_comment['uid'] = hmm_user[0]['id']
  #        @guest_comment['journal_typeid'] = params[:type_id]
  #        @guest_comment['journal_id'] = params[:journal_id]
  #        @guest_comment['journal_type'] = params[:journal_type]
  #        @guest_comment['name'] = params[:name]
  #        @guest_comment['comment'] = params[:comment]
  #        @guest_comment['comment_date'] = Time.now
  #        @guest_comment['ctype'] = 'guest_comment'
  #
  #        if @guest_comment.save
  #          $notice_guest
  #          #Postoffice.deliver_comment(params[:comment],'0','guest comment',params[:name],'',hmm_user[0].v_user_name,hmm_user[0].v_e_mail,hmm_user[0].v_myimage)
  #          flash[:message] = 'Comment was successfully sent...'
  #        else
  #          flash[:message] = 'Comment added  failed...'
  #        end
  #        redirect_to :controller =>'blog', :action => 'list', :id => params[:id]
  #      else
  #        redirect_to :controller =>'blog', :action => 'list', :id => params[:id],:fail=>1
  #        #flash[:error] = 'Please enter the correct code!'
  #      end
  #    else
  #      render :layout => false
  #    end
  #  end

  def add_comment
    unless params[:add_comment_bt].blank?
      if verify_recaptcha
        @guest_comment = GuestComment.new()
        hmm_user=HmmUser.find(:all, :conditions => " family_name='#{params[:id]}'")
        @guest_comment['uid'] = hmm_user[0]['id']
        @guest_comment['journal_typeid'] = params[:type_id]
        @guest_comment['journal_id'] = params[:journal_id]
        @guest_comment['journal_type'] = params[:journal_type]
        @guest_comment['name'] = params[:name]
        @guest_comment['comment'] = params[:comment]
        @guest_comment['comment_date'] = Time.now
        @guest_comment['ctype'] = 'guest_comment'

        if @guest_comment.save
          $notice_guest
          #Postoffice.deliver_comment(params[:comment],'0','guest comment',params[:name],'',hmm_user[0].v_user_name,hmm_user[0].v_e_mail,hmm_user[0].v_myimage)
          flash[:message] = 'Comment was successfully sent...'
        else
          flash[:message] = 'Comment added  failed...'
        end
        redirect_to :controller =>'blog', :action => 'list', :id => params[:id]
      else
        redirect_to :controller =>'blog', :action => 'list', :id => params[:id],:fail=>1
        #flash[:error] = 'Please enter the correct code!'
      end
    else
      render :layout => false
    end
  end


  # Method under manage my site

  def manage_blog_details
    @current_item = 'manage_blog'
    @current_page = 'manage my site'
    @familyname=params[:id]
    @hmm_user=HmmUser.find(session[:hmm_user])

    # code to add new non_hmm users from e-mail text box
    if session[:nonhmm]
      if params[:email]
        @nonhmm = params[:email]
        @nonhmmids = @nonhmm.join(",")

        if params[:name]
          nonhmmna = params[:name]
          @nonhmmnames = nonhmmna.join(",")
        end
        frindsEmail=@nonhmmids.split(',')
        frindsName=@nonhmmnames.split(',')
        i=0

        #finding the size of an array
        emailsize=frindsEmail.size()
        namesize=frindsName.size()

        #loop to insert new nonHMM friends which are added through e-mail
        emailsize.times {|i|
          @addnonhmm = NonhmmUser.new()
          @addnonhmm['v_email'] = frindsEmail[i]
          @addnonhmm['v_name'] = frindsName[i]
          @addnonhmm['uid'] = logged_in_hmm_user.id
          @addnonhmm['v_city'] = 'edit city'
          @addnonhmm['v_country'] = 'edit country'
          @addnonhmm.save
        }
        session[:nonhmm] = nil #session nonhmm is killed
      end
    end

    #     for k in frindsEmail
    #       @addnonhmm = NonhmmUser.new()
    #       @addnonhmm['v_email'] = k
    #    j=k
    #    for j in frindsName
    #      @addnonhmm['v_name'] = j
    #
    #    end
    #
    #    end


    #add new friends code ends here


    uid1=logged_in_hmm_user.id


    tagcout = Tag.find_by_sql(" select
       count(*) as cnt
         from chapter_journals as a,tags as t
         where
         a.tag_id=t.id
         and
         t.uid=#{uid1} ")
    subcount = SubChapter.find_by_sql("
 select
        count(*) as cnt
        from
        sub_chap_journals  as b,
        sub_chapters as s
        where
        s.uid=#{uid1}
        and
        b.sub_chap_id=s.id
      "
    )
    galcount = Galleries.find_by_sql("select
        count(*) as cnt
        from
        gallery_journals   as c,
        galleries as g,
        sub_chapters as s1
        where
        s1.uid=#{uid1}
        and
        c.galerry_id=g.id
        and g.subchapter_id=s1.id ")

    usercontentcount = UserContent.find_by_sql("
  select
       count(*) as cnt
        from
        journals_photos   as d,
        user_contents as u
        where
        d.user_content_id=u.id and u.uid=#{uid1}

      ")
    txtcount=UserContent.find_by_sql("
  select
       count(*) as cnt
        from
        text_journals   as txt
        where
        txt.uid=#{uid1}


      ")

    txtcnt=Integer(txtcount[0].cnt)
    galcnt=Integer(galcount[0].cnt)
    tagcnt=Integer(tagcout[0].cnt)
    subcnt=Integer(subcount[0].cnt)
    usercontentcnt=Integer(usercontentcount[0].cnt)

    @total=tagcnt+subcnt+galcnt+usercontentcnt+txtcnt

    @numberofpagesres=@total/10

    @numberofpages=@numberofpagesres.round()

    if(params[:page]==nil)
      x=0
      y=10
      @page=0
      @nextpage=1
      if(@total<=10)
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


    @tagid=ChapterJournal.find_by_sql("
   (select
        t.uid as uid,
         a.id as id,
         a.tag_id as master_id,
         a.v_tag_title as title,
         a.v_tag_journal as descr,
         a.jtype as jtype,
         a.d_created_at as d_created_at,
         a.d_updated_at as d_updated_at,
         t.img_url as img_url
         from chapter_journals as a,tags as t
         where
         a.tag_id=t.id
         and
         t.uid=#{uid1}
     )
     union
     (select
        s.uid as uid,
        b.id as id,
        b.sub_chap_id as master_id,
        b.journal_title as title,
        b.subchap_journal as descr,
        b.jtype as jtype,
        b.created_on as d_created_at,
        b.updated_on as d_updated_at,
        s.img_url as img_url
        from
        sub_chap_journals  as b,
        sub_chapters as s
        where
        s.uid=#{uid1}
        and
        b.sub_chap_id=s.id
     )
     union
     (select
        s1.uid as uid,
        c.id as id,
        c.galerry_id as master_id,
        c.v_title as title,
        c.v_journal as descr,
        c.jtype as jtype,
        c.d_created_on as d_created_at,
        c.d_updated_on as d_updated_on,
        g.img_url as img_url
        from
        gallery_journals   as c,
        galleries as g,
        sub_chapters as s1
        where
        s1.uid=#{uid1}
        and
        c.galerry_id=g.id
        and g.subchapter_id=s1.id)
     union
    (select
        u.uid as uid,
        d.id as id,
        d.user_content_id as master_id,
        d.v_title as title,
        d.v_image_comment as descr,
        d.jtype as jtype,
        d.date_added as d_created_at,
        d.date_added  as d_updated_on,
        u.img_url as img_url
        from
        journals_photos   as d,
        user_contents as u
        where
        d.user_content_id=u.id and u.uid=#{uid1}
     )
union
(select
        txt.uid as uid,
        txt.id as id,
        txt.id as master_id,
        txt.journal_title as title,
        txt.description as descr,
        txt.jtype as jtype,
        txt.d_created_at as d_created_at,
        txt.d_updated_at  as d_updated_on,
        txt.uid as img_url
        from
        text_journals    as txt

        where
        txt.uid='#{uid1}'
     )
     order by d_created_at desc limit #{x}, #{y} ")

    if(params[:page]==nil)
    else
      render :layout => false
    end
  end


  def delete_chapter_blog
    ChapterJournal.find(params[:blog_id]).destroy
    flash[:message] = 'Blog entry deleted!'
    redirect_to :controller => 'blog', :action => 'manage_blog_details', :id => params[:id]
  end


  def delete_subchapter_blog
    SubChapJournal.find(params[:blog_id]).destroy
    flash[:mesasge] = 'Blog entry deleted!'
    redirect_to :controller => 'blog', :action => 'manage_blog_details', :id => params[:id]
  end

  def delete_gallery_blog
    GalleryJournal.find(params[:blog_id]).destroy
    flash[:message] = 'Blog entry deleted!'
    redirect_to :controller => 'blog', :action => 'manage_blog_details', :id => params[:id]
  end


  def delete_gallery_content_blog
    JournalsPhoto.find(params[:blog_id]).destroy
    flash[:message] = 'Blog entry deleted!'
    redirect_to :controller => 'blog', :action => 'manage_blog_details', :id => params[:id]
  end

  def delete_text_blog
    TextJournal.find(params[:blog_id]).destroy
    flash[:message] = 'Blog entry deleted!'
    redirect_to :controller => 'blog', :action => 'manage_blog_details', :id => params[:id]
  end


  def edit_chapter_blog
    @current_item = 'manage_blog'
    @current_page = 'manage my site'
    unless params[:chapter_journal].blank?
      @chapter_journal = ChapterJournal.find(params[:blog_id])
      @chapter_journal['d_updated_at']=Time.now
      @chapter_journal['d_created_at']=Time.now

      if @chapter_journal.update_attributes(params[:chapter_journal])
        #@chapter_journal['d_created_at']=Time.now
        @chap_j = ChapterJournal.find(:all, :select => "a.*,b.*", :joins => "as a , tags as b", :conditions => "a.id=#{params[:blog_id]} and a.tag_id=b.id")
        flash[:message] = "Chapter's Blog updated!"
        redirect_to  :action => 'manage_blog_details', :id => params[:id]
      else
        render :action => 'edit_chapter_blog',:id => params[:id], :jid => params[:blog_id]
      end
    else
      @chapter_journal = ChapterJournal.find(params[:blog_id])
      @chap_j = ChapterJournal.find(:all, :select => "a.*, b.*", :joins => "as a , tags as b", :conditions => "a.tag_id=b.id and a.id=#{params[:blog_id]}")
    end
  end

  def edit_subchapter_blog
    unless params[:sub_chap_journal].blank?
      @sub_chap_journal = SubChapJournal.find(params[:blog_id])
      @sub_chap_journal['d_updated_on']=Time.now
      @sub_chap_journal['created_on']=Time.now
      if @sub_chap_journal.update_attributes(params[:sub_chap_journal])
        flash[:message] = 'Sub-Chapter blog updated!'
        redirect_to  :action => 'manage_blog_details', :id => params[:id]
      else
        render :action => 'edit', :id => params[:id], :blog_id => params[:blog_id]
      end
    else
      @sub_chap_journal = SubChapJournal.find(params[:blog_id])
      @subchap_j = SubChapJournal.find(:all,:select =>"a.*,b.*", :joins => "as a , sub_chapters as b", :conditions => "a.sub_chap_id=b.id and a.id=#{params[:blog_id]}")
    end

  end

  def edit_gallery_blog
    unless params[:gallery_journal].blank?
      @gallery_journal = GalleryJournal.find(params[:blog_id])
      @gallery_journal['d_updated_on']=Time.now
      @gallery_journal['d_created_on']=Time.now
      if @gallery_journal.update_attributes(params[:gallery_journal])
        flash[:message] = 'Gallery blog updated!'
        redirect_to  :action => 'manage_blog_details', :id => params[:id]
      else
        render :action => 'edit_gallery_journal', :id => params[:id], :blog_id => params[:blog_id]
      end
    else
      @gallery_journal = GalleryJournal.find(params[:blog_id])
      @gal_j = GalleryJournal.find(:all, :select => "a.*,b.*",:joins => "as a , galleries as b", :conditions => "a.galerry_id=b.id and a.id=#{params[:blog_id]}")
    end
  end

  def edit_text_blog
    unless params[:text_journal].blank?
      @text_journal = TextJournal.find(params[:blog_id])
      @text_journal['d_updated_on']=Time.now
      @text_journal['d_created_on']=Time.now
      if @text_journal.update_attributes(params[:text_journal])
        flash[:message] = 'Text blog updated!'
        redirect_to  :action => 'manage_blog_details', :id => params[:id]
      else
        render :action => 'edit_text_journal', :id => params[:id], :blog_id => params[:blog_id]
      end
    else
      @text_journal = TextJournal.find(params[:blog_id])
    end
  end



  def edit_gallery_content_blog
    unless params[:journals_photo].blank?
      @journals_photo = JournalsPhoto.find(params[:blog_id])
      params['journals_photo']['date_added']=Time.now
      #params['journals_photo']['updated_date']=Time.now
      if @journals_photo.update_attributes(params[:journals_photo])
        flash[:message] = ' Blog updated!'
        redirect_to  :action => 'manage_blog_details' , :id => params[:id]
      else
        redirect_to  :action => 'manage_blog_details' , :id => params[:id]
      end
    else
      @journals_photo = JournalsPhoto.find(:first, :conditions => "user_content_id= '#{params[:blog_id]}'")
      @usercontent = UserContent.find(params[:blog_id])
      if(@usercontent.e_filetype=='video' || @usercontent.e_filetype=='swf')
        @imgpath="/user_content/videos/thumbnails/#{@usercontent.v_filename}"+".jpg"
      else
        if(@usercontent.e_filetype=='image')
          @imgpath="/user_content/photos/small_thumb/#{@usercontent.v_filename}"
        else
          @imgpath="/user_content/audios/speaker.jpg"
        end
      end
      @imgname = @usercontent.v_tagphoto
      @ucontent_id = params[:blog_id]
      params[:blog_id] = @journals_photo.id
    end
  end


  def comment_list
  	@mode=params[:mode]
    if(params[:id])
      @hmm_user=HmmUser.find(:all, :conditions => "family_name = '#{params[:id]}' ")
      @hmm_user=@hmm_user[0]
      e_approved="and e_approval='approve'"
      e_approved1="and e_approved='approve'"
      approved="and status='accepted'"
      uid1=@hmm_user.id
    else
      if session[:friend] == ''
        @hmm_user=HmmUser.find(session[:hmm_user])
        uid1=logged_in_hmm_user.id
      else
        uid1=session[:friend]
      end
    end
    sharejournalcnt = ShareJournal.find_by_sql("
  select
    count(*) as cnt
    from
    share_journalcomments as d,
    share_journals as u
    where
    d.shareid = u.id and  u.presenter_id=#{uid1}
      ")

    tagcout = Tag.find_by_sql(" select
         count(*) as cnt
         from chapter_comments  as a,tags as t
         where
         a.tag_id=t.id
         and
         t.uid=#{uid1} ")


    guestcout = GuestComment.count(:all, :conditions => "journal_id=#{params[:id_journal]} and journal_type='#{@mode}'" )


    usercontentcnt=Integer(tagcout[0].cnt)

    sharejournalcnt=Integer(sharejournalcnt[0].cnt)

    @total=usercontentcnt+sharejournalcnt+guestcout

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

    if(@mode=='chapter')

      sql_query="(select
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
			 and
			 a.tag_jid=#{params[:id_journal]}

		 	) "

			@table=Tag
			#@path_controller="chapter_comment"
      @path_controller='manage_site/chapter_comment'
			@path_share="/share_journals/shareJournal_view/"
    else
      if(@mode=='sub-chapter')
        sql_query="(select
			 a.id as id,
			 a.subchap_id as master_id,
			 a.v_comments as comment,
			 a.reply as reply,
			 a.e_approval as e_approval,
			 a.ctype as ctype,
			 h.v_fname as name,
			 a.uid as user_id,
			 a.d_created_on as d_created_at
			 from subchap_comments as a, hmm_users as h
			 where
			 a.subchap_jid=#{params[:id_journal]}
			 and
			 h.id=a.uid

			  #{e_approved}
		 	)"
        #@path_controller="subchap_comment"
        @path_controller='manage_site/subchap_comment'
        @path_share="share_journals"
        @table=SubChapter
      else
        if(@mode=='gallery')
          sql_query="(select
				 a.id as id,
				 a.gallery_id as master_id,
				 a.v_comment as comment,
				 a.reply as reply,
				 a.e_approval as e_approval,
				 a.ctype as ctype,
				 h.v_fname as name,
				 a.uid as user_id,
				 a.d_created_on as d_created_at
				 from gallery_comments as a, hmm_users as h
				 where
				 a.gallery_jid=#{params[:id_journal]}
				 and
				 h.id=a.uid

				  #{e_approved}
				)"
          #@path_controller="gallery_comment"
          @path_controller='manage_site/gallery_comment'
          @path_share="/share_journals/shareJournal_view/"
          @table=Galleries
        else
          if(@mode=='text')
            sql_query="(select
				 a.id as id,
				 a.gallery_id as master_id,
				 a.v_comment as comment,
				 a.reply as reply,
				 a.e_approval as e_approval,
				 a.ctype as ctype,
				 h.v_fname as name,
				 a.uid as user_id,
				 a.d_created_on as d_created_at
				 from gallery_comments as a, hmm_users as h
				 where
				 a.gallery_jid='-1'
				 and
				 h.id=a.uid

				  #{e_approved}
				)"
            #@path_controller="gallery_comment"
            @path_controller='manage_site/gallery_comment'
            @path_share="/share_journals/shareJournal_view/"
            @table=Galleries


          else
            if(@mode=='photo')
              sql_query="(select
					 a.id as id,
					 a.user_content_id as master_id,
					 a.v_comment as comment,
					 a.reply as reply,
					 a.e_approved as e_approval,
					 a.ctype as ctype,
					 h.v_fname as name,
					 a.uid as user_id,
					 a.d_add_date as d_created_at
					 from photo_comments as a, hmm_users as h
					 where
					 a.journal_id=#{params[:id_journal]}
					 and
					 h.id=a.uid

					  #{e_approved1}
					)"
              #@path_controller="photo_comments"
              @path_controller="manage_site/photo_comments"
              @path_share="/share_journals/shareJournal_view/"
              @table=UserContent
            end
          end
        end
      end
    end

    sql_share_union="
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
        and
        r.journal_type='#{@mode}'
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
        g.id as user_id,
        g.comment_date as d_add_date
        from
        guest_comments as g

        where
        g.journal_id=#{params[:id_journal]}
        and
        g.journal_type='#{@mode}'

     )order by d_created_at  desc limit #{x}, #{y}"


    @tagid=ChapterComment.find_by_sql("#{sql_query} #{sql_share_union}")

    render(:layout => false)

  end

  def create_chapter_blog_entry
    unless params[:chapter_id].blank?
      @chapter_journal = ChapterJournal.find(:first, :conditions => "tag_id=#{params[:chapter_id]}")
      @chapter = Tag.find(params[:chapter_id])
      if(@chapter.v_chapimage == "folder_img.png")
        @image="#{@chapter.img_url}/user_content/photos/big_thumb/noimage.jpg"
      else
        image_name = @chapter.v_chapimage
        image_name.slice!(-3..-1)
        @image="#{@chapter.img_url}/user_content/photos/icon_thumbnails/#{image_name}png"
      end
      if @chapter_journal
        @title = "Edit blog entry for '#{@chapter.v_tagname}'"
      else
        @title = "Create a blog entry for '#{@chapter.v_tagname}'"
      end
      unless params[:chapter_journal].blank?
        if @chapter_journal
          @chapter_journal['d_updated_at']=Time.now
          @chapter_journal['d_created_at']=Time.now
          @chapter_journal.update_attributes(params[:chapter_journal])
          flash[:notice] = "Blog entry updated successfully!"
        else
          @chapter_journal = ChapterJournal.new(params[:chapter_journal])
          @chapter_journal['d_updated_at']=Time.now
          @chapter_journal.save
          flash[:notice] = "Blog entry added successfully!"
        end
        if params[:redirect_url]
          redirect_to params[:redirect_url]
        else
          redirect_to :action => 'list', :id =>params[:id]
        end
      end
    else
      redirect_to :controller => "familywebsite", :action => "home", :id => params[:id]
    end
  end

  #new chapter blog entry
  def create_chapter_newblog_entry
    unless params[:chapter_id].blank?
      @blog = Blog.find(:first, :conditions => "blog_type_id=#{params[:chapter_id]} and blog_type='chapter'")
      @chapter = Tag.find(params[:chapter_id])
      if(@chapter.v_chapimage == "folder_img.png")
        @image="#{@chapter.img_url}/user_content/photos/big_thumb/noimage.jpg"
      else
        image_name = @chapter.v_chapimage
        image_name.slice!(-3..-1)
        @image="#{@chapter.img_url}/user_content/photos/icon_thumbnails/#{image_name}png"
      end
      if @blog
        @title = "Edit blog entry for '#{@chapter.v_tagname}'"
      else
        @title = "Create a blog entry for '#{@chapter.v_tagname}'"
      end

      unless params[:title].blank?

        userid = HmmUser.find(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')")
        uid = userid[0]['id']
        img_url=userid[0]['img_url']
        blogdate="#{params[:blog]['added_date(1i)']}-#{params[:blog]['added_date(2i)']}-#{params[:blog]['added_date(3i)']}"
        if @blog

          @blog['blog_type']='chapter'
          @blog['blog_type_id']=params[:chapter_id]
          @blog['user_id']=uid
          @blog['title']=params[:title]
          @blog['description']=params[:desc]
          @blog['added_date']=blogdate
          @blog.save
          flash[:notice] = "Blog entry updated successfully!"
        else
          @blog = Blog.new()
          @blog['blog_type']='chapter'
          @blog['blog_type_id']=params[:chapter_id]
          @blog['user_id']=uid
          @blog['title']=params[:title]
          @blog['description']=params[:desc]
          @blog['added_date']=blogdate
          @blog.save
          flash[:notice] = "Blog entry added successfully!"
        end
        if params[:redirect_url]
          redirect_to params[:redirect_url]
        else
          redirect_to :action => 'list', :id =>params[:id]
        end
      end
    else
      redirect_to :controller => "familywebsite", :action => "home", :id => params[:id]
    end
  end



  def create_subchapter_blog_entry
    unless params[:subchapter_id].blank?
      @sub_chap_journal = SubChapJournal.find(:first, :conditions => "sub_chap_id=#{params[:subchapter_id]}")
      @subchapter = SubChapter.find(params[:subchapter_id])
      if(@subchapter.v_image == "folder_img.png")
        @image="#{@subchapter.img_url}/user_content/photos/big_thumb/noimage.jpg"
      else
        image_name = @subchapter.v_image
        image_name.slice!(-3..-1)
        @image="#{@subchapter.img_url}/user_content/photos/icon_thumbnails/#{image_name}png"
      end
      if @sub_chap_journal
        @title = "Edit blog entry for '#{@subchapter.sub_chapname}'"
      else
        @title = "Create a blog entry for '#{@subchapter.sub_chapname}'"
      end
      unless params[:sub_chap_journal].blank?
        if @sub_chap_journal
          @sub_chap_journal['d_updated_at']=Time.now
          @sub_chap_journal['d_created_at']=Time.now
          @sub_chap_journal.update_attributes(params[:sub_chap_journal])
          flash[:notice] = "Blog entry updated successfully!"
        else
          @sub_chap_journal = SubChapJournal.new(params[:sub_chap_journal])
          @sub_chap_journal['d_updated_at']=Time.now
          @sub_chap_journal.save
          flash[:notice] = "Blog entry added successfully!"
        end
        if params[:redirect_url]
          redirect_to params[:redirect_url]
        else
          redirect_to :action => 'list', :id =>params[:id]
        end
      end

    else
      redirect_to :controller => "familywebsite", :action => "home", :id => params[:id]
    end
  end

  #new sub chapter blog entries
  def create_subchapter_newblog_entry
    unless params[:subchapter_id].blank?
      @blog = Blog.find(:first, :conditions => "blog_type_id=#{params[:subchapter_id]} and blog_type='subchapter'")
      @subchapter = SubChapter.find(params[:subchapter_id])
      if(@subchapter.v_image == "folder_img.png")
        @image="#{@subchapter.img_url}/user_content/photos/big_thumb/noimage.jpg"
      else
        image_name = @subchapter.v_image
        image_name.slice!(-3..-1)
        @image="#{@subchapter.img_url}/user_content/photos/icon_thumbnails/#{image_name}png"
      end
      if @blog
        @title = "Edit blog entry for '#{@subchapter.sub_chapname}'"
      else
        @title = "Create a blog entry for '#{@subchapter.sub_chapname}'"
      end

      unless params[:title].blank?

        userid = HmmUser.find(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')")
        uid = userid[0]['id']
        img_url=userid[0]['img_url']
        blogdate="#{params[:blog]['added_date(1i)']}-#{params[:blog]['added_date(2i)']}-#{params[:blog]['added_date(3i)']}"

        if @blog


          @blog['blog_type']='subchapter'
          @blog['blog_type_id']=params[:subchapter_id]
          @blog['user_id']=uid
          @blog['title']=params[:title]
          @blog['description']=params[:desc]
          @blog['added_date']=blogdate
          @blog.save
          flash[:notice] = "Blog entry updated successfully!"
        else
          @blog = Blog.new()
          @blog['blog_type']='subchapter'
          @blog['blog_type_id']=params[:subchapter_id]
          @blog['user_id']=uid
          @blog['title']=params[:title]
          @blog['description']=params[:desc]
          @blog['added_date']=blogdate
          @blog.save
          flash[:notice] = "Blog entry added successfully!"
        end
        if params[:redirect_url]
          redirect_to params[:redirect_url]
        else
          redirect_to :action => 'list', :id =>params[:id]
        end
      end

    else
      redirect_to :controller => "familywebsite", :action => "home", :id => params[:id]
    end
  end

  def create_gallery_blog_entry
    unless params[:gallery_id].blank?
      @gallery_journal = GalleryJournal.find(:first, :conditions => "galerry_id=#{params[:gallery_id]}")
      @gallery = Galleries.find(params[:gallery_id])
      if(@gallery.v_gallery_image == "folder_img.png")
        @image="#{@gallery.img_url}/user_content/photos/big_thumb/noimage.jpg"
      else
        image_name = @gallery.v_gallery_image
        image_name.slice!(-3..-1)
        @image="#{@gallery.img_url}/user_content/photos/icon_thumbnails/#{image_name}png"
      end
      if @gallery_journal
        @title = "Edit blog entry for '#{@gallery.v_gallery_name}'"
      else
        @title = "Create a blog entry for '#{@gallery.v_gallery_name}'"
      end
      unless params[:gallery_journal].blank?
        if @gallery_journal
          @gallery_journal['d_updated_on']=Time.now
          @gallery_journal['d_created_on']=Time.now
          @gallery_journal.update_attributes(params[:gallery_journal])
          flash[:notice] = "Blog entry updated successfully!"
        else
          @gallery_journal = GalleryJournal.new(params[:gallery_journal])
          @gallery_journal['d_updated_on']=Time.now
          @gallery_journal['uid']=logged_in_hmm_user.id
          @gallery_journal.save
          flash[:notice] = "Blog entry added successfully!"
        end
        if params[:redirect_url]
          redirect_to params[:redirect_url]
        else
          redirect_to :action => 'list', :id =>params[:id]
        end
      end

    else
      redirect_to :controller => "familywebsite", :action => "home", :id => params[:id]
    end
  end

  #new gallery blog entry
  def create_gallery_newblog_entry
    unless params[:gallery_id].blank?
      conditions = "galleries.id = #{params[:gallery_id]}"
      @detail = MobileGallery.find :first, :joins => "INNER JOIN sub_chapters ON sub_chapters.id = galleries.subchapter_id INNER JOIN tags ON tags.id = sub_chapters.tagid",:conditions => conditions,
        :select =>"tags.tag_type as chapter_type,tags.id as chapter_id"
      if @detail.chapter_type == 'photo' || @detail.chapter_type == 'audio' || @detail.chapter_type == 'video' # render chapter blog creation if it is an album
        # params[:chapter_id] = @detail.chapter_id
        redirect_to :action => "create_chapter_newblog_entry", :id => params[:id], :chapter_id =>@detail.chapter_id, :redirect_url => params[:redirect_url]
      else
        @blog = Blog.find(:first, :conditions => "blog_type_id=#{params[:gallery_id]} and blog_type='gallery'")
        @gallery = Galleries.find(params[:gallery_id])
        if(@gallery.v_gallery_image == "folder_img.png")
          @image="#{@gallery.img_url}/user_content/photos/big_thumb/noimage.jpg"
        else
          image_name = @gallery.v_gallery_image
          image_name.slice!(-3..-1)
          @image="#{@gallery.img_url}/user_content/photos/icon_thumbnails/#{image_name}png"
        end
        if @blog
          @title = "Edit blog entry for '#{@gallery.v_gallery_name}'"
        else
          @title = "Create a blog entry for '#{@gallery.v_gallery_name}'"
        end
        unless params[:title].blank?

          userid = HmmUser.find(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')")
          uid = userid[0]['id']
          img_url=userid[0]['img_url']
          blogdate="#{params[:blog]['added_date(1i)']}-#{params[:blog]['added_date(2i)']}-#{params[:blog]['added_date(3i)']}"

          if @blog


            @blog['blog_type']='gallery'
            @blog['blog_type_id']=params[:gallery_id]
            @blog['user_id']=uid
            @blog['title']=params[:title]
            @blog['description']=params[:desc]
            @blog['added_date']=blogdate
            @blog.save
            flash[:notice] = "Blog entry updated successfully!"
          else
            @blog = Blog.new()
            @blog['blog_type']='gallery'
            @blog['blog_type_id']=params[:gallery_id]
            @blog['user_id']=uid
            @blog['title']=params[:title]
            @blog['description']=params[:desc]
            @blog['added_date']=blogdate
            @blog.save
            flash[:notice] = "Blog entry added successfully!"
          end
          if params[:redirect_url]
            redirect_to params[:redirect_url]
          else
            redirect_to :action => 'list', :id =>params[:id]
          end
        end
      end
    else
      redirect_to :controller => "familywebsite", :action => "home", :id => params[:id]
    end
  end

  def create_moment_newblog_entry
    unless params[:moment_id].blank?

      @usercontent = UserContent.find(params[:moment_id])
      if(@usercontent.e_filetype=='video' || @usercontent.e_filetype=='swf')
        @image ="#{@usercontent.img_url}/user_content/videos/thumbnails/#{@usercontent.v_filename}"+".jpg"
        @btype='video'
      else
        if(@usercontent.e_filetype=='image')
          @image ="#{@usercontent.img_url}/user_content/photos/small_thumb/#{@usercontent.v_filename}"
          @btype='image'
        else
          @image ="#{@usercontent.img_url}/user_content/audios/speaker.jpg"
          @btype='audio'
        end
      end
      @blog = Blog.find(:first, :conditions => "blog_type_id=#{params[:moment_id]} and blog_type='#{@btype}'")
      if @blog
        @title = "Edit blog entry for '#{@usercontent.v_tagphoto}'"
      else
        @title = "Create a blog entry for '#{@usercontent.v_tagphoto}'"
      end
      unless params[:title].blank?
        userid = HmmUser.find(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')")
        uid = userid[0]['id']
        img_url=userid[0]['img_url']
        blogdate="#{params[:blog]['added_date(1i)']}-#{params[:blog]['added_date(2i)']}-#{params[:blog]['added_date(3i)']}"


        if @blog

          @blog['blog_type']=@btype
          @blog['blog_type_id']=params[:moment_id]
          @blog['user_id']=uid
          @blog['title']=params[:title]
          @blog['description']=params[:desc]
          @blog['added_date']=blogdate
          @blog['status']='active'
          @blog.save
          flash[:notice] = "Blog entry updated successfully!"
        else
          @blog = Blog.new()
          @blog['blog_type']=@btype
          @blog['blog_type_id']=params[:moment_id]
          @blog['user_id']=uid
          @blog['title']=params[:title]
          @blog['description']=params[:desc]
          @blog['added_date']=blogdate
          @blog.save
          flash[:notice] = "Blog entry added successfully!"
        end
        if params[:redirect_url]
          redirect_to params[:redirect_url]
        else
          redirect_to :action => 'list', :id =>params[:id]
        end
      end
    else
      redirect_to :controller => "familywebsite", :action => "home", :id => params[:id]
    end
  end

  def create_moment_blog_entry
    unless params[:moment_id].blank?
      @journals_photo = JournalsPhoto.find(:first, :conditions => "user_content_id=#{params[:moment_id]}")
      @usercontent = UserContent.find(params[:moment_id])
      if(@usercontent.e_filetype=='video' || @usercontent.e_filetype=='swf')
        @image ="#{@usercontent.img_url}/user_content/videos/thumbnails/#{@usercontent.v_filename}"+".jpg"
      else
        if(@usercontent.e_filetype=='image')
          @image ="#{@usercontent.img_url}/user_content/photos/small_thumb/#{@usercontent.v_filename}"
        else
          @image ="#{@usercontent.img_url}/user_content/audios/speaker.jpg"
        end
      end
      if @journals_photo
        @title = "Edit blog entry for '#{@usercontent.v_tagphoto}'"
      else
        @title = "Create a blog entry for '#{@usercontent.v_tagphoto}'"
      end
      unless params[:journals_photo].blank?
        if @journals_photo
          @journals_photo[':updated_date']=Time.now
          @journals_photo['date_added']=Time.now
          @journals_photo.update_attributes(params[:journals_photo])
          flash[:notice] = "Blog entry updated successfully!"
        else
          @journals_photo = JournalsPhoto.new(params[:journals_photo])
          @journals_photo[':updated_date']=Time.now
          @journals_photo['uid']=logged_in_hmm_user.id
          @journals_photo.save
          flash[:notice] = "Blog entry added successfully!"
        end
        if params[:redirect_url]
          redirect_to params[:redirect_url]
        else
          redirect_to :action => 'list', :id =>params[:id]
        end
      end
    else
      redirect_to :controller => "familywebsite", :action => "home", :id => params[:id]
    end
  end

  def create_textblog

    @text_journal = TextJournal.new(params[:text_journal])
    @text_journal['uid']=logged_in_hmm_user.id
    @text_journal['d_updated_at']=Time.now

    if @text_journal.save
      flash[:message] = 'Text blog entry added successfully!'
      redirect_to :controller => 'blog', :action => 'list', :id => params[:id]
    end

  end

  def create_textblogentry

    blogdate="#{params[:blog]['added_date(1i)']}-#{params[:blog]['added_date(2i)']}-#{params[:blog]['added_date(3i)']}"

    @text_journal = Blog.new()
    @text_journal['title']=params[:title]
    @text_journal['description']=params[:desc]
    @text_journal['blog_type']='text'
    @text_journal['user_id']=logged_in_hmm_user.id
    @text_journal['added_date']=blogdate

    if @text_journal.save
      flash[:message] = 'Text blog entry added successfully!'
      redirect_to :controller => 'blog', :action => 'index', :id => params[:id]
    end

  end

  def view_more
    unless params[:bid].blank?
      @current_page = 'blog'
      @conditions= "user_id = #{@family_website_owner.id} AND blogs.id=#{params[:bid]} AND blogs.status='active'"
      @entries = Blog.find(:all,:conditions => @conditions,
        :joins =>"LEFT JOIN tags on (blogs.blog_type='chapter' and blogs.blog_type_id = tags.id)
        LEFT JOIN sub_chapters on (blogs.blog_type='subchapter' and blogs.blog_type_id = sub_chapters.id)
        LEFT JOIN galleries on (blogs.blog_type='gallery' and blogs.blog_type_id = galleries.id)
        LEFT JOIN user_contents on (blogs.blog_type in ('image','audio','video') and blogs.blog_type_id = user_contents.id) and blogs.client='website'
        LEFT JOIN mobile_blog_contents on blogs.client='iphone' and blogs.blog_type in ('image','audio','video') and blogs.blog_type_id=mobile_blog_contents.id",
        :select => "blogs.id as blog_id,blog_type,blogs.client,title,description,blog_type_id,DATE_FORMAT(blogs.added_date,'%W, %b %d, %Y') as created_date,
        tags.v_chapimage as chapter_image,
        sub_chapters.v_image as subchapter_image,
        galleries.v_gallery_image as gallery_image,
        user_contents.v_filename  as v_filename,
        user_contents.img_url as uimg_url,
        user_contents.e_filetype as filetype,
        user_contents.id as user_content_id,
        CONCAT(user_contents.img_url,'/user_content/photos/big_thumb/',v_filename) as content_image_url,
        CONCAT(user_contents.img_url,'/user_content/videos/thumbnails/',v_filename,'.jpg') as content_video_url,
        CONCAT(user_contents.img_url,'/user_content/audios/speaker.jpg') as content_audio_url,
        tags.tag_type as chapter_type,galleries.e_gallery_type as gallery_type,mobile_blog_contents.server_url as mobile_server_url,
        mobile_blog_contents.file_name as mobile_file_name", :limit => 1)
      @results = Blog.format_results2(@entries,params[:id],@family_website_owner.img_url)
      @proxyurls = get_proxy_urls()
      #Blog Comments
      @blog_comments=BlogComment.find(:all,:conditions=>"blog_id=#{params[:bid]} and status='approved'")
    else
      redirect_to :controller =>'blog', :action => 'index', :id => params[:id]
    end
  end

  def addblog_comment
    unless params[:comment].blank?
#      if simple_captcha_valid?
#        @guest_comment = BlogComment.new()
      
      if verify_recaptcha
        @guest_comment = BlogComment.new()
        #@guest_comment = BlogComment.new()
        @guest_comment['blog_id'] = params[:blog_id]
        @guest_comment['name'] = params[:name]
        @guest_comment['comment'] = params[:comment]
        @guest_comment['status'] = 'pending'
        if @guest_comment.save
          $notice_guest
          Postoffice.deliver_comment(params[:comment],'0','Blog Comment',params[:name],@family_website_owner.v_e_mail,@family_website_owner.v_user_name,@family_website_owner.v_e_mail,@family_website_owner.v_myimage,@family_website_owner.img_url)
          flash[:message] = 'Comment added successfully!'
        else
          flash[:message] = 'Add Comment failed...'
        end
        #redirect_to :controller =>'blog', :action => 'view_more', :id => params[:id] , :bid => params[:blog_id]
      else
        flash[:message] = 'Please enter the correct code!'
      end
    end
    render :layout => false
  end


  def manage_bloglist_details
    @current_page = 'blog'


    if(params[:order])
      order=params[:order]
    else
      order="desc"
    end


    userid = HmmUser.find(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')")
    uid1 = userid[0]['id']
    img_url=userid[0]['img_url']

    @conditions= ["user_id = #{uid1} AND blogs.status='active'",{:user_id => uid1}]
    @entries = Blog.paginate  :per_page => 10, :page => params[:page],:conditions => @conditions,
      :joins =>"LEFT JOIN tags on (blogs.blog_type='chapter' and blogs.blog_type_id = tags.id)
        LEFT JOIN sub_chapters on (blogs.blog_type='subchapter' and blogs.blog_type_id = sub_chapters.id)
        LEFT JOIN galleries on (blogs.blog_type='gallery' and blogs.blog_type_id = galleries.id)
        LEFT JOIN user_contents on (blogs.blog_type in ('image','audio','video') and blogs.blog_type_id = user_contents.id) and blogs.client='website'
        LEFT JOIN mobile_blog_contents on blogs.client='iphone' and blogs.blog_type in ('image','audio','video') and blogs.blog_type_id=mobile_blog_contents.id",
      :select => "blogs.id as blog_id,blog_type,blogs.client,title,description,blog_type_id,DATE_FORMAT(blogs.added_date,'%W %b %d , %Y') as created_date,
        tags.v_chapimage as chapter_image,
        sub_chapters.v_image as subchapter_image,
        galleries.v_gallery_image as gallery_image,
        CONCAT(user_contents.img_url,'/user_content/photos/big_thumb/',v_filename) as content_image_url,
        CONCAT(user_contents.img_url,'/user_content/videos/thumbnails/',v_filename,'.jpg') as content_video_url,
        CONCAT(user_contents.img_url,'/user_content/audios/speaker.jpg') as content_audio_url,
        tags.tag_type as chapter_type,galleries.e_gallery_type as gallery_type,mobile_blog_contents.server_url as mobile_server_url,
        mobile_blog_contents.file_name as mobile_file_name",:order=>"blogs.added_date #{order}"

    @results = Blog.format_results(@entries,params[:id],img_url)


    #recent entries
    @total=Blog.count(:all,:conditions => @conditions,
      :joins =>"LEFT JOIN tags on (blogs.blog_type='chapter' and blogs.blog_type_id = tags.id)
        LEFT JOIN sub_chapters on (blogs.blog_type='subchapter' and blogs.blog_type_id = sub_chapters.id)
        LEFT JOIN galleries on (blogs.blog_type='gallery' and blogs.blog_type_id = galleries.id)
        LEFT JOIN user_contents on (blogs.blog_type in ('image','audio','video') and blogs.blog_type_id = user_contents.id) and blogs.client='website'",
      :order =>" blogs.id #{order}")

  end

  def edit_blog
    unless params[:title].blank?
      blogdate="#{params[:blog]['added_date(1i)']}-#{params[:blog]['added_date(2i)']}-#{params[:blog]['added_date(3i)']}"
      @blog = Blog.find(params[:bid])
      @blog['title']=params[:title]
      @blog['description']=params[:desc]
      @blog['added_date']=blogdate

      if @blog.save
        flash[:message] = 'Blog updated successfully'
        redirect_to  :action => 'manage_bloglist_details', :id => params[:id]
      else
        render :action => 'edit_blog', :id => params[:id], :bid => params[:bid]
      end

    else
      @blog=Blog.find(params[:bid])
    end

  end

  def delete_blog

    @blog = Blog.find(params[:bid])
    @blog['status']='inactive'
    if @blog.save
      flash[:message] = 'Blog deleted successfully'
      redirect_to  :action => 'manage_bloglist_details', :id => params[:id]
    else
      render :action => 'edit_blog', :id => params[:id], :bid => params[:bid]
    end

  end

  # Flex service to Blog the contents under file manager
  def fx_blogthis

    logger.info("Blog Info :#{params['data']}")
    result = JSON.parse(params['data'])
    if(result['id']==0)
      @blog=Blog.new()
    else
      @blog=Blog.find(result['id'])
    end
    @blog['blog_type']=result['type']
    @blog['blog_type_id']=result['blog_type_id']
    @blog['added_date']=result['date']
    @blog['user_id']=session[:hmm_user]
    @blog['title']=result['title']
    @blog['description']=result['description']
    if @blog.save
      render :text => @blog.id
    else
      render :text => "0"
    end

  end


  def new_shareblogcomment
    @blogcomment = BlogComment.new
    render :layout => false
  end

  def create_shareblogcomment
    @blogcomment = BlogComment.new()
    @blogcomment['blog_id']=params[:blogid]
    @blogcomment['name']=params[:name]
    @blogcomment['comment']=params[:comment]
    if @blogcomment.save
      $noticenonhmm_jcmt
      flash[:noticenonhmm_jcmt] = 'Thank-you for adding your comment.'
      redirect_to :controller => 'share', :action => 'share_blog_display', :id => params[:re_directid]
    else
      render :action => 'new_shareblogcomment'
    end
  end

end