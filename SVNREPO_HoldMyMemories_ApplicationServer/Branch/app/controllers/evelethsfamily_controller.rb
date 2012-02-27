class EvelethsfamilyController < ApplicationController
  
  layout "evelethsFamily"
  def evelethsfamily
     @link = request.request_uri
  end
  
  def chapters_display
    uid = 4;
    @results = Tag.find(:all, :conditions => "uid=#{uid} and status='active' and default_tag='yes' " , :order => "id ASC" )
	#@results = Tag.find(:all)
    render :layout => false
	#render :amf => @results
  end
  
  def subchapters
    @chapterid = "#{params[:id]}"
  end
  def coverFlowImages
     	 @subchapters = SubChapter.find(:all, :conditions=>"tagid=#{params[:id]} and status='active' ")
	 @chapterid = params[:id]	 
	  render :layout => false
	end
  def biographies
    
  end
  
  def gallerycoverflowimages
   
    @galleries = Galleries.find(:all, :conditions=>"subchapter_id=#{params[:id]} and status='active'")
    @subchapterid = params[:id]
    render :layout => false
  end
  
  def gallery_fisheye
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
    @subchapterid = params[:id];
    @buttonVisibility = "false";
  end
  
  
  def videoCoverflow
    
    @gallery=Galleries.find(params[:id])
    @sub_chapter = SubChapter.find(@gallery.subchapter_id)	
    @userid = HmmUser.find(:all, :conditions => "id=#{@sub_chapter.uid}") 
    @uid = @userid[0]['id']
    @family_name=@userid[0]['family_name']
    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{@family_name}' and password_required='yes'")
    
    if(@password_protected > 0 )
      @e_acess="and (e_access='public' or e_access='semiprivate')"
    else 
      @e_acess="and e_access='public'"
    end
    @contents = UserContent.find(:all, :conditions => "gallery_id=#{params[:id]} and status='active' #{@e_acess} ", :order => 'id desc')
    render :layout => false
  end
  
  def showGallery
    
    @gallery=Galleries.find(params[:id])
    @sub_chapter = SubChapter.find(@gallery.subchapter_id)	
    @userid = HmmUser.find(:all, :conditions => "id=#{@sub_chapter.uid}") 
    @uid = @userid[0]['id']
    @family_name=@userid[0]['family_name']
    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{@family_name}' and password_required='yes'")
    
    if(@password_protected > 0 )
      @e_acess="and (e_access='public' or e_access='semiprivate')"
    else 
      @e_acess="and e_access='public'"
    end
    
    @contents = UserContent.find(:all, :conditions => "gallery_id=#{params[:id]} and status='active' #{@e_acess}",:order =>'id desc')
    render :layout => false
  end
  
  def showAudioGallery
    
    @gallery=Galleries.find(params[:id])
    @sub_chapter = SubChapter.find(@gallery.subchapter_id)	
    @userid = HmmUser.find(:all, :conditions => "id=#{@sub_chapter.uid}") 
    @uid = @userid[0]['id']
    @family_name=@userid[0]['family_name']
    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{@family_name}' and password_required='yes'")
    
    if(@password_protected > 0 )
      @e_acess="and (e_access='public' or e_access='semiprivate')"
    else 
      @e_acess="and e_access='public'"
    end
    
    @contents = UserContent.find(:all, :conditions => "gallery_id=#{params[:id]} and status='active' #{@e_acess}",:order =>'id desc')
    render :layout => false
  end
  
  
  
  def journals
  

 tagcout = Tag.find_by_sql(" select 
       count(*) as cnt
         from chapter_journals as a,tags as t 
         where 
         a.tag_id=t.id 
         and 
         t.uid=#{4} ")
 subcount = SubChapter.find_by_sql("
 select 
        count(*) as cnt
        from 
        sub_chap_journals  as b, 
        sub_chapters as s 
        where 
        s.uid=#{4} 
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
        s1.uid=#{4} 
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
        d.user_content_id=u.id and u.uid=#{4}
  
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
         a.d_updated_at as d_updated_at 
         from chapter_journals as a,tags as t 
         where 
         a.tag_id=t.id 
         and 
         t.uid=#{4}
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
        b.updated_on as d_updated_at 
        from 
        sub_chap_journals  as b, 
        sub_chapters as s 
        where 
        s.uid=#{4} 
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
        c.d_updated_on as d_updated_on 
        from 
        gallery_journals   as c, 
        galleries as g, 
        sub_chapters as s1
        where 
        s1.uid=#{4} 
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
        d.date_added  as d_updated_on 
        from 
        journals_photos   as d,
        user_contents as u
        where 
        d.user_content_id=u.id and u.uid=#{4}
     )
     order by d_created_at desc limit #{x}, #{y} ")
  
  #@tagid = ChapterJournal.paginating_sql_find(@cnt, sql, {:page_size => 10, :current => params[:page]})
  # @tagid1, @tagid = paginate_by_sql ChapterJournal, sql, 20 
  
  
  
  
  
  if(@params[:page]==nil)
  else
    render :layout => false
  end  
   


  end
  
  def moment_view
   
  end
   def contactus
     
   end
  
  def addcontact
    
    @contact_u = ContactU.new(params[:contact_u])
    @contact_u.subject = "HoldMyMemories Contact Us Information..."
    if @contact_u.save
       Postoffice.deliver_contactUsreport(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email)
      $notice_contact
      flash[:notice_contact] = 'The Contact Us Informantion was successfully Sent... Thank You!!'
    render :action => 'contactus'
  end
end

def  moment_page
    

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
    link = params[:link]
    sender_name = params[:sender_name]
    sender_email = params[:sender_email]
    if params[:reciepent_email]
      @frdEmail = params[:reciepent_email]
      frindsEmail=@frdEmail.split(',')
      for i in frindsEmail
        Postoffice.deliver_shareFamilypages(i,sender_name,sender_email,link)
      end
    end
    $share_familypage
        flash[:share_familypage] = "Share was Successfully sent to Recipent's e-mail!!"
    redirect_to :action => :evelethfamily
  end
 
end

