class AccountSettingsController < ApplicationController
  layout 'familywebsite'
  include UserAccountHelper
  require 'rubygems'
  require 'base64'
  require 'money'
  require 'active_merchant'
  require "ArbApiLib"
  before_filter  :check_account #checks for valid family name, terms of use check and user block check

  def initialize()
    @current_page = 'manage my site'
    @hide_float_menu = true
  end
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
          @content_server_name = @path.proxyname
          return true #returns true if all the conditions are cleared
        end
      else
        redirect_to '/'
      end
    end
  end

  #  def home
  #    @current_item = 'account_settings'
  #    @credit_count=CreditPoint.count(:all,:conditions=>"user_id=#{@family_website_owner.id}")
  #    unless @credit_count==0
  #      @credit_points=CreditPoint.find(:first,:conditions => "user_id=#{@family_website_owner.id}")
  #      @studio_groups=HmmUser.find(:first,:select => "a.*,b.*,c.*,d.* ", :joins =>"as a ,employe_accounts as b,hmm_studios as c,hmm_studiogroups  as d ",:conditions => "a.id=#{@family_website_owner.id} and b.id=a.emp_id and b.store_id=c.id and c.studio_groupid=d.id ")
  #    end
  #  end

  def home
    @current_item = 'account_settings'
    @credit_count=CreditPoint.count(:all,:conditions=>"user_id=#{@family_website_owner.id}")
    @benefits = ""
    #unless @credit_count==0
    @credit_points=CreditPoint.find(:first,:conditions => "user_id=#{@family_website_owner.id}")
    @studio_groups=HmmUser.find(:first,:select => "a.*,b.*,c.*,d.* ", :joins =>"as a ,employe_accounts as b,hmm_studios as c,hmm_studiogroups  as d ",:conditions => "a.id=#{@family_website_owner.id} and b.id=a.emp_id and b.store_id=c.id and c.studio_groupid=d.id ")
    if(@studio_groups)
      studiogroup_benefits = StudioBenefit.find(:all,:conditions => "studio_group_id=#{@studio_groups.studio_groupid}",:select => "*")
      studio_benefits = StudioBenefit.find(:all,:conditions => "studio_id=#{@studio_groups.store_id}",:select => "*")
      @benefits = studiogroup_benefits + studio_benefits
    end

  end

  def pop1
    @current_item = 'account_settings'
    @credit_count=CreditPoint.count(:all,:conditions=>"user_id=#{@family_website_owner.id}")
    @benefits = ""
    #unless @credit_count==0
    @credit_points=CreditPoint.find(:first,:conditions => "user_id=#{@family_website_owner.id}")
    @studio_groups=HmmUser.find(:first,:select => "a.*,b.*,c.*,d.* ", :joins =>"as a ,employe_accounts as b,hmm_studios as c,hmm_studiogroups  as d ",:conditions => "a.id=#{@family_website_owner.id} and b.id=a.emp_id and b.store_id=c.id and c.studio_groupid=d.id ")
    if(@studio_groups)
      studiogroup_benefits = StudioBenefit.find(:all,:conditions => "studio_group_id=#{@studio_groups.studio_groupid}",:select => "*")
      studio_benefits = StudioBenefit.find(:all,:conditions => "studio_id=#{@studio_groups.store_id}",:select => "*")
      @benefits = studiogroup_benefits + studio_benefits
    end



    #end
    render :layout => false
  end

  def pop2
    @current_item = 'account_settings'

    render :layout => false
  end

  def generate_receipt
    @hmm_user=HmmUser.find(@family_website_owner.id)
    render :layout => false
  end

  def cancel_subscription

  end

  def new_cancel_subscription

  end

  def cancel_sub
    reason = params[:reason]
    hmm_user = HmmUser.find(logged_in_hmm_user.id)
    if hmm_user.cancel_status == "approved" || hmm_user.cancel_status == "pending"
      flash[:sucess_id] = "You have already cancelled your subscription."
    elsif hmm_user.account_type == "free_user"
      hmm_user.cancel_reason=params[:reason]
      hmm_user.cancel_status='approved'
      hmm_user.cancellation_request_date = Time.now
      hmm_user.save
      hmm_user_day_dif =  HmmUser.find_by_sql("select (To_days( account_expdate ) - TO_DAYS( CURRENT_DATE() )) as difr from hmm_users where id='#{logged_in_hmm_user.id}'")
      no_of_days=hmm_user_day_dif[0].difr
      family_pic=hmm_user.family_pic
      img_url=hmm_user.img_url
      if(hmm_user.emp_id == nil || hmm_user.emp_id == "" || hmm_user.emp_id == 0 )
        Postoffice.deliver_cancellation_request("admin","admin@holdmymemories.com,Rachel.Allen@S121.com,Bob.Eveleth@S121.com,Dan.Quinlan@holdmymemories.com,customerservice@holdmymemories.com", reason,"nil",logged_in_hmm_user.id)
        Postoffice.deliver_cancellation_request_response("admin@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,family_pic,no_of_days,img_url)
      else
        store_employee = EmployeAccount.find(hmm_user.emp_id)
        Postoffice.deliver_cancellation_request(store_employee.employe_name,"#{store_employee.e_mail},Rachel.Allen@S121.com,Bob.Eveleth@S121.com,Dan.Quinlan@holdmymemories.com,customerservice@holdmymemories.com", reason,store_employee.store_id,logged_in_hmm_user.id)
        Postoffice.deliver_cancellation_request_response(store_employee.e_mail,logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,family_pic,no_of_days,img_url)
      end
      @array=TrackAccount.find(:first)
      @array.canceled =@array.canceled.to_i+1
      @array.save

      flash[:sucess_id] = "Subscription has been cancelled sucessfully."
    else
      hmm_user.cancel_reason=params[:reason]
      hmm_user.cancel_status='pending'
      hmm_user.cancellation_request_date = Time.now
      hmm_user.save
      hmm_user_day_dif =  HmmUser.find_by_sql("select (To_days( account_expdate ) - TO_DAYS( CURRENT_DATE() )) as difr from hmm_users where id='#{logged_in_hmm_user.id}'")
      no_of_days=hmm_user_day_dif[0].difr
      family_pic=hmm_user.family_pic
      img_url=hmm_user.img_url

      #Credit points should be calculated here
      #----------------------------------------------------

      #creditpoints=0
      if(hmm_user.emp_id == nil || hmm_user.emp_id == "" || hmm_user.emp_id == 0 )
        Postoffice.deliver_cancellation_request("admin","admin@holdmymemories.com,Rachel.Allen@S121.com,Bob.Eveleth@S121.com,Dan.Quinlan@holdmymemories.com,customerservice@holdmymemories.com", reason,"nil",logged_in_hmm_user.id)
        Postoffice.deliver_cancellation_request_response("admin@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,family_pic,no_of_days,img_url)
      else
        store_employee = EmployeAccount.find(hmm_user.emp_id)
        Postoffice.deliver_cancellation_request(store_employee.employe_name,"#{store_employee.e_mail},Rachel.Allen@S121.com,Bob.Eveleth@S121.com,Dan.Quinlan@holdmymemories.com,customerservice@holdmymemories.com", reason,store_employee.store_id,logged_in_hmm_user.id)
        Postoffice.deliver_cancellation_request_response(store_employee.e_mail,logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,family_pic,no_of_days,img_url)
      end

      #cancel the subcription
      require "ArbApiLib"
      aReq = ArbApi.new
      subnumber = logged_in_hmm_user.subscriptionnumber
      if(subnumber=='One time payment')
        @res="Your subscription has been canceled sucessfully."
      else
        if ARGV.length < 3
        end
        ARGV[0]= "https://api.authorize.net/xml/v1/request.api"
        ARGV[1]= "8GxD65y84"
        ARGV[2]= "89j6d34cW8CKhp9S"
        auth = MerchantAuthenticationType.new(ARGV[1], ARGV[2])
        subname = ARGV.length > 3? ARGV[3]: logged_in_hmm_user.account_type
        xmlout = aReq.CalcelSubscription(auth,subnumber)
        xmlresp1 = HttpTransport.TransmitRequest(xmlout, ARGV[0])
        apiresp = aReq.ProcessResponse1(xmlresp1)
        apiresp.messages.each { |message|
          puts "Error Code=" + message.code
          puts "Error Message = " + message.text
          @res =  message.text
        }
      end
      hmm_user = HmmUser.find(logged_in_hmm_user.id)
      uuid =  HmmUser.find_by_sql(" select UUID() as u")
      unnid = uuid[0]['u']
      hmm_user.cancel_status = 'approved'
      if(hmm_user.family_name=='' or hmm_user.family_name==nil)
        hmm_user.family_name="#{logged_in_hmm_user.id}#{unnid}un#{logged_in_hmm_user.id}"
      end
      if(session[:employe])
        hmm_user.canceled_by = "#{session[:employe]}"
      else
        hmm_user.canceled_by = "0"
      end
      hmm_user.save
      if(@res == "Successful.")
        @array=TrackAccount.find(:first)
        @array.canceled =@array.canceled.to_i+1
        @array.save
        flash[:sucess_id] = "Subscription has been cancelled sucessfully."
        #Postoffice.deliver_cancellation_approved("Admin","admin@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,logged_in_hmm_user.street_address,logged_in_hmm_user.postcode,logged_in_hmm_user.city,logged_in_hmm_user.state,logged_in_hmm_user.country,logged_in_hmm_user.telephone, reason)
        Postoffice.deliver_cancellation_request_complete("admin@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber, hmm_user['v_password'], logged_in_hmm_user.v_user_name)
      else
        flash[:sucess_id] = "Subscription status is: #{@res}"
      end

    end


    render :action => 'cancel_sucess', :id => logged_in_hmm_user.family_name

    #    reason = params[:reason]
    #   @hmm_user = HmmUser.find(logged_in_hmm_user.id)
    #   @hmm_user.cancel_reason=params[:reason]
    #   @hmm_user.cancel_status='pending'
    #   @hmm_user.cancellation_request_date = Time.now
    #   @hmm_user.save
    #   reason = params[:reason].gsub("'","`")
    #   sql = ActiveRecord::Base.connection();
    #   @hmm_user_day_dif =  HmmUser.find_by_sql("select (To_days( account_expdate ) - TO_DAYS( CURRENT_DATE() )) as difr from hmm_users where id='#{logged_in_hmm_user.id}'")
    #   no_of_days=@hmm_user_day_dif[0].difr
    #   family_pic=@hmm_user.family_pic
    #   img_url=@hmm_user.img_url
    #   if(@hmm_user.emp_id == nil || @hmm_user.emp_id == "")
    #    flash[:notice] = 'Your Subscription Cancellation request has been sent sucessfully.'
    #    Postoffice.deliver_cancellation_request("Admin","admin@holdmymemories.com,,Rachel.Allen@S121.com,Bob.Eveleth@S121.com,Dan.Quinlan@holdmymemories.com,customerservice@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,logged_in_hmm_user.street_address,logged_in_hmm_user.postcode,logged_in_hmm_user.city,logged_in_hmm_user.state,logged_in_hmm_user.country,logged_in_hmm_user.telephone, reason)
    #    Postoffice.deliver_cancellation_request_response("admin@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,family_pic,no_of_days,img_url)
    #   else
    #    @store_employee = EmployeAccount.find(@hmm_user.emp_id)
    #    flash[:notice] = 'Your Subscription Cancellation request has been sent sucessfully.'
    #    Postoffice.deliver_cancellation_request(@store_employee.employe_name,"#{@store_employee.e_mail},Rachel.Allen@S121.com,Bob.Eveleth@S121.com,Dan.Quinlan@holdmymemories.com,customerservice@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,logged_in_hmm_user.street_address,logged_in_hmm_user.postcode,logged_in_hmm_user.city,logged_in_hmm_user.state,logged_in_hmm_user.country,logged_in_hmm_user.telephone, reason)
    #    Postoffice.deliver_cancellation_request_response(@store_employee.e_mail,logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,family_pic,no_of_days,img_url)
    #   end
    #     render :action => 'cancel_sucess', :id=>params[:id]
  end


  def new_cancel_sub
    reason = params[:reason]
    hmm_user = HmmUser.find(logged_in_hmm_user.id)
    if hmm_user.cancel_status == "approved" || hmm_user.cancel_status == "pending"
      flash[:sucess_id] = "You have already cancelled your subscription."
    elsif hmm_user.account_type == "free_user"
      hmm_user.cancel_reason=params[:reason]
      hmm_user.cancel_status='approved'
      hmm_user.cancellation_request_date = Time.now
      hmm_user.save
      hmm_user_day_dif =  HmmUser.find_by_sql("select (To_days( account_expdate ) - TO_DAYS( CURRENT_DATE() )) as difr from hmm_users where id='#{logged_in_hmm_user.id}'")
      no_of_days=hmm_user_day_dif[0].difr
      family_pic=hmm_user.family_pic
      img_url=hmm_user.img_url
      if(hmm_user.emp_id == nil || hmm_user.emp_id == "" || hmm_user.emp_id == 0 )
        Postoffice.deliver_cancellation_request("admin","admin@holdmymemories.com,Rachel.Allen@S121.com,Bob.Eveleth@S121.com,Dan.Quinlan@holdmymemories.com,customerservice@holdmymemories.com", reason,"nil",logged_in_hmm_user.id)
        Postoffice.deliver_cancellation_request_response("admin@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,family_pic,no_of_days,img_url)
      else
        store_employee = EmployeAccount.find(hmm_user.emp_id)
        Postoffice.deliver_cancellation_request(store_employee.employe_name,"#{store_employee.e_mail},Rachel.Allen@S121.com,Bob.Eveleth@S121.com,Dan.Quinlan@holdmymemories.com,customerservice@holdmymemories.com", reason,store_employee.store_id,logged_in_hmm_user.id)
        Postoffice.deliver_cancellation_request_response(store_employee.e_mail,logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,family_pic,no_of_days,img_url)
      end
      @array=TrackAccount.find(:first)
      @array.canceled =@array.canceled.to_i+1
      @array.save

      flash[:sucess_id] = "Subscription has been cancelled sucessfully."
    else
      #        hmm_user.cancel_reason=params[:reason]
      #        hmm_user.cancel_status='pending'
      #        hmm_user.cancellation_request_date = Time.now
      #        hmm_user.save

      sql = ActiveRecord::Base.connection();
      sql.update"update hmm_users set cancel_status='pending' , cancellation_request_date=Now()  where id='#{logged_in_hmm_user.id}'";

      hmm_user_day_dif =  HmmUser.find_by_sql("select (To_days( account_expdate ) - TO_DAYS( CURRENT_DATE() )) as difr from hmm_users where id='#{logged_in_hmm_user.id}'")
      no_of_days=hmm_user_day_dif[0].difr
      family_pic=hmm_user.family_pic
      img_url=hmm_user.img_url

      #insert to cancel req table
      @exp_date_cal =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL 3 DAY) as m")
      cancel_date= @exp_date_cal[0]['m']

      @cancel_req= CancellationRequest.new()
      @cancel_req['uid']=logged_in_hmm_user.id
      @cancel_req['reason_for_cancellation']=params[:reason]
      @cancel_req['cancellation_request_date']=Time.now()
      @cancel_req['cancellation_date']=cancel_date
      @cancel_req['cancellation_status']='pending'
      @cancel_req.save

      #Credit points should be calculated here
      #----------------------------------------------------

      #creditpoints=0
      if(hmm_user.emp_id == nil || hmm_user.emp_id == "" || hmm_user.emp_id == 0 )
        Postoffice.deliver_cancellation_request("admin","admin@holdmymemories.com,Rachel.Allen@S121.com,Bob.Eveleth@S121.com,Dan.Quinlan@holdmymemories.com,customerservice@holdmymemories.com", reason,"nil",logged_in_hmm_user.id)
        Postoffice.deliver_cancellation_request_response("admin@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,family_pic,no_of_days,img_url)
      else
        store_employee = EmployeAccount.find(hmm_user.emp_id)
        Postoffice.deliver_cancellation_request(store_employee.employe_name,"#{store_employee.e_mail},Rachel.Allen@S121.com,Bob.Eveleth@S121.com,Dan.Quinlan@holdmymemories.com,customerservice@holdmymemories.com", reason,store_employee.store_id,logged_in_hmm_user.id)
        Postoffice.deliver_cancellation_request_response(store_employee.e_mail,logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,family_pic,no_of_days,img_url)
      end

      #cancel the subcription
      #        require "ArbApiLib"
      #        aReq = ArbApi.new
      #        subnumber = logged_in_hmm_user.subscriptionnumber
      #        if(subnumber=='One time payment')
      #          @res="Your subscription has been canceled sucessfully."
      #        else
      #          if ARGV.length < 3
      #          end
      #          ARGV[0]= "https://api.authorize.net/xml/v1/request.api"
      #          ARGV[1]= "8GxD65y84"
      #          ARGV[2]= "89j6d34cW8CKhp9S"
      #          auth = MerchantAuthenticationType.new(ARGV[1], ARGV[2])
      #          subname = ARGV.length > 3? ARGV[3]: logged_in_hmm_user.account_type
      #          xmlout = aReq.CalcelSubscription(auth,subnumber)
      #          xmlresp1 = HttpTransport.TransmitRequest(xmlout, ARGV[0])
      #          apiresp = aReq.ProcessResponse1(xmlresp1)
      #          apiresp.messages.each { |message|
      #            puts "Error Code=" + message.code
      #            puts "Error Message = " + message.text
      #            @res =  message.text
      #          }
      #        end
      hmm_user = HmmUser.find(logged_in_hmm_user.id)
      uuid =  HmmUser.find_by_sql(" select UUID() as u")
      unnid = uuid[0]['u']

      if(hmm_user.family_name=='' or hmm_user.family_name==nil)
        hmm_user.family_name="#{logged_in_hmm_user.id}#{unnid}un#{logged_in_hmm_user.id}"
      end

      hmm_user.save
      #    reason = params[:reason]
      @array=TrackAccount.find(:first)
      @array.canceled =@array.canceled.to_i+1
      @array.save
      flash[:sucess_id] = "Subscription has been cancelled sucessfully."
      #Postoffice.deliver_cancellation_approved("Admin","admin@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,logged_in_hmm_user.street_address,logged_in_hmm_user.postcode,logged_in_hmm_user.city,logged_in_hmm_user.state,logged_in_hmm_user.country,logged_in_hmm_user.telephone, reason)
      #Postoffice.deliver_cancellation_request_complete("admin@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber, hmm_user['v_password'], logged_in_hmm_user.v_user_name)


    end


    render :action => 'cancel_sucess', :id => logged_in_hmm_user.family_name

    #    reason = params[:reason]
    #   @hmm_user = HmmUser.find(logged_in_hmm_user.id)
    #   @hmm_user.cancel_reason=params[:reason]
    #   @hmm_user.cancel_status='pending'
    #   @hmm_user.cancellation_request_date = Time.now
    #   @hmm_user.save
    #   reason = params[:reason].gsub("'","`")
    #   sql = ActiveRecord::Base.connection();
    #   @hmm_user_day_dif =  HmmUser.find_by_sql("select (To_days( account_expdate ) - TO_DAYS( CURRENT_DATE() )) as difr from hmm_users where id='#{logged_in_hmm_user.id}'")
    #   no_of_days=@hmm_user_day_dif[0].difr
    #   family_pic=@hmm_user.family_pic
    #   img_url=@hmm_user.img_url
    #   if(@hmm_user.emp_id == nil || @hmm_user.emp_id == "")
    #    flash[:notice] = 'Your Subscription Cancellation request has been sent sucessfully.'
    #    Postoffice.deliver_cancellation_request("Admin","admin@holdmymemories.com,,Rachel.Allen@S121.com,Bob.Eveleth@S121.com,Dan.Quinlan@holdmymemories.com,customerservice@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,logged_in_hmm_user.street_address,logged_in_hmm_user.postcode,logged_in_hmm_user.city,logged_in_hmm_user.state,logged_in_hmm_user.country,logged_in_hmm_user.telephone, reason)
    #    Postoffice.deliver_cancellation_request_response("admin@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,family_pic,no_of_days,img_url)
    #   else
    #    @store_employee = EmployeAccount.find(@hmm_user.emp_id)
    #    flash[:notice] = 'Your Subscription Cancellation request has been sent sucessfully.'
    #    Postoffice.deliver_cancellation_request(@store_employee.employe_name,"#{@store_employee.e_mail},Rachel.Allen@S121.com,Bob.Eveleth@S121.com,Dan.Quinlan@holdmymemories.com,customerservice@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,logged_in_hmm_user.street_address,logged_in_hmm_user.postcode,logged_in_hmm_user.city,logged_in_hmm_user.state,logged_in_hmm_user.country,logged_in_hmm_user.telephone, reason)
    #    Postoffice.deliver_cancellation_request_response(@store_employee.e_mail,logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,family_pic,no_of_days,img_url)
    #   end
    #     render :action => 'cancel_sucess', :id=>params[:id]
  end







  def cancel_sucess

  end

  def upgrade_account

  end

  def upgrade_account_form
    @hmm_user=HmmUser.find(logged_in_hmm_user.id)
    if @hmm_user.account_type =="platinum_user"
      @account_type="Premium Account"
    elsif @hmm_user.account_type =="familyws_user"
      @account_type="Family Website"
    else
      @account_type="Free Account"
    end
  end

  def upgrade_payment_family

    card_no=params[:card_no]
    cvv_no=params[:cardcvv_no]
    expiry_date="#{params[:exp_year]}-#{params[:exp_month]}"
    exp_month=params[:exp_month]
    exp_year=params[:exp_year]
    fname=params[:fname]
    lname=params[:lname]
    #amount=Integer(params[:amount])
    street_address = params[:street_address]
    #suburb = params[:suburb]
    postcode = params[:postcode]
    city = params[:city]
    state = params[:state]
    country = params[:country]
    telephone = params[:telephone]
    fax = params[:fax]
    months=params[:months]
    account_type=params[:account_type]
    email = params[:email]
    invoicenumber = "HMM000HMM#{params[:hmm_id]}"
    if(logged_in_hmm_user.subscriptionnumber.nil? || logged_in_hmm_user.invoicenumber!="")
      invoicenumber = "HMM000HMM#{params[:hmm_id]}"
    else
      if(logged_in_hmm_user.subscriptionnumber=="One time payment")
        invoicenumber = "HMMAP0HMM#{params[:hmm_id]}"
      end
    end
    subnumber = logged_in_hmm_user.subscriptionnumber

    #if(logged_in_hmm_user.account_type=='free_user')
    @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL #{months} MONTH) as m")
    #else
    #@hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE('#{logged_in_hmm_user.account_expdate}',INTERVAL #{months} MONTH) as m")
    #end

    account_expdate= @hmm_user_max[0]['m']

    @uuid =  HmmUser.find_by_sql(" select UUID() as u")

    unid = "#{@uuid[0]['u']}000#{params[:hmm_id]}"
    if(account_type == "familyws_user")
      acctype="family_website"
      if(months == "1")
        amount = 4.95
        amttest=495
        amount1 = "$4.95"
      end
      if(months == "6")
        amount = 4.95
        amttest=2495
        amount1 = "$24.95"
      end
      if(months == "12")
        amount = 4.95
        amttest=4995
        amount1 = "$49.95"
      end
    else
      if(account_type == "platinum_user")
        acctype="platinum_account"
        if(months == "1")
          amount = 9.95
          amttest=995
          amount1 = "$9.95"
        end
        if(months == "6")
          amount = 9.95
          amttest=4995
          amount1 = "$49.95"
        end
        if(months == "12")
          amount = 9.95
          amttest=9995
          amount1 = "$99.95"
        end
      end
    end
    nextsub = HmmUser.find_by_sql("SELECT DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL +#{months.to_i} MONTH), '%M %D, %Y') as dat")


    #number = '4007000000027'

    creditcard = ActiveMerchant::Billing::CreditCard.new( #:number => number, # Authorize.net test card, error-producing
      :number => card_no, #Authorize.net test card, non-error-producing
      :month => exp_month,                #for test cards, use any date in the future
      :year => exp_year,
      :first_name => fname,
      :last_name => lname,
      :verification_value => cvv_no
      #:cvv => cvv_no
      #note that MasterCard is 'master'
    )

    if creditcard.valid?

      if(logged_in_hmm_user.account_type == "platinum_user")
        if(account_type == "familyws_user")
          flag=2
        else
          flag=2
        end
      end

      if(flag==1)
        flash[:error] = "Sorry you cannot  downgrade your subscription."
        redirect_to "/account_settings/upgrade_account_form/#{params[:id]}?acc_type=#{acctype}"
      else
        #@creditcard = Creditcard.find(params[:id])
        gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(:test => false, :login => "8GxD65y84", :password=> "89j6d34cW8CKhp9S")
        amount_to_charge = Money.ca_dollar(amttest) #1000 = ten US dollars
        creditcard = ActiveMerchant::Billing::CreditCard.new( #:number => number, # Authorize.net test card, error-producing
          :number => card_no, #Authorize.net test card, non-error-producing
          :month => exp_month,                #for test cards, use any date in the future
          :year => exp_year,
          :first_name => fname,
          :last_name => lname,
          :verification_value => cvv_no
          #:cvv => cvv_no
          #note that MasterCard is 'master'
        )

        options = {
          :address => {},
          :billing_address => {
            :name     => "#{fname} #{lname}",
            :address1 => street_address,
            :city     => city,
            :state    => state,
            :country  => country,
            :zip      => postcode,
            :phone    => telephone
          }
        }
        response = gateway.authorize(amount_to_charge,creditcard,options)
        if response.success?
          #charge once
          gateway.capture(amount_to_charge, response.authorization)
          hmm_user_det=HmmUser.find(params[:hmm_id])
          hmm_user_det[:street_address]=params[:street_address]
          hmm_user_det[:suburb]=params[:suburb]
          hmm_user_det[:postcode]=params[:postcode]
          hmm_user_det[:city]=params[:city]
          hmm_user_det[:state]=params[:state]
          hmm_user_det[:country]=params[:country]
          hmm_user_det[:telephone]=params[:telephone]
          hmm_user_det[:account_type] = params[:account_type]
          hmm_user_det[:account_expdate] = account_expdate

          hmm_user_det[:first_payment_date] = Time.now
          hmm_user_det[:invoicenumber] = invoicenumber
          hmm_user_det[:months] = months
          hmm_user_det[:amount] = amount1
          hmm_user_det[:unid] = unid
          hmm_user_det[:comission_month] = 0
          hmm_user_det[:membership_sold_by] = params[:sold_by]
          hmm_user_det.save
          @get_content_url=ContentPath.find(:all, :conditions => "status='active'")
          content_path=@get_content_url[0]['content_path']

          if(session[:employe])
            employedet=EmployeAccount.find(session[:employe])
            hmmstudio=HmmStudio.find(employedet.store_id)
            hmm_user_det[:emp_id] = session[:employe]
            hmm_user_det[:studio_id]=employedet.store_id
            hmm_user_det.save

            upgrade_account=UpgradedAccount.new
            upgrade_account.user_id= hmm_user_det.id
            upgrade_account.emp_id=hmm_user_det.emp_id
            upgrade_account.studio_id=hmm_user_det.studio_id
            upgrade_account.months=months
            upgrade_account.save

            subchaptercount=SubChapter.count(:all, :conditions => "store_id > 0 and uid=#{hmm_user_det.id}")
            if(subchaptercount > 0)
              subchaptercheck = SubChapter.count(:all, :conditions => "store_id = #{employedet.store_id}  and uid=#{hmm_user_det.id} ")
              if(subchaptercheck > 0)
              else
                subchapterfind=SubChapter.find(:first, :conditions => "store_id > 0  and uid=#{hmm_user_det.id}")
                subchapter_new = SubChapter.new
                subchapter_new['uid']= hmm_user_det.id
                subchapter_new['tagid']= subchapterfind.tagid
                subchapter_new['sub_chapname']="#{hmmstudio.studio_name}"
                subchapter_new['v_image']="folder_img.png"
                subchapter_new['e_access'] = "public"
                subchapter_new['d_updated_on'] = Time.now
                subchapter_new['d_created_on'] = Time.now
                subchapter_new['img_url']=content_path
                subchapter_new['store_id']= hmmstudio.id
                subchapter_new.save
              end
            else
              tag_default = Tag.new
              tag_default.default_tag='no'
              tag_default.v_tagname="STUDIO SESSIONS"
              tag_default.uid=hmm_user_det.id
              tag_default.default_tag="yes"
              tag_default.e_access = 'public'
              tag_default.e_visible = 'yes'
              tag_default.d_updateddate= Time.now
              tag_default.d_createddate= Time.now
              tag_default.img_url=content_path
              tag_default.v_chapimage = "folder_img.png"
              tag_default.save
              subchapter_new = SubChapter.new
              subchapter_new['uid']= hmm_user_det.id
              subchapter_new['tagid']= tag_default.id
              subchapter_new['sub_chapname']="#{hmmstudio.studio_name}"
              subchapter_new['v_image']="folder_img.png"
              subchapter_new['e_access'] = "public"
              subchapter_new['d_updated_on'] = Time.now
              subchapter_new['d_created_on'] = Time.now
              subchapter_new['img_url']=content_path
              subchapter_new['store_id']= hmmstudio.id
              subchapter_new.save
            end
          end

          i=0
          while i < Integer(hmm_user_det.months)
            @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL #{i} MONTH) as m")
            payment_recieved_on= @hmm_user_max[0]['m']
            recdate= Time.parse(payment_recieved_on)
            mon= recdate.strftime("%m")
            payment_count = PaymentCount.new
            payment_count.uid = hmm_user_det.id
            payment_count.amount = hmm_user_det.amount
            payment_count.recieved_on = payment_recieved_on
            payment_count.account_type = hmm_user_det.account_type
            if hmm_user_det.account_type=="platinum_user"
              if  amttest==995
                payment_count.current_received_amount = 9.95
              else
                payment_count.current_received_amount = 8.32
              end
            elsif hmm_user_det.account_type=="familyws_user"
              if  amttest==495
                payment_count.current_received_amount = 4.95
              else
                payment_count.current_received_amount = 4.16
              end
            end
            payment_count.updated = 1
            payment_count.emp_id = "#{hmm_user_det.emp_id}"
            payment_count.month = "#{mon}"
            payment_count.save
            i=i+1
          end

          start_date = Time.now.strftime("%Y-%m-%d")
          #if(logged_in_hmm_user.account_type=='free_user')
          @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL #{months} MONTH) as m")
          #else
          #  @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE('#{logged_in_hmm_user.account_expdate}',INTERVAL #{months} MONTH) as m")
          #end
          account_expdate= @hmm_user_max[0]['m']

          # Write code for new subscription for  upgradation
          aReq = ArbApi.new
          if ARGV.length < 3
            puts "Usage: ArbApiSample.rb <url> <login> <txnkey> [<subscription name>]"
            #exit
          end
          ARGV[0]= "https://api.authorize.net/xml/v1/request.api"
          ARGV[1]= "8GxD65y84"
          ARGV[2]= "89j6d34cW8CKhp9S"
          #ARGV[1]= "cnpdev4289"
          #ARGV[2]= "SR2P8g4jdEn7vFLQ"
          #ARGV[3]= "644100"

          auth = MerchantAuthenticationType.new(ARGV[1], ARGV[2])
          subname = ARGV.length > 3? ARGV[3]: account_type
          interval = IntervalType.new(1, "months")
          schedule = PaymentScheduleType.new(interval, account_expdate, 9999, 0)
          cinfo = CreditCardType.new(card_no, expiry_date, cvv_no)
          binfo = NameAndAddressType.new(fname, lname,"Not added", street_address, city, state ,postcode, country,email,telephone )
          xmlout = aReq.CreateSubscription(auth,subname,schedule,amount, 0, cinfo,binfo,interval,invoicenumber)

          puts "Creating Subscription Name: #{subname}"
          puts "Submitting to URL: #{ARGV[0]}"
          xmlresp = HttpTransport.TransmitRequest(xmlout, ARGV[0])


          apiresp = aReq.ProcessResponse(xmlresp)

          if apiresp.success
            hmm_user_det=HmmUser.find(params[:hmm_id])
            hmm_user_det[:subscriptionnumber] = apiresp.subscriptionid

            hmm_user_det.save

            subscriptionid = apiresp.subscriptionid
            if(hmm_user_det.account_type=='platinum_user')
              if(hmm_user_det.emp_id=='' || hmm_user_det.emp_id==nil )
              else
                studio_commission=StudioCommission.new
                studio_commission.uid=hmm_user_det.id
                studio_commission.emp_id=hmm_user_det.emp_id
                empstore=EmployeAccount.find(hmm_user_det.emp_id)
                empstoreid=empstore.store_id
                studio_commission.store_id=empstoreid
                if(hmm_user_det.months=='1')
                  commissionamount=5
                elsif(hmm_user_det.months=='6')
                  commissionamount=25
                elsif(hmm_user_det.months=='12')
                  commissionamount=50
                end
                studio_commission.amount=commissionamount
                studio_commission.months=hmm_user_det.months
                studio_commission.payment_recieved_on=Time.now
                studio_commission.subscriptionumber=apiresp.subscriptionid
                studio_commission.save
              end
            end
            pw=HmmUser.find(:all, :select => "v_password as pword,password_required as preq, familywebsite_password as fpword ", :conditions => "id=#{hmm_user_det.id}")

            link = "http://www.holdmymemories.com/#{hmm_user_det.family_name}"
            pass_req = pw[0].preq
            pass = pw[0].pword
            #Postoffice.deliver_paymentsucess("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, params[:account_type], hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,apiresp.subscriptionid, hmm_user_det.v_user_name, hmm_user_det.v_password,link,pass_req,pass)

            flash[:sucess] =  "Subscription Created successfully"
            flash[:sucess_id] = "Your Subscription id is: #{apiresp.subscriptionid}"

            if(logged_in_hmm_user.account_type == "free_user")
              flag=1
            else
              flag=2
            end


            if ARGV.length < 3
            end
            ARGV[0]= "https://api.authorize.net/xml/v1/request.api"
            ARGV[1]= "8GxD65y84"
            ARGV[2]= "89j6d34cW8CKhp9S"

            auth = MerchantAuthenticationType.new(ARGV[1], ARGV[2])
            subname = ARGV.length > 3? ARGV[3]: account_type

            if(flag==2)
              xmlout = aReq.CalcelSubscription(auth,subnumber)
              xmlresp1 = HttpTransport.TransmitRequest(xmlout, ARGV[0])
              apiresp = aReq.ProcessResponse1(xmlresp1)
              puts "Subscription Creation Failed"
              apiresp.messages.each { |message|
                puts "Error Code=#{message.code}"
                puts "Error Message = #{message.text }"
                @res =  message.text
              }
            else
              @res = "no subscription"
            end
            if(@res == "The subscription has already been canceled." || @res == "Successful." || @res == "no subscription")

            end
            Postoffice.deliver_paymentsucessupdate("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, params[:account_type], hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,subscriptionid, hmm_user_det.v_user_name, pw[0].pword,link,pass_req,pass,nextsub[0]['dat'])

            redirect_to "/account_settings/upgrade_account_success/#{params[:id]}?acc_type=#{acctype}"

          else
            apiresp.messages.each { |message|
              puts "Error Code=#{message.code}"
              puts "Error Message =#{message.text } "
              flash[:sucess] =  ""
              flash[:sucess_id] =  " Your Account has been upgraded successfully.<br>"
              # reset the credit points
              @credit_check=CreditPoint.count(:all,:conditions =>"user_id=#{params[:hmm_id]}")
              if(@credit_check > 0)
                @credit_pt=CreditPoint.find(:first,:conditions =>"user_id=#{params[:hmm_id]}")
                @credit_pt['available_credits']=0.00
                @credit_pt.save
              end
            }
            pw=HmmUser.find(:all, :select => "v_password as pword,password_required as preq, familywebsite_password as fpword ", :conditions => "id=#{hmm_user_det.id}")

            link = "http://www.holdmymemories.com/#{hmm_user_det.family_name}"
            pass_req = pw[0].preq
            pass = pw[0].pword
            Postoffice.deliver_paymentsucessupdate("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, params[:account_type], hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,"One time payment", hmm_user_det.v_user_name, pw[0].pword,link,pass_req,pass,nextsub[0]['dat'])

            redirect_to "/account_settings/upgrade_account_success/#{params[:id]}?acc_type=#{acctype}"

            hmm_user_det=HmmUser.find(params[:hmm_id])
            hmm_user_det[:subscriptionnumber] = "One time payment"

            hmm_user_det.save
            if(hmm_user_det.account_type=='platinum_user')
              if(hmm_user_det.emp_id=='' || hmm_user_det.emp_id==nil )
              else
                studio_commission=StudioCommission.new
                studio_commission.uid=hmm_user_det.id
                studio_commission.emp_id=hmm_user_det.emp_id
                empstore=EmployeAccount.find(hmm_user_det.emp_id)
                empstoreid=empstore.store_id
                studio_commission.store_id=empstoreid
                if(hmm_user_det.months=='1')
                  commissionamount=5
                elsif(hmm_user_det.months=='6')
                  commissionamount=25
                elsif(hmm_user_det.months=='12')
                  commissionamount=50
                end
                studio_commission.amount=commissionamount
                studio_commission.months=hmm_user_det.months
                studio_commission.payment_recieved_on=Time.now
                studio_commission.subscriptionumber="One time payment"
                studio_commission.save
              end
            end
          end

          puts "\nXML Dump:"
          @xmldet= xmlresp
        else

          flash[:error] ="Transaction has been declined please check your Credit card CVV number, Card Expiration date and try again"
          redirect_to "/account_settings/upgrade_account_form/#{params[:id]}?acc_type=#{acctype}"
        end
      end
    else
      flash[:error] =   "Error Message = This is a general error Entered Credit card number or CVV number is invalid"
      redirect_to "/account_settings/upgrade_account_form/#{params[:id]}?acc_type=#{acctype}"
    end
  end

  def familywebsite_option

  end

  def not_canceled

    @array=TrackAccount.find(:first)
    @array.not_canceled=@array.not_canceled.to_i+1
    @array.save
    redirect_to :controller=>'account_settings',:action=>'home', :id=>logged_in_hmm_user.family_name


  end


end