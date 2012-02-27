class MobileHmmUsersController < ApplicationController
  require 'json/pure'
  before_filter :response_header # add json header to the output
  layout false

  def response_header
    response.headers['Pragma' ] = 'no-cache'
    response.headers['Cache-Control' ] = 'no-store, no-cache, max-age=0, must-revalidate'
    response.headers['Content-Type' ] = 'text/x-json'
  end

  # login service for the mobile application
  # input:username,password
  # output:json
  # created by :parthi


  def iphone_login
    @retval = Hash.new()
    if ((params[:username] && params[:password] && !params[:username].blank? && !params[:password].blank?) || params[:myhmm] && !params[:email].blank?) #check for username and password input
      if params[:myhmm] #this is for MyHHM App login from facebook create account if not else login with email id
        user_exists=MobileHmmUser.count(:all,:conditions=>"v_user_name='#{params[:email]}' || v_e_mail='#{params[:email]}'")
        if user_exists>0
          @login = MobileHmmUser.find(:first,:conditions=>"(v_user_name='#{params[:email]}' || v_e_mail='#{params[:email]}') && e_user_status='unblocked'",:select=>'id, account_type,family_name')
        else
          @get_content_url=ContentPath.find(:all, :conditions => "status='active'")
          content_path=@get_content_url[0]['content_path']
          randomtext = self.genpass()
          redirect_to "#{content_path}/mobile_hmm_users/iphone_signup_free?username=#{params[:email]}&&password=#{randomtext}&&email=#{params[:email]}&&first_name=#{params[:first_name]}&&last_name=#{params[:last_name]}&&dob=#{params[:dob]}&&gender=#{params[:gender]}&&check_memory_lane_album_created=#{params[:check_memory_lane_album_created]}"
          return
        end
      else
        @login = MobileHmmUser.find(:first,:conditions=>{:v_user_name=>params[:username],:v_password=>params[:password],:e_user_status=>'unblocked'},:select=>'id, account_type,family_name')
      end
      if(@login)
        if(@login.account_type=='free_user')
          account_type='freeaccount'
        elsif(@login.account_type=='familyws_user')
          account_type='familywebsiteaccount'
        elsif(@login.account_type=='platinum_user')
          account_type='premiumaccount'
        end
        mobile_upload = MobileTag.find(:first,:conditions => "uid = #{@login.id} and tag_type = 'mobile_uploads'")
        MobileTag.save_mobile_uploads_chapter(@login.id) if mobile_upload == nil #create mobile_uploads chapter, if it is not there by default
        if params[:check_memory_lane_album_created]
          mobile_upload = MobileTag.find(:first,:conditions => "uid = #{@login.id} and tag_type = 'mobile_uploads'")
          memory_mane_album = SubChapter.find(:first,:conditions => "uid = #{@login.id} and tagid=#{mobile_upload.id} and subchapter_type = 'memory_lane' and status='active'")
          times = Time.new
          if memory_mane_album == nil
            MobileSubChapter.save_memory_lane_subchapter("#{times.year} (Uncategorized)",'Enter description here...',@login.id,mobile_upload.id) #create memory lane subchapter, if it is not there by default
          else
            times = Time.new
            sub_crr_year=SubChapter.find(:first,:conditions => "uid = #{@login.id} and tagid=#{mobile_upload.id} and 	d_created_on >'#{times.year}-1-1 00:00:00' and d_created_on <'#{times.year}-12-31 23:59:59' and subchapter_type = 'memory_lane' and status='active'")
            if sub_crr_year == nil
              memory_mane_album.subchapter_type="old_memory_lane";
              memory_mane_album.save
              MobileSubChapter.save_memory_lane_subchapter("#{times.year} (Uncategorized)",'Enter description here...',@login.id,mobile_upload.id)
            end
          end
        end
        @retval['account_type'] = account_type
        @retval['body'] = @login
        @retval['status'] = true
        render :text => @retval.to_json # render output
      else
        @retval['message'] = 'Invalid Login Details!'
        @retval['status'] = false
        render :text => @retval.to_json # render output
      end
     else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
      render :text => @retval.to_json # render output
    end
  end

  # registration service for the mobile application
  # input: username,password,email,dob,gender
  # output: json
  # created by: parthi

  def iphone_signup
    @retval = Hash.new()
    if !params[:username].blank? && !params[:password].blank? #checking input data presence
      @user = MobileHmmUser.find(:first,:conditions=>{:v_user_name=>params[:username]},:select=>'id')
      if @user #checking username existence
        @retval['status'] = false
        @retval['message'] = 'Username already exists!'
      else
        @user = MobileHmmUser.find(:first,:conditions=>{:v_e_mail=>params[:email]},:select=>'id')
        if @user #checking email existence
          @retval['status'] = false
          @retval['message'] = 'Email already exists!'
        else
          @user = MobileHmmUser.find(:first,:conditions=>{:family_name=>params[:family_name]},:select=>'id')
          if @user #checking email existence
            @retval['status'] = false
            @retval['message'] = 'Family name already exists!'
          else
            @get_content_url=ContentPath.find(:all, :conditions => "status='active'")#get the content path from the table
            content_path=@get_content_url[0]['content_path']
            @hmmuser = MobileHmmUser.new()
            @hmmuser['v_e_mail'] = params[:email]
            @hmmuser['v_user_name'] = params[:username]
            @hmmuser['v_password'] = params[:password]
            @hmmuser['d_bdate'] = params[:dob]
            @hmmuser['e_sex'] = params[:gender]
            @hmmuser['v_security_q']='NA'
            @hmmuser['v_security_a']='NA'
            @hmmuser['d_updated_date']=Time.now()
            @hmmuser['v_abt_me']='NA'
            @hmmuser['d_created_date']=Time.now()
            @hmmuser['v_country']='USA'
            @hmmuser['v_zip']='NA'
            @hmmuser['v_link1']='NA'
            @hmmuser['v_link2']='NA'
            @hmmuser['v_link3']='NA'
            @hmmuser['v_lname']='NA'
            @hmmuser['v_fname']='NA'
            #@hmmuser['d_bdate']= Date.today()
            @hmmuser['img_url']=content_path
            @exp_date_cal =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL 1 MONTH) as m") #calculate account expiry date
            account_expdate= @exp_date_cal[0]['m']
            @hmmuser['account_expdate'] = account_expdate
            if params[:gender]=='F' # assign profile image according to the gender
              @hmmuser['v_myimage']="default_female.jpg"
            else
              @hmmuser['v_myimage']="blank.jpg"
            end

            if params[:family_name]!=nil
              @hmmuser['family_name'] = params[:family_name]
            else
              @uuid =  HmmUser.find_by_sql(" select UUID() as u")
              unnid = @uuid[0]['u']
              prev_user = HmmUser.find(:last,:select => "id")
              if prev_user
                hmm_user_next_id= Integer(prev_user.id) + 1
              else
                hmm_user_next_id = 1
              end
              @hmmuser['family_name']="#{hmm_user_next_id}#{unnid}un#{hmm_user_next_id}"
            end



            if @hmmuser.save()
              @retval['message'] = 'User registered successfully!'
              @retval['user_id'] = @hmmuser.id
              @retval['status'] = true
            else
              @retval['status'] = false
              @retval['message'] = 'Registration failed'
            end
          end
        end
      end

    else
      @retval['status'] = false
      @retval['message'] = 'Incomplete data provided!'
    end
    render :text => @retval.to_json # render output
  end

  # forgot password service for the mobile application
  # input: email
  # output: json
  # created by: parthi

  def forgot_password
    @retval = Hash.new()
    if !params[:email].blank?
      @data = MobileHmmUser.find(:first, :conditions => "v_e_mail='#{params[:email]}'")
      if @data
        name=@data['v_fname']
        @email=@data['v_e_mail']
        username=@data['v_user_name']
        pass=@data['v_password']
        Postoffice.deliver_deliverpass(name, @email, username, pass)
        @retval['status'] = true
        @retval['message'] = 'Your account details are sent to your email!'
      else
        @retval['status'] = false
        @retval['message'] = 'Email doesn\'t exist!'
      end
    else
      @retval['status'] = false
      @retval['message'] = 'Incomplete data provided!'
    end
    render :text => @retval.to_json # render output
  end

  # User profile service for the mobile application
  # input: user_id
  # output: json
  # created by: parthi
  def user_profile
    @retval = Hash.new()
    if !params[:user_id].blank?
      @user = MobileHmmUser.find(:first,:conditions=>{:id=>params[:user_id]},:select=>"v_fname as `First Name`,v_lname as `Last Name`,v_user_name as Username,v_e_mail as Email,CONCAT('http://#{request.domain(1)}','/',family_name) as family_website_url")
      if @user
        @retval['status'] = true
        @retval['body'] = @user
      else
        @retval['status'] = false
        @retval['message'] = 'User not found!'
      end
    else
      @retval['status'] = false
      @retval['message'] = 'Incomplete data provided!'
    end
    render :text => @retval.to_json # render output
  end

  def update_user_profile
    @retval = Hash.new()
    if !params[:user_id].blank?
      @user = MobileHmmUser.update(params[:user_id],:v_e_mail=>params[:email],:d_bdate=>params[:dob],:e_sex=>params[:gender],:v_fname=>params[:first_name],:v_lname=>params[:last_name])
      if @user
        @retval['status'] = true
        @retval['body'] = "Profile updated succesfully!"
      else
        @retval['status'] = false
        @retval['message'] = 'User not found!'
      end
    else
      @retval['status'] = false
      @retval['message'] = 'Incomplete data provided!'
    end
    render :text => @retval.to_json # render output
  end

  def update_password
    @retval = Hash.new()
    if !params[:user_id].blank? && !params[:password].blank? #checking input data presence
      @user = MobileHmmUser.update(params[:user_id],:v_password=>params[:password])
      if @user
        @retval['status'] = true
        @retval['body'] = "Profile updated succesfully!"
      else
        @retval['status'] = false
        @retval['message'] = 'User not found!'
      end
    else
      @retval['status'] = false
      @retval['message'] = 'Incomplete data provided!'
    end
    render :text => @retval.to_json # render output
  end

  def get_address_book_contacts
    @retval = Hash.new()
    if !params[:user_id].blank?
      @contacts = NonhmmUser.find(:all,:conditions => "uid=#{params[:user_id]} and v_status='yes'",:select=>"v_name as contact_name,v_email as contact_email")
      @retval['status'] = true
      @retval['body'] = @contacts
    else
      @retval['status'] = false
      @retval['message'] = 'Incomplete data provided!'
    end
    render :text => @retval.to_json # render output
  end


  def genpass
    list=("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    genpass = ""
    1.upto(10) { |i| genpass << list[rand(list.size-1)] }
    return genpass

  end

end