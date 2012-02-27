class FamilywebsiteHomeController < ApplicationController
  layout 'familywebsite'
  include FamilywebsiteHomeHelper
  include SortHelper
  helper :sort
  require 'will_paginate'
  require 'cgi'

  before_filter  :check_account,:redirect_url #checks for valid family name, terms of use check and user block check

  #method to check whether the family name in the url is valid or invalid
  #if family name doesn't exist, redirects to hmm home page
  #if user is blocked, displays message
  #if user didn't agee for terms of use,
  # => if the user is not logged in, takes to login page
  # => if the user is logged in, takes to agree terms page

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

  def intro
    @current_page = 'contest'
    @contest_details=ContestDetail.find_by_id(14)
    #redirect_to :action => 'previous_contest'
    #@recent_entries = Contest.find_by_sql("SELECT a.*, b.* FROM contests as a, user_contents as b WHERE a.moment_id=b.id and a.moment_type = 'image' and a.status = 'active' and a.contest_phase='#{contest_phase}' and a.age_groups='0-2' order by a.votes desc limit 2")
    #redirect_to :action => 'previous_contest'
    #@recent_entries = Contest.find_by_sql("SELECT a.*, b.* FROM contests as a, user_contents as b WHERE a.moment_id=b.id and a.moment_type = 'image' and a.status = 'active' and a.contest_phase='#{contest_phase}' and a.age_groups='0-2' order by a.votes desc limit 2")
    @topentries_photo_0_to_2 = Contest.find(:all,:select => "a.*, b.*, a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b",
      :conditions => "a.moment_id = b.id and a.moment_type = 'image' and a.contest_phase='#{contest_phase}' and a.status='active' ", :order => "a.votes desc", :limit =>"10")
    logger.info(@topentries_photo_0_to_2.inspect)

    @topentries_photo = Array.new
    @topentries_photo_0_to_2.each do |photo|
      @topentries_photo << photo
    end

    @topentries_video_0_to_2 = Contest.find(:all,:select => "a.*, b.*, a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b",
      :conditions => "a.moment_id = b.id and a.moment_type = 'video' and a.contest_phase='#{contest_phase}' and a.status='active'", :order => "a.votes desc", :limit =>"10")

    @topentries_video = Array.new
    @topentries_video_0_to_2.each do |video|
      @topentries_video << video
    end
    logger.info "==================="
    logger.info @topentries_video.inspect


  end

  def manage_intro
    @current_item = 'contest'
  end

  def terms_conditions
    params[:contest]=CGI.escapeHTML(params[:contest])
    @current_page = 'contest'
    if params[:contest] == "video"
      @type = params[:contest]
      session[:contests_type] = "video"
    else params[:contest] == "photo"
      @type = params[:contest]
      session[:contests_type] = "image"
    end
  end

  def manage_terms_conditions
    @current_item = 'contest'
    if params[:contest] == "video"
      @type = params[:contest]
      session[:contests_type] = "video"
    else params[:contest] == "photo"
      @type = params[:contest]
      session[:contests_type] = "image"
    end
  end

  def contest_login
    params[:contest]=CGI.escapeHTML(params[:contest])
    params[:category]=CGI.escapeHTML(params[:category])
    @current_page = 'contest'
    if session[:hmm_user]
      @hmm_user=HmmUser.find(session[:hmm_user])
      if params[:contest] == "memorable"
        @type = params[:contest]
        session[:contests_type] = "video"
      else params[:contest] == "photo"
        @type = params[:contest]
        session[:contests_type] = "image"
      end
      redirect_to "/#{familywebsite_controller_name}/contest_chapter/#{@hmm_user.family_name}"
    end
    #render :layout => true
  end

  def authenticate_contestlogin
    @current_page = 'contest'
    #creating contest type session
    if params[:contest] == "video"
      @type = params[:contest]
      session[:contests_type] = "video"
    else params[:contest] == "photo"
      @type = params[:contest]
      session[:contests_type] = "image"
    end
    #redirect_to index_url+'account/'
    self.logged_in_hmm_user = HmmUser.authenticate(params[:username],params[:password])
    #self.logged_in_hmm_user = HmmUser.authenticate("alok","alok")
    if is_userlogged_in?
      if logged_in_hmm_user.e_user_status == 'unblocked'
        #log file entry
        logger.info("[User]: #{params[:username]} [Logged In] at #{Time.now} !")

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
                redirect_to "/account_settings/upgrade_account_form/#{params[:id]}?acc_type=platinum_account&option=1"
              else
                #session[:flag]=''
                if(logged_in_hmm_user.family_name=='' || logged_in_hmm_user.family_name==nil)
                  @uuid =  HmmUser.find_by_sql(" select UUID() as u")
                  unnid = @uuid[0]['u']
                  hmmuser_family = HmmUser.find(logged_in_hmm_user.id)
                  hmmuser_family.family_name="#{logged_in_hmm_user.id}#{unnid}un#{logged_in_hmm_user.id}"
                  hmmuser_family.save
                  redirect_to :controller=>familywebsite_controller_name,:action=>'contest_chapter',:id=>logged_in_hmm_user.family_name, :contest => params[:contest]
                else
                  if(logged_in_hmm_user.msg=='0')
                    redirect_to :controller=>familywebsite_controller_name,:action=>'contest_chapter',:id=>logged_in_hmm_user.family_name, :contest => params[:contest]
                  else
                    redirect_to :controller=>familywebsite_controller_name,:action=>'contest_chapter',:id=>logged_in_hmm_user.family_name, :contest => params[:contest]
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
      logger.error("[Invalid Login]: by [User]:#{params[:username]} at #{Time.now}")
      redirect_to :action => 'contest_login', :id=> params[:id], :contest => params[:contest]
      return "false"
    end


  end


  def moments_vote
    params[:sort_key]=CGI.escapeHTML(params[:sort_key])
    params[:sort_order]=CGI.escapeHTML(params[:sort_order])
    params[:page]=CGI.escapeHTML(params[:page])
    params[:query]=CGI.escapeHTML(params[:query])
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

    @contest_memoriable = Contest.find(:all, :conditions => "moment_type = 'image' and contest_phase='#{contest_phase}'")
    if  params[:query]
      if params[:query].match("%3C") ||  params[:query].length > 50
        special=1
      else
        special=0
      end
    else
      special=0
    end
    logger.info("Special:#{special}")
    if special==1
      redirect_to "/nonexistent_page.html"
    end

    if (params[:query].nil?)
      conditions = "a.moment_id = b.id and a.moment_type = 'image' and a.status = 'active'  and a.contest_phase='#{contest_phase}'"
    else
      params[:query] = (params[:query].gsub("'","")).gsub('"',"")
      conditions = "a.moment_id = b.id and a.moment_type = 'image' and a.status = 'active' and ( a.first_name like '#{params[:query]}%') and a.contest_phase='#{contest_phase}'"
    end
    @contest_cutekid = Contest.paginate :per_page => items_per_page, :page => params[:page], :select => "a.*, b.*, a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b",
      :conditions => "#{conditions}", :order => @sort,:group=>"a.id"
  end

  def manage_moments_vote
    @current_item = 'contest'
    items_per_page = 12

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

    @contest_memoriable = Contest.find(:all, :conditions => "moment_type = 'image' and contest_phase='#{contest_phase}'")
    if (params[:query].nil?)
      conditions = "a.moment_id = b.id and a.moment_type = 'image' and a.status = 'active' and a.contest_phase='#{contest_phase}'"
    else
      params[:query] = (params[:query].gsub("'","")).gsub('"',"")
      conditions = "a.moment_id = b.id and a.moment_type = 'image' and a.status = 'active' and ( a.first_name like '#{params[:query]}%') and a.contest_phase='#{contest_phase}'"
    end
    @contest_cutekid = Contest.paginate :per_page => items_per_page, :page => params[:page], :select => "a.*, b.*, a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b ",
      :conditions => "#{conditions}", :order => @sort,:group=>"a.id"
  end




  def vote
    @current_page = 'contest'
    @mom_id = params[:contest_id]
    @contests_det = Contest.find(params[:contest_id])
    @moment_details = UserContent.find(:all, :conditions => "id='#{@contests_det.moment_id}'")
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{@contests_det.moment_id}'")
    #@journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{@contests_det.moment_id} ")
    @journal = Blog.find(:all, :conditions => "blog_type_id = #{@contests_det.moment_id} and user_id=#{@moment_details[0].uid}")
    render :layout => false
  end

  def create_vote
    @current_page = 'contest'
    if (session[:hmm_user].nil?)
      @contest = Contest.find(params[:contest_id])
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
      end
      my_date_time = Date.today
      if my_date_time >= open_voting_start_date.to_date
        cond= "and vote_date = '#{my_date_time}'"
      else
        cond=''
      end
      @contest_vote = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and email_id = '#{params[:email]}'  #{cond}")
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
          Postoffice.deliver_kidsvoteconform(params[:email],contetsid,unid,moment_filename,contetsfname,user_fname,user_lname,moment_type,paths.proxyname,momentid,moment_url,contest_phase)
          if(moment_type=="video")
            redirect_to :controller => "#{familywebsite_controller_name}", :action => 'videomoment_vote',:id => params[:id]
          else
            redirect_to :controller => "#{familywebsite_controller_name}", :action => 'moments_vote',:id => params[:id]
          end
        else
          $notice_vote
          flash[:notice_vote] = 'Your was not submitted due to technical issue... Please try again!!'
          if(moment_type=="video")
            redirect_to :controller => "#{familywebsite_controller_name}",:action => 'videomoment_vote',:id => params[:id]
          else
            redirect_to :controller => "#{familywebsite_controller_name}",:action => 'moments_vote',:id => params[:id]
          end
        end

      else
        $notice_vote
        flash[:notice_vote] = 'You have already voted for this moment.. you can cast your vote only once per family!!'
        if(moment_type=="video")
          redirect_to :controller => "#{familywebsite_controller_name}", :action => 'videomoment_vote',:id => params[:id]
        else
          redirect_to :controller => "#{familywebsite_controller_name}", :action => 'moments_vote',:id => params[:id]
        end
      end
    else
      redirect_to :action => 'vote_cal', :id => params[:id], :contest_id => params[:contest_id]
    end
  end


  def vote_cal
    @current_page = 'contest'
    @contest = Contest.find(params[:contest_id])
    familyname=params[:id]
    @uid = @contest.uid
    contetsid = @contest.id
    contest_typ = @contest.moment_type
    my_date_time = Date.today
    if my_date_time >= open_voting_start_date.to_date
      cond= "and vote_date = '#{my_date_time}'"
    else
      cond=''
    end
    @contest_vote1 = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and hmm_voter_id = '#{logged_in_hmm_user.id}' #{cond}")
    @contest_vote2 = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and email_id = '#{logged_in_hmm_user.v_e_mail}' #{cond}")
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
          redirect_to  :action => 'moments_vote', :id => params[:id]
        else if contest_typ == 'video'
            redirect_to  :action => 'videomoment_vote', :id => params[:id]
          end
        end
      else
        $notice_vote
        flash[:notice_vote] = 'Your was not submitted due to technical issue... Please try again!!'
        if contest_typ == 'image'
          redirect_to  :action => 'moments_vote', :id => params[:id]
        else if contest_typ == 'video'
            redirect_to  :action => 'videomoment_vote', :id => params[:id]
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


  def manage_vote
    @current_item = 'contest'
    @mom_id = params[:contest_id]
    @contests_det = Contest.find(params[:contest_id])
    @moment_details = UserContent.find(:all, :conditions => "id='#{@contests_det.moment_id}'")
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{@contests_det.moment_id}'")
    #@journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{@contests_det.moment_id} ")
    @journal = Blog.find(:all, :conditions => "blog_type_id = #{@contests_det.moment_id} and user_id=#{@moment_details[0].uid}")
    render :layout => false
  end


  def manage_create_vote
    @current_item = 'contest'
    logger.info(params[:email])
    logger.info("hai")
    if (session[:hmm_user].nil?)
      logger.info("hai")
      @contest = Contest.find(params[:contest_id])
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
      end
      my_date_time = Date.today
      if my_date_time >= open_voting_start_date.to_date
        cond= "and vote_date = '#{my_date_time}'"
      else
        cond=''
      end
      @contest_vote = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and email_id = '#{params[:email]}' #{cond}")
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
          Postoffice.deliver_voteconform(params[:email],contetsid, unid,moment_filename,contetsfname,user_fname,user_lname,moment_type,paths.proxyname,momentid,moment_url)
          if(moment_type=="video")
            redirect_to :controller => "#{familywebsite_controller_name}", :action => 'manage_videomoment_vote',:id => params[:id]
          else
            redirect_to :controller => "#{familywebsite_controller_name}", :action => 'manage_moments_vote',:id => params[:id]
          end
        else
          $notice_vote
          flash[:notice_vote] = 'Your was not submitted due to technical issue... Please try again!!'
          if(moment_type=="video")
            redirect_to :controller => "#{familywebsite_controller_name}",:action => 'manage_videomoment_vote',:id => params[:id]
          else
            redirect_to :controller => "#{familywebsite_controller_name}",:action => 'manage_moments_vote',:id => params[:id]
          end
        end

      else
        $notice_vote
        flash[:notice_vote] = 'You have already voted for this moment.. you can cast your vote only once per family!!'
        if(moment_type=="video")
          redirect_to :controller => "#{familywebsite_controller_name}", :action => 'manage_videomoment_vote',:id => params[:id]
        else
          redirect_to :controller => "#{familywebsite_controller_name}", :action => 'manage_moments_vote',:id => params[:id]
        end
      end
    else
      redirect_to :action => 'manage_vote_cal', :id => params[:id], :contest_id => params[:contest_id]
    end
  end

  def manage_vote_cal
    @current_item = 'contest'
    @contest = Contest.find(params[:contest_id])
    familyname=params[:id]
    @uid = @contest.uid
    contetsid = @contest.id
    contest_typ = @contest.moment_type
    my_date_time = Date.today
    if my_date_time >= open_voting_start_date.to_date
      cond= "and vote_date = '#{my_date_time}'"
    else
      cond=''
    end
    @contest_vote1 = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and hmm_voter_id = '#{logged_in_hmm_user.id}' #{cond}")
    @contest_vote2 = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and email_id = '#{logged_in_hmm_user.v_e_mail}' #{cond}")
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
          redirect_to  :action => 'manage_moments_vote', :id => params[:id]
        else if contest_typ == 'video'
            redirect_to  :action => 'manage_videomoment_vote', :id => params[:id]
          end
        end
      else
        $notice_vote
        flash[:notice_vote] = 'Your was not submitted due to technical issue... Please try again!!'
        if contest_typ == 'image'
          redirect_to  :action => 'manage_moments_vote', :id => params[:id]
        else if contest_typ == 'video'
            redirect_to  :action => 'manage_videomoment_vote', :id => params[:id]
          end
        end
      end

    else
      $notice_vote
      flash[:notice_vote] = 'You have already voted for this moment.. you can cast your vote only once per family!!'
      if contest_typ == 'image'
        redirect_to :action => 'manage_moments_vote', :id => familyname
      else if contest_typ == 'video'
          redirect_to :action => 'manage_videomoment_vote', :id => familyname
        end
      end
    end

  end


  def videomoment_vote
    @current_page = 'contest'
    items_per_page = 6
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

    #@contest_cutekid = Contest.find(:all, :joins => "as a, user_contents as b", :conditions => "a.moment_id = b.id and a.contest_title = 'Cute Kid Contest'")
    @contest_memoriable = Contest.find(:all, :conditions => "moment_type='video' and contest_phase='#{contest_phase}'")
    if (params[:query].nil?)
      conditions = "a.moment_id = b.id  and  a.moment_type = 'video' and a.status='active' and a.contest_phase='#{contest_phase}'"
    else
      params[:query] = (params[:query].gsub("'","")).gsub('"',"")
      conditions = "a.moment_id = b.id   and  a.moment_type = 'video' and a.status='active' and ( a.first_name like '#{params[:query]}%') and a.contest_phase='#{contest_phase}'"

    end
    @contest_cutekid = Contest.paginate :per_page => items_per_page, :page => params[:page], :select => "a.*, b.*, a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b",
      :conditions => "#{conditions}", :order => @sort,:group=>"a.id"

  end

  def manage_videomoment_vote
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

    #@contest_cutekid = Contest.find(:all, :joins => "as a, user_contents as b", :conditions => "a.moment_id = b.id and a.contest_title = 'Cute Kid Contest'")
    @contest_memoriable = Contest.find(:all, :conditions => "moment_type='video' and contest_phase='#{contest_phase}'")
    if (params[:query].nil?)
      conditions = "a.moment_id = b.id  and  a.moment_type = 'video'  and a.status='active' and a.contest_phase='#{contest_phase}'"
    else
      params[:query] = (params[:query].gsub("'","")).gsub('"',"")
      conditions = "a.moment_id = b.id   and  a.moment_type = 'video'  and a.status='active' and ( a.first_name like '#{params[:query]}%') and a.contest_phase='#{contest_phase}'"

    end
    @contest_cutekid = Contest.paginate :per_page => items_per_page, :page => params[:page], :select => "a.*, b.*, a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b ",
      :conditions => "#{conditions}", :order => @sort,:group=>"a.id"

  end

  def momentdetails
    @current_page = 'contest'
    @moment_details = UserContent.find(:all, :conditions => "id='#{params[:contest_id]}'")
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:contest_id]}'")
    #@journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{params[:id]} ")
    @journal = Blog.find(:all, :conditions => "blog_type_id = #{params[:contest_id]} and user_id=#{@moment_details[0].uid}")

  end

  def momentdetails_old_contest
    @current_page = 'contest'
    @moment_details = UserContent.find(:all, :conditions => "id='#{params[:contest_id]}'")
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:contest_id]}'")
    #@journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{params[:id]} ")
    @journal = Blog.find(:all, :conditions => "blog_type_id = #{params[:contest_id]} and user_id=#{@moment_details[0].uid}")

  end

  def manage_momentdetails
    @current_item = 'contest'
    if(params[:page]==nil || params[:page]=='' || params[:hmm]==nil)
      @counts =  Contest.count(:all, :conditions => " moment_type='image' and status='active' and contest_phase='#{contest_phase}'",:order =>'first_name  asc')
      @allrecords =  Contest.find(:all, :conditions => " moment_type='image' and status='active'and contest_phase='#{contest_phase}'" ,:order =>'first_name  asc')
      page=0

      @user_content =Contest.paginate  :per_page => 1, :page => params[:page], :conditions => "moment_type='image' and status='active' and contest_phase='#{contest_phase}'",:order =>'first_name  asc'
      #@contest_cutekid = Contest.paginate :per_page => 1, :page => params[:page], :conditions => " moment_type='image' and status='active'" ,:order =>'first_name  asc'

    end
  end

  def videomoment_details
    @current_page = 'contest'
    @moment_details = UserContent.find(:all, :conditions => "id='#{params[:contest_id]}'")
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:contest_id]}'")
    @journal = Blog.find(:all, :conditions => "blog_type_id = #{params[:contest_id]} and user_id=#{@moment_details[0].uid}")
    #render :layout => true
  end

  def videodetails_old_contest
    @current_page = 'contest'
    @moment_details = UserContent.find(:all, :conditions => "id='#{params[:contest_id]}'")
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:contest_id]}'")
    #@journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{params[:contest_id]} ")
    @journal = Blog.find(:all, :conditions => "blog_type_id = #{params[:contest_id]} and user_id=#{@moment_details[0].uid}")
    #render :layout => true
  end

  def manage_videomoment_details
    @current_item = 'contest'
    @moment_details = UserContent.find(:all, :conditions => "id='#{params[:contest_id]}'")
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:contest_id]}'")
    #@journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{params[:contest_id]} ")
    @journal = Blog.find(:all, :conditions => "blog_type_id = #{params[:contest_id]} and user_id=#{@moment_details[0].uid}")
    #render :layout => true
  end

  #contest section


  def contest_terms_conditions
    @current_page = 'contest'
    if params[:contest] == "memorable"
      @type = params[:contest]
      session[:contests_type] = "video"
    else params[:contest] == "cutekid"
      @type = params[:contest]
      session[:contests_type] = "image"
    end
  end

  def contest_chapter
    @current_page = 'contest'
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
    if session[:contests_type] == 'image'
      @album_list = 'photo'
    else
      @album_list = 'video'
    end
    @tags_pages  = Tag.paginate :per_page => items_per_page,:page => params[:page], :order => sort, :conditions => "uid='#{uid}' and status='active' and (tag_type ='#{@album_list}' or tag_type = 'chapter') " # ,:order => " #{@sort.to_s} #{@order.to_s} "

    if request.xml_http_request?
      render :partial => "chapters_list", :layout => false
    end
  end

  def contest_sub_chapter
    @current_page = 'contest'
    sort_init 'd_updated_on'
    sort_update
    if(!params[:tagid].nil?)
      session[:tag_id]=params[:tagid]
    else

      params[:tagid]= session[:tag_id]
    end
    if(!params[:tagtype].nil?)
      session[:tagtype]=params[:tagtype]
    else
      params[:tagtype]=session[:tagtype]
    end

    @chapter_belongs_to=Tag.find_by_sql("select a.*,b.* from tags as a,  hmm_users as b where a.id='#{params[:tagid]}' and  a.uid=b.id")


    @hmm_user=HmmUser.find(session[:hmm_user])
    items_per_page = 9
    conditions = ["v_tagname LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?


    uid=logged_in_hmm_user.id

    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="id  desc"
    end

    if (params[:tagtype]=='chapter')

      @subchaps = SubChapter.paginate :per_page => items_per_page,:page => params[:page], :order => sort, :conditions => "tagid=#{params[:tagid]} and status='active' " # ,:order => " #{@sort.to_s} #{@order.to_s} "
      # @sub_chapters_pages, @sub_chapters = paginate :sub_chapters ,  :per_page => items_per_page, :conditions => "tagid=#{params[:tagid]} and status='active' " , :order => sort #:order => " #{@sort.to_s} #{@order.to_s} "
      countcheck=SubChapter.count(:all,:conditions => "tagid=#{params[:tagid]} and status='active'")

      @chapter_journal = ChapterJournal.find(:all, :conditions => "tag_id=#{params[:tagid]}", :order=>"id DESC")
      @tagid = ChapterJournal.find(:all, :conditions => "tag_id=#{params[:tagid]}")
      @chap_cnt = ChapterJournal.count(:all, :conditions => "tag_id=#{params[:tagid]}")
      @tag = Tag.find(params[:tagid])
      session[:chap_id]=params[:tagid]
      session[:chap_name]=@tag['v_tagname']
      #  if request.xml_http_request?
      #      render :partial => "chapter_next", :layout => false
      #  end
      @subchapter = SubChapter.find(:all, :conditions => "tagid=#{params[:tagid]} and status='active' ")
      @hmmuser = HmmUser.find(:all, :conditions => "id='#{uid}'")
      puts @subchapter[0]['id']
      if(countcheck==1)
        gallery = Galleries.find(:all,:conditions=>"subchapter_id='#{@subchapter[0]['id']}'")
        redirect_to :controller => "#{familywebsite_controller_name}" , :action => 'contest_gallery', :id => @hmmuser[0]['family_name'], :subchapid => @subchapter[0]['id']

      end
    else
      @content_count =UserContent.count(:all, :conditions => "tagid='#{params[:tagid]}'")
      puts @content_count
      if(@content_count >0)
        @gallery_id = UserContent.find(:first, :conditions => "tagid=#{params[:tagid]}").gallery_id
        redirect_to :controller=>familywebsite_controller_name , :action=>'contest_moments' ,:id =>params[:id],:moment_id => @gallery_id
      else
        flash[:notice] = 'You have no moments'
        @tag_id = params[:tagid]
        redirect_to :controller=>familywebsite_controller_name , :action=>'no_moments' ,:id =>params[:id],:moment_id => 0
      end
    end




  end

  def no_moments
    @current_page = 'contest'
  end



  def contest_gallery
    @current_page = 'contest'
    sort_init 'd_updated_on'
    sort_update
    session[:sub_id]=params[:subchapid]
    @hmm_user=HmmUser.find(session[:hmm_user])
    items_per_page = 9
    if(!params[:subchapid].nil?)
      session[:subchapid]=params[:subchapid]
    else

      params[:subchapid]= session[:subchapid]
    end
    galery_id=params[:subchapid]
    conditions = ["v_tagname LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"
    if( srk==nil)
      sort="id  desc"
    end
    #    @sub_chapters_galleries_pages, @sub_chapters_gallerie = paginate :galleriess , :order => sort, :per_page => items_per_page, :conditions => "subchapter_id=#{params[:subchapid]} and status='active' and e_gallery_type='#{session[:contests_type]}'" ,:order => sort
    @sub_chapters_gallerie = Galleries.paginate :per_page => items_per_page,:page => params[:page], :order => sort, :conditions => "subchapter_id=#{params[:subchapid]} and status='active' and e_gallery_type='#{session[:contests_type]}'"
    countcheck=Galleries.count(:all, :conditions => "subchapter_id=#{params[:subchapid]} and status='active' and e_gallery_type='#{session[:contests_type]}'")
    for subchap in @sub_chapters_gallerie
      @sub_chapter_count=UserContent.count(:all, :conditions => " gallery_id=#{subchap.id} and status='active'")
      if(@sub_chapter_count<=0)
        countcheck=countcheck
      else
        actualid=subchap.id
      end
    end

    @sub_chapter_journal = SubChapJournal.find(:all, :conditions => "sub_chap_id=#{params[:subchapid]}", :order=>"id DESC")

    #Bread crumb sessions
    @sub_chapter = SubChapter.find(params[:subchapid])
    session[:subchap_id]=params[:subchapid]
    session[:sub_chapname]=@sub_chapter['sub_chapname']
    params[:sbchap_id]=@sub_chapter['tagid']
    @tag = Tag.find(@sub_chapter['tagid'])
    session[:chap_id]=@sub_chapter['tagid']
    session[:chap_name]=@tag['v_tagname']
    # Journals count
    uid=logged_in_hmm_user.id
    @hmmuser = HmmUser.find(:all, :conditions => "id='#{uid}'")
    params[:galid]=galery_id
    @subchap_cnt = SubChapJournal.count(:all, :conditions => "sub_chap_id=#{params[:subchapid]}")
    if request.xml_http_request?
      render :partial => "sub_chapter_gallery", :layout => false
    end
    puts countcheck
    if(countcheck==1)
      redirect_to :controller => "#{familywebsite_controller_name}" , :action => 'contest_moments', :id => @hmmuser[0]['family_name'], :moment_id => @sub_chapters_gallerie[0]['id']
    else
      render :layout => true
    end

  end


  def contest_moments
    #@versions=VersionDetail.find(:first,:conditions=>"file_url='/ContestPage.swf'")
    @current_page = 'contest'
    @hmm_user=HmmUser.find(session[:hmm_user])
    @contest_details=ContestDetail.find(:first,:conditions=>"contest_phase='#{contest_phase}'")
    session[:share_with_hmm]=nil
    session[:shid]=nil
    session[:share]=nil
    render :layout => true
    @galleries = Galleries.find(:all, :conditions =>"id='#{params[:moment_id]}'")

    #         @sub_chapter = SubChapter.find(:all, :onditions => "id='#{@galleries[0]['subchapter_id']}'")
    #         session[:subchap_id]=@galleries.subchapter_id
    #         session[:sub_chapname]=@sub_chapter['sub_chapname']
    #         params[:id]=@sub_chapter['tagid']
    #         @tag = Tag.find(@sub_chapter['tagid'])
    #         session[:chap_id]=params[:id]
    #         session[:chap_name]=@tag['v_tagname']
  end

  def previous_contest
    @recent_entries = Contest.find_by_sql("SELECT a.*, b.* FROM contests as a, user_contents as b WHERE a.moment_id=b.id and a.moment_type = 'image' and a.status = 'active' order by a.new_votes desc limit 0,12")
  end

  # Flex Services for Contest
  def select_contestmoment
    issubmitted = Contest.find_by_sql("select *  from contests where contests.moment_id='#{params[:momentid]}' and contests.uid=#{session[:hmm_user]} and contest_phase = '#{params[:contest_phase]}'")

    #to get the moment thumb
    @moment = UserContent.find(:all, :conditions => "id='#{params[:momentid]}'")
    for mom_thumb in @moment
      moment_thumb = mom_thumb.v_filename
    end

    if params[:type] == 'image'
      jtype = 'image'
    else if params[:type] == 'video'
        jtype = 'video'
      end
    end


    if(issubmitted.length == 0)
      @contest_namecheck = Contest.find_by_sql("select *  from contests where contests.first_name='#{params[:fname]}' and contests.uid='#{session[:hmm_user]}' and moment_type = '#{params[:type]}' and contest_phase = '#{params[:contest_phase]}' and status != 'inactive'")
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

          @journal['jtype']= 'photo'
          @journal.save

          #Blog Entry


          @blog=Blog.new()
          @blog['blog_type_id']=params[:momentid]
          @blog['user_id']=logged_in_hmm_user.id
          @blog['title']=params[:title]
          @blog['description']=params[:journal_desc]
          @blog['blog_type']=jtype
          @blog['added_date']=params[:date]
          @blog.save



          params[:jid] = @journal['id']
        elsif  params[:journal] == "edited"
          journaledited = JournalsPhoto.find(params[:jid])
          journaledited['v_title']=params[:title]
          journaledited['v_image_comment']=params[:journal_desc]
          journaledited['updated_date']=params[:date]
          journaledited.save;


          #Blog Entry Edit
          @blog=Blog.find(:first,:conditions=>"blog_type_id=#{params[:momentid]} and blog_type='#{jtype}'")
          @blog['blog_type_id']=params[:momentid]
          @blog['user_id']=logged_in_hmm_user.id
          @blog['title']=params[:title]
          @blog['description']=params[:journal_desc]
          @blog['blog_type']=jtype
          @blog['added_date']=params[:date]
          @blog.save
        else

        end
        @contest = Contest.new
        @contest['uid']=logged_in_hmm_user.id
        @contest['moment_id']=params[:momentid]
        @contest['journal_id']= params[:jid]
        @contest['moment_type']=params[:type]
        @contest['contest_title']=params[:contest_title]
        @contest['first_name']=params[:fname]
        @contest['contest_entry_date'] = Time.now
        @contest['contest_phase'] = params[:contest_phase]
        @contest['age_groups'] = params[:age_groups]
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


  # New Flex Service
  #  def select_contestmoment
  #    issubmitted = Contestant.find(:all, :conditions=>"contest_id='#{session[:contest_id]}' and user_content_id='#{params[:momentid]}'")
  #
  #    #to get the moment thumb
  #    @moment = UserContent.find(:all, :conditions => "id='#{params[:momentid]}'")
  #    for mom_thumb in @moment
  #      moment_thumb = mom_thumb.v_filename
  #    end
  #
  #    if(issubmitted.length == 0)
  #      @contest_namecheck = Contestant.find(:all,:conditions=>"name='#{params[:fname]}' and contest_id='#{session[:contest_id]}'")
  #      if (@contest_namecheck.length == 0)
  #        @result = "true"
  #        if params[:journal] == "no"
  #          @blog=Blog.new
  #          @blog['blog_type']=session[:contests_type]
  #          @blog['blog_type_id']=session[:contest_id]
  #          @blog['user_id']=session[:hmm_user]
  #          @blog['title']=params[:title]
  #          @blog['description']=params[:journal_desc]
  #          @blog.save
  #          params[:bid] = @blog['id']
  #        elsif  params[:journal] == "edited"
  #          blog = Blog.find(params[:bid])
  #          blog['title']=params[:title]
  #          blog['description']=params[:journal_desc]
  #          blog.save
  #        else
  #
  #        end
  #        @contest = Contestant.new
  #        @contest['contest_id']=session[:contest_id]
  #        @contest['user_content_id']=params[:momentid]
  #        @contest['blog_id']= params[:bid]
  #        @contest['name']=params[:fname]
  #        @contest['votes']='0'
  #        @contest.save
  #        #Postoffice.deliver_contest_entrymail(params[:fname],moment_thumb,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_fname,logged_in_hmm_user.v_e_mail)
  #      else
  #        @result = "false"
  #      end
  #    else
  #      @result = "submited";
  #    end
  #    render :layout => false
  #  end


  def alert_messages
    @hmmuser=HmmUser.find(session[:hmm_user])
    render :layout => false
  end

  def get_memories_list
    @moments=UserContent.find(:all, :conditions => "gallery_id='#{params[:moment_id]}'")
    @familyname=HmmUser.find(:all, :conditions => "id='#{logged_in_hmm_user.id}'")
    render :layout => false
  end


  #Send unsent Vote Confirm emails
  def send_voteconfirm

    @dets=ContestVotes.find(:all,:select=>"a.*,a.email_id as cemail,a.unid as contestunid,b.*,c.v_filename,d.v_fname,d.v_lname",:joins=>" as a , contests as b ,user_contents as c, hmm_users as d",:conditions=>" a.vote_date between '2010-02-01' and '2010-02-2' and a.email_id!='' and a.conformed='no' and a.contest_id=b.id and b.moment_id=c.id and b.uid=d.id " , :group=>" a.id ")

    #    for @det in @dets
    #
    #     email=@det['cemail']
    #     contetsid=@det['contest_id']
    #     unid=@det['contestunid']
    #     moment_filename=@det['v_filename']
    #     contetsfname=@det['first_name']
    #     user_fname=@det['v_fname']
    #     user_lname=@det['v_lname']
    #     moment_type=@det['moment_type']
    #     logger.info("email")
    #     Postoffice.deliver_voteconform(email,contetsid, unid,moment_filename,contetsfname,user_fname,user_lname,moment_type)
    #
    #    end
    render :layout => false
  end


  #Entrants Page
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
      @sort=" new_votes  desc"
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

    if(srk == 'first_name')
      @sort3="desc"
      if params[:sort_order] == 'desc'
        @sort3="asc"
      else
        @sort3="desc"
      end
    end

    #@contest_cutekid = Contest.find(:all, :joins => "as a, user_contents as b", :conditions => "a.moment_id = b.id and a.contest_title = 'Cute Kid Contest'")
    #    @contest_memoriable = Contest.find(:all, :conditions => "moment_type='video' and contest_phase='phase#{params[:p]}'")
    #    if (params[:query].nil?)
    #      conditions = "a.moment_id = b.id  and  a.moment_type = 'video' and a.moment_id=c.user_content_id and b.id=c.user_content_id and a.status='active' and a.contest_phase='phase#{params[:p]}'"
    #    else
    #      conditions = "a.moment_id = b.id   and  a.moment_type = 'video' and a.moment_id=c.user_content_id and b.id=c.user_content_id and a.status='active' and ( a.first_name like '#{params[:query]}%' or c.v_image_comment like '%#{params[:query]}%') and a.contest_phase='phase#{params[:p]}'"
    #
    #    end
    #    @contest_cutekid = Contest.paginate :per_page => items_per_page, :page => params[:page], :select => "a.*, b.*,c.v_image_comment,  a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b, journals_photos as c ",
    #      :conditions => "#{conditions}", :order => @sort,:group=>"a.id"

    @contest_memoriable = Contest.find(:all, :conditions => "moment_type='video' and contest_phase='phase#{params[:p]}'")
    if (params[:query].nil?)
      conditions = "a.moment_id = b.id  and  a.moment_type = 'video' and a.status='active' and a.contest_phase='phase#{params[:p]}'"
    else
      conditions = "a.moment_id = b.id   and  a.moment_type = 'video' and a.status='active' and ( a.first_name like '#{params[:query]}%' and a.contest_phase='phase#{params[:p]}'"

    end
    @contest_cutekid = Contest.paginate :per_page => items_per_page, :page => params[:page], :select => "a.*, b.*, a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b",
      :conditions => "#{conditions}", :order => @sort,:group=>"a.id"

  end



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
      @sort=" new_votes  desc"
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

    if(srk == 'first_name')
      @sort3="desc"
      if params[:sort_order] == 'desc'
        @sort3="asc"
      else
        @sort3="desc"
      end
    end

    #    @contest_memoriable = Contest.find(:all, :conditions => "moment_type = 'image' and contest_phase='phase#{params[:p]}'")
    #    if (params[:query].nil?)
    #      conditions = "a.moment_id = b.id and a.moment_type = 'image' and a.status = 'active' and a.moment_id=c.user_content_id and b.id=c.user_content_id and a.contest_phase='phase#{params[:p]}'"
    #    else
    #      conditions = "a.moment_id = b.id and a.moment_type = 'image' and a.status = 'active' and a.moment_id=c.user_content_id and b.id=c.user_content_id and ( a.first_name like '#{params[:query]}%' or c.v_image_comment like '%#{params[:query]}%') and a.contest_phase='phase#{params[:p]}'"
    #    end
    #    @contest_cutekid = Contest.paginate :per_page => items_per_page, :page => params[:page], :select => "a.*, b.*,c.*,  a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b, journals_photos as c ",
    #      :conditions => "#{conditions}", :order => @sort,:group=>"a.id"

    @contest_memoriable = Contest.find(:all, :conditions => "moment_type = 'image' and contest_phase='phase#{params[:p]}'")
    if (params[:query].nil?)
      conditions = "a.moment_id = b.id and a.moment_type = 'image' and a.status = 'active'  and a.contest_phase='phase#{params[:p]}'"
    else
      conditions = "a.moment_id = b.id and a.moment_type = 'image' and a.status = 'active' and ( a.first_name like '#{params[:query]}%' and a.contest_phase='phase#{params[:p]}'"
    end
    @contest_cutekid = Contest.paginate :per_page => items_per_page, :page => params[:page], :select => "a.*, b.*, a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b",
      :conditions => "#{conditions}", :order => @sort,:group=>"a.id"

#

  end
end
