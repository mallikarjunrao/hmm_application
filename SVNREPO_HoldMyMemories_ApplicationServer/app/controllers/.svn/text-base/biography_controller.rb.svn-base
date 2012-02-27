class BiographyController < ApplicationController
layout 'familywebsite'
  include SortHelper
  include SortHelper
  helper :sort
  require 'will_paginate'
  before_filter  :check_account #checks for valid family name, terms of use check and user block check

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
          redirect_to :controller =>"familywebsite", :action => 'visitor_login', :id => params[:id], :redirect_url => request.url if (params[:action]!='login' && params[:action]!='visitor_login')
        else
          @path = ContentPath.find(:first, :conditions => "status='active'")
          @content_server_url = @path.content_path
          return true #returns true if all the conditions are cleared
        end
      else
        redirect_to '/'
      end
    end
  end

  
  def family_biographies
    @current_page = 'manage my site'
    @current_item = "biography"
  end

  def add_biography
    @current_page = 'manage my site'
    @current_item = "biography"
    @chap= Tag.find(:all, :conditions => "uid=#{logged_in_hmm_user.id} and status='active' and default_tag='yes'")
    @chap_count= Tag.count(:all, :conditions => "uid=#{logged_in_hmm_user.id} and status='active' and default_tag='yes'")
  end
  
  def show_biography
    @current_page = 'manage my site'
    @current_item = "biography"
    @family_members = FamilyMember.find(:all, :conditions => "id=#{params[:member_id]}")
    @uid=logged_in_hmm_user.id
    @family_member = FamilyMember.find(params[:member_id])
  end

  def edit_biography
    @current_page = 'manage my site'
    @current_item = "biography"
    @family_member = FamilyMember.find(params[:member_id])
    @chap= Tag.find(:all, :conditions => "uid=#{logged_in_hmm_user.id} and status='active' and default_tag='yes'")
    @chap_count= Tag.count(:all, :conditions => "uid=#{logged_in_hmm_user.id} and status='active' and default_tag='yes'")
  end

  def delete_biography
    FamilyMember.find(params[:member_id]).destroy
    flash[:message] = 'Family Biography has been Deleted Successfully!!'
    redirect_to :action => 'family_biographies',:id => params[:id]
  end

  def moveup_biography
    previousid=params[:prev]
    currentid=params[:currentid]
    famax =  FamilyMember.find_by_sql("select max(id) as m from family_members")
    if(famax[0]['m']=='')
      fa_next_id=1
    else
      famax=famax[0]['m']
      fa_next_id= Integer(famax) + 1
    end

    sql = ActiveRecord::Base.connection();
    sql.update "UPDATE family_members SET id = #{fa_next_id}  WHERE id =#{currentid}";

    sql.update "UPDATE family_members SET id = #{currentid}  WHERE id =#{previousid}";

    sql.update "UPDATE family_members SET id = #{previousid}  WHERE id =#{fa_next_id}";
    redirect_to :action => 'family_biographies',:id=>params[:id]

  end

  def movedown_biography
    nextid=params[:nextid]
    currentid=params[:currentid]
    famax =  FamilyMember.find_by_sql("select max(id) as m from family_members")
    if(famax[0]['m']=='')
      fa_next_id=1
    else
      famax=famax[0]['m']
      fa_next_id= Integer(famax) + 1
    end

    sql = ActiveRecord::Base.connection();
    sql.update "UPDATE family_members SET id = #{fa_next_id}  WHERE id =#{currentid}";

    sql.update "UPDATE family_members SET id = #{currentid}  WHERE id =#{nextid}";

    sql.update "UPDATE family_members SET id = #{nextid}  WHERE id =#{fa_next_id}";
    redirect_to :action => 'family_biographies',:id=>params[:id]

  end

  def write_familyhistory
    @current_page = 'manage my site'
    @current_item = "biography"
    @hmm_user = HmmUser.find(@family_website_owner.id)
    
    unless params[:hmm_user].blank?
      if @hmm_user.update_attributes(params[:hmm_user])
        flash[:message] = 'Your Family History information has been Successfully Updated.'
        redirect_to :action => "family_biographies", :id => params[:id]
      end
    end

  end


  
end
