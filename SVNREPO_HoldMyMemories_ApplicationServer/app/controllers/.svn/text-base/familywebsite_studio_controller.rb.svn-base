class FamilywebsiteStudioController < ApplicationController
  layout 'familywebsite_studio'

  before_filter :check_account_public, :except => [:share]
  before_filter :check_account, :only => [:share]

  before_filter :authenticate_admin, :only => [ :hmm_reporting, :hmm_reporting_search, :cutekid_contetslist, :review_cutekid, :cutekid_moment_view ,:studio_customers,  :commissionReport, :list, :list1, :login_report, :guestReport, :statReport, :chapReport, :commentReport, :sessionReport, :fnf_index, :index1, :customer_list, :link_customer, :link_list, :link_list1, :platinum_user_excel, :gotskils_moment_view, :gotskils_contetslist, :review_gotskils, :pending_requests_admin, :pending_request_search_admin, :cancelled_list_search_admin, :cancelled_list_admin, :activation_report,:contest_shares,:form]

  #  ssl_required :home, :login,:user_login,:order_prints_login,:share_login,:popup_login,:order_prints_login
  #  ssl_allowed  :studio_session_videos,:share,:moments,:get_proxy_urls,:new_gallery_contents_list,:new_galleries_list,:new_subchapters_list,:studio_session_gallery,:homepage_data,:requesting_owner,:check_account_public,:check_account
  #
  #  before_filter :change_ssl, :only => [:studio_session_videos,:share,:moments,:get_proxy_urls,:new_gallery_contents_list,:new_galleries_list,:new_subchapters_list,:studio_session_gallery,:homepage_data,:requesting_owner,:check_account_public,:check_account]

  def change_ssl
    current= request.url.split("://")
    if current[0]== "https"
      redirect_to "http://#{current[1]}"
    end
  end

  def check_account_public
    unless params[:id].blank?
      @family_website_owner = HmmUser.find(:first,:joins =>"INNER JOIN themes on hmm_users.theme_id=themes.id", :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')",:select => "hmm_users.*,themes.stylesheet as theme") #get the user details
      logger.info "====familywebsite_owner=========="
      logger.info params[:id]
      logger.info @family_website_owner.inspect
      logger.info "====familywebsite_owner=========="
      if @family_website_owner
        if (@family_website_owner.account_expdate!=nil && @family_website_owner.account_expdate < Date.current())

          flash[:expired] = 'expired'
          #redirect_to "/familywebsite/login/#{params[:id]}" if params[:action]!='login' unless (session[:hmm_user]==@family_website_owner.id)
        elsif(session[:employe]==nil && @family_website_owner.terms_checked == 'false' ) #if the logged in user is not employee and terms is not agreed
          flash[:terms] = 'terms'
          if(session[:hmm_user]) #f the user is logged in, takes to agree terms page
            redirect_to "/user_account/update_terms/"
          else #if the user is not logged in, takes to login page
            #redirect_to "/familywebsite/login/#{params[:id]}" if params[:action]!='login'
          end
        elsif @family_website_owner.e_user_status=='blocked' #displays message, if the user is blocked
          render :text => "This Familywebsite has been Blocked. Please contact Website Administrator at <a href='mailto:admin@holdmymemories.com' >admin@HoldMyMemories.com</a>"
        elsif (session[:visitor]==nil || session[:visitor]!=@family_website_owner.family_name) &&  session[:hmm_user] != @family_website_owner.id && @family_website_owner.password_required == 'yes'
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
    @path1 = ContentPath.find(:all)
    @path=""
    for path in @path1
      @path="#{@path}#{path.content_path},"
    end
    if(params[:id]=='bob')
      @content_server_url = "http://content.holdmymemories.com"
    else
      @content_server_url = "#{@path}"
      @img_url=@path1[0].content_path
    end
    return true #returns true if all the conditions are cleared
  end


  def check_account
    unless params[:id].blank?
      @family_website_owner = HmmUser.find(:first,:joins =>"INNER JOIN themes on hmm_users.theme_id=themes.id", :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')",:select => "hmm_users.*,themes.stylesheet as theme") #get the user details
      if @family_website_owner
        if(session[:employe]==nil && @family_website_owner.terms_checked == 'false' ) #if the logged in user is not employee and terms is not agreed
          flash[:terms] = 'terms'
          if(session[:hmm_user]) #f the user is logged in, takes to agree terms page
            redirect_to "/user_account/update_terms/"
          else #if the user is not logged in, takes to login page
            redirect_to "/familywebsite_studio/login/#{params[:id]}" if params[:action]!='login'
          end
        elsif @family_website_owner.e_user_status=='blocked' #displays message, if the user is blocked
          render :text => "This Familywebsite has been Blocked. Please contact Website Administrator at <a href='mailto:admin@holdmymemories.com' >admin@HoldMyMemories.com</a>"
        elsif session[:visitor]==nil && session[:hmm_user]==nil && @family_website_owner.password_required == 'yes'
          #render :text =>"Password protected. Redirect to family website login page"
          redirect_to :controller =>"familywebsite", :action => 'visitor_login', :id => params[:id], :redirect_url => request.url if (params[:action]!='login' && params[:action]!='visitor_login')
        elsif !session[:hmm_user] || logged_in_hmm_user.id!=@family_website_owner.id
          redirect_to "/familywebsite_studio/login/#{params[:id]}"
        else
          @path1 = ContentPath.find(:all)
          @path=""
          for path in @path1
            @path="#{@path}#{path.content_path},"
          end
          @content_server_url = "#{@path}"
          @content_server_name = @path1[0].proxyname
          return true #returns true if all the conditions are cleared
        end
      else
        redirect_to '/'
      end
    end
  end


  def home
    logger.info "*************home page inside********************"
    logger.info logged_in_hmm_user.inspect
    @studio_groups=HmmUser.find(:first,:select => "a.*,b.*,c.*,d.* ", :joins =>"as a ,employe_accounts as b,hmm_studios as c,hmm_studiogroups  as d ",:conditions => "a.id=#{@family_website_owner.id} and b.id=a.emp_id and b.store_id=c.id and c.studio_groupid=d.id ")
    @creditpt=CreditPoint.find(:first,:conditions=>"user_id=#{@family_website_owner.id}")
    @cp=CreditPoint.count(:all,:conditions=>"user_id=#{@family_website_owner.id}")
    now = Time.now
    @check_date = now.strftime("%Y-%m-%d")
    unless @studio_groups.blank?
      unless @studio_groups.account_expdate.blank?
        if  @cp == 0 || (@studio_groups.account_expdate < @check_date.to_date )
          @creditpt_count=0
        else
          @creditpt_count=1
        end
      else
        if  @cp == 0
          @creditpt_count=0
        else
          @creditpt_count=1
        end
      end
    end
  end

  def user_login
    render :layout =>false
  end

  def login

    user = HmmUser.find_by_family_name(params[:id])
    studio = HmmStudio.find(user.studio_id) rescue nil

    @current_page = 'login'

    if logged_in_hmm_user && @family_website_owner.id == logged_in_hmm_user.id && @family_website_owner.terms_checked =="true" && studio.family_website_version == 2
      redirect_to :action => 'home', :id => params[:id]
    end
    if params[:username] == "" && params[:password] == ""
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
          if studio.nil?
            redirect_to "/account_settings/upgrade_account_form/#{params[:id]}?acc_type=platinum_account&option=1"
          elsif studio.family_website_version == 3
            redirect_to :action => 'home', :id => params[:id]
          else

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
                  redirect_to :controller => 'familywebsite_studio',:action => 'home', :id => params[:id]
                end
              end
            else
              session[:hmm_user]=nil
              flash[:error] = " Invalid Login.You must be the owner of this site."
              #log file entry
              logger.error("[Invalid Login]: by [User]:#{params[:username]} at #{Time.now}")
              redirect_to :controller => 'familywebsite_studio',:action => 'home', :id => params[:id]
            end
          end
        else
          session[:hmm_user]=nil
          flash[:error] = "User is been blocked.. Contact Admin!!"
        end
      else
        flash[:error] = "Either your username or password is incorrect. Please try again."
        #log file entry
        logger.error("[Invalid Login]: by [User]:#{params[:username]} at #{Time.now}")
        redirect_to :controller => 'familywebsite_studio',:action => 'home', :id => params[:id]

      end
    end
  end

  def popup_login

    user = HmmUser.find_by_family_name(params[:id])
    studio = HmmStudio.find(user.studio_id) rescue nil

    if user.v_user_name == params[:username]
      @current_page = 'login'

      if logged_in_hmm_user && @family_website_owner.id == logged_in_hmm_user.id && @family_website_owner.terms_checked =="true" && studio.family_website_version == 2
        redirect_to :action => 'home', :id => params[:id]
      end
      if params[:username] == "" && params[:password] == ""
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
            if studio.nil?
              redirect_to "/account_settings/upgrade_account_form/#{params[:id]}?acc_type=platinum_account&option=1"
            elsif studio.family_website_version == 3
              redirect_to :controller=>"studio_session_orders",:action => 'print_orders', :id => params[:id]
            else

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
                    redirect_to :controller=>"studio_session_orders",:action => 'print_orders', :id => params[:id]
                  end
                end
              else
                session[:hmm_user]=nil
                flash[:error] = " Invalid Login.You must be the owner of this site."
                #log file entry
                logger.error("[Invalid Login]: by [User]:#{params[:username]} at #{Time.now}")
              end
            end
          else
            session[:hmm_user]=nil
            flash[:error] = "User is been blocked.. Contact Admin!!"
          end
        else
          flash[:error] = "Either your username or password is incorrect. Please try again."
          #log file entry
          logger.error("[Invalid Login]: by [User]:#{params[:username]} at #{Time.now}")
          redirect_to :action => 'home', :id => params[:id]
        end
      end
    else
      flash[:error] = "Either your username or password is incorrect. Please try again."
      redirect_to :action => 'home', :id => params[:id]
    end
  end

  def share_login

    user = HmmUser.find_by_family_name(params[:id])
    studio = HmmStudio.find(user.studio_id) rescue nil
    if user.v_user_name == params[:username]
      @current_page = 'login'

      if logged_in_hmm_user && @family_website_owner.id == logged_in_hmm_user.id && @family_website_owner.terms_checked =="true" && studio.family_website_version == 2
        redirect_to :action => 'home', :id => params[:id]
      end
      if params[:username] == "" && params[:password] == ""
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
            if studio.nil?
              redirect_to "/account_settings/upgrade_account_form/#{params[:id]}?acc_type=platinum_account&option=1"
            elsif studio.family_website_version == 3
              redirect_to :controller=>"familywebsite_studio",:action => 'share', :id => params[:id]
            else

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
                    redirect_to :controller=>"familywebsite_studio",:action => 'share', :id => params[:id]
                  end
                end
              else
                session[:hmm_user]=nil
                flash[:error] = " Invalid Login.You must be the owner of this site."
                #log file entry
                logger.error("[Invalid Login]: by [User]:#{params[:username]} at #{Time.now}")
                redirect_to :controller => 'familywebsite_studio',:action => 'home', :id => params[:id]
              end
            end
          else
            session[:hmm_user]=nil
            flash[:error] = "User is been blocked.. Contact Admin!!"
            redirect_to :controller => 'familywebsite_studio',:action => 'home', :id => params[:id]
          end
        else
          flash[:error] = "Either your username or password is incorrect. Please try again."
          #log file entry
          logger.error("[Invalid Login]: by [User]:#{params[:username]} at #{Time.now}")
          redirect_to :controller => 'familywebsite_studio',:action => 'home', :id => params[:id]
        end
      end
    else
      flash[:error] = "Either your username or password is incorrect. Please try again."
      redirect_to :action => 'home', :id => params[:id]
    end
  end

  def logout
    user = HmmUser.find(session[:hmm_user]) rescue nil
    unless user.nil?
      if user.studio_id == 0
      else
        studio = HmmStudio.find(user.studio_id) rescue nil
      end
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
    unless user.nil? or params[:visitor] == "visitor"
      if studio.nil?
        redirect_to :controller=>"familywebsite",:action => 'home', :id => params[:id]
      elsif studio.family_website_version == 3
        redirect_to :action => 'home',:id=>params[:id]
      else
        redirect_to :action => 'login', :id => params[:id]
      end
    else
      redirect_to :controller=>"order_request",:action => 'visitor_login'
    end
  end

  def order_prints_login
    render :layout =>false
  end

  def requesting_owner
    if verify_recaptcha
      puts "========================"
      unless params[:user][:name] == "" and params[:user][:email] == ""
        puts params[:id]
        puts params.inspect
        owner = HmmUser.find_by_family_name(params[:id])
        @path = ContentPath.find(:all)
        code = OrderRequest.find_by_sql("select uuid() as id")
        orders = OrderRequest.count(:conditions=>"email_address='#{params[:user][:email]}' and owner_id=#{owner.id}")
        puts "========================"
        if orders==0
          order_request = OrderRequest.new
          order_request.owner_id = owner.id
          order_request.email_address = params[:user][:email]
          order_request.message = params[:user][:body]
          order_request.requested_by = params[:user][:name]
          order_request.status = nil
          order_request.request_code = nil
          order_request.save


          order_request_status = OrderRequestStatus.new
          order_request_status.owner_id = owner.id
          order_request_status.visitor_id = order_request.id
          order_request_status.status = "pending"
          order_request_status.save
          code = "#{order_request_status.id}_#{code.id}"
          logger.info("order_request_status.id")
          logger.info(order_request_status.id)
          logger.info(code)
          Postoffice.deliver_requesting_owner1(owner.v_e_mail,order_request.email_address,order_request.requested_by,order_request.message,owner.family_name,@path[0].proxyname,code)
          flash[:notice] = "Your request has been sent to #{owner.family_name}"
        else

          flash[:notice] = "Your have already sent request once try with other email ID"
        end
      end
    else
      flash[:notice] = "Invalid Captcha and can't be empty."
    end
    redirect_to :action=>"home",:id=>params[:id]
  end

  def share
    @content_path = ContentPath.find(:first,:conditions=>"status='active'")
    subdomain = request.subdomains[0]
    subdomain = 'www' if subdomain.blank?
    @proxyurls = get_proxy_urls()
    owner = HmmUser.find(:first,:conditions =>"family_name='#{params[:id]}'")
    suchapter_images= SubChapter.find(:all,:select=>"id",:conditions=>"uid=#{owner.id} and store_id!=''",:order=>"id desc")
    type="image"
    @userimages = FamilywebsiteStudio.getinfo(suchapter_images,type)
    if @userimages
      @share_image = "#{@userimages[0].img_url}/user_content/photos/coverflow/#{@userimages[0].v_filename}"
      logger.info(@share_image)
    end
    logger.info("@share_image")
    @share_video = "http://#{subdomain}.holdmymemories.com/flash/debug/ImageDisplayer.swf?serverURL=http://#{subdomain}.holdmymemories.com/familywebsite_studio/homepage_data/#{params[:id]}&proxyurl=#{@proxyurls}&familyname=#{params[:id]}"
    @share_type = "video"


  end

  def homepage_data
    @content_path = ContentPath.find(:first,:conditions=>"status='active'")
    owner = HmmUser.find(:first,:conditions =>"family_name='#{params[:id]}'")
    if params[:gallery_id]
      @userimages=UserContent.find(:all,:select =>"id,img_url,v_filename,sub_chapid,gallery_id",:conditions=>"gallery_id=#{params[:gallery_id]} and e_access='public' and status='active'",:order=>"id desc")
    else
      suchapter_images= SubChapter.find(:all,:select=>"id",:conditions=>"uid=#{owner.id} and status='active' and e_access='public' and store_id!=''",:order=>"id desc")
      type="image"
      @userimages = FamilywebsiteStudio.getinfo(suchapter_images,type)
    end
    logger.info(@userimages.inspect)
    render :layout =>false

  end




  def studio_session_gallery
    @content_path = ContentPath.find(:first,:conditions=>"status='active'")
    type="video"
    suchapter_images= SubChapter.find(:all,:select=>"id",:conditions=>"uid=#{@family_website_owner.id} and status='active' and e_access='public' and store_id!=''",:order=>"id desc")
    @studio_gallery= FamilywebsiteStudio.getvideoinfo(suchapter_images,type)

    render :layout =>false
  end

  def new_subchapters_list
    unless params[:chapter_id].blank?
      temp = params[:chapter_id].split('?')
      params[:chapter_id] = temp[0]
      @versions=VersionDetail.find(:first,:conditions=>"file_name='Carousel'")
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

    else
      redirect_to :action => 'home', :id => params[:id]
    end

  end

  def new_galleries_list
    unless params[:subchapter_id].blank?
      temp = params[:subchapter_id].split('?')
      params[:subchapter_id] = temp[0]
      @versions=VersionDetail.find(:first,:conditions=>"file_name='Carousel'")
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
    else
      redirect_to :action => 'home', :id => params[:id]
    end
  end

  def new_gallery_contents_list
    @versions=VersionDetail.find(:first,:conditions=>"file_name='Carousel'")
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
    else
      redirect_to :action => 'home', :id => params[:id]
    end
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
        subdomain = request.subdomains[0]
        subdomain = 'www' if subdomain.blank?
        @swfName1 = "Chapter"
        @galleryUrl = "/evelethsfamily/showGallery/#{@detail.gallery_id}"
        if(@detail.e_filetype =="image")
          if(@detail.subchapstore=="" || @detail.subchapstore==nil || @logo=="no" )
            @share_image = "#{@detail.img_url}/user_content/photos/coverflow/#{@detail.v_filename}"
          else
            @share_image = @share_image_studio
            #@share_image = "#{@detail.img_url}/user_content/photos/journal_thumb/#{@detail.v_filename}"
          end
         @share_video = "http://#{subdomain}.holdmymemories.com/#{@swfName1}.swf?serverUrl=http://#{subdomain}.holdmymemories.com#{@galleryUrl}&buttonsVisible=false&proxyurls=#{@proxyurls}"
         @share_type = "video"
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
      else
        redirect_to :action => 'home', :id => params[:id]
      end
    else
      redirect_to :action => 'home', :id => params[:id]
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

  def studio_session_videos

  end

  def memory_lane_data
    all_images = Hash.new
    user_id=HmmUser.find(:first,:select=>"id",:conditions=>"family_name='#{params[:id]}'")
    image_count=UserContent.count(:select=>"distinct(v_filename)",:conditions=>"status='active' and e_access='public' and uid=#{user_id.id} and e_filetype='image'")
    @userimages=UserContent.find(:all,:select =>"id,img_url,v_filename",:conditions=>"status='active' and e_access='public' and e_filetype='image' and uid=#{user_id.id}",:group => 'v_filename',:order=>"id desc",:limit=>"20")
    if @userimages
      images_arr= Array.new
      for userimage in @userimages
        images = Hash.new
        images ={:img => "#{userimage.img_url}/user_content/photos/journal_thumb/#{userimage.v_filename}",:img_id =>userimage.id}
        images_arr.push(images)
      end
      all_images['body'] =  images_arr
      all_images['status'] = "success"
      all_images['count'] = image_count
    else
      all_images['status'] = "failure"
    end
    render :text=>all_images.to_json
  end

  def memory_lane_custom_data
    all_images = Hash.new
    user_id=HmmUser.find(:first,:select=>"id",:conditions=>"family_name='#{params[:id]}'")
    image_count=UserContent.count(:select=>"distinct(v_filename)",:conditions=>"status='active' and e_access='public' and uid=#{user_id.id} and e_filetype='image'")
    @userimages = UserContent.paginate(:per_page => params[:per_page], :page => params[:page], :select =>"id,img_url,v_filename",:conditions=>"status='active' and uid=#{user_id.id} and e_access='public' and e_filetype='image'", :group => 'v_filename', :order => "id DESC")
    if @userimages
      images_arr= Array.new
      for userimage in @userimages
        images = Hash.new
        images ={:img => "#{userimage.img_url}/user_content/photos/journal_thumb/#{userimage.v_filename}",:img_id =>userimage.id}
        images_arr.push(images)
      end
      all_images['body'] =  images_arr
      all_images['status'] = "success"
      all_images['count'] = image_count
    else
      all_images['status'] = "failure"
    end
    render :text=>all_images.to_json
  end


  def memory_lane_chapters_list
    imagesc = Array.new
    all_images = Hash.new
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
            navigate_path="#{@path.proxyname}/familywebsite_studio/memory_lane_subchapters_list/#{@family_name}?chapter_id=#{photos.id}"
          end
          icon_exists="yes"
          type="folder"
        elsif(photos.v_chapimage == "folder_img_import.png")
          icon=photos.img_url  + '/user_content/photos/big_thumb/imp-moments.jpg'
          if(photos.tag_type=='chapter')
            navigate_path="#{@path.proxyname}/familywebsite_studio/memory_lane_subchapters_list/#{@family_name}?chapter_id=#{photos.id}"
            type="folder"
          else
            subchapter=SubChapter.find(:first, :conditions => "tagid='#{photos.id}'")
            gallery = Galleries.find(:first, :conditions => "subchapter_id = '#{subchapter.id}'")
            navigate_path="#{@path.proxyname}/familywebsite_studio/memory_lane_images_list/#{@family_name}?gallery_id=#{gallery.id}"
            type="file"
          end
          icon_exists="yes"
        else
          imageName  = photos.v_chapimage
          if(imageName == nil)
          else
            imageName.slice!(-3..-1)
          end
          icon=photos.img_url + '/user_content/photos/flex_icon/'+imageName+"jpg"
          #icon_exists=registered_domain_name_exists(photos.img_url,"/flex_icon",imageName+"jpg")
          icon_exists="yes"
          if(photos.tag_type=='chapter')
            navigate_path="#{@path.proxyname}/familywebsite_studio/memory_lane_subchapters_list/#{@family_name}"
            navigate_path_ref="#{@path.proxyname}/familywebsite_studio/memory_lane_subchapters_list/#{@family_name}?chapter_id=#{photos.id}"
            type="folder"
          else
            subchapter=SubChapter.find(:first, :conditions => "tagid='#{photos.id}'")
            gallery = Galleries.find(:first, :conditions => "subchapter_id = '#{subchapter.id}'")
            navigate_path="#{@path.proxyname}/familywebsite_studio/memory_lane_image_list/#{@family_name}"
            navigate_path_ref="#{@path.proxyname}/familywebsite_studio/memory_lane_images_list/#{@family_name}?gallery_id=#{gallery.id}"
            type="file"
          end
        end
        if icon_exists=="yes"
          imagec ={:id =>"#{photos.id}",:name => photos.v_tagname,:icon =>  icon,:child_path =>  navigate_path, :child_path_ref =>  navigate_path_ref,:type => type}
          imagesc.push(imagec)
        end
      end
      all_images['body']=imagesc
      all_images['status'] = "success"
    end
    render :text => all_images.to_json

  end


  def memory_lane_subchapters_list
    imagess = Array.new
    all_images = Hash.new
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
        icon_exists="yes"
      else
        imageName  = content_subchap.v_image
        imageName.slice!(-3..-1)
        icon=content_subchap.img_url + '/user_content/photos/flex_icon/'+imageName+"jpg"
        icon_exists="yes"
      end

      if(@tag.v_tagname == 'Mobile Uploads')
        navigate_path_ref="#{@path.proxyname}/familywebsite/events_moments/#{@family_name}?event_id=#{content_subchap.id}"
        navigate_path="#{@path.proxyname}/familywebsite/events_moments/#{@family_name}"
        type="file"
      else
        navigate_path_ref="#{@path.proxyname}/familywebsite_studio/memory_lane_galleries_list/#{@family_name}?subchapter_id=#{content_subchap.id}"
        navigate_path="#{@path.proxyname}/familywebsite_studio/memory_lane_galleries_list/#{@family_name}"
        type="folder"
      end
      if icon_exists=="yes"
        imagesub ={:id =>"#{content_subchap.id}",:name =>name,:icon =>  icon,:child_path =>  navigate_path, :child_path_ref => navigate_path_ref,:type => type}
        imagess.push(imagesub)
      end
    end
    all_images['body']=imagess
    all_images['status'] = "success"
    render :text => all_images.to_json
  end

  def memory_lane_galleries_list
    @path = ContentPath.find(:first)
    if params[:visitor_id].to_i > 0
      @family_website_owner = HmmUser.find_by_family_name(params[:id])
    end
    @family_name = params[:id]

    all_images = Hash.new
    data = Array.new
    userimage = Hash.new
    galleries = Galleries.find(:all,:conditions=>"subchapter_id=#{params[:subchapter_id]} and  e_gallery_acess='public' and status='active'" ,:order=>"id desc")
    for gallery in galleries
      if params[:id].upcase=="EVELETH" || params[:id].upcase=="BOB"
        link="http://content.holdmymemories.com"
      else
        link="#{gallery.img_url}"
      end
      usercontent=UserContent.count(:all,:conditions=>"gallery_id=#{gallery.id} and status='active' and e_access='public'")
      if usercontent.to_i > 0
        if(gallery.v_gallery_image=='picture.png' || gallery.v_gallery_image=='audio.png' ||gallery.v_gallery_image=='video.png')
          icon=link + '/user_content/photos/flex_icon/noimage.jpg'
          icon_exists="yes"
        else
          imageName  = gallery.v_gallery_image
          imageName.slice!(-3..-1)
          icon=link + '/user_content/photos/flex_icon/'+imageName+"jpg"
          icon_exists="yes"
        end
        if(gallery.v_gallery_name == "" || gallery.v_gallery_name==nil)
          name="Gallery"
        else
          name=gallery.v_gallery_name
        end
        if icon_exists=="yes"
          img1 = "#{link}/user_content/photos/icon_thumbnails/#{gallery.v_gallery_image}"
          navigate_path="#{@path.proxyname}/familywebsite_studio/memory_lane_images_list/#{@family_name}?gallery_id=#{gallery.id}"
          userimage = {:id=>gallery.id.to_s,:icon=>icon,:gallery_name=>gallery.v_gallery_image,:child_path=>navigate_path,:type=>"file",:name=>name}
          data.push(userimage)
        end
      end
    end
    all_images['body'] = data
    all_images['status'] = "success"
    render :text =>  all_images.to_json
  end

  def memory_lane_images_list
    data = Array.new
    userimage = Hash.new
    all_images = Hash.new
    @share_type="image"
    usercontents=UserContent.find(:all,:conditions=>"gallery_id=#{params[:gallery_id]}")
    for usercontent in usercontents
      if usercontent.e_filetype == "image"
        img1 = "#{usercontent.img_url}/user_content/photos/coverflow/#{usercontent.v_filename}"
        navigate="#{usercontent.img_url}/user_content/photos/journal_thumb/#{usercontent.v_filename}"
      else
        img1 = "#{usercontent.img_url}/user_content/videos/thumbnails/#{usercontent.v_filename}.jpg"
        navigate="#{usercontent.img_url}/user_content/videos/#{usercontent.v_filename}.flv"
      end
      icon_exists="yes"
      if icon_exists=="yes"
        userimage = {:image_id=>usercontent.id,:img_url=>img1,:gallery_name=>usercontent.v_tagname,:file_type=>usercontent.e_filetype,:icon=>navigate}
        data.push(userimage)
      end
    end
    all_images['body'] = data
    all_images['status'] = "success"
    render :text =>  all_images.to_json
  end

  def memory_lane_comments
    datas = Array.new
    usercomments = Hash.new
    all_comments = Hash.new
    blog = Blog.find(:first, :conditions => "blog_type_id=#{params[:moment_id]}", :select => "title as blog_title,description as blog_content,DATE_FORMAT(added_date,'%W, %b %d, %Y') as blog_date")
    comments = PhotoComment.find(:all, :conditions => "e_approved = 'approve' and user_content_id = #{params[:moment_id]}", :order => "id asc", :select =>"v_comment as comment,v_name as commenter,d_add_date as commented_date")
    if blog
      blog_title=blog.blog_title
      blog_description=blog.blog_content
      blog_date=blog.blog_date
    else
      blog_title=''
      blog_description=''
      blog_date=''
    end
    if comments
      for  comment in  comments
        usercomments={:comment=>comment.comment,:commenter=>comment.commenter,:commented_date=>comment.commented_date}
        datas.push(usercomments)
      end
      blogs={:blog_title=>blog_title,:blog_description=>blog_description,:blog_date=>blog_date}
      all_comments[:comments]=datas
      all_comments[:blogs]=blogs
      all_comments['status'] = "success"
    else
      all_comments['status'] = "fail"
    end
    render :text =>  all_comments.to_json
  end

  def registered_domain_name_exists_video(path,filename)
    url="http://content1.holdmymemories.com/user_content/videos#{path}/#{filename}"
    if url and url.match(URI::regexp(%w(http https))) then
      begin # check header response
        case Net::HTTP.get_response(URI.parse(url))
        when Net::HTTPSuccess
          return "yes"
          logger.info("#{path}/#{filename}  exists")
        else
          return "no"
          logger.info("#{path}/#{filename}  Not exists")
        end
      rescue # DNS failures
        logger.info("#{path}/#{filename}  Not exists")
        return "no"
      end
    end
  end


  def remote_file_exist
    open( "http://www.google.com/" , :method => :head).status rescue false
  end

  def registered_domain_name_exists(server,path,filename)
    logger.info(filename)
    logger.info(server)
    url="#{server}/user_content/photos#{path}/#{filename}"
    if url and url.match(URI::regexp(%w(http https))) then
      begin # check header response
        case Net::HTTP.get_response(URI.parse(url))
        when Net::HTTPSuccess
          return "yes"
          logger.info("#{path}/#{filename}  exists")
        else
          return "no"
          logger.info("#{path}/#{filename}  Not exists")
        end
      rescue # DNS failures
        logger.info("#{path}/#{filename}  Not exists")
        return "no"
      end
    end
  end

  def memory_lane_gallery_list
    if params[:visitor_id].to_i > 0
      @family_website_owner = HmmUser.find_by_family_name(params[:id])
    end

    all_images = Hash.new
    data = Array.new
    userimage = Hash.new
    subchapters= SubChapter.find(:all,:select=>"id",:conditions=>"uid=#{@family_website_owner.id} and status='active' and e_access='public' ",:order=>"id desc",:limit=>"30,30")
    if subchapters
      for subchapter in subchapters
        galleries = Galleries.find(:all,:conditions=>"subchapter_id=#{subchapter.id} and  e_gallery_acess='public' and status='active' and 	e_gallery_type='image'",:order=>"id desc")
        for gallery in galleries
          if params[:id].upcase=="EVELETH" || params[:id].upcase=="BOB"
            link="http://content.holdmymemories.com"
          else
            link="#{gallery.img_url}"
          end
          usercontent=UserContent.count(:all,:conditions=>"gallery_id=#{gallery.id} and status='active' and e_access='public'")
          if usercontent.to_i > 0
            if(gallery.v_gallery_image=='picture.png' || gallery.v_gallery_image=='audio.png' ||gallery.v_gallery_image=='video.png')
              icon=link + '/user_content/photos/flex_icon/noimage.jpg'
              icon_exists="yes"
            else
              imageName  = gallery.v_gallery_image
              imageName.slice!(-3..-1)
              icon=link + '/user_content/photos/flex_icon/'+imageName+"jpg"
              icon_exists=registered_domain_name_exists(link,"/flex_icon",imageName+"jpg")
            end
            if(gallery.v_gallery_name == "" || gallery.v_gallery_name==nil)
              name="Gallery"
            else
              name=gallery.v_gallery_name
            end

            if icon_exists=="yes"
              userimage = {:id=>gallery.id,:img_url=>icon,:gallery_name=>gallery.v_gallery_image,:name=>name}
              data.push(userimage)
            end
          end
        end
        all_images['body'] = data
        all_images['status'] = "success"
      end
    else
    end
    render :text =>  all_images.to_json
  end

  def memory_lane_image_list
    data = Array.new
    userimage = Hash.new
    all_images = Hash.new
    usercontents=UserContent.find(:all,:conditions=>"gallery_id=#{params[:gallery_id]}")
    for usercontent in usercontents
      if usercontent.e_filetype == "image"
        icon_exists=registered_domain_name_exists(usercontent.img_url,"/coverflow",usercontent.v_filename)
        if icon_exists=="yes"
          img1 = "#{usercontent.img_url}/user_content/photos/coverflow/#{usercontent.v_filename}"
          navigate="#{usercontent.img_url}/user_content/photos/#{usercontent.v_filename}"
          userimage = {:image_id=>usercontent.id,:img_url=>img1,:gallery_name=>usercontent.v_tagname,:file_type=>usercontent.e_filetype,:navigate=>navigate}
          data.push(userimage)
        end
      end
    end
    all_images['body'] = data
    all_images['status'] = "success"
    render :text =>  all_images.to_json
  end

  def memory_lane_list

  end

  def search_tags
    @retval = Hash.new()
    allimages=Array.new
    tags=params[:tagname].split(",")
    if !params[:user_id].blank? || !params[:tagname].blank?
      contents =MobileUserContent.find(:all,:conditions=>"uid = #{params[:user_id]} and status = 'active' and 	e_access!='private' and (e_filetype='video' or e_filetype='image')",:order =>"id desc")
      if contents
        for content in contents
          if content.v_tagname
            if content.v_tagname!=''
              tagarray=content.v_tagname.split(",")
              tagarray = tagarray.map {|x| x.upcase }
              tags = tags.map {|y| y.upcase }
              #              logger.info(tagarray.inspect)
              #              logger.info(tags.inspect)
              for tag in tags
                val=tagarray.grep(/^#{tag}/)

                if content.v_desc
                  v_desc=content.v_desc.upcase
                  cond=v_desc.grep(/#{tag}/)
                  cond_len=cond.length
                else
                  cond_len=0
                end

                if val.length > 0 || cond_len > 0
                  logger.info(tagarray.grep(/^#{tag}/))
                  if content.e_filetype=="image"
                    val={:image_id=>content.id,:tag_name=>content.v_tagname,:user_id=>content.uid,:file_type=>content.e_filetype,:description=>content.v_desc,:img_url=>"#{content.img_url}/user_content/photos/small_thumb/#{content.v_filename}",:icon=>"#{content.img_url}/user_content/photos/iphone/big_thumb/#{content.v_filename}"}
                    allimages.push(val)
                  elsif content.e_filetype=="video"
                    val={:image_id=>content.id,:tag_name=>content.v_tagname,:user_id=>content.uid,:file_type=>content.e_filetype,:description=>content.v_desc,:img_url=>"#{content.img_url}/user_content/videos/thumbnails/#{content.v_filename}.jpg",:icon=>"#{content.img_url}/user_content/videos/#{content.v_filename}.flv"}
                    allimages.push(val)
                  end
                  break
                end
              end
            end
          end
        end
        @retval['body'] = allimages
        @retval['total_count'] = allimages.length
        @retval['status'] = true
        @retval['count'] = allimages.length
      else
        @retval['message'] = 'Incomplete details provided!'
        @retval['status'] = false
      end
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    logger.info(@retval.inspect)
    render :text => @retval.to_json
  end


end