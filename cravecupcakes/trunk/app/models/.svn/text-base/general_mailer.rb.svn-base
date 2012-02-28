class GeneralMailer < ActionMailer::Base

  def mailor(parms)
    from_address = DEFAULT_EMAIL
				if parms.key?(:from_email)
						from_address = parms.fetch(:from_email)
				end
				if parms.key?(:from_name)
						from_address = "#{parms.fetch(:from_name)}<#{from_address}>"
				end
						to_address = DEFAULT_EMAIL
				if parms.key?(:to_email)
						to_address = parms.fetch(:to_email)
				end
				if parms.key?(:to_name)
						to_address = "#{parms.fetch(:to_name)}<#{to_address}>"
				end
  
    @subject    =  parms.fetch(:subject)
    @body["message"] = parms.fetch(:message)
    @recipients = to_address
    @from       = from_address
    @headers = {
      "reply-to" => from_address
    }
  end
  
		
  def contact_form(from_name, from_email, subject, message)
    from_address = "#{from_name}<#{from_email}>"
  
    recipients      Owner.contact_emails
    subject         "Contact from beautybrands.com: " + subject 
    from            SERVER_EMAIL
    body["from"]= from_address
    body["subject"]= subject
    body["message"]= message
    headers = {
      "reply-to" => from_address
    }
  end
		
	def preorder( parms )
    recipients      parms[:super_admin_email]
    subject         "Order request from cravecupcakes.com" 
    from            parms[:super_admin_email]
    body["params"]= parms
    content_type "text/html"
    headers = {
      "reply-to" => "#{parms[:first_name]} #{parms[:last_name]}<#{parms[:email]}>"
    }
  end
		
	def order_received( parms )

      recipients      "#{parms[:first_name]} #{parms[:last_name]}<#{parms[:email]}>"
   
   
    subject         "Your order with cravecupcakes.com" 
    from            parms[:super_admin_email]
    body["params"]= parms
    content_type "text/html"
  end

  def order_received_admin_customer( parms )

      recipients      "#{parms[:first_name]} #{parms[:last_name]}<#{parms[:email]}>"


    subject         "Your order with cravecupcakes.com"
    from            parms[:super_admin_email]
    body["params"]= parms
    content_type "text/html"
  end

  def order_received_admin( parms )

   
       recipients      " <#{parms[:admin_email]}>"
  
    


    subject         "Your order with cravecupcakes.com"
    from            parms[:super_admin_email]
    body["params"]= parms
    content_type "text/html"
  end

end
