class Mailman < ActionMailer::Base
  require "faster_csv" 
  def receive_old(email)
      #page = Page.find_by_address(email.to.first)
      # page.emails.create(
      #        puts  "Subject => #{email.subject}"
      #        puts "body => #{email.body}"
      #   )
      
      if (email.subject=="Summary of Automated Recurring Billing")
        if email.has_attachments?
          i=0
          for attachment in email.attachments
             #puts "attachment => #{attachment}"
             File.open("#{RAILS_ROOT}/public/inbox/attach#{i}.txt", 'w') do |f|
             f.write "#{attachment}"
             #puts "<br>attachment<bR>"
             end
             i=i+1
          end
        end
      end
  end
  
  
  
  def receive(email)
    #email.attachments are TMail::Attachment
    #but they ignore a text/mail parts.
    
    
    uniqueid =  HmmUser.find_by_sql("select UUID() as unid")
    uniqueid1=uniqueid[0].unid
    unid=uniqueid1
    require 'pp'
    
    pp email
    
    edate=email.date.strftime("%Y %m %d")
    
    esub=email.subject.gsub(":","").gsub("-","").gsub(",","").gsub(".","").gsub("/","").gsub(";","")
    if(File.exist?("#{RAILS_ROOT}/public/inbox/#{edate}#{esub}"))
    else
      dirname=Dir.mkdir("#{RAILS_ROOT}/public/inbox/#{edate}#{esub}")
    end
    email.parts.each_with_index do |part, index|
      filename = part_filename(part)
      filename ||= "#{index}.#{ext(part)}"
      filepath = "#{RAILS_ROOT}/public/inbox/#{edate}#{esub}/#{filename}"
      puts "WRITING: #{filepath}"
      File.open(filepath,File::CREAT|File::TRUNC|File::WRONLY,0644) do |f|
        f.write(part.body)
        if(File.exist?("#{RAILS_ROOT}/public/inbox/#{edate}#{esub}/Successful.csv"))
          begin
            data=FasterCSV.read("#{RAILS_ROOT}/public/inbox/#{edate}#{esub}/Successful.csv")
          rescue
            logger.info("#{RAILS_ROOT}/public/inbox/#{edate}#{esub}/Successful.csv ==> file problem")
          end  
            if(data!=nil )
              for row in data 
                # assuming the fields in the CSV file are in order npa, nxxFrom, nxxTo, trnk
                # create and save a Trunk model for each row
                countcheck=SuccessfulTransaction.count(:conditions =>"transactionID='#{row[4]}'")
                if(row[0]=='SubscriptionID'  || row[0]=='' || row[0]==nil )
                else
                  if(countcheck > 0 )
                  else
                   SuccessfulTransaction.create!(:subscriptionID => "#{row[0]}", :subscriptionStatus => "#{row[1]}", :payment => "#{row[2]}", :totalRecurrences  => "#{row[3]}", :transactionID => "#{row[4]}", :amount => "#{row[5]}", :currency => "#{row[6]}", :method => "#{row[7]}", :custFirstName => "#{row[8]}", :custLastName => "#{row[9]}", :respCode => "#{row[10]}", :respText => "#{row[11]}", :transdate => "#{email.date}" )
                  end
               end
              end
           end
          
        end
        
        
         if(File.exist?("#{RAILS_ROOT}/public/inbox/#{edate}#{esub}/Failed.csv"))
          begin
            data=FasterCSV.read("#{RAILS_ROOT}/public/inbox/#{edate}#{esub}/Failed.csv")
          rescue
            logger.info("#{RAILS_ROOT}/public/inbox/#{edate}#{esub}/Failed.csv ==> file problem")
          end  
            if(data!=nil )
              for row in data 
                # assuming the fields in the CSV file are in order npa, nxxFrom, nxxTo, trnk
                # create and save a Trunk model for each row
                countcheck=FailedTransaction.count(:conditions =>"transactionID='#{row[4]}'")
                if(row[0]=='SubscriptionID'  || row[0]=='' || row[0]==nil )
                else
                  if(countcheck > 0 )
                  else
                   FailedTransaction.create!(:subscriptionID => "#{row[0]}", :subscriptionStatus => "#{row[1]}", :payment => "#{row[2]}", :totalRecurrences  => "#{row[3]}", :transactionID => "#{row[4]}", :amount => "#{row[5]}", :currency => "#{row[6]}", :method => "#{row[7]}", :custFirstName => "#{row[8]}", :custLastName => "#{row[9]}", :respCode => "#{row[10]}", :respText => "#{row[11]}", :transdate => "#{email.date}" )
                  end
               end
              end
           end
          
         end
      end
    end
  end

  # part is a TMail::Mail
  def part_filename(part)
    # This is how TMail::Attachment gets a filename
    file_name = (part['content-location'] &&
      part['content-location'].body) ||
      part.sub_header("content-type", "name") ||
      part.sub_header("content-disposition", "filename")
  end

  CTYPE_TO_EXT = {
    'image/jpeg' => 'jpg',
    'image/gif'  => 'gif',
    'image/png'  => 'png',
    'image/tiff' => 'tif'
  }

  def ext( mail )
    CTYPE_TO_EXT[mail.content_type] || 'txt'
  end

end
