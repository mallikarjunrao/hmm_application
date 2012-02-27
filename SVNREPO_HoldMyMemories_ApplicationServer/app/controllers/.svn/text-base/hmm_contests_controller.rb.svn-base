class HmmContestsController < ApplicationController
 
  layout "application"
  include SortHelper
  helper :sort
 # require 'contacts'
  require 'will_paginate'


  def contest_intro
    @contestintro=HmmContest.find(:all,:conditions=>"start_date<=CURRENT_TIMESTAMP() and end_date>=CURRENT_TIMESTAMP()")
  end


  def contest_terms_conditions
    @contest=HmmContest.find(params[:id])
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

   @contest=HmmContest.find(params[:id])
   if session[:hmm_user]
          if(@contest.contest_type=='photo')
          session[:contests_type]='image'
          session[:contest_id]=@contest.id
           else
          session[:contests_type]='video'
          session[:contest_id]=@contest.id
          end
          redirect_to :controller => 'familywebsite_contest', :action =>'contest_chapter', :id => logged_in_hmm_user.family_name
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

        if(params[:id]!=nil && params[:id]!='')
          @contest=HmmContest.find(params[:id])
          if(@contest.contest_type=='photo')
          session[:contests_type]='image'
          session[:contest_id]=@contest.id
           else
          session[:contests_type]='video'
          session[:contest_id]=@contest.id
          end
        end



        session[:alert] = "fnfalert"
        session[:account_type] = logged_in_hmm_user.account_type
        redirect_to :controller => 'familywebsite_contest', :action =>'contest_chapter', :id => logged_in_hmm_user.family_name
      else
        reset_session
        flash[:error1] = "User is been blocked.. Contact Admin!!"
        redirect_to :action => 'contest_login'
      end
    else
      flash[:error] = "I'm sorry; either your username or password was incorrect."
      #log file entry
      logger.error("[Invalid Login]: by [User]:#{params[:hmm_user][:v_user_name]} at #{Time.now}")
      redirect_to :action => 'contest_login'
      return "false"
    end


  end


#
#  def details
#  end
#
#  def prev_winners_contest
#     @recent_entries = Contest.find(:all,:select=>"a.*, b.*",:joins=>"as a, user_contents as b",:conditions=>"a.moment_id=b.id and a.moment_type = 'image' and a.status = 'active'",:order=>"a.new_votes desc")
#  end
#
#  def moments_vote
#      items_per_page = 12
#
#      sort_init 'contest_entry_date'
#      sort_update
#
#      srk=params[:sort_key]
#      @sort="#{srk}  #{params[:sort_order]}"
#       @sort1="desc"
#        @sort2="desc"
#       if(srk==nil)
#        @sort="contest_entry_date  desc"
#        @sort1="desc"
#        @sort2="desc"
#      end
#
#      if(srk == 'contest_entry_date')
#        @sort1="desc"
#        if params[:sort_order] == 'desc'
#          @sort1="asc"
#        else
#          @sort1="desc"
#        end
#      end
#
#      if(srk == 'new_votes')
#        @sort2="desc"
#        if params[:sort_order] == 'desc'
#          @sort2="asc"
#        else
#          @sort2="desc"
#        end
#      end
#
#      if (params[:query].nil?)
#        conditions = "a.moment_id = b.id  and  a.moment_type = 'image' and a.moment_id=c.user_content_id and b.id=c.user_content_id and a.status='active' and a.contest_phase='phase2'"
#    else
#      conditions = "a.moment_id = b.id   and  a.moment_type = 'image' and a.moment_id=c.user_content_id and b.id=c.user_content_id and a.status='active' and ( a.first_name like '#{params[:query]}%' or c.v_image_comment like '%#{params[:query]}%') and a.contest_phase='phase2'"
#
#    end
#     @contest_cutekid = Contest.paginate :per_page => items_per_page, :page => params[:page], :select => "a.*, b.*,c.v_image_comment,  a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b, journals_photos as c ",
#        :conditions => "#{conditions}", :order => @sort
#   end
#
#   def videomoment_vote
#    items_per_page = 15
#    sort_init 'contest_entry_date'
#      sort_update
#
#      srk=params[:sort_key]
#      @sort="#{srk}  #{params[:sort_order]}"
#       @sort1="desc"
#        @sort2="desc"
#       if(srk==nil)
#        @sort="contest_entry_date  desc"
#        @sort1="desc"
#        @sort2="desc"
#      end
#
#      if(srk == 'contest_entry_date')
#        @sort1="desc"
#        if params[:sort_order] == 'desc'
#          @sort1="asc"
#        else
#          @sort1="desc"
#        end
#      end
#
#      if(srk == 'new_votes')
#        @sort2="desc"
#        if params[:sort_order] == 'desc'
#          @sort2="asc"
#        else
#          @sort2="desc"
#        end
#      end
#    #@contest_cutekid = Contest.find(:all, :joins => "as a, user_contents as b", :conditions => "a.moment_id = b.id and a.contest_title = 'Cute Kid Contest'")
#    @contest_memoriable = Contest.find(:all, :conditions => "moment_type='video' and contest_phase='phase2'")
#    if (params[:query].nil?)
#        conditions = "a.moment_id = b.id  and  a.moment_type = 'video' and a.moment_id=c.user_content_id and b.id=c.user_content_id and a.status='active' and a.contest_phase='phase2'"
#    else
#      conditions = "a.moment_id = b.id   and  a.moment_type = 'video' and a.moment_id=c.user_content_id and b.id=c.user_content_id and a.status='active' and ( a.first_name like '#{params[:query]}%' or c.v_image_comment like '%#{params[:query]}%') and a.contest_phase='phase2'"
#
#    end
#     @contest_cutekid = Contest.paginate :per_page => items_per_page, :page => params[:page], :select => "a.*, b.*,c.v_image_comment,  a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b, journals_photos as c ",
#        :conditions => "#{conditions}", :order => @sort
#
#  end
#
# def momentdetails
#    if(params[:page]==nil || params[:page]=='' || params[:hmm] ==nil)
#     @counts =  Contest.count(:all, :conditions => " moment_type='image' and status='active' and contest_phase='phase2' ",:order =>'contest_entry_date  desc')
#      @allrecords =  Contest.find(:all, :conditions => " moment_type='image' and status='active' and contest_phase='phase2'" ,:order =>'contest_entry_date  desc')
#      page=0
#
#
#      #pp @allrecords
#      for check in @allrecords
#        page=page+1
#        if("#{check.moment_id}" == "#{params[:id]}" )
#         @nextpage=page
#         puts "yes dude"
#         redirect_to :action => :momentdetails, :id=> params[:id], :page =>@nextpage,:hmm=>"true"
#         #redirect_to :action => :momentdetails, :id=> params[:id], :page =>@nextpage
#       else
#         puts "#{check.moment_id} == #{params[:id]}"
#
#         puts "\n"
#        end
#      end
#
#     else
#       #@user_content_pages, @user_content = paginate :contests, :conditions => "gallery_id='#{@usercontent.gallery_id}' and status='active'  #{eacess} ",:order =>'id desc', :per_page => 1
#      @contest_cutekid = Contest.paginate :per_page => 1, :page => params[:page], :conditions => " moment_type='image' and status='active' and contest_phase='phase2'" ,:order =>'contest_entry_date  desc'
#
#   end
#end
#
#def videomoment_details
#    @moment_details = UserContent.find(:all, :conditions => "id='#{params[:id]}'")
#    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:id]}' and contest_phase='phase2'")
#    @journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{params[:id]} ")
#end
#
# def vote
#      @mom_id = params[:id]
#      @contests_det = Contest.find(params[:id])
#      @moment_details = UserContent.find(:all, :conditions => "id='#{@contests_det.moment_id}'")
#      @contests_fname = Contest.find(:all, :conditions => "moment_id='#{@contests_det.moment_id}' and contest_phase='phase2'")
#      @journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{@contests_det.moment_id} ")
#      render :layout => false
#  end
#
#
# def create_vote
#
#    if (session[:hmm_user].nil?)
#     @contest = Contest.find(params[:mom_id])
#      @uid = @contest.uid
#      contetsid = @contest.id
#      contetsfname = @contest.first_name
#      moment_type = @contest.moment_type
#      momentid = @contest.moment_id
#      @moment = UserContent.find(:first, :conditions => "id='#{momentid}'")
#      moment_filename = @moment.v_filename
#      #working for fname and lastname of cntestant
#      @username = HmmUser.find(@uid)
#      user_fname = @username.v_fname
#      user_lname = @username.v_lname
#      familyname = @username.family_name
#
#      @contest_vote = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and email_id = '#{params[:email]}'  ")
#      if @contest_vote <= 0
#       #calculating next id for the contest vote table
#       @contestvote_max =  ContestVotes.maximum(:id)
#       if(@contestvote_max == '')
#         @contestvote_max = '0'
#       end
#       contestvote_next_id = Integer(@contestvote_max) + 1
#
#       #creating unid for the vote conform
#       contestuuid=Share.find_by_sql("select uuid() as uid")
#       unid=contestuuid[0].uid+""+"#{contestvote_next_id}"
#       #inserting new values into contest vote table
#       @vote = ContestVotes.new()
#       @vote['uid']=@uid
#       @vote['contest_id']=contetsid
#       @vote['email_id']=params[:email]
#       @vote['vote_date']= Time.now
#       @vote['unid'] = unid
#       if @vote.save
#         $notice_vote1
#         flash[:notice_vote] = 'Thank-you for casting your vote.  You will shortly receive an email verification that you must accept for your vote to be counted.  This helps us make sure that all votes are valid votes.  Your email address will not be shared with any other company.'
#         Postoffice.deliver_hmmvoteconform(params[:email],contetsid, unid,moment_filename,contetsfname,user_fname,user_lname,moment_type)
#         if(moment_type=="video")
#           redirect_to :controller => "hmm_contests", :action => 'videomoment_vote'
#         else
#          redirect_to :controller => "hmm_contests", :action => 'moments_vote'
#         end
#          else
#         $notice_vote
#         flash[:notice_vote] = 'Your was not submitted due to technical issue... Please try again!!'
#         if(moment_type=="video")
#           redirect_to :controller => "hmm_contests",:action => 'videomoment_vote'
#         else
#          redirect_to :controller => "hmm_contests",:action => 'moments_vote'
#         end
#       end
#
#     else
#      $notice_vote
#      flash[:notice_vote] = 'You have already voted for this moment.. you can cast your vote only once per child!!'
#      if(moment_type=="video")
#         redirect_to :controller => "hmm_contests", :action => 'videomoment_vote'
#      else
#         redirect_to :controller => "hmm_contests", :action => 'moments_vote'
#      end
#    end
#   else
#      redirect_to :controller => "hmm_contests", :action => 'vote_cal', :id => params[:mom_id]
#    end
#  end
#
#
#  def vote_cal
#
#    @contest = Contest.find(params[:id])
#    @uid = @contest.uid
#    contetsid = @contest.id
#    contest_typ = @contest.moment_type
#
#    @contest_vote = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and (hmm_voter_id = '#{logged_in_hmm_user.id}' OR email_id = '#{logged_in_hmm_user.v_e_mail}) ")
#
#    if (@contest_vote<=0)
#      #calculating next id for the contest vote table
#      @contestvote_max =  ContestVotes.maximum(:id)
#
#      if(@contestvote_max == '')
#        @contestvote_max = '0'
#      end
#      contestvote_next_id = Integer(@contestvote_max) + 1
#
#      @username = HmmUser.find(@uid)
#      familyname = @username.family_name
#
#      #inserting new values into contest vote table
#      @vote = ContestVotes.new()
#      @vote['uid']=@uid
#      @vote['contest_id']=contetsid
#      @vote['hmm_voter_id']=logged_in_hmm_user.id
#      @vote['vote_date']= Time.now
#      @vote['conformed'] = 'yes'
#      if @vote.save
#
#        @contest_vote_count = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and conformed='yes'")
#        countest_update = Contest.find(contetsid)
#        countest_update.votes = @contest_vote_count
#        countest_update.save
#
#        #calculation for new votes
#        @count = ContestVotes.count_by_sql("select COUNT(distinct CONCAT(IFNULL(email_id,''),IFNULL(hmm_voter_id,''))) AS COUNT from contest_votes where contest_id='#{contetsid}' and conformed='yes'")
#        countest_update = Contest.find(contetsid)
#        countest_update.new_votes = @count
#        countest_update.save
#
#        $notice_vote
#        flash[:notice_vote] = 'Vote has been successfully submitted.. '
#        #Postoffice.deliver_voteconform(params[:email],contetsid, unid)
#        if contest_typ == 'image'
#          redirect_to :controller => "hmm_contests", :action => 'moments_vote', :id => familyname
#        else if contest_typ == 'video'
#          redirect_to :controller => "hmm_contests", :action => 'videomoment_vote', :id => familyname
#        end
#        end
#      else
#        $notice_vote
#        flash[:notice_vote] = 'Your was not submitted due to technical issue... Please try again!!'
#        if contest_typ == 'image'
#          redirect_to :controller => "hmm_contests", :action => 'moments_vote', :id => familyname
#        else if contest_typ == 'video'
#          redirect_to :controller => "hmm_contests", :action => 'videomoment_vote', :id => familyname
#        end
#        end
#      end
#
#    else
#      $notice_vote
#      flash[:notice_vote] = 'You have already voted for this moment.. you can cast your vote only once per child!!'
#      if contest_typ == 'image'
#          redirect_to :controller => "hmm_contests", :action => 'moments_vote', :id => familyname
#        else if contest_typ == 'video'
#          redirect_to :controller => "hmm_contests", :action => 'videomoment_vote', :id => familyname
#        end
#        end
#    end
#
#  end
#
#   def authenticate_vote
#
#    @authenticate_vote_count = ContestVotes.count(:conditions => "unid='#{params[:id]}'")
#    if @authenticate_vote_count == 1
#      contest_votes = ContestVotes.find(:all, :conditions => "unid='#{params[:id]}'")
#      contest_votes_check = ContestVotes.count(:all, :conditions => "unid='#{params[:id]}' and conformed='yes'")
#      if(contest_votes_check > 0)
#        $notice_voteconform
#     res = "Our records indicate you have already confirmed your vote for this entry with email address #{contest_votes[0].email_id}.  Voters may only vote once per entry.  Thank-you for your vote!"
#       flash[:notice_voteconform]=res
#      redirect_to(:action => "conform_vote", :res => res)
#      else
#      #contest_votes[0].unid = "null"
#      contest_votes[0].conformed = 'yes'
#      contest_votes[0].save
#      @contest_vote_count = ContestVotes.count(:all, :conditions => "contest_id = '#{contest_votes[0].contest_id}' and conformed='yes'")
#        countest_update = Contest.find(contest_votes[0].contest_id)
#        countest_update.votes = @contest_vote_count
#        countest_update.save
#
#      #calculation for new votes
#        @count = ContestVotes.count_by_sql("select COUNT(distinct CONCAT(IFNULL(email_id,''),IFNULL(hmm_voter_id,''))) AS COUNT from contest_votes where contest_id='#{contest_votes[0].contest_id}' and conformed='yes'")
#        countest_update = Contest.find(contest_votes[0].contest_id)
#        countest_update.new_votes = @count
#        countest_update.save
#
#      $notice_voteconform
#      res  = 'Thank-you for your vote.'
#      flash[:notice_voteconform] = res
#      redirect_to :action => 'conform_vote', :res => res
#      end
#    else
#      $notice_voteconform
#      res = 'Our records indicate you have already voted for this entry.  Voters may only vote once per entry.  Thank-you for your vote! '
#      flash[:notice_voteconform] = res
#      redirect_to(:action => "conform_vote", :res => res)
#    end
#
#  end
#
#  def conform_vote
#
#  end

  end


