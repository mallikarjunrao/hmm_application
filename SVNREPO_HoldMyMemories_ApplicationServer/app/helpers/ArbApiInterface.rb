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


class MerchantAuthenticationType
attr_writer :name, :transactionKey
attr_reader :name, :transactionKey
def initialize(name, transactionKey)
	@name = name
	@transactionKey = transactionKey
end
end

class NameAndAddressType 
attr_reader :firstName,:lastName,:company,:address,:city,:state,:zip,:country,:email,:phone
attr_writer :firstName,:lastName,:company,:address,:city,:state,:zip,:country,:email,:phone
def initialize(firstName, lastName, company, address, city, state, zip, country, email, phone)
	@firstName = firstName
	@lastName = lastName
	@company = company
	@address = address
	@city = city
	@state = state
	@zip = zip
	@country = country
	@email = email
	@phone = phone
end
end

class IntervalType 
attr_reader :length,:unit
attr_writer :length,:unit
def initialize(length, unit)
	@length = length
	@unit = unit
end
end

class PaymentScheduleType 
attr_reader :interval,:startDate,:totalOccurrences,:trialOccurrences
attr_writer :interval,:startDate,:totalOccurrences,:trialOccurrences
def initialize(interval, startDate, totalOccurrences, trialOccurrences)
	@interval = interval
	@startDate = startDate
	@totalOccurrences = totalOccurrences
	@trialOccurrences = trialOccurrences
end
end

class CreditCardType 
attr_reader :cardNumber,:expirationDate,:cardCode
attr_writer :cardNumber,:expirationDate,:cardCode
def initialize(cardNumber, expirationDate, cardCode)
	@cardCode = cardCode
	@cardNumber = cardNumber
	@expirationDate = expirationDate
end
end

class Payment 
attr_accessor :creditcard
def initialize(creditcard)
	@creditcard = creditcard
end
end

class ARBSubscriptionType 
attr_accessor :name, :paymentschedule, :amount, :trialamount, :payment, :billTo, :shipTo
def initalize(name, paymentschedule, amount, trialamount, payment, billTo, shipTo)
	@name = name
	@paymentschedule = paymentschedule
	@amount = amount
	@trialamount = trialamount
	@payment = payment
	@billTo = billTo
	@shipTo = shipTo
end
end

class ResponseMessage
attr_accessor :code, :text
end

class ApiResponse
attr_accessor :success, :messages
end

class CreateSubscriptionResponse < ApiResponse
attr_accessor :subscriptionid
end

class ErrorResponse < ApiResponse
end




