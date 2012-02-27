class ZipcodeApi < ActionWebService::API::Base
  api_method :zipcode, :expects => [:string], :returns => [:string]
end
