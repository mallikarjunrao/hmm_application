class HmmContestVotesController < ApplicationController

  def authenticate_vote
    contest_chk=HmmUser.count(:all, :conditions => "v_e_mail='#{params[:e]}'")
    if(contest_chk>0)
      @contest_email=HmmUser.find(:first, :conditions => "v_e_mail='#{params[:e]}'")
      contest_votes1 = HmmContestVote.find(:all, :conditions => "unique_id='#{params[:id]}'")
      @contest_email_chk=HmmContestVote.count(:all,:conditions => "contestant_id = '#{contest_votes1[0].contestant_id}' and voter_id='#{@contest_email.id}' and status='confirmed'")
    else
      @contest_email_chk=0
    end
    if(@contest_email_chk>0)
      $notice_voteconform
      res = 'Our records indicate you have already voted for this entry.  Voters may only vote once per entry.  Thank-you for your vote! '
      flash[:notice_voteconform] = res
      redirect_to(:action => "confirm_vote", :res => res)
    else
      @authenticate_vote_count = HmmContestVote.count(:conditions => "unique_id=='#{params[:id]}'")
      if @authenticate_vote_count == 1
        contest_votes = HmmContestVote.find(:all, :conditions => "unique_id=='#{params[:id]}'")
        contest_votes_check = HmmContestVote.count(:all, :conditions => "unique_id=='#{params[:id]}' and status='confirmed'")
        if(contest_votes_check > 0)
          $notice_voteconform
          res = "Our records indicate you have already confirmed your vote for this entry with email address #{contest_votes[0].email}.  Voters may only vote once per entry.  Thank-you for your vote!"
          flash[:notice_voteconform]=res
          redirect_to(:action => "confirm_vote", :res => res)
        else
          contest_votes[0].status = 'confirmed'
          contest_votes[0].save
          @contest_vote_count = HmmContestVote.count(:all, :conditions => "contestant_id = '#{contest_votes[0].contestant_id}' and status='confirmed'")
          countestant_update = Contestant.find(contest_votes[0].contestant_id)
          countestant_update.votes = @contest_vote_count
          countestant_update.save
          #calculation for new votes
          @count = HmmContestVote.count_by_sql("select COUNT(distinct CONCAT(IFNULL(email,''),IFNULL(voter_id,''))) AS COUNT from hmm_contest_votes where contestant_id='#{contest_votes[0].contestant_id}' and status='confirmed'")
          countestant_update = Contestant.find(contest_votes[0].contestant_id)
          countestant_update.new_votes = @count
          countestant_update.save
          $notice_voteconform
          res  = 'Thank-you for your vote.'
          flash[:notice_voteconform] = res
          redirect_to :action => 'confirm_vote', :res => res
        end
      else
        $notice_voteconform
        res = 'Our records indicate you have already voted for this entry.  Voters may only vote once per entry.  Thank-you for your vote! '
        flash[:notice_voteconform] = res
        redirect_to(:action => "confirm_vote", :res => res)
      end
   end
  end

  def confirm_vote

  end

end
