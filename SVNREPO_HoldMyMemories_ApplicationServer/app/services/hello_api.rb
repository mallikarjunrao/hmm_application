class HelloApi < ActionWebService::API::Base
 api_method :getMsg, :expects => [:name=>:string], 
:returns => [:string]


end

