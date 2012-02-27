class ContestsController < ApplicationController
  include ApplicationHelper
  include SortHelper
  helper :sort
  include SortHelper
  include ApplicationHelper
  include ContestsHelper
  #  before_filter :set_facebook_session
  #  helper_method :facebook_session
  require 'will_paginate'
  #  require 'contacts'
  require 'json'
  require 'htmlentities'
  # before_filter :set_facebook_session
  #  helper_method :facebook_session
  #  def index
  #    list
  #    render :action => 'list'
  #  end
  
  layout :phone_or_desktop
  #      layout "iphone_application"
  

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
    :redirect_to => { :action => :list }

  before_filter :authenticate1, :only => [ :contest_chapter, :contest_sub_chapter ,:contest_gallery ,:contest_upload, :contest_moments, :mycontest_moments, :mymemorable_moments, :logged_videomoment_vote, :logged_moments_vote, :contests_select]

  before_filter :iphone_website, :only=>[:select_contestmoment]
  #  rescue_from Facebooker::Session::SessionExpired, :with => :facebook_session_expired
  #
  #  def facebook_session_expired
  #    clear_fb_cookies!
  #    clear_facebook_session_information
  #    #reset_session # remove your cookies!
  #    redirect_to :url => "/user_account/login"
  #  end
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
        else
          @path = ContentPath.find(:first, :conditions => "status='active'")
          if(params[:id]=='bob')
            @content_server_url = "http://content.holdmymemories.com"
          else
            @content_server_url = @path.content_path
          end

          return true #returns true if all the conditions are cleared
        end
      else
        redirect_to '/'
      end
    end
  end

  def authenticate1
    unless session[:hmm_user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to :controller => "user_account" , :action => 'login'
      return false
    end
  end

  def iphone_website
    unless session[:hmm_user] || params[:user_id]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to :controller => "user_account" , :action => 'login'
      return false
    end
  end

  def initialize
    super
    #@hmm_users = HmmUser.find(:all)
  end
  
  def login_check #user login check for manage family website
    unless session[:hmm_user]
      ``
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to '/seniorscontest/hmm_contest'
      return false
    else
      redirect_to :controller =>'familywebsite_seniorscontest', :action => 'intro', :id => logged_in_hmm_user.family_name
    end
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
    @contest = ContestDetail.find(params[:contest_id])
    if params[:contest_type] == "video"
      @type = params[:contest_type]
    else params[:contest_type] == "photo"
      @type = params[:contest_type]
    end
    if iphone_request?
      respond_to do |format|
        format.iphone do  # action.iphone.erb
        end
      end
    end
  end


  def hmm_contest
    params[:contest_id] = Base64.decode64(params[:contest_id])
    @contest_details=ContestDetail.find(params[:contest_id])
    if params[:contest_id] == "15"
      #redirect_to :action => 'previous_contest'
      #@recent_entries = Contest.find_by_sql("SELECT a.*, b.* FROM contests as a, user_contents as b WHERE a.moment_id=b.id and a.moment_type = 'image' and a.status = 'active' and a.contest_phase='#{contest_phase}' and a.age_groups='0-2' order by a.votes desc limit 2")
      @topentries_photo_0_to_2 = Contest.find(:all,:select => "a.*, b.*, a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b",
        :conditions => "a.moment_id = b.id and a.moment_type = 'image' and a.contest_phase='phase#{params[:contest_id]}' and a.status='active' and age_groups='0-2'", :order => "a.votes desc", :limit =>"2")

      @topentries_photo1 = Array.new
      @topentries_photo_0_to_2.each do |photo|
        @topentries_photo1 << photo
      end

      @topentries_photo_3_to_5 = Contest.find(:all,:select => "a.*, b.*, a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b",
        :conditions => "a.moment_id = b.id and a.moment_type = 'image' and a.contest_phase='phase#{params[:contest_id]}' and a.age_groups='3-5' and a.status='active'", :order => "a.votes desc", :limit =>"2")

      @topentries_photo2 = Array.new
      @topentries_photo_3_to_5.each do |photo|
        @topentries_photo2 << photo
      end

      @topentries_photo_6_to_9 = Contest.find(:all,:select => "a.*, b.*, a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b",
        :conditions => "a.moment_id = b.id and a.moment_type = 'image' and a.contest_phase='phase#{params[:contest_id]}' and a.age_groups='6-9' and a.status='active'", :order => "a.votes desc", :limit =>"2")

      @topentries_photo3 = Array.new
      @topentries_photo_6_to_9.each do |photo|
        @topentries_photo3 << photo
      end

      @topentries_photo_10_to_17 = Contest.find(:all,:select => "a.*, b.*, a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b",
        :conditions => "a.moment_id = b.id and a.moment_type = 'image' and a.contest_phase='phase#{params[:contest_id]}' and a.age_groups='10-17' and a.status='active'", :order => "a.votes desc", :limit =>"2")

      @topentries_photo4 = Array.new
      @topentries_photo_10_to_17.each do |photo|
        @topentries_photo4 << photo
      end
      logger.info "==================="
      logger.info @topentries_photo4.inspect
      logger.info @topentries_photo4.size
    else
   
      @topentries_photo_0_to_2 = Contest.find(:all,:select => "a.*, b.*, a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b",
        :conditions => "a.moment_id = b.id and a.moment_type = 'image' and a.contest_phase='phase#{params[:contest_id]}' and a.status='active' ", :order => "a.votes desc", :limit =>"10")
      @topentries_photo = Array.new
      @topentries_photo_0_to_2.each do |photo|
        @topentries_photo << photo
      end
    end
    if params[:contest_id] == "15"
      limit = "8"
    else
      limit = "10"
    end
    @topentries_video_0_to_2 = Contest.find(:all,:select => "a.*, b.*, a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b",
      :conditions => "a.moment_id = b.id and a.moment_type = 'video' and a.contest_phase='phase#{params[:contest_id]}' and a.status='active'", :order => "a.votes desc", :limit =>"#{limit}")
    @topentries_video = Array.new
    @topentries_video_0_to_2.each do |video|
      @topentries_video << video
    end
    if iphone_request?
      respond_to do |format|
        format.iphone do  # action.iphone.erb
        end
      end
    end
  end

  def phase2_contest
    @recent_entries = Contest.find_by_sql("SELECT a.*, b.* FROM contests as a, user_contents as b WHERE a.moment_id=b.id and a.moment_type = 'image' and a.status = 'active' and a.contest_phase='2' order by a.new_votes desc limit 0,12")

  end

  def evaluate_terms
    puts params[:mom]
    if params[:agree] == 'agree'
      redirect_to "/contests/contest_login?contest_id=#{params[:contest_id]}&contest_type=#{params[:contest_type]}"
    else if params[:agree_down] == 'agree'
        redirect_to "/contests/contest_login?contest_id=#{params[:contest_id]}&contest_type=#{params[:contest_type]}"
      else
        redirect_to '/'
      end
    end
  end

  def contest_login
    if session[:hmm_user]
      @hmm_user=HmmUser.find(session[:hmm_user])
    end
    if iphone_request?
      respond_to do |format|
        format.iphone do  # action.iphone.erb
        end
      end
    end
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

        if params[:contest_type] == 'photo'
          session[:contests_type] = 'image'
        else if params[:contest_type] == 'video'
            session[:contests_type] = 'video'
          end
        end
        session[:contest_phase] = Base64.encode64(params[:contest_id])
        logger.info("************session contest**********")
        logger.info(session[:contests_type])
        logger.info("************session contest**********")
        session[:alert] = "fnfalert"
        session[:account_type] = logged_in_hmm_user.account_type
        redirect_to "/familywebsite_contest/contest_chapter/#{logged_in_hmm_user.family_name}?p=#{Base64.encode64(params[:contest_id])}"
      else
        reset_session
        flash[:error1] = "User is been blocked.. Contact Admin!!"
        redirect_to "/contests/contest_login?contest_id=#{params[:contest_id]}&contest_type=#{params[:contest_type]}"
      end
    else
      flash[:error] = "I'm sorry; either your username or password was incorrect."
      #log file entry
      logger.error("[Invalid Login]: by [User]:#{params[:hmm_user][:v_user_name]} at #{Time.now}")
      redirect_to "/contests/contest_login?contest_id=#{params[:contest_id]}&contest_type=#{params[:contest_type]}"
      return "false"
    end
  end

  def contest_chapter
    @hmm_user=HmmUser.find(session[:hmm_user])
    items_per_page = 9
    sort_init 'd_updateddate'
    sort_update

    @total = HmmUser.count(:all , :conditions =>  "id=#{logged_in_hmm_user.id}")
    @friend=HmmUser.find(logged_in_hmm_user.id)
    uid=@friend.id
    uid=logged_in_hmm_user.id
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"
    if(srk==nil)
      sort="id  asc"
    end
    @tags = Tag.paginate :per_page => items_per_page, :page => params[:page], :conditions => "uid='#{uid}' and status='active' ", :order => sort

    if request.xml_http_request?
      render :partial => "chapters_list", :layout => false
    end
  end

  def contest_sub_chapter
    sort_init 'd_updated_on'
    sort_update
    if(!params[:id].nil?)
      session[:tag_id]=params[:id]
    end

    @chapter_belongs_to=Tag.find_by_sql("select a.*,b.* from tags as a,  hmm_users as b where a.id=#{params[:id]} and  a.uid=b.id")


    @hmm_user=HmmUser.find(session[:hmm_user])
    items_per_page = 9
    conditions = ["v_tagname LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?


    uid=logged_in_hmm_user.id

    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="id  desc"
    end
    @sub_chapters_pages, @sub_chapters = paginate :sub_chapters ,  :per_page => items_per_page, :conditions => "tagid=#{params[:id]} and status='active' " , :order => sort #:order => " #{@sort.to_s} #{@order.to_s} "
    countcheck=SubChapter.count(:all,:conditions => "tagid=#{params[:id]} and status='active'")

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
      redirect_to :controller => "seniorscontest" , :action => 'contest_gallery', :id => @sub_chapters[0]['id']
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
    @hmm_user=HmmUser.find(session[:hmm_user])
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
    session[:sub_id]=params[:subchapid]
    @hmm_user=HmmUser.find(session[:hmm_user])
    items_per_page = 9
    galery_id=params[:subchapid]
    conditions = ["v_tagname LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"
    if( srk==nil)
      sort="id  desc"
    end
    @sub_chapters_galleries_pages, @sub_chapters_gallerie = paginate :galleriess , :order => sort, :per_page => items_per_page, :conditions => "subchapter_id=#{params[:subchapid]} and status='active' and e_gallery_type='#{session[:contests_type]}'" ,:order => sort
    countcheck=Galleries.count(:all, :conditions => "subchapter_id=#{params[:subchapid]} and status='active' and e_gallery_type='#{session[:contests_type]}'")
    for subchap in @sub_chapters_gallerie
      @sub_chapter_count=UserContent.count(:all, :conditions => " gallery_id=#{subchap.id} and status='active'")
      if(@sub_chapter_count<=0)
        countcheck=countcheck-1
      else
        actualid=subchap.id
      end
    end
    #puts countcheck
    @sub_chapter_journal = SubChapJournal.find(:all, :conditions => "sub_chap_id=#{params[:subchapid]}", :order=>"id DESC")
    #Bread crumb sessions
    @sub_chapter = SubChapter.find(params[:subchapid])
    session[:subchap_id]=params[:subchapid]
    session[:sub_chapname]=@sub_chapter['sub_chapname']
    params[:subchapid]=@sub_chapter['tagid']
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
      redirect_to :controller => "seniorscontest" , :action => 'contest_moments', :id =>actualid
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
    if params[:contest_phase]
      @unid = "?id="+params[:id]+"&contest_type="+params[:contest_type]+"&contest_phase="+params[:contest_phase]
    else
      @unid = "?id="+params[:id]+"&contest_type="+params[:contest_type]
    end
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
          if params[:contest_phase]
            redirect_to "/contests/contest_upload"+@unid
          else
            redirect_to :controller => 'contests', :action =>'contest_upload'
          end
        end
        #redirect_to :action => authenticate_pass, :username => username, :password =>password
      end
    else
      redirect_to :controller => 'seniorscontest', :action => 'contest_login'
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

  def contest_upload
    if session[:contest] != nil
      @uid = logged_in_hmm_user.id
      @moment_type = session[:contest]
      @contest_phase = params[:contest_phase]
      @contest_details = ContestDetail.find(params[:contest_phase])
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
      uid=params[:id]
      @images=params[:Filedata]
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
    @journal['jtype']= 'photo'

    #Blog Entry
    if session[:contest] == 'image'
      jtype_create = 'image'
    else if session[:contest] == 'Video'
        jtype_create = 'video'
      end
    end

    @blog=Blog.new()
    @blog['blog_type_id']=@user_content['id']
    @blog['user_id']=logged_in_hmm_user.id
    @blog['title']=params[:journal][:v_title]
    @blog['description']=params[:journal][:v_image_comment]
    @blog['blog_type']=jtype_create
    @blog.save


    @contest = Contest.new
    @contest['uid']=logged_in_hmm_user.id
    @contest['moment_id']=@user_content['id']
    @contest['journal_id']= journalphoto_next_id
    @contest['moment_type']=session[:contest]
    @contest['contest_title']="Home for The Holidays Contest"
    @contest['contest_entry_date'] = Time.now
    @contest['contest_phase'] = seniorcontest_phase

    @tag_contest.save
    @sub_chapter_contest.save
    @galleries1_contest.save
    @galleries2_contest.save
    @galleries3_contest.save

    if @journal.save
      @contest.save
      redirect_to :controller => :seniorscontest, :action => :contestmoment_show
    else
      redirect_to :controller => :seniorscontest, :action => :contest_chapter
    end
  end


  def get_memories_list
    @moments=UserContent.find(:all, :conditions => "gallery_id='#{params[:id]}'")

    render :layout => false
  end

  def contestmoment_show
    @usercontent = UserContent.find(:all, :joins=>"as a, contests as b ", :select =>"*", :conditions => "b.uid = #{logged_in_hmm_user.id} and a.id = b.moment_id ")
    #@journal = JournalsPhoto.find(:all, :joins=>"as a, contests as b ", :select =>"*", :conditions => "b.uid = #{logged_in_hmm_user.id} and b.journal_id = a.id")
    @journal = Blog.find(:all, :joins=>"as a, contests as b ", :select =>"*", :conditions => "b.uid = #{logged_in_hmm_user.id} and b.moment_id = a.blog_type_id and a.user_id=#{logged_in_hmm_user.id}")
    session[:contest] = nil
  end

  def select_contestmoment
    if params[:user_id]
      user=HmmUser.find(params[:user_id])
    else
      user=logged_in_hmm_user
    end
    contest_phase=params[:contest_phase]
    issubmitted = Contest.find_by_sql("select *  from contests where contests.moment_id='#{params[:momentid]}' and contests.uid=#{user.id} and contest_phase = '#{contest_phase}'")

    #to get the moment thumb
    @moment = UserContent.find(:all, :conditions => "id='#{params[:momentid]}'")
    for mom_thumb in @moment
      moment_thumb = mom_thumb.v_filename
    end

    if(issubmitted.length == 0)
      @contest_namecheck = Contest.find_by_sql("select *  from contests where contests.first_name='#{params[:fname]}' and contests.uid='#{user.id}' and moment_type = '#{params[:type]}' and contest_phase = '#{contest_phase}' ")
      #Contest.count(:conditions => "uid=#{logged_in_hmm_user.id} and first_name!=#{params[:fname]}")
      if (@contest_namecheck.length == 0)
        @result = "true"
        if params[:type] == 'image'
          jtype = 'image'
        else if params[:type] == 'video'
            jtype = 'video'
          end
        end

        if params[:journal] == "no"
          @journal = JournalsPhoto.new
          @journal['user_content_id']= params[:momentid]
          @journal['v_title']= params[:title]
          @journal['v_image_comment']= params[:journal_desc]
          @journal['date_added']= Date.civil(params[:date][:"date_selected(1i)"].to_i,params[:date][:"date_selected(2i)"].to_i,params[:date][:"date_selected(3i)"].to_i)
          @journal['updated_date']= Time.now
          @journal['jtype']= 'photo'
          @journal.save

          #Blog Entry
          @blog=Blog.new()
          @blog['blog_type_id']=params[:momentid]
          @blog['user_id']=user.id
          @blog['title']=params[:title]
          @blog['description']=params[:journal_desc]
          @blog['blog_type']=jtype
          @blog['added_date'] = Date.civil(params[:date][:"date_selected(1i)"].to_i,params[:date][:"date_selected(2i)"].to_i,params[:date][:"date_selected(3i)"].to_i)
          @blog.save
        elsif  params[:journal] == "edited"
          journaledited = JournalsPhoto.find(:first, :conditions => "user_content_id = #{params[:momentid]}")
          journaledited['v_title']=params[:title]
          journaledited['v_image_comment']=params[:journal_desc]
          journaledited['updated_date']=Date.civil(params[:date][:"date_selected(1i)"].to_i,params[:date][:"date_selected(2i)"].to_i,params[:date][:"date_selected(3i)"].to_i)
          journaledited.save;

          #Blog Entry Edit
          @blog=Blog.find(:first,:conditions=>"blog_type_id=#{params[:momentid]} and blog_type='#{jtype}'")
          @blog['blog_type_id']=params[:momentid]
          @blog['user_id']=user.id
          @blog['title']=params[:title]
          @blog['description']=params[:journal_desc]
          @blog['blog_type']=jtype
          @blog.save
        else
        end
        @contest = Contest.new
        @contest['uid']=user.id
        @contest['moment_id']=params[:momentid]
        @contest['journal_id']= params[:jid]
        @contest['moment_type']=params[:type]
        @contest['contest_title']=params[:contest_title]
        @contest['first_name']=params[:fname]
        @contest['contest_entry_date'] = Time.now
        @contest['contest_phase'] = contest_phase
        @contest['age_groups'] = params[:age_groups]
       
        @contest.save
        Postoffice.deliver_contest_entrymail(params[:fname],moment_thumb,user.v_user_name,user.v_fname,user.v_e_mail)
      else
        @result = "false"
      end
    else
      @result = "submited"
    end
    if iphone_request?
      respond_to do |format|
        format.iphone do  # action.iphone.erb
          flash[:result] = @result
          if @result == 'true'
            redirect_to "/contests/select_contest?entrysubmitted=true"
          elsif @result == 'false'
            redirect_to "/contests/submit_entry?contest_id=#{contest_phase}&user_id=#{params[:user_id]}&&moment_type=#{params[:type]}&&moment_id=#{params[:momentid]}"
          elsif @result == 'submited'
            redirect_to "/contests/submit_entry?contest_id=#{contest_phase}&user_id=#{params[:user_id]}&&moment_type=#{params[:type]}&&moment_id=#{params[:momentid]}"
          end
        end
      end
    else
      render :layout => false
    end
  end

  def select_contest_type
    @contest_details = ContestDetail.find(Base64.decode64(params[:contest_id]))
    if iphone_request?
      respond_to do |format|
        format.iphone do  # action.iphone.erb
        end
      end
    end
  end

  def moments_vote
    
    items_per_page = 12
    @contest_phase = params[:contest_id]
    logger.info "******************************"
    logger.info(@contest_phase)
    logger.info "******************************"
    sort_init 'contest_entry_date'
    sort_update

    srk=params[:sort_key]
    @sort="#{srk}  #{params[:sort_order]}"
    @sort1="desc"
    @sort2="desc"
    if(srk==nil)
      #@sort="contest_entry_date  desc"
      @sort=" contest_entry_date  desc"
      @sort1="desc"
      @sort2="desc"
    end

    if(srk == 'first_name')
      @sort1="desc"
      if params[:sort_order] == 'desc'
        @sort1="asc"
      else
        @sort1="desc"
      end
    end
    if(srk == 'contest_entry_date')
      @sort1="desc"
      if params[:sort_order] == 'desc'
        @sort1="asc"
      else
        @sort1="desc"
      end
    end

    

    if(srk == 'votes')
      @sort2="desc"
      if params[:sort_order] == 'desc'
        @sort2="asc"
      else
        @sort2="desc"
      end
    end
    @contest_details= ContestDetail.find(@contest_phase)
    @contest_memoriable = Contest.find(:all, :conditions => "moment_type = 'image' and contest_phase='phase#{@contest_phase}'")
    if (params[:query].nil?)
      conditions = "a.moment_id = b.id and a.moment_type = 'image' and a.status = 'active' and a.contest_phase='phase#{@contest_phase}'"
    else
      params[:query] = (params[:query].gsub("'","")).gsub('"',"")
      conditions = "a.moment_id = b.id and a.moment_type = 'image' and a.status = 'active' and ( a.first_name like '%#{params[:query]}%') and a.contest_phase='phase#{@contest_phase}' "
    end
    @contest_cutekid = Contest.paginate :per_page => items_per_page, :page => params[:page], :select => "a.*, b.*, a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b",
      :conditions => "#{conditions}", :order => @sort ,:group =>"a.id"
    if iphone_request?
      respond_to do |format|
        format.iphone do  # action.iphone.erb
        end
      end
    end

  end

  def videomoment_vote
    items_per_page = 6
    @contest_phase = params[:contest_id]
    sort_init 'contest_entry_date'
    sort_update
    srk=params[:sort_key]
    @sort="#{srk}  #{params[:sort_order]}"
    @sort1="desc"
    @sort2="desc"
    if(srk==nil)
      #@sort="contest_entry_date  desc"
      @sort=" contest_entry_date  desc"
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

    if(srk == 'first_name')
      @sort1="desc"
      if params[:sort_order] == 'desc'
        @sort1="asc"
      else
        @sort1="desc"
      end
    end
    
    if(srk == 'votes')
      @sort2="desc"
      if params[:sort_order] == 'desc'
        @sort2="asc"
      else
        @sort2="desc"
      end
    end
    @contest_details= ContestDetail.find(@contest_phase)
    @contest_memoriable = Contest.find(:all, :conditions => "moment_type='video' and contest_phase='phase#{@contest_phase}'")
    if (params[:query].nil?)
      conditions = "a.moment_id = b.id  and  a.moment_type = 'video' and a.status='active' and a.contest_phase='phase#{@contest_phase}'"
    else
      params[:query] = (params[:query].gsub("'","")).gsub('"',"")
      conditions = "a.moment_id = b.id   and  a.moment_type = 'video' and a.status='active' and ( a.first_name like '%#{params[:query]}%') and a.contest_phase='phase#{@contest_phase}'"
    end
    @contest_entries = Contest.paginate :per_page => items_per_page, :page => params[:page], :select => "a.*, b.*, a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b",
      :conditions => "#{conditions}", :order => @sort ,:group=>"a.id"
    if iphone_request?
      respond_to do |format|
        format.iphone do  # action.iphone.erb
        end
      end
    end
  end


  def momentdetails
    sort_key = !params[:sort_key].nil? ? params[:sort_key] : "contest_entry_date"
    sort_order = !params[:sort_order].nil? ? params[:sort_order] : "desc"
    @sort = "#{sort_key}  #{sort_order}"
    if params[:navigate_id].nil?
      @contest_pair = Hash.new
      i = 0
      @contests =  Contest.find(:all, :select => "a.*, b.*, a.id as id, a.first_name as first_name" ,:joins=>"as a, user_contents as b",
        :conditions => "a.moment_id = b.id  and  a.moment_type = 'image' and a.status='active' and a.contest_phase='phase#{params[:contest_id]}'", :order => @sort)
      for contest in @contests
        position = i
        moment_id = contest.moment_id
        @contest_pair.store(position,"#{moment_id}")
        i = i + 1
        logger.info("{#{position} => #{moment_id}}")
      end
      session[:contest_pair] = @contest_pair
    end
    @contest_pair = session[:contest_pair]
    logger.info("*******HASH*************")
    logger.info @contest_pair.inspect
    len = @contest_pair.length
    if params[:moment_id].nil?
      momentid = @contest_pair.fetch(params[:navigate_id].to_i)
    else
      momentid = params[:moment_id]
    end
    @initial_position = @contest_pair.index(momentid)
    logger.info("@initial_position = #{@initial_position}")
    logger.info("len = #{len}")
      
    if @initial_position == 0 && len == 1
      @next = "last"
      @previous = "last"
      logger.info("Cond1")
    elsif @initial_position == 0 && len > 1
      @next = @initial_position + 1
      @previous = "last"
      logger.info("Cond2")
    elsif @initial_position > 0 && @initial_position == len - 1 && len > 1
      @next = "last"
      @previous = @initial_position - 1
      logger.info("Cond3")
    elsif @initial_position > 0 && len > 1
      @next = @initial_position + 1
      @previous = @initial_position - 1
      logger.info("Cond4")
    end
    logger.info("previous = #{@previous}")
    logger.info("next = #{@next}")
    
    
    @contest_details = ContestDetail.find(params[:contest_id])
    @moment_details = UserContent.find(:all, :conditions => "id=#{momentid}")
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{momentid}'")
    @journal = Blog.find(:all, :conditions => "blog_type_id = #{momentid} and user_id=#{@moment_details[0].uid}")
    @contest_image="#{@moment_details[0].img_url}/user_content/photos/journal_thumb/#{@moment_details[0].v_filename}"
    entrants_name=@contests_fname[0].first_name
    if @contests_fname[0].moment_type=="image"
      cname="Photo"
    else
      cname="Video"
    end
    @contest_description = "Hello Friends!\n\nI have entered in HoldMyMemories.com #{@contest_details.name} #{cname} Contest. Please help #{entrants_name} to win by clicking on the above link and casting your vote!"
    @contest_title = "#{@contest_details.name} #{cname} Contest. Brought to you by HoldMyMemories.com."
    
    if !params[:navigate_id].nil? && !params[:navigate_id].blank? && params[:navigate_id] != "undefined"
      if params[:send_partial]
        render :partial => "journal", :locals => {:journal => @journal}
      elsif  params[:fb_partial]
        render :partial => "fb_vote", :locals => {:moment_details => @moment_details}
      else
        vote_link = "/contests/vote?contest_id=#{params[:contest_id]}&entry_id=#{@contests_fname[0].id}"
        
        render :json => {:moment_id => "#{momentid}", :previous => @previous, :next => @next, :img_url => @moment_details[0].img_url, :file_name => @moment_details[0].v_filename,
          :contestant_name => @contests_fname[0].first_name, :entry_date => @contests_fname[0].contest_entry_date.strftime("Submitted: %m/%d/%Y"), :votes => @contests_fname[0].votes,
          :vote_link => vote_link}
      end
    end

    if iphone_request?
      respond_to do |format|
        format.iphone do  # action.iphone.erb
        end
      end
    end
  end

  def momentdetails1
    if(params[:page]==nil || params[:page]=='')
      @counts =  Contest.count(:all, :conditions => " moment_type='image' and uid='#{logged_in_hmm_user.id}'  ",:order =>'first_name  asc')
      @allrecords =  Contest.find(:all, :conditions => " moment_type='image' and uid='#{logged_in_hmm_user.id}' " ,:order =>'first_name  asc')
      page=0
      #pp @allrecords
      for check in @allrecords
        page=page+1
        if("#{check.moment_id}" == "#{params[:id]}" )
          @nextpage=page
          puts "yes dude"
          redirect_to :action => :momentdetails1, :id=> params[:id], :page =>@nextpage
          #redirect_to :action => :momentdetails, :id=> params[:id], :page =>@nextpage
        else
          puts "#{check.moment_id} == #{params[:id]}"
          puts "\n"
        end
      end
    else
      #@user_content_pages, @user_content = paginate :contests, :conditions => "gallery_id='#{@usercontent.gallery_id}' and status='active'  #{eacess} ",:order =>'id desc', :per_page => 1
      @contest_cutekid_pages, @contest_cutekid = paginate :contests, :conditions => " moment_type='image' and uid='#{logged_in_hmm_user.id}' and contest_phase='phase'" ,:order =>'first_name  asc', :per_page => 1
    end
  end

  def momentdetails_old_contest
    @moment_details = UserContent.find(:all, :conditions => "id='#{params[:moment_id]}'")
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:moment_id]}'")
    #@journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{params[:id]} ")
    @journal = Blog.find(:all, :conditions => "blog_type_id = #{params[:moment_id]} and user_id=#{@moment_details[0].uid}")
  end
  
  def videomoment_details
    logger.info("hellllllllllllllllllllllllllllllllllllllllll");
    logger.info(params[:navigation_id]);
    sort_key = !params[:sort_key].nil? ? params[:sort_key] : "contest_entry_date"
    sort_order = !params[:sort_order].nil? ? params[:sort_order] : "desc"
    @sort = "#{sort_key}  #{sort_order}"
    
    if params[:navigate_id].nil?
      @contest_pair = Hash.new
      i = 0
      @contests =  Contest.find(:all, :select => "a.*, b.*, a.id as id, a.first_name as first_name" ,:joins=>"as a, user_contents as b",
        :conditions => "a.moment_id = b.id  and  a.moment_type = 'video' and a.status='active' and a.contest_phase='phase#{params[:contest_id]}'", :order => @sort)
      for contest in @contests
        position = i
        moment_id = contest.moment_id
        @contest_pair.store(position,"#{moment_id}")
        i = i + 1
        logger.info("{#{position} => #{moment_id}}")
      end
      session[:contest_pair1] = @contest_pair
    end
    @contest_pair = session[:contest_pair1]
    logger.info("*******HASH*************")
    logger.info @contest_pair.inspect
    len = @contest_pair.length
    if params[:moment_id].nil?
      momentid = @contest_pair.fetch(params[:navigate_id].to_i)
    else
      momentid = params[:moment_id]
    end
    @initial_position = @contest_pair.index(momentid)
    logger.info("@initial_position = #{@initial_position}")
    logger.info("len = #{len}")

    if @initial_position == 0 && len == 1
      @next = "last"
      @previous = "last"
      logger.info("Cond1")
    elsif @initial_position == 0 && len > 1
      @next = @initial_position + 1
      @previous = "last"
      logger.info("Cond2")
    elsif @initial_position > 0 && @initial_position == len - 1 && len > 1
      @next = "last"
      @previous = @initial_position - 1
      logger.info("Cond3")
    elsif @initial_position > 0 && len > 1
      @next = @initial_position + 1
      @previous = @initial_position - 1
      logger.info("Cond4")
    end
    logger.info("previous = #{@previous}")
    logger.info("next = #{@next}")
    logger.info("momentid=#{momentid}")
    logger.info(momentid)
    logger.info(params[:contest_id])


    @moment_details = UserContent.find(:all, :conditions => "id='#{momentid}'")
    @moment_details.each do |f|
      logger.info(f.v_filename)
      logger.info("#################333333333333333333333333333")
    end
    
    @contest_details= ContestDetail.find(params[:contest_id])
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{momentid}' and contest_phase='phase#{params[:contest_id]}'")
    logger.info(@contests_fname)
    logger.info("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    @journal = Blog.find(:all, :conditions => "blog_type_id = #{momentid} and user_id=#{@moment_details[0].uid}")
    @contest_image="#{@moment_details[0].img_url}/user_content/videos/thumbnails/#{@moment_details[0].v_filename}.jpg"
    entrants_name=@contests_fname[0].first_name
    logger.info(entrants_name)
    if @contests_fname[0].moment_type=="image"
      cname="Photo"
    else
      cname="Video"
    end
    @contest_description =  "Hello Friends!\n\nI have entered in HoldMyMemories.com #{@contest_details.name} #{cname} Contest. Please help #{entrants_name} to win by clicking on the above link and casting your vote!"
    @contest_title="#{@contest_details.name} #{cname} Contest. Brought to you by HoldMyMemories.com."
   
    if !params[:navigate_id].nil? && !params[:navigate_id].blank? && params[:navigate_id] != "undefined"
      if params[:send_partial]
        render :partial => "journal", :locals => {:journal => @journal}
     elsif  params[:video_partial]
       render :partial => "video_details", :locals => {:moment_details => @moment_details}
      elsif  params[:fb_partial]
        render :partial => "fb_vote", :locals => {:moment_details => @moment_details}
      else
        vote_link = "/contests/vote?contest_id=#{params[:contest_id]}&entry_id=#{@contests_fname[0].id}"

        render :json => {:moment_id => "#{momentid}", :previous => @previous, :next => @next, :img_url => @moment_details[0].img_url, :file_name => @moment_details[0].v_filename,
          :contestant_name => @contests_fname[0].first_name, :entry_date => @contests_fname[0].contest_entry_date.strftime("Submitted: %m/%d/%Y"), :votes => @contests_fname[0].votes,
          :vote_link => vote_link}
      end
    else
      logger.info("gogunraaaaaaaaaaaaaaa");
    end
    @moment_details.each do |f|
      logger.info(f.v_filename)
      logger.info("#################3333333333333333333333333355555555555555555555555555555555555555553")
    end

    if iphone_request?
      respond_to do |format|
        format.iphone do  # action.iphone.erb
        end
      end
    end
  end


    def video_details

      render :layout=>false
    end

    
  def videomoment_old_contest
    @moment_details = UserContent.find(:all, :conditions => "id='#{params[:moment_id]}'")
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:moment_id]}'")
    @journal = Blog.find(:all, :conditions => "blog_type_id = #{params[:moment_id]} and user_id=#{@moment_details[0].uid}")
  end

  def vote
    @mom_id = params[:moment_id]
    contest_id = params[:contest_id]
    entry_id = params[:entry_id]
    @contests_det = Contest.find(entry_id)
    @moment_details = UserContent.find(:all, :conditions => "id='#{@contests_det.moment_id}'")
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{@contests_det.moment_id}' and contest_phase='phase#{contest_id}'")
    @journal = Blog.find(:all, :conditions => "blog_type_id = #{@contests_det.moment_id} and user_id=#{@moment_details[0].uid}")
    @contest_image="#{@moment_details[0].img_url}/user_content/photos/journal_thumb/#{@moment_details[0].v_filename}"
    entrants_name=@contests_fname[0].first_name
    @contest_description =  "Hello Friends!\n\nI have entered in HoldMyMemories.com So Fabulous Seniors Photo Contest. Please help #{entrants_name} to win by clicking on the above link and casting your vote!"
    @contest_title="So Fabulous Seniors Photo Contest.Brought to you by HoldMyMemories.com."
    if iphone_request?
      respond_to do |format|
        format.iphone do  # action.iphone.erb
        end
      end
    else
      render :layout => false
    end
  end

  def create_vote
    #    if (session[:hmm_user].nil?)
    logger.info "*************params[:id]*****************"
    logger.info(params[:contest_id])
    logger.info "*************params[:id]*****************"
    @contest = Contest.find(params[:entry_id])
    @contest_details=ContestDetail.find(params[:contest_id])
    @uid = @contest.uid
    contestid = @contest.id
    contestfname = @contest.first_name
    moment_type = @contest.moment_type
    paths = ContentPath.find(:first,:conditions=>"status='active'")

    #working for thumb nail for e-mail
    momentid = @contest.moment_id
    @moment = UserContent.find(:all, :conditions => "id='#{momentid}'")
    for moment_name in @moment
      moment_filename = moment_name.v_filename
      moment_url = moment_name.img_url
    end

    #working for fname and lastname of cntestant
    @username = HmmUser.find(:all, :conditions => "id='#{@uid}'")
    for user in @username
      user_fname = user.v_fname
      user_lname = user.v_lname
      familyname = user.family_name
    end
    my_date_time = Date.today
    if my_date_time >= @contest_details.open_voting_start_date.to_date
      cond= "and vote_date = '#{my_date_time}'"
    else
      cond=''
    end
    logger.info(my_date_time)
    @contest_vote = ContestVotes.count(:all, :conditions => "contest_id = '#{contestid}' and email_id = '#{params[:email]}'  #{cond}")
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
      contestuuid = Share.find_by_sql("select uuid() as uid")
      unid = contestuuid[0].uid+""+"#{contestvote_next_id}"
      #inserting new values into contest vote table
      contest = ContestDetail.find(params[:contest_id])
      contest_name = contest.name
      contest_phase = contest.id
      @vote = ContestVotes.new()
      @vote['uid']=@uid
      @vote['contest_id'] = "#{contestid}"
      @vote['email_id'] = params[:email]
      @vote['vote_date'] = Time.now
      @vote['unid'] = unid
      if @vote.save
        $notice_vote1
        flash[:notice_vote] = 'Thank-you for casting your vote.  You will shortly receive an email verification that you must accept for your vote to be counted.  This helps us make sure that all votes are valid votes.  Your email address will not be shared with any other company.'
        Postoffice.deliver_voteconf(params[:email], contestid, unid, moment_filename, contestfname, user_fname, user_lname, moment_type, paths.proxyname, momentid, moment_url, contest_phase, contest_name)
        if iphone_request?
          redirect_to "/contests/select_contest"
        else
          if(moment_type=="video")
            redirect_to "/contests/videomoment_vote?contest_id=#{params[:contest_id]}"
          else
            redirect_to "/contests/moments_vote?contest_id=#{params[:contest_id]}"
          end
        end

      else
        $notice_vote
        flash[:notice_vote] = 'Your was not submitted due to technical issue... Please try again!!'
        if(moment_type=="video")
          redirect_to "/contests/videomoment_vote?contest_id=#{params[:contest_id]}"
        else
          redirect_to "/contests/moments_vote?contest_id=#{params[:contest_id]}"
        end
      end

    else
      $notice_vote
      flash[:notice_vote] = 'You have already voted for this moment.. you can cast your vote only once per family!!'
      if(moment_type=="video")
        redirect_to "/contests/videomoment_vote?contest_id=#{params[:contest_id]}"
      else
        redirect_to "/contests/moments_vote?contest_id=#{params[:contest_id]}"
      end
    end
  end

  def forgot_password

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
    flash[:conform_mesg] = "Your username and password have been sent to your email.."
    #redirect_to :action => 'conform'
  end

  def validate_email
    @message_email='';
    color = 'red'
    email = params[:email]
    mail = HmmUser.find_all_by_v_e_mail(email)
    if mail.size > 0
      @message_email = 'Email already registered.'
      @valid_email = false
      #    else
      #      @message_email = 'Email Authenticated'
      #      color = 'green'
      #      @valid_email = true

    end
    @message_email = "<b style='color:#{color}'>#{@message_email}</b>"
    render :layout=>false
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
    @contest_email_chk=0
    if(@contest_email_chk>0)
      $notice_voteconform
      logger.info("checkemail > 0")
      res = 'Our records indicate you have already voted for this entry.  Voters may only vote once per entry.  Thank-you for your vote! '
      flash[:notice_voteconform] = res
      redirect_to(:action => "conform_vote", :res => res)
    else
      logger.info("checkemail <= 0")
      @authenticate_vote_count = ContestVotes.count(:conditions => "unid='#{params[:id]}'")
      if @authenticate_vote_count == 1

        contest_votes = ContestVotes.find(:all, :conditions => "unid='#{params[:id]}'")
        contest_votes_check = ContestVotes.count(:all, :conditions => "unid='#{params[:id]}' and conformed='yes'")
        if(contest_votes_check > 0)
          logger.info("contest_votes_check > 0")
          $notice_voteconform
          res = "Our records indicate you have already confirmed your vote for this entry with email address #{contest_votes[0].email_id}.  Voters may only vote once per entry.  Thank-you for your vote!"
          flash[:notice_voteconform]=res
          redirect_to(:action => "conform_vote", :res => res)
        else
          #contest_votes[0].unid = "null"
          logger.info("contest_votes_check <= 0")
          contest_votes[0].conformed = 'yes'
          contest_votes[0].save
          @contest_vote_count = ContestVotes.count(:all, :conditions => "contest_id = '#{contest_votes[0].contest_id}' and conformed='yes'")
          countest_update = Contest.find(contest_votes[0].contest_id)
          countest_update.votes = @contest_vote_count
          countest_update.save

          #calculation for new votes
          @count = ContestVotes.count_by_sql("select COUNT(distinct CONCAT(IFNULL(email_id,''),IFNULL(hmm_voter_id,''))) AS COUNT from contest_votes where contest_id='#{contest_votes[0].contest_id}' and conformed='yes'")
          countest_update = Contest.find(contest_votes[0].contest_id)
          countest_update.new_votes = @count
          countest_update.save

          $notice_voteconform
          res  = 'Thank-you for your vote.'
          flash[:notice_voteconform] = res
          redirect_to :action => 'conform_vote', :res => res
        end
      else
        $notice_voteconform
        logger.info("@authenticate_vote_count != 1")
        res = 'Our records indicate you have already voted for this entry.  Voters may only vote once per entry.  Thank-you for your vote! '
        flash[:notice_voteconform] = res
        redirect_to(:action => "conform_vote", :res => res)
      end
    end
    if iphone_request?
      respond_to do |format|
        format.iphone do  # action.iphone.erb
        end
      end
    end
  end
  
  def contests_select
    @image_contest_count = Contest.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and moment_type = 'image'")
    @video_contest_count = Contest.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and moment_type = 'video'")
    @recent_entries = Contest.find_by_sql("SELECT a.*, b.* FROM contests as a, user_contents as b WHERE a.moment_id=b.id and a.moment_type = 'image' and a.status = 'active' order by a.new_votes desc limit 0,12")
  end

  def cutekid_conteste
    @recent_entries = Contest.find_by_sql("SELECT a.*, b.* FROM contests as a, user_contents as b WHERE a.moment_id=b.id and a.moment_type = 'image' and a.status = 'active' order by a.new_votes desc limit 0,12")
  end

  def previous_contest
    @winners = ContestWinner.find(:all, :select => "a.*, b.photo_logo, b.video_logo, b.heading_logo", :joins => "as a, contest_details as b", :conditions => "a.contest_phase = b.id", :order => "contest_phase desc")
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
    @contest_cutekid = Contest.paginate :per_page => items_per_page, :page => params[:page], :select =>  "a.*, b.*,c.v_image_comment,  a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b, journals_photos as c ",
      #@contest_cutekids_pages, @contest_cutekids = paginate :contests, :select => "a.*, b.*,c.v_image_comment,  a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b, journals_photos as c ", :per_page => items_per_page,
    :order => sort, :conditions => "#{conditions}"
  end

  def vote_cal
    @contest = Contest.find(params[:id])
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
          redirect_to :controller => "manage_site", :action => 'moments_vote', :id => familyname
        else if contest_typ == 'video'
            redirect_to :controller => "manage_site", :action => 'videomoment_vote', :id => familyname
          end
        end
      else
        $notice_vote
        flash[:notice_vote] = 'Your was not submitted due to technical issue... Please try again!!'
        if contest_typ == 'image'
          redirect_to :controller => "manage_site", :action => 'moments_vote', :id => familyname
        else if contest_typ == 'video'
            redirect_to :controller => "manage_site", :action => 'videomoment_vote', :id => familyname
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
    if params[:id] == 'photo'
      session[:contests_type] = 'image'
    else if params[:id] == 'video'
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
    require "contacts"
    @sites = { "gmail" => Contacts::Gmail, "yahoo" => Contacts::Yahoo}
    puts params[:login]
    puts params[:password]
    begin
      @contacts = @sites[params[:from]].new(params[:login], params[:password]).contacts
      @email_names = []
      @emails_list = []
      i=0
      for cnts in @contacts
        @email_names[i] = "#{cnts[0]}"
        @emails_list[i] = "#{cnts[1]}"
        i=i+1
      end
      pp @email_names
      logger.info("username and password matched ==  #{@contacts} == is wat we got")
    rescue
      logger.info("username and password do not match")
    end
    require 'pp'
  end

  def import_form

  end

  def revision

  end

  def vote_request
    if(params[:momentid])
      momentid = params[:momentid]
    else
      conturl = session[:vote_url].split('?')
      momentids=conturl[0].split('/')
      momentid=momentids[5]
    end
    @contest_select = Contest.find(:all, :conditions => "moment_id='#{params[:momentid]}'")
    kidsname = "#{@contest_select[0]['first_name']}"
    moment = UserContent.find(:all, :conditions => "id='#{params[:momentid]}'")
    momenttype = moment[0]['e_filetype']
    filename = moment[0]['v_filename']
    contenturl = moment[0]['img_url']
    res_emails=""
    if(params[:email_id])
      for emails in params[:email_id]
        res_emails=res_emails + "#{emails},"
      end
      res_emails = "#{res_emails}" + "nomail@noemail.com"

      vote_url = "#{session[:vote_url]}"
      email = "#{res_emails}"
      mesg = params[:message]
      puts momenttype
      Postoffice.deliver_votereq_mail(email,vote_url,mesg,momenttype,momentid,filename,contenturl,kidsname)
      $notice_invite1
      flash[:notice_invite1] = ''
    end
    redirect_to  "#{session[:vote_url]}"
  end

  def validate_babyname
    firstname = params[:firstname]
    baby = Contest.count(:all, :conditions => "first_name='#{firstname}' and contest_phase='#{seniorcontest_phase}' and moment_type='#{params[:id]}'")
    if baby > 0
      message_baby = 'Name Is Already Registered'
      color = 'red'
      @valid_username = false
    else
      message_baby = 'Name Is Available'
      color = 'green'
      @valid_username=true
    end
    @message_baby = "<b style='color:#{color}'>#{message_baby}</b>"
    render :partial=>'message_baby' , :layout => false
  end

  #entrants
  def moments_entrants
    @current_page = 'contest'
    items_per_page = 12

    sort_init 'contest_entry_date'
    sort_update

    srk=params[:sort_key]
    @sort="#{srk}  #{params[:sort_order]}"
    @sort1="desc"
    @sort2="desc"
    if(srk==nil)
      #@sort="contest_entry_date  desc"
      @sort="votes  desc"
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

    if(srk == 'votes')
      @sort2="desc"
      if params[:sort_order] == 'desc'
        @sort2="asc"
      else
        @sort2="desc"
      end
    end

    if(srk == 'first_name')
      @sort3="desc"
      if params[:sort_order] == 'desc'
        @sort3="asc"
      else
        @sort3="desc"
      end
    end
    @contest_memoriable = Contest.find(:all, :conditions => "moment_type = 'image' and contest_phase='phase#{params[:contest_id]}'")
    if (params[:query].nil?)
      conditions = "a.moment_id = b.id and a.moment_type = 'image' and a.status = 'active' and a.contest_phase='phase#{params[:contest_id]}'"
    else
      conditions = "a.moment_id = b.id and a.moment_type = 'image' and a.status = 'active' and ( a.first_name like '#{params[:query]}%' or c.v_image_comment like '%#{params[:query]}%') and a.contest_phase='phase#{params[:contest_id]}' "
    end
    @contest_cutekid = Contest.paginate :per_page => items_per_page, :page => params[:page], :select => "a.*, b.*, a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b",
      :conditions => "#{conditions}", :order => @sort ,:group =>"a.id"
  end

  def videomoment_entrants
    @current_item = 'contest'
    items_per_page = 6
    sort_init 'contest_entry_date'
    sort_update

    srk=params[:sort_key]
    @sort="#{srk}  #{params[:sort_order]}"
    @sort1="desc"
    @sort2="desc"
    if(srk==nil)
      #@sort="contest_entry_date  desc"
      @sort="votes  desc"
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

    if(srk == 'votes')
      @sort2="desc"
      if params[:sort_order] == 'desc'
        @sort2="asc"
      else
        @sort2="desc"
      end
    end

    if(srk == 'first_name')
      @sort3="desc"
      if params[:sort_order] == 'desc'
        @sort3="asc"
      else
        @sort3="desc"
      end
    end
    @contest_memoriable = Contest.find(:all, :conditions => "moment_type='video' and contest_phase='phase#{params[:contest_id]}'")
    if (params[:query].nil?)
      conditions = "a.moment_id = b.id  and  a.moment_type = 'video' and a.status='active' and a.contest_phase='phase#{params[:contest_id]}'"
    else
      conditions = "a.moment_id = b.id   and  a.moment_type = 'video' and a.status='active' and ( a.first_name like '#{params[:query]}%' and a.contest_phase='phase#{params[:contest_id]}'"

    end
    @contest_cutekid = Contest.paginate :per_page => items_per_page, :page => params[:page], :select => "a.*, b.*, a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b",
      :conditions => "#{conditions}", :order => @sort ,:group=>"a.id"
  end

  #Sample Page
  def hmm_contest_cutekid2010
    @recent_entries = Contest.find_by_sql("SELECT a.*, b.* FROM contests as a, user_contents as b WHERE a.moment_id=b.id and a.moment_type = 'image' and a.status = 'active' and a.contest_phase='2' order by a.new_votes desc limit 0,12")
  end

  def facebook_share
    @momid=params[:id]
    @moment_details = UserContent.find(:all, :conditions => "id='#{params[:id]}'")
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:id]}'")
    #@journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{params[:id]} ")
    @journal = Blog.find(:all, :conditions => "blog_type_id = #{params[:id]} and user_id=#{@moment_details[0].uid}")
    @contest_image="#{@moment_details[0].img_url}/user_content/photos/journal_thumb/#{@moment_details[0].v_filename}"
    entrants_name=@contests_fname[0].first_name
    @contest_description =  "Hello Friends!\n\nI have entered in HoldMyMemories.com All Glammed Up Photo Contest. Please help #{entrants_name} to win by clicking on the above link and casting your vote!"
    @contest_title="All Glammed Up Photo Contest.Brought to you by HoldMyMemories.com."
  end
  def hmm_contest_new

  end
  def enter_contest
    render :layout =>false
  end

  def share_facebook
    @continfo = Contest.find(:first,:conditions =>"id=#{params[:cid]}")
    @momentinfo = UserContent.find(:first,:conditions =>"id='#{@continfo.moment_id}'")
    @contest_image = "#{@momentinfo.img_url}/user_content/photos/journal_thumb/#{@momentinfo.v_filename}"
    entrants_name = @continfo.first_name
    contestname = ContestDetail.find(params[:contest_id])
    @contest_description =  "Hello Friends!\n\nI have entered in HoldMyMemories.com #{contestname.name} #{@continfo.moment_type.capitalize} Contest Please help #{entrants_name} to win by clicking on the above link and casting your vote!"
    @contest_title = "#{contestname.name} #{@continfo.moment_type.capitalize} Contest.Brought to you by HoldMyMemories.com."
  end
  
  def share_via_email
    share = ContestShare.new()
    share['share_type'] = 'email'
    share['contest_id'] =  params[:cid]
    share['contest_id'] =  params[:cid]
    share.save
    @contests_det = Contest.find(params[:cid])
    @moment_details = UserContent.find(:all, :conditions => "id='#{@contests_det.moment_id}'")
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{@contests_det.moment_id}' and contest_phase='phase#{params[:contest_id]}'")
  end

  def share_via_email_sub
    @contest = Contest.find(params[:mom_id])
    @uid = @contest.uid
    contetsid = @contest.id
    contetsfname = @contest.first_name
    moment_type = @contest.moment_type
    paths=ContentPath.find(:first,:conditions=>"status='active'")
    #working for thumb nail for e-mail
    momentid = @contest.moment_id
    @moment = UserContent.find(:all, :conditions => "id='#{momentid}'")
    for moment_name in @moment
      moment_filename = moment_name.v_filename
      moment_url = moment_name.img_url
    end

    #working for fname and lastname of cntestant
    @username = HmmUser.find(:all, :conditions => "id='#{@uid}'")
    for user in @username
      user_fname = user.v_fname
      user_lname = user.v_lname
      familyname = user.family_name
      user_email = user.v_e_mail
    end

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
    contestuuid = Share.find_by_sql("select uuid() as uid")
    unid = contestuuid[0].uid+""+"#{contestvote_next_id}"
    #inserting new values into contest vote table
    contest = ContestDetail.find(params[:contest_id])
    contest_phase = contest.id
    contest_name = contest.name
    $notice_vote1
    flash[:notice_vote] = 'Thank-you for casting your vote.  You will shortly receive an email verification that you must accept for your vote to be counted.  This helps us make sure that all votes are valid votes.  Your email address will not be shared with any other company.'
    Postoffice.deliver_shareviaemail(params[:email], user_email, contetsid, unid, moment_filename, contetsfname, user_fname, user_lname, moment_type, params[:view], paths.proxyname, momentid,moment_url,contest_phase,contest_name)

    redirect_to :action => 'thank_you_sharing'
  end

  def thank_you_sharing
    logger.info("hai")

  end

  def vote_facebook
  end

  def create_sharecount
    share = ContestShare.new()
    share['share_type'] = params[:from]
    share['contest_id'] =  params[:id]
    share.save
    render :layout =>false
  end

  def fblike
    render :layout =>false
  end

  def like

  end

  def s121_facebook_like
    if params[:id]
      @add_count = CreditFacebookCount.new
      @add_count['hmm_user_id'] = params[:id]
      @add_count.save
    end
  end

  def s121_facebook_fblike
    render :layout =>false
  end

  def select_contest
    cur_date = Date.today
    @contests = ContestDetail.find(:all,:conditions=>"start_date<'#{cur_date}' and end_date>'#{cur_date}'")
 
    if iphone_request?
      respond_to do |format|
        format.iphone do  # action.iphone.erb
        end
      end
    end
  end

  def iphone_contest
  end

  def specific_rules
    render :layout =>false
  end

  def rules
    if iphone_request?
      respond_to do |format|
        format.iphone do  # action.iphone.erb
        end
      end
    end
  end

  def ruleslist
    @contest = ContestDetail.find(params[:contest_id])
    if iphone_request?
      respond_to do |format|
        format.iphone do  # action.iphone.erb
        end
      end
    else
      render :layout=>false
    end
  end

  def submit_entry
    @moment_id=params[:moment_id]
    @moment_type=params[:moment_type]
    @user_id=params[:user_id]
    @contest_details = ContestDetail.find(params[:contest_id])
    @user_data = UserContent.find(params[:moment_id])
    @journal  = JournalsPhoto.find(:first, :conditions => "user_content_id = #{params[:moment_id]}")
    if iphone_request?
      respond_to do |format|
        format.iphone do  # action.iphone.erb
        end
      end
    end
  end

  private

  def phone_or_desktop
    iphone_request? ? "iphone_application" : "application"
  end

end
