class UserAccountController < ApplicationController
  #layout "standard"
  before_filter :set_facebook_session
  include ApplicationHelper
  helper_method :facebook_session
  rescue_from Facebooker::Session::SessionExpired, :with => :facebook_session_expired
  layout :phone_or_desktop

  #ssl_allowed :authenticate, :facebook_vote,:kids_facebook_vote


  before_filter :change_ssl, :only => [:facebook_session_expired,:agree_terms,:update_terms,:update_terms_family,:index,:forgot_live,:forgot_security_q,:takeTour,:validate_email,:execute,:pop_studio_benefits,:pop_studio_benefits_general,:studio_benefits_cp,:map,:facebook_vote,:kids_facebook_vote]
#  ssl_required :home, :login,:logout,:authenticate
#  ssl_allowed  :studios_list,:facebook_session_expired,:agree_terms,:update_terms,:update_terms_family,:index,:forgot_live,:forgot_security_q,:takeTour,:validate_email,:execute,:pop_studio_benefits,:pop_studio_benefits_general,:studio_benefits_cp,:map,:facebook_vote,:kids_facebook_vote

  def change_ssl
    current= request.url.split("://")
    if current[0]== "https"
      redirect_to "http://#{current[1]}"
    end
  end

  def facebook_session_expired
    clear_fb_cookies!
    clear_facebook_session_information
    reset_session # remove your cookies!
    flash[:error2] = "Your facebook session has expired."
    redirect_to :url => "/user_account/login"
  end

  def login
    if session[:hmm_user]
      @hmm_user=HmmUser.find(session[:hmm_user])

    elsif session[:employe]
      redirect_to :controller => 'account', :action => 'my_customers'
    elsif session[:franchise]
      flash[:notice] = 'Account Created Successfully'
      redirect_to :controller => 'hmm_studiogroups', :action => 'create_account'
    end
    if session[:user]
      $notice_admin
      flash[:notice_admin] = 'Coupon Account has been successfully created.'
      redirect_to :controller => 'account', :action => 'index1'
    end
    if(params[:redirect_url]!='')
      session[:redirect_url]=params[:redirect_url]
    end

  end

  def studios_list
    @radius=params[:radius].split(' ')
    @result=ZipCode.zip_code_perimeter_search(params[:zipcode],@radius[0])
    pp @result

    if iphone_request?
      respond_to do |format|
        format.iphone do  # action.iphone.erb
        end
      end
    end
  end
  #  def authenticate
  #
  #   #redirect_to index_url+'account/'
  #
  #   self.logged_in_hmm_user = HmmUser.authenticate(params[:hmm_user][:v_user_name],params[:hmm_user][:v_password])
  #   #self.logged_in_hmm_user = HmmUser.authenticate("alok","alok")
  #   studio = HmmStudio.find(self.logged_in_hmm_user.studio_id) rescue nil
  #
  #    if is_userlogged_in?
  #      if logged_in_hmm_user.e_user_status == 'unblocked'
  #       #log file entry
  #       logger.info("[User]: #{params[:hmm_user][:v_user_name]} [Logged In] at #{Time.now} !")
  #       client_ip = request.remote_ip
  #       user_session = UserSessions.new()
  #       user_session['i_ip_add'] = client_ip
  #       user_session['uid'] = logged_in_hmm_user.id
  #       user_session['v_user_name'] = logged_in_hmm_user.v_user_name
  #       user_session['d_date_time'] = Time.now
  #       user_session['e_logged_in'] = "yes"
  #       user_session['e_logged_out'] = "no"
  #       user_session.save
  #       session[:alert] = "fnfalert"
  #       flag = 0
  #       hmm_payement_check = HmmUser.count(:all, :conditions => "id ='#{logged_in_hmm_user.id}' and account_expdate < CURDATE()")
  #       if (hmm_payement_check > 0)
  #         flag=1
  #       end
  #       if(session[:redirect_url]!=nil && session[:redirect_url]!='')
  #         url = session[:redirect_url]
  #         session[:redirect_url]=nil
  #         redirect_to url
  #       else
  #
  #          if(session[:employe]==nil && logged_in_hmm_user.terms_checked=='false' )
  #            if(logged_in_hmm_user.family_name=='' || logged_in_hmm_user.family_name==nil)
  #              uuid =  HmmUser.find_by_sql(" select UUID() as u")
  #              unnid = uuid[0]['u']
  #              hmmuser_family = HmmUser.find(logged_in_hmm_user.id)
  #              hmmuser_family.family_name="#{logged_in_hmm_user.id}#{unnid}un#{logged_in_hmm_user.id}"
  #              hmmuser_family.save
  #            end
  #            if(params[:othercustomerlogin])
  #              redirect_to :controller => 'account', :action => 'confirm_action'
  #            else
  #              redirect_to "/user_account/update_terms"
  #            end
  #          else
  #            if(flag==1 && request.request_uri != "/account_settings/upgrade_account_form/#{logged_in_hmm_user.family_name}?acc_type=platinum_account&option=1")
  #            #session[:flag]=1
  #              if(logged_in_hmm_user.family_name=='' || logged_in_hmm_user.family_name==nil)
  #                uuid =  HmmUser.find_by_sql(" select UUID() as u")
  #                unnid = uuid[0]['u']
  #                hmmuser_family = HmmUser.find(logged_in_hmm_user.id)
  #                hmmuser_family.family_name="#{logged_in_hmm_user.id}#{unnid}un#{logged_in_hmm_user.id}"
  #                hmmuser_family.save
  #              end
  #              if(params[:othercustomerlogin])
  #                redirect_to :controller => 'account', :action => 'confirm_action'
  #              else
  #                redirect_to "/account_settings/upgrade_account_form/#{logged_in_hmm_user.family_name}?acc_type=platinum_account&option=1"
  #              end
  #            else
  #              if(logged_in_hmm_user.family_name=='' || logged_in_hmm_user.family_name==nil)
  #                uuid =  HmmUser.find_by_sql(" select UUID() as u")
  #                unnid = uuid[0]['u']
  #                hmmuser_family = HmmUser.find(logged_in_hmm_user.id)
  #                hmmuser_family.family_name="#{logged_in_hmm_user.id}#{unnid}un#{logged_in_hmm_user.id}"
  #                hmmuser_family.save
  #                session[:family]=logged_in_hmm_user.family_name
  #                if(params[:othercustomerlogin])
  #                  redirect_to :controller => 'account', :action => 'confirm_action'
  #                else
  #                  if studio.family_website_version == 3
  #                    redirect_to :controller=>'familywebsite_studio',:action=>'home',:id=>logged_in_hmm_user.family_name
  #                  else
  #                    redirect_to :controller=>'familywebsite',:action=>'home',:id=>logged_in_hmm_user.family_name
  #                  end
  #                end
  #             else
  #                hmmuser_family_count = HmmUser.count(:conditions =>"family_name='#{logged_in_hmm_user.family_name}'")
  #                if(hmmuser_family_count > 1)
  #                  hmmuser_family = HmmUser.find(logged_in_hmm_user.id)
  #                  hmmuser_family.family_name="#{logged_in_hmm_user.family_name}#{logged_in_hmm_user.id}"
  #                  hmmuser_family.save
  #                end
  #                if(logged_in_hmm_user.msg=='0')
  #                  session[:family]=logged_in_hmm_user.family_name
  #                  if(params[:othercustomerlogin])
  #                    redirect_to :controller => 'account', :action => 'confirm_action'
  #                  else
  #                     if studio.family_website_version == 3
  #                      redirect_to :controller=>'familywebsite_studio',:action=>'home',:id=>logged_in_hmm_user.family_name
  #                    else
  #                      redirect_to :controller=>'familywebsite',:action=>'home',:id=>logged_in_hmm_user.family_name
  #                    end
  #                  end
  #                else
  #                  session[:family]=logged_in_hmm_user.family_name
  #                  if(params[:othercustomerlogin])
  #                      redirect_to :controller => 'account', :action => 'confirm_action'
  #                  else
  #                    if studio.family_website_version == 3
  #                    redirect_to :controller=>'familywebsite_studio',:action=>'home',:id=>logged_in_hmm_user.family_name
  #                  else
  #                    redirect_to :controller=>'familywebsite',:action=>'home',:id=>logged_in_hmm_user.family_name
  #                  end
  #                  end
  #                end
  #              end
  #            end
  #          end
  #        end
  #  else
  #    session[:hmm_user]=nil
  #    flash[:error1] = "User is been blocked.. Contact Admin!!"
  #    if(params[:othercustomerlogin])
  #      redirect_to :controller => 'account', action => 'othercustomer_login'
  #    else
  #      redirect_to "/user_account/login"
  #    end
  # end
  #else
  #      flash[:error] = "I'm sorry; either your username or password was incorrect."
  #       #log file entry
  #      logger.error("[Invalid Login]: by [User]:#{params[:hmm_user][:v_user_name]} at #{Time.now}")
  #     if(params[:othercustomerlogin])
  #      redirect_to :controller => 'account', action => 'othercustomer_login'
  #     else
  #      redirect_to :action => 'login'
  #     end
  #     return "false"
  # end
  #
  #
  #  end


  def authenticate

    #redirect_to index_url+'account/'

    self.logged_in_hmm_user = HmmUser.authenticate(params[:hmm_user][:v_user_name],params[:hmm_user][:v_password])
    #self.logged_in_hmm_user = HmmUser.authenticate("alok","alok")
    if is_userlogged_in?
      if logged_in_hmm_user.e_user_status == 'unblocked'
        #log file entry
        logger.info("[User]: #{params[:hmm_user][:v_user_name]} [Logged In] at #{Time.now} !")
        client_ip = request.remote_ip
        user_session = UserSessions.new()
        user_session['i_ip_add'] = client_ip
        user_session['uid'] = logged_in_hmm_user.id
        user_session['v_user_name'] = logged_in_hmm_user.v_user_name
        user_session['d_date_time'] = Time.now
        user_session['e_logged_in'] = "yes"
        user_session['e_logged_out'] = "no"
        user_session.save
        session[:alert] = "fnfalert"
        flag = 0
        sub_type=SubChapter.find(:first,:conditions=>"uid=#{logged_in_hmm_user.id} and status='active' and (client='mliphoneapp' || client='mlandriodapp')")
        if !sub_type.nil? && !sub_type.blank?
          contr= "family_memory"
        else
          if(logged_in_hmm_user.studio_id==0)
            contr= "familywebsite"
          else
            studio = HmmStudio.find(logged_in_hmm_user.studio_id)
            if(studio.family_website_version == 3)
              contr= "familywebsite_studio"
            elsif(studio.family_website_version == 4)
              contr= "family_memory"
            else
              contr= "familywebsite"
            end
          end
        end

        hmm_payement_check = HmmUser.count(:all, :conditions => "id ='#{logged_in_hmm_user.id}' and account_expdate < CURDATE()")
        if (hmm_payement_check > 0)
          flag=1
        end
        if(session[:redirect_url]!=nil && session[:redirect_url]!='')
          url = session[:redirect_url]
          session[:redirect_url]=nil
          redirect_to url
        else

          if(session[:employe]==nil && logged_in_hmm_user.terms_checked=='false' )
            if(logged_in_hmm_user.family_name=='' || logged_in_hmm_user.family_name==nil)
              uuid =  HmmUser.find_by_sql(" select UUID() as u")
              unnid = uuid[0]['u']
              hmmuser_family = HmmUser.find(logged_in_hmm_user.id)
              hmmuser_family.family_name="#{logged_in_hmm_user.id}#{unnid}un#{logged_in_hmm_user.id}"
              hmmuser_family.save
            end
            if(params[:othercustomerlogin])
              redirect_to :controller => 'account', :action => 'confirm_action'
            else
              redirect_to "/user_account/update_terms"
            end
          else
            if(flag==1 && request.request_uri != "/account_settings/upgrade_account_form/#{logged_in_hmm_user.family_name}?acc_type=platinum_account&option=1")
              #session[:flag]=1
              if(logged_in_hmm_user.family_name=='' || logged_in_hmm_user.family_name==nil)
                uuid =  HmmUser.find_by_sql(" select UUID() as u")
                unnid = uuid[0]['u']
                hmmuser_family = HmmUser.find(logged_in_hmm_user.id)
                hmmuser_family.family_name="#{logged_in_hmm_user.id}#{unnid}un#{logged_in_hmm_user.id}"
                hmmuser_family.save
              end
              if(params[:othercustomerlogin])
                redirect_to :controller => 'account', :action => 'confirm_action'
              else
                redirect_to "/account_settings/upgrade_account_form/#{logged_in_hmm_user.family_name}?acc_type=platinum_account&option=1"
              end
            else
              if(logged_in_hmm_user.family_name=='' || logged_in_hmm_user.family_name==nil)
                uuid =  HmmUser.find_by_sql(" select UUID() as u")
                unnid = uuid[0]['u']
                hmmuser_family = HmmUser.find(logged_in_hmm_user.id)
                hmmuser_family.family_name="#{logged_in_hmm_user.id}#{unnid}un#{logged_in_hmm_user.id}"
                hmmuser_family.save
                session[:family]=logged_in_hmm_user.family_name
                if(params[:othercustomerlogin])
                  redirect_to :controller => 'account', :action => 'confirm_action'
                else
                  redirect_to :controller=>"#{contr}",:action=>'home',:id=>logged_in_hmm_user.family_name
                end
              else
                hmmuser_family_count = HmmUser.count(:conditions =>"family_name='#{logged_in_hmm_user.family_name}'")
                if(hmmuser_family_count > 1)
                  hmmuser_family = HmmUser.find(logged_in_hmm_user.id)
                  hmmuser_family.family_name="#{logged_in_hmm_user.family_name}#{logged_in_hmm_user.id}"
                  hmmuser_family.save
                end
                if(logged_in_hmm_user.msg=='0')
                  session[:family]=logged_in_hmm_user.family_name
                  if(params[:othercustomerlogin])
                    redirect_to :controller => 'account', :action => 'confirm_action'
                  else
                    redirect_to :controller=>"#{contr}",:action=>'home',:id=>logged_in_hmm_user.family_name
                  end
                else
                  session[:family]=logged_in_hmm_user.family_name
                  if(params[:othercustomerlogin])
                    redirect_to :controller => 'account', :action => 'confirm_action'
                  else
                    redirect_to :controller=>"#{contr}",:action=>'home',:id=>logged_in_hmm_user.family_name
                  end
                end
              end
            end
          end
        end
      else
        session[:hmm_user]=nil
        flash[:error1] = "User is been blocked.. Contact Admin!!"
        if(params[:othercustomerlogin])
          redirect_to :controller => 'account', action => 'othercustomer_login'
        else
          redirect_to "/user_account/login"
        end
      end
    else
      flash[:error] = "I'm sorry; either your username or password was incorrect."
      #log file entry
      logger.error("[Invalid Login]: by [User]:#{params[:hmm_user][:v_user_name]} at #{Time.now}")
      if(params[:othercustomerlogin])
        redirect_to :controller => 'account', action => 'othercustomer_login'
      else
        redirect_to :action => 'login'
      end
      return "false"
    end


  end



  def agree_terms
    hmmuser_family = HmmUser.find(logged_in_hmm_user.id)
    hmmuser_family.terms_checked='true'
    hmmuser_family.save
    sub_type=SubChapter.find(:first,:conditions=>"uid=#{logged_in_hmm_user.id} and status='active' and (client='mliphoneapp' || client='mlandriodapp')")
    if !sub_type.nil? && !sub_type.blank?
      redirect_to :controller => "family_memory", :action => 'home', :id => params[:id]
    else
      if hmmuser_family.studio_id.to_i!=0
        version=HmmStudio.find(:first,:select=>"family_website_version",:conditions=>"id=#{hmmuser_family.studio_id}")
        if version.family_website_version.to_i == 3
          redirect_to :controller=>'familywebsite_studio',:action=>'home',:id=>logged_in_hmm_user.family_name
        elsif version.family_website_version.to_i ==4
          redirect_to :controller=>'family_memory',:action=>'home',:id=>logged_in_hmm_user.family_name
        else
          redirect_to :controller=>'manage_website',:action=>'home',:id=>logged_in_hmm_user.family_name
        end
      else
        redirect_to :controller=>'manage_website',:action=>'home',:id=>logged_in_hmm_user.family_name
      end
    end
  end


  def update_terms

  end

  def update_pass_family
    @hmmuser_family = HmmUser.find(logged_in_hmm_user.id)
    render :layout =>false
  end

  def update_family_pass
    if !params[:family_name].blank? || !params[:password].blank?
      user = HmmUser.find(logged_in_hmm_user.id)
      if params[:sub] == "Change"
        sql = ActiveRecord::Base.connection();
        sql.update "UPDATE hmm_users SET v_password='#{params[:password]}' WHERE id=#{logged_in_hmm_user.id}";
        flash[:error_pass]= "Password updated successfully!"
        family = HmmUser.find(:first, :conditions => "id!=#{logged_in_hmm_user.id} and (family_name like '#{removefamilySymbols(params[:family_name])}' or alt_family_name like '#{removefamilySymbols(params[:family_name])}')")
        unless family
          user.family_name=removefamilySymbols(params[:family_name])
          user.password_reset= "true"
          user.familyname_reset= "true"
          user.save
          logger.info("user.save")
          logged_in_hmm_user.family_name = removefamilySymbols(params[:family_name])
          flash[:error_family] = "Website address updated successfully!"
          redirect_to :controller => "user_account", :action => "update_terms"
        else
          flash[:error_family]= "Family name already exists!"
          redirect_to :controller=>"user_account", :action => "update_terms"
        end
      elsif params[:sub] == "No Thanks"
        user.password_reset= "true"
        user.familyname_reset= "true"
        user.save
        redirect_to :controller => "user_account", :action => "update_terms"
      else
        redirect_to :controller => "user_account", :action => "update_terms"
      end
    else
      redirect_to :controller=>"user_account", :action => "update_terms"
    end
  end

  def update_terms_family

  end

  def logout

    user = HmmUser.find(session[:hmm_user])

    if user.studio_id == 0
    else
      studio = HmmStudio.find(user.studio_id) rescue nil
    end


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

      session[:hmm_user]=nil
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
    sub_type=SubChapter.find(:first,:conditions=>"uid=#{user.id} and status='active' and (client='mliphoneapp' || client='mlandriodapp')")
    if !sub_type.nil? && !sub_type.blank?
      redirect_to :controller => 'family_memory',:action => 'home',:id=>user.family_name
    else
      if studio.nil?
        redirect_to "/user_account/login"
      elsif studio.family_website_version == 3
        redirect_to :controller => 'familywebsite_studio',:action => 'home',:id=>user.family_name
      elsif studio.family_website_version == 4
        redirect_to :controller => 'family_memory',:action => 'home',:id=>user.family_name
      else
        redirect_to "/user_account/login"
      end
    end

  end



  def index
    id=params[:id]
    if(id=='' || id==nil)
    else

      redirect_to :controller => 'familywebsite', :action => 'index', :id => id
    end
    if session[:hmm_user]
      @hmm_user=HmmUser.find(session[:hmm_user])
    end
  end

  def Scripts

  end


  def forgot_live

    @phrase = request.raw_post.chop || request.query_string
    @searchphrase = @phrase
    @results = HmmUser.find(:all, :conditions => [ "v_user_name LIKE ?", @searchphrase])
    @number_match = @results.length
    render(:layout => false)
  end

  def forgot_security_q
    @phrase1 = request.raw_post.chop || request.query_string
    @searchphrase1 = @phrase1
    @results1 = HmmUser.find(:all, :conditions => [ "id='#{params[:id]}' and  v_security_a LIKE ?", @searchphrase1])
    @number_match1 = @results1.length
    if @results1.empty?
    else
      for @i in @results1
        name=@i['v_fname']
        @email=@i['v_e_mail']
        username=@i['v_user_name']
        pass=@i['v_password']
      end
      Postoffice.deliver_deliverpass(name, @email, username, pass)

    end
    render(:layout => false)
  end

  def takeTour

  end

  def iphonelogin
    #redirect_to index_url+'account/'

    self.logged_in_hmm_user = HmmUser.authenticate(params[:v_user_name],params[:v_password])
    #self.logged_in_hmm_user = HmmUser.authenticate("alok","alok")
    if is_userlogged_in?
      if logged_in_hmm_user.e_user_status == 'unblocked'
        #log file entry
        logger.info("[User]: #{params[:v_user_name]} [Logged In] at #{Time.now} !")
        @sucess=1

      else
        session[:hmm_user]=nil
        #flash[:error1] = "User is been blocked.. Contact Admin!!"
        @blocked=1
        @sucess=-1
      end
    else
      session[:hmm_user]=nil
      #flash[:error] = "I'm sorry; either your username or password was incorrect."
      #log file entry
      logger.error("[Invalid Login]: by [User]:#{params[:v_user_name]} at #{Time.now}")
      @sucess=-1
      return "false"
    end
    render :layout => false

  end

  def logoutiphone
    reset_session
    #redirect_to "/user_account/iphonelogin"
    render :layout => false
  end

  def forgot_password_new

  end

  def validate_email
    color = 'red'
    email = params[:email]
    mail = HmmUser.find_all_by_v_e_mail(email)
    if mail.size > 0
      message_email = 'Email Authenticated'
      color = 'green'
      @valid_email = true
    else
      message_email = 'Email does not exist'
      @valid_email = false
    end
    @message_email = "<b style='color:#{color}'>#{message_email}</b>"
    render :partial=>'message_email'
  end

  def execute
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
    redirect_to :action => 'conform'
  end

  def authenticate_iphone_user
    logged_in_iphone_user = HmmUser.find_by_v_user_name_and_v_password("zabi","zabi", :conditions => "e_user_status == 'unblocked'")
    #puts logged_in_employe.id
    if logged_in_iphone_user
      render :json => {:status => "true", :message => "login successfully"}.to_json
    else

    end
  end

  def studio

  end

  def pop_studio_benefits
    @studio = HmmStudio.find(params[:studio_id])
    studiogroup_benefits = StudioBenefit.find(:all,:conditions => "studio_group_id=#{@studio.studio_groupid}",:select => "*")
    studio_benefits = StudioBenefit.find(:all,:conditions => "studio_id=#{params[:studio_id]}",:select => "*")
    @benefits = studiogroup_benefits + studio_benefits
    render :layout => false
  end

  def pop_studio_benefits_general
    render :layout => false
  end

  def studio_benefits_cp
    @studio = HmmStudio.find(params[:studio_id])
    studiogroup_benefits = StudioBenefit.find(:all,:conditions => "studio_group_id=#{@studio.studio_groupid}",:select => "*")
    studio_benefits = StudioBenefit.find(:all,:conditions => "studio_id=#{params[:studio_id]}",:select => "*")
    @benefits = studiogroup_benefits + studio_benefits
    render :layout => false
  end

  def map
    if iphone_request?
      respond_to do |format|
        format.iphone do  # action.iphone.erb
        end
      end
    else
      render :layout => false
    end

  end


  def facebook_vote
    type=params[:type]
    moment_id = params[:id]
    contest = Contest.find(:first, :conditions => "moment_id='#{moment_id}'")
    contest_phase = ContestDetail.find_by_contest_phase(contest.contest_phase)
    uid = contest.uid
    contetsid = contest.id
    contetsfname = contest.first_name
    moment_type = contest.moment_type
    contest_name = "contests"
    if params[:contest_name]
      contest_name = params[:contest_name].to_s
    end

    if facebook_session

      vote_email=facebook_session.user.email
      if(vote_email)
        my_date_time = Date.today
        contest_vote = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and email_id = '#{vote_email}' and vote_date = '#{my_date_time}' ")
        if contest_vote <= 0
          #calculating next id for the contest vote table
          contestvote_max =  ContestVotes.find_by_sql("select max(id) as n from contest_votes")
          contestvote_max_id = "#{contestvote_max[0].n}"
          if(contestvote_max_id == '')
            contestvote_max_id = '0'
          end
          contestvote_next_id = Integer(contestvote_max_id) + 1
          #creating unid for the vote conform
          contestuuid=Share.find_by_sql("select uuid() as uid")
          unid=contestuuid[0].uid+""+"#{contestvote_next_id}"
          #inserting new values into contest vote table
          vote = ContestVotes.new()
          vote['uid']=uid
          vote['contest_id']= contetsid
          vote['email_id']= vote_email
          vote['vote_date']= Time.now
          vote['unid'] = unid
          vote['conformed'] = 'yes'
          vote['method']="facebook"
          if vote.save
            @contest_vote_count = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and conformed='yes'")
            countest_update = Contest.find(contetsid)
            countest_update.votes = @contest_vote_count
            countest_update.save

            #calculation for new votes
            @count = ContestVotes.count_by_sql("select COUNT(distinct CONCAT(IFNULL(email_id,''),IFNULL(hmm_voter_id,''))) AS COUNT from contest_votes where contest_id='#{contetsid}' and conformed='yes'")
            countest_update = Contest.find(contetsid)
            countest_update.new_votes = @count
            countest_update.save
            $notice_vote1
            flash[:notice_vote] = 'Thank-you for casting your vote. Your Vote has been confirmed.'
            #Postoffice.deliver_voteconform(params[:email],contetsid, unid,moment_filename,contetsfname,user_fname,user_lname,moment_type,paths.proxyname,momentid)
            logger.info("hai")
            if(moment_type.to_s=='video')
              redirect_to "/contests/videomoment_vote?contest_id=#{contest_phase.id}"
            else
              redirect_to "/contests/moments_vote?contest_id=#{contest_phase.id}"
            end
          else
            $notice_vote
            flash[:notice_vote] = 'Your was not submitted due to technical issue... Please try again.'
            if(moment_type.to_s=='video')
              redirect_to "/contests/videomoment_vote?contest_id=#{contest_phase.id}"
            else
              redirect_to "/contests/moments_vote?contest_id=#{contest_phase.id}"
            end
          end
        else
          $notice_vote
          flash[:notice_vote] = 'You have already voted for this moment.. you can cast your vote only once per family.'
          if(moment_type.to_s=='video')
            redirect_to "/contests/videomoment_vote?contest_id=#{contest_phase.id}"
          else
            redirect_to "/contests/moments_vote?contest_id=#{contest_phase.id}"
          end
        end
      else
        flash[:notice_vote] = 'You must permit your Facebook email address to be fetched for casting your vote.'
        if(moment_type.to_s=='video')
          redirect_to "/contests/videomoment_details?moment_id=#{moment_id}&contest_id=#{contest_phase.id}"
        else
          redirect_to "/contests/momentdetails?moment_id=#{moment_id}&contest_id=#{contest_phase.id}"
        end
      end


    else
      flash[:notice_vote] = 'Your Facebook session has been expired. Please try again.'
      if(moment_type.to_s=='video')
        redirect_to "/contests/videomoment_details?moment_id=#{moment_id}&contest_id=#{contest_phase.id}"
      else
        redirect_to "/contests/momentdetails?moment_id=#{moment_id}&contest_id=#{contest_phase.id}"
      end
    end
  end


  def kids_facebook_vote
    type=params[:type]
    moment_id=params[:id]
    contest = Contest.find(:first, :conditions => "moment_id='#{moment_id}'")
    uid = contest.uid
    contetsid = contest.id
    contetsfname = contest.first_name
    moment_type = contest.moment_type
    if facebook_session

      vote_email=facebook_session.user.email
      if(vote_email)
        if params[:vote]=="daily"
          my_date_time = Date.today
          contest_vote = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and email_id = '#{vote_email}' and vote_date = '#{my_date_time}' ")
        else
          contest_vote = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and email_id = '#{vote_email}'")
        end
        if contest_vote <= 0
          #calculating next id for the contest vote table
          contestvote_max =  ContestVotes.find_by_sql("select max(id) as n from contest_votes")
          contestvote_max_id = "#{contestvote_max[0].n}"
          if(contestvote_max_id == '')
            contestvote_max_id = '0'
          end
          contestvote_next_id = Integer(contestvote_max_id) + 1
          #creating unid for the vote conform
          contestuuid=Share.find_by_sql("select uuid() as uid")
          unid=contestuuid[0].uid+""+"#{contestvote_next_id}"
          #inserting new values into contest vote table
          vote = ContestVotes.new()
          vote['uid']=uid
          vote['contest_id']= contetsid
          vote['email_id']= vote_email
          vote['vote_date']= Time.now
          vote['unid'] = unid
          vote['conformed'] = 'yes'
          vote['method']="facebook"
          if vote.save
            @contest_vote_count = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and conformed='yes'")
            countest_update = Contest.find(contetsid)
            countest_update.votes = @contest_vote_count
            countest_update.save

            #calculation for new votes
            @count = ContestVotes.count_by_sql("select COUNT(distinct CONCAT(IFNULL(email_id,''),IFNULL(hmm_voter_id,''))) AS COUNT from contest_votes where contest_id='#{contetsid}' and conformed='yes'")
            countest_update = Contest.find(contetsid)
            countest_update.new_votes = @count
            countest_update.save
            $notice_vote1
            flash[:notice_vote] = 'Thank-you for casting your vote. Your Vote has been confirmed.'
            #Postoffice.deliver_voteconform(params[:email],contetsid, unid,moment_filename,contetsfname,user_fname,user_lname,moment_type,paths.proxyname,momentid)
            logger.info("hai")
            if(moment_type.to_s=='video')
              redirect_to :controller => "kidscontests", :action => 'videomoment_vote'
            else
              redirect_to :controller => "kidscontests", :action => 'moments_vote'
            end
          else
            $notice_vote
            flash[:notice_vote] = 'Your was not submitted due to technical issue... Please try again.'
            if(moment_type.to_s=='video')
              redirect_to :controller => "kidscontests",:action => 'videomoment_vote'
            else
              redirect_to :controller => "kidscontests",:action => 'moments_vote'
            end
          end
        else
          $notice_vote
          flash[:notice_vote] = 'You have already voted for this moment.. you can cast your vote only once per family.'
          if(moment_type.to_s=='video')
            redirect_to :controller => "kidscontests", :action => 'videomoment_vote'
          else
            redirect_to :controller => "kidscontests", :action => 'moments_vote'
          end
        end
      else
        flash[:notice_vote] = 'You must permit your Facebook email address to be fetched for casting your vote.'
        if(moment_type.to_s=='video')
          redirect_to :controller => "kidscontests", :action => 'videomoment_details', :id=> moment_id
        else
          redirect_to :controller => "kidscontests", :action => 'momentdetails', :id => moment_id
        end
      end


    else
      flash[:notice_vote] = 'Your Facebook session has been expired. Please try again.'
      if(moment_type.to_s=='video')
        redirect_to :controller => "kidscontests", :action => 'videomoment_details', :id=> moment_id
      else
        redirect_to :controller => "kidscontests", :action => 'momentdetails', :id => moment_id
      end
    end
  end

  def feedback
    Emergencymailer.deliver_feedback(params[:urname], params[:uremail] , params[:urcomment])
    Emergencymailer.deliver_thankyou(params[:urname], params[:uremail] , params[:urcomment])
    render :action => 'thankyou', :layout => false
  end

  def face_book_logged_in
    if facebook_session
      hmmcount=HmmUser.count(:all,:conditions => "facebook_connect_id='#{facebook_session.user.uid}' || v_e_mail='#{facebook_session.user.email}' || v_user_name='#{facebook_session.user.email}'")
      if(hmmcount > 0)
        hmmuserdet=HmmUser.find(:all, :select => "v_user_name as vu, v_password as vp", :conditions => "facebook_connect_id='#{facebook_session.user.uid}'  || v_e_mail='#{facebook_session.user.email}'  || v_user_name='#{facebook_session.user.email}'")
        redirect_to  "/user_account/authenticate/?hmm_user[v_user_name]=#{hmmuserdet[0].vu}&hmm_user[v_password]=#{hmmuserdet[0].vp}"
      else
        logger.info(facebook_session.user.inspect)
        @fuser=facebook_session.user.pic_big
        @other=facebook_session.user.name
        @sex=facebook_session.user.sex
        @aboutme=facebook_session.user.about_me
        @emailid=facebook_session.user.email
        @user = HmmUser.new()
        @user.v_fname=facebook_session.user.first_name
        @user.v_lname=facebook_session.user.last_name
        @user.e_sex=facebook_session.user.sex
        @user.v_user_name=facebook_session.user.email
        @user.v_password="test"
        @user.v_country="USA"
        @user.v_zip="111111"
        @user.v_e_mail=facebook_session.user.email
        @user.d_created_date=Time.now
        @user.d_updated_date=Time.now
        @user.d_bdate="2000-01-01"
        @user.v_abt_me=facebook_session.user.about_me
        @user.facebook_connect_id=facebook_session.user.uid

        #To find the maximum user id
        @hmm_user_max =  HmmUser.find_by_sql("select max(id) as n from hmm_users")
        for hmm_user_max in @hmm_user_max
          hmm_user_max_id = "#{hmm_user_max.n}"
        end
        if(hmm_user_max_id == '')
          hmm_user_max_id = '0'
        end
        hmm_user_next_id= Integer(hmm_user_max_id) + 1
        @uuid =  HmmUser.find_by_sql(" select UUID() as u")
        unnid = @uuid[0]['u']
        @user.family_name="#{hmm_user_next_id}#{unnid}un#{hmm_user_next_id}"
        @user.id=hmm_user_next_id
        max = UserContent.find(:first,:order=>"id desc",:select=>"id")
        max=max.id+1
        filename = "#{hmm_user_next_id}_familyicon.jpg"
        @user.family_pic=filename
        @user.save
        paths=ContentPath.find(:first,:conditions=>"status='active'")
        redirect_to  "#{paths.content_path}/face_book_connect_content/insert_image?image=#{facebook_session.user.pic_big}&id=#{@user.id}&fam_name=#{@user.family_name}&filename=#{filename}"
      end
    else
      @fuser = ""
      redirect_to :controller => "user_account", :action => 'login'
    end
  end


  private

  def phone_or_desktop
    iphone_request? ? "iphone_application" : "application"
  end

end