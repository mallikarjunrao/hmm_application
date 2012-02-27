class StudioIntroController < ApplicationController


  before_filter  :check_account , :only => [:welcome] #checks for valid family name, terms of use check and user block check

  #method to check whether the family name in the url is valid or invalid
  #if family name doesn't exist, redirects to hmm home page
  #if user is blocked, displays message
  #if user didn't agee for terms of use,
  # => if the user is not logged in, takes to login page
  # => if the user is logged in, takes to agree terms page
  def check_account
    unless session[:studioid].blank?

      else
        redirect_to '/studio_intro/home'
      end
  end
 

  def home
    @get_content_url=ContentPath.find(:all, :conditions => "status='active'")
    content_path=@get_content_url[0]['content_path']
    servername=@get_content_url[0]['proxyname']
    @states=State.find(:all)
  end

 

  def create

    @maxid =  Tag.find_by_sql("select max(id) as m from studio_details")
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


        @pdetails = StudioDetail.new()
         logger.info(@pdetails)
        @pdetails['studio_name'] = params[:sname]
      
        @pdetails['address'] = params[:address]
        @pdetails['city'] = params[:city]
        @pdetails['country'] = params[:country]
        @pdetails['studio_phone'] = params[:sphone]
        @pdetails['website'] = params[:website]
        @pdetails['email'] = params[:email]
        @pdetails['name'] = params[:name]
        @pdetails['phone'] = params[:phone]
        @pdetails['username'] = @username
        @pdetails['password'] = @password
        @pdetails['children'] = params[:children]
        @pdetails['family'] = params[:family]
        @pdetails['maternity'] = params[:maternity]
        @pdetails['glamour'] = params[:glamour]
        @pdetails['high_school'] = params[:high_school]
        @pdetails['bridal']=params[:bridal]
        @pdetails['weddings']=params[:weddings]
        @pdetails['others']=params[:other_session]
        @pdetails['avg_sessions']=params[:avg_session]
         
        if(@pdetails.save)
           Postoffice.deliver_studio_signupinfo_user(params[:sname],params[:address],params[:city],params[:country],params[:sphone],params[:website],params[:name],params[:phone],params[:email],params[:children],params[:family],params[:maternity],params[:glamour],params[:high_school],params[:bridal],params[:weddings],params[:other_session],params[:avg_session])
           Postoffice.deliver_studio_introinfo(params[:name],params[:email],@password)
           redirect_to '/studio_intro/thankyou'
       end
 
  end


  def welcome
    @get_content_url=ContentPath.find(:all, :conditions => "status='active'")
    content_path=@get_content_url[0]['content_path']
    servername=@get_content_url[0]['proxyname']
    @states=State.find(:all)
  end

  def welcome_to_studio
    @get_content_url=ContentPath.find(:all, :conditions => "status='active'")
    content_path=@get_content_url[0]['content_path']
    servername=@get_content_url[0]['proxyname']
    @states=State.find(:all)
  end

  def welcome_create

    @maxid =  Tag.find_by_sql("select max(id) as m from studio_details")
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

        @pdetails = StudioDetail.new()
        @pdetails['studio_name'] = params[:sname]
        @pdetails['address'] = params[:address]
        @pdetails['city'] = params[:city]
        @pdetails['country'] = params[:country]
        @pdetails['studio_phone'] = params[:sphone]
        @pdetails['website'] = params[:website]
        @pdetails['email'] = params[:email]
        @pdetails['name'] = params[:name]
        @pdetails['phone'] = params[:phone]
        @pdetails['username'] = @username
        @pdetails['password'] = @password
        @pdetails['children'] = params[:children]
        @pdetails['family'] = params[:family]
        @pdetails['maternity'] = params[:maternity]
        @pdetails['glamour'] = params[:glamour]
        @pdetails['high_school'] = params[:high_school]
        @pdetails['bridal']=params[:bridal]
        @pdetails['weddings']=params[:weddings]
        @pdetails['others']=params[:other_session]
        @pdetails['avg_sessions']=params[:avg_session]
       
        if(@pdetails.save)
      Postoffice.deliver_studio_signupinfo_user(params[:sname],params[:address],params[:city],params[:country],params[:sphone],params[:website],params[:name],params[:phone],params[:email],params[:children],params[:family],params[:maternity],params[:glamour],params[:high_school],params[:bridal],params[:weddings],params[:other_session],params[:avg_session])

      #Postoffice.deliver_studio_introinfo(params[:name],params[:email],@password)

        redirect_to '/studio_intro/welcomethankyou'
        end
  end



 def authenticate
    logged_in_user = StudioDetail.count(:all,:conditions => "password='#{params[:password]}' ")
     @puserid = StudioDetail.find(:first,:conditions => "password='#{params[:password]}' ")

   if(logged_in_user > 0)
      session[:studioid]=@puserid.id
      redirect_to '/studio_intro/welcome'
   
   else
      flash[:conform_mesg] = "Invalid Access Code"
      redirect_to '/studio_intro/home'
    end

  end

end
