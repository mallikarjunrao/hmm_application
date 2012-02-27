class FamilywebsiteContestantsController < ApplicationController
  layout 'familywebsite'
  include SortHelper
  helper :sort
  require 'will_paginate'
  
  before_filter  :check_account #checks for valid family name, terms of use check and user block check

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


  def contest_entries
    @controller_name = "familywebsite_contestants"
    items_per_page = 12
    unless(params[:id].blank?)
      @contest=HmmContest.find(params[:contest_id])
      @contestants = Contestant.paginate   :per_page => items_per_page, :page => params[:page],
        :joins=>"as contestant, user_contents as user_content", :select => " contestant.id as contestant_id,
contestant.name as name, contestant.created_at as submitted_date, contestant.votes as votes, user_content.v_filename as user_content_file, user_content.img_url as usercontent_url, user_content.img_url as img_url, user_content.e_filetype as user_content_type ",
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

end
