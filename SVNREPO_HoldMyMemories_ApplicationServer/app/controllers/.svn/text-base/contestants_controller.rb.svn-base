class ContestantsController < ApplicationController
  include SortHelper
  helper :sort
  include SortHelper
  require 'will_paginate'

  #function to display the list of contestants for given contest id
  def contest_entries
    @controller_name = "contestants"
    items_per_page = 12
    unless(params[:contest_id].blank?)
      @contest=HmmContest.find(params[:contest_id])
      @contestants = Contestant.paginate   :per_page => items_per_page, :page => params[:page],
        :joins=>"as contestant, user_contents as user_content", :select => " contestant.id as contestant_id,
contestant.name as name, contestant.created_at as submitted_date, contestant.votes as votes, user_content.v_filename as user_content_file, user_content.img_url as usercontent_url, user_content.e_filetype as user_content_type ",
        :conditions => "contestant.user_content_id=user_content.id  and contestant.contest_id='#{params[:contest_id]}'",
        :order => "contestant.id"
    else
      redirect_to "/" #redirect to home page if contest id is not provided
    end
  end

  def large_view
    @contestant = Contestant.find(:first, :joins=>"as contestant, user_contents as user_content", :select => " contestant.id as contestant_id, contestant.contest_id as contest_id, contestant.name as name, contestant.created_at as submitted_date, contestant.votes as votes, user_content.id as user_content_id, user_content.v_filename as user_content_file, user_content.img_url as usercontent_url, user_content.e_filetype as user_content_type ", :conditions => " contestant.user_content_id=user_content.id  and contestant.id='#{params[:contestant_id]}'")
    @contest=HmmContest.find(@contestant.contest_id)
    @journal = JournalsPhoto.find(:first, :conditions => "user_content_id = #{@contestant.user_content_id} ")

  end

  def vote
    @contestant = Contestant.find(:first, :joins=>"as contestant, user_contents as user_content", :select => " contestant.id as contestant_id, contestant.contest_id as contest_id, contestant.name as name, contestant.created_at as submitted_date, contestant.votes as votes, user_content.id as user_content_id, user_content.v_filename as user_content_file, user_content.img_url as usercontent_url, user_content.e_filetype as user_content_type , contestant.blog_id as blog_id", :conditions => " contestant.user_content_id=user_content.id  and contestant.id='#{params[:id]}'")
    @contest=HmmContest.find(@contestant.contest_id)
    @blog = Blog.find(@contestant.blog_id)
    @url= "http://www.holdmymemories.com/contests/videomoment_details/#{@contestant.contestant_id}"
    render :layout => false
  end

  def vote_entry
    if (session[:hmm_user].nil?)
      @contestant = Contestant.find(:first, :joins=>"as contestant, user_contents as user_content", :select => " contestant.id as contestant_id, contestant.contest_id as contest_id, contestant.name as name, contestant.created_at as submitted_date, contestant.votes as votes, user_content.id as user_content_id, user_content.v_filename as user_content_file, user_content.img_url as usercontent_url, user_content.e_filetype as user_content_type, user_content.uid as uid  ", :conditions => " contestant.user_content_id=user_content.id  and contestant.id='#{params[:contestant_id]}'")
      @uid = @contestant.uid
      contetsid = @contestant.contestant_id
      contest_id=@contestant.contest_id
      contetsfname = @contestant.name
      moment_type = @contestant.user_content_type
      #working for thumb nail for e-mail
      momentid = @contestant.user_content_id
      moment = UserContent.find(momentid)
      moment_filename = moment.v_filename
      #working for fname and lastname of cntestant
      user = HmmUser.find(@uid)
      user_fname = user.v_fname
      user_lname = user.v_lname
      @contest_vote = HmmContestVote.count(:all, :conditions => "contestant_id = '#{contetsid}' and email = '#{params[:email]}'  ")
      if @contest_vote <= 0
        #calculating next id for the contest vote table
        @contestvote_max =  HmmContestVote.find(:first, :select => "max(id) as n ")

        if(@contestvote_max.n==nil || @contestvote_max.n=='')
          contestvote_max_id='0'
        else
          contestvote_max_id = "#{@contestvote_max.n}"
        end
        
        contestvote_next_id = Integer(contestvote_max_id) + 1
        #creating unid for the vote conform
        contestuuid=HmmContestVote.find_by_sql("select uuid() as uid")
        unid=contestuuid[0].uid+""+"#{contestvote_next_id}"
        #inserting new values into contest vote table
        @vote = HmmContestVote.new()
        @vote['contestant_id']=contetsid
        @vote['voter_id']=0
        @vote['email']=params[:email]
        @vote['unique_id'] = unid
        if @vote.save
          $notice_vote1
          flash[:notice_vote] = 'Thank-you for casting your vote.  You will shortly receive an email verification that you must accept for your vote to be counted.  This helps us make sure that all votes are valid votes.  Your email address will not be shared with any other company.'
          Postoffice.deliver_voteconform(params[:email],contetsid, unid,moment_filename,contetsfname,user_fname,user_lname,moment_type)
          redirect_to session[:redirect_url]
        else
          $notice_vote
          flash[:notice_vote] = 'Your vote was not submitted due to technical issue... Please try again!!'
          redirect_to session[:redirect_url]
        end
      else
        $notice_vote
        flash[:notice_vote] = 'You have already voted for this moment.. you can cast your vote only once per contestant!!'
        redirect_to session[:redirect_url]
      end
    else
          redirect_to :action => 'vote_by_hmmuser', :contestant_id => @contestant.contestant_id
    end
  end

  def vote_by_hmmuser
    @contestant = Contestant.find(:first, :joins=>"as contestant, user_contents as user_content", :select => " contestant.id as contestant_id, contestant.contest_id as contest_id, contestant.name as name, contestant.created_at as submitted_date, contestant.votes as votes, user_content.id as user_content_id, user_content.v_filename as user_content_file, user_content.img_url as usercontent_url, user_content.e_filetype as user_content_type, user_content.uid as uid  ", :conditions => " contestant.user_content_id=user_content.id  and contestant.id='#{params[:contestant_id]}'")
      @uid = @contestant.uid
      contetsid = @contestant.contestant_id
      contest_id=@contestant.contest_id
      @contest_vote1 = HmmContestVote.count(:all, :conditions => "contest_id = '#{contetsid}' and hmm_voter_id = '#{logged_in_hmm_user.id}' ")
      @contest_vote2 = HmmContestVote.count(:all, :conditions => "contest_id = '#{contetsid}' and email_id = '#{logged_in_hmm_user.v_e_mail}' ")
      if (@contest_vote1 <= 0 and @contest_vote2 <= 0)
        #calculating next id for the contest vote table
        #inserting new values into contest vote table
        @vote = HmmContestVote.new()
        @vote['contestant_id']=contetsid
        @vote['voter_id']=logged_in_hmm_user.id
        @vote['vote_date']= Time.now
        @vote['status'] = 'confirmed'
        if @vote.save
          @contest_vote_count = HmmContestVote.count(:all, :conditions => "contestant_id = '#{contetsid}' and status='confirmed'")
          countest_update = Contestant.find(contetsid)
          countest_update.votes = @contest_vote_count
          countest_update.save
          $notice_vote
          flash[:notice_vote] = 'Vote has been successfully submitted.. '
          #Postoffice.deliver_voteconform(params[:email],contetsid, unid)
          redirect_to session[:redirect_url]
        else
          $notice_vote
          flash[:notice_vote] = 'Your vote was not submitted due to technical issue... Please try again!!'
          redirect_to session[:redirect_url]
        end
      else
        $notice_vote
        flash[:notice_vote] = 'You have already voted for this moment.. you can cast your vote only once per contestant!!'
        redirect_to session[:redirect_url]
      end
  end

end
