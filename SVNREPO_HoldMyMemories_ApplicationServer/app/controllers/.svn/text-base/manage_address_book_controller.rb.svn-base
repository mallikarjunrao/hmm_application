class ManageAddressBookController < ApplicationController
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
        elsif !session[:hmm_user] || logged_in_hmm_user.id!=@family_website_owner.id
          redirect_to "/familywebsite/login/#{params[:id]}"
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

  def list
    @current_item = 'address book'
    @current_page = 'manage my site'
    @uid=@family_website_owner.id
    @items_per_page=15
    conditions = "uid=#{@uid} and ((v_name LIKE '#{params[:query_hmm_user]}%' or v_email LIKE '#{params[:query_hmm_user]}%'))"
    @hmm_users_count = NonhmmUser.find(:all,:conditions =>"#{conditions}",:group=>"v_email")
    @total=@hmm_users_count.size
    @hmm_users = NonhmmUser.paginate   :per_page => @items_per_page,:page => params[:page],:group =>"v_email", :conditions => "uid=#{@uid} and ((v_name LIKE '#{params[:query_hmm_user]}%' or v_email LIKE '#{params[:query_hmm_user]}%'))" ,:order => "v_name ASC"
  end

  def add
    @current_item = 'address book'
    @current_page = 'manage my site'
    unless params[:name].blank? && params[:email].blank? 
      @nonhmm_user = NonhmmUser.new()
      @nonhmm_user['uid'] = @family_website_owner.id
      @nonhmm_user['v_name'] =params[:name]
      @nonhmm_user['v_email'] =params[:email]
      @nonhmm_user['v_phone'] =params[:phone]
      @nonhmm_user['v_street'] =params[:address]
      @hmm_user=HmmUser.find(@family_website_owner.id)
      nonhmm_user_check =  NonhmmUser.count(:all, :conditions =>" uid='#{@family_website_owner.id}' and v_email='#{params[:email]}'")

      if nonhmm_user_check == 0
        @nonhmm_user.save
        #invite email
        if params[:invite]=='yes'

          if params[:pass]=='yes'
            Postoffice.deliver_invite2(@hmm_user.v_fname,@hmm_user.v_e_mail,params[:email],@hmm_user.familywebsite_password,@hmm_user.family_name)
          else
            Postoffice.deliver_invite2(@hmm_user.v_fname,@hmm_user.v_e_mail,params[:email],'no',@hmm_user.family_name)
          end
        end
        flash[:message] = 'New contact added successfully!'
        redirect_to :controller => 'manage_address_book', :action => 'list' , :id=>params[:id]
      else
        flash[:message] = 'Contact already exists!'
        redirect_to :controller => 'manage_address_book', :action => 'list' , :id=>params[:id]
      end
    end
  end


  def view_details
    @current_item = 'address book'
    @current_page = 'manage my site'
    @nonhmm_user = NonhmmUser.find(:first,:conditions=>"id=#{params[:uid]}")
    subdomain = request.subdomains[0]
    if subdomain==nil
      subdomain = 'www'
    end   
    conditions2 = "v_e_mail LIKE '#{@nonhmm_user.v_email}%'"
    @hmm = HmmUser.find(:first,:conditions =>"#{conditions2}")
    @ulink="http://#{subdomain}.holdmymemories.com/#{@hmm.family_name}" if @hmm
  end


  def update
    @current_item = 'address book'
    @nonhmm_user = NonhmmUser.find(params[:uid])
    if(@nonhmm_user.v_email!=params[:email])
      nonhmm_user_check =  NonhmmUser.count(:all, :conditions =>" uid='#{@family_website_owner.id}' and v_email='#{params[:email]}'")
      if nonhmm_user_check == 0
        @nonhmm_user['v_name'] =params[:name]
        @nonhmm_user['v_email'] =params[:email]
        @nonhmm_user['v_street'] =params[:address]
        @nonhmm_user['v_phone'] =params[:phone]
        @nonhmm_user.save
        flash[:message] = 'Contact details updated successfully!'
        redirect_to :action => 'list', :id => params[:id]
      else
        flash[:message] = 'Email address already exists in Contact'
        redirect_to :action => 'list', :id => params[:id]
      end
    else
      @nonhmm_user['v_name'] =params[:name]
      @nonhmm_user['v_email'] =params[:email]
      @nonhmm_user['v_street'] =params[:address]
      @nonhmm_user['v_phone'] =params[:phone]
      @nonhmm_user.save
      flash[:message] = 'Contact details updated successfully!'
      redirect_to :action => 'list', :id => params[:id]
    end
  end

  def delete_contact
  
    NonhmmUser.find(params[:uid]).destroy
    flash[:message] = 'Contact deleted successfully!'
    redirect_to :controller => 'manage_address_book', :action => 'list' , :id=>params[:id]
  end
 
end