# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

class PaymentTransactionTestController < ApplicationController


  require 'money'

  def process_payment
    card_type=params[:card_type]
    card_no=params[:card_no]
    cvv_no=params[:cardcvv_no]
    expiry_date=params[:exp_year]+"-"+params[:exp_month]
    exp_month=params[:exp_month]
    exp_year=params[:exp_year]
    fname=params[:fname]
    lname=params[:lname]
    amount=Integer(params[:amount])
    street_address = params[:street_address]
    suburb = params[:suburb]
    postcode = params[:postcode]
    city = params[:city]
    state = params[:state]
    country = params[:country]
    telephone = params[:telephone]
    fax = params[:fax]
    
    #amount=amt*100
#    amount_to_charge = Money.ca_dollar(1000) #ten US dollars
#    creditcard = ActiveMerchant::Billing::CreditCard.new( :number => '4111111111111111', #Authorize.net test card, error-producing
#    # :number => '4007000000027', #Authorize.net test card, non-error-producing
#      :month => 3,                #for test cards, use any date in the future
#      :year => 2010,              
#      :first_name => 'Mark',      
#      :last_name => 'McBride',
#      :type => 'visa'             #note that MasterCard is 'master'
#    )
#
#    if creditcard.valid?
#      gateway = ActiveMerchant::Billing::Base.gateway(:authorized_net.new(
#        :login => 'abcdefgh',         #API Login ID
#        :password => 'abcdefghijklm') )#Transaction Key
#
#options = {     
#          :address => {},
#          :billing_address => { 
#          :name     => 'Mark McBride',
#          :address1 => '1 Show Me The Money Lane',
#          :city     => 'San Francisco',
#          :state    => 'CA',
#          :country  => 'US',
#          :zip      => '23456',
#          :phone    => '(555)555-5555'
#        }
#}
#
#      response = gateway.autorize(amount_to_charge, creditcard, options)
#
#      if response.success?
#        gateway.capture(amount_to_charge, response.authorization)
#        @result = "Success: " + response.message.to_s
#      else
#        @result = "Fail: " + response.message.to_s
#      end
#    else
#      @result = "Credit card not valid: " + creditcard.validate.to_s
#    end

#    creditcard = ActiveMerchant::Billing::CreditCard.new(
#  :type       => 'visa'
#  :number     => '4242424242424242',
#  :month      => 8,
#  :year       => 2009,
#  :first_name => 'Bob',
#  :last_name  => 'Bobsen',
#)
  number = '4007000000027' #Authorize.net test card, non-error-producing

   # card_no = '4007000000027' #Authorize.net test card, non-error-producing
        creditcard = ActiveMerchant::Billing::CreditCard.new(
      :type       => card_type,
      :number     => number,
      :month      => exp_month,
      :year       => exp_year,
      :first_name => fname,
      :last_name  => lname
    )
#if creditcard.valid?

  # Create a gateway object to the Authorize.net service
  gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new( :login => '8GxD65y84',         #API Login ID
        :password => '89j6d34cW8CKhp9S')

  # Authorize for 10 dollars (1000 cents)
  response = gateway.authorize(amount, creditcard)

  if response.success?

    # Capture the money right away
    gateway.capture(amount, response.authorization)
    @result = "Success: " + response.message.to_s
    puts @result
  else
    raise StandardError, response.message
   
  end
#else
#   @result = "Credit card not valid: " + creditcard.validate.to_s
#    puts @result
#end
# require "ArbApiLib"
#
#    aReq = ArbApi.new
#    if ARGV.length < 3
#      puts "Usage: ArbApiSample.rb <url> <login> <txnkey> [<subscription name>]"
#      #exit
#    end
#    ARGV[0]= "https://api.authorize.net/xml/v1/request.api"
#    ARGV[1]= "8GxD65y84"
#    ARGV[2]= "89j6d34cW8CKhp9S"
#    #ARGV[1]= "cnpdev4289"
#    #ARGV[2]= "SR2P8g4jdEn7vFLQ"
#    #ARGV[3]= "644100"
#    
#    auth = MerchantAuthenticationType.new(ARGV[1], ARGV[2])
#    subname = ARGV.length > 3? ARGV[3]: "Subscription-001"
#    interval = IntervalType.new(1, "months")
#    schedule = PaymentScheduleType.new(interval, "2009-01-01",7, 0)
#    cinfo = CreditCardType.new("4111111111111111", "2012-07")
#    binfo = NameAndAddressType.new("john", "doe")
#    xmlout = aReq.CreateSubscription(auth,subname,schedule,10, 0, cinfo,binfo)
#
#    puts "Creating Subscription Name: " + subname
#    puts "Submitting to URL:" + ARGV[0]
#    xmlresp = HttpTransport.TransmitRequest(xmlout, ARGV[0])
#
#
#    apiresp = aReq.ProcessResponse(xmlresp)
#
#    if apiresp.success 
#      puts "Subscription Created successfully"
#      puts "Subscription id : " + apiresp.subscriptionid
#    else
#      puts "Subscription Creation Failed"
#      apiresp.messages.each { |message| 
#        puts "Error Code=" + message.code
#        puts "Error Message = " + message.text 
#      }
#    end
#
#    puts "\nXML Dump:" 
#    @xmldet= xmlresp
#    
#    
#    
hmm_user_det=HmmUser.find(params[:hmm_id])
 hmm_user_det[:street_address]=params[:street_address]
    hmm_user_det[:suburb]=params[:suburb]
    hmm_user_det[:postcode]=params[:postcode]
    hmm_user_det[:city]=params[:city]
    hmm_user_det[:state]=params[:state]
    hmm_user_det[:country]=params[:country]
    hmm_user_det[:telephone]=params[:telephone]
    hmm_user_det[:fax]=params[:fax]
    hmm_user_det.save
    
  redirect_to :controller => 'customers', :action => 'other_details', :message => @result, :id=>params[:hmm_id]
  
  
  end
end

