class Postoffice < ActionMailer::Base
  def load_settings
    #STAGING MODE
    #        @@smtp_settings = {
    #          :address        => "smtp.gmail.com",
    #          :port           => "587",
    #          :domain         => "admin@holdmymemories.com",
    #          :authentication => :plain,
    #          :user_name      => "admin@holdmymemories.com",
    #          :password       => "softway09"
    #        }

    #LIVE MODE
    @@smtp_settings = {
      :address => "relay.jangosmtp.net",
      :port => "2525",
      :domain => "localhost.localdomain",
      :authentication => :plain,
      :user_name => "holdmymemories",
      :password => "hmmpine10"
    }

  end

  #  def reset_smtp_settings
  #    @_temp_smtp_settings = nil
  #    @@smtp_settings = @_temp_smtp_settings
  #
  #  end

  def welcome(name, email,username,password,link,pass_req,pass)
    load_settings
    @recipients   = email
    #    @from         = params[:contact][:email]
    @from         = "admin@holdmymemories.com"
    @bcc="seth.johnson@holdmymemories.com"
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
    @bcc="seth.johnson@holdmymemories.com"
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
    load_settings
    @recipients   = friend_email
    #    @from         = params[:contact][:email]
    @from         = my_name+"<#{my_email}>"
    @bcc="seth.johnson@holdmymemories.com"
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

  def comment(comment,journal,type,cmtfrom_fname,cmtfrom_email,cmtto_fname,cmtto_email,myimage,img_url)
    load_settings
    @recipients   = cmtto_email
    @from         = "#{cmtfrom_fname}<YouHaveAComment@HoldMyMemories.com>"
    @bcc="seth.johnson@holdmymemories.com"
    headers         "Reply-to" => "#{@from}"
    @subject      = "You have received a comment at HoldMyMemories.com"
    @sent_on      = Time.now
    @content_type = "text/html"

    if(cmtto_email!='' && cmtto_email!=nil)
      @hmmuser=HmmUser.find(:first,:conditions=>"v_e_mail='#{cmtto_email}'")
      familyname=@hmmuser.family_name
    else
      familyname=''
    end


    body[:familyname]=familyname
    body[:message]=comment
    body[:from_email]=cmtfrom_email
    body[:from_name]=cmtfrom_fname
    body[:to_email]=cmtto_email
    body[:to_name]=cmtto_fname
    body[:type]="Chapter"
    body[:journal]=journal
    body[:MyImage]=myimage
    body[:img_url]=img_url
  end

  def shareJournalhmm(to_email,message,journal,from_user,from_email,from_image)
    load_settings
    @recipients   = to_email
    @from         = from_email
    @bcc="seth.johnson@holdmymemories.com"
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
    @bcc="seth.johnson@holdmymemories.com"
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

  def shareJournal(to_email,message,journal,from_user,from_email,from_image,id,unid,img_url)
    load_settings
    @recipients   = to_email
    @from         = from_email
    @bcc="seth.johnson@holdmymemories.com"
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
    body[:img_url]=img_url
  end

  def creditpoint(family_name,first_name,last_name,to_email,studio_groupid,studio_groupname,credit_system,studio_id,studio_name,studio_phone,studio_address,studio_zipcode,studio_city,studio_website,total_creditpoint)
    load_settings
    @recipients   = to_email
    @from         = "admin@holdmymemories.com"
    @bcc="seth.johnson@holdmymemories.com"
    #@bcc="testudai@gmail.com"
    headers         "Reply-to" => "#{@from}"
    if credit_system=="Dollars"
      @subject = "#{first_name}, you have a $#{total_creditpoint} credit at #{studio_name}!"
    else
      @subject = "#{first_name}, you have a #{total_creditpoint} credit at #{studio_name}!"
    end
    @sent_on      = Time.now
    @content_type = "text/html"
    body[:family_name]=family_name
    body[:first_name]=first_name
    body[:last_name]=last_name
    body[:studio_groupid]=studio_groupid
    body[:studio_groupname]=studio_groupname
    body[:credit_system]=credit_system
    body[:studio_id]=studio_id
    body[:studio_name]=studio_name
    body[:studio_phone]=studio_phone
    body[:studio_address]=studio_address
    body[:studio_zipcode]=studio_zipcode
    body[:studio_city]=studio_city
    body[:studio_website]=studio_website
    body[:total_creditpoint]=total_creditpoint
  end

  def shareMoment(to_email,message,from_user,from_email,from_image,id,unid)
    load_settings
    @recipients   = to_email
    @from         = from_email
    @from         = from_user+"<#{from_email}>"
    @from_email = "#{@from}"
    @bcc="seth.johnson@holdmymemories.com"
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
    @bcc="seth.johnson@holdmymemories.com"
    headers         "Reply-to" => "#{@from}"
    @subject      = "You have received a comment at HoldMyMemories.com"
    @sent_on      = Time.now
    @content_type = "text/html"

    if(cmtto_email!='' && cmtto_email!=nil)
      @hmmuser=HmmUser.find(:first,:conditions=>"v_e_mail='#{cmtto_email}'")
      familyname=@hmmuser.family_name
    else
      familyname=''
    end


    body[:familyname]=familyname
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
    @bcc="seth.johnson@holdmymemories.com"
    headers         "Reply-to" => "#{@from}"
    @subject      = "You have received a comment at HoldMyMemories.com"
    @sent_on      = Time.now
    @content_type = "text/html"

    if(cmtto_email!='' && cmtto_email!=nil)
      @hmmuser=HmmUser.find(:first,:conditions=>"v_e_mail='#{cmtto_email}'")
      familyname=@hmmuser.family_name
    else
      familyname=''
    end


    body[:familyname]=familyname
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
    @bcc="seth.johnson@holdmymemories.com"
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
    @bcc="seth.johnson@holdmymemories.com"
    headers         "Reply-to" => "#{@from}"
    @subject      = "You have received a comment at HoldMyMemories.com"
    @sent_on      = Time.now
    @content_type = "text/html"

    if(cmtto_email!='' && cmtto_email!=nil)
      @hmmuser=HmmUser.find(:first,:conditions=>"v_e_mail='#{cmtto_email}'")
      familyname=@hmmuser.family_name
    else
      familyname=''
    end


    body[:familyname]=familyname
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
    @bcc="seth.johnson@holdmymemories.com"
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
    @bcc="seth.johnson@holdmymemories.com"
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
    @bcc="seth.johnson@holdmymemories.com"
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
    @recipients   = "farooq@softwaysolutions.com,alok@hysistechnologies.com"
    #   @from         = params[:contact][:email]
    @from         = "#{name}<#{email}>"
    @bcc="seth.johnson@holdmymemories.com"
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
    @bcc="seth.johnson@holdmymemories.com"
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
    @bcc="seth.johnson@holdmymemories.com"
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
    @bcc="seth.johnson@holdmymemories.com"
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

  def contactUsreport(website_email,name,subject,message,country,email,zip,phoneno,mobileno)
    load_settings
    @recipients = website_email
    @bcc="seth.johnson@holdmymemories.com,Bob.Eveleth@S121.com,Rachel.Allen@S121.com,Dan.Quinlan@holdmymemories.com,seth.johnson@s121.com,shrikanth.hathwar@hysistechnologies.com"
    @from = email
    @subject = subject
    @sent_on = Time.now
    @content_type = "text/html"
    body[:name] = name
    body[:email] = email
    body[:country] = country
    body[:subject] = subject
    body[:message] = message
    body[:zip] = zip
    body[:phoneno] = phoneno
    body[:mobileno] = mobileno


  end

  def contactUsreportmysite(name,subject,message,country,email,recepient_email,users_studio_id)
    load_settings
    @recipients = recepient_email
    @from = email
    @bcc="seth.johnson@holdmymemories.com"
    @subject = subject
    @sent_on = Time.now
    @content_type = "text/html"
    body[:name] = name
    body[:email] = email
    body[:country] = country
    body[:subject] = subject
    body[:message] = message

  end

  #  def contactUsreport1(name,subject,message,country,email,branch,employeename,customer_name,account_type)
  #    load_settings
  #    @recipients = "Bob.Eveleth@S121.com,Rachel.Allen@S121.com,customerservice@holdmymemories.com,dan.quinlan@holdmymemories.com"
  #    @from = email
  #    @bcc="seth.johnson@holdmymemories.com"
  #    @subject = subject
  #    @sent_on = Time.now
  #    @content_type = "text/html"
  #    body[:name] = name
  #    body[:email] = email
  #    body[:country] = country
  #    body[:subject] = subject
  #    body[:message] = message
  #    body[:branch] = branch
  #    body[:employeename] = employeename
  #    body[:customer_name] = customer_name
  #    body[:account_type] = account_type
  #
  #
  #  end

  def contactUsreport1(name,subject,message,country,email,branch,employeename,customer_name,account_type,emp_studio_id)
    load_settings
    @recipients = "customerservice@holdmymemories.com"
    @from = email
    #@bcc="seth.johnson@holdmymemories.com"
    if emp_studio_id == 22 || emp_studio_id == '22'
      @bcc = "angie@holdmymemories.com,see.farooq@gmail.com,seth.johnson@holdmymemories.com,Bob.Eveleth@S121.com,Rachel.Allen@S121.com,Dan.Quinlan@holdmymemories.com,seth.johnson@s121.com"
    else
      @bcc = "seth.johnson@holdmymemories.com,Bob.Eveleth@S121.com,Rachel.Allen@S121.com,Dan.Quinlan@holdmymemories.coms,seth.johnson@s121.com,shrikanth.hathwar@hysistechnologies.com"
    end
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
    #
    #   puts sha_type
    #   puts "1234"
    load_settings
    @recipients = i
    @from_email = sender_email
    @bcc="seth.johnson@holdmymemories.com"
    @from_name = sender_name
    @reciepent_message=reciepent_message
    @from         = sender_name+"<#{sender_email}>"
    headers         "Reply-to" => "#{@from}"
    from         sender_name+"<#{sender_email}>"
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
    @bcc="seth.johnson@holdmymemories.com"
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
    @bcc="seth.johnson@holdmymemories.com"
    @from         = sender_name+"<#{sender_email}>"
    headers         "Reply-to" => "#{@from}"
    from       sender_name+"<#{sender_email}>"
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

  def requesting_owner1(to,email,name,msg,owner_name,link,code)
    load_settings
    @recipients = to

    @from_email = email
    @from_name = email
    @from         = "<#{email}>"
    headers         "Reply-to" => "#{@from}"
    from       "<#{email}>"
    body[:name] = name
    body[:msg] = msg
    body[:owner] = owner_name
    body[:link] = link
    body[:code] = code
    body[:frm] = email

    @subject = "HoldMyMemories Requesting owner"
    @sent_on = Time.now
    @content_type = "text/html"
  end

  def request_approval(to_email,link,password,name,owner)
    load_settings
    email = "admin@holdmymemories.com"
    @recipients = to_email
    @from_email = email
    @from_name = email
    @from         = "<#{email}>"
    headers         "Reply-to" => "#{@from}"
    from       "<#{email}>"
    #    @link = link
    #    @password = password
    #    @name = name

    body[:link] = link
    body[:password] = password
    body[:name] = name
    body[:owner] = owner

    @subject = "#{owner} has approved your request for Order prints."
    @sent_on = Time.now
    @content_type = "text/html"
  end

  def request_approval_rejected(to_email,user)
    load_settings
    email = "admin@holdmymemories.com"
    @recipients = to_email
    @from_email = email
    @from_name = email
    @from         = "<#{email}>"
    headers         "Reply-to" => "#{@from}"
    from       "<#{email}>"
    #@user = user
    body[:user] = user
    @subject = "Request has been rejected by the owner."
    @sent_on = Time.now
    @content_type = "text/html"
  end

  def voteconform(email,contestid,unid,filename,entrant_name,userfname,userlname,moment_type,paths,momentid,moment_url)
    load_settings
    @recipients = email
    @from_email = "admin@holdmymemories.com"
    @from_name = "HoldMyMemories Contest"
    @bcc="seth.johnson@holdmymemories.com"
    @subject = "HoldMyMemories.com vote confirmation email"
    @from = "HoldMyMemories Contest"+"<admin@holdmymemories.com>"
    body[:unid] = unid
    body[:email] = email
    body[:filename] = filename
    body[:fname] = entrant_name
    body[:userfname] = userfname
    body[:userlname] = userlname
    body[:moment_type] = moment_type
    body[:contestid] = contestid
    body[:paths]=paths
    body[:momentid]=momentid
    body[:moment_url]=moment_url

  end
   def kidsvoteconform(email,contestid,unid,filename,entrant_name,userfname,userlname,moment_type,paths,momentid,moment_url,contest_phase, contest_name)
    load_settings
    @recipients = email
    @from_email = "admin@holdmymemories.com"
    @from_name = "HoldMyMemories Contest"
    @bcc="seth.johnson@holdmymemories.com"
    @subject = "HoldMyMemories.com vote confirmation email"
    @from = "HoldMyMemories Contest"+"<admin@holdmymemories.com>"
    body[:unid] = unid
    body[:email] = email
    body[:filename] = filename
    body[:fname] = entrant_name
    body[:userfname] = userfname
    body[:userlname] = userlname
    body[:moment_type] = moment_type
    body[:contestid] = contestid
    body[:paths]=paths
    body[:momentid]=momentid
    body[:moment_url]=moment_url
    body[:contest_phase]= contest_phase
    body[:contest_name] = contest_name
  end

  def hmmvoteconform(email,contestid,unid,filename,entrant_name,userfname,userlname,moment_type)
    load_settings
    @recipients = email
    @from_email = "admin@holdmymemories.com"
    @from_name = "HoldMyMemories Contest"
    @bcc="seth.johnson@holdmymemories.com"
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
    @bcc="seth.johnson@holdmymemories.com"
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
    @bcc="seth.johnson@holdmymemories.com"
    headers "Reply-to" => "#{@from}"
    @subject = "HoldMyMemories email test "
    @sent_on = Time.now
    @content_type = "text/html"
  end

  def paymentsucess(customer_name , v_e_mail , v_user_name, account_type, account_expdate,months,amount,street_address, city, state ,postcode, country,telephone,invoicenumber,subnumber, username, password1, link,pass_req,pass,next_subs_dat)
    load_settings
    @recipients = v_e_mail
    @from= "admin@holdmymemories.com"
    @bcc="seth.johnson@holdmymemories.com,bob@s121.com"
    #@bcc="b.shivu@gmail.com"

    #Get studio name
    @udet=HmmUser.find(:first,:conditions=>"v_user_name='#{v_user_name}'")

    #    if(@udet.studio_id==0 || @udet.studio_id=='0' || @udet.studio_id==nil || @udet.studio_id=='')
    #      @subject      = "Thank-you for your subscription to HoldMyMemories.com"
    #    else
    #      @studiodet=HmmStudio.find(@udet.studio_id)
    #      @subject      = "Thank-you for your subscription to HoldMyMemories.com at #{@studiodet.studio_branch}"
    #    end

    if(@udet.emp_id==0 || @udet.emp_id=='0' || @udet.emp_id==nil || @udet.emp_id=='')
      @subject      = "Thank-you for your subscription to HoldMyMemories.com"
    else
      @studio=EmployeAccount.find(@udet.emp_id)
      studio_id=@studio.store_id
      @studiodet=HmmStudio.find(studio_id)
      @subject      = "Thank-you for your subscription to HoldMyMemories.com at #{@studiodet.studio_branch}"
      if @studiodet.studio_groupid==195
        add_bcc=",rachel.poston@holdmymemories.com"
      else
        add_bcc=""
      end
      if(studio_id == 22)
        @bcc="seth.johnson@holdmymemories.com,bob@s121.com#{add_bcc}"
      else
        @bcc="seth.johnson@holdmymemories.com,bob@s121.com#{add_bcc}"
      end
    end


    @sent_on      = Time.now
    @content_type = "text/html"
    if account_type == "platinum_user"
      account_type="Premium"
    else
      account_type="Family Website"
    end
    body[:next_subs_dat] = next_subs_dat
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
    @bcc="seth.johnson@holdmymemories.com"
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

  def paymentsucessupdate(customer_name , v_e_mail , v_user_name, account_type, account_expdate,months,amount,street_address, city, state ,postcode, country,telephone,invoicenumber,subnumber, username, password1, link,pass_req,pass,next_subs_dat)
    load_settings
    @recipients = v_e_mail
    @from= "admin@holdmymemories.com"
    @bcc="seth.johnson@holdmymemories.com,bob@s121.com"
    #@bcc="b.shivu@gmail.com"

    #Get studio name
    @udet=HmmUser.find(:first,:conditions=>"v_user_name='#{v_user_name}'")

    #    if(@udet.studio_id==0 || @udet.studio_id=='0' || @udet.studio_id==nil || @udet.studio_id=='')
    #      @subject      = "Thank-you for your subscription to HoldMyMemories.com"
    #    else
    #      @studiodet=HmmStudio.find(@udet.studio_id)
    #      @subject      = "Thank-you for your subscription to HoldMyMemories.com at #{@studiodet.studio_branch} "
    #    end

    if(@udet.emp_id==0 || @udet.emp_id=='0' || @udet.emp_id==nil || @udet.emp_id=='')
      @subject      = "Thank-you for your subscription to HoldMyMemories.com"
    else
      @studio=EmployeAccount.find(@udet.emp_id)
      studio_id=@studio.store_id
      @studiodet=HmmStudio.find(studio_id)
      @subject      = "Thank-you for your subscription to HoldMyMemories.com at #{@studiodet.studio_branch}"
      if @studiodet.studio_groupid==195
        add_bcc=",rachel.poston@holdmymemories.com"
      else
        add_bcc=""
      end
      if(studio_id == 22)
        @bcc="seth.johnson@holdmymemories.com,bob@s121.com#{add_bcc}"
      else
        @bcc="seth.johnson@holdmymemories.com,bob@s121.com#{add_bcc}"
      end
    end


    @sent_on      = Time.now
    @content_type = "text/html"
    if account_type == "platinum_user"
      account_type="Premium"
    else
      account_type="Family Website"
    end
    body[:next_subs_dat] = next_subs_dat
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

  #  def cancellation_request(store_employee_name, store_employee_email,reason,store_id,user_id)
  #    load_settings
  #    hmm_user = HmmUser.find(user_id)
  #    @recipients = store_employee_email
  #    @from= "#{hmm_user.v_e_mail}"
  #    @bcc="seth.johnson@holdmymemories.com,david.schaefer@holdmymemories.com"
  #    @from_email = "#{hmm_user.v_e_mail}"
  #    @from_name = hmm_user.v_fname
  #    @from = "#{@from_name}" +"#{@from_email}"
  #    @subject      = "Request for the cancellation of subscription sent by  #{hmm_user.v_fname} #{hmm_user.v_lname}"
  #    @sent_on      = Time.now
  #    @content_type = "text/html"
  #    body[:store_employee_name] = store_employee_name
  #    body[:v_fname] = hmm_user.v_fname
  #    body[:v_lname] = hmm_user.v_lname
  #    body[:v_e_mail] = hmm_user.v_e_mail
  #    body[:account_type]  = hmm_user.account_type
  #    body[:amount] = hmm_user.amount
  #    body[:street_address] = hmm_user.street_address
  #    body[:city] = hmm_user.city
  #    body[:state] = hmm_user.state
  #    body[:postcode] = hmm_user.postcode
  #    body[:telephone] = hmm_user.telephone
  #    body[:invoicenumber] = hmm_user.invoicenumber
  #    body[:country] = hmm_user.country
  #    body[:subscriptionnumber] = hmm_user.subscriptionnumber
  #    body[:reason] = reason
  #    @credit_count=CreditPoint.count(:all,:conditions=>"user_id=#{user_id}")
  #    if store_id=="nil" || @credit_count==0
  #      body[:studio_group]="nil"
  #      body[:studio_name]="nil"
  #      body[:credit_point]=0
  #    else
  #      @credit=CreditPoint.find(:first,:select=>"a.available_credits,b.hmm_franchise_studio,b.credit_system,c.studio_name",:joins=>"as a,hmm_studiogroups as b,hmm_studios as c",:conditions=>"a.user_id=#{hmm_user.id} and a.hmm_studiogroup_id=b.id and  b.id=c.studio_groupid and c.id=#{store_id} " )
  #      body[:studio_group]=@credit.hmm_franchise_studio
  #      if @credit.credit_system=="Dollars"
  #        body[:credit_point]="$#{@credit.available_credits}"
  #      else
  #        body[:credit_point]="#{(@credit.available_credits).round} points"
  #      end
  #      body[:studio_name]=@credit.studio_name
  #    end
  #
  #  end

  def cancellation_request(store_employee_name, store_employee_email,reason,store_id,user_id)
    load_settings
    hmm_user = HmmUser.find(user_id)
    @recipients = store_employee_email
    @from= "#{hmm_user.v_e_mail}"
    @from_email = "#{hmm_user.v_e_mail}"
    @from_name = hmm_user.v_fname
    @from = "#{@from_name}" +"#{@from_email}"
    @subject      = "Request for the cancellation of subscription sent by  #{hmm_user.v_fname} #{hmm_user.v_lname}"
    @sent_on      = Time.now
    @content_type = "text/html"
    click_studio_id = 3
    @emp_studio = HmmStudio.find(store_id)
    if @emp_studio.studio_groupid.to_i == click_studio_id && @emp_studio.id == store_id
      #@bcc = "angie@holdmymemories.com"
      @bcc="seth.johnson@holdmymemories.com,david.schaefer@holdmymemories.com,angie@holdmymemories.com,see.farooq@gmail.com"
    else
      @bcc="seth.johnson@holdmymemories.com,david.schaefer@holdmymemories.com"
      #@bcc="seth.johnson@holdmymemories.com,david.schaefer@holdmymemories.com"
    end
    body[:store_employee_name] = store_employee_name
    body[:v_fname] = hmm_user.v_fname
    body[:v_lname] = hmm_user.v_lname
    body[:v_e_mail] = hmm_user.v_e_mail
    body[:account_type]  = hmm_user.account_type
    body[:amount] = hmm_user.amount
    body[:street_address] = hmm_user.street_address
    body[:city] = hmm_user.city
    body[:state] = hmm_user.state
    body[:postcode] = hmm_user.postcode
    body[:telephone] = hmm_user.telephone
    body[:invoicenumber] = hmm_user.invoicenumber
    body[:country] = hmm_user.country
    body[:subscriptionnumber] = hmm_user.subscriptionnumber
    body[:reason] = reason
    @credit_count=CreditPoint.count(:all,:conditions=>"user_id=#{user_id}")
    if store_id=="nil" || @credit_count==0
      body[:studio_group]="nil"
      body[:studio_name]="nil"
      body[:credit_point]=0
    else
      @credit=CreditPoint.find(:first,:select=>"a.available_credits,b.hmm_franchise_studio,b.credit_system,c.studio_name",:joins=>"as a,hmm_studiogroups as b,hmm_studios as c",:conditions=>"a.user_id=#{hmm_user.id} and a.hmm_studiogroup_id=b.id and  b.id=c.studio_groupid and c.id=#{store_id} " )
      body[:studio_group]=@credit.hmm_franchise_studio
      if @credit.credit_system=="Dollars"
        body[:credit_point]="$#{@credit.available_credits}"
      else
        body[:credit_point]="#{(@credit.available_credits).round} points"
      end
      body[:studio_name]=@credit.studio_name
    end
  end

  def cancellation_request_response(store_employee_email,v_fname,v_lname,v_e_mail,account_type,amount,subscriptionnumber,invoicenumber,family_pic,no_of_days,img_url)
    load_settings
    @recipients = v_e_mail
    @from= "admin@holdmymemories.com"
    @bcc="seth.johnson@holdmymemories.com"
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
    @bcc="seth.johnson@holdmymemories.com"
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
    @bcc="seth.johnson@holdmymemories.com"
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
    @bcc="seth.johnson@holdmymemories.com"
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

 def contest_approve_email(fname,email,kidsname,momentid,moment_type,content_url,content_file,paths,contestid,contest_name,phase_id)
    load_settings
    @recipients = email
    @from = "admin@holdmymemories.com"
    @bcc="seth.johnson@holdmymemories.com"
    @subject = "Contest Entry Approved!"
    @sent_on = Time.now
    @content_type = "text/html"

    body[:fname] = fname
    body[:kidsname] = kidsname
    body[:momentid] = momentid
    body[:moment_type] = moment_type
    body[:content_url] = content_url
    body[:content_file] = content_file
    body[:paths]=paths
    body[:contestid] = contestid
    body[:contest_id] = phase_id
#    body[:controller_name] = controller
    body[:contest_name] = contest_name
  end

  def booksession(fname,lname,phone,phone2,streetaddress,email,studio,hear,month,day,year,time,type,comments,studio_email,studio_header_img,url)
    load_settings
    @recipients = studio_email
    #@recipients = "info@clickportraitsnow.com,angie@clickportraitsnow.com"
    #@recipients = "shivakumar@hysistechnologies.com"
    @bcc="Bob.Eveleth@S121.com,seth.johnson@holdmymemories.com"

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
    body[:studio_header_img] = studio_header_img
    body[:content_server_url] = url
  end

  def contest_rejectemail(fname,email,kidsname,momentid,moment_type,message,content_url,content_file)
    load_settings
    @recipients = email
    @from = "admin@holdmymemories.com"
    @bcc="seth.johnson@holdmymemories.com"
    @subject = "#{fname}, your entry into the Cute Kids Contest has not yet been accepted."
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
    @bcc="seth.johnson@holdmymemories.com"
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
    @bcc="seth.johnson@holdmymemories.com"
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
    @bcc="seth.johnson@holdmymemories.com"
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
    @bcc="seth.johnson@holdmymemories.com"
    @subject = "Thank you for registering into HoldMyMemories.com Studios"
    @sent_on = Time.now
    @content_type = "text/html"

    body[:name] = name
    body[:accesscode] = accesscode

  end

  def studio_signupinfo(sname,address,city,country,sphone,website,cname,cphone,cemail,children,family,maternity,glamour,high_school,bridal,weddings,other_session,avg_session,notes,followdate,follow_person)
    load_settings
    @recipients = "Bob@S121.com,Info@StudioPlusSoftware.com"
    #@recipients = "b.shivu@gmail.com"
    #@bcc="shivakumar@hysistechnologies.com"
    @from = cemail
    @bcc="seth.johnson@holdmymemories.com"
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
    body[:children] = children
    body[:family] = family
    body[:maternity] = maternity
    body[:glamour] = glamour
    body[:high_school] = high_school
    body[:bridal] = bridal
    body[:weddings] = weddings
    body[:other_session] = other_session
    body[:avg_session] = avg_session
    body[:notes] = notes
    body[:followdate] =followdate
    body[:follow_person] = follow_person

  end


  def studio_signupinfo_user(sname,address,city,country,sphone,website,cname,cphone,cemail,children,family,maternity,glamour,high_school,bridal,weddings,other_session,avg_session)
    load_settings
    @recipients = "mallikarjun@hysistechnologies.com"
    #@recipients = "b.shivu@gmail.com"
    #@bcc="shivakumar@hysistechnologies.com"
    @from = cemail
    @bcc="seth.johnson@holdmymemories.com"
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
    body[:children] = children
    body[:family] = family
    body[:maternity] = maternity
    body[:glamour] = glamour
    body[:high_school] = high_school
    body[:bridal] = bridal
    body[:weddings] = weddings
    body[:other_session] = other_session
    body[:avg_session] = avg_session

  end

  def licensepass(studio_owner_name)
    load_settings
    @recipients = "bob@s121.com,Seth.johnson@s121.com"
    #@recipients = "b.shivu@gmail.com"
    #@bcc="shivakumar@hysistechnologies.com"
    @from = "admin@holdmymemories.com"
    @bcc="seth.johnson@holdmymemories.com"
    @subject = "License Agreement Activated"
    @sent_on = Time.now
    @content_type = "text/html"

    body[:sname] = studio_owner_name

  end

  def order_confirmation(orderdetails,orderproducts,studiodetails)
    load_settings
    @recipients = orderdetails.shipping_email,orderdetails.billing_email
    @from = "admin@hmm.com"
    @bcc="seth.johnson@holdmymemories.com"
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

  def neworder_confirmation(orders,email1,email2)
    load_settings
    @recipients = email1,email2
    @from = "admin@hmm.com"
    @bcc="seth.johnson@holdmymemories.com"
    @subject = "Order Confirmation from HoldMyMemories"
    @sent_on = Time.now
    @content_type = "text/html"
    body[:orders] = orders

  end

  def neworder_confirmation_studio(orders,studio_email)
    load_settings
    studio_detail = orders[:studio]
    managers = ManagerBranche.find_all_by_branch_id(studio_detail.id)
    bccemail = "seth.johnson@holdmymemories.com,bob@s121.com,dan@s121.com,michelle.bowling@s121.com"
    begin
      for manager in managers
        bccemail << "," + MarketManager.find(manager.manager_id).e_mail
      end
    rescue
      #do nothing
    end
    @recipients = studio_email
    @from = "admin@hmm.com"
    @bcc= bccemail
    @subject = "Order Confirmation from HoldMyMemories"
    @sent_on = Time.now
    @content_type = "text/html"
    body[:order] = orders
  end

  #Gift Coupon Email
  def giftcoupon_mail(coupon_number,name,email,created_date,email_id,payment_type,amount,months)

    load_settings
    @recipients =email_id
    @from = "admin@hmm.com"
    @bcc="seth.johnson@holdmymemories.com,bob@s121.com"
    @subject = "Order Confirmation from HoldMyMemories"
    @sent_on = Time.now
    @content_type = "text/html"

    body[:coupon_number] = coupon_number
    body[:name]=name
    body[:created_date]=created_date
    body[:email_id]=email
    body[:payment_type]=payment_type
    body[:amount]=amount
    body[:months]=months

  end


  #Gift Coupon recipients Email
  def giftcoupon_recipient_mail(coupon_number,name,email,message,fname,lname,payment_type)

    load_settings
    @recipients =email
    @from = "admin@holdmymemories.com"
    @bcc="seth.johnson@holdmymemories.com,bob@s121.com"
    @subject = "Gift Membership from Holdmymemories"
    @sent_on = Time.now
    @content_type = "text/html"

    body[:coupon_number] = coupon_number
    body[:fname] = fname
    body[:lname]=lname
    body[:payment_type]=payment_type
    body[:name]=name
    body[:message]=message

  end

  # Email notifiacatio - once the credit points are credited
  def creditpoint_notification(credit_points,hmm_franchise_studio,studio_branch,family_website_url,customer_email,studio_phone,studio_email)

    load_settings
    @recipients = customer_email
    @from = "admin@holdmymemories.com"
    #@bcc = "testudai@gmail.com"
    @bcc="seth.johnson@holdmymemories.com,bob@s121.com,testudai@gmail.com"
    @subject = "You have a $#{credit_points} Studio credit at #{studio_branch}"
    @sent_on = Time.now
    @content_type = "text/html"

    body[:credit_points] = credit_points
    body[:hmm_franchise_studio] = hmm_franchise_studio
    body[:studio_branch] = studio_branch
    body[:family_website_url] = family_website_url
    body[:studio_phone] = studio_phone
    body[:studio_email] = studio_email

  end

  #  def contactUsreport_email1(name,subject,message,country,email,branch,employeename,customer_name,account_type,to,bccto)
  #    load_settings
  #    @recipients = to
  #    @from = email
  #    @bcc = bccto
  #    #@bcc = "testudai@gmail.com,"+bccto
  #    @subject = subject
  #    @sent_on = Time.now
  #    @content_type = "text/html"
  #    body[:name] = name
  #    body[:email] = email
  #    body[:country] = country
  #    body[:subject] = subject
  #    body[:message] = message
  #    body[:branch] = branch
  #    body[:employeename] = employeename
  #    body[:customer_name] = customer_name
  #    body[:account_type] = account_type
  #
  #
  #  end

  def contactUsreport_email1(name,subject,message,country,email,branch,employeename,customer_name,account_type,to,bccto,studio_group_id)
    load_settings
    @recipients = to
    @from = email
    @bcc = bccto
    @subject = subject
    @sent_on = Time.now
    @content_type = "text/html"
    click_studio_id = 3
    if(studio_group_id == click_studio_id )
      @bcc ="angie@holdmymemories.com,see.farooq@gmail.com,#{bccto}"
    else
      @bcc = bccto
    end
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

  #  def contactUsreport_email(name,subject,message,country,email,zip,phoneno,mobileno,to,bccto)
  #    load_settings
  #    @recipients = to
  #    #@recipients = "b.shivu@gmail.com,kris20k@gmail.com"
  #    @from = email
  #    @bcc=bccto
  #    #@bcc="testudai@gmail.com,"+bccto
  #    @subject = subject
  #    @sent_on = Time.now
  #    @content_type = "text/html"
  #    body[:name] = name
  #    body[:email] = email
  #    body[:country] = country
  #    body[:subject] = subject
  #    body[:message] = message
  #    body[:zip] = zip
  #    body[:phoneno] = phoneno
  #    body[:mobileno] = mobileno
  #
  #
  #  end

  def contactUsreport_email(name,subject,message,country,email,zip,phoneno,mobileno,to,bccto,studio_group_id)
    load_settings
    @recipients = to
    @from = email

    @subject = subject
    @sent_on = Time.now
    @content_type = "text/html"
    click_studio_id = 3
    if(studio_group_id == click_studio_id )
      @bcc ="angie@holdmymemories.com,see.farooq@gmail.com,#{bccto}"
    else
      @bcc=bccto
    end
    body[:name] = name
    body[:email] = email
    body[:country] = country
    body[:subject] = subject
    body[:message] = message
    body[:zip] = zip
    body[:phoneno] = phoneno
    body[:mobileno] = mobileno
  end

  def shareviaemail(to_email,email,contestid,unid,filename,entrant_name,userfname,userlname,moment_type,view,paths,momentid,moment_url,contest_phase,contest_name)
    load_settings
    @recipients = to_email
    @from_email = email
    @from_name = "HoldMyMemories Contest"
        @bcc="seth.johnson@holdmymemories.com"
    @subject = "HoldMyMemories.com vote request email"
    @from = "HoldMyMemories Contest"+"<admin@holdmymemories.com>"
    body[:unid] = unid
    body[:email] = email
    body[:filename] = filename
    body[:fname] = entrant_name
    body[:userfname] = userfname
    body[:userlname] = userlname
    body[:moment_type] = moment_type
    body[:contestid] = contestid
    body[:contest_phase] = contest_phase
    body[:view] = view
    body[:paths] = paths
    body[:momentid] = momentid
    body[:moment_url] = moment_url
  end

  def shareviaemailkids(email,contestid,unid,filename,entrant_name,userfname,userlname,moment_type,view,paths,momentid,moment_url,phase_id)
    load_settings
    @recipients = email
    @from_email = "admin@holdmymemories.com"
    @from_name = "HoldMyMemories Contest"
      @bcc="seth.johnson@holdmymemories.com"
    @subject = "HoldMyMemories.com vote request email"
    @from = "HoldMyMemories Contest"+"<admin@holdmymemories.com>"
    body[:unid] = unid
    body[:email] = email
    body[:filename] = filename
    body[:fname] = entrant_name
    body[:userfname] = userfname
    body[:userlname] = userlname
    body[:moment_type] = moment_type
    body[:contestid] = contestid
    body[:view] = view
    body[:paths] = paths
    body[:momentid] = momentid
    body[:moment_url] = moment_url
    if phase_id == "phase11"
      body[:controllers]="american_family"
      body[:contest_name]="All American Family"
    elsif phase_id == "phase13"
      body[:controllers]="thatsmybaby"
      body[:contest_name]="that'sMYbaby"
    elsif phase_id == "phase14"
      body[:controllers]="home_holidays"
      body[:contest_name]="Home For The Holidays"
    end
  end

  def iphone_app_status(email_id)
    load_settings
    @recipients = email_id
    @bcc="seth.johnson@holdmymemories.com,bob@s121.com,manojbabu@hysistechnologies.com,shrikanth.hathwar@hysistechnologies.com"
    @from = "admin@holdmymemories.com"
    @subject = "Your Studio iPhone App has been approved"
  end


  def  iphone_app_status_reject(email_id,reason)
    load_settings
    @recipients = email_id
    @bcc="seth.johnson@holdmymemories.com,bob@s121.com,manojbabu@hysistechnologies.com,shrikanth.hathwar@hysistechnologies.com"
    @from = "admin@holdmymemories.com"
    @subject = "Your Studio iPhone App has been rejected for some reason"
    body[:reason] = reason
  end
  def  iphone_app_status_live(email_id,live)
    load_settings
    @recipients = email_id
    @bcc="seth.johnson@holdmymemories.com,bob@s121.com,manojbabu@hysistechnologies.com,shrikanth.hathwar@hysistechnologies.com"
    @from = "admin@holdmymemories.com"
    @subject = "Your Studio iPhone App has been made Live"
    body[:live] = live
  end

  def contest_approve_email(fname,email,kidsname,momentid,moment_type,content_url,content_file,paths,contestid,contest_name,phase_id)
    load_settings
    @recipients = email
    @from = "admin@holdmymemories.com"
    @bcc="seth.johnson@holdmymemories.com"
    @subject = "Contest Entry Approved!"
    @sent_on = Time.now
    @content_type = "text/html"

    body[:fname] = fname
    body[:kidsname] = kidsname
    body[:momentid] = momentid
    body[:moment_type] = moment_type
    body[:content_url] = content_url
    body[:content_file] = content_file
    body[:paths]=paths
    body[:contestid] = contestid
    body[:contest_id] = phase_id
#    body[:controller_name] = controller
    body[:contest_name] = contest_name
  end

  def contest_reject_email(fname,email,kidsname,momentid,moment_type,message,content_url,content_file,contest_name,contestid)
    load_settings
    @recipients = email
    @from = "admin@holdmymemories.com"
    @bcc="seth.johnson@holdmymemories.com"
    @subject = "#{fname}, your entry into the #{contest_name} has not yet been accepted."
    @sent_on = Time.now
    @content_type = "text/html"

    body[:message] = message
    body[:fname] = fname
    body[:kidsname] = kidsname
    body[:momentid] = momentid
    body[:moment_type] = moment_type
    body[:content_url] = content_url
    body[:content_file] = content_file
    body[:contest_name] = contest_name
    body[:contestid] = contestid
#    body[:controller_name] = controller
  end

  def studio_certificates(certificate_id,studio_id,cert_id)
    load_settings
    certificate_info=GiftCertificate.find(:first,:conditions=>"id=#{certificate_id}")
    certificate_desc=GiftCertificateDescription.find(:all,:conditions=>"gift_certificates_id=#{certificate_id}")
    studio=HmmStudio.find(:first,:conditions=>"id=#{studio_id}")
    cert_info=CustomerOrderCertificate.find(:first,:select=>"a.*,b.contact_email",:joins=>"as a,hmm_studios as b",:conditions=>"a.studio_id=b.id and a.id=#{cert_id}")
    other_studios=GiftCertificate.find(:all,:select=>"c.studio_name,c.studio_phone",:joins=>"as a,gift_certificate_studios as b,hmm_studios as c",:conditions=>"a.id=b.gift_certificates_id and c.id=b.studio_id and a.id=#{certificate_id}")


    @recipients = cert_info.deliver_email
    @from = "admin@holdmymemories.com"
    @bcc="seth.johnson@holdmymemories.com,shrikanth.hathwar@hysistechnologies.com,#{cert_info.contact_email}"
    @subject = "#{cert_info.first_name}, Check out your Gift Certificate."
    @sent_on = Time.now
    @content_type = "text/html"

    body[:certificate_info]=certificate_info
    body[:certificate_desc]=certificate_desc
    body[:studio]=studio
    body[:cert_info]=cert_info
    body[:other_studios]=other_studios
  end

  def studio_certificate_receipt(cert)
    load_settings
    certificate_info=GiftCertificate.find(:first,:conditions=>"id=#{cert.certificate_id}")

    @recipients = cert.email
    studio=HmmStudio.find(:first,:conditions=>"id=#{cert.studio_id}")
    @from = "admin@holdmymemories.com"
    @bcc="seth.johnson@holdmymemories.com,bob@holdmymemories.com,shrikanth.hathwar@hysistechnologies.com,#{studio.contact_email}"
    @subject = "Order Confirmation from HoldMyMemories"
    @sent_on = Time.now
    @content_type = "text/html"

    body[:certificate]=cert
    body[:certificate_info]=certificate_info
  end


  def voteconfirm(email,contestid,unid,filename,entrant_name,userfname,userlname,moment_type,paths,momentid,moment_url,contest_phase, contest_name)
    load_settings
    @recipients = email
    @from_email = "admin@holdmymemories.com"
    @from_name = "HoldMyMemories Contest"
    #    @bcc="seth.johnson@holdmymemories.com"
    @subject = "HoldMyMemories.com vote confirmation email"
    @from = "HoldMyMemories Contest"+"<admin@holdmymemories.com>"
    body[:unid] = unid
    body[:email] = email
    body[:filename] = filename
    body[:fname] = entrant_name
    body[:userfname] = userfname
    body[:userlname] = userlname
    body[:moment_type] = moment_type
    body[:contestid] = contestid
    body[:paths]=paths
    body[:momentid]=momentid
    body[:moment_url]=moment_url
    body[:contest_phase] = contest_phase
    body[:contest_name] = contest_name
  end

  def feedbacks(params)
    load_settings
    @recipients   = "shrikanth.hathwar@hysistechnologies.com"
    @from         = params[:email]
    @subject = "Feed back about HMM from #{params[:name]}"
    @sent_on = Time.now
    @content_type = "text/html"


    body[:name]=params[:name]
    body[:family_name]=params[:id]
    body[:url]=params[:url]
    body[:comment]=params[:message]
    body[:email]=params[:email]
  end


  def family_share_blog(to_email,message,journal,from_user,from_email,from_image,id,unid,img_url,family_name,blog_id)
    load_settings
    @recipients   = to_email
    @from         = from_email
    @bcc="seth.johnson@holdmymemories.com"
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
    body[:img_url]=img_url
    body[:family_name]=family_name
    body[:blog_id]=blog_id

  end

  def family_memory_comment(comment,journal,type,cmtfrom_fname,cmtfrom_email,cmtto_fname,cmtto_email,myimage,img_url)
    load_settings
    @recipients   = cmtto_email
    @from         = "#{cmtfrom_fname}<YouHaveAComment@HoldMyMemories.com>"
    @bcc="seth.johnson@holdmymemories.com"
    headers         "Reply-to" => "#{@from}"
    @subject      = "You have received a comment at HoldMyMemories.com"
    @sent_on      = Time.now
    @content_type = "text/html"

    if(cmtto_email!='' && cmtto_email!=nil)
      @hmmuser=HmmUser.find(:first,:conditions=>"v_e_mail='#{cmtto_email}'")
      familyname=@hmmuser.family_name
    else
      familyname=''
    end


    body[:familyname]=familyname
    body[:message]=comment
    body[:from_email]=cmtfrom_email
    body[:from_name]=cmtfrom_fname
    body[:to_email]=cmtto_email
    body[:to_name]=cmtto_fname
    body[:type]="Chapter"
    body[:journal]=journal
    body[:MyImage]=myimage
    body[:img_url]=img_url
  end

  def shareMomentpages(i,sender_name,sender_email,link,reciepent_message,sha_type,pass,messageboard_link,family_img,content_url)
    #
    #   puts sha_type
    #   puts "1234"
    load_settings
    @recipients = i
    @from_email = sender_email
    @bcc="seth.johnson@holdmymemories.com"
    @from_name = sender_name
    @reciepent_message=reciepent_message
    @from         = sender_name+"<#{sender_email}>"
    headers         "Reply-to" => "#{@from}"
    from         sender_name+"<#{sender_email}>"
    @subject = "HoldMyMemories Moment Share"
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
   def voteconf(email,contestid,unid,filename,entrant_name,userfname,userlname,moment_type,paths,momentid,moment_url,contest_phase, contest_name)
    load_settings
    @recipients = email
    @from_email = "admin@holdmymemories.com"
    @from_name = "HoldMyMemories Contest"
    @bcc="seth.johnson@holdmymemories.com"
    @subject = "HoldMyMemories.com vote confirmation email"
    @from = "HoldMyMemories Contest"+"<admin@holdmymemories.com>"
    body[:unid] = unid
    body[:email] = email
    body[:filename] = filename
    body[:fname] = entrant_name
    body[:userfname] = userfname
    body[:userlname] = userlname
    body[:moment_type] = moment_type
    body[:contestid] = contestid
    body[:paths]=paths
    body[:momentid]=momentid
    body[:moment_url]=moment_url
    body[:contest_phase] = contest_phase
    body[:contest_name] = contest_name
  end
end