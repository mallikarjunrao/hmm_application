class Subscriber < ActiveRecord::Base
	
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email_address
  #validates_presence_of :address1
  #validates_presence_of :city
  #validates_presence_of :state
  #validates_presence_of :zip
  validates_format_of :email_address, :with => /\A([\w\.\-\+]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
		
		def email_with_name
			"#{self.first_name} #{self.last_name}<#{self.email}>"
		end
	
end
