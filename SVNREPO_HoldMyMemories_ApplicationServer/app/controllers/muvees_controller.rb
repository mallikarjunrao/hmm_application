class MuveesController < ApplicationController
  layout 'standard'
  require 'net/ftp'
  require 'soap/rpc/driver'
  require 'uri'
  require 'pp'
  require 'soap/wsdlDriver'
  
  def uploadfile
    
    if(params[:galid]==nil || params[:galid]=='')
    @subchapterid = params[:id]
    @galleries_col = Galleries.find(:all, :conditions=>"subchapter_id=#{params[:id]} and status='active' ")
   
    else
         @galleries_col = Galleries.find(:all, :conditions=>"id=#{params[:galid]} and status='active' ")
  end
      
    
     wsdl_url = 'http://whampoa-staging.muvee.com:8080/axis/services/MuveeService?wsdl'
  
     begin
    soap = SOAP::WSDLDriverFactory.new(wsdl_url).create_rpc_driver
    logger.info("successful soap rpc driver")
   rescue
    logger.info("Error soap rpc driver")
   end 

muveePassport = {
    'username' => 'mfanwar',
    'passcode' => 'softway'
   }

require 'pp'
@styles = soap.viewStyles(muveePassport)

pp @styles
end

 
  
  def test_webser
  
    begin
     ftp = Net::FTP.new("whampoa-staging.muvee.com")
      puts("successful ftp connection")
     ftp.login("mfanwar","softway")
      logger.info("logged in successfully")
    rescue
       logger.info("Error ftp connection")
    end
   
   ftp.passive = true
   i=0
   media=Array.new
  
   begin
     
    for filename in params[:chk]
      
      if(ftp.closed? == true)
          begin
            ftp.login("mfanwar","softway")
            logger.info("successful ftp authentication")
          rescue
            logger.info("Error ftp authentication failed")
        end
       
       end
       getfiletype=filename.split('.')
      exten=getfiletype[getfiletype.length-1]
      if(exten=='jpg' || exten=='png' || exten=='jpeg' || exten=='gif' || exten == 'bmp')
        type='image'
        newfile="#{RAILS_ROOT}/public/user_content/photos/coverflow/"+filename
     
      elsif(exten=='wmv' || exten=='flv' || exten=='avi' || exten=='mov' || exten=='mp4')
        type='video'
         newfile="#{RAILS_ROOT}/public/user_content/videos/"+filename
      elsif(exten=='mp3')
        type='audio'
         newfile="#{RAILS_ROOT}/public/user_content/audios/"+filename
     
         
      
      end
     
      logger.info("Transferring file #{filename}")
      ftp.putbinaryfile(newfile, "./#{filename}")
      logger.info("successful file transfer for file #{filename}")
     
      muveemedia1={"filename" => "#{filename}", "filetype" => "#{type}"}
      media.insert(i,muveemedia1)
      i=i+1
     end 
    
   rescue
        logger.info("Error ftp file transfer failed")
        ftp.close()
   end 
   
   
#   begin
#    for filename in params[:myFiles]
#      if(ftp.closed? == true)
#          begin
#            ftp.login("mfanwar","softway")
#            puts("sucessful ftp authentication")
#          rescue
#            puts("Error ftp authentication failed")
#          end
#       end
#      directory="public/video_images/"
#      path=File.join(directory,filename.original_filename)
#      File.open(path,"wb") { |f| f.write(filename.read) }
#      newfile="#{RAILS_ROOT}/public/video_images/"+filename.original_filename
#      if(ftp.closed? == true)
#          begin
#            ftp.login("mfanwar","softway")
#            logger.info("sucessful ftp authentication")
#          rescue
#            logger.info("Error ftp authentication failed")
#          end 
#      end
#       getfiletype=filename.original_filename.split('.')
#      exten=getfiletype[getfiletype.length-1]
#      if(exten=='jpg' || exten=='png' || exten=='jpeg' || exten=='gif')
#        type='image'
#      elsif(exten=='wmv' || exten=='flv' || exten=='avi' || exten=='mov' || exten=='mp4')
#        type='video'
#        
#      end
#      puts ("Transferring file #{filename}")
#      ftp.putbinaryfile(newfile, "./#{filename.original_filename}")
#      puts("sucessful file transfer for file #{filename}")
#     
#      muveemedia1={"filename" => "#{filename.original_filename}", "filetype" => "#{type}"}
#      media.insert(i,muveemedia1)
#      i=i+1
#    end
#   rescue
#        logger.info("Error ftp file transfer failed")
#        ftp.close()
#   end 
#   
   
   
   wsdl_url = 'http://whampoa-staging.muvee.com:8080/axis/services/MuveeService?wsdl'
   begin
    soap = SOAP::WSDLDriverFactory.new(wsdl_url).create_rpc_driver
    logger.info("successful soap rpc driver")
   rescue
    logger.info("Error soap rpc driver")
   end 
   
   jobData={'muveeMedia' => media, 'selectedCodec' => 'flv', 'selectedStyle' => "#{params[:style]}"}
   muveePassport = {
    'username' => 'mfanwar',
    'passcode' => 'softway'
   }
  #pp jobData
   begin
      jobid = soap.createMuvee(muveePassport,jobData)
         logger.info("successful job processed ")
   rescue
      logger.info("video creation failed")
   end 
   begin
      ftp.close
      logger.info("successful ftp server close ")
   rescue
      logger.info("Error ftp connection closing failed")
   end 
   
   redirect_to :controller => 'muvees', :action => 'show_video', :id => jobid
 end
 
 def check_progress
   render :layout => false
 end
 
 
 def show_video
   jobid=params[:id]
   if request.xml_http_request?
        render :partial => "statistic_list", :layout => false
     end
 end
 
 
 
 end
