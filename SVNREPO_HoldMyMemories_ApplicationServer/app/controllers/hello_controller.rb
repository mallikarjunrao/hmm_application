class HelloController < ApplicationController
  require 'actionwebservice'

wsdl_service_name 'Hello'

web_service_api HelloApi
web_service_scaffold :invoke


  def getMsg(name)

 
"Hello "+ name
 end

end
