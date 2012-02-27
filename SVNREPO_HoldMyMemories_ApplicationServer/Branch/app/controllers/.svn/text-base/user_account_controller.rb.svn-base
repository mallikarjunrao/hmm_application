class UserAccountController < ApplicationController
#layout "standard"
  def login
    if session[:hmm_user]
      @hmm_user=HmmUsers.find(session[:hmm_user])  
    end
    if session[:employe]
      redirect_to :controller => 'account', :action => 'my_customers'
    end
  end

  def authenticate 
   #redirect_to index_url+'account/'
   
   self.logged_in_hmm_user = HmmUser.authenticate(params[:hmm_user][:v_user_name],params[:hmm_user][:v_password])
   #self.logged_in_hmm_user = HmmUser.authenticate("alok","alok")
    if is_userlogged_in?
      if logged_in_hmm_user.e_user_status == 'unblocked'
       #log file entry 
       logger.info("[User]: #{params[:hmm_user][:v_user_name]} [Logged In] at #{Time.now} !")
      
      @client_ip = request.remote_ip 
      @user_session = UserSessions.new()
      @user_session['i_ip_add'] = @client_ip
      @user_session['uid'] = logged_in_hmm_user.id 
      @user_session['v_user_name'] = logged_in_hmm_user.v_user_name
      @user_session['d_date_time'] = Time.now
      @user_session['e_logged_in'] = "yes"
      @user_session['e_logged_out'] = "no"
      @user_session.save
    #  return "true"
    session[:alert] = "fnfalert"
      if(params[:friend_id]!=nil)
      session[:friend]=params[:friend_id]
        
        redirect_to "http://www.holdmymemories.com/customers/profile/#{params[:friend_id]}"
    else
       if(params[:shareid]!=nil)
        
        if(params[:accept]!=nil)
           
            redirect_to "http://www.holdmymemories.com/tags/memories/#{params[:shareid]}"
        else
           
           redirect_to "http://www.holdmymemories.com/tags/rejectshare/#{params[:shareid]}"
        end
    end  
  end
    
    flag = 0     
    cur_time=Time.now.strftime("%Y-%m-%d")
            @hmm_user_check =  HmmUser.count(:all, :conditions =>" account_expdate <= '#{cur_time}' and id='#{logged_in_hmm_user.id}'")
            if @hmm_user_check > 0
                @hmm_user_max =  HmmUser.find_by_sql(" select account_expdate as m from hmm_users where id='#{logged_in_hmm_user.id}'")
                nextbilingdate = @hmm_user_max[0]['m']
                
                
           else
                nextbilingdate = "#{logged_in_hmm_user.account_expdate}"
               
           end
            if(nextbilingdate == nil || nextbilingdate == "")
              flag = 1
                  
                  flash[:error] = "Your Subscription has been expired. Please provide the new credit card details for renewal of your account."
                
              nextbilingdate2 = "Subscription Expired/cancelled"
              renewal_days = "Subscription already expired"
            else
                nextbilingdate1=nextbilingdate.split('-');
                nextbilingdate2="#{nextbilingdate1[1]} - #{nextbilingdate1[2]} - #{nextbilingdate1[0]}"
                @hmm_leftdays=HmmUser.find_by_sql("  SELECT DATEDIFF('#{nextbilingdate1}',CURDATE( ) ) as d  ")
                renewal_days = Integer(@hmm_leftdays[0]['d'])
                if(renewal_days <= 0)
                  flag = 1
                  
                  flash[:error] = "Your Subscription has been expired. Please provide the new credit card details for renewal of your account."
                
                  
                end
            end 
            if logged_in_hmm_user.substatus=="suspended" 
              flag = 1
              flash[:error] = "Your credit card payment to you HoldMyMemories.com has been declined by your credit card company. This could be for a number of reasons, including an expired card. <br><br><br>Please re-enter your credit card information, or use a different card for the renewal of your account."
              
            
              
            end
        
    if(params[:friend_id]==nil && params[:shareid]==nil )
      if(logged_in_hmm_user.v_e_mail=="Please update email")
        redirect_to "http://www.holdmymemories.com/customers/update_email" 
      else
        if(logged_in_hmm_user.cancel_status=="approved" && flag==1)
          session[:flag]=1
          redirect_to "http://www.holdmymemories.com/customers/upgrade/platinum_account" 
        else
          session[:flag]=''
         redirect_to "http://www.holdmymemories.com/tags/gohome" 
         
        end 
      end   
    end
    
    
    
  else
   reset_session
    flash[:error1] = "User is been blocked.. Contact Admin!!"
   redirect_to "https://www.holdmymemories.com/user_account/login"
 end
 
 else
      flash[:error] = "I'm sorry; either your username or password was incorrect."
       #log file entry
      logger.error("[Invalid Login]: by [User]:#{params[:hmm_user][:v_user_name]} at #{Time.now}") 
      redirect_to :action => 'login'
     return "false"
    end
    
    
  end
  
  
  
   
  def logout
     if(session[:hmm_user])
        @user_session = UserSessions.new()
        if(logged_in_hmm_user.id)
          @user_session['uid'] = logged_in_hmm_user.id 
        end
        if(logged_in_hmm_user.v_user_name) 
          @user_session['v_user_name'] = logged_in_hmm_user.v_user_name
        end
     end    
    if request.post?
        
        reset_session
        flash[:notice] = "You Have Been Successfully logged out." 
        @client_ip = request.remote_ip 
       
       if(session[:hmm_user])
        @user_session['d_date_time'] = Time.now
        @user_session['i_ip_add'] = @client_ip
        @user_session['e_logged_in'] = "no"
        @user_session['e_logged_out'] = "yes"
        @user_session.save
       end 
   end
    #log file entry
   #logger.info("[User]: Logged Out at #{Time.now}") 
   redirect_to :action => 'login'
 end
 
 
 
 def index
   id=params[:id]
   if(id=='' || id==nil)
   else
   
    redirect_to :action => 'my_familywebsite', :action => 'index', :id => id
   end
   if session[:hmm_user]
      @hmm_user=HmmUsers.find(session[:hmm_user])  
   end
 end
 
 def Scripts
   
 end
 
 def forgot_password
      # @email = HmmUsers.find(:all, :conditions => [ "v_e-mail LIKE ?", @searchphrase])
      @results = HmmUsers.find(:all)
 end
 
 def forgot_live
   
   @phrase = request.raw_post.chop || request.query_string
   @searchphrase = @phrase
   @results = HmmUsers.find(:all, :conditions => [ "v_user_name LIKE ?", @searchphrase])
   @number_match = @results.length
   render(:layout => false)
 end

def forgot_security_q
   @phrase1 = request.raw_post.chop || request.query_string
   @searchphrase1 = @phrase1
   @results1 = HmmUsers.find(:all, :conditions => [ "id='#{params[:id]}' and  v_security_a LIKE ?", @searchphrase1])
   @number_match1 = @results1.length
   if @results1.empty?
   else
    for @i in @results1
       name=@i['v_fname']
       @email=@i['v_e_mail']
       username=@i['v_user_name']
       pass=@i['v_password']
     end
      Postoffice.deliver_deliverpass(name, @email, username, pass)
  
   end
   render(:layout => false)
 end

  def takeTour
    
  end
  
  def iphonelogin 
   #redirect_to index_url+'account/'
   
   self.logged_in_hmm_user = HmmUser.authenticate(params[:v_user_name],params[:v_password])
   #self.logged_in_hmm_user = HmmUser.authenticate("alok","alok")
    if is_userlogged_in?
      if logged_in_hmm_user.e_user_status == 'unblocked'
         #log file entry 
        logger.info("[User]: #{params[:v_user_name]} [Logged In] at #{Time.now} !")
        @sucess=1
        
      else
        reset_session
        #flash[:error1] = "User is been blocked.. Contact Admin!!"
        @blocked=1
        @sucess=-1
      end
    else
      reset_session
      #flash[:error] = "I'm sorry; either your username or password was incorrect."
       #log file entry
       logger.error("[Invalid Login]: by [User]:#{params[:v_user_name]} at #{Time.now}") 
       @sucess=-1
       return "false"
    end
    render (:layout => false)
    
  end
  
  def logoutiphone
    reset_session
    #redirect_to "/user_account/iphonelogin"
    render(:layout => false)
  end

end


