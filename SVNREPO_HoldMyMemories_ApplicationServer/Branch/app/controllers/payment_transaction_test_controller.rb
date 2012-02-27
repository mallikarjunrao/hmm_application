# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

class PaymentTransactionTestController < ApplicationController
  
  require 'money'

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
              hmm_user_det[:account_expdate] = account_expdate
              hmm_user_det[:months] = months
              hmm_user_det[:amount] = amount1
              hmm_user_det[:unid] = unid

              hmm_user_det.save  
        
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
              link = "http://www.holdmymemories.com/"+hmm_user_det.family_name
              pass_req = hmm_user_det.password_required
              pass = hmm_user_det.familywebsite_password
              passwd= hmm_user_det['v_password']
              Postoffice.deliver_paymentsucess("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, params[:account_type], hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,apiresp.subscriptionid, hmm_user_det.v_user_name, passwd,link,pass_req,pass)
              
              flash[:sucess] =  "Subscription Created successfully"
              flash[:sucess_id] = "Your Subscription id is: " + apiresp.subscriptionid
              redirect_to "http://www.holdmymemories.com/customers/other_details/#{params[:hmm_id]}"


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
              Postoffice.deliver_paymentsucess("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, params[:account_type], hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,"One time payment", hmm_user_det.v_user_name, passwd,link,pass_req,pass)
              redirect_to "http://www.holdmymemories.com/customers/other_details/#{params[:hmm_id]}"
            end

            puts "\nXML Dump:" 
            @xmldet= xmlresp
      
        
      else
          message = response.message
          if(message == "No Match")
            message = "Card Code Status: No Match"
          end
          
          flash[:error] = "Transaction has been declined due to following reason <br>"+message
          redirect_to "http://www.holdmymemories.com/customers/authorise_payment/?id=#{params[:hmm_id]}&type=#{acctype}"
        end
  else
    flash[:error] =  "Error Message = " +  "This is a general error Entered Credit card number or CVV number is invalid"
    redirect_to "http://www.holdmymemories.com/customers/authorise_payment/?id=#{params[:hmm_id]}&type=#{acctype}"
  end
    
    
    

 
      
 # redirect_to :controller => 'customers', :action => 'other_details', :message => @result, :id=>params[:hmm_id]
  
 end
 
  def upgrade_payment
    
    card_no=params[:card_no]
    cvv_no=params[:cardcvv_no]
    expiry_date=params[:exp_year]+"-"+params[:exp_month]
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
    months=params[:months]
    account_type=params[:account_type]
    email = params[:email]
    invoicenumber = "HMM000"+"HMM#{params[:hmm_id]}"
    if(params[:subnumber]=='' || params[:subnumber]==nil)
      flag = 1
    else
      flag = 2
      subnumber=params[:subnumber]
    end
    
    
    @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL #{months} MONTH) as m")
    account_expdate= @hmm_user_max[0]['m']
    
    if(account_type == "familyws_user")
      acctype="family_website"
      if(months == "1")
        amount = 4.95
        amount1 = "$4.95"
      end
      if(months == "6")
        amount = 24.95
        amount1 = "$24.95"
      end
      if(months == "12")
        amount = 49.95
        amount1 = "$49.95"
      end
    else
      if(account_type == "platinum_user")
        acctype="platinum_account"
        if(months == "1")
         amount = 9.95
         amount1 = "$9.95"
        end
        if(months == "6")
         amount = 49.95
         amount1 = "$49.95"
        end
        if(months == "12")
         amount = 99.95
         amount1 = "$99.95"
        end
      end
    end
    
     
    
    require "ArbApiLib"

    aReq = ArbApi.new
    if ARGV.length < 3
    
    end
    ARGV[0]= "https://api.authorize.net/xml/v1/request.api"
    ARGV[1]= "8GxD65y84"
    ARGV[2]= "89j6d34cW8CKhp9S"
    #ARGV[1]= "cnpdev4289"
    #ARGV[2]= "SR2P8g4jdEn7vFLQ"
    #ARGV[3]= "644100"
    
    auth = MerchantAuthenticationType.new(ARGV[1], ARGV[2])
    subname = ARGV.length > 3? ARGV[3]: account_type
    interval = IntervalType.new(months, "months")
    schedule = PaymentScheduleType.new(interval, params[:start_date], 9999, 0)
    cinfo = CreditCardType.new(card_no, expiry_date, cvv_no)
    binfo = NameAndAddressType.new(fname, lname,"Not added", street_address, city, state ,postcode, country,email,telephone )
    
    if(flag == 2)
      xmlout1 = aReq.CalcelSubscription(auth,subnumber)
      xmlresp1 = HttpTransport.TransmitRequest(xmlout1, ARGV[0])
      apiresp = aReq.ProcessResponse(xmlresp1)
      if apiresp.success
#        flash[:sucess] =  "Subscription updated successfully"
#        flash[:sucess_id] = "Your Subscription id is: " + apiresp.subscriptionid
#        redirect_to :controller => 'customers', :action => 'upgrade_sucess', :message => @result
#       else
#         puts "Subscription Creation Failed"
#         apiresp.messages.each { |message| 
#         puts "Error Code=" + message.code
#         puts "Error Message = " + message.text 
#         flash[:error] =  message.text
#         flash[:error_code] =  "Your Subscription has been failed due to following reason:  " + message.code + " <br><br> Please make appropriate changes and try again later"
#         }
          redirect_to :controller => 'customers', :action => 'upgrade', :id => acctype
      end
    end
        if(flag == 1)
#      xmlout = aReq.CreateSubscription(auth,subname,schedule,amount, 0, cinfo,binfo,interval,invoicenumber)
#      xmlresp = HttpTransport.TransmitRequest(xmlout, ARGV[0])
#      apiresp = aReq.ProcessResponse(xmlresp)
#      if apiresp.success
#        puts "code for freshly paid member"
#      else
#        puts "mission failed"
#      end
#    else
#      puts "mission failed"
    end
    
#    puts "Creating Subscription Name: " + subname
#    puts "Submitting to URL:" + ARGV[0]
    #xmlresp = HttpTransport.TransmitRequest(xmlout1, ARGV[0])


    #apiresp = aReq.ProcessResponse(xmlresp)

#    if apiresp.success 
#      hmm_user_det=HmmUser.find(params[:hmm_id])
#      hmm_user_det[:street_address]=params[:street_address]
#      hmm_user_det[:suburb]=params[:suburb]
#      hmm_user_det[:postcode]=params[:postcode]
#      hmm_user_det[:city]=params[:city]
#      hmm_user_det[:state]=params[:state]
#      hmm_user_det[:country]=params[:country]
#      hmm_user_det[:telephone]=params[:telephone]
#      hmm_user_det[:state]=state
#      hmm_user_det[:account_type]=params[:account_type]
#      hmm_user_det[:account_expdate]= account_expdate
#      hmm_user_det[:subscriptionnumber]= apiresp.subscriptionid
#      hmm_user_det.save
#      
#      link = "http://www.holdmymemories.com/"+hmm_user_det.family_name
#      pass_req = hmm_user_det.password_required
#      pass = hmm_user_det.familywebsite_password
#      Postoffice.deliver_paymentsucess("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, params[:account_type], hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,apiresp.subscriptionid, hmm_user_det.v_user_name, hmm_user_det.v_password,link,pass_req,pass)
#       
#      flash[:sucess] =  "Subscription Created successfully"
#      flash[:sucess_id] = "Your Subscription id is: " + apiresp.subscriptionid
#      redirect_to :controller => 'customers', :action => 'other_details', :message => @result, :id=>params[:hmm_id]
#    
#    else
#      puts "Subscription Creation Failed"
#      apiresp.messages.each { |message| 
#        puts "Error Code=" + message.code
#        puts "Error Message = " + message.text 
#        flash[:error] =  message.text
#        flash[:error_code] =  "Your Subscription has been failed due to following reason:  " + message.code + " <br><br> Please make appropriate changes and try again later"
#      }
#      
#      
#      redirect_to :controller => 'customers', :action => 'upgrade', :type => acctype
#    end

#    puts "\nXML Dump:" 
   @xmldet= xmlresp1
#    
    
  end
  
  
end

