class Emergencymailer < ActionMailer::Base
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
      :port => "2525",
      :domain => "localhost.localdomain",
      :authentication => :plain,
      :user_name => "holdmymemories",
      :password => "hmmpine10"
    }
  end

  def welcome(name, email,username,password,link,pass_req,pass)
    load_settings
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
    load_settings
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
    @subject      = "#{my_name} has sent you a friend request at HoldMyMemories.com!"
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
    load_settings
    @recipients   = cmtto_email
    @from         = "#{cmtfrom_fname}<YouHaveAComment@HoldMyMemories.com>"
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
    load_settings
    @recipients   = to_email
    @from         = from_email
    headers         "Reply-to" => "#{@from}"
    @subject      = "#{from_user} would like to share a memory with you at HoldMyMemories.com"
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
    load_settings
    @recipients   = to_email
    @from         = from_user+"<#{from_email}>"
    headers         "Reply-to" => "#{@from}"
    @subject      = "#{from_user} would like to share a memory with you at HoldMyMemories.com"
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
    load_settings
    @recipients   = to_email
    @from         = from_email
    headers         "Reply-to" => "#{@from}"
    @subject      = "#{from_user} would like to share a memory with you at HoldMyMemories.com"
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
    load_settings
    @recipients   = to_email
    @from         = from_email
    @from         = from_user+"<#{from_email}>"
    @from_email = "#{@from}"
    headers         "Reply-to" => "#{@from}"
    @subject      = "#{from_user} wants to share memories with you at HoldMyMemories.com!"
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
    load_settings
    @recipients   = cmtto_email
    @from         = "#{cmtfrom_fname}<YouHaveAComment@HoldMyMemories.com>"
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
    load_settings
    @recipients   = cmtto_email
    @from         = "#{cmtfrom_fname}<YouHaveAComment@HoldMyMemories.com>"
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
    load_settings
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
    load_settings
    @recipients   = cmtto_email
    @from         = "#{cmtfrom_fname}<YouHaveAComment@HoldMyMemories.com>"
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
    load_settings
    @recipients   = friend_email
    #    @from         = params[:contact][:email]
    @from         = my_name+"<#{my_email}>"
    headers         "Reply-to" => "#{@from}"
    @subject      = "#{my_name} wants to share memories with you at HoldMyMemories.com!"
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
    load_settings
    @recipients   = friend_email
    #    @from         = params[:contact][:email]
    @from         = my_name+"<#{myemail}>"
    headers         "Reply-to" => "#{@from}"
    @subject      = "#{my_name} wants to share memories with you at HoldMyMemories.com!"
    @sent_on      = Time.now
    @content_type = "text/html"


    #body[:friend_email] = friend_email
    body[:my_name]  = my_name
    body[:my_image] = my_image

    body[:exportid] = exportid
    body[:message] = message
  end





  def shareunknown(friend_email,my_name,my_email,my_image,shareid, message,pass,shareunid)
    load_settings
    @recipients   = friend_email
    #   @from         = params[:contact][:email]
    @from         = my_name+"<#{my_email}>"
    headers         "Reply-to" => "#{@from}"
    @subject      = "#{my_name} wants to share memories with you at HoldMyMemories.com!"
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
   
    load_settings
    @recipients   = "farooq@softwaysolutions.com,shrikanth.hathwar@hysistechnologies.com,seth.johnson@s121.com"
    #   @from         = params[:contact][:email]
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
    load_settings
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
    load_settings
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

  def invite2(invitee,invitee_email,email,password,family_name)
    load_settings
    @recipients   = email
    #    @from         = params[:contact][:email]
    @from         = invitee_email
    headers         "Reply-to" => "#{@from}"
    @subject      = "HoldMyMemories.com"
    @sent_on      = Time.now
    @content_type = "text/html"

    body[:invitee]  = invitee
    body[:invitee_email]  = invitee_email
    body[:password]=password
    body[:family_name]=family_name
    body[:email] =email
    #body[:comment]  = comment


  end

  def contactUsreport(website_email,name,subject,message,country,email)
    load_settings
    @recipients = website_email
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

  def contactUsreportmysite(name,subject,message,country,email,recepient_email)
    load_settings
    @recipients = recepient_email
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
    load_settings
    @recipients = "Bob.Eveleth@S121.com,Rachel.Allen@S121.com,Pam@S121.com,customerservice@holdmymemories.com,dan.quinlan@holdmymemories.com"
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

  def shareFamilypages(i,sender_name,sender_email,link,reciepent_message,sha_type,pass,messageboard_link,family_img,content_url)
    load_settings
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
    body[:messageboard_link] = messageboard_link
    body[:family_img] = family_img
    body[:content_url] = content_url
  end

  def send_sitedetails(link,pass_req,pass,recipent,message)
    load_settings
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
    body[:link] = "http://www.holdmymemories.com/"+link
    body[:password_req] = pass_req
    body[:password] = pass
    body[:message] = message

  end

  def shareFamilywebsite(share_to,message,share_link,sender_name,sender_email,sender_myimage,password,messageboard_link)
    load_settings
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
    body[:messageboard_link] = messageboard_link
  end

  def voteconform(email,contestid,unid,filename,entrant_name,userfname,userlname,moment_type)
    load_settings
    @recipients = email
    @from_email = "admin@holdmymemories.com"
    @from_name = "HoldMyMemories Contest"
    @subject = "HoldMyMemories.com vote confirmation email"
    @from = "HoldMyMemories Contest"+"<admin@holdmymemories.com>"
    body[:unid] = unid
    body[:email] = email
    body[:filename] = filename
    body[:fname] = entrant_name
    body[:userfname] = userfname
    body[:userlname] = userlname
    body[:moment_type] = moment_type
  end

  def hmmvoteconform(email,contestid,unid,filename,entrant_name,userfname,userlname,moment_type)
    load_settings
    @recipients = email
    @from_email = "admin@holdmymemories.com"
    @from_name = "HoldMyMemories Contest"
    @subject = "HoldMyMemories.com vote confirmation email"
    @from = "HoldMyMemories Contest"+"<admin@holdmymemories.com>"
    body[:unid] = unid
    body[:filename] = filename
    body[:fname] = entrant_name
    body[:userfname] = userfname
    body[:userlname] = userlname
    body[:moment_type] = moment_type
  end

  def rapidreg(name, email,username,password,link,pass_req,pass,unid)
    load_settings
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
    load_settings
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
    load_settings
    @recipients = v_e_mail
    @from= "admin@holdmymemories.com"
    @subject      = "Thank-you for your subscription to HoldMyMemories.com"
    @sent_on      = Time.now
    @content_type = "text/html"
    if account_type == "platinum_user"
      account_type="Premium"
    else
      account_type="Family Website"
    end
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
    load_settings
    @recipients = v_e_mail
    @from= "admin@holdmymemories.com"
    if account_type == "platinum_user"
      acctype="Premium Account"
    else
      acctype="Family Website Account"
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
    load_settings
    @recipients = v_e_mail
    @from= "admin@holdmymemories.com"
    @subject      = "Thank-you for your subscription to HoldMyMemories.com"
    @sent_on      = Time.now
    @content_type = "text/html"
    if account_type == "platinum_user"
      account_type="Premium"
    else
      account_type="Family Website"
    end
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
    load_settings
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

  def cancellation_request_response(store_employee_email,v_fname,v_lname,v_e_mail,account_type,amount,subscriptionnumber,invoicenumber,family_pic,no_of_days,img_url)
    load_settings
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
    body[:family_pic]=family_pic
    body[:no_of_days]=no_of_days
    body[:img_url]=img_url
  end

  def cancellation_request_complete(store_employee_email,v_fname,v_lname,v_e_mail,account_type,amount,subscriptionnumber,invoicenumber, pass, username)
    load_settings
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
    load_settings
    @recipients = "Bob.Eveleth@S121.com,Dan.Quinlan@holdmymemories.com,customerservice@holdmymemories.com"
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

  def votereq_mail(res_emails,vote_url,message,momenttype,momentid,filename,contenturl,kidsname)
    load_settings
    @recipients = res_emails
    @from = "admin@holdmymemories.com"
    @subject = "Contest Entry Vote Request!!"
    @sent_on = Time.now
    @content_type = "text/html"

    body[:vote_url] = vote_url
    body[:message] = message
    body[:momenttype] = momenttype
    body[:filename] = filename
    body[:contenturl] = contenturl
    body[:kidsname] = kidsname


  end

  def contest_approvemail(fname,email,kidsname,momentid,moment_type,content_url,content_file)
    load_settings
    @recipients = email
    @from = "admin@holdmymemories.com"
    @subject = "Contest Entry Approved!"
    @sent_on = Time.now
    @content_type = "text/html"

    body[:fname] = fname
    body[:kidsname] = kidsname
    body[:momentid] = momentid
    body[:moment_type] = moment_type
    body[:content_url] = content_url
    body[:content_file] = content_file
  end

  def booksession(fname,lname,phone,phone2,streetaddress,email,studio,hear,month,day,year,time,type,comments)
    load_settings
    @recipients = "info@clickportraitsnow.com,angie@clickportraitsnow.com"
    #@recipients = "shivakumar@hysistechnologies.com"
    @bcc="Bob.Eveleth@S121.com"
    @from = email
    @subject = "HoldMyMemories.com - Session"
    @sent_on = Time.now
    @content_type = "text/html"

    body[:fname] = fname
    body[:lname] = lname
    body[:phone] = phone
    body[:phone2] = phone2
    body[:streetaddress] = streetaddress
    body[:email] = email
    body[:studio] = studio
    body[:hear] = hear
    body[:month] = month
    body[:day] = day
    body[:year] = year
    body[:time] = time
    body[:type] = type
    body[:comments] = comments
  end

  def contest_rejectemail(fname,email,kidsname,momentid,moment_type,message,content_url,content_file)
    load_settings
    @recipients = email
    @from = "admin@holdmymemories.com"
    @subject = "#{fname}, your entry into the Family Contest has not yet been accepted."
    @sent_on = Time.now
    @content_type = "text/html"

    body[:message] = message
    body[:fname] = fname
    body[:kidsname] = kidsname
    body[:momentid] = momentid
    body[:moment_type] = moment_type
    body[:content_url] = content_url
    body[:content_file] = content_file
  end

  def photographer_accountinfo(id,name,email,username,userpassword,acc_expire_date)
    load_settings
    @recipients = email
    @from = "info@myhmm.com"
    @subject = "Thank you for registering into HoldMyMemories.com Business Opportunity."
    @sent_on = Time.now
    @content_type = "text/html"

    body[:name] = name
    body[:username] = username
    body[:id] = id
    body[:userpassword] = userpassword
    body[:acc_expire_date] = acc_expire_date
  end

  def studiogroup_accountinfo(id,name,email,username,userpassword,acc_expire_date)
    load_settings
    @recipients = email
    @from = "info@myhmm.com"
    @subject = "Thank you for registering into HoldMyMemories.com Studios"
    @sent_on = Time.now
    @content_type = "text/html"

    body[:name] = name
    body[:username] = username
    body[:id] = id
    body[:userpassword] = userpassword
    body[:acc_expire_date] = acc_expire_date
  end


  def photographer_introinfo(name,address,city,phone,email)
    load_settings
    @recipients = "info@myhmm.com,jeff.Hudson.hmm@gmail.com"
    @from = email
    @subject = "New Registration for HoldMyMemories Business Opportunity."
    @sent_on = Time.now
    @content_type = "text/html"

    body[:name] = name
    body[:address] = address
    body[:city] = city
    body[:phone] = phone
    body[:email] = email
  end

  def studio_introinfo(name,email,accesscode)
    load_settings
    @recipients = email
    @from = 'admin@holdmymemories.com'
    @subject = "Thank you for registering into HoldMyMemories.com Studios"
    @sent_on = Time.now
    @content_type = "text/html"

    body[:name] = name
    body[:accesscode] = accesscode

  end

  def studio_signupinfo(sname,address,city,country,sphone,website,cname,cphone,cemail)
    load_settings
    @recipients = "HMMStudioInfo@HoldMyMemories.com,Bob@S121.com,Info@StudioPlusSoftware.com,HeathL@StudioPlusSoftware.com"
    #@recipients = "b.shivu@gmail.com"
    @bcc="shivakumar@hysistechnologies.com"
    @from = cemail
    @subject = "New Inquiry to HoldMyMemories.com Studio"
    @sent_on = Time.now
    @content_type = "text/html"

    body[:sname] = sname
    body[:address] = address
    body[:city] = city
    body[:country] = country
    body[:sphone] = sphone
    body[:website] = website
    body[:cname] = cname
    body[:cphone] = cphone
    body[:cemail] = cemail
  end


  def order_confirmation(orderdetails,orderproducts,studiodetails)
    load_settings
    @recipients = orderdetails.shipping_email,orderdetails.billing_email
    @from = "admin@hmm.com"
    @subject = "Order Confirmation from HoldMyMemories"
    @sent_on = Time.now
    @content_type = "text/html"

    body[:order_details] = orderdetails
    body[:order_products] = orderproducts
    body[:studio_details] = studiodetails

    #    body[:order_number] = orderdetails.order_number
    #    body[:shipping_name] = orderdetails.shipping_name
    #    body[:shipping_address] = orderdetails.shipping_address
    #    body[:shipping_city] = orderdetails.shipping_city
    #    body[:shipping_state] = orderdetails.shipping_state
    #    body[:shipping_country] = orderdetails.shipping_country
    #    body[:shipping_zip] = orderdetails.shipping_zip
    #    body[:shipping_phone] = orderdetails.shipping_phone
    #    body[:shipping_email] = orderdetails.shipping_email
    #    body[:shipping_price] = orderdetails.shipping_price
    #    body[:total_price] = orderdetails.total_price

  end
end