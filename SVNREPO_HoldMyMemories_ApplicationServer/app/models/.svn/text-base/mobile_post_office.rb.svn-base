class MobilePostOffice < ActionMailer::Base

  def load_settings
    @@smtp_settings = {
      :address        => "smtp.gmail.com",
      :port           => "587",
      :domain         => "admin@holdmymemories.com",
      :authentication => :plain,
      :user_name      => "admin@holdmymemories.com",
      :password       => "softway09"
    }
  end
  
  def share_user_contents(from_name,from_email,to_email,link,image,domain='www')
    load_settings
    subject    "#{from_name} would like to share memories with you at HoldMyMemories.com"
    recipients to_email
    from       from_email
    content_type "text/html"
    #sent_on    sent_at
    body       :link => link,:image =>image,:from_name => from_name,:domain => domain
  end
end
