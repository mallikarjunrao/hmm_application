class FamilywebsiteController < ApplicationController
  require 'cgi'
  layout 'familywebsite'
  before_filter  :check_account,:redirect_url #checks for valid family name, terms of use check and user block check

  before_filter :change_ssl, :only => [:check_account,:home,:biography,:forgot_password,:subchapters,:galleries,:gallery_contents,:emailus,:get_proxy_urls,:moments,:slideshow,:shareworker,:share,:add_nonhmm,:add_nonhmmWorker,:shared_moments,:events_moments,:new_home,:new_coverflownew_subchapters_list,:new_galleries_list,:new_gallery_contents_list,:fx_list_chapters,:fx_list_subchapters,:fx_list_galleries,:fx_list_gallery_contents,:flash_videos,:fx_flashvideo_images,:upload_import,:new_view]
    #ssl_required :home, :login
    #ssl_allowed  :check_account,:home,:biography,:forgot_password,:subchapters,:galleries,:gallery_contents,:emailus,:get_proxy_urls,:moments,:slideshow,:shareworker,:share,:add_nonhmm,:add_nonhmmWorker,:shared_moments,:events_moments,:new_home,:new_coverflownew_subchapters_list,:new_galleries_list,:new_gallery_contents_list,:fx_list_chapters,:fx_list_subchapters,:fx_list_galleries,:fx_list_gallery_contents,:flash_videos,:fx_flashvideo_images,:upload_import,:new_view

  def change_ssl
    current= request.url.split("://")
    if current[0]== "https"
      redirect_to "http://#{current[1]}"
    end
  end

  def redirect_url
    url= request.url.split("/")
    for i in 0..url.length
      if url[i]
        url[i]=url[i].upcase
        logger.info(url[i])
        if((url[i].match("<SCRIPT>")) || (url[i].match("</SCRIPT>")) || (url[i].match("</SCRIP>")) || (url[i].match("<SCRIP")) ||(url[i].match("JAVASCRIPT:ALERT"))||(url[i].match("%3C")))
          redirect_to "/nonexistent_page.html"
        end
      end
    end
  end

  def initialize()
    #@hide_float_menu = true
  end

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
            redirect_to :controller =>"familywebsite", :action => 'visitor_login', :id => params[:id], :redirect_url => request.url if (params[:action]!='login' && params[:action]!='visitor_login' && params[:action]!='forgot_password')
          end
        else
        end
      else
        redirect_to '/'
      end
    end
    #    @path = ContentPath.find(:first, :conditions => "status='active'")
    #    if(params[:id]=='bob')
    #      @content_server_url = "http://content.holdmymemories.com"
    #    else
    #      @content_server_url = @path.content_path
    #    end

    @path1 = ContentPath.find(:all)
    @path=""
    for path in @path1
      @path="#{@path}#{path.content_path},"
    end
    if(params[:id]=='bob')
      @content_server_url = "http://content.holdmymemories.com,http://content1.holdmymemories.com"
    else
      @content_server_url = "#{@path}"
      @img_url=@path1[0].content_path
    end
    return true #returns true if all the conditions are cleared
  end

  def home
    if(params[:version])
    else
      if(params[:id].upcase == 'BOB')
      else
        user = HmmUser.find(:first, :conditions => "family_name='#{params[:id]}'")
        if user.studio_id == 0
        else
          studio = HmmStudio.find(user.studio_id) rescue nil
        end
      end
    end
    sub_type=SubChapter.find(:first,:conditions=>"uid=#{@family_website_owner.id} and status='active' and (client='mliphoneapp' || client='mlandriodapp')")
    if !sub_type.nil? && !sub_type.blank? && params[:version].nil? && params[:id].upcase!='BOB'
      redirect_to :controller => "family_memory", :action => 'home', :id => params[:id]
    elsif(studio)
      if studio.family_website_version == 3
        redirect_to :controller => "familywebsite_studio", :action => 'home', :id => params[:id]
      elsif studio.family_website_version == 4
        redirect_to :controller => "family_memory", :action => 'home', :id => params[:id]
      end
    end
    @current_page = 'home'
    #    get recent images uploaded by the user start
    if(@family_website_owner.password_required == 'no')
      access="(e_access='public' or e_access='semiprivate')"
    else
      access="e_access='public'"
    end
    @recent_moments = UserContent.find(:all, :conditions => "uid=#{@family_website_owner.id} and e_filetype = 'image' and #{access} and status = 'active'",:select =>"id,v_filename,img_url", :order => "id desc", :limit =>8)
    #    get recent images uploaded by the user end
    # render :text =>"#{@family_website_owner.id}"
  end

  def biography
    @current_page = 'biography'
    @biographies = FamilyMember.find(:all, :conditions => "uid='#{@family_website_owner.id}'", :order => 'id')
  end



  def login
    @current_page = 'login'
    puts @family_website_owner.terms_checked
    if logged_in_hmm_user && @family_website_owner.id == logged_in_hmm_user.id && @family_website_owner.terms_checked =="true"
      redirect_to :action => 'home', :id => params[:id]
    end
    unless params[:username].blank? && params[:password].blank?
      self.logged_in_hmm_user = HmmUser.authenticate(params[:username],params[:password])
      if is_userlogged_in?
        if logged_in_hmm_user.e_user_status == 'unblocked'
          logger.info("[User]: #{[:username]} [Logged In] at #{Time.now} !")
          logger.info(logged_in_hmm_user.id)
          @user_session = UserSessions.new()
          @user_session['i_ip_add'] = request.remote_ip
          @user_session['uid'] = logged_in_hmm_user.id
          @user_session['v_user_name'] = logged_in_hmm_user.v_user_name
          @user_session['d_date_time'] = Time.now
          @user_session['e_logged_in'] = "yes"
          @user_session['e_logged_out'] = "no"
          @user_session.save

          logger.info(@family_website_owner.terms_checked)
          if @family_website_owner.id == logged_in_hmm_user.id
            session[:visitor] = params[:id]
            if (@family_website_owner.account_expdate!=nil && @family_website_owner.account_expdate < Date.current())
              redirect_to "/account_settings/upgrade_account_form/#{params[:id]}?acc_type=platinum_account&option=1"
            elsif(session[:employe]==nil && @family_website_owner.terms_checked =="false")
              redirect_to "/user_account/update_terms/"
            else
              unless params[:redirect_url].blank?
                redirect_to "#{params[:redirect_url]}"
              else
                redirect_to :controller => 'manage_website',:action => 'home', :id => params[:id]
              end
            end
          else
            session[:hmm_user]=nil
            flash[:error] = " Invalid Login.You must be the owner of this site."
            #log file entry
            logger.error("[Invalid Login]: by [User]:#{params[:username]} at #{Time.now}")
          end
        else
          session[:hmm_user]=nil
          flash[:error] = "User is been blocked.. Contact Admin!!"
        end
      else
        flash[:error] = "Either your username or password is incorrect. Please try again."
        #log file entry
        logger.error("[Invalid Login]: by [User]:#{params[:username]} at #{Time.now}")
      end
    end
  end








  def logout
    user = HmmUser.find(session[:hmm_user])
    if user.studio_id == 0

    else
      studio = HmmStudio.find(user.studio_id) rescue nil
    end
    if(session[:hmm_user])
      @user_session = UserSessions.new()
      @user_session['uid'] = logged_in_hmm_user.id if (logged_in_hmm_user.id)
      @user_session['v_user_name'] = logged_in_hmm_user.v_user_name if (logged_in_hmm_user.v_user_name)
      @user_session['d_date_time'] = Time.now
      @user_session['i_ip_add'] = request.remote_ip
      @user_session['e_logged_in'] = "no"
      @user_session['e_logged_out'] = "yes"
      @user_session.save
    end
    reset_session
    flash[:error] = "You have been successfully logged out."
    sub_type=SubChapter.find(:first,:conditions=>"uid=#{@family_website_owner.id} and status='active' and (client='mliphoneapp' || client='mlandriodapp')")
    if !sub_type.nil? && !sub_type.blank?
      redirect_to :controller => "family_memory", :action => 'home', :id => params[:id]
    else
      if(studio)
        if studio.family_website_version == 3
          redirect_to :controller => "familywebsite_studio", :action => 'home', :id => params[:id]
        elsif studio.family_website_version == 4
          redirect_to :controller => "family_memory", :action => 'home', :id => params[:id]
        else
          redirect_to :action => 'login', :id => params[:id]
        end
      else
        redirect_to :action => 'login', :id => params[:id]
      end
    end

  end


  def visitor_login
    # Visitor's login : for password protected family website
    unless params[:password].blank?
      logged_in_family=HmmUser.find(:first, :conditions => "familywebsite_password='#{params[:password]}' and family_name='#{params[:id]}'")
      if logged_in_family
        session[:visitor]=params[:id]
        unless params[:redirect_url].blank?
          redir = params[:redirect_url].gsub("www.","")

          redirect_to "#{redir}"
        else
          redirect_to :action => 'home', :id => params[:id]
        end
      else
        flash[:error] = "Invalid password!"
      end
    end
    @redirect_url = params[:redirect_url] unless params[:redirect_url].blank?
  end

  def forgot_password
    logger.info(params.inspect)
    unless params[:email].blank?
      user = HmmUser.find(:first, :conditions => "v_e_mail='#{params[:email]}'",:select => "hmm_users.*,v_password as pwd")
      if user
        name = user.v_fname
        email = user.v_e_mail
        username = user.v_user_name
        password = user.pwd
        Postoffice.deliver_deliverpass(name, email, username, password)
        flash[:error] = "Your account password has been sent to your email address."
        redirect_to  "/familywebsite/login/#{user.family_name}"
      else
        flash[:error] = "Your email address is incorrect. Please Try again"
      end
    end
  end

  def subchapters
    unless CGI.escapeHTML(params[:chapter_id]).blank?
      temp =CGI.escapeHTML(params[:chapter_id]).split('?')
      params[:id]=CGI.escapeHTML(params[:id])
      params[:chapter_id] = temp[0]
      params[:id]==CGI.escapeHTML(params[:id])
      @chapter = Tag.find(params[:chapter_id],:select => "tags.v_tagname as chapter_name,tags.id as chapter_id,tags.tag_type,tags.v_chapimage as chapter_image,tags.img_url as chapter_image_url")
      if(@chapter.tag_type!='mobile_uploads')
        @chapter = Tag.find :first, :joins => "INNER JOIN sub_chapters ON sub_chapters.tagid = tags.id INNER JOIN galleries ON galleries.subchapter_id = sub_chapters.id",:conditions => "tags.id=#{params[:chapter_id]}",
          :select =>"tags.v_tagname as chapter_name,tags.id as chapter_id,sub_chapters.id as subchapter_id,sub_chapters.sub_chapname as subchapter_name,galleries.id as gallery_id,tags.tag_type,tags.v_chapimage as chapter_image,tags.img_url as chapter_image_url"
        if(@chapter)
          if @chapter.tag_type=='photo' || @chapter.tag_type=='video' || @chapter.tag_type=='audio'
            redirect_to :action => 'gallery_contents', :id => params[:id],:gallery_id => @chapter.gallery_id
          end
        else
          @chapter = Tag.find(params[:chapter_id],:select => "tags.v_tagname as chapter_name,tags.id as chapter_id,tags.tag_type,tags.v_chapimage as chapter_image,tags.img_url as chapter_image_url")

        end
      end


      @proxyurls = get_proxy_urls()
      subdomain = request.subdomains[0]
      subdomain = 'www' if subdomain.blank?
      image_name  = @chapter.chapter_image
      image_name.slice!(-3..-1)

      @share_image = "#{@chapter.chapter_image_url}/user_content/photos/flex_icon/#{image_name}jpg"
      @share_video = "http://#{subdomain}.holdmymemories.com/Chapter.swf?serverUrl=http://#{subdomain}.holdmymemories.com/my_familywebsite/coverFlowImages/#{@chapter.chapter_id}&navigateToUrl=http://#{subdomain}.holdmymemories.com/my_familywebsite/gallery/&buttonsVisible=false&proxyurls=#{@proxyurls}&familyname=#{params[:id]}"
      @share_type = "video"

      #@blog = ChapterJournal.find(:first, :conditions => "tag_id=#{params[:chapter_id]}", :select => "v_tag_title as blog_title,v_tag_journal as blog_content,d_created_at as blog_date")
      @blog = Blog.find(:first, :conditions => "blog_type_id=#{params[:chapter_id]} and blog_type='chapter'", :select => "title as blog_title,description as blog_content,DATE_FORMAT(added_date,'%W, %b %d, %Y') as blog_date")
      @comments = ChapterComment.find(:all, :conditions => "e_approval = 'approve' and tag_id = #{params[:chapter_id]}", :order => "id asc", :select =>"v_comment as comment,v_name as commenter,d_created_on as commented_date")
      #      @commentcnt=Blog.count(:all,:joins=>"as a , blog_comments as b",:conditions=>"a.blog_type_id=#{params[:chapter_id]} and a.blog_type='chapter' and a.id=b.blog_id and b.status ='approved'")
      #      if(@commentcnt>0)
      #      @comments=Blog.find(:first,:joins=>"as a , blog_comments as b", :select=>"b.comment as comment,b.name as commenter,b.created_at as commented_date" ,:conditions=>"a.blog_type_id=#{params[:chapter_id]} and a.blog_type='chapter' and a.id=b.blog_id and b.status ='approved'")
      #      end
    else
      redirect_to :action => 'home', :id => params[:id]
    end

  end

  def galleries
    unless params[:subchapter_id].blank?
      temp = params[:subchapter_id].split('?')
      params[:subchapter_id] = temp[0]
      @detail = Tag.find :first, :joins => "INNER JOIN sub_chapters ON sub_chapters.tagid = tags.id",:conditions => "sub_chapters.id=#{params[:subchapter_id]}",
        :select =>"tags.v_tagname as chapter_name,tags.id as chapter_id,sub_chapters.id as subchapter_id,sub_chapters.sub_chapname as subchapter_name, sub_chapters.store_id as store_id, sub_chapters.img_url as img_url "
      if(@detail.store_id==nil || @detail.store_id=="")
      else
        @logo="no"
        store=HmmStudio.find(@detail.store_id)
        @store=store.studio_name
        studio_logo = store.studio_logo
        slogo=store.studio_logo.split('.')
        if(slogo[1]=='gif')
          @logo="no"
        else
          @logo="yes"
        end
        @share_image_studio = "#{@detail.img_url}/user_content/studio_logos/#{studio_logo}"
        if(@logo=="yes")
          @share_image = @share_image_studio
        end
      end
      if(session[:hmm_user]==@family_website_owner.id)
        @buttonVisibility = "true"
      else
        @buttonVisibility = "false"
      end
      #@blog = SubChapJournal.find(:first, :conditions => "sub_chap_id = #{params[:subchapter_id]}", :select => "journal_title as blog_title,subchap_journal as blog_content,created_on as blog_date")
      @blog = Blog.find(:first, :conditions => "blog_type_id=#{params[:subchapter_id]} and blog_type='subchapter'", :select => "title as blog_title,description as blog_content,DATE_FORMAT(added_date,'%W, %b %d, %Y') as blog_date")
      @comments = SubchapComment.find(:all, :conditions => "e_approval = 'approve' and subchap_id = #{params[:subchapter_id]}", :order => "id asc", :select =>"v_comments as comment,v_name as commenter,d_created_on as commented_date")
      #@comments=Blog.find(:first,:joins=>"as a , blog_comments as b", :select=>"b.comment as comment,b.name as commenter,b.created_at as commented_date" ,:conditions=>"a.blog_type_id=#{params[:subchapter_id]} and a.blog_type='subchapter' and a.id=b.blog_id and b.status ='approved'")

    else
      redirect_to :action => 'home', :id => params[:id]
    end
  end

  def gallery_contents
    params[:id]=CGI.escapeHTML(params[:id])
    unless CGI.escapeHTML(params[:gallery_id]).blank?
      if(session[:hmm_user]==@family_website_owner.id)
        @buttonVisibility = "true"
      else
        @buttonVisibility = "false"
      end
      temp = CGI.escapeHTML(params[:gallery_id]).split('?')
      params[:gallery_id] = temp[0]
      @gallery_id =params[:gallery_id]
      @gallery  = Galleries.find(:first, :conditions => "id=#{params[:gallery_id]}", :order => "order_num ASC")
      @detail=SubChapter.find(@gallery.subchapter_id)
      if(@detail.store_id==nil || @detail.store_id=="")
      else
        @logo="no"
        store=HmmStudio.find(@detail.store_id)
        @store=store.studio_name
        studio_logo = store.studio_logo
        slogo=store.studio_logo.split('.')
        if(slogo[1]=='gif')
          @logo="no"
        else
          @logo="yes"
        end

        @share_image_studio = "#{@detail.img_url}/user_content/studio_logos/#{studio_logo}"
        if(@logo=="yes")
          @share_image = @share_image_studio
        end
      end
      @galleryUrl = ""
      if(@gallery.e_gallery_type == "video")
        logger.info("Gallery Type Video")
        @swfName = "CoverFlowVideo"
        @swfName1 = "CoverFlowVideo"
        @galleryUrl = "/evelethsfamily/videoCoverflow/"+params[:gallery_id]
      elsif(@gallery.e_gallery_type == "image")
        logger.info("Gallery Type Image")
        @swfName = "PhotoGallery"
        @swfName1 = "Chapter"
        @galleryUrl = "/evelethsfamily/showGallery/"+params[:gallery_id]
      elsif(@gallery.e_gallery_type == "audio")
        logger.info("Gallery Type Audio")
        @swfName = "CoverFlowAudio"
        @swfName1 = "CoverFlowAudio"
        @galleryUrl = "/evelethsfamily/showAudioGallery/"+params[:gallery_id]
      end

      @detail = Tag.find :first, :joins => "INNER JOIN sub_chapters ON sub_chapters.tagid = tags.id INNER JOIN galleries ON galleries.subchapter_id = sub_chapters.id",:conditions => "galleries.id=#{params[:gallery_id]}",
        :select =>"tags.v_tagname as chapter_name,tags.id as chapter_id,sub_chapters.id as subchapter_id,sub_chapters.sub_chapname as subchapter_name,galleries.v_gallery_name as gallery_name,tags.tag_type as chapter_type,galleries.e_gallery_type as gallery_type,galleries.id as gallery_id,tags.tag_type as chapter_type,tags.v_chapimage as chapter_image"
      @proxyurls = get_proxy_urls()

      if(@detail.chapter_type == 'chapter')
        img = @gallery.v_gallery_image
      else
        img = @detail.chapter_image
      end
      subdomain = request.subdomains[0]
      subdomain = 'www' if subdomain.blank?
      image_name  = img
      image_name.slice!(-3..-1)
      @share_image = "#{@gallery.img_url}/user_content/photos/flex_icon/#{image_name}jpg"
      @share_video = "http://#{subdomain}.holdmymemories.com/#{@swfName1}.swf?serverUrl=http://#{subdomain}.holdmymemories.com#{@galleryUrl}&buttonsVisible=false&proxyurls=#{@proxyurls}"
      @share_type = "video"
      # @blog = GalleryJournal.find(:first, :conditions => "galerry_id = #{params[:gallery_id]}", :select => "v_title as blog_title,v_journal as blog_content,d_created_on as blog_date")
      @blog = Blog.find(:first, :conditions => "blog_type_id=#{params[:gallery_id]} and blog_type='gallery'", :select => "title as blog_title,description as blog_content,DATE_FORMAT(added_date,'%W, %b %d, %Y') as blog_date")
      @comments = GalleryComment.find(:all, :conditions => "e_approval = 'approve' and gallery_id = #{params[:gallery_id]}", :order => "id asc", :select =>"v_comment as comment,v_name as commenter,d_created_on as commented_date")
      #@comments=Blog.find(:first,:joins=>"as a , blog_comments as b", :select=>"b.comment as comment,b.name as commenter,b.created_at as commented_date" ,:conditions=>"a.blog_type_id=#{params[:gallery_id]} and a.blog_type='gallery' and a.id=b.blog_id and b.status ='approved'")

    else
      redirect_to :action => 'home', :id => params[:id]
    end
  end

  #  def emailus
  #    @results = HmmUser.find(:all,:select => "hmm_users.v_user_name,hmm_users.v_fname,hmm_users.v_lname,hmm_studios.studio_name,studio_id", :joins =>" LEFT JOIN hmm_studios
  #ON hmm_users.studio_id=hmm_studios.id", :conditions => "hmm_users.id=#{@family_website_owner.id}")
  #    @current_page = 'emailus'
  #    unless params[:email].blank? && params[:email].blank? && params[:email].blank?
  #      if simple_captcha_valid?
  #        @contactus = ContactU.new()
  #        @contactus.first_name =params[:name]
  #        @contactus.subject = "HoldMyMemories.com - #{params[:name]} has sent you an email from HoldMyMemories.com... "
  #        @contactus.message =params[:message]
  #        @contactus.email =params[:email]
  #        if @contactus.save
  #          Postoffice.deliver_contactUsreportmysite(@contactus.first_name,@contactus.subject,@contactus.message,@contactus.country,@contactus.email,@family_website_owner.v_e_mail)
  #          flash[:message] = "Thank You, Your Email has Been Sent to #{@family_website_owner.v_fname} #{@family_website_owner.v_lname}."
  #        end
  #        @error1="test"
  #      else
  #        flash[:msg] = "Please enter the correct code!"
  #        @error1="Please enter the correct code!"
  #      end
  #    end
  #
  #    if(params[:contact_u])
  #      @contact_u = ContactU.new
  #      if simple_captcha_valid?
  #        @results = HmmUser.find(:all,:select => "hmm_users.v_user_name,hmm_studios.studio_name,studio_id,hmm_users.v_fname,hmm_users.v_lname", :joins =>" LEFT JOIN hmm_studios
  #ON hmm_users.studio_id=hmm_studios.id", :conditions => "hmm_users.id=#{@family_website_owner.id}")
  #        for result in  @results
  #          @managers1 = MarketManager.count(:first,:select => "a.e_mail", :joins=>" as a,manager_branches as b",
  #            :conditions => "a.id=b.manager_id and b.branch_id=#{result.studio_id}")
  #        end
  #        if(@managers1 > 0)
  #        for result in  @results
  #          @managers = MarketManager.find(:first,:select => "a.e_mail", :joins=>" as a,manager_branches as b",
  #            :conditions => "a.id=b.manager_id and b.branch_id=#{result.studio_id}")
  #          @manager_email= @managers.e_mail
  #        end
  #        else
  #            @manager_email=''
  #        end
  #
  #
  #        @studios = HmmStudio.find(:first,:select => "studio_name,contact_email,studio_groupid",:conditions => "id=#{@results[0].studio_id}")
  #        @contact_u = ContactU.new(params[:contact_u])
  #        @hmm_user_belongs_to = HmmUser.count(:all,:conditions => "v_e_mail='#{@contact_u.email}'")
  #        if(@hmm_user_belongs_to > 0)
  #          @hmm_user_belongs_to_det = HmmUser.find(:all,:conditions => "v_e_mail='#{@contact_u.email}'")
  #          emp_id= @hmm_user_belongs_to_det[0]['emp_id']
  #          customer_name="#{@hmm_user_belongs_to_det[0]['v_fname']} #{@hmm_user_belongs_to_det[0]['v_lname']}"
  #          acc_type=@hmm_user_belongs_to_det[0]['account_type']
  #          if(acc_type=="free_user")
  #            customer_account="Free User Account"
  #          else
  #            if(acc_type=="platinum_user")
  #              customer_account="Premium User Account"
  #            else
  #              customer_account="Family Website User Account"
  #            end
  #          end
  #
  #
  #          if(emp_id=='' || emp_id==nil )
  #            @contact_u.subject = "HoldMyMemories Contact Us Information..."
  #            Postoffice.deliver_contactUsreport_email1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,"Direct User","No employee involved",customer_name,customer_account,@studios.contact_email,@manager_email)
  #
  #          else
  #            @employee_details = EmployeAccount.find(emp_id)
  #            branch = @employee_details.branch
  #            e_mail = @employee_details.e_mail
  #            emp_name = @employee_details.employe_name
  #            @contact_u.subject = "HoldMyMemories Contact Us Information..."
  #            Postoffice.deliver_contactUsreport_email1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,@studios.studio_name,emp_name,customer_name,customer_account,@studios.contact_email,@manager_email)
  #          end
  #        else
  #          @contact_u.subject = "HoldMyMemories Contact Us Information..."
  #          Postoffice.deliver_contactUsreport_email(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,@contact_u.zip,@contact_u.phone_no,@contact_u.mobile_no,@studios.contact_email,@manager_email)
  #
  #        end
  #        @contact_u.subject = "HoldMyMemories Contact Us Information..."
  #        if @contact_u.save
  #          #Postoffice.deliver_contactUsreport(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email)
  #          flash[:notice_contact] = "Thank You, Your Email has Been Sent to #{@studios.studio_name}"
  #        else
  #          redirect_to :action => 'emailus'
  #        end
  #        @error2='test'
  #      else
  #        flash[:error] = 'Please enter the correct image code!'
  #        @error2='Please enter the correct image code!'
  #      end
  #    end
  #  end



  #  def emailus
  #    @result = HmmUser.find(:all,:select => "hmm_users.v_user_name,hmm_users.v_fname,hmm_users.v_lname,hmm_studios.studio_name,studio_id", :joins =>" LEFT JOIN hmm_studios
  #     ON hmm_users.studio_id=hmm_studios.id", :conditions => "hmm_users.id=#{@family_website_owner.id}")
  #    @current_page = 'emailus'
  #    unless params[:email].blank? && params[:email].blank? && params[:email].blank?
  #      if simple_captcha_valid?
  #        @contactus = ContactU.new()
  #        #@contactus = ContactU.new
  #        @contactus.first_name =params[:name]
  #        @contactus.subject = "HoldMyMemories.com - #{params[:name]} has sent you an email from HoldMyMemories.com... "
  #        @contactus.message =params[:message]
  #        @contactus.email =params[:email]
  #
  #        users_studio_id = @result[0].studio_id
  #
  #
  #        if @contactus.save
  #          Postoffice.deliver_contactUsreportmysite(@contactus.first_name,@contactus.subject,@contactus.message,@contactus.country,@contactus.email,@family_website_owner.v_e_mail,users_studio_id)
  #          flash[:message] = "Thank You, Your Email has Been Sent to #{@family_website_owner.v_fname} #{@family_website_owner.v_lname}."
  #        end
  #        @error1="test"
  #      else
  #        flash[:msg] = "Please enter the correct code!"
  #        @error1="Please enter the correct code!"
  #      end
  #    end
  #
  #    if(params[:contact_u])
  #      @contact_u = ContactU.new
  #      if simple_captcha_valid?
  #        @result = HmmUser.find(:all,:select => "hmm_users.v_user_name,hmm_studios.studio_name,studio_id,hmm_users.v_fname,hmm_users.v_lname", :joins =>" LEFT JOIN hmm_studios
  #        ON hmm_users.studio_id=hmm_studios.id", :conditions => "hmm_users.id=#{@family_website_owner.id}")
  #
  #        @managers1 = MarketManager.count(:first,:select => "a.e_mail", :joins=>" as a,manager_branches as b",
  #          :conditions => "a.id=b.manager_id and b.branch_id=#{@result[0].studio_id}")
  #        if(@managers1 > 0)
  #
  #          @managers = MarketManager.find(:first,:select => "a.e_mail", :joins=>" as a,manager_branches as b",
  #            :conditions => "a.id=b.manager_id and b.branch_id=#{@result[0].studio_id}")
  #          @manager_email= @managers.e_mail
  #        else
  #          @manager_email=''
  #        end
  #
  #
  #        @studios = HmmStudio.find(:first,:select => "studio_name,contact_email,studio_groupid",:conditions => "id=#{@result[0].studio_id}")
  #        @contact_u = ContactU.new(params[:contact_u])
  #        @hmm_user_belongs_to = HmmUser.count(:all,:conditions => "v_e_mail='#{@contact_u.email}'")
  #        studio_group_id = @studios.studio_groupid
  #
  #        if(@hmm_user_belongs_to > 0)
  #          @hmm_user_belongs_to_det = HmmUser.find(:all,:conditions => "v_e_mail='#{@contact_u.email}'")
  #          emp_id= @hmm_user_belongs_to_det[0]['emp_id']
  #          customer_name="#{@hmm_user_belongs_to_det[0]['v_fname']} #{@hmm_user_belongs_to_det[0]['v_lname']}"
  #          acc_type=@hmm_user_belongs_to_det[0]['account_type']
  #          if(acc_type=="free_user")
  #            customer_account="Free User Account"
  #          else
  #            if(acc_type=="platinum_user")
  #              customer_account="Premium User Account"
  #            else
  #              customer_account="Family Website User Account"
  #            end
  #          end
  #
  #
  #          #studio_group_id = @studios.studio_groupid
  #          if(emp_id=='' || emp_id==nil )
  #            @contact_u.subject = "HoldMyMemories Contact Us Information..."
  #            Postoffice.deliver_contactUsreport_email1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,"Direct User","No employee involved",customer_name,customer_account,@studios.contact_email,@manager_email,studio_group_id)
  #
  #          else
  #            @employee_details = EmployeAccount.find(emp_id)
  #            branch = @employee_details.branch
  #            e_mail = @employee_details.e_mail
  #            emp_name = @employee_details.employe_name
  #            @contact_u.subject = "HoldMyMemories Contact Us Information..."
  #
  #
  #            #           click_studio_id = 3
  #            #emp_store_id = @employee_details.store_id
  #            #   studio_group_id = @studios.studio_groupid
  #            #
  #            #,emp_store_id
  #            #            if(@studios.studio_groupid == click_studio_id && @studios.id == emp_store_id)
  #            #              @manager_email = ,+"seth.johnson@holdmymemories.com,angie@holdmymemories.com"
  #            #            end
  #            #  Postoffice.deliver_contactUsreport_email1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,@studios.studio_name,emp_name,customer_name,customer_account,@studios.contact_email,@manager_email,emp_store_id,studio_group_id)
  #
  #            Postoffice.deliver_contactUsreport_email1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,@studios.studio_name,emp_name,customer_name,customer_account,@studios.contact_email,@manager_email,studio_group_id)
  #          end
  #        else
  #          @contact_u.subject = "HoldMyMemories Contact Us Information..."
  #          Postoffice.deliver_contactUsreport_email(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,@contact_u.zip,@contact_u.phone_no,@contact_u.mobile_no,@studios.contact_email,@manager_email,studio_group_id)
  #
  #        end
  #        @contact_u.subject = "HoldMyMemories Contact Us Information..."
  #        if @contact_u.save
  #          #Postoffice.deliver_contactUsreport(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email)
  #          flash[:notice_contact] = "Thank You, Your Email has Been Sent to #{@studios.studio_name}"
  #        else
  #          redirect_to :action => 'emailus'
  #        end
  #        @error2='test'
  #      else
  #        flash[:error] = 'Please enter the correct image code!'
  #        @error2='Please enter the correct image code!'
  #      end
  #    end
  #  end


  def emailus
    @results = HmmUser.find(:all,:select => "hmm_users.v_user_name,hmm_users.v_fname,hmm_users.v_lname,hmm_studios.studio_name,studio_id", :joins =>" LEFT JOIN hmm_studios
ON hmm_users.studio_id=hmm_studios.id", :conditions => "hmm_users.id=#{@family_website_owner.id}")
    @current_page = 'emailus'
    unless params[:email].blank? && params[:email].blank? && params[:email].blank?
      if simple_captcha_valid?
        @contactus = ContactU.new()
        @contactus.first_name =params[:name]
        @contactus.subject = "HoldMyMemories.com - #{params[:name]} has sent you an email from HoldMyMemories.com... "
        @contactus.message =params[:message]
        @contactus.email =params[:email]
        users_studio_id = @results[0].studio_id
        if @contactus.save
          Postoffice.deliver_contactUsreportmysite(@contactus.first_name,@contactus.subject,@contactus.message,@contactus.country,@contactus.email,@family_website_owner.v_e_mail,users_studio_id)
          flash[:message] = "Thank You, Your Email has Been Sent to #{@family_website_owner.v_fname} #{@family_website_owner.v_lname}."
        end
        @error1="test"
      else
        flash[:msg] = "Please enter the correct code!"
        @error1="Please enter the correct code!"
      end
    end

    if(params[:contact_u])
      @contact_u = ContactU.new
      if simple_captcha_valid?
        @result = HmmUser.find(:all,:select => "hmm_users.v_user_name,hmm_studios.studio_name,studio_id,hmm_users.v_fname,hmm_users.v_lname", :joins =>" LEFT JOIN hmm_studios
        ON hmm_users.studio_id=hmm_studios.id", :conditions => "hmm_users.id=#{@family_website_owner.id}")

        @managers1 = MarketManager.count(:first,:select => "a.e_mail", :joins=>" as a,manager_branches as b",
          :conditions => "a.id=b.manager_id and b.branch_id=#{@result[0].studio_id}")
        if(@managers1 > 0)

          @managers = MarketManager.find(:first,:select => "a.e_mail", :joins=>" as a,manager_branches as b",
            :conditions => "a.id=b.manager_id and b.branch_id=#{@result[0].studio_id}")
          @manager_email= @managers.e_mail
        else
          @manager_email=''
        end


        @studios = HmmStudio.find(:first,:select => "studio_name,contact_email,studio_groupid",:conditions => "id=#{@result[0].studio_id}")
        @contact_u = ContactU.new(params[:contact_u])
        @hmm_user_belongs_to = HmmUser.count(:all,:conditions => "v_e_mail='#{@contact_u.email}'")
        studio_group_id = @studios.studio_groupid

        if(@hmm_user_belongs_to > 0)
          @hmm_user_belongs_to_det = HmmUser.find(:all,:conditions => "v_e_mail='#{@contact_u.email}'")
          emp_id= @hmm_user_belongs_to_det[0]['emp_id']
          customer_name="#{@hmm_user_belongs_to_det[0]['v_fname']} #{@hmm_user_belongs_to_det[0]['v_lname']}"
          acc_type=@hmm_user_belongs_to_det[0]['account_type']
          if(acc_type=="free_user")
            customer_account="Free User Account"
          else
            if(acc_type=="platinum_user")
              customer_account="Premium User Account"
            else
              customer_account="Family Website User Account"
            end
          end


          #studio_group_id = @studios.studio_groupid
          if(emp_id=='' || emp_id==nil )
            @contact_u.subject = "HoldMyMemories Contact Us Information..."
            Postoffice.deliver_contactUsreport_email1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,"Direct User","No employee involved",customer_name,customer_account,@studios.contact_email,@manager_email,studio_group_id)

          else
            @employee_details = EmployeAccount.find(emp_id)
            branch = @employee_details.branch
            e_mail = @employee_details.e_mail
            emp_name = @employee_details.employe_name
            @contact_u.subject = "HoldMyMemories Contact Us Information..."


            #           click_studio_id = 3
            #emp_store_id = @employee_details.store_id
            #   studio_group_id = @studios.studio_groupid
            #
            #,emp_store_id
            #            if(@studios.studio_groupid == click_studio_id && @studios.id == emp_store_id)
            #              @manager_email = ,+"seth.johnson@holdmymemories.com,angie@holdmymemories.com"
            #            end
            #  Postoffice.deliver_contactUsreport_email1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,@studios.studio_name,emp_name,customer_name,customer_account,@studios.contact_email,@manager_email,emp_store_id,studio_group_id)

            Postoffice.deliver_contactUsreport_email1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,@studios.studio_name,emp_name,customer_name,customer_account,@studios.contact_email,@manager_email,studio_group_id)
          end
        else
          @contact_u.subject = "HoldMyMemories Contact Us Information..."
          Postoffice.deliver_contactUsreport_email(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,@contact_u.zip,@contact_u.phone_no,@contact_u.mobile_no,@studios.contact_email,@manager_email,studio_group_id)

        end
        @contact_u.subject = "HoldMyMemories Contact Us Information..."
        if @contact_u.save
          #Postoffice.deliver_contactUsreport(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email)
          flash[:notice_contact] = "Thank You, Your Email has Been Sent to #{@studios.studio_name}"
        else
          redirect_to :action => 'emailus'
        end
        @error2='test'
      else
        flash[:error] = 'Please enter the correct image code!'
        @error2='Please enter the correct image code!'
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

  def moments
    unless params[:moment_id].blank?
      temp = params[:moment_id].split('?')
      params[:moment_id] = temp[0]
      @detail = UserContent.find :first, :joins => "INNER JOIN galleries ON galleries.id = user_contents.gallery_id INNER JOIN sub_chapters ON sub_chapters.id = galleries.subchapter_id INNER JOIN tags ON sub_chapters.tagid = tags.id",:conditions => "user_contents.id=#{params[:moment_id]}",
        :select =>"tags.v_tagname as chapter_name,tags.uid as userid,tags.id as chapter_id,sub_chapters.id as subchapter_id,sub_chapters.sub_chapname as subchapter_name, sub_chapters.store_id as subchapstore, galleries.v_gallery_name as gallery_name,user_contents.v_tagphoto as moment_name,tags.tag_type as chapter_type,user_contents.*,galleries.id as gallery_id"
      if @detail
        @proxyurls = get_proxy_urls()
        hmm_userdet=HmmUser.find(@detail.uid)
        @logo="no"
        if(hmm_userdet.emp_id=="" or hmm_userdet.emp_id==nil)
        else
          studioemp = EmployeAccount.find(hmm_userdet.emp_id)
          store=HmmStudio.find(studioemp.store_id)
          @store=store.studio_name
          studio_logo = store.studio_logo
          slogo=store.studio_logo.split('.')
          if(slogo[1]=='gif')
            @logo="no"
          else
            @logo="yes"
          end

          @share_image_studio = "#{@detail.img_url}/user_content/studio_logos/#{studio_logo}"
        end
        if(@detail.e_filetype =="image")
          if(@detail.subchapstore=="" || @detail.subchapstore==nil || @logo=="no" )
            @share_image = "#{@detail.img_url}/user_content/photos/coverflow/#{@detail.v_filename}"
          else
            @share_image = @share_image_studio
            #@share_image = "#{@detail.img_url}/user_content/photos/journal_thumb/#{@detail.v_filename}"
          end
          @share_type="image"
        elsif(@detail.e_filetype =="video")
          if(@detail.subchapstore=="" || @detail.subchapstore==nil  || @logo=="no")
          else
            @share_image = @share_image_studio
          end
          @share_video = "http://blog.holdmymemories.com/BlogVideoPlayer.swf?videopath=#{@detail.img_url}/user_content/videos/#{@detail.v_filename}.flv"
          @share_type = "video"
        elsif(@detail.e_filetype =="swf")
          if(@detail.subchapstore=="" || @detail.subchapstore==nil)
          else
            @share_image = @share_image_studio
          end
          @share_video = "http://holdmymemories.com/slideShow.swf?xmlfile=http://holdmymemories.com/slideshow/get_slideshow_moment_list/#{@detail.id}.xml"
          @share_type = "video"
        end
        #@blog = JournalsPhoto.find(:first, :conditions => "user_content_id = #{params[:moment_id]}", :select => "v_title as blog_title,v_image_comment as blog_content,date_added as blog_date")
        @blog = Blog.find(:first, :conditions => "blog_type_id=#{params[:moment_id]} and blog_type='#{@share_type}'", :select => "title as blog_title,description as blog_content,DATE_FORMAT(added_date,'%W, %b %d, %Y') as blog_date")
        @comments = PhotoComment.find(:all, :conditions => "e_approved = 'approve' and user_content_id = #{params[:moment_id]}", :order => "id asc", :select =>"v_comment as comment,v_name as commenter,d_add_date as commented_date")
        #@comments=Blog.find(:first,:joins=>"as a , blog_comments as b", :select=>"b.comment as comment,b.name as commenter,b.created_at as commented_date" ,:conditions=>"a.blog_type_id=#{params[:moment_id]} and a.blog_type='#{@share_type}' and a.id=b.blog_id and b.status ='approved'")


      else
        redirect_to :action => 'home', :id => params[:id]
      end
    else
      redirect_to :action => 'home', :id => params[:id]
    end
  end

  def slideshow
    unless params[:gallery_id].blank?
      if(session[:hmm_user]==@family_website_owner.id)
        @buttonVisibility = "true"
      else
        @buttonVisibility = "false"
      end
      @detail = Tag.find :first, :joins => "INNER JOIN sub_chapters ON sub_chapters.tagid = tags.id INNER JOIN galleries ON galleries.subchapter_id = sub_chapters.id",:conditions => "galleries.id=#{params[:gallery_id]}",
        :select =>"tags.v_tagname as chapter_name,tags.id as chapter_id,sub_chapters.id as subchapter_id,sub_chapters.sub_chapname as subchapter_name,galleries.v_gallery_name as gallery_name,tags.tag_type as chapter_type,galleries.id as gallery_id"
      #@blog = GalleryJournal.find(:first, :conditions => "galerry_id = #{params[:gallery_id]}", :select => "v_title as blog_title,v_journal as blog_content,d_created_on as blog_date")
      @blog = Blog.find(:first, :conditions => "blog_type_id=#{params[:gallery_id]} and blog_type='gallery'", :select => "title as blog_title,description as blog_content,DATE_FORMAT(added_date,'%W, %b %d, %Y') as blog_date")
      @comments = GalleryComment.find(:all, :conditions => "e_approval = 'approve' and gallery_id = #{params[:gallery_id]}", :order => "id asc", :select =>"v_comment as comment,v_name as commenter,d_created_on as commented_date")

    else
      redirect_to :action => 'home', :id => params[:id]
    end
  end

  #Share a Page
  def share

    if params[:id]
      fid=params[:id]
    else
      fid=params[:familyname]
    end
    @block_check = HmmUser.count(:all, :conditions => "(family_name='#{fid}' || alt_family_name='#{fid}') and e_user_status='blocked'")
    if(@block_check > 0)
      redirect_to :controller => 'familywebsite', :action => 'blocked', :id => params[:id]
    else

      @userid = HmmUser.find(:all, :conditions => "family_name='#{fid}' || alt_family_name='#{fid}'")
      @uid = @userid[0]['id']
      @results1 = NonhmmUser.find(:all, :conditions => "uid='#{@userid[0]['id']}'")
      @link = params[:link]
      render :layout => false
    end
  end


  def shareWorker
    if params[:id]
      fid=params[:id]
    else
      fid=params[:familyname]
    end
    @block_check = HmmUser.count(:all, :conditions => "(family_name='#{fid}' || alt_family_name='#{fid}') and e_user_status='blocked'")
    if(@block_check > 0)
      redirect_to :controller => 'familywebsite', :action => 'blocked', :id => params[:id]
    else

      @userid = HmmUser.find(:all, :conditions => "family_name='#{fid}' || alt_family_name='#{fid}'")
      @uid = @userid[0]['id']
      @results1 = NonhmmUser.find(:all, :conditions => "uid='#{@userid[0]['id']}'")
      @link = params[:link]
    end
    if verify_recaptcha
      @user = HmmUser.count_by_sql("SELECT count(*) FROM `hmm_users` WHERE family_name='#{params[:id]}' and familywebsite_password='#{params[:pass]}'")
      @pass_req = HmmUser.count_by_sql("SELECT count(*) FROM `hmm_users` WHERE family_name='#{params[:id]}' and password_required='yes'")
      @userid = HmmUser.find(:all, :conditions => "family_name='#{params[:id]}' || alt_family_name='#{params[:id]}'")
      @uid = @userid[0]['id']
      family_img = @userid[0]['family_pic']
      content_url = @userid[0].img_url

      @count = 0

      if params[:reciepent_email]
        if session[:hmm_user]
          email = params[:reciepent_email]
          @frindsEmail=email.split(',')
          size = @frindsEmail.size
          for k in @frindsEmail
            #@friendscheck = NonhmmUser.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and v_email='#{k}'")
            @friendscheck = NonhmmUser.count_by_sql("SELECT count(*) FROM nonhmm_users where  v_email='#{k}' and uid=#{@userid[0]['id']} group by v_email")
            i=0
            until i == size
              i=i+1
              if @friendscheck != 1
                @count = @count +1
              else

              end
            end
          end
          if @count == 0
            link = params[:link]
          else
            link="/familywebsite/add_nonhmm/"+params[:id]+"/?pa="+params[:reciepent_email]
          end
        else
          link = params[:link]
        end
      else
        link = params[:link]

      end

      if (@pass_req > 0 and params[:pass] !='')
        if (params[:pass] and @user > 0)
          puts '1'
          #modified fdwefwefwefwefwe

          sender_name = params[:sender_name]
          sender_email = params[:sender_email]
          reciepent_message=params[:reciepent_message]
          messageboard_link="http://www.holdmymemories.com/familywebsite/messageboard/"+params[:id]
          pass = params[:pass]

          if (params[:share_type] == 'journal' || params[:share_type] == 'biography')
            @sha_type = params[:share_type]
          else
            @sha_type = 'moment'
          end
          if params[:reciepent_email]
            @frdEmail = params[:reciepent_email]
            frindsEmail=@frdEmail.split(',')

            for i in frindsEmail


              Postoffice.deliver_shareFamilypages(i,sender_name,sender_email,params[:link],reciepent_message,@sha_type,pass,messageboard_link,family_img,content_url)



              @familywebsite_share = FamilywebsiteShare.new()
              @familywebsite_share['senders_name']=params[:sender_name]
              @familywebsite_share['senders_email']=params[:sender_email]
              @familywebsite_share['share_message']=params[:reciepent_message]
              @familywebsite_share['reciepent_emails']=i
              @familywebsite_share['website_owner_id']=@uid
              @familywebsite_share['share_date']=Time.now
              @familywebsite_share['family_website']=params[:id]
              @familywebsite_share.save
            end
          end

          #Send Email From Address Book
          if params[:address_email]

            adrsEmail=params[:address_email]
            for j in adrsEmail

              Postoffice.deliver_shareFamilypages(j,sender_name,sender_email,params[:link],reciepent_message,@sha_type,pass,messageboard_link,family_img,content_url)



              @familywebsite_share = FamilywebsiteShare.new()
              @familywebsite_share['senders_name']=params[:sender_name]
              @familywebsite_share['senders_email']=params[:sender_email]
              @familywebsite_share['share_message']=params[:reciepent_message]
              @familywebsite_share['reciepent_emails']=j
              @familywebsite_share['website_owner_id']=@uid
              @familywebsite_share['share_date']=Time.now
              @familywebsite_share['family_website']=params[:id]
              @familywebsite_share.save
            end
          end

          # puts adrsEmail

          #Postoffice.deliver_shareFamilypages(adrsEmail,sender_name,sender_email,link,reciepent_message,@sha_type,pass,messageboard_link,family_img,content_url)

          #end

          session[:journal] = "journal"
          $share_familypage
          flash[:share_familypage] = "<font color='#e75e16' size=3>This page was successfully sent.</font>"
          redirect_to link
        else

          $share_unsuccefull = 'Invalid Password'
          flash[:share_unsuccefull] = 'Invalid Password, please try again!'
          redirect_to link

        end
      else

        @count = 0

        if params[:reciepent_email]
          if session[:hmm_user]
            email = params[:reciepent_email]
            @frindsEmail=email.split(',')
            size = @frindsEmail.size
            for k in @frindsEmail
              #@friendscheck = NonhmmUser.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and v_email='#{k}'")
              @friendscheck = NonhmmUser.count_by_sql("SELECT count(*) FROM nonhmm_users where  v_email='#{k}' and uid=#{@userid[0]['id']} group by v_email")
              i=0
              until i == size
                i=i+1
                if @friendscheck != 1
                  @count = @count +1
                else

                end
              end
            end
            if @count == 0
              link = params[:link]
            else
              link="/familywebsite/add_nonhmm/"+params[:id]+"/?pa="+params[:reciepent_email]
            end
          else
            link = params[:link]
          end
        else
          link = params[:link]

        end
        #link=redirect_to :controller => 'my_familywebsite', :action => 'add_nonhmm', :pa => params[:email] , :id => params[:id]
        sender_name = params[:sender_name]
        sender_email = params[:sender_email]
        reciepent_message=params[:reciepent_message]
        messageboard_link="http://www.holdmymemories.com/familywebsite/messageboard/"+params[:id]

        pass = 'n'

        if (params[:share_type] == 'journal' || params[:share_type] == 'biography')
          @sha_type = params[:share_type]
        else
          @sha_type = 'moment'
        end
        if params[:reciepent_email]
          @frdEmail = params[:reciepent_email]
          frindsEmail=@frdEmail.split(',')
          for i in frindsEmail

            Postoffice.deliver_shareFamilypages(i,sender_name,sender_email,params[:link],reciepent_message,@sha_type,pass,messageboard_link,family_img,content_url)


            @familywebsite_share = FamilywebsiteShare.new()
            @familywebsite_share['senders_name']=params[:sender_name]
            @familywebsite_share['senders_email']=params[:sender_email]
            @familywebsite_share['share_message']=params[:reciepent_message]
            @familywebsite_share['reciepent_emails']=i
            @familywebsite_share['website_owner_id']=@uid
            @familywebsite_share['share_date']=Time.now
            @familywebsite_share['family_website']=params[:id]
            @familywebsite_share.save
          end
        end

        if params[:address_email]

          adrsEmail=params[:address_email]
          for j in adrsEmail

            Postoffice.deliver_shareFamilypages(j,sender_name,sender_email,params[:link],reciepent_message,@sha_type,pass,messageboard_link,family_img,content_url)



            @familywebsite_share = FamilywebsiteShare.new()
            @familywebsite_share['senders_name']=params[:sender_name]
            @familywebsite_share['senders_email']=params[:sender_email]
            @familywebsite_share['share_message']=params[:reciepent_message]
            @familywebsite_share['reciepent_emails']=j
            @familywebsite_share['website_owner_id']=@uid
            @familywebsite_share['share_date']=Time.now
            @familywebsite_share['family_website']=params[:id]
            @familywebsite_share.save
          end
        end



        session[:journal] = "journal"
        $share_familypage
        flash[:share_familypage] = "<font color='#e75e16' size=3>This page was successfully sent</font>"
        redirect_to link
      end
    else
      flash[:error] = 'Please enter the correct code!'
    end
  end



  def add_nonhmm
    if params[:pa]
      email = params[:pa]
      @frindsEmail=email.split(',')
    end
  end

  def add_nonhmmWorker
    if params[:nonhmm_email]
      @email = params[:nonhmm_email]
      @nonhmmemails = @email.join(",")


      if params[:nonhmm_name]
        @name = params[:nonhmm_name]
        @nonhmmnames = @name.join(",")
      end


      @frindsEmail=@nonhmmemails.split(',')
      @frindsName=@nonhmmnames.split(',')
      i=0

      #finding the size of an array
      @emailsize=@frindsEmail.size()
      @namesize=@frindsName.size()

      #loop to insert new nonHMM friends which are added through e-mail
      @emailsize.times {|i|
        @addnonhmm = NonhmmUser.new()
        @addnonhmm['v_email'] = @frindsEmail[i]
        @addnonhmm['v_name'] = @frindsName[i]
        @addnonhmm['uid'] = logged_in_hmm_user.id
        @addnonhmm['v_city'] = 'edit city'
        @addnonhmm['v_country'] = 'edit country'
        @addnonhmm.save
      }
      $addnonhmm
      flash[:addnonhmm] = 'Non-HMM Users Were Successfully added!!'
      $share_journal_sc
      flash[:share_journal_sc] = 'Journal was Successfully Shared!!'
    end
    redirect_to :controller => 'familywebsite', :action => 'home' , :id => params[:id]

  end

  def shared_moments
    redirect_to :action => 'home', :id => params[:id] if !params[:share_id] || params[:share_id]==nil
    @mobile_share_id = params[:share_id]
    content = MobileContentShare.find(:first,:conditions => "id=#{params[:share_id]}")
    if content
      contents = JSON.parse(content.user_contents)
      if contents.length==1
        details = UserContent.find(:first,:conditions => "id=#{contents[0]}")
        if details
          if details['e_filetype'] =='video'
            @share_video = "http://blog.holdmymemories.com/BlogVideoPlayer.swf?videopath=#{details.img_url}/user_content/videos/#{details.v_filename}.flv"
            @share_type = "video"
            @share_image="#{details.img_url}/user_content/videos/thumbnails/#{details.v_filename}.jpg"
          else
            @share_image="#{details.img_url}/user_content/photos/coverflow/#{details.v_filename}"
          end
        end
      end
      logger.info "share id :#{@mobile_share_id}"
    end
  end

  def mailtest
    render :layout => false
  end


  def testemail
    name=params[:name]
    fromemail=params[:fromemail]
    toemail=params[:toemail]
    Jangotest.deliver_testjango(name, fromemail,toemail)
    flash[:notice] = "email sent sucessfully."
    redirect_to "/familywebsite/mailtest/"
  end

  #Mobile events moments list
  def events_moments

    @buttonVisibility = false

    @event_id=params[:event_id]


    @path1 = ContentPath.find(:all)
    @path=""
    for path in @path1
      @path="#{@path}#{path.content_path},"
    end
    @contenturl=@path
    @proxyurls = get_proxy_urls()
    @detail = Tag.find :first, :joins => "INNER JOIN sub_chapters ON sub_chapters.tagid = tags.id INNER JOIN galleries ON galleries.subchapter_id = sub_chapters.id",:conditions => "sub_chapters.id=#{params[:event_id]}",
      :select =>"tags.v_tagname as chapter_name,tags.id as chapter_id,sub_chapters.id as subchapter_id,sub_chapters.sub_chapname as subchapter_name,galleries.v_gallery_name as gallery_name,tags.tag_type as chapter_type,galleries.e_gallery_type as gallery_type,galleries.id as gallery_id,tags.tag_type as chapter_type,tags.v_chapimage as chapter_image"

    usercont=UserContent.find(:first,:conditions=>"sub_chapid=#{params[:event_id]} and status='active'")
    if !usercont.nil?
      if usercont.e_filetype=="image"
        @share_image="#{usercont.img_url}/user_content/photos/coverflow/#{usercont.v_filename}"
      elsif usercont.e_filetype=="video"
        @share_image="#{usercont.img_url}/user_content/videos/thumbnails/#{usercont.v_filename}.jpg"
      end
    end

    @swfName = "ShareCoverFlow"
    @galleryUrl = "/share/events_moments_list/#{@event_id}"
    subdomain = request.subdomains[0]
    subdomain = 'www' if subdomain.blank?
    @share_video = "http://#{subdomain}.holdmymemories.com/#{@swfName}.swf?serverUrl=http://#{subdomain}.holdmymemories.com#{@galleryUrl}&buttonsVisible=false&contenturl=#{@contenturl}"
    @share_type = "video"



    render :layout => true

  end


  # new family website coverflow pages
  def new_home
    @current_page = 'home'
    #    get recent images uploaded by the user start
    if(@family_website_owner.password_required == 'no')
      access="(e_access='public' or e_access='semiprivate')"
    else
      access="e_access='public'"
    end
    @recent_moments = UserContent.find(:all, :conditions => "uid=#{@family_website_owner.id} and e_filetype = 'image' and #{access} and status = 'active'",:select =>"id,v_filename", :order => "id desc", :limit =>8)
    #    get recent images uploaded by the user end
    # render :text =>"#{@family_website_owner.id}"
  end

  def new_coverflow
    @current_page = 'home'
  end

  def new_subchapters_list
    unless params[:chapter_id].blank?
      temp = params[:chapter_id].split('?')
      params[:chapter_id] = temp[0]

      @chapter = Tag.find(params[:chapter_id],:select => "tags.v_tagname as chapter_name,tags.id as chapter_id,tags.tag_type,tags.v_chapimage as chapter_image,tags.img_url as chapter_image_url")
      if(@chapter.tag_type!='mobile_uploads')
        @chapter = Tag.find :first, :joins => "INNER JOIN sub_chapters ON sub_chapters.tagid = tags.id INNER JOIN galleries ON galleries.subchapter_id = sub_chapters.id",:conditions => "tags.id=#{params[:chapter_id]}",
          :select =>"tags.v_tagname as chapter_name,tags.id as chapter_id,sub_chapters.id as subchapter_id,sub_chapters.sub_chapname as subchapter_name,galleries.id as gallery_id,tags.tag_type,tags.v_chapimage as chapter_image,tags.img_url as chapter_image_url"
        redirect_to :action => 'new_gallery_contents_list', :id => params[:id],:gallery_id => @chapter.gallery_id if @chapter.tag_type=='photo' || @chapter.tag_type=='video' || @chapter.tag_type=='audio'
      end


      @proxyurls = get_proxy_urls()
      subdomain = request.subdomains[0]
      subdomain = 'www' if subdomain.blank?
      image_name  = @chapter.chapter_image
      image_name.slice!(-3..-1)

      @share_image = "#{@chapter.chapter_image_url}/user_content/photos/flex_icon/#{image_name}jpg"
      @share_video = "http://#{subdomain}.holdmymemories.com/Chapter.swf?serverUrl=http://#{subdomain}.holdmymemories.com/my_familywebsite/coverFlowImages/#{@chapter.chapter_id}&navigateToUrl=http://#{subdomain}.holdmymemories.com/my_familywebsite/gallery/&buttonsVisible=false&proxyurls=#{@proxyurls}&familyname=#{params[:id]}"
      @share_type = "video"

      #@blog = ChapterJournal.find(:first, :conditions => "tag_id=#{params[:chapter_id]}", :select => "v_tag_title as blog_title,v_tag_journal as blog_content,d_created_at as blog_date")
      @blog = Blog.find(:first, :conditions => "blog_type_id=#{params[:chapter_id]} and blog_type='chapter'", :select => "title as blog_title,description as blog_content,DATE_FORMAT(added_date,'%W, %b %d, %Y') as blog_date")
      @comments = ChapterComment.find(:all, :conditions => "e_approval = 'approve' and tag_id = #{params[:chapter_id]}", :order => "id asc", :select =>"v_comment as comment,v_name as commenter,d_created_on as commented_date")
      #      @commentcnt=Blog.count(:all,:joins=>"as a , blog_comments as b",:conditions=>"a.blog_type_id=#{params[:chapter_id]} and a.blog_type='chapter' and a.id=b.blog_id and b.status ='approved'")
      #      if(@commentcnt>0)
      #      @comments=Blog.find(:first,:joins=>"as a , blog_comments as b", :select=>"b.comment as comment,b.name as commenter,b.created_at as commented_date" ,:conditions=>"a.blog_type_id=#{params[:chapter_id]} and a.blog_type='chapter' and a.id=b.blog_id and b.status ='approved'")
      #      end
    else
      redirect_to :action => 'home', :id => params[:id]
    end

  end

  def new_galleries_list
    unless params[:subchapter_id].blank?
      temp = params[:subchapter_id].split('?')
      params[:subchapter_id] = temp[0]
      @detail = Tag.find :first, :joins => "INNER JOIN sub_chapters ON sub_chapters.tagid = tags.id",:conditions => "sub_chapters.id=#{params[:subchapter_id]}",
        :select =>"tags.v_tagname as chapter_name,tags.id as chapter_id,sub_chapters.id as subchapter_id,sub_chapters.sub_chapname as subchapter_name, sub_chapters.store_id as store_id, sub_chapters.img_url as img_url "
      if(@detail.store_id==nil || @detail.store_id=="")
      else
        @logo="no"
        store=HmmStudio.find(@detail.store_id)
        @store=store.studio_name
        studio_logo = store.studio_logo
        slogo=store.studio_logo.split('.')
        if(slogo[1]=='gif')
          @logo="no"
        else
          @logo="yes"
        end
        @share_image_studio = "#{@detail.img_url}/user_content/studio_logos/#{studio_logo}"
        if(@logo=="yes")
          @share_image = @share_image_studio
        end
      end
      if(session[:hmm_user]==@family_website_owner.id)
        @buttonVisibility = "true"
      else
        @buttonVisibility = "false"
      end
      #@blog = SubChapJournal.find(:first, :conditions => "sub_chap_id = #{params[:subchapter_id]}", :select => "journal_title as blog_title,subchap_journal as blog_content,created_on as blog_date")
      @blog = Blog.find(:first, :conditions => "blog_type_id=#{params[:subchapter_id]} and blog_type='subchapter'", :select => "title as blog_title,description as blog_content,DATE_FORMAT(added_date,'%W, %b %d, %Y') as blog_date")
      @comments = SubchapComment.find(:all, :conditions => "e_approval = 'approve' and subchap_id = #{params[:subchapter_id]}", :order => "id asc", :select =>"v_comments as comment,v_name as commenter,d_created_on as commented_date")
      #@comments=Blog.find(:first,:joins=>"as a , blog_comments as b", :select=>"b.comment as comment,b.name as commenter,b.created_at as commented_date" ,:conditions=>"a.blog_type_id=#{params[:subchapter_id]} and a.blog_type='subchapter' and a.id=b.blog_id and b.status ='approved'")

    else
      redirect_to :action => 'home', :id => params[:id]
    end
  end

  def new_gallery_contents_list
    unless params[:gallery_id].blank?
      if(session[:hmm_user]==@family_website_owner.id)
        @buttonVisibility = "true"
      else
        @buttonVisibility = "false"
      end
      temp = params[:gallery_id].split('?')
      params[:gallery_id] = temp[0]
      @gallery_id =params[:gallery_id]
      @gallery  = Galleries.find(:first, :conditions => "id=#{params[:gallery_id]}", :order => "order_num ASC")
      @detail=SubChapter.find(@gallery.subchapter_id)
      if(@detail.store_id==nil || @detail.store_id=="")
      else
        @logo="no"
        store=HmmStudio.find(@detail.store_id)
        @store=store.studio_name
        studio_logo = store.studio_logo
        slogo=store.studio_logo.split('.')
        if(slogo[1]=='gif')
          @logo="no"
        else
          @logo="yes"
        end

        @share_image_studio = "#{@detail.img_url}/user_content/studio_logos/#{studio_logo}"
        if(@logo=="yes")
          @share_image = @share_image_studio
        end
      end
      @galleryUrl = ""
      if(@gallery.e_gallery_type == "video")
        logger.info("Gallery Type Video")
        @swfName = "CoverFlowVideo"
        @swfName1 = "CoverFlowVideo"
        @galleryUrl = "/evelethsfamily/videoCoverflow/"+params[:gallery_id]
      elsif(@gallery.e_gallery_type == "image")
        logger.info("Gallery Type Image")
        @swfName = "PhotoGallery"
        @swfName1 = "Chapter"
        @galleryUrl = "/evelethsfamily/showGallery/"+params[:gallery_id]
      elsif(@gallery.e_gallery_type == "audio")
        logger.info("Gallery Type Audio")
        @swfName = "CoverFlowAudio"
        @swfName1 = "CoverFlowAudio"
        @galleryUrl = "/evelethsfamily/showAudioGallery/"+params[:gallery_id]
      end

      @detail = Tag.find :first, :joins => "INNER JOIN sub_chapters ON sub_chapters.tagid = tags.id INNER JOIN galleries ON galleries.subchapter_id = sub_chapters.id",:conditions => "galleries.id=#{params[:gallery_id]}",
        :select =>"tags.v_tagname as chapter_name,tags.id as chapter_id,sub_chapters.id as subchapter_id,sub_chapters.sub_chapname as subchapter_name,galleries.v_gallery_name as gallery_name,tags.tag_type as chapter_type,galleries.e_gallery_type as gallery_type,galleries.id as gallery_id,tags.tag_type as chapter_type,tags.v_chapimage as chapter_image"
      @proxyurls = get_proxy_urls()

      if(@detail.chapter_type == 'chapter')
        img = @gallery.v_gallery_image
      else
        img = @detail.chapter_image
      end
      subdomain = request.subdomains[0]
      subdomain = 'www' if subdomain.blank?
      image_name  = img
      image_name.slice!(-3..-1)
      @share_image = "#{@gallery.img_url}/user_content/photos/flex_icon/#{image_name}jpg"
      @share_video = "http://#{subdomain}.holdmymemories.com/#{@swfName1}.swf?serverUrl=http://#{subdomain}.holdmymemories.com#{@galleryUrl}&buttonsVisible=false&proxyurls=#{@proxyurls}"
      @share_type = "video"
      # @blog = GalleryJournal.find(:first, :conditions => "galerry_id = #{params[:gallery_id]}", :select => "v_title as blog_title,v_journal as blog_content,d_created_on as blog_date")
      @blog = Blog.find(:first, :conditions => "blog_type_id=#{params[:gallery_id]} and blog_type='gallery'", :select => "title as blog_title,description as blog_content,DATE_FORMAT(added_date,'%W, %b %d, %Y') as blog_date")
      @comments = GalleryComment.find(:all, :conditions => "e_approval = 'approve' and gallery_id = #{params[:gallery_id]}", :order => "id asc", :select =>"v_comment as comment,v_name as commenter,d_created_on as commented_date")
      #@comments=Blog.find(:first,:joins=>"as a , blog_comments as b", :select=>"b.comment as comment,b.name as commenter,b.created_at as commented_date" ,:conditions=>"a.blog_type_id=#{params[:gallery_id]} and a.blog_type='gallery' and a.id=b.blog_id and b.status ='approved'")

    else
      redirect_to :action => 'home', :id => params[:id]
    end
  end






  # Flex coverflow servies
  def fx_list_chapters
    @family_name = params[:id]
    user_id = @family_website_owner.id
    @hmm_user_check =  HmmUser.count(:all, :conditions =>" account_expdate <= current_date and id='#{user_id}'")
    if @hmm_user_check > 0
      @flag = 1
    else
      @flag = 0
    end
    unless session[:hmm_user].blank?
      @log_status = "yes"
    else
      @log_status = "no"
    end
    @results = Tag.find(:all, :conditions => "uid=#{user_id} and status='active' and default_tag='yes'" , :order => "order_num ASC" )
    render :layout => false
  end


  def fx_list_subchapters
    @family_name = params[:id]
    user_id = @family_website_owner.id
    @hmm_user_check =  HmmUser.count(:all, :conditions =>" account_expdate <= current_date and id='#{user_id}'")
    if @hmm_user_check > 0
      @flag = 1
    else
      @flag = 0
    end
    unless session[:hmm_user].blank?
      @log_status = "yes"
    else
      @log_status = "no"
    end
    @tag = Tag.find(:first ,:conditions =>" id = '#{params[:chapter_id]}'")
    @subchapters = SubChapter.find(:all ,:conditions =>" tagid = '#{params[:chapter_id]}' and status='active'", :order => "order_num ASC" )
    render :layout => false
  end

  def fx_list_galleries
    @family_name = params[:id]
    user_id = @family_website_owner.id
    @hmm_user_check =  HmmUser.count(:all, :conditions =>" account_expdate <= current_date and id='#{user_id}'")
    if @hmm_user_check > 0
      @flag = 1
    else
      @flag = 0
    end
    unless session[:hmm_user].blank?
      @log_status = "yes"
    else
      @log_status = "no"
    end
    @galleries = Galleries.find(:all, :conditions=>"subchapter_id=#{params[:subchapter_id]} and status='active' ", :order => "order_num ASC")
    @subchapterid = params[:subchapter_id]
    render :layout => false
  end

  def fx_list_gallery_contents

    @gallery=Galleries.find(params[:gallery_id])
    @sub_chapter = SubChapter.find(@gallery.subchapter_id)
    @userid = HmmUser.find(:all, :conditions => "id=#{@sub_chapter.uid}")
    @uid = @userid[0]['id']
    @family_name=@userid[0]['family_name']
    @contents = UserContent.find(:all, :group => 'v_filename', :conditions => "gallery_id=#{params[:gallery_id]} and status='active' ", :order => "order_num ASC")
    render :layout => false
  end

  def flash_videos

  end

  def fx_flashvideo_images
    flash_video_id = params[:flash_video_id]
    @flashvideos = Hash.new
    @images_ary = UserContent.find(:all, :select => "a.v_filename as image_name,b.name,b.audio", :joins => "as a, flash_videos as b, flash_video_images as c", :conditions => " a.id = c.user_contents_id and b.id = c.flash_videos_id  and b.id = #{flash_video_id}" )
    @images = Array.new
    for images in  @images_ary
      @images.push("/user_content/photos/coverflow/#{images.image_name}")
    end
    @flashvideos['images'] = @images
    @flashvideos['name'] = @images_ary[0]['name']
    @flashvideos['audio'] = "/user_content/audios/slideshow/#{@images_ary[0]['audio']}"
    render :text => @flashvideos.to_json # render output
  end

  def upload_import
    type = params[:type]

    begin
      @user = UploadImportCount.new

      if type == 'upload'
        @user.clicked_on = type
      else
        @user.clicked_on = type
      end

      @user.hmm_user_id = @family_website_owner.id
      @user.clicked_date = Time.now.strftime("%Y-%m-%d")
      @user.save

    rescue
      logger.info("Hiiiiii")
    end
  end


  def fx_3d_list_chapters
    imagesc = Array.new
    @family_name = params[:id]
    @hmm_user_check =  HmmUser.count(:all, :conditions =>"account_expdate >= current_date and id=#{@family_website_owner.id}")
    if(@family_website_owner.password_required == 'no')
      access="(e_access='public' or e_access='semiprivate')"
    else
      access="e_access='public'"
    end
    @path = ContentPath.find(:first)
    if @hmm_user_check > 0
      @results = Tag.find(:all,:select=>"id,v_chapimage,id,v_tagname,tag_type,img_url", :conditions => "uid=#{@family_website_owner.id} and status='active' and default_tag='yes' and #{access} " , :order => "id ASC" )
      for photos in @results
        imagec = Hash.new()
        if(photos.v_chapimage == "folder_img.png" || photos.v_chapimage == "photo_album.png" ||
              photos.v_chapimage == "speaker.jpg" || photos.v_chapimage == "videogallery.png" || photos.v_chapimage== "nil")
          #set studio session icon if content is blank
          if (photos.v_tagname == "STUDIO SESSIONS" || photos.v_tagname == "studio sessions" || photos.v_tagname == "STUDIO SESSION"  || photos.v_tagname == "Studio session"  || photos.v_tagname == "studio session"  || photos.v_tagname == "Studio Sessions"  || photos.v_tagname == "Studio Session")
            icon=photos.img_url  + '/user_content/photos/big_thumb/noimage_studiosessions.jpg'
            navigate_path="#{@path.proxyname}/static/studios"
          else
            icon=photos.img_url  + '/user_content/photos/big_thumb/noimage.jpg'
            navigate_path="#{@path.proxyname}/familywebsite/fx_3d_list_subchapters/#{@family_name}?chapter_id=#{photos.id}"
          end
        elsif(photos.v_chapimage == "folder_img_import.png")
          icon=photos.img_url  + '/user_content/photos/big_thumb/imp-moments.jpg'
          if(photos.tag_type=='chapter')
            navigate_path="#{@path.proxyname}/familywebsite/fx_3d_list_subchapters/#{@family_name}?chapter_id=#{photos.id}"
          else
            subchapter=SubChapter.find(:first, :conditions => "tagid='#{photos.id}'")
            gallery = Galleries.find(:first, :conditions => "subchapter_id = '#{subchapter.id}'")
            navigate_path="#{@path.proxyname}/familywebsite/fx_3d_list_gallery_contents/#{@family_name}?gallery_id=#{gallery.id}"
          end
        else
          imageName  = photos.v_chapimage
          if(imageName == nil)
          else
            imageName.slice!(-3..-1)
          end
          icon=photos.img_url + '/user_content/photos/flex_icon/'+imageName+"jpg"
          if(photos.tag_type=='chapter')
            navigate_path="#{@path.proxyname}/familywebsite/fx_3d_list_subchapters/#{@family_name}?chapter_id=#{photos.id}"
          else
            subchapter=SubChapter.find(:first, :conditions => "tagid='#{photos.id}'")
            gallery = Galleries.find(:first, :conditions => "subchapter_id = '#{subchapter.id}'")
            navigate_path="#{@path.proxyname}/familywebsite/fx_3d_list_gallery_contents/#{@family_name}?gallery_id=#{gallery.id}"
          end
        end
        type="folder"
        imagec ={:id =>"chapterid_#{photos.id}",:name => photos.v_tagname,:icon =>  icon,:child_path =>  navigate_path, :type => type}
        imagesc.push(imagec)
      end
    end
    render :text => imagesc.to_json

  end


  def fx_3d_list_subchapters
    imagess = Array.new
    @family_name = params[:id]
    @path = ContentPath.find(:first)
    #user_id = @family_website_owner.id
    # hmm_user_check =  HmmUser.count(:all, :conditions =>" account_expdate <= current_date and id='#{user_id}'")
    # if (Integer(hmm_user_check) > 0)
    if(@family_website_owner.password_required == 'no')
      access="(e_access='public' or e_access='semiprivate')"
    else
      access="e_access='public'"
    end
    @tag = Tag.find(:first ,:conditions =>" id = '#{params[:chapter_id]}'")
    @subchapters = SubChapter.find(:all ,:select=>"sub_chapname,id,v_image,img_url",:conditions =>" tagid = '#{params[:chapter_id]}' and status='active'and #{access}", :order => "id ASC" )

    for content_subchap in @subchapters
      imagesub = Hash.new()
      if(content_subchap.sub_chapname == "" || content_subchap.sub_chapname==nil)
        name="Subchapter"
      else
        name=content_subchap.sub_chapname
      end
      if(content_subchap.v_image == "folder_img.png")
        icon=content_subchap.img_url + '/user_content/photos/big_thumb/noimage.jpg'
      else
        imageName  = content_subchap.v_image
        imageName.slice!(-3..-1)
        icon=content_subchap.img_url + '/user_content/photos/flex_icon/'+imageName+"jpg"
      end
      if(@tag.v_tagname == 'Mobile Uploads')
        navigate_path="#{@path.proxyname}/familywebsite/events_moments/#{@family_name}?event_id=#{content_subchap.id}"
      else
        navigate_path="#{@path.proxyname}/familywebsite/fx_3d_list_galleries/#{@family_name}?subchapter_id=#{content_subchap.id}"
      end
      type="folder"
      imagesub ={:id =>"sub_chapterid_#{content_subchap.id}",:name =>name,:icon =>  icon,:child_path =>  navigate_path, :type => type}
      imagess.push(imagesub)
    end
    render :text => imagess.to_json
  end
  # end

  def fx_3d_list_galleries
    imagesg = Array.new
    @family_name = params[:id]
    #user_id = @family_website_owner.id
    #@hmm_user_check =  HmmUser.count(:all, :conditions =>" account_expdate <= current_date and id='#{user_id}'")
    # if (Integer(hmm_user_check) > 0)
    @path = ContentPath.find(:first)
    if(@family_website_owner.password_required == 'no')
      access="(e_gallery_acess='public' or e_gallery_acess='semiprivate')"
    else
      access="e_gallery_acess='public'"
    end
    @galleries = Galleries.find(:all,:select=>"v_gallery_image,v_gallery_name,id,img_url", :conditions=>"subchapter_id=#{params[:subchapter_id]} and status='active' and #{access} ", :order => "id ASC")
    @subchapterid = params[:subchapter_id]
    for gallery in @galleries
      imageg = Hash.new()
      if(gallery.v_gallery_image=='picture.png' || gallery.v_gallery_image=='audio.png' ||gallery.v_gallery_image=='video.png')
        icon=gallery.img_url + '/user_content/photos/icon_thumbnails/noimage.jpg'
      else
        imageName  = gallery.v_gallery_image
        imageName.slice!(-3..-1)
        icon=gallery.img_url + '/user_content/photos/flex_icon/'+imageName+"jpg"
      end
      if(gallery.v_gallery_name == "" || gallery.v_gallery_name==nil)
        name="Gallery"
      else
        name=gallery.v_gallery_name
      end
      navigate_path="#{@path.proxyname}/familywebsite/fx_3d_list_gallery_contents/#{@family_name}?gallery_id=#{gallery.id}"
      type="folder"
      imageg ={:id =>"galleryid_#{gallery.id}",:name =>name,:icon =>  icon,:child_path =>  navigate_path, :type => type}
      imagesg.push(imageg)

    end
    render :text => imagesg.to_json
  end
  #end


  def fx_3d_list_gallery_contents
    imagesgc = Array.new
    #@uid =  @family_website_owner.id
    #@family_name=@family_website_owner.family_name
    if(@family_website_owner.password_required == 'no')
      access="(e_access='public' or e_access='semiprivate')"
    else
      access="e_access='public'"
    end
    @path = ContentPath.find(:first)
    @contents = UserContent.find(:all,:select=>"v_tagphoto,e_filetype,v_filename,id,img_url", :group => 'v_filename', :conditions => "gallery_id=#{params[:gallery_id]} and status='active' and #{access}", :order => "id ASC")
    for content in @contents
      imagegc = Hash.new()

      name=content.v_tagphoto
      type=content.e_filetype
      if(content.e_filetype=='image')
        icon=content.img_url + "/user_content/photos/big_thumb/"+content.v_filename
        navigate_path="#{content.img_url}/user_content/photos/coverflow/"+content.v_filename
      elsif(content.e_filetype=='video')
        icon="#{content.img_url}/user_content/videos/thumbnails/"+content.v_filename+".jpg"
        navigate_path="#{content.img_url}/user_content/videos/"+content.v_filename+".flv"
      elsif(content.e_filetype=='audio')
        icon="#{content.img_url}/user_content/audios/speaker.jpg"
        navigate_path="#{content.img_url}/user_content/audios/"+content.v_filename
      else
        navigate_path="#{@path.proxyname}/familywebsite/moments/#{@family_name}?moment_id=#{content.id}"
      end
      # navigate_path="#{@path.proxyname}/familywebsite/moments/#{@family_name}?moment_id=#{content.id}"
      imagegc ={:id =>"usercontentid_#{content.id}",:name =>name,:icon =>  icon,:child_path =>  navigate_path, :type => type}
      imagesgc.push(imagegc)
    end
    render :text => imagesgc.to_json
  end

  def new_view
    #render :layout =>false
  end

end