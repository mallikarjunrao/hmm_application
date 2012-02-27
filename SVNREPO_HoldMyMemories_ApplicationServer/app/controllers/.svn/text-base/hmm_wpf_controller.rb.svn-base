class HmmWpfController < ApplicationController
  require 'money'
  require 'active_merchant'

  def authenticate_employee
    logged_in_employe = EmployeAccount.find_by_employe_username_and_password(params[:employe_account][:employe_username],
      params[:employe_account][:password ], :conditions => "status='unblock'")
    if logged_in_employe
      render :text=> logged_in_employe.id
    else
      render :text=>"failed"
    end
  end

  #input: employee id (id)
  #returns the customer belonging to the studio fo the given employee
  def my_customers_wpf
    if params[:report_type]
      if params[:first_name] && params[:last_name] && params[:email_address] && params[:user_name]
        first_name=params[:first_name]
        last_name=params[:last_name]
        email_address=params[:email_address]
        user_name=params[:user_name]
        cond=[]
        cond.push("1=1")
        if !first_name.nil? && !first_name.blank?
          cond.push(" and v_fname='#{first_name}' ")
        end
        if !last_name.nil? && !last_name.blank?
          cond.push(" and v_lname='#{last_name}' ")
        end
        if !email_address.nil? && !email_address.blank?
          cond.push(" and v_e_mail='#{email_address}' ")
        end
        if !user_name.nil? && !user_name.blank?
          cond.push(" and 	v_user_name='#{user_name}' ")
        end
        @results = HmmUser.find(:all, :conditions => "(#{cond})",:order =>"id desc") #get the users associated with the employee list
      else
        @results={}
      end
    else
      emps = Array.new
      @employee = EmployeAccount.find(:first,:conditions=>"id=#{params[:id]}",:select=>"store_id") #get the studio id of the employee
      @employees = EmployeAccount.find(:all,:conditions => "store_id=#{@employee.store_id}",:select=>"id") #get the employees belonging to that studio
      for emp in @employees
        emps.push(emp.id)
      end
      employees = emps.join(',')
      @results = HmmUser.find(:all, :conditions => "emp_id in (#{employees})",:order =>"id desc") #get the users associated with the employee list
    end
    render :layout => false
  end


  #validates the given username,email and familyname uniqueness
  def validate_registration_fields
    if params[:username]
      username = params[:username]
      user = HmmUser.find_all_by_v_user_name(username)
      if user.size > 0
        render :text => "unavailable"
      else
        render :text => "available"
      end
    elsif params[:email]
      email = params[:email]
      mail = HmmUser.find_all_by_v_e_mail(email)
      if mail.size > 0
        render :text => "unavailable"
      else
        render :text => "available"
      end
    elsif params[:familyname]
      familyname = params[:familyname]
      family = HmmUser.find_all_by_family_name(familyname)
      if family.size > 0
        render :text => "unavailable"
      else
        render :text => "available"
      end
    end
  end


  def process_payment
    card_no=params[:card_no]
    cvv_no=params[:cardcvv_no]
    expiry_date=params[:exp_year]+"-"+params[:exp_month]
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

    invoicenumber = "HMM000"+"HMM#{params[:hmm_id]}"


    @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL #{months} MONTH) as m")

    account_expdate= @hmm_user_max[0]['m']
    arbstart=account_expdate
    @uuid =  HmmUser.find_by_sql(" select UUID() as u")

    unid = @uuid[0]['u']+"000#{params[:hmm_id]}"
    if(account_type == "familyws_user")
      acctype="family_website"
      if(months == "1")
        amount = 4.95
        amttest = 495
        amount1 = "$4.95"
      end
      if(months == "6")
        amount = 4.95
        amttest = 2495
        amount1 = "$24.95"
      end
      if(months == "12")
        amount = 4.95
        amttest = 4995
        amount1 = "$49.95"
      end
    else
      if(account_type == "platinum_user")
        acctype="platinum_account"
        if(months == "1")
          amount = 9.95
          amttest = 995
          amount1 = "$9.95"
        end
        if(months == "6")
          amount = 9.95
          amttest = 4995
          amount1 = "$49.95"
        end
        if(months == "12")
          amount = 9.95
          amttest = 9995
          amount1 = "$99.95"
        end
      end
    end



    require "ArbApiLib"
    #@creditcard = Creditcard.new(params[:creditcard])
    creditcard = ActiveMerchant::Billing::CreditCard.new(
      #:type => params[:creditcard][:card_type],
      :number => card_no,
      :month => exp_month,
      :year => exp_year,
      :first_name => fname,
      :last_name => lname,
      :verification_value => cvv_no
    )
    if creditcard.valid?
      #if @creditcard.save
      flash[:message] ="Creditcard Info saved!"
      #redirect_to :action => 'check_balance', :id=> @creditcard


      #@creditcard = Creditcard.find(params[:id])



      gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(:test => false, :login => "8GxD65y84", :password=> "89j6d34cW8CKhp9S")
      amount_to_charge = Money.ca_dollar(amttest) #1000 = ten US dollars
      creditcard = ActiveMerchant::Billing::CreditCard.new(
        #:type => params[:creditcard][:card_type],
        :number => card_no,
        :month => exp_month,
        :year => exp_year,
        :first_name => fname,
        :last_name => lname,
        :verification_value => cvv_no
      )

      options = {
        :address => {},
        :billing_address => {
          :name     => "#{fname}  #{lname}",
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
        hmm_user_det[:state] = state
        hmm_user_det[:account_type] = params[:account_type]
        hmm_user_det[:first_payment_date] = Time.now
        hmm_user_det[:account_expdate] = account_expdate
        hmm_user_det[:months] = months
        hmm_user_det[:amount] = amount1
        hmm_user_det[:unid] = unid

        hmm_user_det.save

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

        #       @result = "Success: " + response.message.to_s
        #authorization success proceed to the ARB now
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
        schedule = PaymentScheduleType.new(interval, arbstart, 9999, 0)
        cinfo = CreditCardType.new(card_no, expiry_date, cvv_no)
        binfo = NameAndAddressType.new(fname, lname,"Not added", street_address, city, state ,postcode, country,email,telephone )
        xmlout = aReq.CreateSubscription(auth,subname,schedule,amount, 0, cinfo,binfo,interval,invoicenumber)

        puts "Creating Subscription Name: " + subname
        puts "Submitting to URL:" + ARGV[0]
        xmlresp = HttpTransport.TransmitRequest(xmlout, ARGV[0])


        apiresp = aReq.ProcessResponse(xmlresp)

        if apiresp.success

          hmm_user_det=HmmUser.find(params[:hmm_id])
          hmm_user_det[:subscriptionnumber] = apiresp.subscriptionid
          hmm_user_det[:invoicenumber] = invoicenumber
          hmm_user_det.save


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
            studio_commission.months=months
            studio_commission.payment_recieved_on=Time.now
            studio_commission.subscriptionumber=apiresp.subscriptionid
            studio_commission.save
          end

          pw=HmmUser.find(:all, :select => "v_password as pword,password_required as preq, familywebsite_password as fpword ", :conditions => "id=#{hmm_user_det.id}")

          link = "http://www.holdmymemories.com/#{hmm_user_det.family_name}"
          pass_req = pw[0].preq
          pass = pw[0].pword
          passwd=pw[0].pword
          nextsub = HmmUser.find_by_sql("SELECT DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL +#{months.to_i} MONTH), '%M %D, %Y') as dat")

          Postoffice.deliver_paymentsucess("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, params[:account_type], hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,apiresp.subscriptionid, hmm_user_det.v_user_name, passwd,link,pass_req,pass,nextsub[0]['dat'])

          flash[:sucess] =  "Subscription Created successfully"
          flash[:sucess_id] = "Your Subscription id is: " + apiresp.subscriptionid
          #redirect_to "http://www.holdmymemories.com/customers/other_details/#{params[:hmm_id]}"
          render :text =>"success"


        else
          puts "Subscription Creation Failed"
          apiresp.messages.each { |message|
            puts "Error Code=" + message.code
            puts "Error Message = " + message.text
            flash[:sucess] =  ""
            flash[:sucess_id] =  " Your Account has been created successfully. <br>"
          }
          hmm_user_det=HmmUser.find(params[:hmm_id])
          hmm_user_det[:subscriptionnumber] = "One time payment"
          hmm_user_det[:invoicenumber] = invoicenumber
          hmm_user_det.save

          if(hmm_user_det.emp_id=='' || hmm_user_det.emp_id==nil )
          else
            studio_commission=StudioCommission.new
            studio_commission.uid=hmm_user_det.id
            studio_commission.emp_id=hmm_user_det.emp_id
            empstore=EmployeAccount.find(hmm_user_det.emp_id)
            empstoreid=empstore.store_id
            studio_commission.store_id=empstoreid
            if(hmm_user_det.months==1)
              commissionamount=5
            elsif(hmm_user_det.months==6)
              commissionamount=25
            elsif(hmm_user_det.months==12)
              commissionamount=50
            end
            studio_commission.amount=commissionamount
            studio_commission.month=months
            studio_commission.payment_recieved_on=Time.now
            studio_commission.subscriptionumber="One time payment"
            studio_commission.save
          end

          pw=HmmUser.find(:all, :select => "v_password as pword,password_required as preq, familywebsite_password as fpword ", :conditions => "id=#{hmm_user_det.id}")

          link = "http://www.holdmymemories.com/#{hmm_user_det.family_name}"
          pass_req = pw[0].preq
          pass = pw[0].pword
          passwd=pw[0].pword
          nextsub = HmmUser.find_by_sql("SELECT DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL +#{months.to_i} MONTH), '%M %D, %Y') as dat")
          Postoffice.deliver_paymentsucess("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, hmm_user_det.account_type, hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,"One time payment", hmm_user_det.v_user_name, passwd,link,pass_req,pass,nextsub[0]['dat'])
          #redirect_to "http://www.holdmymemories.com/customers/other_details/#{params[:hmm_id]}"
          render :text =>"success"
        end

        puts "\nXML Dump:"
        @xmldet= xmlresp


      else
        message = response.message
        if(message == "No Match")
          message = "Card Code Status: No Match"
        end

        flash[:error] = "Transaction has been declined.  Please check the billing name, credit card CVV number, and/or card expiration date and try again."
        #redirect_to "http://www.holdmymemories.com/customers/authorise_payment/?id=#{params[:hmm_id]}&type=#{acctype}&street_address=#{params[:street_address]}&city=#{params[:city]}&state=#{params[:state]}&telephone=#{params[:telephone]}&months=#{params[:months]}"
        render :text =>"Transaction has been declined.  Please check the billing name, credit card CVV number, and/or card expiration date and try again."
      end
    else
      flash[:error] =  "This is a general error:  The credit card number entered is invalid."
      # redirect_to "http://www.holdmymemories.com/customers/authorise_payment/?id=#{params[:hmm_id]}&type=#{acctype}&street_address=#{params[:street_address]}&city=#{params[:city]}&state=#{params[:state]}&telephone=#{params[:telephone]}&months=#{params[:months]}"
      render :text =>"This is a general error:  The credit card number entered is invalid."

    end



    #redirect_to "http://www.holdmymemories.com/customers/other_details/#{params[:hmm_id]}"


    # redirect_to :controller => 'customers', :action => 'other_details', :message => @result, :id=>params[:hmm_id]

  end

  def upgrade_payment_family
    require 'active_merchant'
    require "ArbApiLib"
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
    if(params[:subnumber]=='')
      invoicenumber = "HMM000HMM#{params[:hmm_id]}"
    else
      if(params[:subnumber]=='one time payment')
        invoicenumber = "HMMAP0HMM#{params[:hmm_id]}"
      end
    end
    subnumber = params[:subnumber]
    int_months=Integer(months)
    account_expdate= Date.today+int_months.months
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

    #number = '4007000000027'

    creditcard = ActiveMerchant::Billing::CreditCard.new( #:number => number, #Authorize.net test card, error-producing
      :number => card_no, #Authorize.net test card, non-error-producing
      :month => exp_month,                #for test cards, use any date in the future
      :year => exp_year,
      :first_name => fname,
      :last_name => lname,
      :verification_value => cvv_no#:cvv => cvv_no

      #note that MasterCard is 'master'
    )

    if creditcard.valid?
      if(params[:account_type] = "platinum_user")
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
        hmm_user_det=HmmUser.find(params[:hmm_id])
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
        if(params[:membershipsoldby])
          hmm_user_det[:membership_sold_by] = params[:membershipsoldby]
        end
        hmm_user_det.save

        if(session[:employe])

          employedet=EmployeAccount.find(session[:employe])
          hmmstudio=HmmStudio.find(employedet.store_id)
          hmm_user_det[:emp_id] = session[:employe]
          hmm_user_det[:studio_id]=employedet.store_id
          hmm_user_det.save

          

          subchaptercount=SubChapter.count(:all, :conditions => "store_id > 0 and uid=#{hmm_user_det.id}")
          @get_content_url=ContentPath.find(:all, :conditions => "status='active'")
          content_path=@get_content_url[0]['content_path']
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
          payment_recieved_on= Date.today+i.months
          #recdate= Time.parse(payment_recieved_on)
          mon= payment_recieved_on.strftime("%m")
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
        account_expdate= Date.today+int_months.months

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

          subscriptionid = apiresp.subscriptionid

          link = "http://www.holdmymemories.com/#{hmm_user_det.family_name}"
          pw=HmmUser.find(:all, :select => "v_password as pword,password_required as preq, familywebsite_password as fpword ", :conditions => "id=#{hmm_user_det.id}")
          passwd=pw[0].pword
          pass_req = "#{hmm_user_det.password_required}"
          pass = "#{hmm_user_det.familywebsite_password}"
          nextsub = HmmUser.find_by_sql("SELECT DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL +#{months.to_i} MONTH), '%M %D, %Y') as dat")

          logger.info("1111111111111")

          Postoffice.deliver_paymentsucess("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, params[:account_type], hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,apiresp.subscriptionid, hmm_user_det.v_user_name,passwd,link,pass_req,pass,nextsub[0]['dat'])

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
            logger.info("22222222222")
            postoffice.deliver_paymentsucessupdate("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, account_type, hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,subscriptionid, hmm_user_det.v_user_name, hmm_user_det.v_password,link,pass_req,pass)
          rescue
            logger.info("smtp error")
          end
          #redirect_to "/manage_site/upgrade1/#{params[:id]}?atype=#{acctype}&sucess='Subscription Created successfully'&subscriptionnumber=#{subscriptionid}"


        else
          apiresp.messages.each { |message|
            puts "Error Code=#{message.code}"
            puts "Error Message =#{message.text } "
            flash[:sucess] =  ""
            flash[:sucess_id] =  " Your Account has been upgraded successfully.<br>"
          }
          begin
            logger.info("3333333333")
            Postoffice.deliver_paymentsucessupdate("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, account_type, hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,"One time payment", hmm_user_det.v_user_name, hmm_user_det.v_password,link,pass_req,pass)
          rescue
            logger.info("smtp error")
          end
          #redirect_to "/manage_site/upgrade1/#{params[:id]}?atype=#{acctype}&sucess='Your Account has been upgraded successfully.'&subscriptionnumber='one time payment'"
          hmm_user_det=HmmUser.find(params[:hmm_id])
          hmm_user_det[:subscriptionnumber] = "One time payment"
          hmm_user_det.save

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
        puts "\nXML Dump:"
        @xmldet= xmlresp
        render :text =>"Subscription Created successfully"
      else
        flash[:error] ="Transaction has been declined.  Please check the billing name, credit card CVV number, and/or card expiration date and try again."
        #redirect_to "/manage_site/upgrade1/#{params[:id]}?atype=#{acctype}&error='Transaction has been declined please check your Credit card CVV number, Card Expiration date and try again'"
        render :text =>"Transaction has been declined.  Please check the billing name, credit card CVV number, and/or card expiration date and try again."
      end
    else
      flash[:error] =   "Error Message = This is a general error Entered Credit card number or CVV number is invalid"
      #redirect_to "/manage_site/upgrade1/#{params[:id]}?atype=#{acctype}&error='This is a general error Entered Credit card number or CVV number is invalid'"
      render :text => "This is a general error:  The credit card number entered is invalid."
    end
  end



  def customers_list_wpf
    @results = HmmUser.find(:all, :conditions => "emp_id=#{params[:id]}",:order =>"id desc")
    render :layout => false
  end

  def customers_chap_wpf
    @userDetail = HmmUser.find(:first, :conditions => "id=#{params[:id]}")
    @results = Tag.find(:all, :conditions => "uid=#{params[:id]} and status='active'")
    render :layout => false
  end

  def album_contents
    @results = MobileUserContent.find(:all,:conditions=>{:tagid=>params[:album_id],:status=>'active'})
    render :layout => false
  end

  def customers_subchap_wpf
    @results = SubChapter.find(:all, :conditions => "tagid=#{params[:id]}  and status='active'")
    render :layout => false
  end

  def customers_gallery_wpf
    user=EmployeAccount.find(:first,:conditions=>"id=#{params[:emp_id]}")
    userdetails=SubChapter.find(:first,:conditions=>"uid=#{params[:id]} and store_id=#{user.store_id} and status='active'")
    if userdetails.nil?
      userdetails=HmmWpf.create_stud_chap(params[:id],user.store_id)
    end
    @results = Galleries.find(:all,:select=>"a.*",:joins=>"as a,sub_chapters as b", :conditions => "a.subchapter_id=b.id and b.uid=#{params[:id]} and b.store_id=#{user.store_id} and b.status='active' and a.status='active'",:group=>"a.id")
    render :layout => false
  end

  def customers_moments_wpf
    @sql = ActiveRecord::Base.connection();
    @results = UserContent.find(:all, :conditions => "gallery_id=#{params[:id]}  and status='active'")
    render :layout => false
  end

  def customer_avtar
    @results = HmmUser.find(params[:id])
  end

  def customers_avtaar_upload

  end

  def customers_payment_details
    @results = HmmUser.find(params[:id])
    render :layout => false
  end

  def customer_login
    @result = HmmUser.authenticate(params[:username],params[:password])
    if @result
      @user_id = @result.id
    else
      @user_id = false
    end
    render :layout => false
  end

  def check_coupon
    @coupon = Cupon.find(:first, :conditions => "unid='#{params[:couponno]}'",
      :select=>"unid,valid_period,DATE_FORMAT(start_date,'%c/%e/%Y') as begin_date,DATE_FORMAT(expire_date,'%c/%e/%Y') as end_date,cupon_type")
    @coupon_status = Cupon.find(:first, :conditions => "unid='#{params[:couponno]}' and start_date <= CURRENT_TIMESTAMP() and expire_date >= CURRENT_TIMESTAMP()")
    if @coupon_status
      @status = 'active'
    else
      @status='inactive'
    end
    if !@coupon
      render :text => "invalid"
    else
      render :layout => false
    end
  end


  def free_upgrade
    @hmm_user = HmmUser.find(params[:id])
    #     @hmm_user['account_type']="platinum_user"
    #     @hmm_user['months']=1
    @hmm_user['substatus']="active"
    #     @hmm_user['payments_recieved']="1"
    #adding 1 month cupon no
    @hmm_user['cupon_no']="64719993266120_2"
    #adding 1 month to expire date
    @exp_date_cal =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL 1 MONTH) as m")
    account_expdate= @exp_date_cal[0]['m']
    @hmm_user['account_expdate'] = account_expdate
    getthrough = @hmm_user['v_password']
    if @hmm_user.save
      if(params[:req_wpf]=='true') #if the request is from wpf just render the message
        render :text =>"Account upgraded successfully!"
      else
        flash[:unid_succes] = 'User Account has been Upgraded! Please Upload session images'
        redirect_to :controller => 'employe_accounts', :action => 'authenticate_upgrade_login', :id => 1, :v_user_name => @hmm_user.v_user_name, :pa => getthrough
      end
    else
      if(params[:req_wpf]=='true') #if the request is from wpf just render the message
        render :text =>"Upgrade account failed!"
      else
        flash[:unid_failed] = 'Upgrade failed! Please try after some time'
        redirect_to :action => 'upgrade_account'
      end
    end
  end

  def addallphoto_from_wpf
    files = params[:photolist]
    logger.info("photolist : - "+params[:photolist])
    @idstring = "";
    filesarray = files.split('#')
    for file in filesarray
      filedata = file.split('$')
      file_name=filedata[0].split("big_thumb/")
      @val  = UserContent.new()
      @val['v_filename'] = file_name[1]#file['v_filename'];#params[:v_filename]
      logger.info("file name : - "+filedata[0])
      @val['e_filetype'] = params[:filetype]#file['e_filetype'];#params[:e_filetype]
      logger.info("File type :- "+params[:filetype])
      filename = filedata[0];
      logger.info("filename :- "+filename)
      splitresult= filename.split('.');#params[:v_filename].split('.')
      @val['v_tagphoto'] =splitresult[0]
      @val['sub_chapid'] = params[:sub_chapid]#file['sub_chapid']; #params[:sub_chapid]
      @val['uid'] = params[:userId]
      @val['e_access'] = params[:permission]#'semiprivate'
      @val['tagid'] = params[:tagid]
      @val['d_createddate'] = Time.now
      @val['d_momentdate'] = Time.parse(filedata[1])
      @val['gallery_id'] = params[:gallery_id]
      @val['v_desc'] = 'Enter description here.'
      @val.save
      @results =  Tag.find(:all, :conditions=> "default_tag='no' and uid=#{params[:userId]}")
      for res in @results
        @imgval=UserContent.find(:all, :conditions=> "tagid ='#{res.id}' and v_filename='#{filedata[0]}'")
        for img in @imgval
          params[:id]=img.id
          UserContent.find(params[:id]).destroy
        end
      end
      if(@idstring == "")
        @idstring = String(@val.id);
      else
        @idstring = @idstring+'$'+String(@val.id)
      end
    end
    render :text => @idstring
  end

  def uncategorized
    @userid = params[:id]
    @results =  Tag.find(:all, :conditions=> "default_tag='no' and uid=#{@userid}")
    render :layout => false
  end


  def create_chapter
    output = 'failed'
    unless params[:user_id].blank? && params[:chapter_name].blank?
      if params[:chapter_description]==nil || params[:chapter_description]==""
        params[:chapter_description] = 'Enter description here'
      end
      result = HmmWpf.save_chapter(params[:chapter_name], params[:user_id], params[:chapter_description])
      output = 'success' if result
    end
    render :text => output
  end

  def create_subchapter
    output = 'failed'
    unless params[:user_id].blank? && params[:chapter_id].blank? && params[:subchapter_name].blank?
      if params[:subchapter_description]==nil || params[:subchapter_description] == ""
        params[:subchapter_description] = 'Enter description here'
      end
      result = HmmWpf.save_subchapter(params[:subchapter_name], params[:subchapter_description], params[:user_id], params[:chapter_id], 'all')
      output = 'success' if result
    end
    render :text => output
  end

  def create_gallery
    output = 'failed'
    unless params[:user_id].blank? && params[:emp_id].blank? && params[:gallery_name].blank? && params[:gallery_type].blank?
      if params[:gallery_description]==nil || params[:gallery_description]== ""
        params[:gallery_description] = 'Enter description here'
      end
      studio=EmployeAccount.find(:first,:select=>"store_id",:conditions=>"id=#{params[:emp_id]}")
      subchapters=SubChapter.find(:first,:select=>"id",:conditions=>"store_id=#{studio.store_id} and uid=#{params[:user_id]}")
      result = HmmWpf.save_gallery(params[:gallery_name], params[:gallery_description], params[:gallery_type], params[:user_id], subchapters.id)
      output = 'success' if result
    end
    render :text => output
  end

  def create_album
    output = 'failed'
    unless params[:user_id].blank? && params[:album_name].blank? && params[:album_type].blank?
      if params[:album_type] == 'image'
        chapter_type = 'photo'
      else
        chapter_type = params[:album_type]
      end
      if params[:album_description]==nil || params[:album_description]==""
        params[:album_description] = 'Enter description here'
      end
      result = HmmWpf.save_chapter(params[:album_name], params[:user_id], params[:album_description],chapter_type, params[:album_type])
      output = 'success' if result
    end
    render :text => output
  end

  #input: employee id (id)
  #returns the customer belonging to the studio fo the given employee
  def credit_points
    emps = Array.new
    @employee = EmployeAccount.find(:first,:conditions=>"id=#{params[:id]}",:select=>"store_id") #get the studio id of the employee
    @employees = EmployeAccount.find(:all,:conditions => "store_id=#{@employee.store_id}",:select=>"id") #get the employees belonging to that studio
    for emp in @employees
      emps.push(emp.id)
    end
    employees = emps.join(',')
    @results = HmmUser.find(:all, :joins =>"LEFT JOIN credit_points on hmm_users.id = credit_points.user_id",:conditions => "emp_id in (#{employees})",:order =>"hmm_users.id desc",:select=>"hmm_users.*,credit_points.available_credits,credit_points.used_credits,credit_points.notes") #get the users associated with the employee list
    render :layout => false
  end

  def search_credit_points
    user=Hash.new
    point=Array.new
    points=Hash.new
    if params[:first_name] && params[:last_name] && params[:email_address] && params[:user_name]
      first_name=params[:first_name]
      last_name=params[:last_name]
      email_address=params[:email_address]
      user_name=params[:user_name]
      cond=[]
      cond.push("1=1")
      if !first_name.nil? && !first_name.blank?
        cond.push(" and v_fname='#{first_name}' ")
      end
      if !last_name.nil? && !last_name.blank?
        cond.push(" and v_lname='#{last_name}' ")
      end
      if !email_address.nil? && !email_address.blank?
        cond.push(" and v_e_mail='#{email_address}' ")
      end
      if !user_name.nil? && !user_name.blank?
        cond.push(" and 	v_user_name='#{user_name}' ")
      end
      studs = Array.new
      @employee = EmployeAccount.find(:first,:conditions=>"id=#{params[:id]}",:select=>"store_id") #get the studio id of the employee
      @employees = HmmStudio.find(:first,:conditions => "id=#{@employee.store_id}",:select=>"studio_groupid") #get the employees belonging to that studio
      studios=HmmStudio.find(:all,:select=>"id",:conditions=>"studio_groupid=#{@employees.studio_groupid} and status='active'")
      for studio in studios
        studs.push(studio.id)
      end
      employees = studs.join(',')
      @results = HmmUser.find(:all, :joins =>"LEFT JOIN credit_points on hmm_users.id = credit_points.user_id",:conditions => "studio_id in (#{employees}) and #{cond}",:order =>"hmm_users.id desc",:select=>"hmm_users.*,credit_points.available_credits,credit_points.used_credits,credit_points.notes",:limit=>500) #get the users associated with the employee list
      if @results.length >0
        for user_details in @results
          if(user_details.available_credits==nil || user_details.available_credits=='')
            avail=0
          else
            avail=user_details.available_credits
          end
          if(user_details.used_credits ==nil || user_details.used_credits=='')
            used=0
          else
            used=user_details.used_credits
          end
          if (user_details.studio_id == nil || user_details.studio_id == '' || user_details.studio_id == 0 || user_details.studio_id == '0')
            std_name="Direct Customer"
          else
            stud_name=HmmStudio.find(:first,:conditions => "id=#{user_details.studio_id}",:select=>"studio_name")
            std_name=stud_name.studio_name
          end
          points={:UserName=>user_details.v_user_name,:UserEmailId=>user_details.v_e_mail,:Phone=>user_details.telephone,:UserId=>user_details.id,:FirstName=>user_details.v_fname,:LastName=>user_details.v_lname,:Sex=>user_details.e_sex,:Status=>user_details.e_user_status,:AccountType=>user_details.account_type,:CreditNotes=>user_details.notes,:AvailablePoints=>avail,:UsedPoints=>used,:StudioName=>std_name}
          point.push(points)
        end
        user={:status=>"true",:users=>point,:message=>"successfully retrieved users info"}
      else
        user={:status=>"false",:users=>"",:message=>"No User Found"}
      end
    else
      user={:status=>"false",:users=>"",:message=>"No Employee Found"}
    end
    render :text => user.to_json
  end

  def getcreditpoints
    emps = Array.new
    user=Hash.new
    point=Array.new
    points=Hash.new
    if params[:id]
      #      employee = EmployeAccount.find(:first,:conditions=>"id=#{params[:id]}",:select=>"store_id") #get the studio id of the employee
      #      if !employee.nil?
      #        @employees = EmployeAccount.find(:all,:conditions => "store_id=#{employee.store_id}",:select=>"id") #get the employees belonging to that studio
      #        for emp in @employees
      #          emps.push(emp.id)
      #        end
      #        employees = emps.join(',')
      if params[:totalCount]
        count=params[:totalCount].to_i
      else
        counts = HmmUser.count(:all, :joins =>"LEFT JOIN credit_points on hmm_users.id = credit_points.user_id",:conditions => "emp_id =#{params[:id]} and account_type!='free_user'",:select=>"hmm_users.id") #get the users associated with the employee list
        counts_f=  (counts.to_f/25)
        count=counts_f.ceil
      end
      @results = HmmUser.paginate(:per_page => 25, :page => params[:page], :joins =>"LEFT JOIN credit_points on hmm_users.id = credit_points.user_id",:conditions => "emp_id =#{params[:id]} and account_type!='free_user'",:order =>"hmm_users.id desc",:select=>"hmm_users.v_user_name,hmm_users.v_e_mail,hmm_users.telephone,hmm_users.id,hmm_users.v_fname,hmm_users.v_lname,hmm_users.e_sex,hmm_users.e_user_status,hmm_users.account_type,credit_points.available_credits,credit_points.used_credits,credit_points.notes") #get the users associated with the employee list
      if count >0
        for user_details in @results
          if(user_details.available_credits==nil || user_details.available_credits=='')
            avail=0
          else
            avail=user_details.available_credits
          end
          if(user_details.used_credits ==nil || user_details.used_credits=='')
            used=0
          else
            used=user_details.used_credits
          end
          points={:UserName=>user_details.v_user_name,:UserEmailId=>user_details.v_e_mail,:Phone=>user_details.telephone,:UserId=>user_details.id,:FirstName=>user_details.v_fname,:LastName=>user_details.v_lname,:Sex=>user_details.e_sex,:Status=>user_details.e_user_status,:AccountType=>user_details.account_type,:CreditNotes=>user_details.notes,:AvailablePoints=>avail,:UsedPoints=>used}
          point.push(points)
        end
        user={:status=>"true",:totalCount=>count,:users=>point,:message=>"successfully retrieved users info"}
      else
        user={:status=>"false",:totalCount=>count,:users=>"",:message=>"No User Found"}
      end
    else
      user={:status=>"false",:totalCount=>0,:users=>"",:message=>"No Employee Found"}
    end
    render :text => user.to_json
  end


  def credit_logs
    unless params[:emp_id].blank? && params[:user_id].blank?
      @credit = CreditPoint.find(:first,:conditions=>{:user_id=>params[:user_id]})
      if @credit
        response = CreditLog.find(:all,:joins=>"LEFT JOIN hmm_studios on credit_logs.hmm_studio_id = hmm_studios.id",:conditions => "credit_point_id=#{@credit.id}",:select => "credit_logs.used_credit,DATE_FORMAT(credit_logs.created_at,'%c/%e/%Y') as used_date,hmm_studios.studio_branch")
      end
    end
    if response
      render :xml => response.to_xml({:dasherize =>false,:skip_types =>true})
    else
      render :text => "credit logs not available"
    end
  end


  def deduct_credit_points
    response = 'failed'
    unless params[:emp_id].blank? && params[:user_id].blank? && params[:used_points].blank?
      @credit = CreditPoint.find(:first,:conditions=>{:user_id=>params[:user_id]})
      if @credit
        if(@credit.available_credits >= Float(params[:used_points]))
          credit_points = @credit.available_credits-Float(params[:used_points])
          used_points = @credit.used_credits+Float(params[:used_points])
          CreditPoint.update(@credit.id, :available_credits => credit_points, :used_credits => used_points)
          @employee = EmployeAccount.find(:first,:conditions=>"id=#{params[:emp_id]}",:select=>"store_id") #get the studio id of the employee
          log = CreditLog.new
          log.hmm_studio_id = @employee.store_id
          log.credit_point_id = @credit.id
          log.used_credit = Float(params[:used_points])
          log.save()
          logger.info "WPF : Credit points deducted"
          response = 'success'
        else
          logger.info "WPF : Insufficient credit points"
        end
      else
        logger.info "WPF : Credit points not available"
      end

    else
      logger.info "WPF : Incomplete data provided"
    end
    render :text =>response
  end

  def subscription_reciept
    unless params[:user_id].blank?
      @hmm_user=HmmUser.find(params[:user_id])
      next_paydate = @hmm_user.account_expdate
      if next_paydate!=nil
        @subscriptiondate=next_paydate.strftime("%m-%d-%Y")
      else
        @subscriptiondate = 'NA'
      end

      if(@hmm_user.account_type=='platinum_user')
        @account_type = "Premium Account"
        @subscription_amount = "$9.95"
      elsif @hmm_user.account_type=='familyws_user'
        @account_type = "Family Website Account"
        @subscription_amount = "$4.95"
      end
      if @hmm_user.subscriptionnumber == "One time payment"
        @payment_method="One payment occured successfully"
        @amount_recieved=@hmm_user.amount
        @subscription_interval="Nil"

      else
        @payment_method="Your next monthly renewal charge of #{@subscription_amount} will occur on  #{@subscriptiondate}"
        @amount_recieved=@hmm_user.amount
        @subscription_interval="#{@hmm_user.months} months"
      end

      if @hmm_user['membership_sold_by'] != nil
        @sold_by = @hmm_user['membership_sold_by']
      else
        @sold_by = 'NA'
      end

      hmmpass=HmmUser.find(:first, :select => "v_password as ps", :conditions => "id=#{@hmm_user.id}")
      @userpassword = hmmpass.ps
      render :layout => false
    end
  end

  def studio_commission_report
    if !params[:emp_username].nil? && !params[:emp_username].blank? && !params[:start_date].nil? && !params[:start_date].blank? && !params[:end_date].nil? && !params[:end_date].blank?
      user = EmployeAccount.find(:first,:conditions=>"employe_username='#{params[:emp_username]}' and status='unblock'")
      if !user.nil?
        customers_results=HmmWpf.other_studio_commision_report(user.store_id,params[:start_date],params[:end_date],params[:page])
        customers={}
        cus_arr=[]
        if !customers_results.nil? && !customers_results.empty?
          for customers_result in customers_results
            if(customers_result.cancel_status == 'approved')
              status="Subscription Cancelled"
            else
              status="Subscription Active"
            end
            d=StudioCommission.find(:last,:conditions=>"uid=#{customers_result.uid}")
            if d
              date=d.payment_recieved_on.strftime("%m - %d - %Y")
              amount=(d.amount*2)-0.05
              #amounts=number_with_precision(amount, :precision => 2)
              # commission=number_with_precision(Float(customers_result.commission).round(2), :precision => 2)
            end
            if !customers_result.payment_recieved_on.nil?
              payment_recieved_on=customers_result.payment_recieved_on.to_date.strftime("%m - %d - %Y")
            else
              payment_recieved_on=customers_result.payment_recieved_on
            end
            customers={:id=>customers_result.id,:first_name=>customers_result.v_fname,:last_name=>customers_result.v_lname,:user_name=>customers_result.v_user_name,:amount_received_on=>payment_recieved_on,:subscription_number=>customers_result.subscriptionnumber,:subscription_status=>status,:studio_commission=>"$#{customers_result.commission}.00",:sales_person=>customers_result.membership_sold_by,:recent_payment_date=>date,:recent_payment_amount=>"$#{amount}"}
            cus_arr.push(customers)
          end
          customers={:body=>cus_arr,:status=>true,:msg=>"User Exists"}
        else
          customers={:body=>"",:status=>false,:msg=>"No Customers"}
        end
      else
        customers={:body=>"",:status=>false,:msg=>"Employee Does not exist"}
      end
    else
      customers={:body=>"",:status=>false,:msg=>"inappropriate parameters"}
    end
    render :text=>customers.to_json
  end


  def customers_all_gallery_wpf
    @results = Galleries.find(:all, :conditions => "subchapter_id=#{params[:id]}  and status='active'")
    render :layout => false
  end

  def update_customer_emp
    if !params[:id].nil? && !params[:emp_name].nil? && !params[:notes_to_link_customer].nil? && !params[:id].blank? && !params[:emp_name].blank? && !params[:notes_to_link_customer].blank?
      HmmWpf.update_customer_studio(params[:id],params[:emp_name],params[:notes_to_link_customer])
      render :text=>"true"
    else
      render :text=>"false"
    end
  end

  def created_customers_report
    sort = "hmm_users.id desc"

    if !params[:emp_username].nil? && !params[:emp_username].blank?
      user = EmployeAccount.find(:first,:conditions=>"employe_username='#{params[:emp_username]}' and status='unblock'")
      if !user.nil?
        if (params[:from_date]!=nil && params[:to_date]!=nil && params[:exp_date]!=nil)
          fromdate=params[:from_date]
          todate=params[:to_date]
          edate=params[:exp_date]
          account_type=params[:account_type]

          total_conditions1= " and d_created_date  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' and (account_expdate<'#{edate}' || account_expdate>'#{edate}') "

          block_conditions1= " and d_created_date  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' and account_expdate<'#{edate}'  "

          unblock_conditions1= " and d_created_date  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' and account_expdate>'#{edate}' "





          conditions4= " and hmm_studios.id=#{user.store_id}"



          total_conditions="1=1 #{total_conditions1}  #{conditions4}"
          block_conditions="1=1 #{block_conditions1}  #{conditions4}"

          unblock_conditions="1=1 #{unblock_conditions1}   #{conditions4}"
          if account_type.nil? || account_type.blank?
            free_total=self.find_data(total_conditions,"free_user",sort)
            free_block=self.find_data(block_conditions,"free_user",sort)
            free_unblock=self.find_data(unblock_conditions,"free_user",sort)

            family_total=self.find_data(total_conditions,"familyws_user",sort)
            family_block=self.find_data(block_conditions,"familyws_user",sort)
            family_unblock=self.find_data(unblock_conditions,"familyws_user",sort)

            platinum_total=self.find_data(total_conditions,"platinum_user",sort)
            platinum_block=self.find_data(block_conditions,"platinum_user",sort)
            platinum_unblock=self.find_data(unblock_conditions,"platinum_user",sort)
            premium_info={:all_users=>platinum_total,:inactive_users=>platinum_block,:active_users=>platinum_unblock,:total_count=>platinum_total.length,:inactive_users_count=>platinum_block.length,:active_users_count=>platinum_unblock.length}
            family_info={:all_users=>family_total,:inactive_users=>family_block,:active_users=>family_unblock,:total_count=>family_total.length,:inactive_users_count=>family_block.length,:active_users_count=>family_unblock.length}
            free_info={:all_users=>free_total,:inactive_users=>free_block,:active_users=>free_unblock,:total_count=>free_total.length,:inactive_users_count=>free_block.length,:active_user_count=>free_unblock.length}
            body={:premium_customers_info=>premium_info,:familywebsite_customers_info=>family_info,:free_users_info=>free_info}
          elsif account_type=="platinum_user"
            platinum_total=self.find_data(total_conditions,"platinum_user",sort)
            platinum_block=self.find_data(block_conditions,"platinum_user",sort)
            platinum_unblock=self.find_data(unblock_conditions,"platinum_user",sort)
            premium_info={:all_users=>platinum_total,:inactive_users=>platinum_block,:active_users=>platinum_unblock,:total_count=>platinum_total.length,:inactive_users_count=>platinum_block.length,:active_users_count=>platinum_unblock.length}
            body={:premium_customers_info=>premium_info}
          elsif account_type=="familyws_user"
            family_total=self.find_data(total_conditions,"familyws_user",sort)
            family_block=self.find_data(block_conditions,"familyws_user",sort)
            family_unblock=self.find_data(unblock_conditions,"familyws_user",sort)
            family_info={:all_users=>family_total,:inactive_users=>family_block,:active_users=>family_unblock,:total_count=>family_total.length,:inactive_users_count=>family_block.length,:active_users_count=>family_unblock.length}


            body={:familywebsite_customers_info=>family_info}
          elsif account_type=="free_user"
            free_total=self.find_data(total_conditions,"free_user",sort)
            free_block=self.find_data(block_conditions,"free_user",sort)
            free_unblock=self.find_data(unblock_conditions,"free_user",sort)
            free_info={:all_users=>free_total,:inactive_users=>free_block,:active_users=>free_unblock,:total_count=>free_total.length,:inactive_users_count=>free_block.length,:active_user_count=>free_unblock.length}


            body={:free_users_info=>free_info}
          end



          all_data={:body=>body,:status=>"success",:message=>"Information Retrieved"}
        else
          all_data={:body=>"",:status=>"failure",:message=>"Some parameters are missing"}
        end
      else
        all_data={:body=>"",:status=>"failure",:message=>"Employee Does Not Exist"}
      end
    else
      all_data={:body=>"",:status=>"failure",:message=>"Employee parameter missing"}
    end
    render :text=>all_data.to_json

  end

  def find_data(total_conditions,type,sort)
    res = HmmUser.find(:all, :select => "hmm_users.v_fname,hmm_users.v_lname,hmm_users.v_user_name,hmm_users.v_e_mail,hmm_users.account_expdate,hmm_users.months,hmm_users.d_created_date,hmm_users.account_type", :joins =>" LEFT JOIN hmm_studios
ON hmm_users.studio_id=hmm_studios.id", :conditions=>"#{total_conditions} and hmm_users.account_type='#{type}'" , :order => sort)
    res=self.return_hash(res)
    return res
  end

  def return_hash(user_infos)
    user_data=[]
    for user_info in user_infos
      if user_info.account_expdate!=nil && user_info.account_expdate!=""
        if user_info.account_expdate.to_date>Date.today
          status="Active"
        else
          status="Inactive"
        end
      else
        status="Inactive"
      end
      if(user_info.account_type=='platinum_user')
        val="Premium User"
      elsif(user_info.account_type=='familyws_user')
        val="Family Website User"
      else
        val="Free User"
      end
      user={:first_name=>user_info.v_fname,:last_name=>user_info.v_lname,:user_name=>user_info.v_user_name,:email_address=>user_info.v_e_mail,:status=>status,:subscriptio_month=>user_info.months,:created_date=>user_info.d_created_date,:account_type=>val}
      user_data.push(user)
    end
    return user_data
  end


end