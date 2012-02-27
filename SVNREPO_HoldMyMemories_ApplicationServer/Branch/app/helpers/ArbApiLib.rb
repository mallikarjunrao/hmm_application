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


require 'ArbApiInterface'
require 'builder'
require 'net/https'
require 'rexml/document'

class ArbApi
def CreateSubscription(auth,subname, payschedule, amount, trialamount,creditcardinfo, billToinfo,interval,invoicenumber)

x = Builder::XmlMarkup.new(:target=>@xmlout)

x.instruct! :xml, :version => "1.0", :encoding => "US-ASCII"


x.ARBCreateSubscriptionRequest("xmlns" =>"AnetApi/xml/v1/schema/AnetApiSchema.xsd") {
 x.merchantAuthentication  {
    x.name auth.name
    x.transactionKey auth.transactionKey
  }
  x.subscription {
    x.name subname
    x.paymentSchedule {
      x.interval {
        x.length interval.length
        x.unit interval.unit
      }
      x.startDate payschedule.startDate
      x.totalOccurrences payschedule.totalOccurrences
      x.trialOccurrences payschedule.trialOccurrences
      
    }
    x.amount amount
    x.trialAmount trialamount
    
      x.payment {
      
      x.creditCard {
        x.cardNumber creditcardinfo.cardNumber
        x.expirationDate creditcardinfo.expirationDate
         x.cardCode creditcardinfo.cardCode
         
      }
     
    }
    
      x.order{
        x.invoiceNumber invoicenumber
        x.description "HoldMyMemories.com New Account Creation"
      }  
      
    x.customer{
      x.email billToinfo.email
      x.phoneNumber billToinfo.phone
      
      
        
    }
    x.billTo {
      x.firstName billToinfo.firstName
      x.lastName  billToinfo.lastName
      x.company  billToinfo.company
      x.address  billToinfo.address
      x.city  billToinfo.city
      x.state  billToinfo.state
      x.zip  billToinfo.zip
      x.country  billToinfo.country
      
      
    }
    
    x.shipTo {
     x.firstName billToinfo.firstName
      x.lastName  billToinfo.lastName
      x.company  billToinfo.company
      x.address  billToinfo.address
      x.city  billToinfo.city
      x.state  billToinfo.state
      x.zip  billToinfo.zip
      x.country  billToinfo.country
      
      
    }
    
   
  }
  
}
# Puts x.target!
return x.target!
end


def CalcelSubscription(auth,subnumber)

  x = Builder::XmlMarkup.new(:target=>@xmlout)

  x.instruct! :xml, :version => "1.0", :encoding => "US-ASCII"


  x.ARBCancelSubscriptionRequest('xmlns' => "AnetApi/xml/v1/schema/AnetApiSchema.xsd") {
   x.merchantAuthentication  {
      x.name auth.name
      x.transactionKey auth.transactionKey
    }
    x.subscriptionId subnumber
   }
  # Puts x.target!
  return x.target!
  
end




def ProcessResponse(xmlresp)

xmldoc = REXML::Document.new xmlresp

root = xmldoc.root

unless root.elements["messages/resultCode"].text == "Ok"
   ProcessErrorResponse root.elements["messages"]
else
   ProcessCreateSubscriptionResponseSuccess root
end

end


def ProcessResponse1(xmlresp)

xmldoc = REXML::Document.new xmlresp

root = xmldoc.root

  require 'pp'
  pp root.elements
  
unless root.elements["messages"].text == "Ok"
   ProcessErrorResponse root.elements["messages"]
else
   ProcessCancelSubscriptionResponseSuccess root
end

end


def ProcessCancelSubscriptionResponseSuccess(root)

   resp = CreateSubscriptionResponse.new
   
   resp.success = true
   resp.subscriptionid = root.elements["subscriptionId"].text
   
   return resp

end


def ProcessCreateSubscriptionResponseSuccess(root)

   resp = CreateSubscriptionResponse.new
   
   resp.success = true
   resp.subscriptionid = root.elements["subscriptionId"].text
   
   return resp

end

def ProcessErrorResponse(messages)

   resp = ErrorResponse.new
   msgarray = Array.new
   
   messages.elements.each("message") { | message |  
         msg = ResponseMessage.new
         msg.code = message.elements["code"].text
         msg.text = message.elements["text"].text
         msgarray << msg
   }
   
   resp.success = false
   resp.messages = msgarray
   
   return resp
   
end

end

class HttpTransport

def HttpTransport.TransmitRequest(xml,targeturl)

url = URI.parse(targeturl)
    req = Net::HTTP::Post.new(url.path)
    req.body = xml
    
    req.content_type='text/xml'
    ht = Net::HTTP.new(url.host, url.port)
    ht.use_ssl = true if url.scheme == "https"
    res = ht.start {|http| http.request(req) }
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      # OK
    else
      res.error!
    end


return res.body
end

end


