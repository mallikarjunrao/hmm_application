class Jangotest < ActionMailer::Base
  def load_settings
#    @@smtp_settings = {
#      :address        => "smtp.gmail.com",
#      :port           => "587",
#      :domain         => "admin@holdmymemories.com",
#      :authentication => :plain,
#      :user_name      => "admin@holdmymemories.com",
#      :password       => "softway09"
#    }

    @@smtp_settings = {
      :address => "relay.jangosmtp.net",
      :port => "25",
      :domain => "localhost.localdomain",
      :authentication => :plain,
      :user_name => "holdmymemories",
      :password => "hmmpine10"
    }
    
  end

  
  
  def testjango(name, fromemail, toemail)
    load_settings
    @recipients   = toemail
#    @from         = params[:contact][:email]
    @from         = fromemail
    headers         "Reply-to" => "#{@from}"
    @subject      = "test jango"
    @sent_on      = Time.now
    @content_type = "text/html"
    
    body[:name]  = name
    body[:email] = toemail
    
    
  end
  
  
end
