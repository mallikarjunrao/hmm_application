class ManipulationController < ApplicationController


  wsdl_service_name 'Manipulation'
web_service_api ManipulationApi
 web_service_scaffold :invoke

 web_service_dispatching_mode :direct

  
  def manipulate
    return "Yeah! " + terms + "!"

  end

TWA_INVALID 				= "TWA_INVALID"
	USER_NOT_FOUND				= "USER_NOT_FOUND"
	USER_FOUND				= "USER_FOUND"

	def authenticate(twa, login, pass)
		user = User.authenticate(login,  pass)
		if user == nil then
			return USER_NOT_FOUND
  		else
  			return USER_FOUND
  		end
	end

   def add(name, value)
    Item.create(:name => name, :value => value).id
  end


  def edit(id, name, value)
    Item.find(id).update_attributes(:name => name, :value => value)
  end


  def fetch(id)
    @item1=Item.find(id)
    Item.new(:id => "{@item1.id}", :value => "#{@item1.value}", :name => "#{@item1.name}")
  end

end
