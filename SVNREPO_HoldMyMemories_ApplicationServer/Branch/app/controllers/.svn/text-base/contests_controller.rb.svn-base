class ContestsController < ApplicationController
  layout "standard"
  include SortHelper
  helper :sort
  include SortHelper
  require 'contacts'
  require 'json'
#  def index
#    list
#    render :action => 'list'
#  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  before_filter :authenticate1, :only => [ :contest_chapter, :contest_sub_chapter ,:contest_gallery ,:contest_moments, :contest_upload, :select_contestmoment, :mycontest_moments, :mymemorable_moments, :logged_videomoment_vote, :logged_moments_vote, :contests_select]

    def authenticate1
      unless session[:hmm_user]
           flash[:notice] = 'Please Login to Access your Account'
           redirect_to :controller => "user_account" , :action => 'login'
      return false
      end
    end
    
   def initialize
     super
        @hmm_users = HmmUsers.find(:all)
   end


  def list
    @contest_pages, @contests = paginate :contests, :per_page => 10
  end

  def show
    @contest = Contest.find(params[:id])
  end

  def new
    @contest = Contest.new
  end

  def create
    @contest = Contest.new(params[:contest])
    if @contest.save
      flash[:notice] = 'Contest was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @contest = Contest.find(params[:id])
  end

  def update
    @contest = Contest.find(params[:id])
    if @contest.update_attributes(params[:contest])
      flash[:notice] = 'Contest was successfully updated.'
      redirect_to :action => 'show', :id => @contest
    else
      render :action => 'edit'
    end
  end

  def destroy
    Contest.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def contest_terms_conditions
    if params[:id] == "memorable"
      @type = params[:id]
    else params[:id] == "cutekid"
      @type = params[:id]
    end
  end
  
  def evaluate_terms
    puts params[:mom]
    if params[:agree] == 'agree'
      redirect_to :action => 'contest_login', :id => params[:id]
    else if params[:agree_down] == 'agree'
      redirect_to :action => 'contest_login', :id => params[:id]
    else
      redirect_to '/'
    end
    end
  end
  
  def contest_login
   if session[:hmm_user]
      @hmm_user=HmmUsers.find(session[:hmm_user])  
    end
    
    render :layout => true
  end
  
  
  
   def authenticate 
   #redirect_to index_url+'account/'
   
   self.logged_in_hmm_user = HmmUser.authenticate(params[:hmm_user][:v_user_name],params[:hmm_user][:v_password])
   #self.logged_in_hmm_user = HmmUser.authenticate("alok","alok")
    if is_userlogged_in?
      if logged_in_hmm_user.e_user_status == 'unblocked'
        #log file entry 
        logger.info("[User]: #{params[:hmm_user][:v_user_name]} [Logged In] at #{Time.now} !")
        @client_ip = request.remote_ip 
        @user_session = UserSessions.new()
        @user_session['i_ip_add'] = @client_ip
        @user_session['uid'] = logged_in_hmm_user.id 
        @user_session['v_user_name'] = logged_in_hmm_user.v_user_name
        @user_session['d_date_time'] = Time.now
        @user_session['e_logged_in'] = "yes"
        @user_session['e_logged_out'] = "no"
        @user_session.save
        #return "true"
        
          if params[:cont] == 'cutekid'
            session[:contests_type] = 'image'
          else if params[:cont] == 'memorable'
            session[:contests_type] = 'video'
          end
          end
        
        session[:alert] = "fnfalert"
        session[:account_type] = logged_in_hmm_user.account_type
        redirect_to :controller => 'contests', :action =>'contest_chapter' 
      else
        reset_session
        flash[:error1] = "User is been blocked.. Contact Admin!!"
        redirect_to :action => 'login'
      end
    else
      flash[:error] = "I'm sorry; either your username or password was incorrect."
      #log file entry
      logger.error("[Invalid Login]: by [User]:#{params[:hmm_user][:v_user_name]} at #{Time.now}") 
      redirect_to :action => 'login'
      return "false"
    end
    
    
  end
  
  
  def contest_chapter
    @hmm_user=HmmUsers.find(session[:hmm_user])
    items_per_page = 9
    sort_init 'd_updateddate'
    sort_update
         
    @total = HmmUser.count(:all , :conditions =>  "id=#{logged_in_hmm_user.id}")
    @friend=HmmUsers.find(logged_in_hmm_user.id)
    uid=@friend.id
    uid=logged_in_hmm_user.id
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"
       
    if(srk==nil)
      sort="id  asc"
    end
   
    @tags_pages, @tags = paginate :tags , :per_page => items_per_page, :order => sort, :conditions => "uid='#{uid}' and status='active' " # ,:order => " #{@sort.to_s} #{@order.to_s} "
          
    if request.xml_http_request?
      render :partial => "chapters_list", :layout => false
    end
  end
  
  def contest_sub_chapter
      sort_init 'd_updated_on'
  sort_update
  if(!@params[:id].nil?)
    session[:tag_id]=@params[:id]
  end
   
    @chapter_belongs_to=Tag.find_by_sql("select a.*,b.* from tags as a,  hmm_users as b where a.id=#{params[:id]} and  a.uid=b.id")
   

  @hmm_user=HmmUsers.find(session[:hmm_user])
  items_per_page = 9
  conditions = ["v_tagname LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?


    uid=logged_in_hmm_user.id

  srk=params[:sort_key] 
  sort="#{srk}  #{params[:sort_order]}"
    
  if( srk==nil)
     sort="id  desc"
   end
  @sub_chapters_pages, @sub_chapters = paginate :sub_chapters ,  :per_page => items_per_page, :conditions => "tagid=#{@params[:id]} and status='active' " , :order => sort #:order => " #{@sort.to_s} #{@order.to_s} "
   countcheck=SubChapter.count(:all,:conditions => "tagid=#{@params[:id]} and status='active'")
         
  @chapter_journal = ChapterJournal.find(:all, :conditions => "tag_id=#{params[:id]}", :order=>"id DESC")
  @tagid = ChapterJournal.find(:all, :conditions => "tag_id=#{params[:id]}")
  @chap_cnt = ChapterJournal.count(:all, :conditions => "tag_id=#{params[:id]}")
  @tag = Tag.find(params[:id])
  session[:chap_id]=params[:id]
  session[:chap_name]=@tag['v_tagname']
#  if request.xml_http_request?
#      render :partial => "chapter_next", :layout => false
#  end
  
   if(countcheck==1)
             gallery = Galleries.find(:all,:conditions=>"subchapter_id='#{@sub_chapters[0]['id']}'")
            redirect_to :controller => "contests" , :action => 'contest_gallery', :id => @sub_chapters[0]['id']
   
    end
  end
  
  def logout
     
   @user_session = UserSessions.new()
        @user_session['uid'] = logged_in_hmm_user.id  
         @user_session['v_user_name'] = logged_in_hmm_user.v_user_name
    if request.post?
        
        reset_session
        flash[:notice] = "You Have Been Successfully logged out." 
        @client_ip = request.remote_ip 
       
       
        @user_session['d_date_time'] = Time.now
        @user_session['i_ip_add'] = @client_ip
        @user_session['e_logged_in'] = "no"
        @user_session['e_logged_out'] = "yes"
        @user_session.save
   end
    #log file entry
   #logger.info("[User]: Logged Out at #{Time.now}") 
   redirect_to :action => 'contest_login'
 end
  
  def contest_moments
    @hmm_user=HmmUsers.find(session[:hmm_user])
    session[:share_with_hmm]=nil
    session[:shid]=nil
    session[:share]=nil
    render :layout => true
    @galleries = Galleries.find(params[:id])
    
    @sub_chapter = SubChapter.find(@galleries.subchapter_id)
         session[:subchap_id]=@galleries.subchapter_id
         session[:sub_chapname]=@sub_chapter['sub_chapname']
         params[:id]=@sub_chapter['tagid']
     @tag = Tag.find(@sub_chapter['tagid'])
         session[:chap_id]=params[:id]
         session[:chap_name]=@tag['v_tagname'] 
  end
  
  
  def contest_gallery
    
    sort_init 'd_updated_on'
    sort_update
    session[:sub_id]=params[:id]
    @hmm_user=HmmUsers.find(session[:hmm_user])
    items_per_page = 9
    galery_id=params[:id]
    conditions = ["v_tagname LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?
    srk=params[:sort_key] 
    sort="#{srk}  #{params[:sort_order]}"
    if( srk==nil)
      sort="id  desc"
    end
    @sub_chapters_galleries_pages, @sub_chapters_gallerie = paginate :galleriess , :order => sort, :per_page => items_per_page, :conditions => "subchapter_id=#{params[:id]} and status='active' and e_gallery_type='#{session[:contests_type]}'" ,:order => sort
    countcheck=Galleries.count(:all, :conditions => "subchapter_id=#{params[:id]} and status='active' and e_gallery_type='#{session[:contests_type]}'")
    for subchap in @sub_chapters_gallerie
     @sub_chapter_count=UserContent.count(:all, :conditions => " gallery_id=#{subchap.id} and status='active'") 
     if(@sub_chapter_count<=0)
       countcheck=countcheck-1
     else
       actualid=subchap.id
     end 
    end 
    #puts countcheck
    @sub_chapter_journal = SubChapJournal.find(:all, :conditions => "sub_chap_id=#{params[:id]}", :order=>"id DESC")
    #Bread crumb sessions
     @sub_chapter = SubChapter.find(params[:id])
         session[:subchap_id]=params[:id]
         session[:sub_chapname]=@sub_chapter['sub_chapname']
         params[:id]=@sub_chapter['tagid']
     @tag = Tag.find(params[:id])
         session[:chap_id]=params[:id]
         session[:chap_name]=@tag['v_tagname']  
     # Journals count
     params[:id]=galery_id
     @subchap_cnt = SubChapJournal.count(:all, :conditions => "sub_chap_id=#{params[:id]}")
     if request.xml_http_request?
      render :partial => "sub_chapter_gallery", :layout => false
     end
     if(countcheck==1)
      redirect_to :controller => "contests" , :action => 'contest_moments', :id =>actualid
     else 
      render :layout => true
    end
  
  end
  
  
  def rapid_registration
    @hmm_user = HmmUser.new
    
  end
  
  def email_verify
    
  end
  
  def conform_email
    @unid = "?id="+params[:id]+"&contest_type="+params[:contest_type]
    @authenticate_unid = HmmUser.count(:all, :conditions => "unid='#{@unid}'")
    @authenti_unid = HmmUser.find(:all, :conditions => "unid='#{@unid}'")
#    @unid = params[:id]
#    @unid.slice!(-0.-9.-1)
    if @authenticate_unid == 1
      
        username = @authenti_unid[0]['v_user_name']
        password = @authenti_unid[0]['v_password']
      
        self.logged_in_hmm_user = HmmUser.authenticate(username,password)
    
      if is_userlogged_in?
        if logged_in_hmm_user.e_user_status == 'unblocked'
         #log file entry 
         logger.info("[User]: #{username} [Logged In] at #{Time.now} !")
         @client_ip = request.remote_ip 
         @user_session = UserSessions.new()
         @user_session['i_ip_add'] = @client_ip
         @user_session['uid'] = logged_in_hmm_user.id 
         @user_session['v_user_name'] = logged_in_hmm_user.v_user_name
         @user_session['d_date_time'] = Time.now
         @user_session['e_logged_in'] = "yes"
         @user_session['e_logged_out'] = "no"
         @user_session.save
         session[:contest] = params[:contest_type]
         redirect_to :controller => 'contests', :action =>'contest_upload'
        end
        #redirect_to :action => authenticate_pass, :username => username, :password =>password   
      end
     else
       redirect_to :controller => 'contests', :action => 'contest_login'
     end
  end
  
    
  def validate_familyname
      color = 'red'
      familyname = params[:familyname]

      family = HmmUser.find_all_by_family_name(familyname)      
      if family.size > 0        
        message_family = 'Family Name already exist'
        @valid = false
      else
        message_family = 'Family Name Is Available'
        color = 'green'
         @valid = true
      end
      @message_family = "<b style='color:#{color}'>#{message_family}</b>"
    
      render :partial=>'message_family'
  end
  
  def validate
    color = 'red'
   username = params[:username]
   
#       username = 'zabi'
#    if username.length < 5
#      message = 'Too short'
#    elsif username.length > 10
#      message = 'Too long'
#    else
      user = HmmUser.find_all_by_v_user_name(username)      
      if user.size > 0        
        message = 'User Name Is Already Registered'
        @valid_username = false
      else
        message = 'User Name Is Available'
        color = 'green'
         @valid_username=true
    end
    
    
#    end
    @message = "<b style='color:#{color}'>#{message}</b>"
    
    render :partial=>'message'
  end
  def validate_email
    color = 'red'
    email = params[:email]
    mail = HmmUser.find_all_by_v_e_mail(email) 
    if mail.size > 0        
        message_email = 'Email Is Already Registered'  
       @valid_email = false
     
   end
   @message_email = "<b style='color:#{color}'>#{message_email}</b>"
    render :partial=>'message_email'
  end

  
    def contest_upload
      if session[:contest] != nil
        @uid = logged_in_hmm_user.id
        @moment_type = session[:contest]
      else
        redirect_to :controller => 'myphotos', :action => 'choose_upload'
      end  
    end
   
    def create_contest
      t = Time.now
      
      # get next id of chapter(tag) to be inserted  
      @tag_max =  Tag.find_by_sql("select max(id) as m from tags")
      for tag_max in @tag_max
        tag_max_id = "#{tag_max.m}"
      end
      if(tag_max_id == '')
        tag_max_id = '0'
      end
      tag_next_id= Integer(tag_max_id) + 1

      # get next id of subchapter to be inserted
      @subchapter_max =  SubChapter.find_by_sql("select max(id) as n from sub_chapters")
      for subchapter_max in @subchapter_max
        subchapter_max_id = "#{subchapter_max.n}"
      end
      if(subchapter_max_id == '')
        subchapter_max_id = '0'
      end
      subchapter_next_id= Integer(subchapter_max_id) + 1

      #get the next id of tag to be inserted
      @galleries_max =  Galleries.find_by_sql("select max(id) as m from galleries")
      for galleries_max in @galleries_max
        galleries_max_id = "#{galleries_max.m}"
      end
      if(galleries_max_id == '')
        galleries_max_id = '0'
      end
      galleries_next_id= Integer(galleries_max_id) + 1
      
      @usercontents_max = UserContent.find_by_sql("select max(id) as m from user_contents")
      for usercontents_max in @usercontents_max
        usercontents_max_id = "#{usercontents_max.m}"
      end
      if(usercontents_max_id == '')
        usercontents_max_id = '0'
      end
      usercontents_next_id= Integer(usercontents_max_id) + 1
      
      @journalphoto_max = JournalsPhoto.find_by_sql("select max(id) as m from journals_photos")
      for journalphoto_max in @journalphoto_max
        journalphoto_max_id = "#{journalphoto_max.m}"
      end
      if(journalphoto_max_id == '')
        journalphoto_max_id = '0'
      end
      journalphoto_next_id= Integer(journalphoto_max_id) + 1
      
      
      if session[:contest] == "Video"
        @filename = params[:hmm_user][:v_myimage]
        @filename = @filename.downcase
        @filename = removeSymbols(@filename)
        @filename = filename.gsub(/'/,"")
    
        @filename = @filename.gsub(".avi", "")
        @filename = @filename.gsub(".flv", "")
        @filename = @filename.gsub(".wmv", "")
        @filename = @filename.gsub(".mpeg", "")
        @filename = @filename.gsub(".mpg", "")
        @filename = @filename.gsub(".mov", "")
        @filename = Iconv.iconv("utf-8", "windows-874", @filename).join
      else
        @filename = removeSymbols(params[:hmm_user][:v_myimage].original_filename)
        @filename = @filename.downcase
      end
      #starting to prepare new tag(chapter) for contest
      @tag_contest = Tag.new()
      @tag_contest['id'] = tag_next_id 
      @tag_contest['v_tagname']="Contest"
      @tag_contest['uid']= logged_in_hmm_user.id
      @tag_contest['default_tag']="yes"
      @tag_contest.e_access = 'public'
      @tag_contest.e_visible = 'yes'
      @tag_contest['d_updateddate']=t
      @tag_contest['d_createddate' ]=t    
      @tag_contest['v_chapimage'] = "#{tag_next_id}"+"_"+"#{@filename}"
        
      #starting to prepare new subchapter for contest
      @sub_chapter_contest = SubChapter.new
      @sub_chapter_contest['id'] = subchapter_next_id + 1
      @sub_chapter_contest['uid']=logged_in_hmm_user.id
      @sub_chapter_contest['tagid']=@tag_contest.id
      @sub_chapter_contest['sub_chapname']="Contest Sub chapter"
      @sub_chapter_contest['v_image']="folder_img.png"
      @sub_chapter_contest['e_access']="public"
      @sub_chapter_contest['d_updated_on'] = t
      @sub_chapter_contest['d_created_on'] = t   
       
      # Start preparing for a new gallery to be created for contest
      @galleries1_contest = Galleries.new()
      @galleries1_contest['id'] = galleries_next_id 
      @galleries1_contest['v_gallery_name']="Contest Image Gallery"
      @galleries1_contest['e_gallery_type']="image"
      @galleries1_contest['d_gallery_date']=Time.now
      @galleries1_contest['e_gallery_acess']="public"
      @galleries1_contest['v_gallery_image']="picture.png"
      @galleries1_contest['subchapter_id']=@sub_chapter_contest.id
      
      # Start preparing for a new gallery to be created for contest
      @galleries2_contest = Galleries.new()
      @galleries2_contest['id'] = galleries_next_id + 1
      @galleries2_contest['v_gallery_name']="Contest Audio Gallery"
      @galleries2_contest['e_gallery_type']="audio"
      @galleries2_contest['d_gallery_date']=Time.now
      @galleries2_contest['e_gallery_acess']="public"
      @galleries2_contest['v_gallery_image']="audio.png"
      @galleries2_contest['subchapter_id']=@sub_chapter_contest.id
    
      # Start preparing for a new gallery to be created for contest
      @galleries3_contest = Galleries.new()
      @galleries3_contest['id'] = galleries_next_id + 2
      @galleries3_contest['v_gallery_name']="Contest Video Gallery"
      @galleries3_contest['e_gallery_type']="video"
      @galleries3_contest['d_gallery_date']=Time.now
      @galleries3_contest['e_gallery_acess']="public"
      @galleries3_contest['v_gallery_image']="video.png"
      @galleries3_contest['subchapter_id']=@sub_chapter_contest.id
      
      # Start preparing for a new usercontent to be created
      @user_content = UserContent.new()
      @user_content['id'] = usercontents_next_id 
      @user_content['e_access'] = "public"
      if session[:contest] == "Video"
        @user_content['e_filetype'] = "video"
      else
        @user_content['e_filetype'] = "image"
      end
      @user_content['v_tagname']="Contest"
      @user_content['v_tagphoto']="Contest"
      @user_content['uid']=logged_in_hmm_user.id
      @user_content['sub_chapid']=@sub_chapter_contest.id
      if session[:contest] == "Video"
        @user_content['gallery_id']= @galleries3_contest.id
      else
        @user_content['gallery_id']= @galleries1_contest.id
      end
      
      @user_content['v_filename']="#{usercontents_next_id}"+"_"+"#{@filename}"
      @user_content['tagid']=@tag_contest.id
      @user_content['d_createddate'] = t #.strftime("%Y:%m:%d %H:%M:%S")
      @user_content['d_momentdate'] = t #.strftime("%Y:%m:%d %H:%M:%S")
    
         
      if session[:contest] == "Video"
        uid=@params[:id]
        @images=@params[:Filedata]
        File.open("#{RAILS_ROOT}/public/user_content/videos/#{usercontents_next_id}_#{@filename}.avi", "wb") { |f| f.write(params[:hmm_user][:v_myimage].read) }
        @user_content.save
        UserContent.save2(@user_content)
        render :layout => false

      else
       
        HmmUser.save(params['hmm_user'],usercontents_next_id,"/user_content/photos", @filename)
        
        img1 = Magick::Image.read("#{RAILS_ROOT}/public/user_content/photos/#{usercontents_next_id}" + "_" + "#{@filename}").first
        img1.write("#{RAILS_ROOT}/public/user_content/photos/#{usercontents_next_id}" + "_" + "#{@filename}")
        originaldate = img1.get_exif_by_entry('DateTimeOriginal')
        
        flexIcon = resizeWithoutBorder(img1, 320, 240, "")
        flexIcon.write("#{RAILS_ROOT}/public/user_content/photos/flex_icon/#{@tag_image}")
      
          img2 = resize(img1, 72, 72,"#{RAILS_ROOT}/public/user_content/photos/big_thumb/#{@tag_contest['v_chapimage']}")
          #img = Magick::Image.read("#{RAILS_ROOT}/public/user_content/photos/cropthumb/#{content[0].v_filename}").first
          folderImage = Magick::Image.read("#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/folder_img.png").first
          imageName = @filename
          imageName.slice!(-4..-1)
          finalImage = folderImage.composite(img2, 4, 9, CopyCompositeOp)
          @newchapterIcon = "#{imageName}.png"
          @usercontentIcon="#{imageName}.jpg"
          @user_content['v_filename']=@usercontentIcon
          @tag_contest['v_chapimage']= @newchapterIcon
      
          #PLEASE DONT FUCK AROUND WITH THIS LINE OF CODE. 
          finalImage.write("#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/#{@newchapterIcon}")
          phto_icon=resize(img1,192,192,"#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/#{@usercontentIcon}")
          phto_icon.write("#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/#{@usercontentIcon}")
         
          #resize(img,254,360,"#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/#{@user_content['v_filename']}")
          big_photo_image=resize(img1,508,720,"#{RAILS_ROOT}/public/user_content/photos/journal_thumb/#{@usercontentIcon}")
          big_photo_image.write("#{RAILS_ROOT}/public/user_content/photos/journal_thumb/#{@usercontentIcon}")
          
          big_photo_thumnail=resize(img1,192,192,"#{RAILS_ROOT}/public/user_content/photos/big_thumb/#{@usercontentIcon}")
          big_photo_thumnail.write("#{RAILS_ROOT}/public/user_content/photos/big_thumb/#{@usercontentIcon}")
          @user_content.save
      end
     
      params[:journal][:updated_date]=Time.now
      @journal =JournalsPhoto.new(params[:journal])
      @journal['id']= journalphoto_next_id
      @journal['user_content_id']= @user_content['id']
      #@journal['v_title']= params[:journal][:v_title]
      #@journal['v_image_comment']= params[:journal][:v_image_comment]
      
      #@journal['date_added']= params[:hmm_user][:d_bdate]
      @journal['updated_date']= t
#      if session[:contest] == 'image'
#         jtype_create = 'photo'
#      else if session[:contest] == 'Video'  
#         jtype_create = 'video'
#      end
#      end
      @journal['jtype']= 'photo'
      
      @contest = Contest.new
      @contest['uid']=logged_in_hmm_user.id
      @contest['moment_id']=@user_content['id']
      @contest['journal_id']= journalphoto_next_id
      @contest['moment_type']=session[:contest]
      @contest['contest_title']='Cute Kid Contest' 
      @contest['contest_entry_date'] = t
     
      
      @tag_contest.save
      @sub_chapter_contest.save
      @galleries1_contest.save
      @galleries2_contest.save
      @galleries3_contest.save
      
      if @journal.save
        @contest.save
        
      
        redirect_to :controller => :contests, :action => :contestmoment_show      
      else
        redirect_to :controller => :contests, :action => :contest_chapter 
      end
    
    end
    
    def get_memories_list
        @moments=UserContent.find(:all, :conditions => "gallery_id='#{params[:id]}'")
       
        render :layout => false
    end
  
    def contestmoment_show                                                                                                   
      @usercontent = UserContent.find(:all, :joins=>"as a, contests as b ", :conditions => "b.uid = #{logged_in_hmm_user.id} and a.id = b.moment_id ")
      @journal = JournalsPhoto.find(:all, :joins=>"as a, contests as b ", :conditions => "b.uid = #{logged_in_hmm_user.id} and b.journal_id = a.id")
      session[:contest] = nil
    end
    
    def select_contestmoment
      issubmitted = Contest.find_by_sql("select *  from contests where contests.moment_id='#{params[:momentid]}' and contests.uid=#{logged_in_hmm_user.id}")  
        
        #to get the moment thumb 
        @moment = UserContent.find(:all, :conditions => "id='#{params[:momentid]}'")
        for mom_thumb in @moment
          moment_thumb = mom_thumb.v_filename
        end
        
        if(issubmitted.length == 0)
          @contest_namecheck = Contest.find_by_sql("select *  from contests where contests.first_name='#{params[:fname]}' and contests.uid=#{logged_in_hmm_user.id}")  
          #Contest.count(:conditions => "uid=#{logged_in_hmm_user.id} and first_name!=#{params[:fname]}")
          if (@contest_namecheck.length == 0)
          @result = "true"
          if params[:journal] == "no"
            @journal = JournalsPhoto.new
            @journal['user_content_id']= params[:momentid]
            @journal['v_title']= params[:title]
            @journal['v_image_comment']= params[:journal_desc]
            @journal['date_added']= params[:date]
            @journal['updated_date']= Time.now
#            if params[:type] == 'image'
#              jtype = 'photo'
#            else if params[:type] == 'video'  
#              jtype = 'video'
#            end
#            end
            @journal['jtype']= 'photo'
            @journal.save
          elsif  params[:journal] == "edited"
            journaledited = JournalsPhoto.find(params[:jid])
            journaledited['v_title']=params[:title]
            journaledited['v_image_comment']=params[:journal_desc]
            journaledited['updated_date']=params[:date]
            journaledited.save;
          else

          end
            @contest = Contest.new
            @contest['uid']=logged_in_hmm_user.id
            @contest['moment_id']=params[:momentid]
            @contest['journal_id']= params[:jid]
            @contest['moment_type']=params[:type]
            @contest['contest_title']='Cute Kid Contest' 
            @contest['first_name']=params[:fname]
            @contest['contest_entry_date'] = Time.now
            @contest.save
            Postoffice.deliver_contest_entrymail(params[:fname],moment_thumb,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_fname,logged_in_hmm_user.v_e_mail)
          else
            @result = "false"
          end
        else
          @result = "submited";
      end
      render :layout => false
    end
    
   def moments_vote
      items_per_page = 12
      
      sort_init 'contest_entry_date'
      sort_update
    
      srk=params[:sort_key]
      sort="#{srk}  #{params[:sort_order]}"
       
      if(srk==nil)
        sort="first_name  asc"
      end
      
      @contest_memoriable = Contest.find(:all, :conditions => "moment_type = 'image'")
      if (params[:query].nil?)
        conditions = "a.moment_id = b.id and a.moment_type = 'image' and a.status = 'active' and a.moment_id=c.user_content_id and b.id=c.user_content_id"
      else
        conditions = "a.moment_id = b.id and a.moment_type = 'image' and a.status = 'active' and a.moment_id=c.user_content_id and b.id=c.user_content_id and ( a.first_name like '#{params[:query]}%' or c.v_image_comment like '%#{params[:query]}%')"
      end
      @contest_cutekid_pages, @contest_cutekid = paginate :contests, :select => "a.*, b.*,c.*,  a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b, journals_photos as c ", :per_page => items_per_page,
        :conditions => "#{conditions}", :order => sort
   end
   
   def videomoment_vote
    items_per_page = 15
    sort_init 'contest_entry_date'
      sort_update
    
      srk=params[:sort_key]
      sort="#{srk}  #{params[:sort_order]}"
       
      if(srk==nil)
        sort="first_name  asc"
      end
    #@contest_cutekid = Contest.find(:all, :joins => "as a, user_contents as b", :conditions => "a.moment_id = b.id and a.contest_title = 'Cute Kid Contest'")
    @contest_memoriable = Contest.find(:all, :conditions => "moment_type='video'")
    if (params[:query].nil?)
        conditions = "a.moment_id = b.id  and  a.moment_type = 'video' and a.moment_id=c.user_content_id and b.id=c.user_content_id and a.status='active'"
    else
      conditions = "a.moment_id = b.id   and  a.moment_type = 'video' and a.moment_id=c.user_content_id and b.id=c.user_content_id and a.status='active' and ( a.first_name like '#{params[:query]}%' or c.v_image_comment like '%#{params[:query]}%')"
    
    end
     @contest_cutekid_pages, @contest_cutekid = paginate :contests, :select => "a.*, b.*,c.v_image_comment,  a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b, journals_photos as c ", :per_page => items_per_page,
        :conditions => "#{conditions}", :order => sort 
    
  end
  
  def momentdetails  
    @moment_details = UserContent.find(:all, :conditions => "id='#{params[:id]}'") 
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:id]}'")
    @contests_approve = Contest.count(:all, :conditions => "moment_id='#{params[:id]}' and status='active'")
    @journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{params[:id]} ")
  end
  
  def videomoment_details
    @moment_details = UserContent.find(:all, :conditions => "id='#{params[:id]}'") 
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:id]}'")
    @journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{params[:id]} ")
  end
  
  def vote
    
      @mom_id = params[:id]
      @contests_det = Contest.find(params[:id])
      @moment_details = UserContent.find(:all, :conditions => "id='#{@contests_det.moment_id}'") 
      @contests_fname = Contest.find(:all, :conditions => "moment_id='#{@contests_det.moment_id}'")
      @journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{@contests_det.moment_id} ")
      render :layout => false
  end
  
  def create_vote
    if (session[:hmm_user].nil?) 
      @contest = Contest.find(params[:mom_id])
      @uid = @contest.uid
      contetsid = @contest.id
      contetsfname = @contest.first_name
      
      #working for thumb nail for e-mail
      momentid = @contest.moment_id
      @moment = UserContent.find(:all, :conditions => "id='#{momentid}'")
      for moment_name in @moment
        moment_filename = moment_name.v_filename
      end
      
      #working for fname and lastname of cntestant
      @username = HmmUser.find(:all, :conditions => "id='#{@uid}'")
      for user in @username
        user_fname = user.v_fname
        user_lname = user.v_lname
      end
      
      @contest_vote = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and email_id = '#{params[:email]}' and  DATE_FORMAT( vote_date, '%Y-%m-%d' ) = CURDATE()")
      if @contest_vote <= 0 
       #calculating next id for the contest vote table
       @contestvote_max =  ContestVotes.find_by_sql("select max(id) as n from contest_votes")
       for contestvote_max in @contestvote_max
         contestvote_max_id = "#{contestvote_max.n}"
       end
       if(contestvote_max_id == '')
         contestvote_max_id = '0'
       end
       contestvote_next_id = Integer(contestvote_max_id) + 1
       #creating unid for the vote conform
       contestuuid=Share.find_by_sql("select uuid() as uid")
       unid=contestuuid[0].uid+""+"#{contestvote_next_id}"
       #inserting new values into contest vote table
       @vote = ContestVotes.new()
       @vote['uid']=@uid
       @vote['contest_id']=contetsid
       @vote['email_id']=params[:email]
       @vote['vote_date']= Time.now
       @vote['unid'] = unid
       if @vote.save
         $notice_vote
         flash[:notice_vote] = 'Thank you for casting your vote! An email has been sent to validate your vote. You can sign up for free now and vote without having to validate via email.'
         Postoffice.deliver_voteconform(params[:email],contetsid, unid,moment_filename,contetsfname,user_fname,user_lname)
         if(session[:video_vote]=='1')
           redirect_to :action => 'videomoment_vote'
         else 
          redirect_to :action => 'moments_vote'
         end 
          else
         $notice_vote
         flash[:notice_vote] = 'Your was not submitted due to technical issue... Please try again!!'
         if(session[:video_vote]=='1')
           redirect_to :action => 'videomoment_vote'
         else 
          redirect_to :action => 'moments_vote'
         end 
       end
    
     else
      $notice_vote
      flash[:notice_vote] = 'You have already voted for this moment.. you can cast your vote only once per child!!'
      redirect_to :action => 'moments_vote'
    end
    else
      redirect_to :action => 'vote_cal', :id => params[:mom_id]
    end 
  end
  
  def mycontest_moments
    items_per_page = 15
    @moment_count = Contest.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and moment_type = 'image'")
    @contest_cutekid_pages, @contest_cutekid = paginate :contests, :select => "a.*, b.* , a.id as contest_id" ,:joins=>"as a, user_contents as b ", :per_page => items_per_page,
     :conditions => "a.moment_id = b.id and a.moment_type = 'image' and a.uid='#{logged_in_hmm_user.id}'"
  end
  
  def mymemorable_moments
    items_per_page = 15
    @moment_count = Contest.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and moment_type = 'video'")
     @contest_memoriable_pages, @contest_memoriable = paginate :contests, :select => "a.*, b.* , a.id as contest_id" ,:joins=>"as a, user_contents as b ", :per_page => items_per_page,
        :conditions => "a.moment_id = b.id and a.moment_type = 'video' and a.uid='#{logged_in_hmm_user.id}'"
  end
  
  def conform_vote
    
  end
  
  def authenticate_vote
    @authenticate_vote_count = ContestVotes.count(:conditions => "unid='#{params[:id]}'")
    if @authenticate_vote_count == 1
      contest_votes = ContestVotes.find(:all, :conditions => "unid='#{params[:id]}'")
      
      contest_votes[0].unid = "null"
      contest_votes[0].conformed = 'yes'
      contest_votes[0].save
      @contest_vote_count = ContestVotes.count(:all, :conditions => "contest_id = '#{contest_votes[0].contest_id}' and conformed='yes'")
        countest_update = Contest.find(contest_votes[0].contest_id)
        countest_update.votes = @contest_vote_count
        countest_update.save
      $notice_voteconform
      flash[:notice_voteconform] = 'Thank you for Voting your favourite moment...'
      redirect_to :action => 'conform_vote'
    else
      $notice_voteconform
      flash[:notice_voteconform] = 'Your vote has not been confirmed due to invalid key... Please try again...!! '
      redirect_to(:action => "conform_vote")
    end
    
  end

  def contests_select
    @image_contest_count = Contest.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and moment_type = 'image'")
    @video_contest_count = Contest.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and moment_type = 'video'")
  end
  
  def logged_moments_vote
    items_per_page = 12
    sort_init 'contest_entry_date'
    sort_update
    
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"
       
    if(srk==nil)
      sort="first_name  asc"
    end
      #@contest_cutekid = Contest.find(:all, :joins => "as a, user_contents as b", :conditions => "a.moment_id = b.id and a.contest_title = 'Cute Kid Contest'")
      #@contest_memoriable = Contest.find(:all, :conditions => "contest_title = 'Memorable Moments Contest'")
      if (params[:query].nil?)
        conditions = "a.moment_id = b.id and a.moment_type = 'image' and a.status = 'active' and a.moment_id=c.user_content_id and b.id=c.user_content_id"
      else
        conditions = "a.moment_id = b.id and a.moment_type = 'image' and a.status = 'active' and a.moment_id=c.user_content_id and b.id=c.user_content_id and ( a.first_name like '#{params[:query]}%' or c.v_image_comment like '%#{params[:query]}%')"
      end
      @contest_cutekids_pages, @contest_cutekids = paginate :contests, :select => "a.*, b.*,c.v_image_comment,  a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b, journals_photos as c ", :per_page => items_per_page,
         :order => sort, :conditions => "#{conditions}"
  end
  
  def vote_cal
    @contest = Contest.find(params[:id])
    @uid = @contest.uid
    contetsid = @contest.id
    contest_typ = @contest.moment_type 
    
    @contest_vote1 = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and hmm_voter_id = '#{logged_in_hmm_user.id}' and  DATE_FORMAT( vote_date, '%Y-%m-%d' ) = CURDATE()")
    if @contest_vote1 <= 0 
      #calculating next id for the contest vote table
      @contestvote_max =  ContestVotes.find_by_sql("select max(id) as n from contest_votes")
      for contestvote_max in @contestvote_max
        contestvote_max_id = "#{contestvote_max.n}"
      end
      if(contestvote_max_id == '')
        contestvote_max_id = '0'
      end
      contestvote_next_id = Integer(contestvote_max_id) + 1
    
      #creating unid for the vote conform
#      contestuuid=Share.find_by_sql("select uuid() as uid")
#      unid=contestuuid[0].uid+""+"#{contestvote_next_id}"
    
      #inserting new values into contest vote table
      @vote = ContestVotes.new()
      @vote['uid']=@uid
      @vote['contest_id']=contetsid
      @vote['hmm_voter_id']=logged_in_hmm_user.id
      @vote['vote_date']= Time.now
      
      @vote['conformed'] = 'yes'
      if @vote.save
        
        @contest_vote_count = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and conformed='yes'")
        countest_update = Contest.find(contetsid)
        countest_update.votes = @contest_vote_count
        countest_update.save
        $notice_vote
        flash[:notice_vote] = 'Vote has been successfully submitted.. '
        #Postoffice.deliver_voteconform(params[:email],contetsid, unid)
        if contest_typ == 'image' 
          redirect_to :action => 'logged_moments_vote'
        else if contest_typ == 'video' 
          redirect_to :action => 'logged_videomoment_vote'
        end
        end      
      else
        $notice_vote
        flash[:notice_vote] = 'Your was not submitted due to technical issue... Please try again!!'
        if contest_typ == 'image' 
          redirect_to :action => 'logged_moments_vote'
        else if contest_typ == 'video' 
          redirect_to :action => 'logged_videomoment_vote'
        end
        end 
      end
    
    else
      $notice_vote
      flash[:notice_vote] = 'You have already voted for this moment.. you can cast your vote only once per child!!'
      if contest_typ == 'image' 
          redirect_to :action => 'logged_moments_vote'
        else if contest_typ == 'video' 
          redirect_to :action => 'logged_videomoment_vote'
        end
        end 
    end
    
  end
  
  def logged_videomoment_vote
    items_per_page = 15
    sort_init 'contest_entry_date'
    sort_update
    
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"
       
    if(srk==nil)
      sort="first_name  asc"
    end
    #@contest_cutekid = Contest.find(:all, :joins => "as a, user_contents as b", :conditions => "a.moment_id = b.id and a.contest_title = 'Cute Kid Contest'")
    #@contest_memoriable = Contest.find(:all, :conditions => "contest_title = 'Memorable Moments Contest'")
    if (params[:query].nil?)
        conditions = "a.moment_id = b.id and a.moment_type = 'video' and a.moment_id=c.user_content_id and b.id=c.user_content_id and a.status='active'"
    else
      conditions = "a.moment_id = b.id and a.moment_type = 'video' and a.moment_id=c.user_content_id and b.id=c.user_content_id and a.status='active' and ( a.first_name like '#{params[:query]}%' or c.v_image_comment like '%#{params[:query]}%')"
    
    end
     @contest_video_pages, @contest_video = paginate :contests, :select => "a.*, b.*,c.v_image_comment,  a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b, journals_photos as c ", :per_page => items_per_page,
        :conditions => "#{conditions}", :order => sort
  end
    
    def logged_terms_conditions
      if params[:id] == 'cutekid'
         session[:contests_type] = 'image'
      else if params[:id] == 'memorable'
         session[:contests_type] = 'video'
      end
      end
    end
  def facebook_logout
    :log_out_of_facebook
  end
  
  def myspace_invite
    
  end
  
  def import
  
  begin

      @sites = { "gmail" => Contacts::Gmail, "yahoo" => Contacts::Yahoo}
      puts params[:login]
      puts params[:password]
      @contacts = @sites[params[:from]].new(params[:login], params[:password]).contacts
      require 'pp'
      #pp @contacts[2][1]
      
      @email_names = []
      @emails_list = []
      i=0
      for cnts in @contacts
        @email_names[i] = "#{cnts[0]}"
        @emails_list[i] = "#{cnts[1]}"
        i=i+1
      end
      
      pp @email_names
      
      
      
    end
end

def import_form
  
end

def vote_request
  res_emails=""
  for emails in params[:email_id]
    res_emails=res_emails + "#{emails},"
  end
  res_emails = "#{res_emails}" + "admin@holdmymemories.com"
  puts res_emails
  vote_url = "#{session[:vote_url]}"
  email = "#{res_emails}"
  mesg = params[:message]
  Postoffice.deliver_votereq_mail(email,vote_url,mesg)
  $notice_invite
      flash[:notice_invite] = 'You have Succefully Invited your friends to vote!!'
  if session[:hmm_user]
    redirect_to :action => 'logged_moments_vote'
  else
    redirect_to :action => 'moments_vote'
  end
end

end
