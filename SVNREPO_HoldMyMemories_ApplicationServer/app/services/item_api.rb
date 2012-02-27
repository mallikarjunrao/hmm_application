class ItemApi < ActionWebService::API::Base


api_method :add, :expects => [:string, :string], :returns => [:int]
    api_method :edit, :expects => [:int, :string, :string], :returns => [:bool]
    api_method :fetch, :expects => [:int], :returns => [Item]

end
