class ItemController < ApplicationController
  require 'actionwebservice'
  
  wsdl_service_name 'Item'
  web_service_api ItemApi
  web_service_scaffold :invocation if Rails.env == 'development'


  def add(name, value)
    Item.create(:name => name, :value => value).id

  
  end


  def edit(id, name, value)
    Item.find(id).update_attributes(:name => name, :value => value)
  end


  def fetch(id)
#    client = Savon::Client.new("http://www.webservicex.net/uszip.asmx?WSDL")

    @item1=Item.find(id)
    Item.new(:id => "{@item1.id}", :value => "#{@item1.value}", :name => "#{@item1.name}")
  end

end

