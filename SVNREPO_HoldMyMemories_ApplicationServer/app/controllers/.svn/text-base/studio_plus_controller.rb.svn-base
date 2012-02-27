class StudioPlusController < ApplicationController

  before_filter :authenticate #authenticates the api username and password for all the requests

  #method to authenticate the api username and password
  # => input: api_username, api_password
  # => output: if api username is blank, returns status as false and message as 'api username is required'
  # => if api password is blank, returns status as false and message as 'api password is required'
  # => if api user credentials are wrong, returns status as false and message as 'invalid api login details'
  # => On correct input, returns true
  def authenticate
    @retval=Hash.new
    unless params[:api_username].blank?
      unless params[:api_password].blank?
        @employee = EmployeAccount.find_by_employe_username_and_password(params[:api_username],params[:api_password], :conditions => "status='unblock'")
        if @employee
          return true
        else
          @retval['status'] = false
          @retval['message'] = 'invalid api credentials'
        end
      else
        @retval['status'] = false
        @retval['message'] = 'api password is required'
      end
    else
      @retval['status'] = false
      @retval['message'] = 'api username is required'
    end
    render :xml => @retval.to_xml({:root=>'response',:dasherize =>false})
  end

  #Service for user login
  #input : username, password
  #output : If username is missing, returns status as false and message as 'username is required'
  # =>If password is missing, returns status as false and message as 'password is required'
  # =>If given login credentials is wrong, returns status as false and message as 'invalid login details'
  # =>If the details are correct, returns status as true and hmm_user_id (user_id of the logging user)
  def user_login
    @retval = Hash.new()
    unless params[:username].blank?
      unless params[:password].blank? #check for username and password input
        @hmm_user = HmmUser.find(:first,:conditions=>{:v_user_name=>params[:username],:v_password=>params[:password],:e_user_status=>'unblocked'},:select=>'id')
        if(@hmm_user)
          @retval['hmm_user_id'] = @hmm_user.id
          @retval['status'] = true
        else
          @retval['message'] = 'invalid login details'
          @retval['status'] = false
        end
      else
        @retval['message'] = 'password is required'
        @retval['status'] = false
      end
    else
      @retval['message'] = 'username is required'
      @retval['status'] = false
    end
    render :xml => @retval.to_xml({:root=>'response',:dasherize =>false})
  end

  #Service for checking username uniqueness
  #input : username
  #output : If username is missing, returns status as false and message as 'username is required'
  # =>If given username already exists, returns status as false and message as 'username already exists'
  # =>If given username is unique, returns status as true and message as 'username is available'
  def username_uniqueness
    @retval = Hash.new()
    unless params[:username].blank?
      @hmm_user = HmmUser.find(:first,:conditions=>{:v_user_name=>params[:username]},:select=>'id')
      if(@hmm_user)
        @retval['message'] = "username already exists"
        @retval['status'] = false
      else
        @retval['message'] = 'username is available'
        @retval['status'] = true
      end
    else
      @retval['message'] = 'username is required'
      @retval['status'] = false
    end
    render :xml => @retval.to_xml({:root=>'response',:dasherize =>false})
  end

  #Service for checking email uniqueness
  #input : email
  #output : If email is missing, returns status as false and message as 'email is required'
  # =>If given email already exists, returns status as false and message as 'email already exists'
  # =>If given email is unique, returns status as true and message as 'email is available'
  def email_uniqueness
    @retval = Hash.new()
    unless params[:email].blank?
      @hmm_user = HmmUser.find(:first,:conditions=>{:v_e_mail=>params[:email]},:select=>'id')
      if(@hmm_user)
        @retval['message'] = "email already exists"
        @retval['status'] = false
      else
        @retval['message'] = 'email is available'
        @retval['status'] = true
      end
    else
      @retval['message'] = 'email is required'
      @retval['status'] = false
    end
    render :xml => @retval.to_xml({:root=>'response',:dasherize =>false})
  end

  #Service for checking email uniqueness
  #input : family_website_url
  #output : If family_website_url is missing, returns status as false and message as 'family website url is required'
  # =>If given family_website_url already exists, returns status as false and message as 'family website url already exists'
  # =>If given family_website_url is unique, returns status as true and message as 'family website url is available'
  def family_website_url_uniqueness
    @retval = Hash.new()
    unless params[:family_website_url].blank?
      @hmm_user = HmmUser.find(:first,:conditions=>"family_name like '#{params[:family_website_url]}' OR alt_family_name like '#{params[:family_website_url]}'",:select=>'id')
      if(@hmm_user)
        @retval['message'] = "family website url already exists"
        @retval['status'] = false
      else
        @retval['message'] = 'family website url is available'
        @retval['status'] = true
      end
    else
      @retval['message'] = 'family website url is required'
      @retval['status'] = false
    end
    render :xml => @retval.to_xml({:root=>'response',:dasherize =>false})
  end

  #Service for upgrading user account
  def upgrade_account
    @retval = Hash.new()
    empcount=EmployeAccount.count(:all, :conditions => "employe_username='#{params[:api_username]}' and password='#{params[:api_password]}' and status='unblock'")
    if(empcount > 0)
      @employee = EmployeAccount.find(:all, :conditions => "employe_username='#{params[:api_username]}' and password='#{params[:api_password]}' and status='unblock'")
      emp_id=@employee[0].id
    else
      emp_id=''
    end

    require 'active_merchant'
    require "ArbApiLib"
    require 'money'
    card_no=params[:card_no]
    cvv_no=params[:cardcvv_no]
    expiry_date="#{params[:exp_year]}-#{params[:exp_month]}"
    exp_month=params[:exp_month]
    exp_year=params[:exp_year]
    fname=params[:fname]
    lname=params[:lname]
    street_address = params[:street_address]
    postcode = params[:postcode]
    city = params[:city]
    state = params[:state]
    country = params[:country]
    telephone = params[:telephone]
    fax = params[:fax]
    months=params[:months]
    account_type=params[:account_type]
    email = params[:email]
    hmm_user=HmmUser.find(:all,:conditions => "v_user_name='#{params[:username]}'")
    hmm_id=hmm_user[0].id

    if(hmm_user[0].subscriptionnumber=='')
      invoicenumber = "HMM000HMM#{hmm_id}"
    else
      if(hmm_user[0].subscriptionnumber=='one time payment')
        invoicenumber = "HMMAP0HMM#{hmm_id}"
      end
    end
    subnumber = "#{hmm_user[0].subscriptionnumber}"

    @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL #{months} MONTH) as m")
    account_expdate= @hmm_user_max[0]['m']
    @uuid =  HmmUser.find_by_sql(" select UUID() as u")
    unid = "#{@uuid[0]['u']}000#{hmm_id}"
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

    creditcard = ActiveMerchant::Billing::CreditCard.new( #:number => number, #Authorize.net test card, error-producing
      :number => card_no, #Authorize.net test card, non-error-producing
      :month => exp_month,                #for test cards, use any date in the future
      :year => exp_year,
      :first_name => fname,
      :last_name => lname,
      :verification_value => cvv_no
    )

    if creditcard.valid?
      if(params[:account_type] == "platinum_user")
        if(account_type == "familyws_user")
          flag=1
        else
          flag=2
        end
      end

      #@creditcard = Creditcard.find(params[:id])
      gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(:test => false, :login => "8GxD65y84", :password=> "89j6d34cW8CKhp9S")
      amount_to_charge = Money.ca_dollar(amttest) #1000 = ten US dollars
      creditcard = ActiveMerchant::Billing::CreditCard.new( #:number => number, #Authorize.net test card, error-producing
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
        hmm_user_det=HmmUser.find(hmm_id)
        hmm_user_det[:street_address]=params[:street_address]
        hmm_user_det[:suburb]=params[:suburb]
        hmm_user_det[:postcode]=params[:postcode]
        hmm_user_det[:city]=params[:city]
        hmm_user_det[:state]=params[:state]
        hmm_user_det[:country]=params[:country]
        hmm_user_det[:telephone]=params[:telephone]
        hmm_user_det[:account_type] = account_type
        hmm_user_det[:account_expdate] = account_expdate
        hmm_user_det[:cancel_status] = ''
        hmm_user_det[:canceled_by] = ''
        hmm_user_det[:invoicenumber] = invoicenumber
        hmm_user_det[:months] = months
        hmm_user_det[:amount] = amount1
        hmm_user_det[:unid] = unid
        hmm_user_det[:emp_id] = emp_id
        hmm_user_det.save

        hmmpasswords=HmmUser.find(:first, :select => "v_password as ps, familywebsite_password as fps", :conditions => "id='#{hmm_user_det.id}'")

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

        upgrade_account=UpgradedAccount.new
        upgrade_account.user_id= hmm_user_det.id
        upgrade_account.emp_id=hmm_user_det.emp_id
        upgrade_account.studio_id=hmm_user_det.studio_id
        upgrade_account.months=months
        upgrade_account.save
        
        start_date = Time.now.strftime("%Y-%m-%d")
        @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL #{months} MONTH) as m")
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
          hmm_user_det=HmmUser.find(hmm_id)
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

          link = "http://www.holdmymemories.com/#{hmm_user_det.family_name}"
          pass_req = "#{hmm_user_det.password_required}"

          pass = "#{hmmpasswords.fps}"
          Postoffice.deliver_paymentsucess("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, params[:account_type], hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,apiresp.subscriptionid, hmm_user_det.v_user_name, hmmpasswords.ps,link,pass_req,pass,nextsub[0]['dat'])

          flash[:sucess] =  "Subscription Created successfully"
          flash[:sucess_id] = "Your Subscription id is: #{apiresp.subscriptionid}"

          if(params[:account_type] == "free_user")
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
          begin
            #Postoffice.deliver_paymentsucess("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, account_type, hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,subscriptionid, hmm_user_det.v_user_name, hmmpasswords.ps,link,pass_req,pass,nextsub[0]['dat'])
            #postoffice.deliver_paymentsucessupdate("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, account_type, hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,subscriptionid, hmm_user_det.v_user_name, hmmpasswords.ps,link,pass_req,pass)
          rescue
            logger.info("smtp error")
          end
          @retval['message'] = 'Subscription created Successfully. Account has been upgarded.'
          @retval['account_type']=acctype
          @retval['status'] = true
          @retval['subscription_number'] = subscriptionid
          @retval['invoice_receipt'] = "http://holdmymemories.com/customers/generate_receipt/#{hmm_user_det.unid}"



        else
          apiresp.messages.each { |message|
            puts "Error Code=#{message.code}"
            puts "Error Message =#{message.text } "
            flash[:sucess] =  ""
            flash[:sucess_id] =  " Your Account has been upgraded successfully.<br>"
          }
          begin
            #Postoffice.deliver_paymentsucessupdate("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, account_type, hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,"One time payment", hmm_user_det.v_user_name, hmmpasswords.ps,link,pass_req,pass)
            Postoffice.deliver_paymentsucess("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, account_type, hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,"One time payment", hmm_user_det.v_user_name, hmmpasswords.ps,link,pass_req,pass,nextsub[0]['dat'])

          rescue
            logger.info("smtp error")
          end
          hmm_user_det=HmmUser.find(hmm_id)
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
          @retval['message'] = 'Subscription has been created successfully. Account has been upgraded successfully.'
          @retval['account_type']=acctype
          @retval['status'] = true
          @retval['subscription_number'] = 'one time payment'
          @retval['invoice_receipt'] = "http://holdmymemories.com/customers/generate_receipt/#{hmm_user_det.unid}"


        end
        puts "\nXML Dump:"
        @xmldet= xmlresp
      else
        @retval['message'] = 'Transaction has been declined please check your Credit card CVV number, Card Expiration date and try again'
        @retval['account_type']=acctype
        @retval['status'] = false

      end
    else
      @retval['message'] = 'This is a general error Entered Credit card number or CVV number is invalid'
      @retval['account_type']=acctype
      @retval['status'] = false

    end
    render :xml => @retval.to_xml({:root=>'response',:dasherize =>false})

  end

  #Service for returning available credit points by username
  #input : username
  #output : If username is missing, returns status as false and message as 'username is required'
  # =>If given username doesn't exists, returns status as false and message as 'user not found'
  # =>If correct data provided, returns status as true and available_points
  def available_credit_points
    @retval = Hash.new()
    unless params[:username].blank?
      @hmm_user = HmmUser.find(:first,:conditions=>{:v_user_name=>params[:username]},:select=>'id')
      if(@hmm_user)
        @credit = CreditPoint.find(:first,:conditions=>{:user_id=>@hmm_user.id})
        if @credit
          @retval['available_points'] = @credit.available_credits
          @retval['status'] = true
        else
          @retval['available_points'] = 0
          @retval['status'] = true
        end
      else
        @retval['message'] = 'user not found'
        @retval['status'] = false
      end
    else
      @retval['message'] = 'username is required'
      @retval['status'] = false
    end
    render :xml => @retval.to_xml({:root=>'response',:dasherize =>false})
  end

  #Service for deducting available credit points by username
  #input : username
  #output : If username is missing, returns status as false and message as 'username is required'
  # =>If given username doesn't exists, returns status as false and message as 'user not found'
  # =>If user doesn't have any credit points, returns status as false and message as 'credit points not available'
  # =>If used credit points is less than available points, returns status as false and message as 'insufficient credit points'
  # =>If the all the data satisfies, the method deducts the available points with the used points and updates the same for the user
  # => returns status as true, message as 'credit points deducted successfully' and available points.
  def deduct_credit_points
    @retval = Hash.new()
    unless params[:username].blank?
      @hmm_user = HmmUser.find(:first,:conditions=>{:v_user_name=>params[:username]},:select=>'id')
      if(@hmm_user)
        @credit = CreditPoint.find(:first,:conditions=>{:user_id=>@hmm_user.id})
        if @credit
          if(@credit.available_credits > Integer(params[:used_points]))
            credit_points = @credit.available_credits-Integer(params[:used_points])
            used_points = @credit.used_credits+Integer(params[:used_points])
            CreditPoint.update(@credit.id, :available_credits => credit_points, :used_credits => used_points)
            log = CreditLog.new
            log.hmm_studio_id = @employee.store_id
            log.credit_point_id = @credit.id
            log.used_credit = Integer(params[:used_points])
            log.save()
            @retval['available_credits'] =  credit_points
            @retval['message'] = 'credit points deducted successfully'
            @retval['status'] = true
          else
            @retval['message'] = 'insufficient credit points'
            @retval['status'] = true
          end
        else
          @retval['message'] = 'credit points not available'
          @retval['status'] = false
        end
      else
        @retval['message'] = 'user not found'
        @retval['status'] = false
      end
    else
      @retval['message'] = 'username is required'
      @retval['status'] = false
    end
    render :xml => @retval.to_xml({:root=>'response',:dasherize =>false})
  end

  def user_basic_information
    @retval = Hash.new()

    unless params[:email].blank? #check for username and password input
      @hmm_user = HmmUser.find(:first,:conditions=>{:v_e_mail=>params[:email],:e_user_status=>'unblocked'})
      if(@hmm_user)
        @retval['username'] = @hmm_user.v_user_name
        @retval['familywebsite'] = @hmm_user.family_name
        @retval['account_type'] = @hmm_user.account_type
        @retval['nextpayment_date'] = @hmm_user.account_expdate
      else
        @retval['message'] = 'invalid email details'
        @retval['status'] = false
      end
    else
      @retval['message'] = 'email is required'
      @retval['status'] = false
    end

    render :xml => @retval.to_xml({:root=>'response',:dasherize =>false})
  end

end