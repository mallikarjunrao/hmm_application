class MyFamilywebsiteController < ApplicationController
  #  layout "myfamilywebsite"
  #   helper :user_account
  #  include UserAccountHelper
  require 'will_paginate'
  require 'rubygems'
  require 'money'
  #  require 'active_merchant'
  require 'base64'
  include SortHelper
  helper :sort


  layout :theme_check

  #layout 'myfamilywebsite'


  #before_filter :theme_check, :except => [:videomoment_details, :biographies, :share , :chapters_display, :messageboard, :coverFlowImages, :gallerycoverflowimages, :videoCoverflow, :showGallery, :showAudioGallery, :share, :new_chap_comment, :new_subchap_comment, :new_gallery_comment, :new_photo_comment, :create_chap_comment, :create_gallery_comment, :create_subchap_comment, :create_photo_comment, :create_photo_comment, :view_chap_comments, :view_gallery_comments, :view_photo_comments, :view_subchap_comments, :sharejournalWorker, :send_book_session, :book_session_thankyou ]

  def theme_check
    @m=request.request_uri.split('/')
    @path=@m[2];
    if(@path.nil?)
    else
      @path=@path.split('?')
      @path=@path[0]
    end
    #puts @path
    # if (@path!='momentdetails'&& @path !='videomoment_details' && @path !='moment_page' && @path !='gallery' && @path !='subchapters' && @path !='gallery_fisheye' && @path !='shoppingcart_payment' && @path !='chapter_next' && @path !='sub_chapter_gallery' && @path !='chapter_gallery' && @path !='add_sizes' && @path !='share_journal')
    if(params[:familyname])
      @family_name_tag = params[:familyname]
    else
      @family_name_tag = params[:id]
    end

    #generic theme for shopping cart
    if(@path=='selected_items' || @path=='add_sizes' || @path=='edit_sizes' || @path=='delete_msg' || @path =='shoppingcart_payment' || @path =='payment_complete' || @path =='chapter_gallery' || @path =='chapterindex' || @path =='chapter_next' || @path =='sub_chapter_gallery')
      @theme_check='myfamilywebsite'
    else
      @theme_check = HmmUser.find(:all, :conditions => "family_name = '#{@family_name_tag}' || alt_family_name = '#{@family_name_tag}' ")
      @theme_check[0]['themes']
    end
  end

  def initialize
    super
  end

  def login_check #user login check for manage family website
    unless session[:hmm_user]
      hmm_terms_check = HmmUser.count(:all, :conditions => "family_name ='#{params[:id]}' and terms_checked ='false'")

      flash[:notice] = 'Please Login to Access your Account'
      redirect_to :action => mysite_login, :id => params[:id]

      return false
    else
      hmm_payement_check = HmmUser.count(:all, :conditions => "family_name ='#{params[:id]}' and account_expdate < CURDATE()")
      if (hmm_payement_check > 0 && request.request_uri != "manage_site/upgrade/#{params[:id]}?atype=platinum_account&msg=payment_req")
        flash[:error] = "Your credit card payment to your HoldMyMemories.com has been declined by your credit card company. This could be for a number of reasons, including an expired card. <br><br><br>Please re-enter your credit card information, or use a different card for the renewal of your account."
        redirect_to "https://www.holdmymemories.com/manage_site/upgrade/#{params[:id]}?atype=platinum_account&msg=payment_req"
      end

    end
  end

  def login_required

  end

  def mysite_authenticate
    self.logged_in_hmm_user = HmmUser.authenticate(params[:hmm_user][:v_user_name],params[:hmm_user][:v_password])
    #self.logged_in_hmm_user = HmmUser.authenticate("alok","alok")
    if is_userlogged_in?
      if logged_in_hmm_user.e_user_status == 'unblocked'
        #log file entry
        logger.info("[User]: #{params[:hmm_user][:v_user_name]} [Logged In] at #{Time.now} !")

        logger.info(logged_in_hmm_user.id)

        @client_ip = request.remote_ip
        @user_session = UserSessions.new()
        @user_session['i_ip_add'] = @client_ip
        @user_session['uid'] = logged_in_hmm_user.id
        @user_session['v_user_name'] = logged_in_hmm_user.v_user_name
        @user_session['d_date_time'] = Time.now
        @user_session['e_logged_in'] = "yes"
        @user_session['e_logged_out'] = "no"
        @user_session.save
        #  return "true"

        session[:alert] = "fnfalert"


        flag = 0
        cur_time=Time.now.strftime("%Y-%m-%d")
        hmm_user_check =  HmmUser.count(:all, :conditions =>" id='#{logged_in_hmm_user.id}' and family_name='#{params[:familyname]}' and d_created_date > '2009-01-01'")
        if(hmm_user_check > 0)
          redirect_to "/my_familywebsite/manage_website/#{params[:familyname]}"
        else
          reset_session
          flash[:error] = " Invalid Login.You are not an owner of this site."
          #log file entry
          logger.error("[Invalid Login]: by [User]:#{params[:hmm_user][:v_user_name]} at #{Time.now}")
          redirect_to "/my_familywebsite/mysite_login/#{params[:familyname]}"
          return "false"
        end
      else
        reset_session
        flash[:error1] = "User is been blocked.. Contact Admin!!"
        redirect_to "/my_familywebsite/mysite_login/#{params[:familyname]}"
      end

    else
      flash[:error] = "I'm sorry; either your username or password was incorrect. Or You are not an owner of this site!"
      #log file entry
      logger.error("[Invalid Login]: by [User]:#{params[:hmm_user][:v_user_name]} at #{Time.now}")
      redirect_to "/my_familywebsite/mysite_login/#{params[:familyname]}"
      return "false"
    end


  end

  def mysite_logout
    if(session[:hmm_user])
      @user_session = UserSessions.new()
      if(logged_in_hmm_user.id)
        @user_session['uid'] = logged_in_hmm_user.id
      end
      if(logged_in_hmm_user.v_user_name)
        @user_session['v_user_name'] = logged_in_hmm_user.v_user_name
      end
    end
    if request.post?

      reset_session
      flash[:notice] = "You Have Been Successfully logged out."
      @client_ip = request.remote_ip

      if(session[:hmm_user])
        @user_session['d_date_time'] = Time.now
        @user_session['i_ip_add'] = @client_ip
        @user_session['e_logged_in'] = "no"
        @user_session['e_logged_out'] = "yes"
        @user_session.save
      end
    end
    #log file entry
    #logger.info("[User]: Logged Out at #{Time.now}")
    redirect_to "/my_familywebsite/mysite_login/#{params[:id]}"
  end

  def home
    redirect_to "/familywebsite/home/#{params[:id]}"
    #    @block_check = HmmUser.count(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}') and e_user_status='blocked'")
    #    hmm_terms_check = HmmUser.count(:all, :conditions => "family_name ='#{params[:id]}' and terms_checked ='false'")
    #    if(session[:employe]==nil && hmm_terms_check > 0 )
    #        flash[:terms] = 'terms'
    #        if(session[:hmm_user])
    #          redirect_to "/user_account/update_terms/"
    #        else
    #          redirect_to "/manage_site/mysite_login/#{params[:id]}"
    #        end
    #    elsif(@block_check > 0)
    #      redirect_to :controller => 'my_familywebsite', :action => 'blocked', :id => params[:id]
    #    else
    #
    #
    #
    #      #    contentservers = ContentPath.find(:all)
    #      #    @proxyurls = nil
    #      #    for server in contentservers
    #      #      if(@proxyurls == nil)
    #      #        @proxyurls = server['content_path']
    #      #      else
    #      #
    #      #        @proxyurls = "#{@proxyurls},#{server['content_path']}"
    #      #      end
    #      #    end
    #      #@theme_check = HmmUser.find(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')")
    #      @password_protected = HmmUser.count(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}') and password_required='yes'")
    #
    #      @userid = HmmUser.find(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')")
    #      @uid = @userid[0]['id']
    #      #puts @uid
    #
    #
    #      if( session[:family]!=params[:id] && @password_protected > 0)
    #        #redirect_to :action => 'login', :id => params[:id], :url => "/my_familywebsite/home/#{params[:id]}"
    #        if(params[:facebook]=='true')
    #          session[:family]=@userid[0]['family_name']
    #        end
    #
    #        if(session[:family]=='' || session[:family]==nil)
    #          redirect_to :action => 'login', :id => params[:id], :url => request.request_uri, :familyname => "#{params[:id]}"
    #        else
    #          #redirect_to :controller => 'my_familywebsite', :action => 'home', :id => params[:id]
    #          redirect_to request.request_uri
    #        end
    #      end
    #    end

  end

  def correct_familyname
    render(:layout => false)
  end

  def login

    if(params[:familyname])
      @fname=params[:familyname]
    else
      @fname=params[:id]
    end


    @password_protected = HmmUser.count(:all, :conditions => "(family_name='#{@fname}' || alt_family_name='#{@fname}') and password_required='no'")
    if @password_protected > 0
      #session[:family]=params[:id]

      redirect_to :action => 'home', :id => @fname
    else

    end

  end



  def authenticate

    familyname=params[:family_name]
    @logged_in_family=HmmUser.count(:all, :conditions => "familywebsite_password='#{params[:familywebsite_password]}' and family_name='#{familyname}'")
    # self.logged_in_family = HmmUser.authenticate(params[:hmm_user][:family_name],params[:hmm_user][:familywebsite_password])
    #self.match = HmmUser.find_by_familywebsite_password("familywebsite_password")

    if @logged_in_family > 0
      session[:family]=params[:family_name]
      if(params[:url]=='' || params[:url]==nil)
        if(params[:page])
          redirect_to "/my_familywebsite/#{params[:page]}/#{params[:id]}?familyname=#{params[:family_name]}"
        else
          redirect_to "/#{params[:family_name]}"
        end
      else
        if(params[:page])
          redirect_to "/my_familywebsite/#{params[:page]}/#{params[:id]}?familyname=#{params[:family_name]}"
        else
          redirect_to params[:url]
        end

      end
    else

      #reset_session
      flash[:error1] = "Invalid login!!"
      redirect_to :action => 'login', :id => familyname, :familyname => familyname
    end
  end

  def authenticate_contestlogin
    #creating contest type session
    if params[:contest] == "video"
      @type = params[:contest]
      session[:contests_type] = "video"
    else params[:contest] == "photo"
      @type = params[:contest]
      session[:contests_type] = "image"
    end
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
        #  return "true"



        session[:alert] = "fnfalert"


        flag = 0
        hmm_payement_check = HmmUser.count(:all, :conditions => "id ='#{logged_in_hmm_user.id}' and account_expdate < CURDATE()")

        if (hmm_payement_check > 0)
          flag=1
        end

        if(session[:redirect_url]!=nil && session[:redirect_url]!='')
          url = session[:redirect_url]
          session[:redirect_url]=nil
          redirect_to url
        else
          if(params[:friend_id]==nil && params[:shareid]==nil )
            if(logged_in_hmm_user.v_e_mail=="Please update email")
              redirect_to "/customers/update_email"
            else
              if(flag==1 && request.request_uri != "/customers/upgrade/platinum_account?msg=payment_req")
                #session[:flag]=1
                redirect_to "/customers/upgrade/platinum_account?msg=payment_req"
              else
                #session[:flag]=''
                if(logged_in_hmm_user.family_name=='' || logged_in_hmm_user.family_name==nil)
                  @uuid =  HmmUser.find_by_sql(" select UUID() as u")
                  unnid = @uuid[0]['u']
                  hmmuser_family = HmmUser.find(logged_in_hmm_user.id)
                  hmmuser_family.family_name="#{logged_in_hmm_user.id}#{unnid}un#{logged_in_hmm_user.id}"
                  hmmuser_family.save
                  redirect_to :controller=>'manage_site',:action=>'contest_chapter',:id=>logged_in_hmm_user.family_name, :contest => params[:contest]
                else
                  if(logged_in_hmm_user.msg=='0')
                    redirect_to :controller=>'manage_site',:action=>'contest_chapter',:id=>logged_in_hmm_user.family_name, :contest => params[:contest]
                  else
                    redirect_to :controller=>'manage_site',:action=>'contest_chapter',:id=>logged_in_hmm_user.family_name, :contest => params[:contest]
                    #redirect_to "/#{logged_in_hmm_user.family_name}"
                  end


                end

              end
            end
          end

        end

      else
        reset_session
        flash[:error1] = "User is been blocked.. Contact Admin!!"
        redirect_to "/user_account/login"
      end

    else
      flash[:error] = "I'm sorry; either your username or password was incorrect."
      #log file entry
      logger.error("[Invalid Login]: by [User]:#{params[:hmm_user][:v_user_name]} at #{Time.now}")
      redirect_to :action => 'contest_login', :id=> params[:familyname], :contest => params[:contest]
      return "false"
    end


  end

  def logout

    if request.post?

      reset_session
      flash[:notice] = "You Have Been Successfully logged out."

    end
    #log file entry
    #logger.info("[User]: Logged Out at #{Time.now}")
    redirect_to :action => 'login', :id => params[:id],  :familyname => "#{params[:id]}"
  end

  def chapters_display
    uid =params[:id]

    @password_protected = HmmUser.count(:all, :conditions => "id='#{uid}' and password_required='yes'")

    if @password_protected > 0

      @e_access="and (tags.e_access='public' or tags.e_access='semiprivate')"
    else
      @e_access="and tags.e_access='public'"
    end


    #checking payment status for studio session chapter
    @userid = HmmUser.find(:all, :conditions => "id='#{uid}'")
    if @userid[0].studio_id!=0
      studio_website_version=HmmStudio.find(:first,:select=>"family_website_version",:conditions=>"id=#{@userid[0].studio_id}")
      @family_website_version=studio_website_version.family_website_version
    else
      @family_website_version=2
    end
    @flag = 0

    @hmm_user_check =  HmmUser.count(:all, :conditions =>" account_expdate <= current_date and id='#{params[:id]}'")
    if @hmm_user_check > 0

      @flag = 1
    end
    if is_userlogged_in?
      @loggedin = "yes"
    else
      @loggedin = "no"
    end
    @results = Tag.find(:all,:select => "tags.*,count(sub_chapters.store_id) as length", :joins =>" LEFT JOIN sub_chapters
ON tags.id=sub_chapters.tagid", :conditions => "tags.uid=#{uid}  and tags.status='active' and tags.v_tagname!='HOLDING FOLDER' and tags.default_tag='yes' #{@e_access}",:group => 'tags.id', :order => "tags.order_num ASC" )
    #@results = Tag.find(:all)

    @pathurl = ContentPath.find(:first, :select=>"proxyname", :conditions => "status='active'")
    @user = HmmUser.find(:first,:select=>"family_name",:conditions =>"id=#{uid}")
    logger.info(@results.inspect)
    render :layout => false
    #render :amf => @results
  end



  def subchapters

    redirect_to "/familywebsite/subchapters/#{params[:familyname]}?chapter_id=#{params[:id]}?familyname=#{params[:familyname]}"

    #    @symb='&'
    #      @family_name_tag = params[:familyname];
    #      @sub_chapter = SubChapter.find(:all, :conditions => "tagid='#{params[:id]}'")
    #      @userid = HmmUser.find(:all, :conditions => "id='#{@sub_chapter[0].uid}'")
    #      #@userid = HmmUser.find(:all, :conditions => "family_name='rakeshfamily'")
    #      @uid = @userid[0]['id']
    #    if(params[:facebook]=='true')
    #      session[:family]=params[:familyname]
    #    end
    #    contentservers = ContentPath.find(:all)
    #    @proxyurls = nil
    #    for server in contentservers
    #      if(@proxyurls == nil)
    #        @proxyurls = server['content_path']
    #      else
    #        @proxyurls = @proxyurls +','+server['content_path']
    #      end
    #    end
    #    @tagdet=Tag.find(params[:id])
    #    @sub_chapter = SubChapter.find(:all, :conditions => "tagid='#{params[:id]}'", :order => "order_num ASC")
    #    @userid = HmmUser.find(:all, :conditions => "id='#{@sub_chapter[0].uid}'")
    #    #@userid = HmmUser.find(:all, :conditions => "family_name='rakeshfamily'")
    #    @uid = @userid[0]['id']
    #    imageName  = @tagdet.v_chapimage
    #        imageName.slice!(-3..-1)
    #    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{@userid[0][:family_name]}' and password_required='yes'")
    #    @imgpath="<img src=\" #{@tagdet.img_url}/user_content/photos/flex_icon/#{imageName}jpg \" > "
    #                @imgp1 = "#{@tagdet.img_url}/user_content/photos/flex_icon/#{imageName}jpg"
    #                @videop1="http://holdmymemories.com/Chapter1.swf?serverUrl=http://holdmymemories.com/my_familywebsite/coverFlowImages/#{@tagdet.id}&navigateToUrl=http://holdmymemories.com/my_familywebsite/gallery/&buttonsVisible=false&proxyurls=#{@proxyurls}&familyname=#{params[:familyname]}"
    #                @filetype="video"
    #    if(session[:family].nil? && @password_protected > 0 )
    #      redirect_to :action => 'login', :id => params[:id], :url => request.request_uri, :familyname => @userid[0][:family_name], :page => 'subchapters'
    #    end
    #
    #
    #
    #    @chapterid = "#{params[:id]}"
    #
    #    if( @password_protected > 0)
    #      @e_acess="and (e_access='public' or e_access='semiprivate')"
    #    else
    #      @e_acess="and e_access='public'"
    #    end
    #
    #    @item = SubChapter.count(:all,:conditions =>"tagid=#{params[:id]} and status='active' #{@e_acess}" )
    #
    #    if(@item==1)
    #      @subchapter=SubChapter.find(:all,:conditions =>"tagid=#{params[:id]} and status='active' #{@e_acess}", :order => "order_num ASC" )
    #      redirect_to :action => 'gallery', :id => "#{@subchapter[0]['id']}", :familyname => "#{params[:familyname]}"
    #    end
    #
    #    @chapter_journal = ChapterJournal.find(:all, :conditions => "tag_id=#{params[:id]}", :order=>"id DESC")
    #    @chap_cnt = ChapterJournal.count(:all, :conditions => "tag_id=#{params[:id]}")


  end

  def coverFlowImages

    @sub_chapter = SubChapter.find(:all, :conditions => "tagid='#{params[:id]}'", :order => "order_num ASC")
    @userid = HmmUser.find(:all, :conditions => "id='#{@sub_chapter[0].uid}'")
    #@userid = HmmUser.find(:all, :conditions => "family_name='rakeshfamily'")
    @uid = @userid[0]['id']
    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{@userid[0][:family_name]}' and password_required='yes'")

    if( @password_protected > 0)
      @e_acess="and (e_access='public' or e_access='semiprivate')"
    else
      @e_acess="and e_access='public'"
    end

    @subchapters = SubChapter.find(:all, :conditions=>"tagid=#{params[:id]} and status='active' #{@e_acess} ", :order => "order_num ASC")

    @chapterid = params[:id]
    render :layout => false
  end

  def biographies
    redirect_to "/familywebsite/biography/#{params[:id]}"

    #    if(params[:facebook]=='true')
    #      session[:family]=params[:id]
    #    end
    #    @block_check = HmmUser.count(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}') and e_user_status='blocked'")
    #    @block_check = HmmUser.count(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}') and e_user_status='blocked'")
    #    hmm_terms_check = HmmUser.count(:all, :conditions => "family_name ='#{params[:id]}' and terms_checked ='false'")
    #    if(session[:employe]==nil && hmm_terms_check > 0 )
    #        flash[:terms] = 'terms'
    #        if(session[:hmm_user])
    #          redirect_to "/user_account/update_terms/"
    #        else
    #          redirect_to "/manage_site/mysite_login/#{params[:id]}"
    #        end
    #    elsif(@block_check > 0)
    #      redirect_to :controller => 'my_familywebsite', :action => 'blocked', :id => params[:id]
    #
    #    else
    #      @password_protected = HmmUser.count(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}') and password_required='yes'")
    #      if(session[:family].nil? && @password_protected > 0 )
    #        redirect_to :action => 'login', :id => params[:id], :url => request.request_uri, :familyname => "#{params[:id]}"
    #      end
    #
    #      @userid = HmmUser.find(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')")
    #      @uid = @userid[0]['id']
    #      @hmmuserid = HmmUser.find(:all, :conditions => "id='#{@uid}'")
    #      @biographies = FamilyMember.find(:all, :conditions => "uid='#{@uid}'", :order => 'id')
    #      #    else if @password_protected > 0
    #      #      @userid = HmmUser. find(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')")
    #      #      @uid = @userid[0]['id']
    #      #      @hmmuserid = HmmUser.find(:all, :conditions => "id='#{@uid}'")
    #      #      @biographies = FamilyMember.find(:all, :conditions => "uid='#{@uid}'")
    #
    #    end
  end

  def calender
    @password_protected = HmmUser.count(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}') and password_required='yes'")


    if(session[:family].nil? && @password_protected > 0 )
      redirect_to :action => 'login', :id => params[:id], :url => request.request_uri
    end


  end

  def messageboard
    if(params[:facebook]=='true')
      session[:family]=params[:id]
    end

    @block_check = HmmUser.count(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}') and e_user_status='blocked'")
    hmm_terms_check = HmmUser.count(:all, :conditions => "family_name ='#{params[:id]}' and terms_checked ='false'")
    if(session[:employe]==nil && hmm_terms_check > 0 )
      flash[:terms] = 'terms'
      if(session[:hmm_user])
        redirect_to "/user_account/update_terms/"
      else
        redirect_to "/manage_site/mysite_login/#{params[:id]}"
      end
    elsif(@block_check > 0)
      redirect_to :controller => 'my_familywebsite', :action => 'blocked', :id => params[:id]
    else
      if(params[:sucess].nil?)
      else
        flash[:message_board] = "<font color='black' size=3>The Message is succefully saved on the message board..</font>"
      end
      @password_protected = HmmUser.count(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}') and password_required='yes'")

      if(session[:family].nil? && @password_protected > 0 )
        redirect_to :action => 'login', :id => params[:id], :url => request.request_uri,  :familyname => "#{params[:id]}"
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


    @galleries = Galleries.find(:all, :conditions=>"subchapter_id=#{params[:id]} and status='active' #{@e_acess} ", :order => "order_num ASC")
    @subchapterid = params[:id]
    render :layout => false
  end

  def gallery_fisheye
    redirect_to "/familywebsite/gallery_contents/#{params[:familyname]}?gallery_id=#{params[:id]}?familyname=#{params[:familyname]}"


    #    @symb='&'
    #          @family_name_tag = params[:familyname];
    #          @gallery=Galleries.find(params[:id])
    #
    #          @sub_chapter = SubChapter.find(@gallery.subchapter_id)
    #
    #          @userid = HmmUser.find(:all, :conditions => "id=#{@sub_chapter.uid}")
    #          #@userid = HmmUser.find(:all, :conditions => "family_name='rakeshfamily'")
    #          @uid = @userid[0]['id']
    #    if(params[:facebook]=='true')
    #      session[:family]=params[:familyname]
    #    end
    #    if(session[:hmm_user])
    #      hmmuserdet=HmmUser.find(:all,:conditions=> "family_name='#{params[:familyname]}'")
    #      if(session[:hmm_user]==hmmuserdet[0].id)
    #        @buttonVisibility = "true"
    #      else
    #        @buttonVisibility = "false"
    #      end
    #    else
    #      @buttonVisibility = "false"
    #    end
    #    contentservers = ContentPath.find(:all)
    #    @proxyurls = nil
    #    for server in contentservers
    #      if(@proxyurls == nil)
    #        @proxyurls = server['content_path']
    #      else
    #        @proxyurls = @proxyurls +','+server['content_path']
    #      end
    #    end
    #    @gallery=Galleries.find(params[:id])
    #    @sub_chapter = SubChapter.find(@gallery.subchapter_id)
    #    @userid = HmmUser.find(:all, :conditions => "id=#{@sub_chapter.uid}")
    #    @uid = @userid[0]['id']
    #    @family_name=@userid[0]['family_name']
    #    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{@family_name}' and password_required='yes'")
    #
    #    #code for journal
    #    @gallery_journal = GalleryJournal.find(:all, :conditions => "galerry_id=#{params[:id]}", :order=>"id DESC")
    #
    #    if(session[:family].nil? && @password_protected > 0 )
    #      redirect_to :action => 'login', :id => params[:id], :url => request.request_uri, :familyname => @family_name, :page => 'gallery_fisheye'
    #    end
    #
    #    @gallery  = Galleries.find(:all, :conditions => "id=#{params[:id]}", :order => "order_num ASC")
    #    @galleryUrl = ""
    #    if(@gallery[0].e_gallery_type == "video")
    #      logger.info("Gallery Type Video")
    #      @swfName = "CoverFlowVideo"
    #      @swfName1 = "CoverFlowVideo"
    #      @galleryUrl = "/evelethsfamily/videoCoverflow/"+params[:id]
    #    elsif(@gallery[0].e_gallery_type == "image")
    #      logger.info("Gallery Type Image")
    #      @swfName = "PhotoGallery"
    #      @swfName1 = "Chapter1"
    #      @galleryUrl = "/evelethsfamily/showGallery/"+params[:id]
    #    elsif(@gallery[0].e_gallery_type == "audio")
    #      logger.info("Gallery Type Audio")
    #      @swfName = "CoverFlowAudio"
    #      @swfName1 = "CoverFlowAudio"
    #      @galleryUrl = "/evelethsfamily/showAudioGallery/"+params[:id]
    #    end
    #    @subchaptercheck=SubChapter.find(@gallery[0].subchapter_id)
    #    @tagcheck=Tag.find(@subchaptercheck.tagid)
    #    if(@tagcheck.tag_type=='chapter')
    #      img=@gallery[0].v_gallery_image
    #    else
    #      img=@tagcheck.v_chapimage
    #    end
    #    imageName  = img
    #        imageName.slice!(-3..-1)
    #    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{params[:familyname]}' and password_required='yes'")
    #    @imgpath="<img src=\" #{@gallery[0].img_url}/user_content/photos/flex_icon/#{imageName}jpg \" width=\"130\" > "
    #                @imgp1 = "#{@gallery[0].img_url}/user_content/photos/flex_icon/#{imageName}jpg"
    #                @videop1="http://holdmymemories.com/#{@swfName1}.swf?serverUrl=http://holdmymemories.com#{@galleryUrl}&buttonsVisible=false&proxyurls=#{@proxyurls}"
    #                @filetype="video"

  end


  def simple_slideshow
    if(params[:facebook]=='true')
      session[:family]=params[:familyname]
    end
    if(session[:hmm_user])
      hmmuserdet=HmmUser.find(:all,:conditions=> "family_name='#{params[:familyname]}'")
      if(session[:hmm_user]==hmmuserdet[0].id)
        @buttonVisibility = "true"
      else
        @buttonVisibility = "false"
      end
    else
      @buttonVisibility = "false"
    end
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

    #code for journal
    @gallery_journal = GalleryJournal.find(:all, :conditions => "galerry_id=#{params[:id]}", :order=>"id DESC")

    if(session[:family].nil? && @password_protected > 0 )
      redirect_to :action => 'login', :id => params[:id], :url => request.request_uri, :familyname => @family_name, :page => 'gallery_fisheye'
    end

    @gallery  = Galleries.find(:all, :conditions => "id=#{params[:id]}", :order => "order_num ASC")
    @galleryUrl = ""
    if(@gallery[0].e_gallery_type == "image")
      @swfName = "SimpleSlideShow"
      @galleryUrl = "/evelethsfamily/showGallery/"+params[:id]
    end



  end


  def gallery
    redirect_to "/familywebsite/galleries/#{params[:familyname]}?subchapter_id=#{params[:id]}?familyname=#{params[:familyname]}"
    #    @symb='&'
    #        @family_name_tag = params[:familyname];
    #        @sub_chapter = SubChapter.find(params[:id])
    #        @userid = HmmUser.find(:all, :conditions => "id='#{@sub_chapter.uid}'")
    #        #@userid = HmmUser.find(:all, :conditions => "family_name='rakeshfamily'")
    #        @uid = @userid[0]['id']
    #    if(params[:facebook]=='true')
    #      session[:family]=params[:familyname]
    #    end
    #    #    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{@familyname_gal}' and password_required='no'")
    #    #    if session[:family]!=@familyname_gal
    #    if(session[:hmm_user])
    #      hmmuserdet=HmmUser.find(:all,:conditions=> "family_name='#{params[:familyname]}'")
    #      if(session[:hmm_user]==hmmuserdet[0].id)
    #        @buttonVisibility = "true"
    #      else
    #        @buttonVisibility = "false"
    #      end
    #    end
    #    contentservers = ContentPath.find(:all)
    #    @proxyurls = nil
    #    for server in contentservers
    #      if(@proxyurls == nil)
    #        @proxyurls = server['content_path']
    #      else
    #        @proxyurls = @proxyurls +','+server['content_path']
    #      end
    #    end
    #
    #    @sub_chapter_journal = SubChapJournal.find(:all, :conditions => "sub_chap_id=#{params[:id]}", :order=>"id DESC")
    #
    #    @sub_chapter=SubChapter.find(params[:id])
    #    @uid= @sub_chapter[:uid]
    #    @password_protected_user = HmmUser.find(@uid)
    #    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{@password_protected_user[:family_name]}' and password_required='yes'")
    #
    #    if(session[:family].nil? && @password_protected > 0 )
    #      redirect_to :action => 'login', :id => params[:id], :url => request.request_uri, :familyname => @password_protected_user[:family_name], :page => 'gallery'
    #    end
    #
    #    @subchapterid = params[:id]
    #
    #    @galleriescount = Galleries.count(:all, :conditions => "subchapter_id='#{params[:id]}'  and status='active' and e_gallery_acess='public' ")
    #    if(@galleriescount==1)
    #      @galleries = Galleries.find(:all,:conditions => "subchapter_id='#{params[:id]}' and status='active' and e_gallery_acess='public' ", :order => "id desc")
    #      redirect_to :action => 'gallery_fisheye', :id => "#{@galleries[0]['id']}", :familyname=> "#{params[:familyname]}"
    #
    #
    #
    #    end

  end

  def videoCoverflow
    @contents = UserContent.find(:all, :conditions => "gallery_id=#{params[:id]} and status='active' and e_access='public'", :order => 'order_num ASC')
    render :layout => false
  end

  def showGallery
    @contents = UserContent.find(:all, :conditions => "gallery_id=#{params[:id]} and status='active' and e_access='public'",:order =>'order_num ASC')
    render :layout => false
  end

  def showAudioGallery
    @contents = UserContent.find(:all, :conditions => "gallery_id=#{params[:id]} and status='active' and e_access='public'",:order =>'order_num ASC')
    render :layout => false
  end

  def journals
    redirect_to "/blog/list/#{params[:id]}"
    #    if(params[:order])
    #      order=params[:order]
    #    else
    #      order="desc"
    #    end
    #    if(params[:facebook]=='true')
    #      session[:family]=params[:id]
    #    end
    #    @block_check = HmmUser.count(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}') and e_user_status='blocked'")
    #    hmm_terms_check = HmmUser.count(:all, :conditions => "family_name ='#{params[:id]}' and terms_checked ='false'")
    #    if(session[:employe]==nil && hmm_terms_check > 0 )
    #        flash[:terms] = 'terms'
    #        if(session[:hmm_user])
    #          redirect_to "/user_account/update_terms/"
    #        else
    #          redirect_to "/manage_site/mysite_login/#{params[:id]}"
    #        end
    #    elsif(@block_check > 0)
    #
    #      redirect_to :controller => 'my_familywebsite', :action => 'blocked', :id => params[:id]
    #    else
    #      @familyname=params[:id]
    #      @password_protected = HmmUser.count(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}') and password_required='yes'")
    #      if(session[:family].nil? && @password_protected > 0 )
    #        redirect_to :action => 'login', :id => params[:id], :url => request.request_uri,  :familyname => "#{params[:id]}"
    #      end
    #
    #      if( @password_protected > 0)
    #
    #        cond1="and (t.e_access='public' or t.e_access='semiprivate')"
    #
    #        cond2="and (s.e_access='public' or s.e_access='semiprivate')"
    #
    #        cond3="and (g.e_gallery_acess='public' or g.e_gallery_acess='semiprivate')"
    #
    #        cond4="and (u.e_access='public' or u.e_access='semiprivate')"
    #      else
    #
    #        cond1="and t.e_access='public'"
    #
    #        cond2="and s.e_access='public'"
    #
    #        cond3="and g.e_gallery_acess='public'"
    #
    #        cond4="and u.e_access='public'"
    #
    #
    #      end
    #
    #      userid = HmmUser.find(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')")
    #      uid1 = userid[0]['id']
    #
    #      if(params[:category]=="" ||  params[:category]==nil)
    #
    #
    #         chapter=""
    #        subchapter=""
    #        gallery= ""
    #        moment=""
    #        image=""
    #        video=""
    #        audio=""
    #        text=""
    #      else
    #       chapter=" and t.id=0"
    #        subchapter=" and s.id=0"
    #        gallery= " and g.id=0"
    #        moment="  and d.id=0"
    #        image=" and e_filetype = 'image'"
    #        video=" and e_filetype = 'video'"
    #        audio=" and e_filetype = 'audio'"
    #        text=" and txt.id=0"
    #      end
    #        if(params[:category] == "chapter")
    #          chapter=""
    #        elsif(params[:category] == "subchapter")
    #          subchapter=""
    #        elsif(params[:category] == "gallery")
    #          gallery=""
    #        elsif(params[:category] == "image")
    #          image="and e_filetype = 'image'"
    #          video=""
    #          audio=""
    #          moment=""
    #        elsif(params[:category] == "video")
    #          video="and e_filetype = 'video'"
    #          image=""
    #          audio=""
    #          moment=""
    #        elsif(params[:category] == "audio")
    #          image=""
    #          video=""
    #          audio=" and e_filetype = 'audio'"
    #          moment=""
    #        elsif(params[:category] == "text")
    #          text=""
    #
    #        end
    #      tagcout = Tag.find_by_sql(" select
    #       count(*) as cnt
    #         from chapter_journals as a,tags as t
    #         where
    #         a.tag_id=t.id
    #         and
    #         t.uid=#{uid1} and t.status='active' #{cond1} #{chapter}")
    #      subcount = SubChapter.find_by_sql("
    # select
    #        count(*) as cnt
    #        from
    #        sub_chap_journals  as b,
    #        sub_chapters as s
    #        where
    #        s.uid=#{uid1}
    #        and
    #        b.sub_chap_id=s.id  and s.status='active' #{cond2}  #{subchapter}")
    #
    #      galcount = Galleries.find_by_sql("select
    #        count(*) as cnt
    #        from
    #        gallery_journals   as c,
    #        galleries as g,
    #        sub_chapters as s1
    #        where
    #        s1.uid=#{uid1}
    #        and
    #        c.galerry_id=g.id
    #        and g.subchapter_id=s1.id and g.status='active' #{cond3}  #{gallery}")
    #
    #      usercontentcount = UserContent.find_by_sql("
    #  select
    #       count(*) as cnt
    #        from
    #        journals_photos   as d,
    #        user_contents as u
    #        where
    #        d.user_content_id=u.id and u.uid=#{uid1}
    #        and u.status='active' #{cond4}  #{moment} #{image} #{video} #{audio}
    #
    #        ")
    #      txtcount=UserContent.find_by_sql("
    #  select
    #       count(*) as cnt
    #        from
    #        text_journals   as txt
    #        where
    #        txt.uid=#{uid1}
    #        #{text}
    #
    #        ")
    #      txtcnt=Integer(txtcount[0].cnt)
    #      galcnt=Integer(galcount[0].cnt)
    #      tagcnt=Integer(tagcout[0].cnt)
    #      subcnt=Integer(subcount[0].cnt)
    #      usercontentcnt=Integer(usercontentcount[0].cnt)
    #
    #      @total=tagcnt+subcnt+galcnt+usercontentcnt+txtcnt
    #
    #      @numberofpagesres=@total/10
    #
    #      @numberofpages=@numberofpagesres.round()
    #
    #      if(params[:page]==nil)
    #        x=0
    #        y=10
    #        @page=0
    #        @nextpage=1
    #        if(@total<10)
    #
    #          @nonext=1
    #        end
    #      else
    #        x=10*Integer(params[:page])
    #        y=10
    #        @page=Integer(params[:page])
    #        @nextpage=@page+1
    #        @previouspage=@page-1
    #        if(@page==@numberofpages)
    #          @nonext=1
    #        end
    #
    #      end
    #
    #
    #      @tagid=ChapterJournal.find_by_sql("
    #   (select
    #        t.uid as uid,
    #         a.id as id,
    #         a.tag_id as master_id,
    #         a.v_tag_title as title,
    #         a.v_tag_journal as descr,
    #         a.jtype as jtype,
    #         a.d_created_at as d_created_at,
    #         a.d_updated_at as d_updated_at,
    #         t.img_url as img_url
    #         from chapter_journals as a,tags as t
    #         where
    #         a.tag_id=t.id
    #         and
    #         t.uid=#{uid1}
    #         and
    #         t.status='active' #{cond1}   #{chapter}
    #     )
    #     union
    #     (select
    #        s.uid as uid,
    #        b.id as id,
    #        b.sub_chap_id as master_id,
    #        b.journal_title as title,
    #        b.subchap_journal as descr,
    #        b.jtype as jtype,
    #        b.created_on as d_created_at,
    #        b.updated_on as d_updated_at,
    #        s.img_url as img_url
    #        from
    #        sub_chap_journals  as b,
    #        sub_chapters as s
    #        where
    #        s.uid=#{uid1}
    #        and
    #        b.sub_chap_id=s.id and s.status='active' #{cond2}   #{subchapter}
    #     )
    #     union
    #     (select
    #        s1.uid as uid,
    #        c.id as id,
    #        c.galerry_id as master_id,
    #        c.v_title as title,
    #        c.v_journal as descr,
    #        c.jtype as jtype,
    #        c.d_created_on as d_created_at,
    #        c.d_updated_on as d_updated_on,
    #        g.img_url as img_url
    #        from
    #        gallery_journals   as c,
    #        galleries as g,
    #        sub_chapters as s1
    #        where
    #        s1.uid=#{uid1}
    #        and
    #        c.galerry_id=g.id
    #        and g.subchapter_id=s1.id  and g.status='active' #{cond3} #{gallery})
    #     union
    #    (select
    #        u.uid as uid,
    #        d.id as id,
    #        d.user_content_id as master_id,
    #        d.v_title as title,
    #        d.v_image_comment as descr,
    #        d.jtype as jtype,
    #        d.date_added as d_created_at,
    #        d.date_added  as d_updated_on,
    #        u.img_url as img_url
    #        from
    #        journals_photos   as d,
    #        user_contents as u
    #        where
    #        d.user_content_id=u.id and u.uid=#{uid1} and u.status='active' #{cond4}   #{moment} #{image} #{video} #{audio}
    #     )
    #union
    #(select
    #        txt.uid as uid,
    #        txt.id as id,
    #        txt.uid as master_id,
    #        txt.journal_title as title,
    #        txt.description as descr,
    #        txt.jtype as jtype,
    #        txt.d_created_at as d_created_at,
    #        txt.d_updated_at  as d_updated_on,
    #        txt.uid as img_url
    #        from
    #        text_journals    as txt
    #
    #        where
    #        txt.uid='#{uid1}' #{text}
    #     )
    #     order by d_created_at #{order} limit #{x}, #{y} ")
    #
    #      #@tagid = ChapterJournal.paginating_sql_find(@cnt, sql, {:page_size => 10, :current => params[:page]})
    #      # @tagid1, @tagid = paginate_by_sql ChapterJournal, sql, 20
    #
    #
    #
    #
    #
    #      if(session[:journal]=='journal')
    #        render :layout => true
    #        session[:journal] = nil
    #      else if(params[:page]==nil)
    #
    #        else
    #          render :layout => false
    #        end
    #
    #      end
    #    end




  end

  def moment_view

  end


  def contactus
    redirect_to "/familywebsite/emailus/#{params[:id]}"
    #    if(params[:facebook]=='true')
    #      session[:family]=params[:id]
    #    end
    #    @block_check = HmmUser.count(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}') and e_user_status='blocked'")
    #    hmm_terms_check = HmmUser.count(:all, :conditions => "family_name ='#{params[:id]}' and terms_checked ='false'")
    #    if(session[:employe]==nil && hmm_terms_check > 0 )
    #        flash[:terms] = 'terms'
    #        if(session[:hmm_user])
    #          redirect_to "/user_account/update_terms/"
    #        else
    #          redirect_to "/manage_site/mysite_login/#{params[:id]}"
    #        end
    #    elsif(@block_check > 0)
    #      redirect_to :controller => 'my_familywebsite', :action => 'blocked', :id => params[:id]
    #    else
    #      @password_protected = HmmUser.count(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}') and password_required='yes'")
    #      if(session[:family].nil? && @password_protected > 0 )
    #        redirect_to :action => 'login', :id => params[:id], :url => request.request_uri,  :familyname => "#{params[:id]}"
    #      end
    #
    #      if(params[:contact_u])
    #        #if simple_captcha_valid?
    #        @contact_u = ContactU.new(params[:contact_u])
    #        @contact_u.subject = "HoldMyMemories.com - #{@contact_u.first_name} sent you a message on HoldMyMemories.com... "
    #        if @contact_u.save
    #          Postoffice.deliver_contactUsreportmysite(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email, params[:website_email])
    #          $notice_contact
    #          flash[:notice_contact] = 'Thank You, Your Email has Been Sent to the Owner Of this Website.'
    #          render :action => 'contactus_success', :id => params[:id]
    #        end
    #        # else
    #        # flash[:error] = 'Please enter the correct code!'
    #        #end
    #      end
    #    end
  end

  def addcontact

    @contact_u = ContactU.new(params[:contact_u])
    @contact_u.subject = "HoldMyMemories.com - #{@contact_u.first_name} has sent you an email from HoldMyMemories.com... "
    if @contact_u.save
      Postoffice.deliver_contactUsreportmysite(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,params[:website_email])
      $notice_contact
      flash[:notice_contact] = 'Thank You, Your Email has Been Sent to the Owner of this Website.'
      render :action => 'contactus_success', :id => params[:id]
    end
  end

  def moment_page
    redirect_to "/familywebsite/moments/#{params[:familyname]}?moment_id=#{params[:id]}?familyname=#{params[:familyname]}"

    #    @symb='&'
    #    @family_name_tag = params[:familyname]
    #    @usercontent=UserContent.find(params[:id])
    #    @userid = HmmUser.find(:all, :conditions => "id='#{@usercontent.uid}'")
    #    #@userid = HmmUser.find(:all, :conditions => "family_name='rakeshfamily'")
    #    @uid = @userid[0]['id']
    #    if(params[:facebook]=='true')
    #      session[:family]=params[:familyname]
    #    end
    #    @get_content_url=ContentPath.find(:all, :conditions => "status='active'")
    #    @serverurl=@get_content_url[0]['content_path']
    #    @servername=@get_content_url[0]['proxyname']
    #    contentservers = ContentPath.find(:all)
    #    @proxyurls = nil
    #    for server in contentservers
    #      if(@proxyurls == nil)
    #        @proxyurls = server['content_path']
    #      else
    #        @proxyurls = @proxyurls +','+server['content_path']
    #      end
    #    end
    #    @usercontent=UserContent.find(params[:id])
    #
    #
    #    @userid = HmmUser.find(:all, :conditions => "id='#{@usercontent.uid}'")
    #
    #    @uid = @userid[0]['id']
    #    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{@userid[0][:family_name]}' and password_required='yes'")
    #
    #    if(session[:family].nil? && @password_protected > 0 )
    #
    #      redirect_to :action => 'login', :familyname => "#{params[:familyname]}", :id => params[:id], :page => 'moment_page'
    #    else
    #
    #
    #      session[:usercontent_id]=params[:id]
    #      @usercontent = UserContent.find(params[:id])
    #      @gallery_id=@usercontent.gallery_id
    #      @gallery_type=@usercontent.e_filetype
    #      if(params[:page]==nil || params[:hmm]==nil)
    #
    #        @counts =  UserContent.count(:all, :conditions => " gallery_id='#{@usercontent.gallery_id}' and status='active'  and  e_access='public'  ",:order =>'order_num ASC')
    #        @allrecords =  UserContent.find(:all, :conditions => " gallery_id='#{@usercontent.gallery_id}' and status='active'  and  e_access='public' " ,:order =>'order_num ASC')
    #        page=0
    #        for check in @allrecords
    #          page=page+1
    #          #puts check.id
    #
    #          if(check.id==@usercontent.id)
    #            puts params[:id]
    #            puts check.id
    #            @nextpage=page
    #            redirect_to :action => :moment_page, :id=> params[:id], :page =>@nextpage, :familyname => "#{params[:familyname]}",:hmm=>"true"
    #
    #          else
    #
    #          end
    #        end
    #      else
    #        @user_content = UserContent.paginate :conditions => "gallery_id='#{@usercontent.gallery_id}' and status='active' and  e_access='public' ",:order =>'order_num ASC', :per_page => 1, :page => params[:page]
    #        if(@user_content[0].e_filetype =="image")
    #          @imgpath="<img src=\" #{@user_content[0].img_url}/user_content/photos/journal_thumb/#{@user_content[0].v_filename} \" > "
    #          @imgp1="#{@user_content[0].img_url}/user_content/photos/journal_thumb/#{@user_content[0].v_filename}"
    #          @videop1=""
    #          @filetype="image"
    #        else
    #          if(@user_content[0].e_filetype =="video")
    #            @imgpath="<img src=\" #{@userid[0].img_url}/hmmuser/familyphotos/thumbs/#{@userid[0].family_pic} \" >"
    #            @imgp1="#{@userid[0].img_url}/hmmuser/familyphotos/thumbs/#{@userid[0].family_pic}"
    #            @videop1="http://holdmymemories.com/BlogVideoPlayer.swf?videopath=#{@user_content[0].img_url}/user_content/videos/#{@user_content[0].v_filename}.flv"
    #            @filetype=""
    #           @filetype="video"
    #          else
    #            if(@user_content[0].e_filetype =="swf")
    #                @imgpath="<img src=\" #{@user_content[0].img_url}/user_content/videos/thumbnails/#{@user_content[0].v_filename}.jpg \" > "
    #                @imgp1 = "#{@user_content[0].img_url}/user_content/videos/thumbnails/#{@user_content[0].v_filename}.jpg"
    #                @videop1="http://holdmymemories.com/slideShow.swf?xmlfile=http://holdmymemories.com/slideshow/get_slideshow_moment_list/#{@user_content[0].id}.xml"
    #                @filetype="video"
    #            end
    #          end
    #        end
    #      end
    #      @norecords=""
    #
    #    end
  end

  def moment_page_detail
    @symb='&'
    @family_name_tag = params[:familyname]
    @usercontent=UserContent.find(params[:id])
    @userid = HmmUser.find(:all, :conditions => "id='#{@usercontent.uid}'")
    #@userid = HmmUser.find(:all, :conditions => "family_name='rakeshfamily'")
    @uid = @userid[0]['id']
    if(params[:facebook]=='true')
      session[:family]=params[:familyname]
    end
    @get_content_url=ContentPath.find(:all, :conditions => "status='active'")
    @serverurl=@get_content_url[0]['content_path']
    @servername=@get_content_url[0]['proxyname']
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

    @uid = @userid[0]['id']
    @password_protected = HmmUser.count(:all, :conditions => "family_name='#{@userid[0][:family_name]}' and password_required='yes'")

    if(session[:family].nil? && @password_protected > 0 )

      redirect_to :action => 'login', :familyname => "#{params[:familyname]}", :id => params[:id], :page => 'moment_page'
    else


      session[:usercontent_id]=params[:id]
      @usercontent = UserContent.find(params[:id])
      @gallery_id=@usercontent.gallery_id
      @gallery_type=@usercontent.e_filetype
      if(params[:page]==nil || params[:hmm]==nil)

        @counts =  UserContent.count(:all, :conditions => " gallery_id='#{@usercontent.gallery_id}' and status='active'  and  e_access='public'  ",:order =>'order_num ASC')
        @allrecords =  UserContent.find(:all, :conditions => " gallery_id='#{@usercontent.gallery_id}' and status='active'  and  e_access='public' " ,:order =>'order_num ASC')
        page=0
        for check in @allrecords
          page=page+1
          #puts check.id

          if(check.id==@usercontent.id)
            puts params[:id]
            puts check.id
            @nextpage=page
            redirect_to :action => :moment_page, :id=> params[:id], :page =>@nextpage, :familyname => "#{params[:familyname]}",:hmm=>"true"

          else

          end
        end
      else
        @user_content = UserContent.paginate :conditions => "gallery_id='#{@usercontent.gallery_id}' and status='active' and  e_access='public' ",:order =>'order_num ASC', :per_page => 1, :page => params[:page]
        if(@user_content[0].e_filetype =="image")
          @imgpath="<img src=\" #{@user_content[0].img_url}/user_content/photos/journal_thumb/#{@user_content[0].v_filename} \" > "
          @imgp1="#{@user_content[0].img_url}/user_content/photos/journal_thumb/#{@user_content[0].v_filename}"
          @videop1=""
          @filetype="image"
        else
          if(@user_content[0].e_filetype =="video")
            @imgpath="<img src=\" #{@user_content[0].img_url}/user_content/videos/thumbnails/#{@user_content[0].v_filename}.jpg \" > "
            #@imgpath="<img src= \"/images/logofamily.jpg \">"
            @imgp1 = "#{@user_content[0].img_url}/user_content/videos/thumbnails/#{@user_content[0].v_filename}.jpg"


            @videop1="http://holdmymemories.com/BlogVideoPlayer.swf?videopath=#{@user_content[0].img_url}/user_content/videos/#{@user_content[0].v_filename}.flv"
            @filetype="video"
          else
            if(@user_content[0].e_filetype =="swf")
              @imgpath="<img src=\" #{@user_content[0].img_url}/user_content/videos/thumbnails/#{@user_content[0].v_filename}.jpg \" > "
              @imgp1 = "#{@user_content[0].img_url}/user_content/videos/thumbnails/#{@user_content[0].v_filename}.jpg"
              @videop1="http://holdmymemories.com/slideShow.swf?xmlfile=http://holdmymemories.com/slideshow/get_slideshow_moment_list/#{@user_content[0].id}.xml"
              @filetype="video"
            end
          end
        end
      end
      @norecords=""

    end
  end

  def  photo_journal


    session[:usercontent_id]=params[:id]
    @usercontent = UserContent.find(params[:id])

    if(params[:page]==nil)

      @counts =  UserContent.count(:all, :conditions => " gallery_id='#{@usercontent.gallery_id}' and status='active'  and  e_access='public'  ",:order =>'id desc')
      @allrecords =  UserContent.find(:all, :conditions => " gallery_id='#{@usercontent.gallery_id}' and status='active'  and  e_access='public' " ,:order =>'id desc')
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

      @user_content_pages, @user_content = paginate :user_contents, :conditions => "gallery_id='#{@usercontent.gallery_id}' and status='active'  and  e_access='public'  ",:order =>'id desc', :per_page => 1
    end
    @norecords=""
  end

  def share

    if params[:id]
      fid=params[:id]
    else
      fid=params[:familyname]
    end
    @block_check = HmmUser.count(:all, :conditions => "(family_name='#{fid}' || alt_family_name='#{fid}') and e_user_status='blocked'")
    if(@block_check > 0)
      redirect_to :controller => 'my_familywebsite', :action => 'blocked', :id => params[:id]
    else

      @userid = HmmUser.find(:all, :conditions => "family_name='#{fid}' || alt_family_name='#{fid}'")
      @uid = @userid[0]['id']
      @results1 = NonhmmUser.find(:all, :conditions => "uid='#{@userid[0]['id']}'")
      @link = params[:link]
      render :layout => false
    end
  end

  def shareWorker


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
          link="/my_familywebsite/add_nonhmm/"+params[:id]+"/?pa="+params[:reciepent_email]
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
        messageboard_link="http://www.holdmymemories.com/my_familywebsite/messageboard/"+params[:id]
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
            link="/my_familywebsite/add_nonhmm/"+params[:id]+"/?pa="+params[:reciepent_email]
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
      messageboard_link="http://www.holdmymemories.com/my_familywebsite/messageboard/"+params[:id]

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

  end

  def validate
    @user = HmmUser.count_by_sql("SELECT count(*) FROM `hmm_users` WHERE (`family_name`='#{params[:id]}' || alt_family_name='#{params[:id]}') and `familywebsite_password`='#{params[:pass]}'")
    puts @user
    if @user > 0
      $message

      flash[:notice_contact] = 'Password Authenticated'
      puts "yes"
      redirect_to :action => "shareWorker"
    else
      $message = 'Invalid Password'
      puts "no"
      flash[:notice_contact] = 'Invalid Password'
      redirect_to :controller => "my_familywebsite", :action => "share"
    end
  end

  def link
    url = params[:id]
    logger.info(url)
    url.gsub("||", "/")
    logger.info(url)
    redirect_to "http://www.holdmymemories.com"+Base64.decode64(url)
  end


  def forgot_password

  end

  def validate_email
    @message_email='';
    color = 'red'
    email = params[:email]
    mail = HmmUser.find_all_by_v_e_mail(email)
    if mail.size > 0
      @message_email = 'Email Authenticated'
      color = 'green'
      @valid_email = true
    else
      @message_email = 'Email does not exist'
      @valid_email = false
    end
    @message_email = "<b style='color:#{color}'>#{@message_email}</b>"
    render :layout=>false
  end

  def password_status
    @results1 = HmmUser.find(:all, :conditions => "v_e_mail='#{params[:email]}'")
    for @i in @results1
      name=@i['v_fname']
      @email=@i['v_e_mail']
      username=@i['v_user_name']
      pass=@i['v_password']
    end
    Postoffice.deliver_deliverpass(name, @email, username, pass)
    $conform_mesg
    flash[:conform_mesg] = "Your username and password have been sent to your email."
    #redirect_to :action => 'conform'
  end

  def new_chap_comment
    @chapter_comment = ChapterComment.new
    render :layout => false
  end

  def subchap_grid_comment
    @chapter_comment = ChapterComment.new
    render :layout => false
  end

  def new_subchap_comment
    @subchapter_comment = SubchapComment.new
    render :layout => false
  end

  def gallery_grid_comment
    @subchapter_comment = SubchapComment.new
    render :layout => false
  end

  def new_gallery_comment
    @gallery_comment = GalleryComment.new
    render :layout => false
  end

  def new_contentgrid_comment
    @gallery_comment = GalleryComment.new
    render :layout => false
  end

  def new_photo_comment
    @photo_comment = PhotoComment.new
    render :layout => false
  end


  def create_chap_comment
    type = 'Chapter'
    hmmuser=HmmUser.find(:all, :conditions => "family_name='#{params[:familyname]}' or alt_family_name = '#{params[:familyname]}'")
    @chapter_comment = ChapterComment.new(params[:chapter_comment])
    @chapter_comment['uid']=hmmuser[0].id
    @chapter_comment['tag_id']= params[:tag_id]
    @chapter_comment['tag_jid']= 0
    @chapter_comment['d_created_on']=Time.now

    if @chapter_comment.save
      @commentedTo_detailschap = Tag.find(params[:tag_id])
      @commentedTo_details=HmmUser.find(@commentedTo_detailschap.uid)

      # Postoffice.deliver_friend(@friend_details.id,@friend_details.v_fname,@friend_details.v_e_mail,@friend_details.v_user_name,@friend_details[:v_password],@my_details.id,@my_details.v_fname,@my_details.v_e_mail,@my_details.v_myimage)
      Postoffice.deliver_comment(params[:chapter_comment][:v_comment],'0',type,params[:chapter_comment][:v_name],hmmuser[0].v_e_mail,hmmuser[0].v_user_name,@commentedTo_details.v_e_mail,hmmuser[0].v_myimage,hmmuser[0].img_url)

      $notice_cc
      flash[:notice_cc] = 'Thank-you for adding your comment.'

      redirect_to :controller => 'my_familywebsite', :action => 'subchapters', :id => params[:tag_id], :familyname => params[:familyname]

    else
      render :action => 'new', :layout => false
    end
  end



  def create_subchapgrid_comment
    type = 'Chapter'
    hmmuser=HmmUser.find(:all, :conditions => "family_name='#{params[:familyname]}' or alt_family_name = '#{params[:familyname]}'")
    @chapter_comment = ChapterComment.new(params[:chapter_comment])
    @chapter_comment['uid']=hmmuser[0].id
    @chapter_comment['tag_id']= params[:tag_id]
    @chapter_comment['tag_jid']= 0
    @chapter_comment['d_created_on']=Time.now

    if @chapter_comment.save
      @commentedTo_detailschap = Tag.find(params[:tag_id])
      @commentedTo_details=HmmUser.find(@commentedTo_detailschap.uid)

      # Postoffice.deliver_friend(@friend_details.id,@friend_details.v_fname,@friend_details.v_e_mail,@friend_details.v_user_name,@friend_details[:v_password],@my_details.id,@my_details.v_fname,@my_details.v_e_mail,@my_details.v_myimage)
      Postoffice.deliver_comment(params[:chapter_comment][:v_comment],'0',type,params[:chapter_comment][:v_name],hmmuser[0].v_e_mail,hmmuser[0].v_user_name,@commentedTo_details.v_e_mail,hmmuser[0].v_myimage,hmmuser[0].img_url,hmmuser[0].img_url)

      $notice_cc
      flash[:notice_cc] = 'Thank-you for adding your comment.'

      redirect_to :controller => 'my_familywebsite', :action => 'subchapter_grid_view', :id => params[:familyname], :chapter_id => params[:tag_id]

    else
      render :action => 'new', :layout => false
    end
  end

  def create_gallery_comment
    type = 'gallery'
    hmmuser=HmmUser.find(:all, :conditions => "family_name='#{params[:familyname]}' or alt_family_name = '#{params[:familyname]}'")
    @gallery_comment = GalleryComment.new(params[:gallery_comment])
    @gallery_comment['uid']=hmmuser[0].id
    @gallery_comment['gallery_id']= params[:gallery_id]
    @gallery_comment['gallery_jid']= 0
    @gallery_comment['d_created_on']=Time.now

    if @gallery_comment.save
      @commentedTo_detailschap = Galleries.find(params[:gallery_id])
      @commentedTo_details=HmmUser.find(hmmuser[0].id)

      # Postoffice.deliver_friend(@friend_details.id,@friend_details.v_fname,@friend_details.v_e_mail,@friend_details.v_user_name,@friend_details[:v_password],@my_details.id,@my_details.v_fname,@my_details.v_e_mail,@my_details.v_myimage)
      Postoffice.deliver_comment(params[:gallery_comment][:v_comment],'0',type,params[:gallery_comment][:v_name],hmmuser[0].v_e_mail,hmmuser[0].v_user_name,@commentedTo_details.v_e_mail,hmmuser[0].v_myimage,hmmuser[0].img_url)

      $notice_cc
      flash[:notice_cc] = 'Thank-you for adding your comment.'

      redirect_to :controller => 'my_familywebsite', :action => 'gallery_fisheye', :id => params[:gallery_id], :familyname => params[:familyname]

    else
      render :action => 'new', :layout => false
    end
  end

  def create_contentgrid_comment
    type = 'gallery'
    hmmuser=HmmUser.find(:all, :conditions => "family_name='#{params[:familyname]}' or alt_family_name = '#{params[:familyname]}'")
    @gallery_comment = GalleryComment.new(params[:gallery_comment])
    @gallery_comment['uid']=hmmuser[0].id
    @gallery_comment['gallery_id']= params[:gallery_id]
    @gallery_comment['gallery_jid']= 0
    @gallery_comment['d_created_on']=Time.now

    if @gallery_comment.save
      @commentedTo_detailschap = Galleries.find(params[:gallery_id])
      @commentedTo_details=HmmUser.find(hmmuser[0].id)

      # Postoffice.deliver_friend(@friend_details.id,@friend_details.v_fname,@friend_details.v_e_mail,@friend_details.v_user_name,@friend_details[:v_password],@my_details.id,@my_details.v_fname,@my_details.v_e_mail,@my_details.v_myimage)
      Postoffice.deliver_comment(params[:gallery_comment][:v_comment],'0',type,params[:gallery_comment][:v_name],hmmuser[0].v_e_mail,hmmuser[0].v_user_name,@commentedTo_details.v_e_mail,hmmuser[0].v_myimage,hmmuser[0].img_url)

      $notice_cc
      flash[:notice_cc] = 'Thank-you for adding your comment.'

      redirect_to :controller => 'my_familywebsite', :action => 'content_grid_view', :id => params[:familyname], :gallery_id => params[:gallery_id]

    else
      render :action => 'new', :layout => false
    end
  end

  def create_subchap_comment
    type = 'sub_chapter'
    hmmuser=HmmUser.find(:all, :conditions => "family_name='#{params[:familyname]}' or alt_family_name = '#{params[:familyname]}'")
    @subchap_comment = SubchapComment.new(params[:subchap_comment])
    @subchap_comment['uid']=hmmuser[0].id
    @subchap_comment['subchap_id']= params[:subchap_id]
    @subchap_comment['subchap_jid']= 0
    @subchap_comment['d_created_on']=Time.now

    if @subchap_comment.save
      @commentedTo_detailschap = SubChapter.find(params[:subchap_id])
      @commentedTo_details=HmmUser.find(@commentedTo_detailschap.uid)

      Postoffice.deliver_comment(params[:subchap_comment][:v_comments],'0',type,params[:subchap_comment][:v_name],hmmuser[0].v_e_mail,hmmuser[0].v_user_name,@commentedTo_details.v_e_mail,hmmuser[0].v_myimage,hmmuser[0].img_url)
      flash[:notice_cc] = 'Thank-you for adding your comment.'
      redirect_to :controller => 'my_familywebsite', :action => 'gallery', :id => params[:subchap_id], :familyname => params[:familyname]
    else
      render :action => 'new', :layout => false
    end
  end

  def create_gallerygrid_comment
    type = 'sub_chapter'
    hmmuser=HmmUser.find(:all, :conditions => "family_name='#{params[:familyname]}' or alt_family_name = '#{params[:familyname]}'")
    @subchap_comment = SubchapComment.new(params[:subchap_comment])
    @subchap_comment['uid']=hmmuser[0].id
    @subchap_comment['subchap_id']= params[:subchap_id]
    @subchap_comment['subchap_jid']= 0
    @subchap_comment['d_created_on']=Time.now

    if @subchap_comment.save
      @commentedTo_detailschap = SubChapter.find(params[:subchap_id])
      @commentedTo_details=HmmUser.find(@commentedTo_detailschap.uid)

      Postoffice.deliver_comment(params[:subchap_comment][:v_comments],'0',type,params[:subchap_comment][:v_name],hmmuser[0].v_e_mail,hmmuser[0].v_user_name,@commentedTo_details.v_e_mail,hmmuser[0].v_myimage,hmmuser[0].img_url)
      flash[:notice_cc] = 'Thank-you for adding your comment.'
      redirect_to :controller => 'my_familywebsite', :action => 'gallery_grid_view', :id => params[:familyname], :subchapter_id => params[:subchap_id]
    else
      render :action => 'new', :layout => false
    end
  end

  def create_photo_comment
    hmmuser=HmmUser.find(:all, :conditions => "family_name='#{params[:familyname]}' or alt_family_name = '#{params[:familyname]}'")
    @photo_comment = PhotoComment.new
    @photo_comment['v_comment']=params[:photo_comment][:v_comment]
    @photo_comment['v_name']=params[:photo_comment][:v_name]
    @photo_comment['uid']=hmmuser[0].id
    @photo_comment['user_content_id']=params[:photo_id]
    @photo_comment['d_add_date']=Time.now

    if @photo_comment.save

      Postoffice.deliver_comment(params[:photo_comment][:v_comment],'0','Photo',params[:photo_comment][:v_name],'',hmmuser[0].v_user_name,hmmuser[0].v_e_mail,hmmuser[0].v_myimage,hmmuser[0].img_url)
      flash[:notice_cc] = 'Thank-you for adding your comment.'
      redirect_to :controller => 'my_familywebsite', :action => 'moment_page', :id => params[:photo_id], :familyname => params[:familyname]
    else
      render :action => 'new', :layout => false
    end
  end

  def view_chap_comments
    @familyname = params[:familyname]
    hmmuser=HmmUser.find(:all, :conditions => "family_name='#{params[:familyname]}' or alt_family_name = '#{params[:familyname]}'")
    @hmm_user=HmmUser.find(hmmuser[0].id)


    if session[:hmm_user]
    else
      e_approval=" and e_approval = 'approve'"
    end



    @tag_c = ChapterComment.find_by_sql("select a.*,b.*,a.id as cid from chapter_comments as a , hmm_users as b where tag_id=#{params[:tag_id]} and tag_jid=''  and a.uid=b.id #{e_approval} ORDER BY a.id DESC")



    @tagid=params[:tag_id]
    @id=params[:jid]
    i=0

    for cn in @tag_c
      i=i+1
    end
    @total=i

    @numberofpagesres=@total/3

    @numberofpages=@numberofpagesres.round()

    if(params[:page]==nil)
      x=0
      y=3
      @page=0
      @nextpage=@page+1
      if(@total<=3)
        @nonext=1
      end
    else
      x=3*Integer(params[:page])
      y=3
      @page=Integer(params[:page])
      @nextpage=@page+1
      @previouspage=@page-1
      if(@page==@numberofpages)
        @nonext=1
      end
      if(@total<=3)
        @nonext=1
      end
    end



    #@tag_comment = ChapterComment.find(:all, :conditions => "tag_id=#{params[:id]} && uid=#{logged_in_hmm_user.id}")
    render :layout => false
  end

  def view_gallery_comments
    @familyname = params[:familyname]
    hmmuser=HmmUser.find(:all, :conditions => "family_name='#{params[:familyname]}' or alt_family_name = '#{params[:familyname]}'")
    @hmm_user=HmmUser.find(hmmuser[0].id)


    if session[:hmm_user]
    else
      e_approval=" and e_approval = 'approve'"
    end



    @gallery_c = GalleryComment.find_by_sql("select a.*,b.*,a.id as cid from gallery_comments as a , hmm_users as b where gallery_id=#{params[:gallery_id]} and (gallery_jid='' or gallery_jid=0)   and a.uid=b.id #{e_approval} ORDER BY a.id DESC")



    @galid=params[:gallery_id]
    @id=params[:jid]
    i=0

    for cn in @gallery_c
      i=i+1
    end
    @total=i

    @numberofpagesres=@total/3

    @numberofpages=@numberofpagesres.round()

    if(params[:page]==nil)
      x=0
      y=3
      @page=0
      @nextpage=@page+1
      if(@total<=3)
        @nonext=1
      end
    else
      x=3*Integer(params[:page])
      y=3
      @page=Integer(params[:page])
      @nextpage=@page+1
      @previouspage=@page-1
      if(@page==@numberofpages)
        @nonext=1
      end
      if(@total<=3)
        @nonext=1
      end
    end



    #@tag_comment = ChapterComment.find(:all, :conditions => "tag_id=#{params[:id]} && uid=#{logged_in_hmm_user.id}")
    render :layout => false
  end


  def view_photo_comments
    @familyname = params[:familyname]
    hmmuser=HmmUser.find(:all, :conditions => "family_name='#{params[:familyname]}' or alt_family_name = '#{params[:familyname]}'")
    @hmm_user=HmmUser.find(hmmuser[0].id)


    if session[:hmm_user]
    else
      e_approval=" and e_approved = 'approve'"
    end



    @gallery_c = PhotoComment.find_by_sql("select a.*,b.*,a.id as cid from photo_comments as a , hmm_users as b where user_content_id=#{params[:photo_id]} and a.uid=b.id #{e_approval} ORDER BY a.id DESC")



    @phid=params[:photo_id]

    i=0

    for cn in @gallery_c
      i=i+1
    end
    @total=i

    @numberofpagesres=@total/3

    @numberofpages=@numberofpagesres.round()

    if(params[:page]==nil)
      x=0
      y=3
      @page=0
      @nextpage=@page+1
      if(@total<=3)
        @nonext=1
      end
    else
      x=3*Integer(params[:page])
      y=3
      @page=Integer(params[:page])
      @nextpage=@page+1
      @previouspage=@page-1
      if(@page==@numberofpages)
        @nonext=1
      end
      if(@total<=3)
        @nonext=1
      end
    end



    #@tag_comment = ChapterComment.find(:all, :conditions => "tag_id=#{params[:id]} && uid=#{logged_in_hmm_user.id}")
    render :layout => false
  end





  def view_subchap_comments
    @familyname = params[:familyname]
    hmmuser=HmmUser.find(:all, :conditions => "family_name='#{params[:familyname]}' or alt_family_name = '#{params[:familyname]}'")
    @hmm_user=HmmUser.find(hmmuser[0].id)
    if session[:hmm_user]
    else
      e_approval=" and e_approval = 'approve'"
    end
    @subchap_c = SubchapComment.find_by_sql("select a.*,b.*,a.id as cid from subchap_comments as a , hmm_users as b where subchap_id=#{params[:subchap_id]} and (subchap_jid=0 or subchap_jid='')  and a.uid=b.id #{e_approval} ORDER BY a.id DESC")
    logger.info "result is '#{@subchap_c}'"
    @subchap_id=params[:subchap_id]
    @id=params[:jid]
    i=0

    for cn in @subchap_c
      i=i+1
    end
    @total=i
    @numberofpagesres=@total/3
    @numberofpages=@numberofpagesres.round()
    if(params[:page]==nil)
      x=0
      y=3
      @page=0
      @nextpage=@page+1
      if(@total<=3)
        @nonext=1
      end
    else
      x=3*Integer(params[:page])
      y=3
      @page=Integer(params[:page])
      @nextpage=@page+1
      @previouspage=@page-1
      if(@page==@numberofpages)
        @nonext=1
      end
      if(@total<=3)
        @nonext=1
      end
    end
    render :layout => false
  end

  def share_journal
    @jtype = params[:id]
    @temp = @jtype.split("&")
    @family_name_tag = params[:familyname]
    #@usercontent=UserContent.find(params[:id])
    @userid = HmmUser.find(:all, :conditions => "(family_name='#{params[:familyname]}' || alt_family_name='#{params[:familyname]}')")
    @uid = @userid[0]['id']
    @symb='&'


  end

  def sharejournalWorker
    link = params[:link]
    if params[:message]
      @message = params[:message]
    end
    @jtype = params[:id]
    @temp = @jtype.split("&")
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
        @share['jid']=params[:id]
        @share['jtype']=params[:jtype]
        @share['e_mail']= j.v_email
        @share['created_date']=Time.now
        @share['expiry_date']=Time.now.advance(:months => 1, :years => 0)
        @share['message']=@message
        shareuuid=Share.find_by_sql("select uuid() as uid")
        unid=shareuuid[0].uid+""+"#{share_next_id}"
        @share['unid']=unid
        @share.save
        Postoffice.deliver_shareJournal(@share['e_mail'],@message,journal,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.family_pic,@share.id,@share.unid)
        $share_journalredirect
        flash[:share_journalredirect] = 'Journal was Successfully Shared!!'
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
          @share['jid']=params[:id]
          @share['jtype']=params[:jtype]
          @share['e_mail']= k
          @share['created_date']=Time.now
          @share['expiry_date']=Time.now.advance(:months => 1, :years => 0)
          @share['message']=@message
          shareuuid=Share.find_by_sql("select uuid() as uid")
          unid=shareuuid[0].uid+""+"#{share_next_id}"
          @share['unid']=unid
          @share.save
          Postoffice.deliver_shareJournal(@share['e_mail'],@message,journal,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.family_pic,@share.id,@share.unid)
        end
      end
    end

    $share_journal
    flash[:share_journal] = 'Journal was Successfully Shared!!'
    redirect_to :controller => 'my_familywebsite', :action => 'journals', :id => "#{params[:family_name]}"
  end

  def book_session
    if params[:studio_id] && params[:studio_id]!=nil
      @hmm_studio = HmmStudio.find(params[:studio_id])
      if  @hmm_studio
        unless @hmm_studio.studio_top_logo == nil || @hmm_studio.studio_top_logo == ""
          @studio_header_img = "#{ @hmm_studio.studio_top_logo}_black.png" if  @hmm_studio.studio_top_logo != nil
          @studio_website =  @hmm_studio.studio_website if  @hmm_studio.studio_website != nil
        else
          @studio_header_img="default_top_logo_black.png" #default logo depending upon the header logo color specified in the themes table
          @studio_website = "/" #default studio link
        end
      end
      render(:layout => false)
    else
      redirect_to :controller => 'my_familywebsite', :action => 'book_session', :studio_id => 22
    end



  end

  def send_book_session

    fname=params[:FirstName]
    lname=params[:LastName]
    phone=params[:Phone]
    phone2=params[:AltPhone]
    streetaddress=params[:street_address]
    email=params[:Email]
    studio=params[:studio_visit]
    hear=params[:Source]
    month=params[:orderdate_Month]
    day=params[:orderdate_Day_ID]
    year=params[:orderdate_Year]
    time=params[:SessionTime]
    type=params[:SessionType]
    comments=params[:SessionComments]
    studio_email = params[:studio_email]
    studio_header_img = params[:studio_header_img]
    #@book_studio = BookStudio.new
    #@book_studio['company_id']=0
    #@book_studio['studio_id']=0
    #@book_studio['firstname']=fname
    #@book_studio['lastname']=lname
    #@book_studio['day_phone']=phone
    #@book_studio['night_phone']=phone2
    #@book_studio['streetaddress']=streetaddress
    #@book_studio['emailaddress']=email
    #@book_studio['hear']=hear
    #@book_studio['sessiondate']=month+" "+day+" "+year
    #@book_studio['sessiontime']=time
    #@book_studio['sessiontype']=type
    #@book_studio['comments']=comments

    #@book_studio.save


    Postoffice.deliver_booksession(fname,lname,phone,phone2,streetaddress,email,studio,hear,month,day,year,time,type,comments,studio_email,studio_header_img,request_content_url)
    flash[:notice] = 'Session was Booked Successfully !!!'
    redirect_to "/my_familywebsite/book_session_thankyou/#{params[:id]}?studio_id=#{params[:studio_id]}"
    #redirect_to :controller => 'my_familywebsite', :action => 'book_session_thankyou', :id => "#{params[:id]}"

  end

  def book_session_thankyou
    @hmm_studio = HmmStudio.find(params[:studio_id])
    if  @hmm_studio
      @studio_name = @hmm_studio.studio_name
      unless @hmm_studio.studio_phone == "" || @hmm_studio.studio_phone == nil
        @cnt = (@hmm_studio.studio_phone).length
      else
        @cnt = 0
      end

      if @cnt == 10
        @studio_phone = "("+(@hmm_studio.studio_phone).slice(0..2)+") "+(@hmm_studio.studio_phone).slice(3..5)+"-"+(@hmm_studio.studio_phone).slice(6..9)
      else
        @studio_phone = @hmm_studio.studio_phone
      end
      @studio_email = @hmm_studio.contact_email
      unless @hmm_studio.studio_top_logo == nil || @hmm_studio.studio_top_logo == ""
        @studio_header_img = "#{ @hmm_studio.studio_top_logo}_white.png" if  @hmm_studio.studio_top_logo != nil
      else
        @studio_header_img="default_top_logo_white.png" #default logo depending upon the header logo color specified in the themes table
      end
    end

    render(:layout => false)
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
    redirect_to :controller => 'my_familywebsite', :action => 'home' , :id => params[:id]

  end

  def zoomdemo
    @familywebsite_themes = FamilywebsiteTheme.find(:all)
    render(:layout => false)
  end

  #Chapter Display In The Chapter Index Page
  def chapterindex
    if(session[:hmm_user])
      @hmm_user=HmmUser.find(session[:hmm_user])
    else
      redirect_to '/user_account/login'
    end

    items_per_page = 9

    sort_init 'd_updateddate'
    sort_update

    @total = HmmUser.count(logged_in_hmm_user.id)
    if(@total>0)
      session[:semiprivate]="activate"
    else
      session[:semiprivate]=""
    end


    srk=params[:sort_key]

    sort="#{srk}  #{params[:sort_order]}"

    if(srk==nil)
      sort="id  asc"
    end


    @tags = Tag.paginate  :per_page => items_per_page, :page => params[:page], :order => sort, :conditions => "uid='#{logged_in_hmm_user.id}' and status='active' and e_access='public'" # ,:order => " #{@sort.to_s} #{@order.to_s} "
    @countcheck=Tag.count(:all,:conditions => "uid=#{logged_in_hmm_user.id} and e_access='public' and status='active'")
    # @tags = Tag.find_by_sql("SELECT a.*,b.* FROM user_contents as a,tags as b where a.uid='logged_in_hmm_user.id' and a.uid=b.uid")
    if request.xml_http_request?
      render :partial => "chapters_list", :layout => false
    end
  end


  def selected_items

    #render :layout => 'myfamilywebsite'


    if(session[:hmm_user])

    else
      redirect_to '/user_account/login'
    end
    @my_carts = MyCart.find(:all, :conditions => "uid=#{logged_in_hmm_user.id}", :order=>"id DESC" )
    @my_carts_count = MyCart.count(:all, :conditions => "uid=#{logged_in_hmm_user.id}" )
    @moment_count = MyCart.count(:all, :conditions => "uid=#{logged_in_hmm_user.id} and added_item = 'moment'" )
    @product = Product.find(:all)
  end

  def generate_reciept
    if(session[:hmm_user])

    else
      redirect_to '/user_account/login'
    end
    @my_carts = MyCart.find(:all, :conditions => "uid=#{logged_in_hmm_user.id}", :order=>"id DESC" )
    @my_carts_count = MyCart.count(:all, :conditions => "uid=#{logged_in_hmm_user.id}" )
    @moment_count = MyCart.count(:all, :conditions => "uid=#{logged_in_hmm_user.id} and added_item = 'moment'" )
    @product = Product.find(:all)

    @totalamount = MyCart.sum('price', :conditions => "uid='#{logged_in_hmm_user.id}' " )
    render :layout => false
  end

  def shoppingcart_payment
    if(session[:hmm_user])


    else
      redirect_to '/user_account/login'
    end
    @hmm_user=HmmUser.find(params[:id])
    @amount = MyCart.sum('price', :conditions => "uid='#{logged_in_hmm_user.id}' " )
    #render :layout => true
  end

  def process_payment
    #    #adding no of copies in my_carts table
    if(session[:hmm_user])

    else
      redirect_to '/user_account/login'
    end
    card_no=params[:card_no]
    cvv_no=params[:cardcvv_no]
    exp_month=params[:exp_month]
    exp_year=params[:exp_year]
    fname=params[:fname]
    lname=params[:lname]
    street_address = params[:street_address]
    postcode = params[:postcode]
    city = params[:city]
    state = params[:state]
    country = params[:country]
    telephone = params[:telephone]



    amttest = Integer(params[:amount])


    creditcard = ActiveMerchant::Billing::CreditCard.new(
      # :type => params[:creditcard][:card_type],
      :number => card_no,
      :month => exp_month,
      :year => exp_year,
      :first_name => fname,
      :last_name => lname,
      :verification_value => cvv_no
    )
    if creditcard.valid?
      #if @creditcard.save
      flash[:message] ="Creditcard Info saved!"
      #redirect_to :action => 'check_balance', :id=> @creditcard


      #@creditcard = Creditcard.find(params[:id])
      gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(:test => true, :login => "8GxD65y84", :password=> "89j6d34cW8CKhp9S")
      amount_to_charge = Money.ca_dollar(amttest) #1000 = ten US dollars
      creditcard = ActiveMerchant::Billing::CreditCard.new(
        #:type => params[:creditcard][:card_type],
        :number => card_no,
        :month => exp_month,
        :year => exp_year,
        :first_name => fname,
        :last_name => lname,
        :verification_value => cvv_no
      )

      options = {
        :address => {},
        :billing_address => {
          :name     => "#{fname}  #{lname}",
          :address1 => street_address,
          :city     => city,
          :state    => state,
          :country  => country,
          :zip      => postcode,
          :phone    => telephone
        }
      }
      response = gateway.authorize(amount_to_charge,creditcard,options)
      if response.success?
        gateway.capture(amount_to_charge, response.authorization)

        #creating unid for order_id
        @paymentdetail_max =  PaymentDetail.find_by_sql("select max(id) as n from payment_details")
        for paymentdetail_max in @paymentdetail_max
          paymentdetail_max_id = "#{paymentdetail_max.n}"
        end
        if(paymentdetail_max_id == '')
          paymentdetail_max_id = '0'
        end

        paymentdetail_next_id= Integer(paymentdetail_max_id) + 1
        orderuuid=PaymentDetail.find_by_sql("select uuid() as id")
        @unid=String(orderuuid.id)+"_"+"#{paymentdetail_next_id}"

        @find_itemsincart = MyCart.find(:all, :conditions => "uid = '#{logged_in_hmm_user.id}' and status='pending'")
        for k in @find_itemsincart
          @order_detail = OrderDetail.new
          @order_detail['uid']= logged_in_hmm_user.id
          @order_detail['moment_type']= k.added_item
          @order_detail['order_unid']= @unid
          @order_detail['moment_id']= k.moment_id
          @order_detail['no_of_copies']= k.no_of_copies
          @order_detail['product_id']= k.product_id
          @order_detail['payment_status']= 'yes'
          @order_detail['order_status']= 'yes'
          @order_detail['shippment_status']= 'pending'
          @order_detail['order_date']=Time.now
          @order_detail['shippment_date']=Time.now + 3
          if @order_detail.save
            MyCart.find(k.id).destroy
            flag=1
          end
        end
        if flag == 1
          #saving payemnt deatils and order id
          @payment_detail = PaymentDetail.new
          @payment_detail['user_id']= logged_in_hmm_user.id
          @payment_detail['order_id']= @unid
          @payment_detail['fname']=fname
          @payment_detail['lname']=lname
          @payment_detail['amount']=amttest
          @payment_detail['street_address']=street_address
          @payment_detail['city']=city
          @payment_detail['state']=state
          @payment_detail['country']=country
          @payment_detail['postcode']=postcode
          @payment_detail['telephone']=telephone
          @payment_detail['shipment_street_address']=street_address
          @payment_detail['shipment_city']=city
          @payment_detail['shipment_state']=state
          @payment_detail['shipment_country']=country
          @payment_detail['shipment_postcode']=postcode
          @payment_detail['shipment_telephone']=telephone
          @payment_detail['exp_month']=exp_month
          @payment_detail['exp_year']=exp_year
          @payment_detail['order_date']=Time.now
          @payment_detail['shippment_date']=Time.now + 3
          @payment_detail.save
        end

        flash[:succes] = "Payment was successfully done, You will recieve your images in 7 working days."
        #redirect_to "https://www.holdmymemories.com/customers/authorise_payment/?id=#{params[:hmm_id]}&type=#{acctype}"
        redirect_to "/my_familywebsite/payment_complete/#{params[:familyname]}"
      else
        flash[:error] = "Transaction has been declined, below is the reason from authorize.net<br>"+message
        #redirect_to "https://www.holdmymemories.com/customers/authorise_payment/?id=#{params[:hmm_id]}&type=#{acctype}"
        redirect_to "/my_familywebsite/shoppingcart_payment/#{logged_in_hmm_user.id}/?familyname=#{params[:familyname]}"
      end
    else
      flash[:error] = "Error in credit card info! this error is from our website so the reason is invalid information added as wrong count of credit card numbers or cvv number is alphanumeric etc"
      #redirect_to "https://www.holdmymemories.com/customers/authorise_payment/?id=#{params[:hmm_id]}&type=#{acctype}"
      redirect_to "/my_familywebsite/shoppingcart_payment/#{logged_in_hmm_user.id}/?familyname=#{params[:familyname]}"
    end

  end


  def chapter_next
    if(session[:hmm_user])

    else
      redirect_to '/user_account/login'
    end
    sort_init 'd_updated_on'
    sort_update
    if(!params[:id].nil?)
      session[:tag_id]=params[:id]
    end

    @chapter_belongs_to=Tag.find_by_sql("select a.*,b.* from tags as a,  hmm_users as b where a.id=#{params[:id]} and  a.uid=b.id")
    puts @chapter_belongs_to[0]['uid']
    puts logged_in_hmm_user.id
    if(@chapter_belongs_to[0]['uid']==logged_in_hmm_user.id)
    else
      session[:friend]=@chapter_belongs_to[0]['uid']
      @total = HmmUser.count(:conditions =>  "uid=#{logged_in_hmm_user.id} and status='accepted'")
      if(@total>0)
        session[:semiprivate]="activate"
      else
        session[:semiprivate]=""
      end
    end
    @hmm_user=HmmUser.find(session[:hmm_user])
    items_per_page = 9
    conditions = ["v_tagname LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?
    if(session[:friend]!='')
      e_access="and e_access='public' "
      uid=session[:friend]
      if(session[:semiprivate]=="activate")
        e_access=" and (e_access='public'  or e_access='semiprivate')"
      end
    else
      uid=logged_in_hmm_user.id
    end
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="id  desc"
    end

    @sub_chapters = SubChapter.paginate :per_page => items_per_page, :page => params[:page], :conditions => "tagid=#{params[:id]} and status='active'    #{e_access}" , :order => sort #:order => " #{@sort.to_s} #{@order.to_s} "
    @countcheck=SubChapter.count(:all,:conditions => "tagid=#{params[:id]} #{e_access} and status='active'")

    @chapter_journal = ChapterJournal.find(:all, :conditions => "tag_id=#{params[:id]}", :order=>"id DESC")
    @tagid = ChapterJournal.find(:all, :conditions => "tag_id=#{params[:id]}")
    @chap_cnt = ChapterJournal.count(:all, :conditions => "tag_id=#{params[:id]}")
    @tag = Tag.find(params[:id])
    session[:chap_id]=params[:id]
    session[:chap_name]=@tag['v_tagname']
    if request.xml_http_request?
      render :partial => "chapter_next", :layout => false
    end

    if(@countcheck==1)
      gallery = Galleries.find(:all,:conditions=>"subchapter_id='#{@sub_chapters[0]['id']}'")
      redirect_to :controller => "my_familywebsite" , :action => 'sub_chapter_gallery', :id => @sub_chapters[0]['id'] , :familyname => params[:familyname]

    end
  end

  def sub_chapter_gallery
    if(session[:hmm_user])

    else
      redirect_to '/user_account/login'
    end
    sort_init 'd_updated_on'
    sort_update
    session[:sub_id]=params[:id]

    @subchaapter_belongs_to=SubChapter.find_by_sql("select a.*,b.* from sub_chapters as a,  hmm_users as b where a.id=#{params[:id]} and  a.uid=b.id")
    if(@subchaapter_belongs_to[0]['uid']!=logged_in_hmm_user.id)
      session[:friend]=@subchaapter_belongs_to[0]['uid']
      @total = HmmUser.count(:conditions =>  "uid=#{logged_in_hmm_user.id} and status='accepted'")
      if(@total>0)
        session[:semiprivate]="activate"
      else
        session[:semiprivate]=""
      end
    end

    @hmm_user=HmmUser.find(session[:hmm_user])
    items_per_page = 9
    galery_id=params[:id]
    conditions = ["v_tagname LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?
    if(session[:friend]!='')
      e_access="and e_gallery_acess='public' "
      uid=session[:friend]
      if(session[:semiprivate]=="activate")
        e_access="and (e_gallery_acess='public'  or e_gallery_acess='semiprivate')"
      end
    else
      uid=logged_in_hmm_user.id
    end
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"
    if( srk==nil)
      sort="id  desc"
    end
    @sub_chapters_gallerie = Galleries.paginate :per_page => items_per_page, :page => params[:page], :order => sort,  :conditions => "subchapter_id=#{params[:id]} and status='active'    #{e_access}" ,:order => sort
    @countcheck=Galleries.count(:all, :conditions => "subchapter_id=#{params[:id]} and status='active'    #{e_access}")
    for subchap in @sub_chapters_gallerie
      @sub_chapter_count=UserContent.count(:all, :conditions => " gallery_id=#{subchap.id} and status='active'")
      if(@sub_chapter_count<=0)
        @countcheck=@countcheck-1
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
    if(@countcheck==1)
      redirect_to :controller => "my_familywebsite" , :action => 'chapter_gallery', :id =>actualid ,:familyname => params[:familyname]
    else
      render :layout => true
    end
  end


  #Function For Displaying Chapter Gallery
  def chapter_gallery
    if(session[:hmm_user])

    else
      redirect_to '/user_account/login'
    end
    sql = ActiveRecord::Base.connection();
    session[:share_with_hmm]=nil
    session[:shid]=nil
    session[:share]=nil
    session[:redirect]=nil
    @gallery_belongs_to=Galleries.find_by_sql("select a.*,b.* from galleries as a, sub_chapters as b, hmm_users as c where a.id=#{params[:id]} and a.subchapter_id=b.id and b.uid=c.id")
    @gallery_belongs_to[0]['uid']
    if(@gallery_belongs_to[0]['uid']!="#{logged_in_hmm_user.id}")
      session[:friend]=@gallery_belongs_to[0]['uid']
      @total = HmmUser.count(:conditions =>  "uid=#{logged_in_hmm_user.id} and status='accepted'")
      if(@total>0)
        session[:semiprivate]="activate"
      else
        session[:semiprivate]=""
      end
    end

    session[:galleryid]=''
    session[:share]=''
    sort_init 'd_updated_on'
    sort_update
    session[:galery_id]=params[:id]
    gal=params[:id]
    items_per_page = 9
    chapter_id=params[:id]
    @hmm_user=HmmUser.find(session[:hmm_user])
    if(session[:friend]!='')
      e_access="and e_access='public'"
      if(session[:semiprivate]=="activate")
        e_access=" and (e_access='public' or e_access='semiprivate')"
      end
    end

    srk=params[:sort_key]
    puts srk
    sort="#{srk}  #{params[:sort_order]}"
    if(srk==nil)
      sort="id  desc"
    end
    puts sort

    @user_content = UserContent.find(:all,:conditions=>"gallery_id=#{params[:id]}  and status='active'", :order => sort)
    @gallery_journal = GalleryJournal.find(:all, :conditions => "galerry_id=#{params[:id]}", :order=>"id DESC")

    # Bread crumb sessions
    @galleries = Galleries.find(params[:id])
    @gal_name=@galleries['v_gallery_name']
    session[:gal]=params[:id]
    session[:gallery_name]=@galleries['v_gallery_name']
    params[:id]=@galleries['subchapter_id']
    @sub_chapter = SubChapter.find(params[:id])
    session[:subchap_id]=params[:id]
    session[:sub_chapname]=@sub_chapter['sub_chapname']
    params[:id]=@sub_chapter['tagid']
    @tag = Tag.find(params[:id])
    session[:chap_id]=params[:id]
    session[:chap_name]=@tag['v_tagname']

    params[:id]=gal
    @gal_cnt = GalleryJournal.count(:all, :conditions => "galerry_id=#{params[:id]}")
    if request.xml_http_request?
      render :partial => "chapgallery_list", :layout => false
    end
  end


  def validate_item
    if(session[:hmm_user])

    else
      redirect_to '/user_account/login'
    end
    moment_type = params[:moment_type]
    mom_id = params[:id]
    if moment_type == "chap"
      @chap_content_count = UserContent.count(:all, :conditions => "tagid = '#{mom_id}' and e_filetype='image'")
      if @chap_content_count > 0
        redirect_to "/my_familywebsite/create_item/?id=#{mom_id}&familyname=#{params[:familyname]}&moment_type=#{moment_type}&link=#{params[:link]}"
      else
        flash[:order_invalid] = "This "+moment_type+"ter contains no images!!"
        redirect_to params[:link]
      end
    elsif moment_type == "subchapter"
      @subchap_content_count = UserContent.count(:all, :conditions => "sub_chapid = '#{mom_id}'  and e_filetype='image'")
      if @subchap_content_count > 0
        redirect_to "/my_familywebsite/create_item/?id=#{mom_id}&familyname=#{params[:familyname]}&moment_type=#{moment_type}&link=#{params[:link]}"
      else
        flash[:order_invalid] = "This "+moment_type+" contains no images!!"
        redirect_to params[:link]
      end
    elsif moment_type == "gallery"
      @gal_content_count = UserContent.count(:all, :conditions => "gallery_id = '#{mom_id}'  and e_filetype='image'")
      if @gal_content_count > 0
        redirect_to "/my_familywebsite/create_item/?id=#{mom_id}&familyname=#{params[:familyname]}&moment_type=#{moment_type}&link=#{params[:link]}"
      else
        flash[:order_invalid] = "This "+moment_type+" contains no images!!"
        redirect_to params[:link]
      end
    elsif moment_type == "moment"
      redirect_to "/my_familywebsite/create_item/?id=#{mom_id}&familyname=#{params[:familyname]}&moment_type=#{moment_type}&link=#{params[:link]}"
    end

  end

  def login_mysite #user login check for manage family website

    unless session[:hmm_user]
      ``
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to :controller =>'my_familywebsite', :action => 'contest_login', :id => params[:id],:contest =>params[:contest]
      return false
    else
      redirect_to :controller =>'manage_site', :action => 'contest_chapter', :id => logged_in_hmm_user.family_name,:contest =>params[:contest]
    end
  end
  def phase2_contest


    @block_check = HmmUser.count(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}') and e_user_status='blocked'")
    if(@block_check > 0)
      redirect_to :controller => 'my_familywebsite', :action => 'blocked', :id => params[:id]
    end
  end

  def hmm_contest
    @block_check = HmmUser.count(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}') and e_user_status='blocked'")
    if(@block_check > 0)
      redirect_to :controller => 'my_familywebsite', :action => 'blocked', :id => params[:id]
    end
  end

  def contest_terms_conditions
    if params[:contest] == "video"
      @type = params[:contest]
      session[:contests_type] = "video"
    else params[:contest] == "photo"
      @type = params[:contest]
      session[:contests_type] = "image"
    end
  end

  def moments_vote
    items_per_page = 12

    sort_init 'contest_entry_date'
    sort_update

    srk=params[:sort_key]
    @sort="#{srk}  #{params[:sort_order]}"
    @sort1="desc"
    @sort2="desc"
    if(srk==nil)
      @sort="contest_entry_date  desc"
      @sort1="desc"
      @sort2="desc"
    end

    if(srk == 'contest_entry_date')
      @sort1="desc"
      if params[:sort_order] == 'desc'
        @sort1="asc"
      else
        @sort1="desc"
      end
    end

    if(srk == 'new_votes')
      @sort2="desc"
      if params[:sort_order] == 'desc'
        @sort2="asc"
      else
        @sort2="desc"
      end
    end

    @contest_memoriable = Contest.find(:all, :conditions => "moment_type = 'image' and contest_phase='phase3'")
    if (params[:query].nil?)
      conditions = "a.moment_id = b.id and a.moment_type = 'image' and a.status = 'active' and a.moment_id=c.user_content_id and b.id=c.user_content_id and a.contest_phase='phase3'"
    else
      conditions = "a.moment_id = b.id and a.moment_type = 'image' and a.status = 'active' and a.moment_id=c.user_content_id and b.id=c.user_content_id and ( a.first_name like '#{params[:query]}%' or c.v_image_comment like '%#{params[:query]}%') and a.contest_phase='phase3'"
    end
    @contest_cutekid = Contest.paginate :per_page => items_per_page, :page => params[:page], :select => "a.*, b.*,c.*,  a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b, journals_photos as c ",
      :conditions => "#{conditions}", :order => @sort,:group=>"a.id"
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
      @contest = Contest.find(params[:id])
      @uid = @contest.uid
      contetsid = @contest.id
      contetsfname = @contest.first_name
      moment_type = @contest.moment_type

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
        familyname = user.family_name
      end

      @contest_vote = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and email_id = '#{params[:email]}' ")
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
          $notice_vote1
          flash[:notice_vote] = 'Thank-you for casting your vote.  You will shortly receive an email verification that you must accept for your vote to be counted.  This helps us make sure that all votes are valid votes.  Your email address will not be shared with any other company.'
          Postoffice.deliver_voteconform(params[:email],contetsid, unid,moment_filename,contetsfname,user_fname,user_lname,moment_type)
          if(moment_type=="video")
            redirect_to :controller => "my_familywebsite", :action => 'videomoment_vote',:id => params[:familyname]
          else
            redirect_to :controller => "my_familywebsite", :action => 'moments_vote',:id => params[:familyname]
          end
        else
          $notice_vote
          flash[:notice_vote] = 'Your was not submitted due to technical issue... Please try again!!'
          if(moment_type=="video")
            redirect_to :controller => "my_familywebsite",:action => 'videomoment_vote',:id => params[:familyname]
          else
            redirect_to :controller => "my_familywebsite",:action => 'moments_vote',:id => params[:familyname]
          end
        end

      else
        $notice_vote
        flash[:notice_vote] = 'You have already voted for this moment.. you can cast your vote only once per family!!'
        if(moment_type=="video")
          redirect_to :controller => "my_familywebsite", :action => 'videomoment_vote',:id => params[:familyname]
        else
          redirect_to :controller => "my_familywebsite", :action => 'moments_vote',:id => params[:familyname]
        end
      end
    else
      redirect_to :action => 'vote_cal', :id => params[:id], :familyname => params[:familyname]
    end
  end

  def momentdetails
    if(params[:page]==nil || params[:page]=='' || params[:hmm]==nil)
      @counts =  Contest.count(:all, :conditions => " moment_type='image' and status='active' and contest_phase='phase3'",:order =>'first_name  asc')
      @allrecords =  Contest.find(:all, :conditions => " moment_type='image' and status='active'and contest_phase='phase3'" ,:order =>'first_name  asc')
      page=0


      #pp @allrecords
      for check in @allrecords
        page=page+1
        if("#{check.moment_id}" == "#{params[:id]}" )
          @nextpage=page
          puts "yes dude"
          redirect_to :action => :momentdetails, :id=> params[:id], :page =>@nextpage,:familyname =>params[:familyname],:hmm=>'true'
          #redirect_to :action => :momentdetails, :id=> params[:id], :page =>@nextpage
        else
          puts "#{check.moment_id} == #{params[:id]}"

          puts "\n"
        end
      end

    else
      @user_content =Contest.paginate  :per_page => 1, :page => params[:page], :conditions => "moment_type='image' and status='active' and contest_phase='phase3'",:order =>'first_name  asc'
      #@contest_cutekid = Contest.paginate :per_page => 1, :page => params[:page], :conditions => " moment_type='image' and status='active'" ,:order =>'first_name  asc'

    end
  end

  def videomoment_vote
    items_per_page = 6
    sort_init 'contest_entry_date'
    sort_update

    srk=params[:sort_key]
    @sort="#{srk}  #{params[:sort_order]}"
    @sort1="desc"
    @sort2="desc"
    if(srk==nil)
      @sort="contest_entry_date  desc"
      @sort1="desc"
      @sort2="desc"
    end

    if(srk == 'contest_entry_date')
      @sort1="desc"
      if params[:sort_order] == 'desc'
        @sort1="asc"
      else
        @sort1="desc"
      end
    end

    if(srk == 'new_votes')
      @sort2="desc"
      if params[:sort_order] == 'desc'
        @sort2="asc"
      else
        @sort2="desc"
      end
    end

    #@contest_cutekid = Contest.find(:all, :joins => "as a, user_contents as b", :conditions => "a.moment_id = b.id and a.contest_title = 'Cute Kid Contest'")
    @contest_memoriable = Contest.find(:all, :conditions => "moment_type='video' and contest_phase='phase3'")
    if (params[:query].nil?)
      conditions = "a.moment_id = b.id  and  a.moment_type = 'video' and a.moment_id=c.user_content_id and b.id=c.user_content_id and a.status='active' and a.contest_phase='phase3'"
    else
      conditions = "a.moment_id = b.id   and  a.moment_type = 'video' and a.moment_id=c.user_content_id and b.id=c.user_content_id and a.status='active' and ( a.first_name like '#{params[:query]}%' or c.v_image_comment like '%#{params[:query]}%') and a.contest_phase='phase3'"

    end
    @contest_cutekid = Contest.paginate :per_page => items_per_page, :page => params[:page], :select => "a.*, b.*,c.v_image_comment,  a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b, journals_photos as c ",
      :conditions => "#{conditions}", :order => @sort,:group=>"a.id"

  end

  def videomoment_details
    @moment_details = UserContent.find(:all, :conditions => "id='#{params[:id]}'")
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:id]}'")
    @journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{params[:id]} ")
    #render :layout => true
  end

  def contest_login
    if session[:hmm_user]
      @hmm_user=HmmUser.find(session[:hmm_user])
      if params[:contest] == "memorable"
        @type = params[:contest]
        session[:contests_type] = "video"
      else params[:contest] == "photo"
        @type = params[:contest]
        session[:contests_type] = "image"
      end
      redirect_to "/manage_site/contest_chapter/#{@hmm_user.family_name}"
    end
    #render :layout => true
  end

  def create_item
    puts params[:moment_type]
    j=0
    @last_index=Array.new()
    for mom_id in params[:moment_id]

      @my_cart = MyCart.new()
      @my_cart['uid']=logged_in_hmm_user.id
      @my_cart['moment_id']=mom_id
      @my_cart['added_item']=params[:moment_type][j]
      @my_cart['status']='pending'
      #    @my_cart['no_of_copies']=
      @my_cart.save

      @last_index[j] = MyCart.find(:first, :order => "id desc").id
      #@moment_id = MyCart.find(:first, :order => "id desc").moment_id

      j=j+1
    end
    flash[:notice_mycart] = 'Item was successfully added to cart.'
    redirect_to :controller=>'my_familywebsite' , :action=>'add_sizes' , :link=>params[:link] , :familyname => params[:familyname] , :cartid =>  @last_index , :moment_id => params[:moment_id] , :moment_type => params[:moment_type]


  end

  def add_sizes

    @products = Product.find(:all)


    @no_of_moments = 0
    if(params[:moment_type]=='chap')

      @tags = Tag.find(:all, :conditions => "uid=#{logged_in_hmm_user.id} and id=#{params[:moment_id]}")

      for tag in @tags

        @no_of_moments = UserContent.count(:all, :conditions => "uid=#{logged_in_hmm_user.id} and tagid=#{tag.id} and e_filetype='image'")

      end

    end

    if(params[:moment_type]=='subchapter')

      @sub_chap = SubChapter.find(:all, :conditions => "uid=#{logged_in_hmm_user.id} and id=#{params[:moment_id]}")

      for subchap in @sub_chap

        @no_of_moments = UserContent.count(:all, :conditions => "uid=#{logged_in_hmm_user.id} and sub_chapid=#{subchap.id} and e_filetype='image'")

      end

    end


    if(params[:moment_type]=='gallery')

      @gal = Galleries.find(:all, :conditions => "id=#{params[:moment_id]}")

      for gallery in @gal
        @no_of_moments = UserContent.count(:all, :conditions => "uid=#{logged_in_hmm_user.id} and gallery_id=#{gallery.id}")
      end

    end

    if(params[:moment_type]=='moment')
      @no_of_moments = 1
    end


    if (params[:did])
      ProductDetail.find(params[:did]).destroy

      #Cart Update
      @amount = ProductDetail.sum('product_price', :conditions => "cartid='#{params[:cartid]}' " )
      @copies = ProductDetail.sum('no_of_copies', :conditions => "cartid='#{params[:cartid]}' " )
      @moments = ProductDetail.sum('no_of_moments', :conditions => "cartid='#{params[:cartid]}' " )

      @my_cart = MyCart.find(params[:cartid])
      @my_cart.no_of_copies=@copies
      @my_cart.no_of_moments=@moments
      @my_cart.price=@amount
      @my_cart.save

      redirect_to params[:dellink]
      #redirect_to :controller=>'my_familywebsite', :action=>'add_sizes' , :familyname =>params[:familyname],:cartid=>params[:cartid],:link=>params[:link],:moment_id=>params[:moment_id],:moment_type=>params[:moment_type]
    end

    if(params[:pname])



      @product = ProductDetail.new()
      @product.cartid=params[:cartid]
      @product.no_of_moments=@no_of_moments
      @product.no_of_copies=params[:copies]
      @noof_moment=(@no_of_moments * Integer(params[:copies]))
      @product_price = Product.find(:first, :conditions => "id=#{params[:pname]}").price
      @product.product_price=(Integer(@product_price) * @noof_moment)
      @product.product_id=params[:pname]
      @product.save


      #Cart Update
      @amount = ProductDetail.sum('product_price', :conditions => "cartid='#{params[:cartid]}' " )
      @copies = ProductDetail.sum('no_of_copies', :conditions => "cartid='#{params[:cartid]}' " )
      @moments = ProductDetail.sum('no_of_moments', :conditions => "cartid='#{params[:cartid]}' " )
      @pids1 = ProductDetail.find(:all, :conditions => "cartid='#{params[:cartid]}' " )

      #arr=Array.new()
      @pids=''
      for j in @pids1

        @pids=@pids+"#{j.id}"+","

      end



      #@pids='1,2,3,4,5'



      @my_cart = MyCart.find(params[:cartid])
      @my_cart.product_id=@pids
      @my_cart.no_of_copies=@copies
      @my_cart.no_of_moments=@moments
      @my_cart.price=@amount
      @my_cart.save

      redirect_to params[:addlink]
    end
  end

  def edit_sizes

    @products = Product.find(:all)


    @no_of_moments = 0
    if(params[:moment_type]=='chap')

      @tags = Tag.find(:all, :conditions => "uid=#{logged_in_hmm_user.id} and id=#{params[:moment_id]}")

      for tag in @tags

        @no_of_moments = UserContent.count(:all, :conditions => "uid=#{logged_in_hmm_user.id} and tagid=#{tag.id} and e_filetype='image'")

      end

    end

    if(params[:moment_type]=='subchapter')

      @sub_chap = SubChapter.find(:all, :conditions => "uid=#{logged_in_hmm_user.id} and id=#{params[:moment_id]}")

      for subchap in @sub_chap

        @no_of_moments = UserContent.count(:all, :conditions => "uid=#{logged_in_hmm_user.id} and sub_chapid=#{subchap.id} and e_filetype='image'")

      end

    end


    if(params[:moment_type]=='gallery')

      @gal = Galleries.find(:all, :conditions => "id=#{params[:moment_id]}")

      for gallery in @gal
        @no_of_moments = UserContent.count(:all, :conditions => "uid=#{logged_in_hmm_user.id} and gallery_id=#{gallery.id}")
      end

    end

    if(params[:moment_type]=='moment')
      @no_of_moments = 1
    end


    if (params[:did])
      ProductDetail.find(params[:did]).destroy

      #Cart Update
      @amount = ProductDetail.sum('product_price', :conditions => "cartid='#{params[:cartid]}' " )
      @copies = ProductDetail.sum('no_of_copies', :conditions => "cartid='#{params[:cartid]}' " )
      @moments = ProductDetail.sum('no_of_moments', :conditions => "cartid='#{params[:cartid]}' " )

      @my_cart = MyCart.find(params[:cartid])
      @my_cart.no_of_copies=@copies
      @my_cart.no_of_moments=@moments
      @my_cart.price=@amount
      @my_cart.save

      redirect_to :controller=>'my_familywebsite', :action=>'edit_sizes' , :familyname =>params[:familyname],:cartid=>params[:cartid],:link=>params[:link],:moment_id=>params[:moment_id],:moment_type=>params[:moment_type]
    end

    if(params[:pname])



      @product = ProductDetail.new()
      @product.cartid=params[:cartid]
      @product.no_of_moments=@no_of_moments
      @product.no_of_copies=params[:copies]
      @noof_moment=(@no_of_moments * Integer(params[:copies]))
      @product_price = Product.find(:first, :conditions => "id=#{params[:pname]}").price
      @product.product_price=(Integer(@product_price) * @noof_moment)
      @product.product_id=params[:pname]
      @product.save


      #Cart Update
      @amount = ProductDetail.sum('product_price', :conditions => "cartid='#{params[:cartid]}' " )
      @copies = ProductDetail.sum('no_of_copies', :conditions => "cartid='#{params[:cartid]}' " )
      @moments = ProductDetail.sum('no_of_moments', :conditions => "cartid='#{params[:cartid]}' " )
      @pids1 = ProductDetail.find(:all, :conditions => "cartid='#{params[:cartid]}' " )

      #arr=Array.new()
      @pids=''
      for j in @pids1

        @pids=@pids+"#{j.id}"+","

      end

      @my_cart = MyCart.find(params[:cartid])
      @my_cart.product_id=@pids
      @my_cart.no_of_copies=@copies
      @my_cart.no_of_moments=@moments
      @my_cart.price=@amount
      @my_cart.save

      #redirect_to params[:link]
    end
  end

  def delete_sizes
    if(params[:did])
      ProductDetail.find(params[:did]).destroy
      redirect_to :controller => "my_familywebsite", :action => 'delete_msg', :m => 'size' ,:url=>params[:url], :familyname => params[:familyname]
    end
  end

  def delete_item_cart
    if(params[:cid])
      MyCart.find(params[:cid]).destroy
      redirect_to :controller => "my_familywebsite", :action => 'delete_msg', :m => 'item' ,:url=>params[:url], :familyname => params[:familyname]
    end
  end

  def delete_msg

  end



  def update_copies
    #adding no of copies in my_carts table
    #@find_cartid = MyCart.find(:all, :conditions => "uid = '#{logged_in_hmm_user.id}' and status='pending'")
    #i=0
    #require 'pp'
    #pp params[:mycart_id]
    #for m in @find_cartid
    #  sizes= "sizes#{params[:mycart_id][i]}"
    #  @my_cart = MyCart.find(params[:mycart_id][i])
    #  @my_cart.no_of_copies=params[:copies][i]
    # @my_cart.no_of_moments=params[:no_moments][i]
    # @my_cart.product_id=params["#{sizes}"]
    #    @product_price = Product.find(:all, :conditions => "id='#{@my_cart.product_id}'")
    # @noof_moment =  (@my_cart.no_of_moments * @my_cart.no_of_copies)
    # @my_cart.price = (@product_price[0]['price'] * @noof_moment)
    # @my_cart.save
    #i=i+1
    # end
    #redirect_to :controller => "order_details", :action => 'process_payment', :id => logged_in_hmm_user.id , :familyname => params[:familyname]
    redirect_to :controller => "my_familywebsite", :action => 'shoppingcart_payment', :id => logged_in_hmm_user.id , :familyname => params[:familyname]

  end

  def vote_cal
    @contest = Contest.find(params[:id])
    familyname=params[:familyname]
    @uid = @contest.uid
    contetsid = @contest.id
    contest_typ = @contest.moment_type

    @contest_vote1 = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and hmm_voter_id = '#{logged_in_hmm_user.id}' ")
    @contest_vote2 = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and email_id = '#{logged_in_hmm_user.v_e_mail}' ")
    puts @contest_vote2
    if (@contest_vote1 <= 0 and @contest_vote2 <= 0)
      #calculating next id for the contest vote table
      @contestvote_max =  ContestVotes.find_by_sql("select max(id) as n from contest_votes")
      for contestvote_max in @contestvote_max
        contestvote_max_id = "#{contestvote_max.n}"
      end
      if(contestvote_max_id == '')
        contestvote_max_id = '0'
      end
      contestvote_next_id = Integer(contestvote_max_id) + 1

      @username = HmmUser.find(:all, :conditions => "id='#{@uid}'")
      for user in @username
        familyname = user.family_name
      end

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

        #calculation for new votes
        @count = ContestVotes.count_by_sql("select COUNT(distinct CONCAT(IFNULL(email_id,''),IFNULL(hmm_voter_id,''))) AS COUNT from contest_votes where contest_id='#{contetsid}' and conformed='yes'")
        countest_update = Contest.find(contetsid)
        countest_update.new_votes = @count
        countest_update.save

        $notice_vote
        flash[:notice_vote] = 'Vote has been successfully submitted.. '
        #Postoffice.deliver_voteconform(params[:email],contetsid, unid)
        if contest_typ == 'image'
          redirect_to  :action => 'moments_vote', :id => params[:familyname]
        else if contest_typ == 'video'
            redirect_to  :action => 'videomoment_vote', :id => params[:familyname]
          end
        end
      else
        $notice_vote
        flash[:notice_vote] = 'Your was not submitted due to technical issue... Please try again!!'
        if contest_typ == 'image'
          redirect_to  :action => 'moments_vote', :id => params[:familyname]
        else if contest_typ == 'video'
            redirect_to  :action => 'videomoment_vote', :id => params[:familyname]
          end
        end
      end

    else
      $notice_vote
      flash[:notice_vote] = 'You have already voted for this moment.. you can cast your vote only once per family!!'
      if contest_typ == 'image'
        redirect_to :action => 'moments_vote', :id => familyname
      else if contest_typ == 'video'
          redirect_to :action => 'videomoment_vote', :id => familyname
        end
      end
    end

  end

  def cutekid_contest
    @recent_entries = Contest.find_by_sql("SELECT a.*, b.* FROM contests as a, user_contents as b WHERE a.moment_id=b.id and a.moment_type = 'image' and a.status = 'active' order by a.new_votes desc limit 0,12")
  end

  def previous_contest
    @recent_entries = Contest.find_by_sql("SELECT a.*, b.* FROM contests as a, user_contents as b WHERE a.moment_id=b.id and a.moment_type = 'image' and a.status = 'active' order by a.new_votes desc limit 0,12")
  end

  def momentdetails_old_contest
    @moment_details = UserContent.find(:all, :conditions => "id='#{params[:momentid]}'")
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:momentid]}' ")
    @journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{params[:momentid]} ")
  end

  def videomoment_old_contest
    @moment_details = UserContent.find(:all, :conditions => "id='#{params[:momentid]}'")
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:momentid]}'")
    @journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{params[:momentid]} ")
  end

  def shareJournal_nonhmm
    @user_contentID = ShareJournal.find(:all,:select =>"a.*,b.*" ,:joins => "as a, journals_photos as b" , :conditions => "a.unid='#{params[:id]}' and a.jid=b.id")

    @get_content_url=ContentPath.find(:all, :conditions => "status='active'")
    @serverurl=@get_content_url[0]['content_path']
    @servername=@get_content_url[0]['proxyname']
    contentservers = ContentPath.find(:all)
    @proxyurls = nil
    for server in contentservers
      if(@proxyurls == nil)
        @proxyurls = server['content_path']
      else
        @proxyurls = @proxyurls +','+server['content_path']
      end
    end
  end

  def chapter_grid_view
    @hmm_user = HmmUser.find(:first, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}') and e_user_status='unblocked'")
    if(@hmm_user)
      items_per_page = 9
      sort_init 'd_updateddate'
      sort_update
      if(params[:sort_key]==nil)
        sort="order_num  asc"
      else
        sort="#{params[:sort_key]}  #{params[:sort_order]}"
      end
      @tags = Tag.paginate  :per_page => items_per_page, :page => params[:page], :order => sort, :conditions => "uid='#{@hmm_user.id}' and status='active' and e_access ='public'"
      @countcheck=Tag.count(:all,:conditions => "uid=#{@hmm_user. id} and status='active' and e_access ='public'")
    end
  end

  def subchapter_grid_view
    @hmm_user = HmmUser.find(:first, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}') and e_user_status='unblocked'")
    if(@hmm_user)
      items_per_page = 9
      sort_init 'd_updated_on'
      sort_update
      if(!params[:chapter_id].nil?)
        session[:chapter_id]=params[:chapter_id]
      else
        params[:chapter_id]= session[:chapter_id]
      end
      if(params[:sort_key]==nil)
        sort="order_num  asc"
      else
        sort="#{params[:sort_key]}  #{params[:sort_order]}"
      end
      @sub_chapters = SubChapter.paginate :per_page => items_per_page, :page => params[:page], :conditions => "tagid='#{params[:chapter_id]}' and status='active' and e_access ='public'" , :order => sort
      @countcheck=SubChapter.count(:all,:conditions => "tagid='#{params[:chapter_id]}' and status='active' and e_access ='public'")

      @chapter_journal = ChapterJournal.find(:all, :conditions => "tag_id='#{params[:chapter_id]}'", :order=>"id DESC")
      @chap_cnt = ChapterJournal.count(:all, :conditions => "tag_id='#{params[:chapter_id]}'")
    end

  end

  def gallery_grid_view
    @hmm_user = HmmUser.find(:first, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}') and e_user_status='unblocked'")
    if(@hmm_user)
      items_per_page = 9
      sort_init 'd_updated_on'
      sort_update
      if(params[:sort_key]==nil)
        sort="order_num  asc"
      else
        sort="#{params[:sort_key]}  #{params[:sort_order]}"
      end
      if(!params[:subchapter_id].nil?)
        session[:subchapter_id]=params[:subchapter_id]
      else
        params[:subchapter_id]= session[:subchapter_id]
      end
      @sub_chapter_journal = SubChapJournal.find(:all, :conditions => "sub_chap_id=#{params[:subchapter_id]}", :order=>"id DESC")
      @galleries = Galleries.paginate :per_page => items_per_page, :page => params[:page], :conditions => "subchapter_id=#{params[:subchapter_id]} and status='active' and e_gallery_acess='public'" ,:order => sort
      @countcheck=Galleries.count(:all, :conditions => "subchapter_id=#{params[:subchapter_id]} and status='active' and e_gallery_acess='public'")
    end
  end


  def content_grid_view
    @hmm_user = HmmUser.find(:first, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}') and e_user_status='unblocked'")
    if(@hmm_user)
      items_per_page = 9
      sort_init 'd_updated_on'
      sort_update
      if(params[:sort_key]==nil)
        sort="order_num  asc"
      else
        sort="#{params[:sort_key]}  #{params[:sort_order]}"
      end
      if(!params[:gallery_id].nil?)
        session[:gallery_id]=params[:gallery_id]
      else
        params[:gallery_id]= session[:gallery_id]
      end
      @gallery  = Galleries.find(:all, :conditions => "id=#{params[:gallery_id]}", :order => "order_num ASC")
      @gallery_journal = GalleryJournal.find(:all, :conditions => "galerry_id=#{params[:gallery_id]}", :order=>"id DESC")
      @user_content = UserContent.paginate :per_page => items_per_page, :page => params[:page], :conditions=>"gallery_id=#{params[:gallery_id]}  and status='active' and e_access ='public'", :order => sort
      @countcheck=UserContent.count(:all, :conditions => "gallery_id=#{params[:gallery_id]} and status='active' and e_access ='public'")
      logger.info "count #{@countcheck}"
    end
  end
  def no_photo

  end

end


