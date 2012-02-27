class HellomessageApi < ActionWebService::API::Base

 api_method :hello_message, :expects => [{:firstname=>:string}, 
{:lastname=>:string}], :returns => [:string]


end
