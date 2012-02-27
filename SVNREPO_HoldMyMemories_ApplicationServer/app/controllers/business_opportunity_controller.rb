class BusinessOpportunityController < ApplicationController
  
  def home
    
  end
  
  def welcome
    if(session[:puser_id])
     @pdetail=PhotographerDetail.find(:all,:conditions=>"id=#{session[:puser_id]}")
    end
  end
  
  def whatisthebusiness
    if(session[:puser_id])
  else
    redirect_to '/business_opportunity/login'
    end
  end
  
  def whatmarketsdoeshmmserve
    if(session[:puser_id])
  else
    redirect_to '/business_opportunity/login'
    end
  end
  
  def howdoimakemoney
    if(session[:puser_id])
  else
    redirect_to '/business_opportunity/login'
    end
  end
  def calculator
    if(session[:puser_id])
  else
    redirect_to '/business_opportunity/login'
    end
  end
  
  def whatdoesitcost
    if(session[:puser_id])
  else
    redirect_to '/business_opportunity/login'
    end
  end
  def whatdoeshmmprovide
    if(session[:puser_id])
  else
    redirect_to '/business_opportunity/login'
    end
  end
  def howtobecomeahmmphotographer
    if(session[:puser_id])
  else
    redirect_to '/business_opportunity/login'
    end
  end
  
  def stillnotsure
    if(session[:puser_id])
  else
    redirect_to '/business_opportunity/login'
    end
  end
  
  def frequentlyaskedquestions
    if(session[:puser_id])
  else
    redirect_to '/business_opportunity/login'
    end
  end
  
  def personalinfo
    if(session[:puser_id])
  else
    redirect_to '/business_opportunity/login'
    end
  end
  
  def submit_form
    
        @ppdetails = PhotographerPersonalDetail.new()
        @ppdetails['uid'] = session[:puser_id]
        @ppdetails['fname'] = params[:fname]
        @ppdetails['mname'] = params[:mname]
        @ppdetails['lname'] = params[:lname]
        @ppdetails['address'] = params[:address]
        @ppdetails['city'] = params[:city]
        @ppdetails['state_name'] = params[:state_name] 
        @ppdetails['zipcode'] = params[:zipcode] 
        @ppdetails['phone'] = params[:phone]
        @ppdetails['email'] = params[:email]
        @ppdetails['dob'] = params[:dob]
        @ppdetails['hobbies'] = params[:hobbies]
        @ppdetails['marital'] = params[:marital]
        @ppdetails['language'] = params[:language]
        @ppdetails['describe'] = params[:describe]
        @ppdetails['institution'] = params[:institution]
        @ppdetails['certificate'] = params[:certificate]
        @ppdetails['qualification'] = params[:qualification]
        @ppdetails['license'] = params[:license]
        @ppdetails['skills'] = params[:skills]
        @ppdetails['additional_info'] = params[:additional_info]
        @ppdetails['hobby'] = params[:hobby]
        @ppdetails['part_time'] = params[:part_time]
        @ppdetails['full_time'] = params[:full_time]
        @ppdetails['monday'] = params[:monday]
        @ppdetails['tuesday'] = params[:tuesday]
        @ppdetails['wednesday'] = params[:wednesday]
        @ppdetails['thursday'] = params[:thursday]
        @ppdetails['friday'] = params[:friday]
        @ppdetails['saturday'] = params[:saturday]
        @ppdetails['sunday'] = params[:sunday]
        @ppdetails['from_time'] = params[:from_time]
        @ppdetails['to_time'] = params[:to_time]
        @ppdetails['reference_name'] = params[:reference_name]
        @ppdetails['reference_title'] = params[:reference_title]
        @ppdetails['reference_address'] = params[:reference_address]
        @ppdetails['reference_phone'] = params[:reference_phone]
        @ppdetails['competent'] = params[:competent]
        @ppdetails['under_age'] = params[:under_age]
        @ppdetails['physical'] = params[:physical]
        @ppdetails['nationality_number'] = params[:nationality_number]
        @ppdetails['passport_number'] = params[:passport_number]
        @ppdetails['license_number'] = params[:license_number]
        @ppdetails['voters_number'] = params[:voters_number]
        @ppdetails['incometax_number'] = params[:incometax_number]
        @ppdetails['security_number'] = params[:security_number]
        @ppdetails['collegeid_number'] = params[:collegeid_number]
        @ppdetails['bankruptcy'] = params[:bankruptcy]
        @ppdetails['criminal'] = params[:criminal]
        @ppdetails['describe_crimes'] = params[:describe_crimes]
        @ppdetails['imprisoned'] = params[:imprisoned]
        @ppdetails['describe_imprisoned'] = params[:describe_imprisoned]
        @ppdetails['alcohol'] = params[:alcohol]
        @ppdetails['rehabilitation'] = params[:rehabilitation]
        @ppdetails['invest'] = params[:invest]
        @ppdetails['earn'] = params[:earn]
        
        if(@ppdetails.save)
        redirect_to '/business_opportunity/thankyou'
        else
        end
    
  end
  
  
  def create
    
    @maxid =  Tag.find_by_sql("select max(id) as m from photographer_details")
    for tag_max in @maxid
     max_id = "#{tag_max.m}"
    end
    if(max_id == '')
     max_id = '0'
    end
    next_id= Integer(max_id) + 1
    
    @uname=params[:name].delete(' ')


    @username="#{@uname}#{next_id}"
    @password=Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{next_id}--")[0,6]

        @pdetails = PhotographerDetail.new()
        @pdetails['name'] = params[:name]
        @pdetails['address'] = params[:address]
        @pdetails['city'] = params[:city]
        @pdetails['phone'] = params[:phone]
        @pdetails['email'] = params[:email]
        @pdetails['amount'] = params[:amount]
        @pdetails['join'] = params[:time]
        @pdetails['location'] = params[:location]
        @pdetails['exp_level'] = params[:level]
        @pdetails['username'] = @username
        @pdetails['password'] = @password
        if(@pdetails.save)
        Postoffice.deliver_photographer_introinfo(params[:name],params[:address],params[:city],params[:phone],params[:email])
        redirect_to '/business_opportunity/thankyou'
        end
  end
  
  def login
     
  end
  
  
  def logout
     @plog = PhotographerLog.find(session[:plogid])
     @plog.logout_time = Time.now;
     @plog.save
    reset_session
    flash[:notice] = "You Have Successfully Logged Out."
    redirect_to :action => 'login'
  end
  
   def page_expire
     
  end
  
   def authenticate
    logged_in_user = PhotographerDetail.count(:all,:conditions => "username='#{params[:username]}' and password='#{params[:password]}' and account_status='accepted' ")
     @puserid = PhotographerDetail.find(:all,:conditions => "username='#{params[:username]}' and password='#{params[:password]}' and account_status='accepted' ")
    
   if(logged_in_user > 0)
   
   if(@puserid[0]['account_expire_date'] >= Time.now)
      session[:puser_id]=@puserid[0]['id']

        @plog = PhotographerLog.new()
        @plog['username'] = @puserid[0]['username']
        @plog['name'] = @puserid[0]['name']
        @plog['login_time'] = Time.now
        @plog.save
        last_index = PhotographerLog.find(:first, :order => "id desc").id

        session[:plogid]=last_index

      redirect_to '/business_opportunity/welcome'
   else
      redirect_to '/business_opportunity/page_expire'
   end
   else
      flash[:conform_mesg] = "Invalid Username or Password"
      redirect_to '/business_opportunity/login'
    end
    
  end
  
end
