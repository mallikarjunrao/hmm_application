class HelloadminController < ApplicationController
web_client_api :hello, :xmlrpc, "http://localhost:3000/hello/api"
web_client_api :item, :xmlrpc, "http://localhost:3000/item/api"

    def getMsg
  @service_output= hello.getMsg(params[:name])
  # @service_output1= item.add(params[:name],params[:phone])
  @item1=Item.find(params[:phone])

  
    end

    def getMsg1
       @item1=Item.find(params[:phone])
      respond_to do |f|
      f.xml  { render :xml => @item1.to_xml }
      end
    end
end
