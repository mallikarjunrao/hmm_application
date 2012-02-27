# Before working with this sample code, please be sure to read the accompanying Readme.txt file.
# It contains important information regarding the appropriate use of and conditions for this
# sample code. Also, please pay particular attention to the comments included in each individual
# code file, as they will assist you in the unique and correct implementation of this code on
# your specific platform.
#
# Copyright 2007 Authorize.Net Corp.


# This is a Ruby script to create an ARB subscription using the ARB API.
# To run it you need Ruby 1.8.4, Builder 2.0.0 (Just type "gem install builder" to install the
# XML builder once you have Ruby).

# To test the sample just type "arbapisample.rb" The program just parses the XML response and
# prints a subscription ID if the create is successful or it displays an error code and error
# message.


require "ArbApiLib"

aReq = ArbApi.new
if ARGV.length < 3
   puts "Usage: ArbApiSample.rb <url> <login> <txnkey> [<subscription name>]"
   exit
end

auth = MerchantAuthenticationType.new(ARGV[1], ARGV[2])
subname = ARGV.length > 3? ARGV[3]: "Subscription-001"
interval = IntervalType.new(1, "months")
schedule = PaymentScheduleType.new(interval, "2007-04-01",7, 0)
cinfo = CreditCardType.new("4111111111111111", "2008-07")
binfo = NameAndAddressType.new("john", "doe")
xmlout = aReq.CreateSubscription(auth,subname,schedule,10, 0, cinfo,binfo)

puts "Creating Subscription Name: " + subname
puts "Submitting to URL:" + ARGV[0]
xmlresp = HttpTransport.TransmitRequest(xmlout, ARGV[0])


apiresp = aReq.ProcessResponse(xmlresp)

if apiresp.success 
   puts "Subscription Created successfully"
   puts "Subscription id : " + apiresp.subscriptionid
else
   puts "Subscription Creation Failed"
   apiresp.messages.each { |message| 
      puts "Error Code=" + message.code
      puts "Error Message = " + message.text 
   }
end

puts "\nXML Dump:" 
puts xmlresp

