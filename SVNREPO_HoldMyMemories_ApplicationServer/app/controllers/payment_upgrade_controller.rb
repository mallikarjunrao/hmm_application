#
# To change this template, choose Tools | Templates
# and open the template in the editor.


class PaymentUpgradeController < ApplicationController
  layout "standard"
  require 'money'
  #require 'active_merchant'



  def upgrade_payment

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
    if(logged_in_hmm_user.subscriptionnumber.nil? || logged_in_hmm_user.invoicenumber!='')
      invoicenumber = "HMM000HMM#{params[:hmm_id]}"
    else
      if(logged_in_hmm_user.subscriptionnumber=="One time payment")
        invoicenumber = "HMMAP0HMM#{params[:hmm_id]}"
      end
    end
    subnumber = logged_in_hmm_user.subscriptionnumber


    if(logged_in_hmm_user.account_type=='free_user')
      @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL #{months} MONTH) as m")
    else
      @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE('#{logged_in_hmm_user.account_expdate}',INTERVAL #{months} MONTH) as m")
    end
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

    #number = '4007000000027'

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
      redirect_to "http://holdmymemories.com/customers/upgrade/#{acctype}"
    else
          #@creditcard = Creditcard.find(params[:id])
          if ( request_server_url == "http://staging.holdmymemories.com")
          testmode = true
        else
          testmode = false
        end
        gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(:test => testmode, :login => "8GxD65y84", :password=> "89j6d34cW8CKhp9S")
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

              hmm_user_det[:account_type] = params[:account_type]

              hmm_user_det[:account_expdate] = account_expdate
              hmm_user_det[:cancel_status] = ''
              hmm_user_det[:canceled_by] = ''


              hmm_user_det[:first_payment_date] = Time.now
              hmm_user_det[:invoicenumber] = invoicenumber
              hmm_user_det[:months] = months
              hmm_user_det[:amount] = amount1
              hmm_user_det[:unid] = unid
              hmm_user_det[:membership_sold_by] = params[:sold_by]
              hmm_user_det.save








          if(logged_in_hmm_user.account_type=='free_user')
            @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL #{months} MONTH) as m")
          else
            @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE('#{logged_in_hmm_user.account_expdate}',INTERVAL #{months} MONTH) as m")
          end
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
              pw=HmmUser.find(:all, :select => "v_password as pword,password_required as preq, familywebsite_password as fpword ", :conditions => "id=#{hmm_user_det.id}")

              link = "http://holdmymemories.com/#{hmm_user_det.family_name}"
              pass_req = pw[0].preq
              pass = pw[0].pword
              passwd=pw[0].pword

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
                pw=HmmUser.find(:all, :select => "v_password as pword,password_required as preq, familywebsite_password as fpword ", :conditions => "id=#{hmm_user_det.id}")

              link = "http://holdmymemories.com/#{hmm_user_det.family_name}"
              pass_req = pw[0].preq
              pass = pw[0].pword
              passwd=pw[0].pword
                Postoffice.deliver_paymentsucessupdate("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, hmm_user_det.account_type, hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,subscriptionid, hmm_user_det.v_user_name, passwd,link,pass_req,pass)


                redirect_to "http://holdmymemories.com/customers/upgrade/#{acctype}"

          else
            apiresp.messages.each { |message|
                puts "Error Code=#{message.code}"
                puts "Error Message =#{message.text } "
                 flash[:sucess] =  ""
                flash[:sucess_id] =  " Your Account has been upgraded successfully.<br>"
              }
                   pw=HmmUser.find(:all, :select => "v_password as pword,password_required as preq, familywebsite_password as fpword ", :conditions => "id=#{hmm_user_det.id}")

              link = "http://holdmymemories.com/#{hmm_user_det.family_name}"
              pass_req = pw[0].preq
              pass = pw[0].pword
              passwd=pw[0].pword
                  Postoffice.deliver_paymentsucessupdate("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, params[:account_type], hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,"One time payment", hmm_user_det.v_user_name, passwd,link,pass_req,pass)

                  logger.info("smtp error")

               redirect_to "http://holdmymemories.com/customers/upgrade/#{acctype}"

              hmm_user_det=HmmUser.find(params[:hmm_id])
              hmm_user_det[:subscriptionnumber] = "One time payment"

              hmm_user_det.save

            end

            puts "\nXML Dump:"
            @xmldet= xmlresp
        else

          flash[:error] ="Transaction has been declined please check your Credit card CVV number, Card Expiration date and try again"
          redirect_to "http://holdmymemories.com/customers/upgrade/#{acctype}"
        end

          end


    else


                flash[:error] =   "Error Message = This is a general error Entered Credit card number or CVV number is invalid"

               redirect_to "/customers/upgrade/#{acctype}"
    end

  end

 def cancel_subscript

              require "ArbApiLib"
              aReq = ArbApi.new
              subnumber = logged_in_hmm_user.subscriptionnumber
              @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL 1 MONTH) as m")
              account_expdate = @hmm_user_max[0]['m']
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
              puts "Subscription Creation Failed"
              apiresp.messages.each { |message|
               puts "Error Code=#{message.code}"
               puts "Error Message =#{ message.text} "
               @res =  message.text
              }

                if(@res == "The subscription has already been canceled." || @res == "Successful." || @res == "no subscription")
                  hmm_user = HmmUser.find(logged_in_hmm_user.id)
                  hmm_user.account_type="free_user"
                  hmm_user.account_expdate=account_expdate
                  hmm_user.save

                  if(@res == "Successful.")

                   flash[:sucess_id] = "Your Subscription has been cancelled sucessfully."
                  else
                   flash[:sucess_id] = "Your Subscription status is: #{@res}"
                  end

                  redirect_to "/customers/cancelled_sub/"
                end

  end



end

