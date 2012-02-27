class HellomessageController < ApplicationController
  require 'actionwebservice'
require 'savon'
  wsdl_service_name 'Hellomessage'
  web_service_api HellomessageApi
# web_service_dispatching_mode :direct

  web_service_scaffold :invoke


  def hello_message(firstname, lastname)
    return "Hello "+ firstname +" "+lastname
  end

end
