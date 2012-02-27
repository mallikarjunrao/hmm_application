class Postoffice < ActionMailer::Base
  
  def welcome(name, email,username,password,link,pass_req,pass)
    @recipients   = email
#    @from         = params[:contact][:email]
    @from         = "admin@holdmymemories.com"
    headers         "Reply-to" => "#{@from}"
    @subject      = "Thank you for registering with HoldMyMemories.com"
    @sent_on      = Time.now
    @content_type = "text/html"
    body[:link] = link
    body[:password_req] = pass_reqd
    body[:pass] = pass
    body[:name]  = name
    body[:email] = email   
    body[:username]  = username
    body[:password] = password   
    
  end
  
  def deliverpass(name, email,username,password)
     @recipients   = email
#    @from         = params[:contact][:email]
    @from         = "admin@holdmymemories.com"
    headers         "Reply-to" => "#{@from}"
    @subject      = "HoldMyMemories.com password request."
    @sent_on      = Time.now
    @content_type = "text/html"
    
    body[:name]  = name
    body[:email] = email   
    body[:username]  = username
    body[:password] = password
  end
  
  def friend(friend_id,frined_name, friend_email,friend_username,pass,my_id,my_name,my_email,my_image,my_gender)
     @recipients   = friend_email
#    @from         = params[:contact][:email]
    @from         = my_name+"<#{my_email}>"
    headers         "Reply-to" => "#{@from}"
    @subject      = "HoldMyMemories.com - "+my_name+" has sent you a friend request."
    @sent_on      = Time.now 
    @content_type = "text/html"
    body[:friend_id]=friend_id
    body[:my_id]=my_id
    body[:friend_name]  = frined_name
    body[:friend_email] = friend_email  
     body[:friend_username]  = friend_username
    body[:pass] = pass
    body[:my_name]  = my_name
    body[:my_image] = my_image
    if(my_gender=='M')
     body[:my_gender]='his'
    else
     body[:my_gender]='her' 
    end
  end
  
   def comment(comment,journal,type,cmtfrom_fname,cmtfrom_email,cmtto_fname,cmtto_email,myimage)
    @recipients   = cmtto_email
    @from         = cmtfrom_email
    headers         "Reply-to" => "#{@from}"
    @subject      = "You have received a comment at HoldMyMemories.com"
    @sent_on      = Time.now
    @content_type = "text/html"
    body[:message]=comment
    body[:from_email]=cmtfrom_email
    body[:from_name]=cmtfrom_fname
    body[:to_email]=cmtto_email
    body[:to_name]=cmtto_fname
    body[:type]="Chapter"
    body[:journal]=journal
    body[:MyImage]=myimage
 end
 
 def shareJournalhmm(to_email,message,journal,from_user,from_email,from_image)
     @recipients   = to_email
     @from         = "#{from_email}"
     headers         "Reply-to" => "#{@from}"
     @subject      = "You have received a Journal Share at HoldMyMemories.com"
     @sent_on      = Time.now
     @content_type = "text/html"
     body[:message]=message
     body[:from_email]=from_email
     body[:from_name]=from_user
     body[:to_email]=to_email
     body[:type]="Journal Share"
     body[:MyImage]=from_image
     
  end
  
  def shareMomenthmm(to_email,message,from_user,from_email,from_image)
    @recipients   = to_email
     @from         = from_user+"<#{from_email}>"
     headers         "Reply-to" => "#{@from}"
     @subject      = "You have received a Share Moment at HoldMyMemories.com"
     @sent_on      = Time.now
     @content_type = "text/html"
     body[:message]=message
     body[:from_email]=from_email
     body[:from_name]=from_user
     body[:to_email]=to_email
     body[:type]="Moment Share"
     body[:MyImage]=from_image
  end
 
   def shareJournal(to_email,message,journal,from_user,from_email,from_image,id,unid)
     @recipients   = to_email
     @from         = from_email
     headers         "Reply-to" => "#{@from}"
     @subject      = "You have received a Journal Share at HoldMyMemories.com"
     @sent_on      = Time.now
     @content_type = "text/html"
     body[:message]=message
     body[:from_email]=from_email
     body[:from_name]=from_user
     body[:to_email]=to_email
     body[:type]="Journal Share"
     body[:MyImage]=from_image
     body[:id]=id
     body[:unid]=unid
  end
  
  def shareMoment(to_email,message,from_user,from_email,from_image,id,unid)
     @recipients   = to_email
     @from         = from_email
     @from         = from_user+"<#{from_email}>"
     @from_email = "#{@from}"   
     headers         "Reply-to" => "#{@from}"
     @subject      = "You have received a shared moment at HoldMyMemories.com"
     @sent_on      = Time.now
     @content_type = "text/html"
     body[:message]=message
     body[:from_email]=from_email
     body[:from_name]=from_user
     body[:to_email]=to_email
     body[:type]="Moment Share"
     body[:MyImage]=from_image
     body[:id]=id
     body[:unid]=unid
  end
 
  def subchapComment(comment,journal,type,cmtfrom_fname,cmtfrom_email,cmtto_fname,cmtto_email,myimage)
    @recipients   = cmtto_email
    @from         = cmtfrom_email
    headers         "Reply-to" => "#{@from}"
    @subject      = "You have received a comment at HoldMyMemories.com"
    @sent_on      = Time.now
    @content_type = "text/html"
    body[:message]=comment
    body[:from_email]=cmtfrom_email
    body[:from_name]=cmtfrom_fname
    body[:to_email]=cmtto_email
    body[:to_name]=cmtto_fname
    body[:type]="Sub-Chapter"
    body[:journal]=journal
     body[:MyImage]=myimage
  end
  
  def galleryComment(comment,journal,type,cmtfrom_fname,cmtfrom_email,cmtto_fname,cmtto_email,myimage)
    @recipients   = cmtto_email
    @from         = cmtfrom_email
    headers         "Reply-to" => "#{@from}"
    @subject      = "You have received a comment at HoldMyMemories.com"
    @sent_on      = Time.now
    @content_type = "text/html"
    body[:message]=comment
    body[:from_email]=cmtfrom_email
    body[:from_name]=cmtfrom_fname
    body[:to_email]=cmtto_email
    body[:to_name]=cmtto_fname
    body[:type]="Gallery"
    body[:journal]=journal
     body[:MyImage]=myimage
 end
 
 def tipsideas(title,desc,from_name,from_email,myimage)
    @recipients   = "bob@s121.com"
#    @from         = params[:contact][:email]
    @from         = "#{from_name}<#{from_email}>"
    headers         "Reply-to" => "#{@from}"
    @subject      = "Tips Section Views and Ideas!!"
    @sent_on      = Time.now
    @content_type = "text/html"
    body[:myimage]=myimage
    body[:from_name] = from_name
    body[:from_email] = from_email 
    body[:title] = title
    body[:desc] = desc
 end
 
 def usercontentComment(comment,journal,type,cmtfrom_fname,cmtfrom_email,cmtto_fname,cmtto_email,myimage)
    @recipients   = cmtto_email
    @from         = cmtfrom_email
    headers         "Reply-to" => "#{@from}"
    @subject      = "You have received a comment at HoldMyMemories.com"
    @sent_on      = Time.now
    @content_type = "text/html"
    body[:message]=comment
    body[:from_email]=cmtfrom_email
    body[:from_name]=cmtfrom_fname
    body[:to_email]=cmtto_email
    body[:to_name]=cmtto_fname
    body[:type]="Moment"
    body[:journal]=journal
    
    body[:MyImage]=myimage
  end
  
def share(frined_name, friend_email,my_name,my_email,my_image,my_username,my_password,shareid, message)
     @recipients   = friend_email
#    @from         = params[:contact][:email]
    @from         = my_name+"<#{my_email}>"
    headers         "Reply-to" => "#{@from}"
    @subject      = "HoldMyMemories.com - "+my_name+" wants to share memories with you!"
    @sent_on      = Time.now 
    @content_type = "text/html"
    
    body[:friend_name]  = frined_name
    body[:friend_email] = friend_email  
    body[:my_name]  = my_name
    body[:my_image] = my_image
    body[:my_username] = my_username
    body[:my_password] = my_password
    body[:shareid] = shareid
    body[:message] = message
  end
  
  
  def export(my_name,friend_email,my_image,exportid, message,myemail)
     @recipients   = friend_email
#    @from         = params[:contact][:email]
    @from         = my_name+"<#{myemail}>"
    headers         "Reply-to" => "#{@from}"
    @subject      = "HoldMyMemories.com - "+my_name+" want to share memories with you!"
    @sent_on      = Time.now 
    @content_type = "text/html"
    
    
    #body[:friend_email] = friend_email  
    body[:my_name]  = my_name
    body[:my_image] = my_image
   
    body[:exportid] = exportid
    body[:message] = message
  end
  
  
  
  
  
  def shareunknown(friend_email,my_name,my_email,my_image,shareid, message,pass,shareunid)
     @recipients   = friend_email
#    @from         = params[:contact][:email]
    @from         = my_name+"<#{my_email}>"
    headers         "Reply-to" => "#{@from}"
    @subject      = "HoldMyMemories.com - "+my_name+" want to share memories with you!"
    @sent_on      = Time.now 
    @content_type = "text/html"
    
   
   body[:shareunid] = shareunid
    body[:friend_email] = friend_email 
    body[:password]=pass
    body[:my_name]  = my_name
    body[:my_image] = my_image
    body[:shareid]=shareid
    body[:message] = message
  end
  
  def feedback(name, email,comment)
    @recipients   = "farooq@softwaysolutions.com,alok@hysistechnologies.com"
#    @from         = params[:contact][:email]
    @from         = "#{name}<#{email}>"
    headers         "Reply-to" => "#{@from}"
    @subject      = "Bug reported by the user on HoldMyMemories.com"
    @sent_on      = Time.now
    @content_type = "text/html"
    
    body[:name]  = name
    body[:email] = email   
    body[:comment]  = comment
   
    
  end
  
  def thankyou(name, email,comment)
    @recipients   = email
#    @from         = params[:contact][:email]
    @from         = "admin@holdmymemories.com"
    headers         "Reply-to" => "#{@from}"
    @subject      = "HoldMyMemories.com - Thank you for your feedback."
    @sent_on      = Time.now
    @content_type = "text/html"
    
    body[:name]  = name
    body[:email] = email   
    body[:comment]  = comment
   
    
  end
  
  def invite(invitee,invitee_email, email)
    @recipients   = email
#    @from         = params[:contact][:email]
    @from         = invitee_email
    headers         "Reply-to" => "#{@from}"
    @subject      = "HoldMyMemories.com"
    @sent_on      = Time.now
    @content_type = "text/html"
    
    body[:invitee]  = invitee
    body[:invitee_email]  = invitee_email
    body[:email] = email   
    #body[:comment]  = comment
   
    
  end
  
  def contactUsreport(name,subject,message,country,email)
    @recipients = "Bob.Eveleth@S121.com"
    @from = email
    @subject = subject
    @sent_on = Time.now
    @content_type = "text/html"
    body[:name] = name
    body[:email] = email 
    body[:country] = country
    body[:subject] = subject
    body[:message] = message
    
  end
  
  def contactUsreport1(name,subject,message,country,email,branch,employeename,customer_name,account_type)
    @recipients = "Bob.Eveleth@S121.com"
    @from = email
    @subject = subject
    @sent_on = Time.now
    @content_type = "text/html"
    body[:name] = name
    body[:email] = email 
    body[:country] = country
    body[:subject] = subject
    body[:message] = message
    body[:branch] = branch
    body[:employeename] = employeename
    body[:customer_name] = customer_name
    body[:account_type] = account_type
    
    
  end
  
  def shareFamilypages(i,sender_name,sender_email,link,reciepent_message,sha_type,pass)
#   puts sha_type
#   puts "1234"
    @recipients = i
    @from_email = sender_email
    @from_name = sender_name
    @reciepent_message=reciepent_message
    @from         = sender_name+"<#{sender_email}>"
    headers         "Reply-to" => "#{@from}"
    @subject = "HoldMyMemories Family Website Share"
    @sent_on = Time.now
    @content_type = "text/html"
    body[:from_name] = sender_name
    body[:from_email] = sender_email 
    body[:subject] = subject
    body[:link] = link
    body[:reciepent_message]=reciepent_message
    body[:sha_type]=sha_type
    body[:password] = pass
  end
  
  def send_sitedetails(link,pass_req,pass,recipent,message)
    @recipients = recipent
    @from_email = "admin@holdmymemories.com"
    @from_name = "HoldMyMemories Family Website"
    @subject = "HoldMyMemories Family Website Details"
    @from = "HoldMyMemories Family Website"+"<admin@holdmymemories.com>"
    headers         "Reply-to" => "#{@from}"
    @sent_on = Time.now
    @content_type = "text/html"
    body[:from_name] = "HoldMyMemories.com team"
    body[:from_email] = "admin@holdmymemories.com"
    body[:subject] = subject
    body[:link] = "http://www.HoldMyMemories.com/"+link
    body[:password_req] = pass_req
    body[:password] = pass
    body[:message] = message
  end
 
  def shareFamilywebsite(share_to,message,share_link,sender_name,sender_email,sender_myimage,password)
    @recipients = share_to
    @from_email = sender_email
    @from_name = sender_name
    @from         = sender_name+"<#{sender_email}>"
    headers         "Reply-to" => "#{@from}"
    @subject = "HoldMyMemories Familywebsite Share"
    @sent_on = Time.now
    @content_type = "text/html"
    body[:from_name] = sender_name
    body[:from_email] = sender_email 
    body[:subject] = subject
    body[:my_image] = sender_myimage
    body[:link] = share_link
    body[:password] = password
    body[:message] = message
  end
  
  def voteconform(email,contestid,unid,filename,entrant_name,userfname,userlname)
    @recipients = email
    @from_email = "admin@holdmymemories.com"
    @from_name = "HoldMyMemories Contest"
    @subject = "HoldMyMemories vote confirm mail"
    @from = "HoldMyMemories Contest"+"<admin@holdmymemories.com>"
    body[:unid] = unid
    body[:filename] = filename
    body[:fname] = entrant_name
    body[:userfname] = userfname
    body[:userlname] = userlname
  end
  
  def rapidreg(name, email,username,password,link,pass_req,pass,unid)
    @recipients   = email
#    @from         = params[:contact][:email]
    @from         = "admin@holdmymemories.com"
    headers         "Reply-to" => "#{@from}"
    @subject      = "Thank you for registering with HoldMyMemories.com"
    @sent_on      = Time.now
    @content_type = "text/html"
    body[:link] = link
    body[:password_req] = pass_req
    body[:pass] = pass
    body[:name]  = name
    body[:email] = email   
    body[:username]  = username
    body[:password] = password  
  end
  
  
   def farooqtest()
    @recipients = "see.farooq@gmail.com"
    @from_email = "farooq@softwaysolutions.com"
    @from_name = "Farooq Kuntoji"
    @from = "Farooq Kuntoji" +"farooq@softwaysolutions.com"
    headers "Reply-to" => "#{@from}"
    @subject = "HoldMyMemories email test "
    @sent_on = Time.now
    @content_type = "text/html"
  end
  
   def paymentsucess(customer_name , v_e_mail , v_user_name, account_type, account_expdate,months,amount,street_address, city, state ,postcode, country,telephone,invoicenumber,subnumber, username, password1, link,pass_req,pass)
     @recipients = v_e_mail
    @from= "admin@holdmymemories.com"
    @subject      = "Thank you for your subscription  for #{account_type} account on HoldMyMemories.com"
    @sent_on      = Time.now
    @content_type = "text/html"
     body[:customer_name] = customer_name
     body[:v_user_name] = v_user_name
    body[:v_e_mail] = v_e_mail
    
    body[:account_type]  = account_type
   
    body[:account_expdate]  = account_expdate
    body[:months] = months  
    body[:amount] = amount 
    body[:street_address] = street_address
    body[:city] = city
    body[:state] = state
    body[:postcode] = postcode
    body[:telephone] = telephone
    body[:invoicenumber] = invoicenumber
    body[:country] = country
    body[:subnumber] = subnumber
    body[:username] = username
    body[:password1] = password1
    body[:link] = link
    body[:pass_req] = pass_req
    body[:pass] = pass
    
   end
   
   def paymentdeclained(customer_name , v_e_mail , v_user_name, invoicenumber, account_type,months,amount,subscriptionnumber,substatus)
      @recipients = v_e_mail
      @from= "admin@holdmymemories.com"
      if account_type == "platinum_user"
        acctype="Premium User Account"
      else  
        acctype="Family Website User Account"
      end
      @subject      = "Your subscription  for #{acctype} on HoldMyMemories.com has been declined"
      @sent_on      = Time.now
      @content_type = "text/html"
      body[:customer_name] = customer_name
      body[:v_user_name] = v_user_name
      body[:invoicenumber] = invoicenumber
      body[:account_type] = account_type
      body[:months] = months
      body[:amount] = amount
      body[:subscriptionnumber] = subscriptionnumber
      body[:substatus] = substatus
   end
   
   def paymentsucessupdate(customer_name , v_e_mail , v_user_name, account_type, account_expdate,months,amount,street_address, city, state ,postcode, country,telephone,invoicenumber,subnumber, username, password1, link,pass_req,pass)
     @recipients = v_e_mail
      @from= "admin@holdmymemories.com"
      @subject      = "Thank you for your subscription  for #{account_type} account on HoldMyMemories.com"
      @sent_on      = Time.now
      @content_type = "text/html"
      body[:customer_name] = customer_name
      body[:v_user_name] = v_user_name
      body[:v_e_mail] = v_e_mail
      body[:account_type]  = account_type
      body[:account_expdate]  = account_expdate
      body[:months] = months  
      body[:amount] = amount 
      body[:street_address] = street_address
      body[:city] = city
      body[:state] = state
      body[:postcode] = postcode
      body[:telephone] = telephone
      body[:invoicenumber] = invoicenumber
      body[:country] = country
      body[:subnumber] = subnumber
      body[:username] = username
      body[:password1] = password1
      body[:link] = link
      body[:pass_req] = pass_req
      body[:pass] = pass
    
   end
   
    def cancellation_request(store_employee_name, store_employee_email,v_fname,v_lname,v_e_mail,account_type,amount,subscriptionnumber,invoicenumber,street_address,postcode,city,state,country,telephone,reason)
      @recipients = store_employee_email
      @from= "#{v_e_mail}"
      @from_email = "#{v_e_mail}"
    @from_name = v_fname
    @from = "#{@from_name}" +"#{@from_email}"
      @subject      = "Request for the cancellation of subscription sent by  #{v_fname} #{v_lname}"
      @sent_on      = Time.now
      @content_type = "text/html"
      body[:v_fname] = v_fname
      body[:v_lname] = v_lname
      body[:v_e_mail] = v_e_mail
      body[:account_type]  = account_type
      body[:amount] = amount 
      body[:street_address] = street_address
      body[:city] = city
      body[:state] = state
      body[:postcode] = postcode
      body[:telephone] = telephone
      body[:invoicenumber] = invoicenumber
      body[:country] = country
      body[:subscriptionnumber] = subscriptionnumber
      
      body[:reason] = reason
      
    end
    
    def cancellation_request_response(store_employee_email,v_fname,v_lname,v_e_mail,account_type,amount,subscriptionnumber,invoicenumber)
      @recipients = v_e_mail
      @from= "admin@holdmymemories.com"
      @subject      = "Your Request for the cancellation of your subscription has been sent to HoldMyMemories.com"
      @sent_on      = Time.now
      @content_type = "text/html"
      body[:v_fname] = v_fname
      body[:v_lname] = v_lname
      body[:v_e_mail] = v_e_mail
      body[:account_type]  = account_type
      body[:amount] = amount
      body[:invoicenumber] = invoicenumber
      body[:subscriptionnumber] = subscriptionnumber
      body[:store_employee_email]=store_employee_email
    end
    
    def cancellation_request_complete(store_employee_email,v_fname,v_lname,v_e_mail,account_type,amount,subscriptionnumber,invoicenumber, pass, username)
      @recipients = v_e_mail
      @from= "admin@holdmymemories.com"
      @subject      = "Your Request for the cancellation of your subscription has been sent to HoldMyMemories.com"
      @sent_on      = Time.now
      @content_type = "text/html"
      body[:v_fname] = v_fname
      body[:v_lname] = v_lname
      body[:v_e_mail] = v_e_mail
      body[:account_type]  = account_type
      body[:amount] = amount
      body[:invoicenumber] = invoicenumber
      body[:subscriptionnumber] = subscriptionnumber
      body[:store_employee_email]=store_employee_email
      body[:pass] = pass
      body[:username] = username
    end
   
   def contest_entrymail(entrant_name,video_thumb,username,userfname,useremail)
    @recipients = "Bob.Eveleth@S121.com"
    @from = "admin@holdmymemories.com"
    @subject = "Contest Entry Notification"
    @sent_on = Time.now
    @content_type = "text/html"
    body[:fname] = userfname
    body[:email] = useremail 
    body[:entrant_name] = entrant_name
    body[:video_thumb] = video_thumb
    body[:user_name] = username
    
  end
  
  def votereq_mail(res_emails,vote_url,message)
    @recipients = res_emails
    @from = "admin@holdmymemories.com"
    @subject = "Contest Entry Vote Request!!"
    @sent_on = Time.now
    @content_type = "text/html"
    
    body[:vote_url] = vote_url
    body[:message] = message
    
  end
  
end
