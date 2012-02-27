class ZipcodeController < ApplicationController
  wsdl_service_name 'Zipcode'
   wsdl_namespace 'http://www.softwaysolutions.com'
  require 'actionwebservice'

  web_service_api ZipcodeApi
  web_service_scaffold :invocation if Rails.env == 'development'

  def zipcode

  end
end
