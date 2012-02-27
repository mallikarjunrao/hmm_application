class FaceBookInviteController < ApplicationController
  load "family_website.rb"
  #require 'family_website'
  include FamilyWebsite
  include ApplicationHelper
  #layout "standard"
  layout false
  #layout 'familywebsite_facebook'
  require 'pp'
  require 'rfacebook'
  #before_filter  :check_account


  def init_session


  end


  def check_account(profile_user)


    @path = ContentPath.find(:first, :conditions => "status='active'")
    logger.info(@path).inspect
    logger.info("profile_user id")
    logger.info(profile_user)
    family_name = "uday"
    if !profile_user.nil? && profile_user.to_i != 0
      facebook_profile_id = profile_user
      count = @hmm_user = HmmUser.count(:all, :conditions => "facebook_profile_id = #{facebook_profile_id}")
      logger.info(count)
      if count > 0
        @family_website_owner = HmmUser.find(:first,:joins =>"INNER JOIN themes on hmm_users.theme_id=themes.id", :conditions => "(facebook_profile_id = '#{facebook_profile_id}')",:select => "hmm_users.*,themes.stylesheet as theme") #get the user details
      else
        @family_website_owner = HmmUser.find(:first,:joins =>"INNER JOIN themes on hmm_users.theme_id=themes.id", :conditions => "(family_name='#{family_name}' || alt_family_name='#{family_name}')",:select => "hmm_users.*,themes.stylesheet as theme") #get the user details
      end
      @app_main_width = 520
      @app_width = 500
      @coverflow_width = 475
      @about_us_width = 226
      @home_page_link = 226
      app_layout = "familywebsite_facebook"
    else
      @family_website_owner = HmmUser.find(:first,:joins =>"INNER JOIN themes on hmm_users.theme_id=themes.id", :conditions => "(family_name='#{family_name}' || alt_family_name='#{family_name}')",:select => "hmm_users.*,themes.stylesheet as theme") #get the user details
      @app_main_width = 720
      @app_width = 700
      @coverflow_width = 650
      @about_us_width = 586
      @home_page_link = 586
      app_layout = "familywebsite_facebook_full"
    end

    unless family_name.blank?
      #@family_website_owner = HmmUser.find(:first,:joins =>"INNER JOIN themes on hmm_users.theme_id=themes.id", :conditions => "(family_name='#{family_name}' || alt_family_name='#{family_name}')",:select => "hmm_users.*,themes.stylesheet as theme") #get the user details
      if @family_website_owner
        if (@family_website_owner.account_expdate!=nil && @family_website_owner.account_expdate < Date.current())
          flash[:expired] = 'expired'
          redirect_to "/familywebsite/login/#{family_name}" if params[:action]!='login' unless (@family_website_owner.id)
        elsif(session[:employe]==nil && @family_website_owner.terms_checked == 'false' ) #if the logged in user is not employee and terms is not agreed
          flash[:terms] = 'terms'
          if(session[:hmm_user]) #f the user is logged in, takes to agree terms page
            redirect_to "/user_account/update_terms/"
          else #if the user is not logged in, takes to login page
            redirect_to "/familywebsite/login/#{family_name}" if params[:action]!='login'
          end
        elsif @family_website_owner.e_user_status=='blocked' #displays message, if the user is blocked
          render :text => "This Familywebsite has been Blocked. Please contact Website Administrator at <a href='mailto:admin@holdmymemories.com' >admin@HoldMyMemories.com</a>"
          #        elsif @family_website_owner.password_required == 'yes'
          #          @website_password = "true"
        else
        end
      else
        redirect_to '/'
      end
    end


    logger.info("family nameeeeee")
    logger.info(@family_website_owner.family_name)
    if(@family_website_owner.family_name=='bob' || @family_website_owner.family_name=='eveleth')
      @content_server_url = "http://content.holdmymemories.com"
      params[:id]='bob'
    else
      @content_server_url = @path.content_path
    end
    return app_layout #returns app_layout if all the conditions are cleared
  end

  def index1

    #:requirefacebookinstall

    if fbsession.ready?
      friendUIDs = fbsession.friends_get.uid_list
      @friendNames = []
      @friendimages = []
      @uids = []
      friendsInfo = fbsession.users_getInfo(:uids => friendUIDs, :fields => ["first_name", "last_name","pic_square", "status"])
      i=0

      for userInfo in friendsInfo.user_list
        @uids[i] = userInfo.uid
        @friendNames[i] = userInfo.first_name + " " + userInfo.last_name
        @friendimages[i] = userInfo.pic_square
        i=i+1
        pp userInfo
        pp session
        #puts friendsNames
        #fbsession.notifications_send(:to_ids => ['400156', '1906543'], :notification => message)
      end
    else
      :require_facebook_install
    end

  end

  def add_app

  end
  def index2
    if fbsession.ready?
      friendUIDs = fbsession.friends_get.uid_list
      @friendNames = []
      @friendimages = []
      friendsInfo = fbsession.users_getInfo(:uids => friendUIDs, :fields => ["first_name", "last_name","pic_square", "status"])
      i=0
      for userInfo in friendsInfo.user_list
        @friendNames[i] = userInfo.first_name + " " + userInfo.last_name
        @friendimages[i] = userInfo.pic_square
        i=i+1
        pp userInfo
        pp session
        #puts friendsNames
      end
    else
      :require_facebook_install
    end
  end
  def facebook_logout
    if fbsession.ready?
      session[:__RFACEBOOK_fbsession_holder] = nil
      session[:__RFACEBOOK_fbparams] = nil
      @fbsession_holder = nil
      session[:_rfacebook_fbsession_holder] = nil
      session[:_rfacebook_fbparams] = nil
      @fbsession_holder = nil
      :log_out_of_facebook
    end
  end

  def notify_friend
    if fbsession.ready?
      message ="#{params[:message]} <br><br>
      <a href='#{session[:vote_url]}' target='_blank'>#{session[:vote_url]}</a> <br><br>Thank-You!"
      #      frnlist = ""
      #
      #      for frndsid in params[:frnid]
      #        frnlist = frnlist + "'#{frndsid}',"
      #      end
      #        frnlist = frnlist + "0"
      fbsession.notifications_send(:to_ids => params[:frnid] , :notification => message)
      fbsession.app_application(:id => params[:id])


    else
      :require_facebook_install
    end
  end

  def myspace_invite

  end

  def vote
    session[:vote_url] = params[:url]

    redirect_to :controller => "face_book_invite", :action => 'index1'
  end

  def vote1
    @current_facebook_user = facebook_session.user
  end



  # Facebook integration for HMM Aplication starts

  def home

    if(params[:fb_sig_profile_user] && params[:fb_sig_profile_user] != '' && params[:fb_sig_profile_user] != nil)
      @profile_id = params[:fb_sig_profile_user] if params[:fb_sig_profile_user]
      @hmm_user = HmmUser.find(:first, :conditions => "facebook_profile_id = #{@profile_id}")

    end

    if params[:user_name]
      user_name = params[:user_name]
      email = params[:email]
      profile_id = params[:profile_id]
      hmmuser = HmmUser.find(:first, :conditions => "v_user_name = '#{user_name}' and v_e_mail = '#{email}'")
      if hmmuser.nil?
        flash[:message] = "Invalid HMM Username or Email"
      else
        sql = ActiveRecord::Base.connection();
        sql.update "UPDATE hmm_users SET facebook_profile_id = #{profile_id} WHERE id = #{hmmuser.id}"
        #HmmUser.update(hmmuser.id,:facebook_profile_id => profile_id)

       redirect_to( "http://www.facebook.com/profile.php?id=#{profile_id}&v=app_104789226241181")
       # redirect_to "#http://w.facebook.com/profile.php?id=#{profile_id}&v=app_104789226241181"
      end

    end
  end

  def signup

    if params[:sub]
      @hmm_user = HmmUser.new
      @hmm_user['v_fname'] = params[:first_name]
      @hmm_user['v_lname'] = params[:last_name]
      @hmm_user['v_user_name'] = params[:user_name]
      @hmm_user['v_password'] = params[:password]
      @hmm_user['v_e_mail'] = params[:email]
      @hmm_user['family_name'] = params[:family_name]
      if @hmm_user.save
        profile_id = params[:profile_id]
        redirect_to "http://www.facebook.com/profile.php?id=#{profile_id}&v=app_104789226241181"
      end
    else
      @profile_id = params[:profile_id]
    end
  end

  def familywebsite_test

    self.familywebsite

  end

  def familywebsite

    # check_account method is to get the familywebsite owner data
    if params[:fb_sig_profile]
      app_layout = self.check_account(params[:fb_sig_profile])
    else
      app_layout = self.check_account(params[:fb_sig_profile_user])
    end

    logger.info("contetetetetetetetetetetete")
    logger.info(@content_server_url)
    # @image_path is variables used in the CSS to specify the absolute path for the image
    @image_path = "#{@path.proxyname}/images/themes/classic/"
    # get recent images uploaded by the user start
    if(@family_website_owner.password_required == 'no')
      access="(e_access='public' or e_access='semiprivate')"
    else
      access="e_access='public'"
    end
    # Fetching the Carousel coverflow details
    @versions=VersionDetail.find(:first,:conditions=>"file_name='Carousel'")

    # Get the date for recent moments
    @recent_moments = UserContent.find(:all, :conditions => "uid=#{@family_website_owner.id} and e_filetype = 'image' and #{access} and status = 'active'",:select =>"id,v_filename", :order => "id desc", :limit =>5)

    # Ajax call - Authentication of familywebsite password starts
    if params[:visitor_pwd]
      password = params[:visitor_pwd]
      hmm_count = HmmUser.count(:all, :conditions => "id = '#{@family_website_owner.id}' and familywebsite_password = '#{password}'")
      if hmm_count > 0
        @visitor_message = "success"
      else
        @visitor_message = "Invalid Password"
      end
      render :layout => false
    end

    if @family_website_owner.password_required == 'no' || @message == "success"
      @website_password = false
    else
      @website_password = true
    end
    # Ajax call - Authentication of familywebsite password ends

    unless  params[:visitor_pwd]
      # Condition to show the login page if the owner is not authenticated

      unless params[:fb_sig_profile_user].blank?
        @profile_id = params[:fb_sig_profile_user]
        @hmm_user = HmmUser.find(:first, :conditions => "facebook_profile_id = #{@profile_id}")
        unless @hmm_user.nil?
          render :layout => app_layout
        else
          render :layout => false
        end
      else
        # Default Layout to show in bob account (apps.facebook.com/hold-my-memories/)
        unless @hmm_user
           render :layout => app_layout
        end
      end
    end

  end

  # Facebook integration for HMM Aplication ends

  def authenticate

    if params[:user_name] && params[:email]
      user_name = params[:user_name]
      email = params[:email]
      @profile_id = params[:profile_id]
      @app_id = "app_142094399159483"
      hmmuser = HmmUser.find(:first, :conditions => "v_user_name = '#{user_name}' and v_e_mail = '#{email}'")
      if hmmuser.nil?
        @message = "Invalid HMM Username or Email"
      else
        @message = "success"
        sql = ActiveRecord::Base.connection();
        sql.update "UPDATE hmm_users SET facebook_profile_id = #{@profile_id} WHERE id = #{hmmuser.id}"
      end
    end
    render :layout => false
  end

  def biography
    self.check_account(params[:facebook_profile_id])
    #    familywebsite = FamilywebsiteController.new
    #
    #    familywebsite.biography(@family_website_owner.family_name)
    @biographies = FamilyMember.find(:all, :conditions => "uid='#{@family_website_owner.id}'", :order => 'id')
    render :layout => false
  end

  def blog
    self.check_account(params[:facebook_profile_id])
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
        tags.v_chapimage as chapter_image,
        sub_chapters.v_image as subchapter_image,
        galleries.v_gallery_image as gallery_image,
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


  #def guestbook_new(facebook_profile_id)
  def guestbook_new
     self.check_account(params[:facebook_profile_id])
    @get_content_url=ContentPath.find(:all, :conditions => "status='active'")
    content_path=@get_content_url[0]['content_path']
    servername=@get_content_url[0]['proxyname']
    logger.info("Chekkkkkkkkkkkkk")
    logger.info(params[:name])
    logger.info(params[:email])
    logger.info(params[:subject])
    logger.info(params[:message])
    logger.info("End of Params")
   # @captcha=GuestbookCommentCaptcha.find(:last)
   #   if params[:captcha]==@captcha.value
   #@userid = HmmUser.find(:all, :conditions => "family_name='#{params[:id]}'")

        @userid = HmmUser.find(:all, :conditions => "facebook_profile_id='#{params[:facebook_profile_id]}'")
        @uid = @userid[0]['id']
        @email = @userid[0]['v_e_mail']
        @fname = @userid[0]['v_fname']
        @hmmuserid = HmmUser.find(:all, :conditions => "id='#{@uid}'")
        #@familyname=params[:id]

        @mesgboard_max =  MessageBoard.count
        puts @mesgboard_max
        mesgboard_next_id= @mesgboard_max + 1

        @message_board = MessageBoard.new()
        @message_board['uid']=@uid
        @message_board['message']=params[:message]
        @message_board['guest_name']=params[:name]
        @message_board['email']=params[:email]
        @message_board['subject']=params[:subject]
        @message_board['title']="Title GBook"
        @message_board['reply']="Reply"

        image=params[:guest_image]
        if (image==nil  or image=="")
          img1 = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/photos/blank.jpg").first
          messageboardimage = resizeWithoutBorder(img1, 98, 74, "")
          @message_board['guest_image']=mesgboard_next_id.to_s+"_"+"blank.jpg"
          messageboardimage.write("#{RAILS_ROOT}/public/hmmuser/message_board/thumb/#{@message_board['guest_image']}")
        else

          @filename = params[:guest_image].original_filename
          @filename = @filename.downcase
          @message_board['guest_image']=mesgboard_next_id.to_s+"_"+"#{@filename}"
          @message_board['img_url']=content_path
          HmmUser.save_mesgboard_img(image,mesgboard_next_id,@filename)
          img1 = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/message_board/#{@message_board['guest_image']}").first
          messageboardimage = resizeWithoutBorder(img1, 98, 74, "")
          messageboardimage.write("#{RAILS_ROOT}/public/hmmuser/message_board/thumb/#{@message_board['guest_image']}")
        end
        @message_board['created_at']=Time.now
        @message_board['updated_on']=Time.now
        @message_board['status']='pending'
        @message_board.save

    #Postoffice.deliver_message_board_notify(@fname,@email,form_data[3], form_data[2],form_data[1],form_data[0],@message_board['guest_image'])
      Postoffice.deliver_message_board_notify(@fname,@email,params[:message], params[:subject],params[:email],params[:name],@message_board['guest_image'])
        flash[:message] = "Comment has been sent.."
        #self.display_comments
        #redirect_to "#{servername}/guest_book/display_comments/#{params[:id]}?success=1"
      #else
      #  redirect_to "#{servername}/guest_book/display_comments/#{params[:id]}"
      #end

        facebook_profile_id = @family_website_owner.facebook_profile_id
        self.fw_display_comments(facebook_profile_id)


  end




  def new_comment
    logger.info("Face Book profiell Id-- starts")
     logger.info(params[:facebook_profile_id])

    self.check_account(params[:facebook_profile_id])

    #@current_page = 'guest book'
#    unless params[:button].blank?
#      @name=params[:name]
#      @email=params[:email]
#      @subject=params[:subject]
#      @message=params[:message]
#      @guest_image=params[:guest_image]

      #redirect_to "#{request_content_url}/manage_website/guestbook_new/#{params[:id]}?name=#{@name}&email=#{@email}&subject=#{@subject}&message=#{@message}&guest_image=#{@guest_image}}"

      #self.guestbook_new(params[:facebook_profile_id])

    #end
  end

  def display_comments
    self.check_account(params[:facebook_profile_id])
    facebook_profile_id = @family_website_owner.facebook_profile_id
    self.fw_display_comments(facebook_profile_id)

  end

  def intro
    self.check_account(params[:facebook_profile_id])
    self.fw_intro
  end

  def emailus
    self.check_account(params[:facebook_profile_id])

    self.fw_emailus()
  end

   def emailmsg
    self.check_account(params[:facebook_profile_id])

    self.fw_emailus()
  end

  def emailCS_msg

    self.check_account(params[:facebook_profile_id])
#     logger.info("proxyName ------------- starts")
#    logger.info(@path.proxyname)
    self.fw_contact_new

      end


  def mw_home
    self.check_account(params[:facebook_profile_id])
    logged_in_hmm_user = @family_website_owner
    self.fw_mw_home(logged_in_hmm_user)
  end

  def emailuser
    self.check_account(params[:facebook_profile_id])

  end

  def emailHmm
    self.check_account(params[:facebook_profile_id])
  end

  def emailCS
    self.check_account(params[:facebook_profile_id])

  end


end