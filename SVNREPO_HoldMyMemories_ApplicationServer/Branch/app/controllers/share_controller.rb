class ShareController < ApplicationController
layout "guest"

  def memories
	   session[:share]="check"
       @presenter_name=HmmUser.find(:all, :joins => "as b, shares as a", :conditions => "a.unid='#{params[:id]}' and a.presenter_id=b.id")    
      params[:id]="#{@presenter_name[0]['id']}"
       
      @fname=@presenter_name[0]['v_fname']
      @shid=params[:id]
      shid=params[:id]
       session[:shid] = params[:id]
       session[:shareunid] = @presenter_name[0]['unid'] 
      shar=Share.find(params[:id])
      params[:id]=shar.presenter_id
	  @buttonVisibility = false
      email_list1=shar.email_list
      email_list=email_list1.split(",")
      newlist=email_list[0]
     # for emailfind in email_list
      #  if(logged_in_hmm_user.v_e_mail==emailfind || newlist==emailfind)
       # else
        #  newlist=newlist+","+emailfind
        #end
      #end
      
     
      filename = shar.xml_name
      sqlCmd = "select * from content_paths where content_path=\'"+shar.img_url+"\'";
      contentpath = Tag.find_by_sql(sqlCmd)
      puts contentpath[0].proxyname
     @swfName = "ShareCoverFlow"
     @galleryUrl = "/share/shared_moments_list/#{shar.id}"
     render :layout => true
	
 end
   
  def please_authenticate
    
  end
  
  def authenticate
    shareemail=params[:share]['email']
    sharepass=params[:share]['pass']
    puts shareemail
    puts sharepass
    id=params[:id]
    share_checkcount=Share.count(:all, :conditions =>"unid='#{id}' and password='#{sharepass}'")
    if(share_checkcount > 0 )
      share_checkid=Share.find(:all, :conditions =>"unid='#{id}' and password='#{sharepass}'")
      email_list=share_checkid[0].email_list
      email_array=email_list.split(',')
      for email in email_array
       #check for if email id exists in hmm database
        if(email==shareemail)
         
        end  
      end
      session[:share_auth]= params[:id]
         redirect_to :action => :memories, :id => params[:id]
    else
      session[:share_auth]=""
      
      redirect_to :action => :please_authenticate, :id => params[:id]
    end  
  
 end
  
def newpassgenerator( len )
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    0.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
end
  
  def addShare
    
    @share_max =  HmmUser.find_by_sql("select max(id) as n from shares")
     for share_max in @share_max
      share_max_id = "#{share_max.n}"
     end
     if(share_max_id == '')
      share_max_id = '0'
     end
     share_next_id= Integer(share_max_id) + 1
	  share  = Share.new
	  chars = ["A".."Z","a".."z","0".."9"].collect { |r| r.to_a }.join 
	  suffix = (1..8).collect { chars[rand(chars.size)] }.pack("C*")
	  filename = suffix+".xml"
	  share.xml_name =filename
	  share.created_date = Time.now
	  share.expiry_date = Time.now + 604800
	  share.presenter_id = "#{logged_in_hmm_user.id}"
	  share.email_list = params[:email]
    share.password=newpassgenerator(8)
	  fout = File.open("#{RAILS_ROOT}/public/share/#{filename}", "w")
	  fout.puts params[:xmlData]
	  fout.close
	  shareXml = XmlSimple.xml_in("#{RAILS_ROOT}/public/share/#{filename}") 
	  # me3ssage that needs to be sent. 
	  message = shareXml["message"]
    shareuuid=Share.find_by_sql("select uuid() as uid")
    share.message = shareXml["message"]
    share.unid=shareuuid[0].uid+""+"#{share_next_id}"
    share.save
    # farooq add the email code here.
    email_list=params[:email]
    email_array=email_list.split(',')
    for email in email_array
      #check for if email id exists in hmm database
      hmm_users = HmmUsers.find(:all, :conditions => "v_e_mail='#{email}'")
      @my_details=HmmUsers.find(logged_in_hmm_user.id)
     if((hmm_users[0] != nil) && hmm_users[0].v_e_mail.downcase==email.downcase)
      #params[:id]=logged_in_hmm_user.id
	   Postoffice.deliver_share(hmm_users[0].v_fname, hmm_users[0].v_e_mail,@my_details.v_fname,@my_details.v_e_mail,@my_details.v_myimage,hmm_users[0].v_user_name,hmm_users[0][:v_password],share.id, share.message)
     else
      Postoffice.deliver_shareunknown(email,@my_details.v_fname,@my_details.v_e_mail,@my_details.v_myimage,share.id, share.message,share.password,share.unid)
     end
    end
	  
    render :layout => false
  end
   
   
   def shareMemories
      @share  = Share.find(:joins => "as a, galleries as b", :conditions => "b.id=#{params[:id]} and a.id= b.")
      @shareUrl = ""
      
      
      if(@share[0].e_share_type == "video")
        logger.info("Share Type Video")
#        @swfName = "CoverFlowVideo"
#        @galleryUrl = "/myvideos/videoCoverflow/"+params[:id]
      
      elsif(@share[0].e_share_type == "image")
        logger.info("Share Type Image")
#        @swfName = "TileExplorer"
#        @galleryUrl = "/galleries/showGallery/"+params[:id]
      
      elsif(@share[0].e_share_type == "audio")
#        logger.info("Share Type Audio")
#        @swfName = "CoverFlowVideo"
      end
   end
  
   def photoMemories
      
    if(session[:share]=="check")
      
    end
  
  
    if(params[:Id])
       session[:usercontent_id]=params[:Id]
      @usercontent = UserContent.find(params[:Id])
   
      params[:Id]=@usercontent.sub_chapid
      @sub_chapter = SubChapter.find(params[:Id])
      params[:Id]=@usercontent.id
      @journals_photo = JournalsPhoto.find(:all,:conditions=>"user_content_id=#{params[:Id]}",:order=>"id DESC" )
 else
   session[:usercontent_id]=params[:id]
   @usercontent = UserContent.find(params[:id])
    params[:id]=@usercontent.id
   @journals_photo =JournalsPhoto.find(:all,:conditions=>"user_content_id=#{params[:id]}",:order=>"id DESC" )
 end
   @journal_cnt = JournalsPhoto.count(:all, :conditions =>"user_content_id=#{params[:id]}")
   end
   
   def getsharelist
     @sharelist = Share.find_by_sql("select * from shares where shares.presenter_id = #{logged_in_hmm_user.id}")  #Share.find(:all,:condition =>"presenter_id=#{params[:id]}")
     render :layout => false
   end
   
   def updateshare
     expirydate = Time.parse(params[:expirydate])
     @share = Share.find(params[:id])
     @share.expiry_date = Time.parse(params[:expirydate]);
     @share.save
     render :layout => false
    # sql = ActiveRecord::Base.connection();
    # sql.execute("update shares set shares.expiry_date='#{expirydate}' where shares.id=#{params[:id]}")
    #sql.commit_db_transaction
#     sharedata = Share.find(params[:id])
#     sharedata['expiry_date'] = Time.parse(params[:expirydate])
#     sharedata.save
   end
   
   def shareMoment_nonhmm
      @user_contentID = ShareMoment.find(:all, :joins => "as a, user_contents as b" , :conditions => "a.unid='#{params[:id]}' and a.usercontent_id=b.id")
      @unid = params[:id]
      @presenter_name = HmmUsers.find(:all, :joins => "as b, share_moments as a", :conditions => "a.unid='#{params[:id]}' and a.presenter_id=b.id")
      for j in @presenter_name
        params[:id] = j.v_fname
        @name = params[:id]
        params[:id] = j.id
        @shid = params[:id]
      end
     
   end
   
   def shareJournal_nonhmm
     @user_contentID = ShareJournal.find(:all, :joins => "as a, journals_photos as b" , :conditions => "a.unid='#{params[:id]}' and a.jid=b.id")
   end
   
   def shareJournalnonhmm_momentview
     
   end

  def deleteshare
    sql = ActiveRecord::Base.connection();
    sql.execute("delete shares from shares where shares.id=#{params[:id]}")
    sql.commit_db_transaction 
   end
   
  def shared_moments_list
    
    @shares=Share.find(params[:id])
    @shared_moments=SharedMomentId.find(:all, :conditions => "share_id=#{params[:id]}")
   render :layout => false
    
  end
   
end

  