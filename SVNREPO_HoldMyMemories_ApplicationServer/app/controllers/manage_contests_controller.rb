class ManageContestsController < ApplicationController

  layout "admin"
  require 'will_paginate'
  include CustomersHelper
   helper :customers

  before_filter :authenticate_admin, :only => [:create_contest]

  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to :controller => 'account', :action => 'login'
      return false
    end
  end

  def create_contest    
    
  end

  def contest_list
    @contests = HmmContest.paginate :per_page => 10,:select=>"hmm_contests.*", :page => params[:page],:order=>"id desc"
  end

  def destroy
    HmmContest.find(params[:id]).destroy
    flash[:notice] = 'Contest Deleted Successfully'
    redirect_to :action => 'contest_list'
  end

  def edit_contest
    if(params[:id]!='' && params[:id]!=nil)
      @contest=HmmContest.find(params[:id])

     
    else
      redirect_to "/"
    end
  end

  def preview
    if(params[:id]!='' && params[:id]!=nil)
      @contest=HmmContest.find(params[:id])
    else
      redirect_to "/"
    end
  end

  def contest_approve
    unless(params[:id].blank?)
     
      @contestant=Contestant.find(params[:id])
      @contestant['status']='approved'
      if(@contestant.save)
        
         @contestant_details=Contestant.find(:first,:joins=>" LEFT JOIN hmm_contests on (contestants.id=#{params[:id]} and contestants.contest_id=hmm_contests.id and hmm_contests.contest_type ='video')
        LEFT JOIN user_contents on (contestants.user_content_id=user_contents.id)
        LEFT JOIN hmm_users on (user_contents.uid=hmm_users.id)",:select => "hmm_users.v_user_name,hmm_users.v_fname,hmm_users.v_e_mail,contestants.*,hmm_contests.*, contestants.status as contestant_status , contestants.id as contestant_id " , :conditions => "", :order => 'contestants.id desc')
  
         flash[:contest_rej] = 'contest entry has been approved'
         if(session['redirect']=='101')
        redirect_to :action => 'contestantlist' , :id => params[:cid] ,:typ => 'photo'
        else
        redirect_to :action => 'contestantlist' , :id => params[:cid] ,:typ => 'video'
        end
      end
       @content_url = UserContent.find(:all, :conditions => "id='#{@contestant_details.user_content_id}'")
      #Emergencymailer.deliver_contest_approvemail(@contestant_details.v_fname,@contestant_details.v_e_mail,@contestant_details.name,@contestant_details.user_content_id,@contestant_details.contest_type,@content_url[0]['img_url'],@content_url[0]['v_filename'])
    end
  end

  def reject_email
    @contest = Contestant.find(:all, :conditions => "id='#{params[:id]}'")
    for i in @contest
      @content_url = UserContent.find(:all, :conditions => "id='#{i.user_content_id}'")
    end
  end


  def contest_reject
    unless(params[:id].blank?)
      @contestant=Contestant.find(params[:id])
      @contestant['status']='rejected'
      if(@contestant.save)

        @contestant_details=Contestant.find(:first,:joins=>" LEFT JOIN hmm_contests on (contestants.id=#{params[:id]} and contestants.contest_id=hmm_contests.id and hmm_contests.contest_type ='video')
        LEFT JOIN user_contents on (contestants.user_content_id=user_contents.id)
        LEFT JOIN hmm_users on (user_contents.uid=hmm_users.id)",:select => "hmm_users.v_user_name,hmm_users.v_fname,hmm_users.v_e_mail,contestants.*,hmm_contests.*, contestants.status as contestant_status , contestants.id as contestant_id " , :conditions => "", :order => 'contestants.id desc')


         flash[:contest_rej] = 'contest entry has been rejected'
         if(session['redirect']=='101')
           redirect_to :action => 'contestantlist' , :id => params[:cid] ,:typ => 'photo'
          else
          redirect_to :action => 'contestantlist' , :id => params[:cid] ,:typ => 'video'
          end
      end
       @content_url = UserContent.find(:all, :conditions => "id='#{@contestant_details.user_content_id}'")
       #Emergencymailer.deliver_contest_rejectemail(@contestant_details.v_fname,@contestant_details.v_e_mail,@contestant_details.name,@contestant_details.user_content_id,@contestant_details.contest_type,params[:message],@content_url[0]['img_url'],@content_url[0]['v_filename'])

    end
  end

  def contest_delete
    Contestant.find(params[:id]).destroy
    flash[:contest_rej] = 'Contest Entry Deleted Successfully'
    if(session['redirect']=='101')
    redirect_to :action => 'contestantlist' , :id => params[:cid] ,:typ => 'photo'
    else
    redirect_to :action => 'contestantlist' , :id => params[:cid] ,:typ => 'video'
    end
  end



def contestantlist
    @contests = Contestant.paginate :per_page => 10,:joins=>" JOIN hmm_contests on (contestants.contest_id=#{params[:id]} and contestants.contest_id=hmm_contests.id and hmm_contests.contest_type ='#{params[:typ]}')
        JOIN user_contents on (contestants.user_content_id=user_contents.id)
        JOIN hmm_users on (user_contents.uid=hmm_users.id)
        ",
    :page => params[:page], :select => "hmm_users.v_user_name,hmm_users.v_fname,hmm_users.v_e_mail,contestants.*,hmm_contests.*, contestants.status as contestant_status , contestants.id as contestant_id , contestants.created_at as added_date" , :conditions => "", :order => 'contestants.id desc'
end

  def video_contestantview
    @hmmcontest=HmmContest.find(params[:cid])
    @contest= Contestant.find(params[:id])
    @moment_details = UserContent.find(:first, :conditions => "id='#{@contest.user_content_id}'")
    @blog = Blog.find(@contest.blog_id)
  end

  def photo_contestantview
    @hmmcontest=HmmContest.find(params[:cid])
    @contest= Contestant.find(params[:id])
    @moment_details = UserContent.find(:first, :conditions => "id='#{@contest.user_content_id}'")
    @blog = Blog.find(@contest.blog_id)
  end



def view_entries
    #@controller_name = "manage_contests"
    items_per_page = 12
    unless(params[:id].blank?)
      @contest=HmmContest.find(params[:id])
      @contestants = Contestant.paginate   :per_page => items_per_page, :page => params[:page],
        :joins=>"as contestant, user_contents as user_content", :select => " contestant.id as contestant_id,
contestant.name as name, contestant.created_at as submitted_date, contestant.votes as votes, user_content.v_filename as user_content_file, user_content.img_url as usercontent_url, user_content.e_filetype as user_content_type ",
        :conditions => "contestant.user_content_id=user_content.id  and contestant.contest_id='#{params[:id]}'",
        :order => "contestant.id desc"
    else
      redirect_to "/" #redirect to home page if contest id is not provided
    end
  end

def select_winner
  unless(params[:id].blank?)
    @contest=HmmContest.find(params[:id])
    @contest['contestant_id']=params[:cid]
    @contest.save
    flash[:contest_rej] = "Winner Selected to Contest : #{@contest.title}"
    redirect_to "/manage_contests/contest_list"
  end
end





end
