class MyFamilywebsiteController < ApplicationController

  layout "myfamilywebsite"
 
  require 'rubygems'
  
  def login_required
    
  end

  def home
    contentservers = ContentPath.find(:all)
    @proxyurls = nil
    for server in contentservers
      if(@proxyurls == nil)
        @proxyurls = server['content_path']
      else
        @proxyurls = @proxyurls +','+server['content_path']
      end
    end
    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{params[:id]}' and password_required='yes'")
    
      # @hmm_user=HmmUsers.find(session[:family])
    
#     if session[:family] == '' || session[:family] == nil
#    
#      
#      puts "went in"
#      
#      puts session[:family]
#      
#    else 
#      if session[:family]==params[:id]
#       else
#         redirect_to :controller => 'my_familywebsite', :action => 'home', :id => session[:family]
#         
#       end
##       @userid = HmmUser.find(:all, :conditions => "family_name='#{params[:family]}'")
##      @uid = @userid[0]['id']
##      @hmmuserid = HmmUser.find(:all, :conditions => "id='#{@uid}'")
    
   
     
      @userid = HmmUser.find(:all, :conditions => "family_name='#{params[:id]}'")
    begin
    if(@userid != nil)

      @uid = @userid[0]['id']
      @hmmuserid = HmmUser.find(:all, :conditions => "id='#{@uid}'")

      #    else if @password_protected > 0
      #      @userid = HmmUser.find(:all, :conditions => "family_name='#{params[:id]}'")
      #      @uid = @userid[0]['id']
      #      @hmmuserid = HmmUser.find(:all, :conditions => "id='#{@uid}'")
      
      
      if( session[:family]!=params[:id] && @password_protected > 0)
        #redirect_to :action => 'login', :id => params[:id], :url => "/my_familywebsite/home/#{params[:id]}"
        if(session[:family]=='' || session[:family]==nil)
          redirect_to :action => 'login', :id => params[:id], :url => request.request_uri
        else
        redirect_to :controller => 'my_familywebsite', :action => 'home', :id => session[:family], :family => params[:family]
         #flash[:login] = 'You have already logged in as'
      end
#      else
#        redirect_to :action => 'login', :id => params[:id], :url => "/my_familywebsite/home/#{params[:id]}"
      
      end
    else
       redirect_to "http://www.holdmymemories.com"
    end
  rescue
    redirect_to "/my_familywebsite/correct_familyname"
  end
    
   
    #    end
  end
  
  def correct_familyname
    
  end
  
  def login
    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{params[:id]}' and password_required='no'")
    if @password_protected > 0
      #session[:family]=params[:id]
     
      redirect_to :action => 'home', :id => params[:id]
   
    end
  end
  
  
  
  def authenticate 
   
    #redirect_to index_url+'account/'
    #   pass = @uid.familywebsite_password
    @logged_in_family=HmmUser.count(:all, :conditions => "familywebsite_password='#{params[:familywebsite_password]}' and family_name='#{params[:family_name]}'")
    # self.logged_in_family = HmmUser.authenticate(params[:hmm_user][:family_name],params[:hmm_user][:familywebsite_password])
    #self.match = HmmUser.find_by_familywebsite_password("familywebsite_password")
   
    if @logged_in_family > 0
      reset_session
     
      
      session[:family]=params[:family_name]
      if(params[:url]==nil || params[:url]=="")
        redirect_to :action => 'home', :id => params[:family_name]
      else 
        redirect_to params[:url]
      end
     
    else
      #reset_session
      flash[:error1] = "Invalid login!!"
      redirect_to :action => 'login', :id => params[:family_name] 
    end
  end
 
  def logout
  
    if request.post?
        
      reset_session
      flash[:notice] = "You Have Been Successfully logged out." 
        
    end
    #log file entry
    #logger.info("[User]: Logged Out at #{Time.now}") 
    redirect_to :action => 'login', :id => params[:id]
  end
  
  def chapters_display
    uid =params[:id]
    
    @password_protected = HmmUser.count(:all, :conditions => "id='#{uid}' and password_required='yes'")
    
    if @password_protected > 0
      
      @e_access="and (e_access='public' or e_access='semiprivate')"
    else
      @e_access="and e_access='public'"
    end
    @results = Tag.find(:all, :conditions => "uid=#{uid}  and status='active' and default_tag='yes' #{@e_access} " , :order => "id ASC" )
    #@results = Tag.find(:all)
    render :layout => false
    #render :amf => @results
  end
  
  
  
  def subchapters
    
    contentservers = ContentPath.find(:all)
    @proxyurls = nil
    for server in contentservers
      if(@proxyurls == nil)
        @proxyurls = server['content_path']
      else
        @proxyurls = @proxyurls +','+server['content_path']
      end
    end
    @sub_chapter = SubChapter.find(:all, :conditions => "tagid='#{params[:id]}'")	
    @userid = HmmUser.find(:all, :conditions => "id='#{@sub_chapter[0].uid}'") 
    #@userid = HmmUser.find(:all, :conditions => "family_name='rakeshfamily'") 
    @uid = @userid[0]['id']
    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{@userid[0][:family_name]}' and password_required='yes'")
    
      if(session[:family].nil? && @password_protected > 0 )
      redirect_to :action => 'login', :id => params[:id], :url => request.request_uri
      end
    
                
    
      @chapterid = "#{params[:id]}"
      
      if( @password_protected > 0)
        @e_acess="and (e_access='public' or e_access='semiprivate')"
      else 
        @e_acess="and e_access='public'"
      end  
      
      @item = SubChapter.count(:all,:conditions =>"tagid=#{params[:id]} and status='active' #{@e_acess}" )
   
      if(@item==1)
        @subchapter=SubChapter.find(:all,:conditions =>"tagid=#{params[:id]} and status='active' #{@e_acess}" )
        redirect_to :action => 'gallery', :id => "#{@subchapter[0]['id']}"
      end
   
      
      #    end
    
    
  end
  
  def coverFlowImages
    
    @sub_chapter = SubChapter.find(:all, :conditions => "tagid='#{params[:id]}'")	
    @userid = HmmUser.find(:all, :conditions => "id='#{@sub_chapter[0].uid}'") 
    #@userid = HmmUser.find(:all, :conditions => "family_name='rakeshfamily'") 
    @uid = @userid[0]['id']
    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{@userid[0][:family_name]}' and password_required='yes'")
   
    if( @password_protected > 0)
      @e_acess="and (e_access='public' or e_access='semiprivate')"
    else 
      @e_acess="and e_access='public'"
    end    
    
    @subchapters = SubChapter.find(:all, :conditions=>"tagid=#{params[:id]} and status='active' #{@e_acess} ")
    
    
    
    @chapterid = params[:id]  
    render :layout => false
  end
  
  def biographies
    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{params[:id]}' and password_required='yes'")
    if(session[:family].nil? && @password_protected > 0 )
      redirect_to :action => 'login', :id => params[:id], :url => request.request_uri
    end
    
      @userid = HmmUser.find(:all, :conditions => "family_name='#{params[:id]}'")
      @uid = @userid[0]['id']
      @hmmuserid = HmmUser.find(:all, :conditions => "id='#{@uid}'")
      @biographies = FamilyMember.find(:all, :conditions => "uid='#{@uid}'", :order => 'id')
      #    else if @password_protected > 0
      #      @userid = HmmUser.find(:all, :conditions => "family_name='#{params[:id]}'")
      #      @uid = @userid[0]['id']
      #      @hmmuserid = HmmUser.find(:all, :conditions => "id='#{@uid}'")
      #      @biographies = FamilyMember.find(:all, :conditions => "uid='#{@uid}'")
    
    
  end
    
  def calender
    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{params[:id]}' and password_required='yes'")
    
   
   if(session[:family].nil? && @password_protected > 0 )
      redirect_to :action => 'login', :id => params[:id], :url => request.request_uri
    end
    
     
  end
    
  def messageboard
    if(params[:sucess].nil?)
    else
      flash[:message_board] = "<font color='black' size=3>The Message is succefully saved on the message board..</font>"
    end
    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{params[:id]}' and password_required='yes'")
    
    if(session[:family].nil? && @password_protected > 0 )
      redirect_to :action => 'login', :id => params[:id], :url => request.request_uri
    end
    
      @userid = HmmUser.find(:all, :conditions => "family_name='#{params[:id]}'")
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
      else if(@params[:page]==nil) 
        
      else
        render :layout => false
      end  
    end
    
    
    
  end
    
  def gallerycoverflowimages
   
    @sub_chapter=SubChapter.find(params[:id])
    @uid= @sub_chapter[:uid]
    @password_protected_user = HmmUser.find(@uid)
    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{@password_protected_user[:family_name]}' and password_required='yes'")
    
    
     if(@password_protected > 0)
      @e_acess="and (e_gallery_acess='public' or e_gallery_acess='semiprivate')"
    else  
      @e_acess="and e_gallery_acess='public'"
    end
    
    
    @galleries = Galleries.find(:all, :conditions=>"subchapter_id=#{params[:id]} and status='active' #{@e_acess} ")
    @subchapterid = params[:id]
    render :layout => false
  end
  
  def gallery_fisheye
    contentservers = ContentPath.find(:all)
    @proxyurls = nil
    for server in contentservers
      if(@proxyurls == nil)
        @proxyurls = server['content_path']
      else
        @proxyurls = @proxyurls +','+server['content_path']
      end
    end
    @gallery=Galleries.find(params[:id])
    @sub_chapter = SubChapter.find(@gallery.subchapter_id)	
    @userid = HmmUser.find(:all, :conditions => "id=#{@sub_chapter.uid}") 
    @uid = @userid[0]['id']
    @family_name=@userid[0]['family_name']
    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{@family_name}' and password_required='yes'")
    
    
   if(session[:family].nil? && @password_protected > 0 )
      redirect_to :action => 'login', :id => params[:id], :url => request.request_uri
    end
    
      @gallery  = Galleries.find(:all, :conditions => "id=#{params[:id]}")
      @galleryUrl = ""
      if(@gallery[0].e_gallery_type == "video")
        logger.info("Gallery Type Video")
        @swfName = "CoverFlowVideo"
        @galleryUrl = "/evelethsfamily/videoCoverflow/"+params[:id]
      elsif(@gallery[0].e_gallery_type == "image")
        logger.info("Gallery Type Image")
        @swfName = "PhotoGallery"
        @galleryUrl = "/evelethsfamily/showGallery/"+params[:id]
      elsif(@gallery[0].e_gallery_type == "audio")
        logger.info("Gallery Type Audio")
        @swfName = "CoverFlowAudio"
        @galleryUrl = "/evelethsfamily/showAudioGallery/"+params[:id]
      end
      render :layout => true
         
    
  end
  
  
  def gallery
    #    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{@familyname_gal}' and password_required='no'")
    #    if session[:family]!=@familyname_gal
    contentservers = ContentPath.find(:all)
    @proxyurls = nil
    for server in contentservers
      if(@proxyurls == nil)
        @proxyurls = server['content_path']
      else
        @proxyurls = @proxyurls +','+server['content_path']
      end
    end
    
    @sub_chapter=SubChapter.find(params[:id])
    @uid= @sub_chapter[:uid]
    @password_protected_user = HmmUser.find(@uid)
    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{@password_protected_user[:family_name]}' and password_required='yes'")
    
      if(session[:family].nil? && @password_protected > 0 )
      redirect_to :action => 'login', :id => params[:id], :url => request.request_uri
    end
    
      @subchapterid = params[:id]
      @buttonVisibility = "false"
      @galleriescount = Galleries.count(:all, :conditions => "subchapter_id='#{params[:id]}'  and status='active' and e_gallery_acess='public' ")
      if(@galleriescount==1)
        @galleries = Galleries.find(:all,:conditions => "subchapter_id='#{params[:id]}' and status='active' and e_gallery_acess='public' ")
        redirect_to :action => 'gallery_fisheye', :id => "#{@galleries[0]['id']}"
      
   
      
    end  
        
  end
  
  def videoCoverflow
    @contents = UserContent.find(:all, :conditions => "gallery_id=#{params[:id]} and status='active' and e_access='public'", :order => 'id desc')
    render :layout => false
  end
  
  def showGallery
    @contents = UserContent.find(:all, :conditions => "gallery_id=#{params[:id]} and status='active' and e_access='public'",:order =>'id desc')
    render :layout => false
  end
  
  def showAudioGallery
    @contents = UserContent.find(:all, :conditions => "gallery_id=#{params[:id]} and status='active' and e_access='public'",:order =>'id desc')
    render :layout => false
  end
  
  def journals
    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{params[:id]}' and password_required='yes'")
    if(session[:family].nil? && @password_protected > 0 )
      redirect_to :action => 'login', :id => params[:id], :url => request.request_uri
    end
   
   
  
      userid = HmmUser.find(:all, :conditions => "family_name='#{params[:id]}'") 
      uid1 = userid[0]['id']
      @familyname=params[:id]
 
      tagcout = Tag.find_by_sql(" select 
       count(*) as cnt
         from chapter_journals as a,tags as t 
         where 
         a.tag_id=t.id 
         and 
         t.uid=#{uid1} and t.status='active' and t.e_access='public' ")
      subcount = SubChapter.find_by_sql("
 select 
        count(*) as cnt
        from 
        sub_chap_journals  as b, 
        sub_chapters as s 
        where 
        s.uid=#{uid1} 
        and 
        b.sub_chap_id=s.id  and s.status='active' and s.e_access='public'")
        
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
        and g.subchapter_id=s1.id and g.status='active' and g.e_gallery_acess='public' ")
  
      usercontentcount = UserContent.find_by_sql("
  select 
       count(*) as cnt
        from 
        journals_photos   as d,
        user_contents as u
        where 
        d.user_content_id=u.id and u.uid=#{uid1} 
        and u.status='active' and u.e_access='public'
  
        ")
      galcnt=Integer(galcount[0].cnt)
      tagcnt=Integer(tagcout[0].cnt)
      subcnt=Integer(subcount[0].cnt)
      usercontentcnt=Integer(usercontentcount[0].cnt)
  
      @total=tagcnt+subcnt+galcnt+usercontentcnt
  
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
         t.status='active' and t.e_access='public'
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
        b.sub_chap_id=s.id and s.status='active' and s.e_access='public'
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
        and g.subchapter_id=s1.id  and g.status='active' and g.e_gallery_acess='public')
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
        d.user_content_id=u.id and u.uid=#{uid1} and u.status='active' and u.e_access='public'
     )
     order by d_created_at desc limit #{x}, #{y} ")
  
      #@tagid = ChapterJournal.paginating_sql_find(@cnt, sql, {:page_size => 10, :current => params[:page]})
      # @tagid1, @tagid = paginate_by_sql ChapterJournal, sql, 20 
  
  
  
      
  
      if(session[:journal]=='journal')
        render :layout => true
        session[:journal] = nil
      else if(@params[:page]==nil) 
        
      else
        render :layout => false
      end  
    end
    
    
    

  end
  
  def moment_view
   
  end
  def contactus
    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{params[:id]}' and password_required='yes'")
    
   if(session[:family].nil? && @password_protected > 0 )
      redirect_to :action => 'login', :id => params[:id], :url => request.request_uri
    end
   
    
  end
  
  def addcontact
    
    @contact_u = ContactU.new(params[:contact_u])
    @contact_u.subject = "HoldMyMemories Contact Us Information..."
    if @contact_u.save
      Postoffice.deliver_contactUsreport(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email)
      $notice_contact
      flash[:notice_contact] = 'Thank-you, your information was sent to HoldMyMemories.com'
      render :action => 'contactus_success', :id => params[:id]
    end
  end

  def moment_page
    contentservers = ContentPath.find(:all)
    @proxyurls = nil
    for server in contentservers
      if(@proxyurls == nil)
        @proxyurls = server['content_path']
      else
        @proxyurls = @proxyurls +','+server['content_path']
      end
    end
    @usercontent=UserContent.find(params[:id])


    @userid = HmmUser.find(:all, :conditions => "id='#{@usercontent.uid}'") 
    #@userid = HmmUser.find(:all, :conditions => "family_name='rakeshfamily'") 
    @uid = @userid[0]['id']
    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{@userid[0][:family_name]}' and password_required='yes'")
    
      if(session[:family].nil? && @password_protected > 0 )
      redirect_to :action => 'login', :id => params[:id], :url => request.request_uri
    end
    
   
      session[:usercontent_id]=params[:id]
      @usercontent = UserContent.find(params[:id])
    
      if(params[:page]==nil)
     
        @counts =  UserContent.count(:all, :conditions => " gallery_id='#{@usercontent.gallery_id}' and status='active' ",:order =>'id desc')
        @allrecords =  UserContent.find(:all, :conditions => " gallery_id='#{@usercontent.gallery_id}' and status='active'" ,:order =>'id desc')
        page=0
        for check in @allrecords
          page=page+1
          #puts check.id
        
          if(check.id==@usercontent.id)
            puts params[:id]
            puts check.id
            @nextpage=page
            redirect_to :action => :moment_page, :id=> params[:id], :page =>@nextpage
         
          else
     
          end
        end
      else
    
        @user_content_pages, @user_content = paginate :user_contents, :conditions => "gallery_id='#{@usercontent.gallery_id}' and status='active' ",:order =>'id desc', :per_page => 1
      end
      @norecords=""
   
    
  end
 
 
  def  photo_journal
    

    session[:usercontent_id]=params[:id]
    @usercontent = UserContent.find(params[:id])
    
    if(params[:page]==nil)
     
      @counts =  UserContent.count(:all, :conditions => " gallery_id='#{@usercontent.gallery_id}' and status='active' ",:order =>'id desc')
      @allrecords =  UserContent.find(:all, :conditions => " gallery_id='#{@usercontent.gallery_id}' and status='active'" ,:order =>'id desc')
      page=0
      for check in @allrecords
        page=page+1
        #puts check.id
        
        if(check.id==@usercontent.id)
          puts params[:id]
          puts check.id
          @nextpage=page
          redirect_to :action => :moment_page, :id=> params[:id], :page =>@nextpage
         
        else
     
        end
      end
    else
    
      @user_content_pages, @user_content = paginate :user_contents, :conditions => "gallery_id='#{@usercontent.gallery_id}' and status='active' ",:order =>'id desc', :per_page => 1
    end
    @norecords=""
  end
 
  def share
    @link = request.request_uri
    
    render :layout => false
  end
 
  def shareWorker
    
    #modified fdwefwefwefwefwe
    link = params[:link]
    sender_name = params[:sender_name]
    sender_email = params[:sender_email]
    reciepent_message=params[:reciepent_message]
    if params[:pass]
      pass = params[:pass]
    else
      pass = 'n'
    end
    if (params[:share_type] == 'journal' || params[:share_type] == 'biography')
      @sha_type = params[:share_type]
    else
      @sha_type = 'moment'
    end
    if params[:reciepent_email]
      @frdEmail = params[:reciepent_email]
      frindsEmail=@frdEmail.split(',')
      for i in frindsEmail
        Postoffice.deliver_shareFamilypages(i,sender_name,sender_email,link,reciepent_message,@sha_type,pass)
      end
    end
    session[:journal] = "journal"
    $share_familypage
    flash[:share_familypage] = "<font color='white' size=1>Share was Successfully sent to Recipent's e-mail!!</font>"
    redirect_to link
  end
  
  def validate_pass
    color = 'red'

      @user = HmmUser.count(:all, :conditions => "family_name='#{params[:id]}' and familywebsite_password='#{params[:fwpass]}'")  
      
      if @user > 0    
        message = 'Password Authenticated'
        color = 'green'
        @valid_pass = true
      else
        message = 'Invalid Password'
        
        @valid_pass=false
      end
 
    @message = "<b style='color:#{color}'>#{message}</b>"
    
    render :partial=>"message", :layout => false
  end
 
end
  

