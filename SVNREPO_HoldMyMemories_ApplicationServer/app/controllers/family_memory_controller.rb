class FamilyMemoryController < ApplicationController
  layout :pp_s121_other
  require 'will_paginate'
  include FamilyMemoryHelper
  require 'json/pure'
  helper :user_account
  before_filter  :redirect_url
  before_filter :authenticate_user, :only => [:view, :upload, :order_prints, :upgrade_account_form, :upgrade_payment_family, :familywebsite_option, :upgrade_account_success,:edit_profile]
  before_filter :check_account_public, :except => [:view, :upload, :order_prints, :upgrade_account_form, :upgrade_payment_family, :familywebsite_option, :upgrade_account_success,:edit_profile]

  def pp_s121_other
    if @family_website_owner.studio_id==0
      return  "family_memory"
    else
      @studio_header = HmmStudio.find(@family_website_owner.studio_id)
      if @studio_header.studio_groupid==pp_studio_group
        return "pp_family_memory"
      else
        return  "family_memory"
      end
    end
  end

  def redirect_url
    url= request.url.split("/")
    for i in 0..url.length
      if url[i]
        url[i]=url[i].upcase
        logger.info(url[i])
        if((url[i].match("<SCRIPT>")) || (url[i].match("</SCRIPT>")) || (url[i].match("</SCRIP>")) || (url[i].match("<SCRIP")) ||(url[i].match("JAVASCRIPT:ALERT"))||(url[i].match("%3C")))
          redirect_to "/nonexistent_page.html"
        end
      end
    end
  end

  def check_account_public
    unless params[:id].blank?
      @family_website_owner = HmmUser.find(:first,:conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')",:select => "hmm_users.*") #get the user details
      if @family_website_owner
        if (@family_website_owner.account_expdate!=nil && @family_website_owner.account_expdate < Date.current())

          flash[:expired] = 'expired'
          #redirect_to "/familywebsite/login/#{params[:id]}" if params[:action]!='login' unless (session[:hmm_user]==@family_website_owner.id)
        elsif(session[:employe]==nil && @family_website_owner.terms_checked == 'false' ) #if the logged in user is not employee and terms is not agreed
          flash[:terms] = 'terms'
          if(session[:hmm_user]) #f the user is logged in, takes to agree terms page
            redirect_to "/user_account/update_terms/"
          else #if the user is not logged in, takes to login page
            #redirect_to "/familywebsite/login/#{params[:id]}" if params[:action]!='login'
          end
        elsif @family_website_owner.e_user_status=='blocked' #displays message, if the user is blocked
          render :text => "This Familywebsite has been Blocked. Please contact Website Administrator at <a href='mailto:admin@holdmymemories.com' >admin@HoldMyMemories.com</a>"
        elsif (session[:visitor]==nil || session[:visitor]!=@family_website_owner.family_name) &&  session[:hmm_user] != @family_website_owner.id && @family_website_owner.password_required == 'yes'
          #render :text =>"Password protected. Redirect to family website login page"
          if(params[:facebook]=='true')
            session[:visitor]=@family_website_owner.family_name
          else
            redirect_to :controller =>"familywebsite", :action => 'visitor_login', :id => params[:id], :redirect_url => request.url if (params[:action]!='login' && params[:action]!='visitor_login' && params[:action]!='forgot_password')
          end

        else

        end
      else

        redirect_to '/'
      end
    end

    @path1 = ContentPath.find(:all)
    @path=""
    for path in @path1
      @path="#{@path}#{path.content_path},"
    end
    #    if(params[:id]=='bob')
    #      @content_server_url = "http://content.holdmymemories.com"
    #    else
    #      @content_server_url = "#{@path}"
    #      @img_url=@path1[0].content_path
    #    end
    return true #returns true if all the conditions are cleared
  end

  #Authenticate User
  def authenticate_user
    unless params[:id].blank?
      @family_website_owner = HmmUser.find(:first, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')") #get the user details
      if @family_website_owner
        if(session[:employe]==nil && @family_website_owner.terms_checked == 'false' ) #if the logged in user is not employee and terms is not agreed
          flash[:terms] = 'terms'
          if(session[:hmm_user]) #f the user is logged in, takes to agree terms page
            redirect_to "/user_account/update_terms/"
          else #if the user is not logged in, takes to login page
            redirect_to "/family_memory/home/#{params[:id]}"
          end
        elsif @family_website_owner.e_user_status=='blocked' #displays message, if the user is blocked
          render :text => "This Familywebsite has been Blocked. Please contact Website Administrator at <a href='mailto:admin@holdmymemories.com' >admin@HoldMyMemories.com</a>"
        elsif session[:visitor]==nil && session[:hmm_user]==nil && @family_website_owner.password_required == 'yes'
          #render :text =>"Password protected. Redirect to family website login page"
          if(params[:facebook]=='true')
            session[:visitor]=@family_website_owner.family_name
          else
            redirect_to "/family_memory/home/#{params[:id]}"
          end
        elsif (!session[:hmm_user] || logged_in_hmm_user.id!=@family_website_owner.id)
          redirect_to "/family_memory/home/#{params[:id]}"
        else
          #          @path = ContentPath.find(:first, :conditions => "status='active'")
          #          @content_server_url = @path.content_path
          return true #returns true if all the conditions are cleared
        end
      else
        redirect_to '/'
      end
    end
  end

  def home
    @paths = ContentPath.find(:first,:conditions=>"status='active'")
    @path1 = ContentPath.find(:all)
    @path=""
    for path in @path1
      @path="#{@path}#{path.content_path},"
    end
    if(params[:id]=='bob')
      @content_server_url = "http://content.holdmymemories.com"
    else
      @content_server_url = "#{@path}"
      @img_url=@path1[0].content_path
    end
    cond=self.subchapter_public()
    @subchapters=SubChapter.find(:all,:select=>"id,store_id",:conditions=>"store_id!='' #{cond} and uid=#{@family_website_owner.id} and status='active'")
    if @subchapters.length>0
      sub=[]
      for subchapter in @subchapters
        sub.push(subchapter.id)
      end
      sub=sub.join(',')
      cond1=self.gallery_public()

      galleries_lists=[]
      gallery_imgs=UserContent.find(:all,:select=>"distinct(gallery_id)",:conditions=>"sub_chapid in (#{sub}) and status='active' #{cond} and (e_filetype='image' or e_filetype='video')")
      if gallery_imgs
        if gallery_imgs.length>0
          for  gallery_img in gallery_imgs
            galleries_lists.push(gallery_img.gallery_id)
          end
          galleries_lists=galleries_lists.join(",")

          @gals=MobileGallery.find(:all,:joins=>"as a,sub_chapters as b",:select=>"a.id,v_gallery_name,d_gallery_date,a.img_url,v_gallery_image,b.sub_chapname,b.store_id",:conditions=>"a.status='active' and a.subchapter_id=b.id #{cond1} and a.id in (#{galleries_lists})",:group=>"a.id",:order=>"d_gallery_date desc")
          if(!@gals.nil?)
            if(@gals.length>0)
              @galleryUrl = ""

              @swfName1 = "/flash/debug/ShareCoverflow_V4.swf"
              if params[:search_albums]
                @galleryUrl = "/family_memory/search_album_facebook_share/#{params[:id]}?search=#{params[:search]}"
              elsif params[:search_moments]
                @galleryUrl = "/family_memory/search_moments_facebook_share/#{params[:id]}?searchval=#{params[:searchval]}&&type_id=#{params[:type_id]}&&type=#{params[:type]}"
              else
                @galleryUrl = "/family_memory/homepage_facebook_share/"+params[:id]
              end
              imgs=[]
              for gal in @gals
                imgss=gal.v_gallery_image
                imgss.slice!(-3..-1)
                img="#{gal.img_url}/user_content/photos/flex_icon/#{imgss}jpg"
                imgs.push(img)
              end
              @proxyurls = get_proxy_urls()

              subdomain = request.subdomains[0]
              logger.info(subdomain)
              current= request.url.split("http://")
              current1= current[1].split("/")
              if current1[0]=="holdmymemories.com"
                @app_url="http://holdmymemories.com"
              else
                @app_url="http://www.holdmymemories.com"
              end
              logger.info(current1[0])
              logger.info("@app_url")
              @share_image = imgs
              url="http://#{subdomain}.holdmymemories.com#{@galleryUrl}&buttonsVisible=false&contenturl=#{@proxyurls},http://content.holdmymemories.com,http://content1.holdmymemories.com&website_type=familywebsite_v4&&data_type=gallery&user_id=#{@family_website_owner.id}&familyName=#{params[:id]}&domainName=#{@path1[0].proxyname}&app_url=#{@app_url}"
              @share_video = "http://#{subdomain}.holdmymemories.com#{@swfName1}?serverUrl=#{url}"
              logger.info("*********************************")
              logger.info @share_video.inspect
              @share_type = "video"
            end
          end
        end
      end
    end
  end

  def upgrade_account_form
    @hmm_user=HmmUser.find(@family_website_owner.id)
    if @hmm_user.account_type =="platinum_user"
      @account_type="Premium Account"
    elsif @hmm_user.account_type =="familyws_user"
      @account_type="Family Website"
    else
      @account_type="Free Account"
    end
  end

  def upgrade_account_success

  end

  def upgrade_account

  end

  def generate_receipt
    @hmm_user=HmmUser.find(@family_website_owner.id)
    render :layout => false
  end

  def familywebsite_option

  end

  def pop1
    @current_item = 'account_settings'
    @credit_count=CreditPoint.count(:all,:conditions=>"user_id=#{@family_website_owner.id}")
    @benefits = ""
    #unless @credit_count==0
    @credit_points=CreditPoint.find(:first,:conditions => "user_id=#{@family_website_owner.id}")
    @studio_groups=HmmUser.find(:first,:select => "a.*,b.*,c.*,d.* ", :joins =>"as a ,employe_accounts as b,hmm_studios as c,hmm_studiogroups  as d ",:conditions => "a.id=#{@family_website_owner.id} and b.id=a.emp_id and b.store_id=c.id and c.studio_groupid=d.id ")
    if(@studio_groups)
      studiogroup_benefits = StudioBenefit.find(:all,:conditions => "studio_group_id=#{@studio_groups.studio_groupid}",:select => "*")
      studio_benefits = StudioBenefit.find(:all,:conditions => "studio_id=#{@studio_groups.store_id}",:select => "*")
      @benefits = studiogroup_benefits + studio_benefits
    end
    render :layout => false
  end

  def pop2
    @current_item = 'account_settings'
    render :layout => false
  end

  def upgrade_payment_family
    card_no=params[:card_no]
    cvv_no=params[:cardcvv_no]
    expiry_date="#{params[:exp_year]}-#{params[:exp_month]}"
    exp_month=params[:exp_month]
    exp_year=params[:exp_year]
    fname=params[:fname]
    lname=params[:lname]
    #amount=Integer(params[:amount])
    street_address = params[:street_address]
    #suburb = params[:suburb]
    postcode = params[:postcode]
    city = params[:city]
    state = params[:state]
    country = params[:country]
    telephone = params[:telephone]
    fax = params[:fax]
    months=params[:months]
    account_type=params[:account_type]
    email = params[:email]
    invoicenumber = "HMM000HMM#{params[:hmm_id]}"
    if(logged_in_hmm_user.subscriptionnumber.nil? || logged_in_hmm_user.invoicenumber!="")
      invoicenumber = "HMM000HMM#{params[:hmm_id]}"
    else
      if(logged_in_hmm_user.subscriptionnumber=="One time payment")
        invoicenumber = "HMMAP0HMM#{params[:hmm_id]}"
      end
    end
    subnumber = logged_in_hmm_user.subscriptionnumber

    #if(logged_in_hmm_user.account_type=='free_user')
    @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL #{months} MONTH) as m")
    #else
    #@hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE('#{logged_in_hmm_user.account_expdate}',INTERVAL #{months} MONTH) as m")
    #end

    account_expdate= @hmm_user_max[0]['m']

    @uuid =  HmmUser.find_by_sql(" select UUID() as u")

    unid = "#{@uuid[0]['u']}000#{params[:hmm_id]}"
    if(account_type == "familyws_user")
      acctype="family_website"
      if(months == "1")
        amount = 4.95
        amttest=495
        amount1 = "$4.95"
      end
      if(months == "6")
        amount = 4.95
        amttest=2495
        amount1 = "$24.95"
      end
      if(months == "12")
        amount = 4.95
        amttest=4995
        amount1 = "$49.95"
      end
    else
      if(account_type == "platinum_user")
        acctype="platinum_account"
        if(months == "1")
          amount = 9.95
          amttest=995
          amount1 = "$9.95"
        end
        if(months == "6")
          amount = 9.95
          amttest=4995
          amount1 = "$49.95"
        end
        if(months == "12")
          amount = 9.95
          amttest=9995
          amount1 = "$99.95"
        end
      end
    end
    nextsub = HmmUser.find_by_sql("SELECT DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL +#{months.to_i} MONTH), '%M %D, %Y') as dat")


    #number = '4007000000027'

    creditcard = ActiveMerchant::Billing::CreditCard.new( #:number => number, # Authorize.net test card, error-producing
      :number => card_no, #Authorize.net test card, non-error-producing
      :month => exp_month,                #for test cards, use any date in the future
      :year => exp_year,
      :first_name => fname,
      :last_name => lname,
      :verification_value => cvv_no
      #:cvv => cvv_no
      #note that MasterCard is 'master'
    )

    if creditcard.valid?

      if(logged_in_hmm_user.account_type == "platinum_user")
        if(account_type == "familyws_user")
          flag=2
        else
          flag=2
        end
      end

      if(flag==1)
        flash[:error] = "Sorry you cannot  downgrade your subscription."
        redirect_to "/family_memory/upgrade_account_form/#{params[:id]}?acc_type=#{acctype}"
      else
        #@creditcard = Creditcard.find(params[:id])
        gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(:test => false, :login => "8GxD65y84", :password=> "89j6d34cW8CKhp9S")
        amount_to_charge = Money.ca_dollar(amttest) #1000 = ten US dollars
        creditcard = ActiveMerchant::Billing::CreditCard.new( #:number => number, # Authorize.net test card, error-producing
          :number => card_no, #Authorize.net test card, non-error-producing
          :month => exp_month,                #for test cards, use any date in the future
          :year => exp_year,
          :first_name => fname,
          :last_name => lname,
          :verification_value => cvv_no
          #:cvv => cvv_no
          #note that MasterCard is 'master'
        )

        options = {
          :address => {},
          :billing_address => {
            :name     => "#{fname} #{lname}",
            :address1 => street_address,
            :city     => city,
            :state    => state,
            :country  => country,
            :zip      => postcode,
            :phone    => telephone
          }
        }
        response = gateway.authorize(amount_to_charge,creditcard,options)
        if response.success?
          #charge once
          gateway.capture(amount_to_charge, response.authorization)
          hmm_user_det=HmmUser.find(params[:hmm_id])
          hmm_user_det[:street_address]=params[:street_address]
          hmm_user_det[:suburb]=params[:suburb]
          hmm_user_det[:postcode]=params[:postcode]
          hmm_user_det[:city]=params[:city]
          hmm_user_det[:state]=params[:state]
          hmm_user_det[:country]=params[:country]
          hmm_user_det[:telephone]=params[:telephone]
          hmm_user_det[:account_type] = params[:account_type]
          hmm_user_det[:account_expdate] = account_expdate

          hmm_user_det[:first_payment_date] = Time.now
          hmm_user_det[:invoicenumber] = invoicenumber
          hmm_user_det[:months] = months
          hmm_user_det[:amount] = amount1
          hmm_user_det[:unid] = unid
          hmm_user_det[:comission_month] = 0
          hmm_user_det[:membership_sold_by] = params[:sold_by]
          hmm_user_det.save
          @get_content_url=ContentPath.find(:all, :conditions => "status='active'")
          content_path=@get_content_url[0]['content_path']

          if(session[:employe])
            employedet=EmployeAccount.find(session[:employe])
            hmmstudio=HmmStudio.find(employedet.store_id)
            hmm_user_det[:emp_id] = session[:employe]
            hmm_user_det[:studio_id]=employedet.store_id
            hmm_user_det.save
            subchaptercount=SubChapter.count(:all, :conditions => "store_id > 0 and uid=#{hmm_user_det.id}")
            if(subchaptercount > 0)
              subchaptercheck = SubChapter.count(:all, :conditions => "store_id = #{employedet.store_id}  and uid=#{hmm_user_det.id} ")
              if(subchaptercheck > 0)
              else
                subchapterfind=SubChapter.find(:first, :conditions => "store_id > 0  and uid=#{hmm_user_det.id}")
                subchapter_new = SubChapter.new
                subchapter_new['uid']= hmm_user_det.id
                subchapter_new['tagid']= subchapterfind.tagid
                subchapter_new['sub_chapname']="#{hmmstudio.studio_name}"
                subchapter_new['v_image']="folder_img.png"
                subchapter_new['e_access'] = "public"
                subchapter_new['d_updated_on'] = Time.now
                subchapter_new['d_created_on'] = Time.now
                subchapter_new['img_url']=content_path
                subchapter_new['store_id']= hmmstudio.id
                subchapter_new.save
              end
            else
              tag_default = Tag.new
              tag_default.default_tag='no'
              tag_default.v_tagname="STUDIO SESSIONS"
              tag_default.uid=hmm_user_det.id
              tag_default.default_tag="yes"
              tag_default.e_access = 'public'
              tag_default.e_visible = 'yes'
              tag_default.d_updateddate= Time.now
              tag_default.d_createddate= Time.now
              tag_default.img_url=content_path
              tag_default.v_chapimage = "folder_img.png"
              tag_default.save
              subchapter_new = SubChapter.new
              subchapter_new['uid']= hmm_user_det.id
              subchapter_new['tagid']= tag_default.id
              subchapter_new['sub_chapname']="#{hmmstudio.studio_name}"
              subchapter_new['v_image']="folder_img.png"
              subchapter_new['e_access'] = "public"
              subchapter_new['d_updated_on'] = Time.now
              subchapter_new['d_created_on'] = Time.now
              subchapter_new['img_url']=content_path
              subchapter_new['store_id']= hmmstudio.id
              subchapter_new.save
            end
          end

          i=0
          while i < Integer(hmm_user_det.months)
            @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL #{i} MONTH) as m")
            payment_recieved_on= @hmm_user_max[0]['m']
            recdate= Time.parse(payment_recieved_on)
            mon= recdate.strftime("%m")
            payment_count = PaymentCount.new
            payment_count.uid = hmm_user_det.id
            payment_count.amount = hmm_user_det.amount
            payment_count.recieved_on = payment_recieved_on
            payment_count.account_type = hmm_user_det.account_type
            if hmm_user_det.account_type=="platinum_user"
              if  amttest==995
                payment_count.current_received_amount = 9.95
              else
                payment_count.current_received_amount = 8.32
              end
            elsif hmm_user_det.account_type=="familyws_user"
              if  amttest==495
                payment_count.current_received_amount = 4.95
              else
                payment_count.current_received_amount = 4.16
              end
            end
            payment_count.updated = 1
            payment_count.emp_id = "#{hmm_user_det.emp_id}"
            payment_count.month = "#{mon}"
            payment_count.save
            i=i+1
          end

          start_date = Time.now.strftime("%Y-%m-%d")
          #if(logged_in_hmm_user.account_type=='free_user')
          @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL #{months} MONTH) as m")
          #else
          #  @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE('#{logged_in_hmm_user.account_expdate}',INTERVAL #{months} MONTH) as m")
          #end
          account_expdate= @hmm_user_max[0]['m']

          # Write code for new subscription for  upgradation
          aReq = ArbApi.new
          if ARGV.length < 3
            puts "Usage: ArbApiSample.rb <url> <login> <txnkey> [<subscription name>]"
            #exit
          end
          ARGV[0]= "https://api.authorize.net/xml/v1/request.api"
          ARGV[1]= "8GxD65y84"
          ARGV[2]= "89j6d34cW8CKhp9S"
          #ARGV[1]= "cnpdev4289"
          #ARGV[2]= "SR2P8g4jdEn7vFLQ"
          #ARGV[3]= "644100"

          auth = MerchantAuthenticationType.new(ARGV[1], ARGV[2])
          subname = ARGV.length > 3? ARGV[3]: account_type
          interval = IntervalType.new(1, "months")
          schedule = PaymentScheduleType.new(interval, account_expdate, 9999, 0)
          cinfo = CreditCardType.new(card_no, expiry_date, cvv_no)
          binfo = NameAndAddressType.new(fname, lname,"Not added", street_address, city, state ,postcode, country,email,telephone )
          xmlout = aReq.CreateSubscription(auth,subname,schedule,amount, 0, cinfo,binfo,interval,invoicenumber)

          puts "Creating Subscription Name: #{subname}"
          puts "Submitting to URL: #{ARGV[0]}"
          xmlresp = HttpTransport.TransmitRequest(xmlout, ARGV[0])


          apiresp = aReq.ProcessResponse(xmlresp)

          if apiresp.success
            hmm_user_det=HmmUser.find(params[:hmm_id])
            hmm_user_det[:subscriptionnumber] = apiresp.subscriptionid

            hmm_user_det.save

            subscriptionid = apiresp.subscriptionid
            if(hmm_user_det.account_type=='platinum_user')
              if(hmm_user_det.emp_id=='' || hmm_user_det.emp_id==nil )
              else
                studio_commission=StudioCommission.new
                studio_commission.uid=hmm_user_det.id
                studio_commission.emp_id=hmm_user_det.emp_id
                empstore=EmployeAccount.find(hmm_user_det.emp_id)
                empstoreid=empstore.store_id
                studio_commission.store_id=empstoreid
                if(hmm_user_det.months=='1')
                  commissionamount=5
                elsif(hmm_user_det.months=='6')
                  commissionamount=25
                elsif(hmm_user_det.months=='12')
                  commissionamount=50
                end
                studio_commission.amount=commissionamount
                studio_commission.months=hmm_user_det.months
                studio_commission.payment_recieved_on=Time.now
                studio_commission.subscriptionumber=apiresp.subscriptionid
                studio_commission.save
              end
            end
            pw=HmmUser.find(:all, :select => "v_password as pword,password_required as preq, familywebsite_password as fpword ", :conditions => "id=#{hmm_user_det.id}")

            link = "http://www.holdmymemories.com/#{hmm_user_det.family_name}"
            pass_req = pw[0].preq
            pass = pw[0].pword
            #Postoffice.deliver_paymentsucess("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, params[:account_type], hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,apiresp.subscriptionid, hmm_user_det.v_user_name, hmm_user_det.v_password,link,pass_req,pass)

            flash[:sucess] =  "Subscription Created successfully"
            flash[:sucess_id] = "Your Subscription id is: #{apiresp.subscriptionid}"

            if(logged_in_hmm_user.account_type == "free_user")
              flag=1
            else
              flag=2
            end


            if ARGV.length < 3
            end
            ARGV[0]= "https://api.authorize.net/xml/v1/request.api"
            ARGV[1]= "8GxD65y84"
            ARGV[2]= "89j6d34cW8CKhp9S"

            auth = MerchantAuthenticationType.new(ARGV[1], ARGV[2])
            subname = ARGV.length > 3? ARGV[3]: account_type

            if(flag==2)
              xmlout = aReq.CalcelSubscription(auth,subnumber)
              xmlresp1 = HttpTransport.TransmitRequest(xmlout, ARGV[0])
              apiresp = aReq.ProcessResponse1(xmlresp1)
              puts "Subscription Creation Failed"
              apiresp.messages.each { |message|
                puts "Error Code=#{message.code}"
                puts "Error Message = #{message.text }"
                @res =  message.text
              }
            else
              @res = "no subscription"
            end
            if(@res == "The subscription has already been canceled." || @res == "Successful." || @res == "no subscription")

            end
            Postoffice.deliver_paymentsucessupdate("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, params[:account_type], hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,subscriptionid, hmm_user_det.v_user_name, pw[0].pword,link,pass_req,pass,nextsub[0]['dat'])

            redirect_to "/family_memory/upgrade_account_success/#{params[:id]}?acc_type=#{acctype}"

          else
            apiresp.messages.each { |message|
              puts "Error Code=#{message.code}"
              puts "Error Message =#{message.text } "
              flash[:sucess] =  ""
              flash[:sucess_id] =  " Your Account has been upgraded successfully.<br>"
              # reset the credit points
              @credit_check=CreditPoint.count(:all,:conditions =>"user_id=#{params[:hmm_id]}")
              if(@credit_check > 0)
                @credit_pt=CreditPoint.find(:first,:conditions =>"user_id=#{params[:hmm_id]}")
                @credit_pt['available_credits']=0.00
                @credit_pt.save
              end
            }
            pw=HmmUser.find(:all, :select => "v_password as pword,password_required as preq, familywebsite_password as fpword ", :conditions => "id=#{hmm_user_det.id}")

            link = "http://www.holdmymemories.com/#{hmm_user_det.family_name}"
            pass_req = pw[0].preq
            pass = pw[0].pword
            Postoffice.deliver_paymentsucessupdate("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, params[:account_type], hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,"One time payment", hmm_user_det.v_user_name, pw[0].pword,link,pass_req,pass,nextsub[0]['dat'])

            redirect_to "/family_memory/upgrade_account_success/#{params[:id]}?acc_type=#{acctype}"

            hmm_user_det=HmmUser.find(params[:hmm_id])
            hmm_user_det[:subscriptionnumber] = "One time payment"

            hmm_user_det.save
            if(hmm_user_det.account_type=='platinum_user')
              if(hmm_user_det.emp_id=='' || hmm_user_det.emp_id==nil )
              else
                studio_commission=StudioCommission.new
                studio_commission.uid=hmm_user_det.id
                studio_commission.emp_id=hmm_user_det.emp_id
                empstore=EmployeAccount.find(hmm_user_det.emp_id)
                empstoreid=empstore.store_id
                studio_commission.store_id=empstoreid
                if(hmm_user_det.months=='1')
                  commissionamount=5
                elsif(hmm_user_det.months=='6')
                  commissionamount=25
                elsif(hmm_user_det.months=='12')
                  commissionamount=50
                end
                studio_commission.amount=commissionamount
                studio_commission.months=hmm_user_det.months
                studio_commission.payment_recieved_on=Time.now
                studio_commission.subscriptionumber="One time payment"
                studio_commission.save
              end
            end
          end

          puts "\nXML Dump:"
          @xmldet= xmlresp
        else

          flash[:error] ="Transaction has been declined please check your Credit card CVV number, Card Expiration date and try again"
          redirect_to "/family_memory/upgrade_account_form/#{params[:id]}?acc_type=#{acctype}"
        end
      end
    else
      flash[:error] =   "Error Message = This is a general error Entered Credit card number or CVV number is invalid"
      redirect_to "/family_memory/upgrade_account_form/#{params[:id]}?acc_type=#{acctype}"
    end
  end

  def not_canceled
    @array=TrackAccount.find(:first)
    @array.not_canceled=@array.not_canceled.to_i+1
    @array.save
    redirect_to :controller=>'family_memory',:action=>'edit_profile', :id=>logged_in_hmm_user.family_name
  end

  def new_cancel_subscription

  end

  def new_cancel_sub
    reason = params[:reason]
    hmm_user = HmmUser.find(logged_in_hmm_user.id)
    if hmm_user.cancel_status == "approved" || hmm_user.cancel_status == "pending"
      flash[:sucess_id] = "You have already cancelled your subscription."
    elsif hmm_user.account_type == "free_user"
      hmm_user.cancel_reason=params[:reason]
      hmm_user.cancel_status='approved'
      hmm_user.cancellation_request_date = Time.now
      hmm_user.save
      hmm_user_day_dif =  HmmUser.find_by_sql("select (To_days( account_expdate ) - TO_DAYS( CURRENT_DATE() )) as difr from hmm_users where id='#{logged_in_hmm_user.id}'")
      no_of_days=hmm_user_day_dif[0].difr
      family_pic=hmm_user.family_pic
      img_url=hmm_user.img_url
      if(hmm_user.emp_id == nil || hmm_user.emp_id == "" || hmm_user.emp_id == 0 )
        Postoffice.deliver_cancellation_request("admin","admin@holdmymemories.com,Rachel.Allen@S121.com,Bob.Eveleth@S121.com,Dan.Quinlan@holdmymemories.com,customerservice@holdmymemories.com", reason,"nil",logged_in_hmm_user.id)
        Postoffice.deliver_cancellation_request_response("admin@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,family_pic,no_of_days,img_url)
      else
        store_employee = EmployeAccount.find(hmm_user.emp_id)
        Postoffice.deliver_cancellation_request(store_employee.employe_name,"#{store_employee.e_mail},Rachel.Allen@S121.com,Bob.Eveleth@S121.com,Dan.Quinlan@holdmymemories.com,customerservice@holdmymemories.com", reason,store_employee.store_id,logged_in_hmm_user.id)
        Postoffice.deliver_cancellation_request_response(store_employee.e_mail,logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,family_pic,no_of_days,img_url)
      end
      @array=TrackAccount.find(:first)
      @array.canceled =@array.canceled.to_i+1
      @array.save

      flash[:sucess_id] = "Subscription has been cancelled sucessfully."
    else
      sql = ActiveRecord::Base.connection();
      sql.update"update hmm_users set cancel_status='pending' , cancellation_request_date=Now()  where id='#{logged_in_hmm_user.id}'";

      hmm_user_day_dif =  HmmUser.find_by_sql("select (To_days( account_expdate ) - TO_DAYS( CURRENT_DATE() )) as difr from hmm_users where id='#{logged_in_hmm_user.id}'")
      no_of_days=hmm_user_day_dif[0].difr
      family_pic=hmm_user.family_pic
      img_url=hmm_user.img_url

      #insert to cancel req table
      @exp_date_cal =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL 3 DAY) as m")
      cancel_date= @exp_date_cal[0]['m']

      @cancel_req= CancellationRequest.new()
      @cancel_req['uid']=logged_in_hmm_user.id
      @cancel_req['reason_for_cancellation']=params[:reason]
      @cancel_req['cancellation_request_date']=Time.now()
      @cancel_req['cancellation_date']=cancel_date
      @cancel_req['cancellation_status']='pending'
      @cancel_req.save

      #Credit points should be calculated here
      #----------------------------------------------------
      if(hmm_user.emp_id == nil || hmm_user.emp_id == "" || hmm_user.emp_id == 0 )
        Postoffice.deliver_cancellation_request("admin","admin@holdmymemories.com,Rachel.Allen@S121.com,Bob.Eveleth@S121.com,Dan.Quinlan@holdmymemories.com,customerservice@holdmymemories.com", reason,"nil",logged_in_hmm_user.id)
        Postoffice.deliver_cancellation_request_response("admin@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,family_pic,no_of_days,img_url)
      else
        store_employee = EmployeAccount.find(hmm_user.emp_id)
        Postoffice.deliver_cancellation_request(store_employee.employe_name,"#{store_employee.e_mail},Rachel.Allen@S121.com,Bob.Eveleth@S121.com,Dan.Quinlan@holdmymemories.com,customerservice@holdmymemories.com", reason,store_employee.store_id,logged_in_hmm_user.id)
        Postoffice.deliver_cancellation_request_response(store_employee.e_mail,logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,family_pic,no_of_days,img_url)
      end
      hmm_user = HmmUser.find(logged_in_hmm_user.id)
      uuid =  HmmUser.find_by_sql(" select UUID() as u")
      unnid = uuid[0]['u']
      if(hmm_user.family_name=='' or hmm_user.family_name==nil)
        hmm_user.family_name="#{logged_in_hmm_user.id}#{unnid}un#{logged_in_hmm_user.id}"
      end
      hmm_user.save
      @array=TrackAccount.find(:first)
      @array.canceled =@array.canceled.to_i+1
      @array.save
      flash[:sucess_id] = "Subscription has been cancelled sucessfully."
    end
    render :action => 'cancel_sucess', :id => logged_in_hmm_user.family_name
  end

  def cancel_sucess

  end

  def login
    if params[:id].upcase=="BOB"
      params[:id]="EVELETH"
    end
    user = HmmUser.find_by_family_name(params[:id])
    studio = HmmStudio.find(user.studio_id) rescue nil
    if user.studio_id==0
      r_action="home"
    else
      if studio.studio_groupid==pp_studio_group
        r_action="login"
      else
        r_action="home"
      end
    end

    @current_page = 'login'

    if logged_in_hmm_user && @family_website_owner.id == logged_in_hmm_user.id && @family_website_owner.terms_checked =="true"
      redirect_to :action => 'home', :id => params[:id]
    end
    if params[:username] == "" && params[:password] == ""
      redirect_to :action => 'home', :id => params[:id]
    end

    unless params[:username].blank? && params[:password].blank?
      self.logged_in_hmm_user = HmmUser.authenticate(params[:username],params[:password])
      if is_userlogged_in?
        if logged_in_hmm_user.e_user_status == 'unblocked'
          logger.info("[User]: #{[:username]} [Logged In] at #{Time.now} !")
          logger.info(logged_in_hmm_user.id)
          @user_session = UserSessions.new()
          @user_session['i_ip_add'] = request.remote_ip
          @user_session['uid'] = logged_in_hmm_user.id
          @user_session['v_user_name'] = logged_in_hmm_user.v_user_name
          @user_session['d_date_time'] = Time.now
          @user_session['e_logged_in'] = "yes"
          @user_session['e_logged_out'] = "no"
          @user_session.save

          if @family_website_owner.id == logged_in_hmm_user.id
            session[:visitor] = params[:id]
            #              if @family_website_owner.substatus == 'inactive'
            if (@family_website_owner.account_expdate!=nil && @family_website_owner.account_expdate < Date.current())
              redirect_to "/family_memory/upgrade_account_form/#{params[:id]}?acc_type=platinum_account&option=1"
            elsif(session[:employe]==nil && @family_website_owner.terms_checked =="false")
              redirect_to "/user_account/update_terms/"
            else

              unless params[:redirect_url].blank?

                redirect_to "#{params[:redirect_url]}"
              else
                if params[:url]
                  redirect_to "#{params[:url]}"
                else
                  redirect_to :controller => 'family_memory',:action => 'home', :id => params[:id]
                end
              end
            end
          else
            session[:hmm_user]=nil
            flash[:error] = " Invalid Login.You must be the owner of this site."
            #log file entry
            logger.error("[Invalid Login]: by [User]:#{params[:username]} at #{Time.now}")
            if params[:url]
              redirect_to "#{params[:url]}"
            else
              redirect_to :controller => 'family_memory',:action => 'home', :id => params[:id]
            end
          end

        else
          session[:hmm_user]=nil
          flash[:error] = "User is been blocked.. Contact Admin!!"
        end
      else
        flash[:error] = "Either your username or password is incorrect. Please try again."
        #log file entry
        logger.error("[Invalid Login]: by [User]:#{params[:username]} at #{Time.now}")
        if params[:url]
          redirect_to "#{params[:url]}"
        else

          redirect_to :controller => 'family_memory',:action => r_action, :id => params[:id]
        end
      end
    end
  end



  def gallery_details
    cond=self.subchapter_public()
    urls=request.url
    @url=urls
    #url=urls.gsub("holdmymemories.com","www.holdmymemories.com")
    @paths = ContentPath.find(:first,:conditions=>"status='active'")
    if params[:moment_id]
      @img=UserContent.find(:all,:conditions=>"id=#{params[:moment_id]} ")
      @first_img=@img[0]
    elsif params[:gallery_id]
      gal=Galleries.find(params[:gallery_id])
      @img=UserContent.find(:all,:conditions=>"gallery_id=#{params[:gallery_id]} and status='active' #{cond}",:order=>"id desc",:limit=>"4")
      @first_img=@img[0]
    elsif params[:chapter_id]
      @img=UserContent.find(:all,:conditions=>"tagid=#{params[:chapter_id]} and status='active' #{cond}",:order=>"id desc",:limit=>"4")
      @first_img=@img[0]
    elsif params[:sub_chapid]
      @img=UserContent.find(:all,:conditions=>"sub_chapid=#{params[:sub_chapid]} and status='active' #{cond}",:order=>"id desc",:limit=>"4")
      @first_img=@img[0]
    elsif params[:searchval]
      months = ["january", "february", "march", "april", "may", "june", "july","august", "september", "october", "november", "december"]
      searchs=params[:searchval].split(' ')
      search_query=''
      search_query << "2=1 "
      for search in searchs
        search=search.gsub(/[^0-9A-Za-z]/, '')
        search_query << "OR v_tagname LIKE '%#{search}%'"
        search_query << "OR v_desc LIKE '%#{search}%'"
        search_query << "OR YEAR(d_createddate) LIKE '%#{search}%'"
        i = 0
        while i < months.length
          test = months[i].scan(search.downcase)
          if !test.empty?
            if i < 9
              search_query << "OR MONTH(d_createddate) = 0#{i+1}"
              break
            else
              search_query << "OR MONTH(d_createddate) = #{i+1}"
              break
            end
          end
          i= i+1
        end
      end
      if(params[:cnt_id])
        cnt=params[:cnt_id].to_i
        logger.info(cnt)
        @img=UserContent.find(:all,:conditions=>"status='active' #{cond} and (#{search_query}) and uid=#{@family_website_owner.id}",:order=>"id desc",:limit=>"#{cnt},1")
        @first_img=@img[0]
      else
        @img=UserContent.find(:all,:conditions=>"status='active' #{cond} and (#{search_query}) and uid=#{@family_website_owner.id}",:order=>"id desc",:limit=>"4")
        @first_img=@img[0]
      end
      if @first_img
      else
        search_query_blog=''
        search_query_blog << "2=1 "
        for searching in searchs
          searching=searching.gsub(/[^0-9A-Za-z]/, '')
          search_query_blog << "OR  title like '%#{searching}%'"
        end
        if session[:hmm_user]
          if logged_in_hmm_user.id==@family_website_owner.id
            cond_b="and 1=1"
          else
            cond_b="and a.access='public'"
          end
        else
          cond_b="and a.access='public'"
        end
        if session[:hmm_user]
          if logged_in_hmm_user.id==@family_website_owner.id
            cond_a="and 1=1"
          else
            cond_a="and b.e_access='public'"
          end
        else
          cond_a="and b.e_access='public'"
        end
        @img=Blog.find(:all,:select=>"b.*",:joins=>"as a,user_contents as b",:conditions=>"b.id=a.blog_type_id and a.status='active' #{cond_b} #{cond_a} and b.status='active' and (#{search_query_blog}) and	(a.blog_type='image' or 	a.blog_type='video') and a.user_id=#{@family_website_owner.id}",:order=>"id desc",:limit=>"4")
        @first_img=@img[0]
      end
    end
    if(!@first_img.nil?)
      if params[:facebook]
        img_arr=[]
        @galleryUrl = ""
        if(gal.e_gallery_type == "video")
          logger.info("Gallery Type Video")
          @swfName = "ShareCoverFlow"
          @swfName1 = "ShareCoverFlow"
          @galleryUrl = "/family_memory/share_coverflow/#{params[:id]}?gallery_id=#{params[:gallery_id]}"
          for im in @img
            img_arr.push("#{im.img_url}/user_content/videos/thumbnails/#{im.v_filename}.jpg")
          end
        elsif(gal.e_gallery_type == "image")
          logger.info("Gallery Type Image")
          @swfName = "PhotoGallery"
          @swfName1 = "ShareCoverFlow"
          @galleryUrl = "/family_memory/share_coverflow/#{params[:id]}?gallery_id=#{params[:gallery_id]}"
          for im in @img
            img_arr.push("#{im.img_url}/user_content/photos/coverflow/#{im.v_filename}")
          end
        elsif(gal.e_gallery_type == "audio")
          logger.info("Gallery Type Audio")
          @swfName = "CoverFlowAudio"
          @swfName1 = "CoverFlowAudio"
          @galleryUrl = "/evelethsfamily/showAudioGallery/"+params[:gallery_id]
        end
        @proxyurls = get_proxy_urls()

        subdomain = request.subdomains[0]
        subdomain = 'www' if subdomain.blank?
        @share_image = img_arr

        @share_video = "http://#{subdomain}.holdmymemories.com/#{@swfName1}.swf?serverUrl=http://#{subdomain}.holdmymemories.com#{@galleryUrl}&buttonsVisible=false&contenturl=#{@proxyurls}"
        @share_type = "video"
      else
        if(@first_img.e_filetype =="image")
          @share_image = "#{@first_img.img_url}/user_content/photos/coverflow/#{@first_img.v_filename}"
          @share_type="image"
        elsif(@first_img.e_filetype =="video")
          @share_image = "#{@first_img.img_url}/user_content/videos/thumbnails/#{@first_img.v_filename}.jpg"
          @share_video = "http://blog.holdmymemories.com/BlogVideoPlayer.swf?videopath=#{@first_img.img_url}/user_content/videos/#{@first_img.v_filename}.flv"
          @share_type = "video"
        end
        blog_ids = []
        @blog = Blog.find(:first, :conditions => "blog_type_id=#{@first_img.id} and blog_type='#{@share_type}' and status='active'", :select => "id,title,description,added_date")
        if @blog
          blog_ids.push(@blog.id)
        end
        @gallery_blog = Blog.find(:first, :conditions => "blog_type_id=#{@first_img.gallery_id} and blog_type='gallery' and status='active'", :select => "id,title,description,added_date")
        if @gallery_blog
          blog_ids.push(@gallery_blog.id)
        end
        if !@blog.nil? || !@gallery_blog.nil?
          blog_ids = blog_ids.join(',')
          @blogcomments=BlogComment.find(:all,:conditions=>"blog_id IN (#{blog_ids}) and 	status='approved'")
          logger.info(blog_ids)
        end
        @comments = PhotoComment.find(:all, :conditions => "e_approved = 'approve' and user_content_id = #{@first_img.id}", :order => "id asc", :select =>"v_comment as comment,v_name as commenter,d_add_date as commented_date")
        @gallery_comments = GalleryComment.find(:all, :conditions => "e_approval = 'approve' and gallery_id = #{@first_img.gallery_id}", :order => "id asc", :select =>"v_comment as comment,v_name as commenter,d_created_on as commented_date")
      end
    end
    if params[:next] == "yes"
      #      return @comments, @blogcomments, @blog
      render :update do |page|
        page.replace_html "refresh_comments", :partial => "comments"
      end
    end
    if params[:alert_msg]
      flash[:notice_com] = params[:alert_msg]
    end
  end

  def share_coverflow
    @contents=UserContent.find(:all,:select=>"e_filetype,img_url,v_filename,v_tagphoto,id",:conditions=>"gallery_id=#{params[:gallery_id]} and status='active' and 	e_access!='private'")
    render :layout=>false
  end

  def share_subchapter_coverflow
    @contents=UserContent.find(:all,:select=>"e_filetype,img_url,v_filename,v_tagphoto,id",:conditions=>"gallery_id=#{params[:subchapter_id]} and status='active' and 	e_access!='private'")
    render :layout=>false
  end

  def create_moment_comment
    unless params[:moment_comment].blank?
      if verify_recaptcha
        @moment_comment = PhotoComment.new(params[:moment_comment])
        @moment_comment['uid']= @family_website_owner.id
        @moment_comment['d_add_date']=Time.now
        if @moment_comment.save
          Postoffice.deliver_family_memory_comment(params[:moment_comment][:v_comment],'0','Photo',params[:moment_comment][:v_name],@family_website_owner.v_e_mail,@family_website_owner.v_user_name,@family_website_owner.v_e_mail,@family_website_owner.v_myimage,@family_website_owner.img_url)
          flash[:notice_com] = 'Thank-you for adding your comment!'
          #          redirect_to "#{params[:redirect_url]}"
        else
          flash[:notice_com] = 'Please enter the correct code!'
          #          redirect_to "#{params[:redirect_url]}"
        end
      else
        flash[:notice_com] = 'Please enter the correct code!'
        flash[:v_comment]=params[:moment_comment][:v_comment]
        flash[:v_name]=params[:moment_comment][:v_name]
        #        redirect_to "#{params[:redirect_url]}"
      end
    end
    render :layout => false
  end

  #  def search_func(search)
  #    search_val = search
  #    regexp = /[a-zA-Z]{3}[\s][0-9]{1,2}[\s][0-9]{4}/
  #    if !search.nil? && search.match(regexp)
  #      date_val = search.match(regexp)
  #      date_search = Date.parse(date_val[0].gsub(/, */, '-'))
  #    else
  #      date_search = nil
  #    end
  #    if !search_val.nil? && search_val.match(regexp)
  #      search_val = search_val.gsub(regexp, "")
  #      text_search = search_val
  #      logger.info("******* first********")
  #      logger.info text_search.inspect
  #    else
  #      text_search = search
  #      logger.info("******* second********")
  #      logger.info text_search.inspect
  #    end
  #    search_query=''
  #    search_query << "2=1 "
  #    if !text_search.nil?
  #      text_search = text_search.split(" ")
  #      for search1 in text_search
  #        search1=search1.gsub(/[^0-9A-Za-z]/, '')
  #        search_query << "OR v_tagphoto LIKE '%#{search1}%'"
  #        search_query << "OR v_tagname LIKE '%#{search1}%'"
  #        search_query << "OR v_desc LIKE '%#{search1}%'"
  #      end
  #    end
  #    if !date_search.nil? && date_search.class.to_s == "Date"
  #      date_search = date_search.to_date.strftime("%Y-%m-%d")
  #      search_query << "OR d_createddate LIKE '%#{date_search}%'"
  #      search_query << "OR d_momentdate LIKE '%#{date_search}%'"
  #    end
  #
  #    search_query_blog=''
  #    search_query_blog << "2=1 "
  #    for searching in text_search
  #      searching=searching.gsub(/[^0-9A-Za-z]/, '')
  #      search_query_blog << " OR  title like '%#{searching}%' "
  #    end
  #    return search_query,search_query_blog
  #  end

  def search_func(search)

    regexp_single = /(([0-9]|10|11|12)\/([0-9]|1[0-9]|2[0-9]|3[0-9])\/[0-9]{4})/
    search_text = search
    search_key_arr = Array.new
    search_date_arr = Array.new
    search_arr = Array.new
    search_query=""
    search_key = search_text.gsub("-","")
    search_key_arr = search_key.split(" ")
    dates = search_text.scan(regexp_single)
	  for d in dates
	  	search_arr << d[0]
 	  end
    if search_arr.length > 1
      search_date_arr[0] = search_arr[0]
      search_date_arr[1] = search_arr[1]
    elsif search_arr.length == 1
      search_date_arr[0] = search_arr[0]
    end

    search_album_query=''
    search_moment_query=''
    search_moment_query << "2=1 "
    search_album_query << "2=1 "
    #search text keyword
    if search_key_arr.length > 0
      for search1 in search_key_arr
        if !search1.match(regexp_single)
          search1 = search1.gsub("'s","")
          search_moment_query << "OR v_tagphoto LIKE '%#{search1}%' "
          search_moment_query << "OR v_tagname LIKE '%#{search1}%' "
          search_moment_query << "OR v_desc LIKE '%#{search1}%' "
          #
          search_album_query  << "OR sub_chapname LIKE '%#{search1}%' "
          search_album_query  << "OR edited_name LIKE '%#{search1}%' "
        end
      end
    end

    if search_date_arr.length == 2
      srch = search_date_arr[0]
      srch1 = search_date_arr[1]
      start_date = srch.gsub("/",",")
      end_date = srch1.gsub("/",",")
      start_date = Date.strptime("{ #{start_date} }", "{ %m, %d, %Y }")
      end_date = Date.strptime("{ #{end_date} }", "{ %m, %d, %Y }")
      start_date = start_date.strftime("%Y-%m-%d")
      end_date = end_date.strftime("%Y-%m-%d")
      #
      search_moment_query << "OR (d_createddate >= '#{start_date}' AND d_createddate <= '#{end_date}') "
      search_moment_query << "OR (d_momentdate >= '#{start_date}' AND d_momentdate <= '#{end_date}') "
      #
      search_album_query  << "OR (d_created_on >= '#{start_date}' AND d_created_on <= '%#{end_date}%') "
      search_album_query  << "OR (date_updated >= '#{start_date}' AND date_updated <= '#{end_date}') "

    elsif search_date_arr.length == 1
      srch = search_date_arr[0]
      search_date = srch.gsub("/",",")
      search_date = Date.strptime("{ #{search_date} }" , "{ %m, %d, %Y }")
      search_date = search_date.strftime("%Y-%m-%d")
      #
      search_moment_query << "OR d_createddate LIKE '%#{search_date}%' "
      search_moment_query << "OR d_momentdate LIKE '%#{search_date}%' "
      #
      search_album_query  << "OR d_created_on LIKE '%#{search_date}%' "
      search_album_query  << "OR date_updated LIKE '%#{search_date}%' "

    end
    search_query_blog=''
    search_query_blog << "2=1 "
    for searching in search_key_arr

      if !searching.match(regexp_single)

        searching = searching.gsub("'s","")
			  search_query_blog << " OR  title like '%#{searching}%' "
        search_query_blog << "OR (added_date >= '#{start_date}' AND added_date <= '#{end_date}') "

      end
    end
    #    logger.info("********************************search_moment_query_conditions***************************")
    #    logger.info(search_moment_query)
    #
    #    logger.info("********************************search_query_blog_conditions***************************")
    #    logger.info(search_query_blog)
    #
    #    logger.info("********************************search_moment_query_conditions***************************")
    #    logger.info(search_album_query)
    #
    return search_moment_query,search_query_blog,search_album_query
  end

  def search_tag_fun(search)

    search_moment_query,search_query_blog,search_album_query=self.search_func(search)
    arr_imgs=[]
    blog_cond=self.blog_public()
    imgs=Blog.find(:all,:select=>"blog_type_id",:conditions=>"status='active' #{blog_cond} and (#{search_query_blog}) and	(blog_type='image' or 	blog_type='video') and user_id=#{@family_website_owner.id}",:order=>"id desc")
    for img in imgs
      arr_imgs.push(img.blog_type_id)
    end
    cond=self.subchapter_public

    if arr_imgs.length > 0
      arr_imgs=arr_imgs.join(',')
      cont=UserContent.find(:all,:conditions=>"status='active'  #{cond} and (#{search_moment_query}) and uid=#{@family_website_owner.id}  and (e_filetype='video' or e_filetype='image')",:order=>"id desc")
      us_cont=UserContent.find(:all,:conditions=>"id in (#{arr_imgs}) #{cond}")
      contents=cont+us_cont
    else
      contents=UserContent.find(:all,:conditions=>"status='active'  and (#{search_moment_query}) #{cond} and uid=#{@family_website_owner.id}  and (e_filetype='video' or e_filetype='image')",:order=>"id desc")
    end
    return contents
  end
  #  def search_tag_fun(search)
  #    search_query,search_query_blog=self.search_func(search)
  #    arr_imgs=[]
  #    blog_cond=self.blog_public()
  #    imgs=Blog.find(:all,:select=>"blog_type_id",:conditions=>"status='active' #{blog_cond} and (#{search_query_blog}) and	(blog_type='image' or 	blog_type='video') and user_id=#{@family_website_owner.id}",:order=>"id desc")
  #    for img in imgs
  #      arr_imgs.push(img.blog_type_id)
  #    end
  #    cond=self.subchapter_public
  #
  #    if arr_imgs.length > 0
  #      arr_imgs=arr_imgs.join(',')
  #      cont=UserContent.find(:all,:conditions=>"status='active'  #{cond} and (#{search_query}) and uid=#{@family_website_owner.id}  and (e_filetype='video' or e_filetype='image')",:order=>"id desc")
  #      us_cont=UserContent.find(:all,:conditions=>"id in (#{arr_imgs}) #{cond}")
  #      contents=cont+us_cont
  #    else
  #      contents=UserContent.find(:all,:conditions=>"status='active'  and (#{search_query}) #{cond} and uid=#{@family_website_owner.id}  and (e_filetype='video' or e_filetype='image')",:order=>"id desc")
  #    end
  #    return contents
  #  end

  def search_tag_fun1(search)
    search_moment_query,search_query_blog,search_album_query=self.search_func(search)
    arr_imgs=[]
    blog_cond=self.blog_public()
    imgs=Blog.find(:all,:select=>"blog_type_id",:conditions=>"status='active' #{blog_cond} and (#{search_query_blog}) and	(blog_type='image' or 	blog_type='video') and user_id=#{@family_website_owner.id}",:order=>"id desc")
    for img in imgs
      arr_imgs.push(img.blog_type_id)
    end
    cond=self.subchapter_public
    if session[:hmm_user]
      if logged_in_hmm_user.id==@family_website_owner.id
        cond2="and 1=1"
      else
        cond2="and b.e_access='public'"
      end
    else
      cond2="and b.e_access='public'"
    end
    #    if params[:id].upcase=="BOB" || params[:id].upcase=="EVELETH"
    group="sub_chapid"
    #    else
    #      group="gallery_id"
    #    end

    #get the subchapters matching the name
    albums=SubChapter.find(:all,:select=>"id",:conditions=>"status='active' and (#{search_album_query}) #{cond} and uid=#{@family_website_owner.id}",:order=>"id desc")
    album_list=[]
    for album in albums
      album_list.push(album.id)
    end
    if  album_list.length>0
      sub_cond="and sub_chapid NOT IN (#{album_list.join(",")})"
    else
      sub_cond=''
    end
    if arr_imgs.length > 0
      arr_imgs=arr_imgs.join(',')
      contents=UserContent.find(:all,:conditions=>"(status='active'  #{cond} #{sub_cond} and (#{search_moment_query}) and uid=#{@family_website_owner.id}  and (e_filetype='video' or e_filetype='image') and #{group} is not null) or (id in (#{arr_imgs}) #{cond} #{sub_cond}) ",:order=>"id desc")
    else
      contents=UserContent.find(:all,:conditions=>"status='active'  and (#{search_moment_query}) #{cond} #{sub_cond} and uid=#{@family_website_owner.id}  and (e_filetype='video' or e_filetype='image') and #{group} is not null",:order=>"id desc")
    end
    #find the images with more the one subchapter
    img_subs={}
    sub_chp_arr=[]
    for content in contents
      sub_chp_arr.push(content.sub_chapid)
      img_subs.store(content.sub_chapid,content)
    end

    subs=only_duplicates(sub_chp_arr)
    subs=subs.uniq
    album_list=album_list+subs
    #get the subchapter with name and grouping the image into album which has more than one image matching description
    if album_list.length>0
      albums=UserContent.find(:all,:select=>"b.id,#{group},max(d_createddate) as last_moment,v_filename,e_filetype,a.img_url",:joins=>"as a,sub_chapters as b",:conditions=>"a.sub_chapid=b.id and a.status='active' and b.status='active'  and b.id in (#{album_list.join(",")}) #{cond2} and (e_filetype='video' or e_filetype='image') and #{group} is not null",:group=>group,:order=>"b.id desc")
    else
      albums = []
    end
    for album in album_list
      img_subs.delete(album)
    end
    return img_subs,albums
  end

  def only_duplicates(sub_chp_arr)
    duplicates = []
    sub_chp_arr.each {|each| duplicates << each if sub_chp_arr.count(each) > 1}
    return duplicates
  end

  def search_moments
    all_galleries=self.get_album_details(params[:search],params[:id])
    render :text=>all_galleries.to_json
  end

  def search_album_facebook_share
    @results=self.get_album_details(params[:search],params[:id])
    render :layout=>false
  end

   def get_album_details(search,id)
    subdomain = request.subdomains[0]
    subdomain = 'www' if subdomain.blank?
    all_galleries=[]
    contents,albums=search_tag_fun1(search)
    ids=[]
    user_content_ids={}
    imgs={}
    m_type={}
    server={}
    #    if id.upcase=="BOB" || id.upcase=="EVELETH"
    group="sub_chapid"
    for content in albums
      ids.push(content.sub_chapid)
      user_content_ids.store(content.sub_chapid,content.last_moment)
      imgs.store(content.sub_chapid,content.v_filename)
      m_type.store(content.sub_chapid,content.e_filetype)
      server.store(content.sub_chapid,content.img_url)
    end
    mob_sub=ids.join(",")
    if session[:hmm_user]
      if logged_in_hmm_user.id==@family_website_owner.id
        cond2="and 1=1"
      else
        cond2="and sub_chapters.e_access='public'"
      end
    else
      cond2="and sub_chapters.e_access='public'"
    end
    if ids.length>0
      all_sub_chapters=SubChapter.find(:all,:select=>"sub_chapters.v_subchapter_tags,sub_chapters.sub_chapname,sub_chapters.edited_name,sub_chapters.date_updated,sub_chapters.id,sub_chapters.img_url,sub_chapters.v_image,sub_chapters.v_desc",:conditions=>"sub_chapters.id in (#{mob_sub}) and sub_chapters.status='active' #{cond2} and store_id is null")
      for all_sub_chapter in all_sub_chapters
        imageName  = all_sub_chapter.v_image
        imageName.slice!(-3..-1)
        date_index = user_content_ids.key?(all_sub_chapter.id)
        if date_index
          latest_gal_date = user_content_ids[all_sub_chapter.id]
          img_file=imgs[all_sub_chapter.id]
          mom_type=m_type[all_sub_chapter.id]
          server_url=server[all_sub_chapter.id]
        end
        #      chap=all_sub_chapter.v_tagname.gsub(/\s+/, "")
        #      chap=chap.gsub(/[^0-9A-Za-z]/, '')
        #      chap_name=chap.upcase
        #
        #
        #      sub_chap=all_sub_chapter.sub_chapname.gsub(/\s+/, "")
        #      sub_chap=sub_chap.gsub(/[^0-9A-Za-z]/, '')
        #      sub_chap_name=sub_chap.upcase
        #
        #      sub_chap_name=sub_chap_name.gsub(/[^0-9A-Za-z]/, '')
        #
        #      cond_tags=sub_chap_name.grep(/#{chap_name}/)
        #      cond_len_tags=cond_tags.length
        if all_sub_chapter.edited_name.nil? || all_sub_chapter.edited_name.blank?
          #        if(chap=="MobileUploads") || (all_sub_chapter.v_tagname.upcase==all_sub_chapter.sub_chapname.upcase) || (cond_len_tags!=0)
          disp_name=" #{all_sub_chapter.sub_chapname}"
          #        else
          #          disp_name="#{all_sub_chapter.v_tagname}, #{all_sub_chapter.sub_chapname}"
          #        end
        else
          disp_name=all_sub_chapter.edited_name
        end
        if !all_sub_chapter.date_updated.nil? && !all_sub_chapter.date_updated.blank?
          latest_gal_date=all_sub_chapter.date_updated
        else
          latest_gal_date=latest_gal_date
        end
        if imageName=="folder_img."
          if mom_type=="image"
            file_name="#{server_url}/user_content/photos/coverflow/#{img_file}"
          elsif mom_type=="video"
            file_name="#{server_url}/user_content/videos/thumbnails/#{img_file}.jpg"
          end
        else
          file_name="#{all_sub_chapter.img_url}/user_content/photos/flex_icon/#{imageName}jpg"
        end
        if !all_sub_chapter.v_desc.nil? && !all_sub_chapter.v_desc.blank?
          desc2=all_sub_chapter.v_desc.gsub('&quot;',"'")
        else
          desc2=""
        end
        if params[:myhmm] && params[:myhmm] == "true"
          if !all_sub_chapter.id.nil? && all_sub_chapter.id > 0
            data_type = "studio"
          else
            data_type = "mobile"
          end

          if all_sub_chapter.v_subchapter_tags.nil? || all_sub_chapter.v_subchapter_tags == ""
            tag = ""
          else
            tag = all_sub_chapter.v_subchapter_tags
          end

          if disp_name.nil? || disp_name == ""
            disp_name = ""
          end

          allsub_chaps={:text=>disp_name,
            :id=>all_sub_chapter.id,
            :sub_chapid=>all_sub_chapter.id,
            :tags=>tag,
            :video_path=>"",
            :audio_tag=>"",
            :file_name=>disp_name,
            :sort_date=>latest_gal_date.to_date,
            :d_createddate=>latest_gal_date.to_date.strftime('%m/%d/%Y'),
            :img_url=>file_name,
            :big_thumb=>file_name,
            :displayDate=>"#{latest_gal_date.to_date.strftime("%b. %d, %Y")}",
            :type=>"gallery",
            :navigateUrl=>"/family_memory/search_album_tags/#{id}?type_id=#{all_sub_chapter.id}&&searchval=#{search}&&type=subchapter",
            :response_type => 'navigate_V4',
            :facebook_share_url=>CGI.escape("http://#{subdomain}.holdmymemories.com/family_memory/home/#{params[:id]}?&&facebook=#{rand(1000)}&&search_albums=true&&t=text&&search=#{search}"),
            :data_type =>data_type,
            :video_url=>"",
            :service_url=>"/family_memory/search_album_tags/#{id}?type_id=#{all_sub_chapter.id}&&searchval=#{search}&&type=subchapter",
            :back_service_url=>"",
            :folder_icon=>"#{all_sub_chapter.img_url}/user_content/photos/icon_thumbnails/#{all_sub_chapter.v_image}",
            :description=>desc2,
            :edit_tag_type=>"subchapter",
            :studio_sessions=>"false"}
        else
          allsub_chaps={:text=>disp_name,:gallery_id=>all_sub_chapter.id,:file_name=>disp_name,:sort_date=>latest_gal_date.to_date,:created_date=>latest_gal_date.to_date.strftime('%m/%d/%Y'),:img_url=>file_name,:orginal_img_url=>file_name,:displayDate=>"#{latest_gal_date.to_date.strftime("%b. %d, %Y")}",:type=>"galleries",:navigateUrl=>"/family_memory/search_album_tags/#{id}?type_id=#{all_sub_chapter.id}&&searchval=#{search}&&type=subchapter", :response_type => 'navigate_V4',:facebook_share_url=>CGI.escape("http://#{subdomain}.holdmymemories.com/family_memory/home/#{params[:id]}?&&facebook=#{rand(1000)}&&search_albums=true&&t=text&&search=#{search}"),:data_type =>"gallery",:service_url=>"/family_memory/search_album_tags/#{id}?type_id=#{all_sub_chapter.id}&&searchval=#{search}&&type=subchapter",:back_service_url=>"",:folder_icon=>"#{all_sub_chapter.img_url}/user_content/photos/icon_thumbnails/#{all_sub_chapter.v_image}",:description=>desc2,:edit_tag_type=>"subchapter",:studio_sessions=>"false"}
        end
        all_galleries.push(allsub_chaps)
      end
    end

    for gal in contents
      gal=gal[1]
      if gal.e_filetype=="image"
        small_thumb="#{gal.img_url}/user_content/photos/coverflow/#{gal.v_filename}"
        url="#{gal.img_url}/user_content/photos/journal_thumb/#{gal.v_filename}"
      elsif gal.e_filetype=="video"
        small_thumb="#{gal.img_url}/user_content/videos/thumbnails/#{gal.v_filename}.jpg"
        url="#{gal.img_url}/user_content/videos/#{gal.v_filename}.flv"
        if params[:myhmm] && params[:myhmm] == "true"
          url="#{gal.img_url}/user_content/videos/iphone/#{gal.v_filename}.mp4"
        end
      else
        small_thumb=""
        url=""
      end
      if !gal.v_desc.nil? && !gal.v_desc.blank?
        desc1=gal.v_desc.gsub('&quot;',"'")
      else
        desc1=""
      end
      if params[:myhmm] && params[:myhmm] == "true"
        if  !gal.audio_tag.blank? || !gal.audio_tag.nil?
          audio_tag= "#{gal.audio_tag_url}/user_content/audio_tags/#{gal.audio_tag}"
        else
          audio_tag= ""
        end
        if !gal.sub_chapid.nil? && gal.sub_chapid > 0
          data_type = "studio"
        else
          data_type = "mobile"
        end

        if gal.v_tagname.nil? || gal.v_tagname == ""
          file_name = ""
        else
          file_name = gal.v_tagname
        end
        allstudio_gals={:text=>gal.v_tagname,
          :id=>gal.id,
          :sub_chapid=>gal.sub_chapid,
          :tags=>file_name,
          :video_path=>url,
          :audio_tag=>audio_tag,
          :file_name=>file_name,
          :sort_date=>gal.d_createddate.to_date,
          :d_createddate=>gal.d_createddate.strftime('%m/%d/%Y'),
          :img_url=>"#{small_thumb}",
          :big_thumb=>"#{small_thumb}",
          :displayDate=>"#{gal.d_createddate.strftime("%b. %d, %Y")}",
          :type=>"#{gal.e_filetype}",
          :navigateUrl=>"/family_memory/gallery_details/#{params[:id]}?moment_id=#{gal.id}&&searchval=#{search}",
          :response_type => 'navigate_V4',
          :facebook_share_url=>CGI.escape("http://#{subdomain}.holdmymemories.com/family_memory/gallery_details/#{params[:id]}?gallery_id=#{gal.gallery_id}&&searchval=#{search}&&facebook=#{rand(1000)}&&t=text"),
          :data_type =>data_type,
          :video_url=>url,
          :back_service_url=>"/family_memory/homepage_data/#{params[:id]}",
          :folder_icon=>"#{small_thumb}",
          :description=>desc1,
          :edit_tag_type=>"moment",
          :studio_sessions=>"false"}
      else
        allstudio_gals={:text=>gal.v_tagname,:gallery_id=>gal.id,:file_name=>gal.v_tagname,:sort_date=>gal.d_createddate.to_date,:created_date=>gal.d_createddate.strftime('%m/%d/%Y'),:img_url=>"#{small_thumb}",:orginal_img_url=>"#{small_thumb}",:displayDate=>"#{gal.d_createddate.strftime("%b. %d, %Y")}",:type=>"galleries",:navigateUrl=>"/family_memory/gallery_details/#{params[:id]}?moment_id=#{gal.id}&&searchval=#{search}", :response_type => 'navigate_V4',:facebook_share_url=>CGI.escape("http://#{subdomain}.holdmymemories.com/family_memory/gallery_details/#{params[:id]}?gallery_id=#{gal.gallery_id}&&searchval=#{search}&&facebook=#{rand(1000)}&&t=text"),:data_type =>"#{gal.e_filetype}",:video_url=>url,:back_service_url=>"/family_memory/homepage_data/#{params[:id]}",:folder_icon=>"#{small_thumb}",:description=>desc1,:edit_tag_type=>"moment",:studio_sessions=>"false"}
      end
      all_galleries.push(allstudio_gals)
    end
    all_galleries.sort! { |x, y| y[:sort_date] <=> x[:sort_date] }

    #    else
    #      group="gallery_id"
    #      for content in contents
    #        ids.push(content.gallery_id)
    #        user_content_ids.store(content.gallery_id,content.last_moment)
    #      end
    #      galleries_lists=ids.join(",")
    #      if session[:hmm_user]
    #        if logged_in_hmm_user.id==@family_website_owner.id
    #          gal_access="and 1=1"
    #        else
    #          gal_access="and galleries.e_gallery_acess='public'"
    #        end
    #      else
    #        gal_access="and galleries.e_gallery_acess='public'"
    #      end
    #      gals = MobileGallery.find(:all, :joins => "INNER JOIN sub_chapters ON sub_chapters.id = galleries.subchapter_id INNER JOIN tags ON sub_chapters.tagid = tags.id",:conditions => "galleries.id in (#{galleries_lists})  #{gal_access}",
    #        :select =>"tags.v_tagname as chapter_name,sub_chapters.sub_chapname as subchapter_name,galleries.edited_name, galleries.date_updated,galleries.id,galleries.v_gallery_name,galleries.d_gallery_date,galleries.img_url,galleries.v_gallery_image,galleries.v_desc",:group=>"galleries.id")
    #      allstudio_gals=Hash.new
    #      if !gals.nil?
    #        if gals.length>0
    #          for gal in gals
    #            imageName  = gal.v_gallery_image
    #            imageName.slice!(-3..-1)
    #            date_index = user_content_ids.key?(gal.id)
    #            if !gal.edited_name.nil? && !gal.edited_name.blank?
    #              disp_name=gal.edited_name
    #            else
    #              disp_name="#{gal.chapter_name}, #{gal.subchapter_name}, #{gal.v_gallery_name}"
    #            end
    #            if date_index
    #              latest_gal_date = user_content_ids[gal.id]
    #
    #              if !gal.date_updated.nil? && !gal.date_updated.blank?
    #                latest_gal_date=latest_gal_date
    #              else
    #                latest_gal_date=gal.d_gallery_date
    #              end
    #              allstudio_gals={:text=>disp_name,:gallery_id=>gal.id,:file_name=>disp_name,:sort_date=>latest_gal_date.to_date,:created_date=>latest_gal_date.to_date.strftime('%m/%d/%Y'),:img_url=>"#{gal.img_url}/user_content/photos/flex_icon/#{imageName}jpg",:orginal_img_url=>"#{gal.img_url}/user_content/photos/flex_icon/#{imageName}jpg",:displayDate=>"#{latest_gal_date.to_date.strftime("%b. %d, %Y")}",:type=>"galleries",:navigateUrl=>"/family_memory/search_album_tags/#{id}?type_id=#{gal.id}&&searchval=#{search}&&type=gallery", :response_type => 'navigate_V4',:facebook_share_url=>CGI.escape("http://#{subdomain}.holdmymemories.com/family_memory/home/#{id}?familyname=#{id}&&search_albums=true&&search=#{search}&&t=#{rand(1000)}&&t=text"),:data_type => "gallery",:service_url=>"/family_memory/search_album_tags/#{id}?type_id=#{gal.id}&&searchval=#{search}&&type=gallery",:back_service_url=>"",:folder_icon=>"#{gal.img_url}/user_content/photos/icon_thumbnails/#{gal.v_gallery_image}",:description=>gal.v_desc,:edit_tag_type=>"gallery",:studio_sessions=>"true"}
    #              all_galleries.push(allstudio_gals)
    #            end
    #          end
    #        end
    #      end
    #    end
    return all_galleries
  end

  def search_album_tags
    all_galleries=self.get_moment_details(params[:searchval],params[:type_id],params[:type],params[:id])
    render :text=>all_galleries.to_json
  end

  def search_moment_facebook_share
    @results=self.get_moment_details(params[:searchval],params[:type_id],params[:type],params[:id])
    render :layout=>false
  end

  def get_moment_details(searchval,type_id,type,id)
    all_galleries=[]
    subdomain = request.subdomains[0]
    subdomain = 'www' if subdomain.blank?
    search_val = searchval
    #    search_query,search_query_blog,search_album_query=self.search_func(search_val)
    #    arr_imgs=[]
    #
    cond=self.subchapter_public
    if type=="subchapter"
      album_cond="sub_chapid"
    else
      album_cond="gallery_id"
    end
    cond="#{cond} and #{album_cond}=#{type_id}"
    contents=UserContent.find(:all,:conditions=>"status='active'  #{cond} and uid=#{@family_website_owner.id}  and (e_filetype='video' or e_filetype='image')",:order=>"id desc")
    for gal in contents
      allstudio_gals=Hash.new
      if gal.e_filetype=="image"
        small_thumb="#{gal.img_url}/user_content/photos/coverflow/#{gal.v_filename}"
        url="#{gal.img_url}/user_content/photos/coverflow/#{gal.v_filename}"
      elsif gal.e_filetype=="video"
        small_thumb="#{gal.img_url}/user_content/videos/thumbnails/#{gal.v_filename}.jpg"
        url="#{gal.img_url}/user_content/videos/#{gal.v_filename}.flv"
        if params[:myhmm] && params[:myhmm] == "true"
          url="#{gal.img_url}/user_content/videos/iphone/#{gal.v_filename}.mp4"
        end
      end
      if  !gal.audio_tag.blank? || !gal.audio_tag.nil?
        audio_tag= "#{gal.audio_tag_url}/user_content/audio_tags/#{gal.audio_tag}"
      else
        audio_tag= ""
      end

      if !gal.sub_chapid.nil? && gal.sub_chapid > 0
        data_type = "studio"
      else
        data_type = "mobile"
      end
      if gal.v_tagname.nil? || gal.v_tagname == ""
        tag = ""
      else
        tag = gal.v_tagname
      end

      if params[:myhmm] && params[:myhmm] == "true"
        allstudio_gals={:text=>gal.v_tagname,
          :id=>gal.id,
          :sub_chapid=>gal.sub_chapid,
          :tags=>tag,
          :video_path=>url,
          :audio_tag=>audio_tag,
          :file_name=>tag,
          :sort_date=>gal.d_createddate,
          :d_createddate=>gal.d_createddate.strftime('%m/%d/%Y'),
          :img_url=>"#{small_thumb}",
          :big_thumb=>"#{small_thumb}",
          :displayDate=>"#{gal.d_createddate.strftime("%b. %d, %Y")}",
          :type=>"#{gal.e_filetype}",
          :navigateUrl=>"/family_memory/gallery_details/#{id}?moment_id=#{gal.id}&&searchval=#{searchval}",
          :response_type => 'navigate_V4',
          :facebook_share_url=>CGI.escape("http://#{subdomain}.holdmymemories.com/family_memory/home/#{id}?familyname=#{id}&&search_moments=true&&t=#{rand(1000)}&&t=text&&searchval=#{searchval}&&type_id=#{type_id}&&type=#{type}"),
          :data_type =>data_type,
          :video_url=>url,
          :service_url=>"/family_memory/gallery_contents_data/#{id}?gallery_id=#{gal.gallery_id}",
          :back_service_url=>"/family_memory/homepage_data/#{id}"
        }
      else
        allstudio_gals={:text=>gal.v_tagname,:gallery_id=>gal.id,:file_name=>gal.v_tagname,:sort_date=>gal.d_createddate,:created_date=>gal.d_createddate.strftime('%m/%d/%Y'),:img_url=>"#{small_thumb}",:orginal_img_url=>"#{small_thumb}",:displayDate=>"#{gal.d_createddate.strftime("%b. %d, %Y")}",:type=>"galleries",:navigateUrl=>"/family_memory/gallery_details/#{id}?moment_id=#{gal.id}&&searchval=#{searchval}", :response_type => 'navigate_V4',:facebook_share_url=>CGI.escape("http://#{subdomain}.holdmymemories.com/family_memory/home/#{id}?familyname=#{id}&&search_moments=true&&t=#{rand(1000)}&&t=text&&searchval=#{searchval}&&type_id=#{type_id}&&type=#{type}"),:data_type =>"#{gal.e_filetype}",:video_url=>url,:service_url=>"/family_memory/gallery_contents_data/#{id}?gallery_id=#{gal.gallery_id}",:back_service_url=>"/family_memory/homepage_data/#{id}"}
      end
      all_galleries.push(allstudio_gals)
    end
    return  all_galleries
  end

  def search_tags
    @contents=self.search_tag_fun(params[:search])
    render :layout=>false
  end

  def moment_details
    @img=UserContent.find(:first,:conditions=>"id=#{params[:image_id]}")
    @imgs=UserContent.find(:all,:conditions=>"gallery_id=#{params[:gallery_id]} and status='active' and e_access!='private'",:order=>"id desc")
  end


  def homepage_data
    subdomain = request.subdomains[0]
    if session[:hmm_user]
      val=logged_in_hmm_user.id
    else
      val=nil
    end
    result=FamilyMemory.homepage_data(subdomain,session[:hmm_user],@family_website_owner.id,@family_website_owner.family_name,val)
    render :text=>result.to_json
  end

  def homepage_facebook_share
    subdomain = request.subdomains[0]
    if session[:hmm_user]
      val=logged_in_hmm_user.id
    else
      val=nil
    end
    @results=FamilyMemory.homepage_data(subdomain,session[:hmm_user],@family_website_owner.id,@family_website_owner.family_name,val)
    render :layout=>false
  end





  def all_gallery_data_bob
    sub=[]
    sub_data=[]
    user_content_ids = Hash.new
    gal_access=self.gallery_public()
    subdomain = request.subdomains[0]
    subdomain = 'www' if subdomain.blank?
    all_sub_data=UserContent.find(:all,:select=>"distinct(gallery_id),max(d_createddate) as last_moment",:conditions=>"uid=#{@family_website_owner.id} and status='active'  and 	(e_filetype='image' or e_filetype='video') and gallery_id is not null",:group=>"gallery_id")
    for ml_sub in all_sub_data
      sub.push(ml_sub.gallery_id)
      user_content_ids.store(ml_sub.gallery_id,ml_sub.last_moment)
    end
    #logger.info(user_content_ids.inspect)
    mob_sub= sub.join(',')
    cond=self.subchapter_public()
    all_sub_chapters = MobileGallery.find(:all, :joins => "INNER JOIN sub_chapters ON sub_chapters.id = galleries.subchapter_id INNER JOIN tags ON sub_chapters.tagid = tags.id",:conditions => "galleries.id in (#{mob_sub})  #{gal_access} and store_id is null",
      :select =>"tags.v_tagname as chapter_name,sub_chapters.sub_chapname as subchapter_name, galleries.id,galleries.date_updated,galleries.v_gallery_name,galleries.d_gallery_date,galleries.img_url,galleries.v_gallery_image,galleries.v_desc",:group=>"galleries.id")

    # all_sub_chapters=MobileGallery.find(:all,:select=>"id,v_gallery_name,d_gallery_date,img_url,v_gallery_image,v_desc",:conditions=>"status='active'  #{gal_access} and id in (#{mob_sub})",:order=>"id asc")
    for all_gal_ml in all_sub_chapters
      imageName  = all_gal_ml.v_gallery_image
      imageName.slice!(-3..-1)
      names=[]
      chap=all_gal_ml.chapter_name.gsub(" ","")
      if(chap!="MobileUploads")
        names="#{all_gal_ml.chapter_name}, #{all_gal_ml.subchapter_name}, #{all_gal_ml.v_gallery_name}"
      else
        names="#{all_gal_ml.subchapter_name}, #{all_gal_ml.v_gallery_name}"
      end
      date_index = user_content_ids.key?(all_gal_ml.id)
      if date_index
        latest_gal_date = user_content_ids[all_gal_ml.id]
      end
      #latest_gal_date = all_gal_ml.d_gallery_date
      if !all_gal_ml.date_updated.nil? && !all_gal_ml.date_updated.blank?
        latest_gal_date=all_gal_ml.d_gallery_date
      else
        latest_gal_date=latest_gal_date
      end
      allstudio_gals={:text=> names,:gallery_id=>all_gal_ml.id,:file_name=> names,:sort_date=>latest_gal_date.to_date,:created_date=>all_gal_ml.d_gallery_date.strftime('%m/%d/%Y'),:img_url=>"#{all_gal_ml.img_url}/user_content/photos/flex_icon/#{imageName}jpg",:orginal_img_url=>"#{all_gal_ml.img_url}/user_content/photos/flex_icon/#{imageName}jpg",:displayDate=>"#{latest_gal_date.to_date.strftime("%b. %d, %Y")}",:type=>"galleries",:navigateUrl=>"/family_memory/gallery_contents/#{params[:id]}?gallery_id=#{all_gal_ml.id}", :response_type => 'navigate_V4',:facebook_share_url=>CGI.escape("http://#{subdomain}.holdmymemories.com/family_memory/home/#{params[:id]}?familyname=#{params[:id]}&&t=#{rand(1000)}&&fb=text"),:data_type => "gallery",:service_url=>"/family_memory/gallery_contents_data/#{params[:id]}?gallery_id=#{all_gal_ml.id}",:back_service_url=>"",:folder_icon=>"#{all_gal_ml.img_url}/user_content/photos/icon_thumbnails/#{all_gal_ml.v_gallery_image}",:description=>all_gal_ml.v_desc,:edit_tag_type=>"gallery",:studio_sessions=>"false"}
      sub_data.push(allstudio_gals)
    end
    return sub_data
  end




  def gallery_contents
    @paths = ContentPath.find(:first,:conditions=>"status='active'")
    cond=self.subchapter_public()
    if params[:gallery_id]
      cond=self.subchapter_public()
      @img=UserContent.find(:all,:conditions=>"gallery_id=#{params[:gallery_id]} and status='active' #{cond}",:order=>"id desc",:limit=>4)
      @first_img=@img[0]
    elsif params[:subchapter_id]
      @img=UserContent.find(:all,:conditions=>"sub_chapid=#{params[:subchapter_id]} and status='active' #{cond}",:order=>"id desc",:limit=>4)
      @first_img=@img[0]
    elsif params[:searchval]
      @img=UserContent.find(:all,:conditions=>"id in (1,2,3,4) and status='active'",:order=>"id desc",:limit=>4)
      @first_img=@img[0]
    end
    @subchapters=SubChapter.find(:all,:select=>"id,store_id",:conditions=>"store_id!='' #{cond} and uid=#{@family_website_owner.id} and status='active'")
    if @subchapters.length>0
      sub=[]
      for subchapter in @subchapters
        sub.push(subchapter.id)
      end
      sub=sub.join(',')
      cond1=self.gallery_public()

      galleries_lists=[]
      gallery_imgs=UserContent.find(:all,:select=>"distinct(gallery_id)",:conditions=>"sub_chapid in (#{sub}) and status='active' #{cond} and (e_filetype='image' or e_filetype='video')")
      if gallery_imgs
        if gallery_imgs.length>0
          for  gallery_img in gallery_imgs
            galleries_lists.push(gallery_img.gallery_id)
          end
          galleries_lists=galleries_lists.join(",")
          @gals=MobileGallery.find(:all,:joins=>"as a,sub_chapters as b",:select=>"a.id,v_gallery_name,d_gallery_date,a.img_url,v_gallery_image,b.sub_chapname,b.store_id",:conditions=>"a.status='active' and a.subchapter_id=b.id #{cond1} and a.id in (#{galleries_lists})",:group=>"a.id",:order=>"d_gallery_date desc")
        end
      end
    end
    if params[:subchapter_id]
      img_arr=[]
      @galleryUrl = ""
      @swfName1 = "ShareCoverFlow"
      @galleryUrl = "/share/events_moments_list/#{params[:subchapter_id]}"
      for im in @img
        if(im.e_filetype == "video")
          img_arr.push("#{im.img_url}/user_content/videos/thumbnails/#{im.v_filename}.jpg")
        elsif(im.e_filetype == "image")
          img_arr.push("#{im.img_url}/user_content/photos/coverflow/#{im.v_filename}")
        end
      end
      @proxyurls = get_proxy_urls()

      subdomain = request.subdomains[0]
      subdomain = 'www' if subdomain.blank?
      @share_image = img_arr
      @share_video = "http://#{subdomain}.holdmymemories.com/#{@swfName1}.swf?serverUrl=http://#{subdomain}.holdmymemories.com#{@galleryUrl}&buttonsVisible=false&contenturl=#{@proxyurls}"
      @share_type = "video"
    end
  end

  def gallery_contents_data
    subdomain = request.subdomains[0]
    subdomain = 'www' if subdomain.blank?
    all_data=Hash.new
    all_galleries=[]
    cond=self.subchapter_public()
    cond1=self.gallery_public()
    allstudio_gals=Hash.new

    if params[:subchapter_id]
      all_galleries=gallery_moments_data(params[:subchapter_id],"subchapters")
      #      gals=UserContent.find(:all,:select=>"a.*",:joins=>"as a,user_contents as b",:conditions=>"a.subchapter_id=#{params[:subchapter_id]} #{cond1} and a.status='active' and a.id=b.gallery_id  and 	(	a.e_gallery_type='image' or 	a.e_gallery_type='video')",:group=>"a.id",:order=>"a.id asc")
      #      allstudio_gals=Hash.new
      #      if !gals.nil?
      #        if gals.length>0
      #          if gals.length>1
      #            for all_gal_ml in gals
      #              latest_gal_date = all_gal_ml.d_gallery_date
      #              imageName  = all_gal_ml.v_gallery_image
      #              imageName.slice!(-3..-1)
      #              disp_name1="#{all_gal_ml.v_gallery_name}"
      #              allstudio_gals={:text=> disp_name1,:gallery_id=>all_gal_ml.id,:file_name=> disp_name1,:sort_date=>all_gal_ml.d_gallery_date,:created_date=>all_gal_ml.d_gallery_date.strftime('%m/%d/%Y'),:img_url=>"#{all_gal_ml.img_url}/user_content/photos/flex_icon/#{imageName}jpg",:orginal_img_url=>"#{all_gal_ml.img_url}/user_content/photos/flex_icon/#{imageName}jpg",:displayDate=>"#{latest_gal_date.strftime("%b. %d, %Y")}",:type=>"galleries",:navigateUrl=>"/family_memory/gallery_contents/#{params[:id]}?gallery_id=#{all_gal_ml.id}", :response_type => 'navigate_V4',:facebook_share_url=>CGI.escape("http://#{subdomain}.holdmymemories.com/family_memory/gallery_contents/#{params[:id]}?subchapter_id=#{params[:subchapter_id]}&&t=#{rand(1000)}&&ft=text"),:data_type => "gallery",:service_url=>"/family_memory/gallery_contents_data/#{params[:id]}?gallery_id=#{all_gal_ml.id}",:back_service_url=>"/family_memory/gallery_contents_data/#{params[:id]}?gallery_id=#{all_gal_ml.id}",:folder_icon=>"#{all_gal_ml.img_url}/user_content/photos/icon_thumbnails/#{all_gal_ml.v_gallery_image}",:description=>all_gal_ml.v_desc,:edit_tag_type=>"gallery",:studio_sessions=>"false"}
      #              all_galleries.push(allstudio_gals)
      #            end
      #          else
      #            all_galleries=gallery_moments_data(gals[0].id)
      #          end
      #        end
      #      end
    else
      all_galleries=gallery_moments_data(params[:gallery_id],"galleries")
    end
    all_data['body']=all_galleries
    render :text=> all_galleries.to_json
  end

  def gallery_moments_data(gal_id,type)
    all_galleries=[]
    subdomain = request.subdomains[0]
    subdomain = 'www' if subdomain.blank?
    cond=self.subchapter_public()
    if type=="galleries"
      var="gallery_id"
    else
      var="sub_chapid"
    end
    gals=UserContent.find(:all,:conditions=>"#{var}=#{gal_id} #{cond} and status='active' and 	(e_filetype='image' or e_filetype='video')",:group=>"v_filename",:order=>"d_createddate desc")
    for gal in gals
      if gal.e_filetype=="image"
        small_thumb="#{gal.img_url}/user_content/photos/coverflow/#{gal.v_filename}"
        url="#{gal.img_url}/user_content/photos/journal_thumb/#{gal.v_filename}"
      elsif gal.e_filetype=="video"
        small_thumb="#{gal.img_url}/user_content/videos/thumbnails/#{gal.v_filename}.jpg"
        url="#{gal.img_url}/user_content/videos/#{gal.v_filename}.flv"
      end
      allstudio_gals={:text=>gal.v_tagname,:gallery_id=>gal.id,:file_name=>gal.v_tagname,:sort_date=>gal.d_createddate,:created_date=>gal.d_createddate.strftime('%m/%d/%Y'),:img_url=>"#{small_thumb}",:orginal_img_url=>"#{small_thumb}",:displayDate=>"#{gal.d_createddate.strftime("%b. %d, %Y")}",:type=>"galleries",:navigateUrl=>"/family_memory/gallery_details/#{params[:id]}?moment_id=#{gal.id}", :response_type => 'navigate_V4',:facebook_share_url=>CGI.escape("http://#{subdomain}.holdmymemories.com/family_memory/gallery_details/#{params[:id]}?gallery_id=#{gal.gallery_id}&&facebook=#{rand(1000)}&&t=text"),:data_type =>"#{gal.e_filetype}",:video_url=>url,:back_service_url=>"/family_memory/homepage_data/#{params[:id]}",:folder_icon=>"#{small_thumb}",:description=>gal.v_desc,:edit_tag_type=>"moment",:studio_sessions=>"false"}
      all_galleries.push(allstudio_gals)
    end
    return all_galleries
  end


  def get_offers
    cur_date=Date.today
    offers=PackageOffer.find(:all,:select=>"id",:conditions=>"start_date<'#{cur_date}' and end_date>'#{cur_date}' and status='active'")
    arr_off=Array.new
    for offer in offers
      arr_off.push(offer.id)
    end
    logger.info(arr_off.inspect)
    item = arr_off.choice
    offer=PackageOffer.find(:first,:conditions=>"id=#{item}")
    render :text=>"<span>#{offer.title}</span><br />#{offer.description}"
  end

  def search_studio
    render :layout=>false
  end

  def email
    @results = HmmUser.find(:all,:select => "hmm_users.v_user_name,hmm_users.v_fname,hmm_users.v_lname,hmm_studios.studio_name,studio_id", :joins =>" LEFT JOIN hmm_studios
ON hmm_users.studio_id=hmm_studios.id", :conditions => "hmm_users.id=#{@family_website_owner.id}")
    @current_page = 'emailus'
    unless params[:email].blank? && params[:email].blank? && params[:email].blank?
      if verify_recaptcha
        @contactus = ContactU.new()
        @contactus.first_name =params[:name]
        @contactus.subject = "HoldMyMemories.com - #{params[:name]} has sent you an email from HoldMyMemories.com... "
        @contactus.message =params[:message]
        @contactus.email =params[:email]
        users_studio_id = @results[0].studio_id
        if @contactus.save
          Postoffice.deliver_contactUsreportmysite(@contactus.first_name,@contactus.subject,@contactus.message,@contactus.country,@contactus.email,@family_website_owner.v_e_mail,users_studio_id)
          flash[:message] = "Thank You, Your Email has Been Sent to #{@family_website_owner.v_fname} #{@family_website_owner.v_lname}."
        end
        @error1="test"
      else
        flash[:msg] = "Please enter the correct code!"
        @error1="Please enter the correct code!"
      end
    end

    if(params[:contact_u])
      @contact_u = ContactU.new
      if verify_recaptcha
        @result = HmmUser.find(:all,:select => "hmm_users.v_user_name,hmm_studios.studio_name,studio_id,hmm_users.v_fname,hmm_users.v_lname", :joins =>" LEFT JOIN hmm_studios
        ON hmm_users.studio_id=hmm_studios.id", :conditions => "hmm_users.id=#{@family_website_owner.id}")

        @managers1 = MarketManager.count(:first,:select => "a.e_mail", :joins=>" as a,manager_branches as b",
          :conditions => "a.id=b.manager_id and b.branch_id=#{@result[0].studio_id}")
        if(@managers1 > 0)

          @managers = MarketManager.find(:first,:select => "a.e_mail", :joins=>" as a,manager_branches as b",
            :conditions => "a.id=b.manager_id and b.branch_id=#{@result[0].studio_id}")
          @manager_email= @managers.e_mail
        else
          @manager_email=''
        end

        @studios = HmmStudio.find(:first,:select => "studio_name,contact_email,studio_groupid",:conditions => "id=#{@result[0].studio_id}")
        @contact_u = ContactU.new(params[:contact_u])
        @hmm_user_belongs_to = HmmUser.count(:all,:conditions => "v_e_mail='#{@contact_u.email}'")
        studio_group_id = @studios.studio_groupid

        if(@hmm_user_belongs_to > 0)
          @hmm_user_belongs_to_det = HmmUser.find(:all,:conditions => "v_e_mail='#{@contact_u.email}'")
          emp_id= @hmm_user_belongs_to_det[0]['emp_id']
          customer_name="#{@hmm_user_belongs_to_det[0]['v_fname']} #{@hmm_user_belongs_to_det[0]['v_lname']}"
          acc_type=@hmm_user_belongs_to_det[0]['account_type']
          if(acc_type=="free_user")
            customer_account="Free User Account"
          else
            if(acc_type=="platinum_user")
              customer_account="Premium User Account"
            else
              customer_account="Family Website User Account"
            end
          end


          #studio_group_id = @studios.studio_groupid
          if(emp_id=='' || emp_id==nil )
            @contact_u.subject = "HoldMyMemories Contact Us Information..."
            Postoffice.deliver_contactUsreport_email1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,"Direct User","No employee involved",customer_name,customer_account,@studios.contact_email,@manager_email,studio_group_id)

          else
            @employee_details = EmployeAccount.find(emp_id)
            branch = @employee_details.branch
            e_mail = @employee_details.e_mail
            emp_name = @employee_details.employe_name
            @contact_u.subject = "HoldMyMemories Contact Us Information..."


            #           click_studio_id = 3
            #emp_store_id = @employee_details.store_id
            #   studio_group_id = @studios.studio_groupid
            #
            #,emp_store_id
            #            if(@studios.studio_groupid == click_studio_id && @studios.id == emp_store_id)
            #              @manager_email = ,+"seth.johnson@holdmymemories.com,angie@holdmymemories.com"
            #            end
            #  Postoffice.deliver_contactUsreport_email1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,@studios.studio_name,emp_name,customer_name,customer_account,@studios.contact_email,@manager_email,emp_store_id,studio_group_id)

            Postoffice.deliver_contactUsreport_email1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,@studios.studio_name,emp_name,customer_name,customer_account,@studios.contact_email,@manager_email,studio_group_id)
          end
        else
          @contact_u.subject = "HoldMyMemories Contact Us Information..."
          Postoffice.deliver_contactUsreport_email(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,@contact_u.zip,@contact_u.phone_no,@contact_u.mobile_no,@studios.contact_email,@manager_email,studio_group_id)

        end
        @contact_u.subject = "HoldMyMemories Contact Us Information..."
        if @contact_u.save
          Postoffice.deliver_contactUsreport(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email)
          flash[:notice_contact] = "Thank You, Your Email has Been Sent to #{@studios.studio_name}"
        else
          redirect_to :action => 'email'
        end
        @error2='test'
      else
        flash[:error] = 'Please enter the correct image code!'
        @error2='Please enter the correct image code!'
      end
    end
  end

  def upload_old
    mobile_chapter = MobileTag.find(:first,:conditions => "uid = #{@family_website_owner.id} and tag_type = 'mobile_uploads' and status='active'")
    @all_albums = Array.new
    if mobile_chapter==nil
      mobile_chapter=MobileTag.save_mobile_uploads_chapter(@family_website_owner.id)
    end
    times = Time.new
    t= times.year
    mobile_subchapter= MobileSubChapter.find(:first,:conditions=>"tagid=#{mobile_chapter.id} AND status='active' AND uid=#{@family_website_owner.id} and subchapter_type='memory_lane' and status='active'")
    if mobile_subchapter==nil
      MobileSubChapter.save_memory_lane_subchapter("#{times.year} (Uncategorized)",'Enter description here...',@family_website_owner.id, mobile_chapter.id)
    else
      sub_crr_year=SubChapter.find(:first,:conditions =>"tagid=#{mobile_chapter.id} and 	created_at  >'#{t}-1-1 00:00:00' and created_at  <'#{t}-12-31 23:59:59' and subchapter_type = 'memory_lane' and status='active'")
      if sub_crr_year == nil
        mobile_subchapter.subchapter_type="old_memory_lane";
        mobile_subchapter.save
        MobileSubChapter.save_memory_lane_subchapter("#{times.year} (Uncategorized)",'Enter description here...',@family_website_owner.id, mobile_chapter.id)
      end
    end
    mobile_events = MobileSubChapter.find(:all,:conditions=>"tagid=#{mobile_chapter.id} AND status='active' AND uid=#{@family_website_owner.id}", :select => "id, sub_chapname, subchapter_type")
    mobile_events.each { |mobile_event|
      sub_chapter_name = mobile_event.sub_chapname
      sub_chapter_id = mobile_event.id
      sub_chapter_type = mobile_event.subchapter_type
      @all_albums.push(:sub_chapter_id => sub_chapter_id, :sub_chapter_name => sub_chapter_name, :sub_chapter_type => sub_chapter_type)
    }
    logger.info("**********@all_albums************")
    logger.info @all_albums.inspect
    #    render :text => all_albums.to_json

    #    if iphone_request?
    #      respond_to do |format|
    #        format.iphone do  # action.iphone.erb
    #        end
    #      end
    #    end
  end

  def upload2
  end

  def upload_select
    render :layout => false
  end

  def upload_data
    mobile_chapter = MobileTag.find(:first,:conditions => "uid = #{@family_website_owner.id} and tag_type = 'mobile_uploads' and status='active'")
    all_albums = Array.new
    if mobile_chapter==nil
      mobile_chapter=MobileTag.save_mobile_uploads_chapter(@family_website_owner.id)
    end
    times = Time.new
    t= times.year
    mobile_subchapter= MobileSubChapter.find(:first,:conditions=>"tagid=#{mobile_chapter.id} AND status='active' AND uid=#{@family_website_owner.id} and subchapter_type='memory_lane' and status='active'")
    if mobile_subchapter==nil
      MobileSubChapter.save_memory_lane_subchapter("#{times.year} (Uncategorized)",'Enter description here...',@family_website_owner.id, mobile_chapter.id)
    else
      sub_crr_year=SubChapter.find(:first,:conditions =>"tagid=#{mobile_chapter.id} and 	created_at  >'#{t}-1-1 00:00:00' and created_at  <'#{t}-12-31 23:59:59' and subchapter_type = 'memory_lane' and status='active'")
      if sub_crr_year == nil
        mobile_subchapter.subchapter_type="old_memory_lane";
        mobile_subchapter.save
        MobileSubChapter.save_memory_lane_subchapter("#{times.year} (Uncategorized)",'Enter description here...',@family_website_owner.id, mobile_chapter.id)
      end
    end
    mobile_events = MobileSubChapter.find(:all,:conditions=>"tagid=#{mobile_chapter.id} AND status='active' AND uid=#{@family_website_owner.id}", :select => "id, sub_chapname, subchapter_type")
    mobile_events.each { |mobile_event|
      sub_chapter_name = mobile_event.sub_chapname
      sub_chapter_id = mobile_event.id
      sub_chapter_type = mobile_event.subchapter_type
      all_albums.push(:sub_chapter_id => sub_chapter_id, :sub_chapter_name => sub_chapter_name, :sub_chapter_type => sub_chapter_type)
    }
    render :text => all_albums.to_json
  end

  def contest

  end

  def blog
    params[:order]=CGI.escapeHTML(params[:order])
    params[:page]=CGI.escapeHTML(params[:page])
    params[:id]=CGI.escapeHTML(params[:id])
    @current_page = 'blog'
    if(params[:order])
      order=params[:order]
    else
      order="desc"
    end
    if !params[:search].nil? && !params[:search].blank?
      search="and blogs.title like '%#{params[:search]}%'"
    else
      search=""
    end
    if session[:hmm_user]
    else
      cond="and access='public'"
    end
    @conditions= ["user_id = #{@family_website_owner.id} AND blogs.status='active' #{cond}"]

    @entries = Blog.paginate  :per_page => 4, :page => params[:page],:conditions => "#{@conditions} #{search}",
      :joins =>"LEFT JOIN tags on (blogs.blog_type='chapter' and blogs.blog_type_id = tags.id)
        LEFT JOIN sub_chapters on (blogs.blog_type='subchapter' and blogs.blog_type_id = sub_chapters.id)
        LEFT JOIN galleries on (blogs.blog_type='gallery' and blogs.blog_type_id = galleries.id)
        LEFT JOIN user_contents on (blogs.blog_type in ('image','audio','video') and blogs.blog_type_id = user_contents.id) and blogs.client='website'
        LEFT JOIN mobile_blog_contents on blogs.client='iphone' and blogs.blog_type in ('image','audio','video') and blogs.blog_type_id=mobile_blog_contents.id",
      :select => "blogs.id as blog_id,blog_type,blogs.client,title,description,blog_type_id,DATE_FORMAT(blogs.added_date,'%b %d, %Y') as created_date,
        tags.v_chapimage as chapter_image, tags.img_url as tag_url,
        sub_chapters.v_image as subchapter_image,sub_chapters.img_url as sub_chapter_url,
        galleries.v_gallery_image as gallery_image,galleries.img_url as galleries_url,
        CONCAT(user_contents.img_url,'/user_content/photos/big_thumb/',v_filename) as content_image_url,
        CONCAT(user_contents.img_url,'/user_content/videos/thumbnails/',v_filename,'.jpg') as content_video_url,
        CONCAT(user_contents.img_url,'/user_content/audios/speaker.jpg') as content_audio_url,
        tags.tag_type as chapter_type,galleries.e_gallery_type as gallery_type,mobile_blog_contents.server_url as mobile_server_url,
        mobile_blog_contents.file_name as mobile_file_name",:order=>"blogs.added_date #{order}"

    @results = FamilyMemory.format_results(@entries,params[:id],@family_website_owner.img_url)

    #recent entries
    @total=Blog.count(:all,:conditions => @conditions,:order =>"blogs.added_date #{order}")
  end

  def blog_view

    unless params[:bid].blank?
      @current_page = 'blog'
      @conditions= "user_id = #{@family_website_owner.id} AND blogs.id=#{params[:bid]} AND blogs.status='active'"
      @entries = Blog.find(:all,:conditions => @conditions,
        :joins =>"LEFT JOIN tags on (blogs.blog_type='chapter' and blogs.blog_type_id = tags.id)
        LEFT JOIN sub_chapters on (blogs.blog_type='subchapter' and blogs.blog_type_id = sub_chapters.id)
        LEFT JOIN galleries on (blogs.blog_type='gallery' and blogs.blog_type_id = galleries.id)
        LEFT JOIN user_contents on (blogs.blog_type in ('image','audio','video') and blogs.blog_type_id = user_contents.id) and blogs.client='website'
        LEFT JOIN mobile_blog_contents on blogs.client='iphone' and blogs.blog_type in ('image','audio','video') and blogs.blog_type_id=mobile_blog_contents.id",
        :select => "blogs.id as blog_id,blog_type,blogs.client,title,description,blog_type_id,DATE_FORMAT(blogs.added_date,'%W, %b %d, %Y') as created_date,
        tags.v_chapimage as chapter_image, tags.img_url as tag_url,
        sub_chapters.v_image as subchapter_image,sub_chapters.img_url as sub_chapter_url,
        galleries.v_gallery_image as gallery_image,galleries.img_url as galleries_url,
        user_contents.v_filename  as v_filename,
        user_contents.img_url as uimg_url,
        user_contents.e_filetype as filetype,
        user_contents.id as user_content_id,
        CONCAT(user_contents.img_url,'/user_content/photos/big_thumb/',v_filename) as content_image_url,
        CONCAT(user_contents.img_url,'/user_content/videos/thumbnails/',v_filename,'.jpg') as content_video_url,
        CONCAT(user_contents.img_url,'/user_content/audios/speaker.jpg') as content_audio_url,
        tags.tag_type as chapter_type,galleries.e_gallery_type as gallery_type,mobile_blog_contents.server_url as mobile_server_url,
        mobile_blog_contents.file_name as mobile_file_name", :limit => 1)
      @results = FamilyMemory.format_results(@entries,params[:id],@family_website_owner.img_url)
      @proxyurls = get_proxy_urls()
      logger.info(@results.inspect)
      #Blog Comments
      @blog_comments=BlogComment.find(:all,:conditions=>"blog_id=#{params[:bid]} and status='approved'")

      if(@results[0][:type]=="image")
        @share_image = "#{@results[0][:thumbnail]}"
        description = @results[0][:description]
        @description=description.gsub("\n", "<br />\n")
        @share_type="image"
        @title=@results[0][:title]
      elsif(@results[0][:type] =="video")
        @share_image = "#{@results[0][:thumbnail]}"
        @share_video = "http://blog.holdmymemories.com/BlogVideoPlayer.swf?videopath=#{@results[0][:uimg_url]}/user_content/videos/#{@results[0][:filename]}.flv"
        @share_type = "video"
      end
    else
      redirect_to :controller =>'blog', :action => 'index', :id => params[:id]
    end
  end

  def delete_blog
    if params[:blog_id]
      blog=Blog.find(:first,:conditions=>"id=#{params[:blog_id]} and 	user_id=#{@family_website_owner.id}")
      blog.status="inactive"
      blog.save
      flash[:notice1]="Blog entry has been removed"
      redirect_to params[:redirect_url]
    end
  end

  def get_proxy_urls
    proxyurls = nil
    contentservers = ContentPath.find(:all)
    for server in contentservers
      if(proxyurls == nil)
        proxyurls = server['content_path']
      else
        proxyurls = proxyurls +','+server['content_path']
      end
    end
    return proxyurls
  end


  def order_prints
    @paths = ContentPath.find(:first,:conditions=>"status='active'")
    @path1 = ContentPath.find(:all)
    @path=""
    for path in @path1
      @path="#{@path}#{path.content_path},"
    end
    if params[:moment_id]
      @img=UserContent.find(:first,:conditions=>"id=#{params[:moment_id]}")
      @first_img=@img
    elsif params[:gallery_id]
      @img=UserContent.find(:first,:conditions=>"gallery_id=#{params[:gallery_id]} and status='active' and e_access!='private'",:order=>"id desc")
      @first_img=@img
    end
    if(@first_img.e_filetype =="image")
      @share_image = "#{@first_img.img_url}/user_content/photos/coverflow/#{@first_img.v_filename}"
      @share_type="image"
    elsif(@first_img.e_filetype =="video")
      @share_image = "#{@first_img.img_url}/user_content/videos/thumbnails/#{@first_img.v_filename}.jpg"
      @share_video = "http://blog.holdmymemories.com/BlogVideoPlayer.swf?videopath=#{@first_img.img_url}/user_content/videos/#{@first_img.v_filename}.flv"
      @share_type = "video"
    end
  end

  def popup_login
    user = HmmUser.find_by_family_name(params[:id])
    studio = HmmStudio.find(user.studio_id) rescue nil

    if user.v_user_name == params[:username]
      @current_page = 'login'

      if logged_in_hmm_user && @family_website_owner.id == logged_in_hmm_user.id && @family_website_owner.terms_checked =="true" && studio.family_website_version == 2
        redirect_to :action => 'home', :id => params[:id]
      end
      if params[:username] == "" && params[:password] == ""
        redirect_to :action => 'home', :id => params[:id]
      end

      unless params[:username].blank? && params[:password].blank?
        self.logged_in_hmm_user = HmmUser.authenticate(params[:username],params[:password])
        if is_userlogged_in?
          if logged_in_hmm_user.e_user_status == 'unblocked'
            logger.info("[User]: #{[:username]} [Logged In] at #{Time.now} !")
            logger.info(logged_in_hmm_user.id)
            @user_session = UserSessions.new()
            @user_session['i_ip_add'] = request.remote_ip
            @user_session['uid'] = logged_in_hmm_user.id
            @user_session['v_user_name'] = logged_in_hmm_user.v_user_name
            @user_session['d_date_time'] = Time.now
            @user_session['e_logged_in'] = "yes"
            @user_session['e_logged_out'] = "no"
            @user_session.save

            logger.info(@family_website_owner.terms_checked)
            if studio.nil?
              redirect_to "/family_memory/upgrade_account_form/#{params[:id]}?acc_type=platinum_account&option=1"
            elsif studio.family_website_version == 3
              redirect_to :controller=>"family_memory",:action => 'print_orders', :id => params[:id]
            else

              if @family_website_owner.id == logged_in_hmm_user.id
                session[:visitor] = params[:id]
                if (@family_website_owner.account_expdate!=nil && @family_website_owner.account_expdate < Date.current())
                  redirect_to "/family_memory/upgrade_account_form/#{params[:id]}?acc_type=platinum_account&option=1"
                elsif(session[:employe]==nil && @family_website_owner.terms_checked =="false")
                  redirect_to "/user_account/update_terms/"
                else
                  unless params[:redirect_url].blank?
                    redirect_to "#{params[:redirect_url]}"
                  else
                    @Contents = UserContent.find(:first, :conditions => "e_filetype= 'image' and status='active' and e_access='public' and uid=#{@family_website_owner.id}",:group => "id", :order=>"sub_chapid desc")
                    redirect_to "/family_memory/order_prints/#{params[:id]}?moment_id=#{@Contents.id}"
                  end
                end
              else
                session[:hmm_user]=nil
                flash[:error] = " Invalid Login.You must be the owner of this site."
                #log file entry
                logger.error("[Invalid Login]: by [User]:#{params[:username]} at #{Time.now}")
              end
            end
          else
            session[:hmm_user]=nil
            flash[:error] = "User is been blocked.. Contact Admin!!"
          end
        else
          flash[:error] = "Either your username or password is incorrect. Please try again."
          #log file entry
          logger.error("[Invalid Login]: by [User]:#{params[:username]} at #{Time.now}")
          redirect_to :action => 'home', :id => params[:id]
        end
      end
    else
      flash[:error] = "Either your username or password is incorrect. Please try again."
      redirect_to :action => 'home', :id => params[:id]
    end
  end

  def print_orders
    user = HmmUser.find_by_family_name(params[:id])
    if session[:hmm_user] or user.v_user_name == params[:username] or session[:visitor_id]
      @path1 = ContentPath.find(:first, :conditions => "status='active'")
      if session[:visitor_id]
        content1 = ContentPath.find(:first, :conditions => "status='inactive'")
        @content_server_url = content1.content_path
      end
    else
      flash[:error] = "Either your username or password is incorrect. Please try again."
      redirect_to :controller=>"family_memory",:action => 'home', :id => params[:id]
    end
  end

  def order_prints_login
    render :layout =>false
  end

  def requesting_owner
    if simple_captcha_valid?
      puts "========================"
      unless params[:user][:name] == "" and params[:user][:email] == ""
        puts params[:id]
        puts params.inspect
        owner = HmmUser.find_by_family_name(params[:id])
        @path = ContentPath.find(:all)
        code = OrderRequest.find_by_sql("select uuid() as id")
        orders = OrderRequest.count(:conditions=>"email_address='#{params[:user][:email]}' and owner_id=#{owner.id}")
        puts "========================"
        if orders==0
          order_request = OrderRequest.new
          order_request.owner_id = owner.id
          order_request.email_address = params[:user][:email]
          order_request.message = params[:user][:body]
          order_request.requested_by = params[:user][:name]
          order_request.status = nil
          order_request.request_code = nil
          order_request.save

          order_request_status = OrderRequestStatus.new
          order_request_status.owner_id = owner.id
          order_request_status.visitor_id = order_request.id
          order_request_status.status = "pending"
          order_request_status.save
          code = "#{order_request_status.id}_#{code.id}"
          version = "v4"
          logger.info("order_request_status.id")
          logger.info(order_request_status.id)
          logger.info(code)
          #  -----        Postoffice.deliver_requesting_owner1(owner.v_e_mail, order_request.email_address,order_request.requested_by,order_request.message,owner.family_name,@path[0].proxyname,code)
          Postoffice.deliver_requesting_owner1(owner.v_e_mail, order_request.email_address,order_request.requested_by,order_request.message,owner.family_name,@path[0].proxyname,code,version)
          flash[:notice] = "Your request has been sent to #{owner.family_name}"
        else

          flash[:notice] = "Your have already sent request once try with other email ID"
        end
      end
    else
      flash[:notice] = "Invalid Captcha and can't be empty."
    end
    logger.info(flash[:notice])
    redirect_to :action=>"home",:id=>params[:id]
  end

  def addblog_comment
    unless params[:comment].blank?
      if session[:hmm_user]
        @guest_comment = BlogComment.new()
        @guest_comment['blog_id'] = params[:blog_id]
        @guest_comment['name'] = @family_website_owner.v_user_name
        @guest_comment['comment'] = params[:comment]
        @guest_comment['status'] = 'approved'
        if @guest_comment.save
          flash[:message] = 'Comment added successfully!'
        else
          flash[:message] = 'Add Comment failed...'
        end
      else
        if verify_recaptcha
          @guest_comment = BlogComment.new()
          @guest_comment['blog_id'] = params[:blog_id]
          @guest_comment['name'] = params[:name]
          @guest_comment['comment'] = params[:comment]
          @guest_comment['status'] = 'pending'
          if @guest_comment.save
            $notice_guest
            Postoffice.deliver_comment(params[:comment],'0','Blog Comment',params[:name],@family_website_owner.v_e_mail,@family_website_owner.v_user_name,@family_website_owner.v_e_mail,@family_website_owner.v_myimage,@family_website_owner.img_url)
            flash[:message] = 'Comment added successfully!'
          else
            flash[:message] = 'Add Comment failed...'
          end
          #redirect_to :controller =>'blog', :action => 'view_more', :id => params[:id] , :bid => params[:blog_id]
        else
          flash[:message] = 'Please enter the correct code!'
        end
      end
    end
    render :layout => false
  end



  def select_gallery
    @path=ContentPath.find(:first,:conditions=>"status='active'")
    subchapters=SubChapter.find(:all,:select=>"id",:conditions=>"store_id!='' and uid=#{@family_website_owner.id} and status='active'")
    if subchapters
      sub=[]
      for subchapter in subchapters
        sub.push(subchapter.id)
      end
      sub=sub.join(',')
      @gals=Galleries.find(:all,:select=>"a.id as gal_id,b.id as img_id,a.v_gallery_name,a.d_gallery_date,a.img_url,a.v_gallery_image,a.d_gallery_date",:joins=>"as a,user_contents as b",:conditions=>"a.subchapter_id in (#{sub}) and a.e_gallery_acess!='private' and a.status='active' and 	a.e_gallery_type='image' and a.id=b.gallery_id",:group=>"a.id",:order=>"a.id asc")

    end
    render :layout=>false
  end

  def new_text_blogentry
    if params[:title] && params[:desc] && params[:blog]
      blogdate="#{params[:blog]['added_date(1i)']}-#{params[:blog]['added_date(2i)']}-#{params[:blog]['added_date(3i)']}"

      @text_journal = Blog.new()
      @text_journal['title']=params[:title]
      @text_journal['description']=params[:desc]
      @text_journal['blog_type']='text'
      @text_journal['user_id']=logged_in_hmm_user.id
      @text_journal['added_date']=blogdate

      if @text_journal.save
        flash[:message] = 'Text blog entry added successfully!'
      else
        flash[:message] = 'Text blog entry failed!'
      end
      render :layout => false
    else
      render :layout=>false
    end
  end

  def edit_blog
    @blog=Blog.find(params[:blog_id])
    if params[:submit]
      blogdate="#{params[:blog]['added_date(1i)']}-#{params[:blog]['added_date(2i)']}-#{params[:blog]['added_date(3i)']}"
      blog=Blog.find(:first,:conditions=>"id=#{params[:blog_id]} and 	user_id=#{@family_website_owner.id}")
      blog.title=params[:title]
      blog.description=params[:desc]
      blog.added_date=blogdate
      blog.save
      redirect_to params[:redirect_url]
    else
      render :layout=>false
    end
    #    if params[:title] && params[:desc] && params[:blog]
    #      blogdate="#{params[:blog]['added_date(1i)']}-#{params[:blog]['added_date(2i)']}-#{params[:blog]['added_date(3i)']}"
    #
    #      @text_journal = Blog.new()
    #      @text_journal['title']=params[:title]
    #      @text_journal['description']=params[:desc]
    #      @text_journal['blog_type']='text'
    #      @text_journal['user_id']=logged_in_hmm_user.id
    #      @text_journal['added_date']=blogdate
    #
    #      if @text_journal.save
    #        flash[:message] = 'Text blog entry added successfully!'
    #      end
    #      redirect_to :controller =>'family_memory', :action => 'blog', :id => params[:id]
    #    else

    #  end
  end


  def logout
    user = HmmUser.find(session[:hmm_user]) rescue nil
    unless user.nil?
      if user.studio_id == 0
      else
        studio = HmmStudio.find(user.studio_id) rescue nil
      end
    end

    if(session[:hmm_user])
      @user_session = UserSessions.new()
      @user_session['uid'] = logged_in_hmm_user.id if (logged_in_hmm_user.id)
      @user_session['v_user_name'] = logged_in_hmm_user.v_user_name if (logged_in_hmm_user.v_user_name)
      @user_session['d_date_time'] = Time.now
      @user_session['i_ip_add'] = request.remote_ip
      @user_session['e_logged_in'] = "no"
      @user_session['e_logged_out'] = "yes"
      @user_session.save
    end

    reset_session
    flash[:error] = "You have been successfully logged out."
    unless user.nil? or params[:visitor] == "visitor"
      #      if studio.nil?
      redirect_to :controller=>"family_memory",:action => 'home', :id => params[:id]
      #      elsif studio.family_website_version == 3
      #        redirect_to :action => 'home',:id=>params[:id]
      #      else
      #        redirect_to :action => 'login', :id => params[:id]
      #      end
    else
      redirect_to :controller=>"order_request",:action => 'visitor_login'
    end
  end


  def studio_list
    @radius=params[:radius].split(' ')
    @result=ZipCode.zip_code_perimeter_search(params[:zipcode],@radius[0])
    pp @result


  end

  def share_blog
    @jtype = params[:blog_id]
    @temp = params[:blog_type]
    @family_name_tag = params[:id]
    @userid = HmmUser.find(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')")
    @uid = @userid[0]['id']
    @symb='&'
  end

  def share_blog_email
    @userid = HmmUser.find(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')")
    if params[:message]
      @message = params[:message]
    end
    @jid=params[:blog_id]
    @jtype = params[:blog_type]

    journal = Journal

    #   INSERTING NON-HMM USERS IN SHARE'S TABLE
    if params[:nhmmuser]
      @nonhmmusers = params[:nhmmuser]
      nonhmmids = @nonhmmusers.join(",")
      @nonhmm = NonhmmUser.find(:all, :conditions => "id in (#{nonhmmids})",:group=>"v_email")
      for j in @nonhmm
        @share_max =  ShareJournal.find_by_sql("select max(id) as n from share_journals")
        for share_max in @share_max
          share_max_id = "#{share_max.n}"
        end
        if(share_max_id == '')
          share_max_id = '0'
        end
        share_next_id= Integer(share_max_id) + 1
        @share = ShareJournal.new
        @share['presenter_id']=logged_in_hmm_user.id
        @share['jid']= @jid
        @share['jtype']=@jtype
        @share['e_mail']= j.v_email
        @share['created_date']=Time.now
        @share['expiry_date']=Time.now.advance(:months => 1, :years => 0)
        @share['message']=@message
        shareuuid=Share.find_by_sql("select uuid() as uid")
        unid=shareuuid[0].uid+""+"#{share_next_id}"
        @share['unid']=unid
        @share.save
        Postoffice.deliver_family_share_blog(@share['e_mail'],@message,journal,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.family_pic,@share.id,@share.unid,logged_in_hmm_user.img_url,logged_in_hmm_user.family_name,@jid)
        $share_journalredirect
        flash[:message] = 'Blog was successfully shared!!'
        link = "/family_memory/blog/#{params[:id]}"
      end
    end

    #   INSERTING E-MAIL ID'S
    if params[:email]
      @count = 0
      @frdEmail = params[:email]
      frindsEmail=@frdEmail.split(',')
      for k in frindsEmail
        @share_max =  ShareJournal.find_by_sql("select max(id) as n from share_journals")
        for share_max in @share_max
          share_max_id = "#{share_max.n}"
        end
        if(share_max_id == '')
          share_max_id = '0'
        end
        share_next_id= Integer(share_max_id) + 1
        @check_hmmusers = HmmUser.count(:all, :conditions => "v_e_mail='#{k}'")
        if(@check_hmmusers > 0)
          @check_hmmusers = HmmUser.find(:all, :conditions => "v_e_mail='#{k}'")
          @blocked_friend = FamilyFriend.count(:all,:conditions => "uid='#{@check_hmmusers[0]['id']}' and fid='#{logged_in_hmm_user.id}' and block_status='block'")
          if(@blocked_friend <= 0)
            @blocked_friend =  0
          else
            @blocked_friend = 1
          end
        else
          @blocked_friend = 0
        end
        if(@blocked_friend <= 0)
          if session[:hmm_user]
            email = params[:email]
            @frindsEmail=email.split(',')
            size = @frindsEmail.size
            for k in @frindsEmail
              #@friendscheck = NonhmmUser.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and v_email='#{k}'")
              @friendscheck = NonhmmUser.count_by_sql("SELECT count(*) FROM nonhmm_users where  v_email='#{k}' and uid=#{@userid[0]['id']} group by v_email")
              i=0
              until i == size
                i=i+1
                if @friendscheck != 1
                  @count = @count + 1
                else

                end
              end
            end
            if @count == 0
              link = "/family_memory/blog/#{params[:id]}"
            else
              link="/family_memory/add_nonhmm/#{params[:id]}/?pa=#{params[:email]}"
            end
          else
            link = "/family_memory/blog/#{params[:id]}"
          end
          @share = ShareJournal.new
          @share['presenter_id']=logged_in_hmm_user.id
          @share['jid']=@jid
          @share['jtype']=@jtype
          @share['e_mail']= k
          @share['created_date']=Time.now
          @share['expiry_date']=Time.now.advance(:months => 1, :years => 0)
          @share['message']=@message
          shareuuid=Share.find_by_sql("select uuid() as uid")
          unid=shareuuid[0].uid+""+"#{share_next_id}"
          @share['unid']=unid
          @share.save
          Postoffice.deliver_family_share_blog(@share['e_mail'],@message,journal,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.family_pic,@share.id,@share.unid,logged_in_hmm_user.img_url,logged_in_hmm_user.family_name,@jid)
        end
      end
    end

    flash[:message] = 'Blog was successfully shared!!'
    #redirect_to :controller => 'blog', :action => 'list', :id => "#{params[:id]}"
    redirect_to link

  end

  def share
    @conditions= "user_id = #{@family_website_owner.id} AND blogs.id=#{params[:blog_id]} AND blogs.status='active'"
    @entries = Blog.find(:all,:conditions => @conditions,
      :joins =>"LEFT JOIN tags on (blogs.blog_type='chapter' and blogs.blog_type_id = tags.id)
        LEFT JOIN sub_chapters on (blogs.blog_type='subchapter' and blogs.blog_type_id = sub_chapters.id)
        LEFT JOIN galleries on (blogs.blog_type='gallery' and blogs.blog_type_id = galleries.id)
        LEFT JOIN user_contents on (blogs.blog_type in ('image','audio','video') and blogs.blog_type_id = user_contents.id) and blogs.client='website'
        LEFT JOIN mobile_blog_contents on blogs.client='iphone' and blogs.blog_type in ('image','audio','video') and blogs.blog_type_id=mobile_blog_contents.id",
      :select => "blogs.id as blog_id,blog_type,blogs.client,title,description,blog_type_id,DATE_FORMAT(blogs.added_date,'%W, %b %d, %Y') as created_date,
        tags.v_chapimage as chapter_image,
        sub_chapters.v_image as subchapter_image,
        galleries.v_gallery_image as gallery_image,
        galleries.img_url as galleries_url,
        user_contents.v_filename  as v_filename,
        user_contents.img_url as uimg_url,
        user_contents.e_filetype as filetype,
        user_contents.id as user_content_id,
        CONCAT(user_contents.img_url,'/user_content/photos/big_thumb/',v_filename) as content_image_url,
        CONCAT(user_contents.img_url,'/user_content/videos/thumbnails/',v_filename,'.jpg') as content_video_url,
        CONCAT(user_contents.img_url,'/user_content/audios/speaker.jpg') as content_audio_url,
        tags.tag_type as chapter_type,galleries.e_gallery_type as gallery_type,mobile_blog_contents.server_url as mobile_server_url,
        mobile_blog_contents.file_name as mobile_file_name", :limit => 1)
    @results = FamilyMemory.format_results(@entries,params[:id],@family_website_owner.img_url)
    @proxyurls = get_proxy_urls()
    if(@results[0][:type]=="image")
      @share_image = "#{@results[0][:thumbnail]}"
      description = @results[0][:description]
      @description=description.gsub("\n", "<br />\n")
      @share_type="image"
      @title=@results[0][:title]
    elsif(@results[0][:type] =="video")
      @share_image = "#{@results[0][:thumbnail]}"
      @share_video = "http://blog.holdmymemories.com/BlogVideoPlayer.swf?videopath=#{@results[0][:uimg_url]}/user_content/videos/#{@results[0][:filename]}.flv"
      @share_type = "video"
    end
    render :layout=>false
  end

  def edit_profile
    @paths = ContentPath.find(:first,:conditions=>"status='active'")
    @path1 = ContentPath.find(:all)
    @path2=""
    for path in @path1
      @path2="#{@path}#{path.content_path},"
    end
    @content_server_url = "#{@paths.content_path}"
    subdomain = request.subdomains[0]
    logger.info(subdomain)
    current= request.url.split("http://")
    current1= current[1].split("/")
    if current1[0]=="holdmymemories.com"
      @app_url="http://holdmymemories.com"
    else
      @app_url="http://www.holdmymemories.com"
    end
    @family_website_owner = HmmUser.find(:first, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')") #get the user details
    @hmm_user = HmmUser.find(@family_website_owner.id)
    @path=ContentPath.find(:first,:conditions=>"status='active'")
    uid1 = @hmm_user.id
    @path=ContentPath.find(:first,:conditions=>"status='active'")
    @all_comments = ChapterComment.find_by_sql("
     (select
        c.id as id,
        c.gallery_id as master_id,
        c.v_comment as comment,
        c.reply as reply,
        c.e_approval as e_approval,
        c.ctype as ctype,
        c.v_name as name,
        c.uid as user_id,
        c.d_created_on as d_created_at
        from
        gallery_comments    as c,
        user_contents as u
        where
        c.gallery_id=u.gallery_id
        and
        c.uid=#{uid1}
        and c.e_approval = 'pending'
        )
     union
    (select
        d.id as id,
        d.user_content_id as master_id,
        d.v_comment as comment,
        d.reply as reply,
        d.e_approved as e_approval,
        d.ctype as ctype,
        d.v_name as name,
        d.uid as user_id,
        d.d_add_date as d_created_at
        from
        photo_comments  as d,
        user_contents as u
        where
        d.user_content_id=u.id
        and
        u.uid=#{uid1}
        and d.e_approved = 'pending'
     )
     union
    (select
        b.id as id,
        b.blog_type_id as master_id,
        bc.comment as message,
        bc.id as reply,
        bc.status as e_approval,
        b.client as ctype,
        bc.name as name,
        b.user_id as user_id,
        bc.created_at as d_created_at
        from
        blog_comments as bc,
        blogs as b
        where b.id=bc.blog_id
        and
        b.user_id=#{uid1}
        and bc.status = 'pending'
     )
     order by e_approval")
    #    @blogcmt = Blog.count(:all,:joins=>" as a , blog_comments as b", :conditions => "a.id=b.blog_id and a.user_id='#{logged_in_hmm_user.id}' and b.status='pending' ")
    #    @comments = PhotoComment.count(:all,:select=>"distinct(a.id)",:joins=>"as a,user_contents as b", :conditions => "a.user_content_id=b.id and a.e_approved = 'pending' and a.uid = #{logged_in_hmm_user.id}")
    #    @gallery_comments = GalleryComment.count(:all,:select=>"distinct(a.id)",:joins=>"as a,user_contents as b", :conditions => "a.gallery_id=b.gallery_id and a.e_approval = 'pending' and a.uid = #{logged_in_hmm_user.id}")

    # render :layout=>false
  end



    def customize_site
      
    
    @paths = ContentPath.find(:first,:conditions=>"status='active'")
    @path1 = ContentPath.find(:all)
    @path2=""
    for path in @path1
      @path2="#{@path}#{path.content_path},"
    end
    @content_server_url = "#{@paths.content_path}"
    subdomain = request.subdomains[0]
    logger.info(subdomain)
    current= request.url.split("http://")
    current1= current[1].split("/")
    if current1[0]=="holdmymemories.com"
      @app_url="http://holdmymemories.com"
    else
      @app_url="http://www.holdmymemories.com"
    end
    @family_website_owner = HmmUser.find(:first, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')") #get the user details
    @hmm_user = HmmUser.find(@family_website_owner.id)
    @path=ContentPath.find(:first,:conditions=>"status='active'")
    uid1 = @hmm_user.id
    @path=ContentPath.find(:first,:conditions=>"status='active'")
    @all_comments = ChapterComment.find_by_sql("
     (select
        c.id as id,
        c.gallery_id as master_id,
        c.v_comment as comment,
        c.reply as reply,
        c.e_approval as e_approval,
        c.ctype as ctype,
        c.v_name as name,
        c.uid as user_id,
        c.d_created_on as d_created_at
        from
        gallery_comments    as c,
        user_contents as u
        where
        c.gallery_id=u.gallery_id
        and
        c.uid=#{uid1}
        and c.e_approval = 'pending'
        )
     union
    (select
        d.id as id,
        d.user_content_id as master_id,
        d.v_comment as comment,
        d.reply as reply,
        d.e_approved as e_approval,
        d.ctype as ctype,
        d.v_name as name,
        d.uid as user_id,
        d.d_add_date as d_created_at
        from
        photo_comments  as d,
        user_contents as u
        where
        d.user_content_id=u.id
        and
        u.uid=#{uid1}
        and d.e_approved = 'pending'
     )
     union
    (select
        b.id as id,
        b.blog_type_id as master_id,
        bc.comment as message,
        bc.id as reply,
        bc.status as e_approval,
        b.client as ctype,
        bc.name as name,
        b.user_id as user_id,
        bc.created_at as d_created_at
        from
        blog_comments as bc,
        blogs as b
        where b.id=bc.blog_id
        and
        b.user_id=#{uid1}
        and bc.status = 'pending'
     )
     order by e_approval")
      @hmm=params[:id]
    #    @blogcmt = Blog.count(:all,:joins=>" as a , blog_comments as b", :conditions => "a.id=b.blog_id and a.user_id='#{logged_in_hmm_user.id}' and b.status='pending' ")
    #    @comments = PhotoComment.count(:all,:select=>"distinct(a.id)",:joins=>"as a,user_contents as b", :conditions => "a.user_content_id=b.id and a.e_approved = 'pending' and a.uid = #{logged_in_hmm_user.id}")
    #    @gallery_comments = GalleryComment.count(:all,:select=>"distinct(a.id)",:joins=>"as a,user_contents as b", :conditions => "a.gallery_id=b.gallery_id and a.e_approval = 'pending' and a.uid = #{logged_in_hmm_user.id}")

    # render :layout=>false
    
     link = "/family_memory/customize_site/#{params[:id]}"
  end


def pp_contact_us
logger.info("11111111111111111111111111111111111111111111111111111111111111111111111111111")
logger.info(params[:id])

    @contact_u = ContactU.new
    if(params[:contact_u])
      if verify_recaptcha
        @contact_u = ContactU.new(params[:contact_u])
        @hmm_user_belongs_to = HmmUser.count(:all,:conditions => "v_e_mail='#{@contact_u.email}'")
       

        if(@hmm_user_belongs_to > 0)
          @hmm_user_belongs_to_det = HmmUser.find(:all,:conditions => "v_e_mail='#{@contact_u.email}'")
          emp_id= @hmm_user_belongs_to_det[0]['emp_id']
          customer_name="#{@hmm_user_belongs_to_det[0]['v_fname']} #{@hmm_user_belongs_to_det[0]['v_lname']}"
          acc_type=@hmm_user_belongs_to_det[0]['account_type']
      

          if(acc_type=="free_user")
            customer_account="Free User Account"
          else
            if(acc_type=="platinum_user")
              customer_account="Premium User Account"
            else
              customer_account="Family Website User Account"
            end
          end

          if(emp_id=='' || emp_id==nil )
            @contact_u.subject = "HoldMyMemories Contact Us Information..."
            emp_studio_id = 0
            Postoffice.deliver_contactUsreport1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,"Direct User","No employee involved",customer_name,customer_account,emp_studio_id)

          else
            @employee_details = EmployeAccount.find(emp_id)
            branch = @employee_details.branch
            e_mail = @employee_details.e_mail
            emp_name = @employee_details.employe_name
            emp_studio_id = @employee_details.store_id
            @contact_u.subject = "HoldMyMemories Contact Us Information..."
            Postoffice.deliver_contactUsreport1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,branch,emp_name,customer_name,customer_account,emp_studio_id)
          end
        else
          user_studio_id = 0
          @contact_u.subject = "HoldMyMemories Contact Us Information..."
          Postoffice.deliver_contactUsreport("customerservice@holdmymemories.com",@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,@contact_u.zip,@contact_u.phone_no,@contact_u.mobile_no)

        end
        @contact_u.subject = "HoldMyMemories Contact Us Information..."
        if @contact_u.save
          #user_studio_id = @hmm_user_belongs_to_det[0]['studio_id']
          #Postoffice.deliver_contactUsreport(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email)
        
          flash[:notice_contact] = 'Thank You for submitting the details'
        #  redirect_to :action => 'customize_site'
         # redirect_to :action => "customize_site/#{params[:hmm]}"
          redirect_to :controller=>"family_memory",:action => 'customize_site', :id => params[:id]
        else
        #  redirect_to :action => "customize_site/#{params[:hmm]}"
        redirect_to :controller=>"family_memory",:action => 'customize_site', :id => params[:id]
        end
      else
        #redirect_to :action => "customize_site/#{params[:hmm]}"
        redirect_to :controller=>"family_memory",:action => 'customize_site', :id => params[:id]
        flash[:error] = 'Please enter the correct Image code!'
      end
    end
  end



  def contest
    cur_date=Date.today
    @contests = ContestDetail.find(:all,:conditions=>"start_date<'#{cur_date}' and end_date>'#{cur_date}'")
  end

  #  **********************COMMENTS SECTION*****************************
  def create_chapter_comment
    unless params[:chapter_comment].blank?
      if verify_recaptcha
        @chapter_comment = ChapterComment.new(params[:chapter_comment])
        @chapter_comment['uid']= @family_website_owner.id
        @chapter_comment['tag_jid']= 0
        @chapter_comment['d_created_on']=Time.now
        if @chapter_comment.save
          Postoffice.deliver_comment(params[:chapter_comment][:v_comment],'0','Chapter',params[:chapter_comment][:v_name],@family_website_owner.v_e_mail,@family_website_owner.v_user_name,@family_website_owner.v_e_mail,@family_website_owner.v_myimage,@family_website_owner.img_url)
          flash[:notice] = 'Thank-you for adding your comment!'
        end
      else
        flash[:error] = 'Please enter the correct code!'
      end
    end
    render :layout => false
  end

  def create_subchapter_comment
    unless params[:subchap_comment].blank?
      if verify_recaptcha
        @subchap_comment = SubchapComment.new(params[:subchap_comment])
        @subchap_comment['uid']= @family_website_owner.id
        @subchap_comment['subchap_id']= params[:subchapter_id]
        @subchap_comment['subchap_jid']= 0
        @subchap_comment['d_created_on']=Time.now
        if @subchap_comment.save
          Postoffice.deliver_comment(params[:subchap_comment][:v_comments],'0','sub_chapter',params[:subchap_comment][:v_name],@family_website_owner.v_e_mail,@family_website_owner.v_user_name,@family_website_owner.v_e_mail,@family_website_owner.v_myimage,@family_website_owner.img_url)
          flash[:notice] = 'Thank-you for adding your comment!'
        end
      else
        flash[:error] = 'Please enter the correct code!'
      end
    end
    render :layout => false
  end

  def create_gallery_comment
    unless params[:gallery_comment].blank?
      if verify_recaptcha
        @gallery_comment = GalleryComment.new(params[:gallery_comment])
        @gallery_comment['uid']= @family_website_owner.id
        @gallery_comment['gallery_jid']= 0
        @gallery_comment['d_created_on']=Time.now
        if @gallery_comment.save
          Postoffice.deliver_comment(params[:gallery_comment][:v_comment],'0','gallery',params[:gallery_comment][:v_name],@family_website_owner.v_e_mail,@family_website_owner.v_user_name,@family_website_owner.v_e_mail,@family_website_owner.v_myimage,@family_website_owner.img_url)
          flash[:notice] = 'Thank-you for adding your comment!'
        end
      else
        flash[:error] = 'Please enter the correct code!'
      end
    end
    render :layout => false
  end



  def view
    @current_item="comments"
    @hmm_user=HmmUser.find(session[:hmm_user])

    uid1=logged_in_hmm_user.id

    tagcout = Tag.find_by_sql(" select
         count(*) as cnt
         from chapter_comments  as a,tags as t
         where
         a.tag_id=t.id
         and
         t.uid=#{uid1} ")
    subcount = SubChapter.find_by_sql("
       select
        count(*) as cnt
        from
        subchap_comments   as b,
        sub_chapters as s
        where
        s.uid=#{uid1}
        and
        b.subchap_id=s.id ")
    galcount = Galleries.find_by_sql("select
        count(*) as cnt
        from
        gallery_comments    as c,
        galleries as g,
        sub_chapters as s1
        where
        s1.uid=#{uid1}
        and
        c.gallery_id=g.id
        and g.subchapter_id=s1.id ")

    usercontentcount = UserContent.find_by_sql("
  select
       count(*) as cnt
        from
        photo_comments   as d,
        user_contents as u
        where
        d.user_content_id=u.id and u.uid=#{uid1}

      ")
    sharecount = Share.find_by_sql("
  select
       count(*) as cnt
        from
        share_comments    as d,
        shares as u
        where
        d.share_id =u.id and u.presenter_id=#{uid1}

      ")
    sharejournalcnt = ShareJournal.find_by_sql("
  select
    count(*) as cnt
    from
    share_journalcomments as d,
    share_journals as u
    where
    d.shareid = u.id and u.presenter_id=#{uid1}
      ")


    guestmessagecount = MessageBoard.count(:all, :conditions => "uid=#{uid1}")

    guestcommentcount = GuestComment.find_by_sql("
    select
    count(*) as cnt
    from
    guest_comments
    where
    uid=#{uid1}
      ")

    blogcomment=BlogComment.count(:joins=>" as bc , blogs as b , hmm_users as h",:conditions=>" b.id=bc.blog_id and
        b.user_id=h.id and
        h.id=#{uid1}")

    guestcommentcnt=Integer(guestcommentcount[0].cnt)
    galcnt=Integer(galcount[0].cnt)
    tagcnt=Integer(tagcout[0].cnt)
    subcnt=Integer(subcount[0].cnt)
    usercontentcnt=Integer(usercontentcount[0].cnt)
    sharecnt=Integer(sharecount[0].cnt)
    sharejournalcnt=Integer(sharejournalcnt[0].cnt)
    bcnt=Integer(blogcomment)

    @total=tagcnt+subcnt+galcnt+usercontentcnt+sharecnt+sharejournalcnt+guestcommentcnt+guestmessagecount+bcnt

    @numberofpagesres=@total/10

    @numberofpages=@numberofpagesres.round()

    if(params[:page]==nil)
      x=0
      y=10
      @page=0
      @nextpage=1
      if(@total<10)

        @nonext=1
      end
    else
      x=10*Integer(params[:page])
      y=10
      @page=Integer(params[:page])
      @nextpage=@page+1
      @previouspage=@page-1
      if(@page==@numberofpages)
        @nonext=1
      end

    end

    if params[:view_all] == "true"
      sort = "d_created_at desc"
    else
      sort = "e_approval desc, d_created_at desc"
    end
    @tagid=ChapterComment.paginate_by_sql ["
   (select

         a.id as id,
         a.tag_id as master_id,
         a.v_comment as comment,
         a.reply as reply,
         a.e_approval as e_approval,
         a.ctype as ctype,
         a.v_name as name,
         a.uid as user_id,
         a.d_created_on as d_created_at
         from chapter_comments as a,tags as t
         where
         a.tag_id=t.id
         and

         t.uid=#{uid1}
     )
     union
     (select

        b.id as id,
        b.subchap_id as master_id,
        b.v_comments as comment,
        b.reply as reply,
        b.e_approval as e_approval,
        b.ctype as ctype,
        b.v_name as name,
        b.uid as user_id,
        b.d_created_on as d_created_at
        from
        subchap_comments   as b,
        sub_chapters as s
        where
        s.uid=#{uid1}
        and
        b.subchap_id=s.id
     )
     union
     (select
        c.id as id,
        c.gallery_id as master_id,
        c.v_comment as comment,
        c.reply as reply,
        c.e_approval as e_approval,
        c.ctype as ctype,
        c.v_name as name,
        c.uid as user_id,
        c.d_created_on as d_created_at
        from
        gallery_comments    as c,
        galleries as g,
        sub_chapters as s1
        where
        s1.uid=#{uid1}
        and
        c.gallery_id=g.id
        and g.subchapter_id=s1.id)
     union
    (select
        d.id as id,
        d.user_content_id as master_id,
        d.v_comment as comment,
        d.reply as reply,
        d.e_approved as e_approval,
        d.ctype as ctype,
        d.v_name as name,
        d.uid as user_id,
        d.d_add_date as d_created_at
        from
        photo_comments  as d,
        user_contents as u
        where
        d.user_content_id=u.id
        and
        u.uid=#{uid1}
     )
     union
    (select
        d.id as id,
        d.share_id as master_id,
        d.comment as comment,
        d.reply as reply,
        d.e_approved as e_approval,
        d.reply as ctype,
        d.name as name,
        d.uid as user_id,
        d.d_add_date as d_add_date
        from
        share_comments as d,
        shares as s
        where
        d.share_id=s.id
        and
        s.presenter_id=#{uid1}
     )
     union
    (select
        p.id as id,
        p.share_id as master_id,
        p.comment as comment,
        p.reply as reply,
        p.e_approved as e_approval,
        p.ctype as ctype,
        p.name as name,
        p.uid as user_id,
        p.added_date as d_add_date
        from
        share_momentcomments as p,
        share_moments as q
        where
        p.share_id=q.id
        and
        q.presenter_id=#{uid1}
     )
      union
    (select
        r.id as id,
        r.shareid as master_id,
        r.comment as comment,
        r.reply as reply,
        r.status as e_approval,
        r.ctype as ctype,
        r.name as name,
        r.id as user_id,
        r.comment_date as d_add_date
        from
        share_journalcomments as r,
        share_journals as z
        where
        r.shareid=z.id
        and
        z.presenter_id=#{uid1}
     )
     union
    (select
        g.id as id,
        g.journal_typeid as master_id,
        g.comment as comment,
        g.ctype as reply,
        g.status as e_approval,
        g.ctype as ctype,
        g.name as name,
        g.uid as user_id,
        g.comment_date as d_add_date
        from
        guest_comments as g
        where
        g.uid=#{uid1}
     )
     union
    (select
        h.id as id,
        h.uid as master_id,
        h.message as message,
        h.reply as reply,
        h.status as e_approval,
        h.ctype as ctype,
        h.guest_name as name,
        h.uid as user_id,
        h.created_at as d_created_at
        from
        message_boards as h
        where
        h.uid=#{uid1}
     )
     union
    (select
        b.id as id,
        b.blog_type_id as master_id,
        bc.comment as message,
        bc.id as reply,
        bc.status as e_approval,
        b.client as ctype,
        bc.name as name,
        h.id as user_id,
        bc.created_at as d_created_at
        from
        blog_comments as bc,
        blogs as b,
        hmm_users as h
        where b.id=bc.blog_id and
        b.user_id=h.id and
        h.id=#{uid1}
     )
     order by  #{sort} "], :per_page => 10, :page => params[:page]

    logger.info(@tagid[0])

    puts x
    puts y
    #     if(params[:page]==nil)
    #     @pages=""
    #    else
    #       @pages=1
    #      render :layout => false
    #    end
  end


  #chapter comments
  def chapter_comment_approve_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @chapter_comment =ChapterComment.find(params[:comment_id])
    @chapter_comment['e_approval'] = 'approve'
    @chapter_comment.save
    $notice_cca_list
    flash[:message] = 'Chapter Comment was Approved!!'
    if(params[:jc]=='1')
      redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end

  end

  def chapter_comment_reject_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @chapter_comment =ChapterComment.find(params[:comment_id])
    @chapter_comment.destroy
    # @chapter_comment['e_approval'] = 'reject'
    #@tag_cid = ChapterComment.find(:all, :conditions => "tag_jid=#{params[:id]} " , :order => "id DESC")
    #@chapter_comment.save
    $notice_ccr_list
    flash[:message] = 'Chapter Comment Rejected'
    if(params[:jc]=='1')
      redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller =>'family_memory', :action => 'view' ,:id => params[:id]
    end

  end

  def chapter_comment_destroy_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @chapter_comment =ChapterComment.find(params[:comment_id])
    @chapter_comment.destroy
    $notice_ccd_list
    flash[:message] = 'Chapter Comment was Deleted!!'
    if(params[:jc]=='1')
      redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end
  end

  #sub chapter comments
  def subchap_comment_approve_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @chapter_comment =SubchapComment.find(params[:comment_id])
    @chapter_comment['e_approval'] = 'approve'
    @chapter_comment.save
    $notice_sca_list
    flash[:message] = 'Sub-Chapter Comment Was Successfully Approved!!'
    if(params[:jc]=='1')
      redirect_to :controller => 'family_memory', :action => 'manage_journals_details' ,:id => params[:id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end
  end

  def subchap_comment_reject_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @chapter_comment =SubchapComment.find(params[:comment_id])
    @chapter_comment.destroy
    $notice_scr_list
    flash[:message] = 'Sub-Chapter Comment was Rejected'
    if(params[:jc]=='1')
      redirect_to :controller => 'family_memory', :action => 'manage_journals_details' ,:id => params[:id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end
  end

  def subchap_comment_destroy_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @chapter_comment =SubchapComment.find(params[:comment_id])
    @chapter_comment.destroy
    $notice_scd_list
    flash[:message] = 'Sub-Chapter Comment Was Successfully Deleted!!'
    if(params[:jc]=='1')
      redirect_to :controller => 'family_memory', :action => 'manage_journals_details' ,:id => params[:id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end
  end

  #gallery comments
  def gallery_comment_approve_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @gallery_comment =GalleryComment.find(params[:comment_id])
    @gallery_comment['e_approval'] = 'approve'
    @gallery_comment.save
    $notice_gca_list
    flash[:message] = 'Gallery Comment Was Successfully Approved!!'

    if(params[:jc]=='1')
      redirect_to :controller => 'family_memory', :action => 'manage_journals_details' ,:id => params[:id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end
  end

  def gallery_comment_reject_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @gallery_comment =GalleryComment.find(params[:comment_id])
    @gallery_comment.destroy
    $notice_gcr_list
    flash[:message] = 'Gallery Comment Rejected!!'

    if(params[:jc]=='1')
      redirect_to :controller => 'family_memory', :action => 'manage_journals_details' ,:id => params[:id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end
  end

  def gallery_comment_destroy_cmt

    @hmm_user=HmmUser.find(session[:hmm_user])
    @gallery_comment =GalleryComment.find(params[:comment_id])
    @gallery_comment.destroy
    $notice_gcd_list
    flash[:notice_gcd_list] = 'Gallery Comment Was Successfully Deleted!!'

    if(params[:jc]=='1')
      redirect_to :controller => 'family_memory', :action => 'manage_journals_details' ,:id => params[:id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end
  end

  #photo comments
  def photo_comments_approve_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @comment =PhotoComment.find(params[:comment_id])
    @comment['e_approved'] = 'approve'
    @comment.save
    $notice_pca_list
    flash[:message] = 'Photo Comment was Successfully Approved!!'
    if(params[:jc]=='1')
      redirect_to :controller => 'family_memory', :action => 'manage_journals_details' ,:id => params[:id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end
  end

  def photo_comments_reject_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @comment =PhotoComment.find(params[:comment_id])
    @comment.destroy
    $notice_pcr_list
    flash[:message] = 'Photo Comment Rejected'
    if(params[:jc]=='1')
      redirect_to :controller => 'family_memory', :action => 'manage_journals_details' ,:id => params[:id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end
  end

  def photo_comments_destroy_cmt

    @hmm_user=HmmUser.find(session[:hmm_user])
    @comment =PhotoComment.find(params[:comment_id])
    @comment.destroy
    $notice_pcd_list
    flash[:message] = 'Photo Comment was Successfully Deleted!!'
    if(params[:jc]=='1')
      redirect_to :controller => 'family_memory', :action => 'manage_journals_details' ,:id => params[:id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end
  end

  # share journal comments
  def share_journalcomments_approve_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @share_journalcomment =ShareJournalcomment.find(params[:comment_id])
    @share_journalcomment.status = 'accepted'
    @share_journalcomment.save
    $notice_cca_list
    flash[:message] = 'Shared Journal Comment Approved!!'
    if(params[:jc]=='1')
      redirect_to :controller => 'family_memory', :action => 'manage_journals_details' ,:id => params[:id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end
  end

  def share_journalcomments_reject_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @share_comment =ShareJournalcomment.find(params[:comment_id])

    #@tag_cid = ChapterComment.find(:all, :conditions => "tag_jid=#{params[:id]} " , :order => "id DESC")
    @share_comment.destroy
    $notice_ccr_list
    flash[:message] = 'Shared Journal Comment Rejected!!'
    if(params[:jc]=='1')
      redirect_to :controller => 'family_memory', :action => 'manage_journals_details' ,:id => params[:id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end
  end

  def share_journalcomments_destroy_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])

    @share_comment =ShareJournalcomment.find(params[:comment_id])
    @share_comment.destroy
    $notice_ccd_list
    flash[:message] = 'Shared Journal Comment Deleted!!'
    if(params[:jc]=='1')
      redirect_to :controller => 'family_memory', :action => 'manage_journals_details' ,:id => params[:id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end
  end

  # Share Blog Comments
  def share_blog_approve_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @share_journalcomment =BlogComment.find(params[:comment_id])
    @share_journalcomment.status = 'approved'
    @share_journalcomment.save
    $notice_cca_list
    flash[:message] = 'Blog Comment Approved!!'
    if(params[:jc]=='1')
      redirect_to :controller => 'family_memory', :action => 'manage_journals_details' ,:id => params[:id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end
  end

  def share_blog_reject_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @share_comment =BlogComment.find(params[:comment_id])

    #@tag_cid = ChapterComment.find(:all, :conditions => "tag_jid=#{params[:id]} " , :order => "id DESC")
    @share_comment.destroy
    $notice_ccr_list
    flash[:message] = 'Blog Comment Rejected!!'
    if(params[:jc]=='1')
      redirect_to :controller => 'family_memory', :action => 'manage_journals_details' ,:id => params[:id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end
  end

  def share_blog_destroy_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])

    @share_comment =BlogComment.find(params[:comment_id])
    @share_comment.destroy
    $notice_ccd_list
    flash[:message] = 'Blog Comment Deleted!!'
    if(params[:jc]=='1')
      redirect_to :controller => 'family_memory', :action => 'manage_journals_details' ,:id => params[:id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end
  end

  # share moments controller

  def share_momentcomments_approve_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    if(session['redirect']=='22')
      @share_comment =ShareMomentcomment.find(params[:cid])
    else
      @share_comment =ShareMomentcomment.find(params[:comment_id])
    end
    @share_comment['e_approved'] = 'approved'
    @share_comment.save
    $notice_acceptcmt
    flash[:notice_acceptcmt] = 'Shared Moment Comment Approved!!'
    if(session['redirect']=='22')
      redirect_to :controller => 'photo_comments', :action => 'photo_comnt', :id => session[:usercontent_id1], :page1=>params[:page1], :id_journal => params[:id_journal]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view',:id => params[:id]
    end
  end

  def share_momentcomments_reject_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    if(session['redirect']=='22')
      @share_comment =ShareMomentcomment.find(params[:cid])
    else
      @share_comment =ShareMomentcomment.find(params[:comment_id])
    end


    #@tag_cid = ChapterComment.find(:all, :conditions => "tag_jid=#{params[:comment_id]} " , :order => "id DESC")
    @share_comment.destroy
    $notice_rejectcmt
    flash[:message] = 'Shared Moment Comment Rejected!!'
    if(session['redirect']=='22')
      redirect_to :controller => 'photo_comments', :action => 'photo_comnt', :id => session[:usercontent_id1], :page1=>params[:page1], :id_journal => params[:id_journal]
    else
      # redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view',:id => params[:id]
    end
  end

  def share_momentcomments_destroy_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    if(session['redirect']=='22')
      @share_comment =ShareMomentcomment.find(params[:cid])
    else
      @share_comment =ShareMomentcomment.find(params[:comment_id])
    end
    @share_comment.destroy
    $notice_smtdestroy
    flash[:notice_smtdestroy] = 'Shared Moment Comment Deleted!!'
    if(session['redirect']=='22')
      redirect_to :controller => 'photo_comments', :action => 'photo_comnt', :id => session[:usercontent_id1], :page1=>params[:page1], :id_journal => params[:id_journal]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'familywebsite_comments', :action => 'view',:id => params[:id]
    end
  end

  #guest comments
  def guest_comments_approve_jcmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @guest_comment =GuestComment.find(params[:comment_id])
    @guest_comment['status'] = 'approve'
    @guest_comment.save
    $notice_cca_jlist
    flash[:message] = 'Guest Comment was Approved!!'
    flash[:message] = 'Guest Comment was Approved!!'
    if(params[:jc]=='1')
      redirect_to :controller => 'family_memory', :action => 'manage_journals_details' ,:id => params[:id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end
  end

  def guest_comments_reject_jcmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @guest_comment =GuestComment.find(params[:comment_id])
    @guest_comment.destroy
    # @guest_comment['e_approval'] = 'reject'
    #@tag_cid = GuestComment.find(:all, :conditions => "tag_jid=#{params[:comment_id]} " , :order => "id DESC")
    #@guest_comment.save
    $notice_ccr_list
    flash[:notice_cca_jlist] = 'Guest Comment Rejected'
    flash[:message] = 'Guest Comment Rejected'
    if(params[:jc]=='1')
      redirect_to :controller => 'family_memory', :action => 'manage_journals_details' ,:id => params[:id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end
  end

  def guest_comments_destroy_jcmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @guest_comment =GuestComment.find(params[:comment_id])
    @guest_comment.destroy
    # @guest_comment['e_approval'] = 'reject'
    #@tag_cid = GuestComment.find(:all, :conditions => "tag_jid=#{params[:comment_id]} " , :order => "id DESC")
    #@guest_comment.save
    $notice_ccr_list
    flash[:message] = 'Guest Comment was removed!!'

    if(params[:jc]=='1')
      redirect_to :controller => 'family_memory', :action => 'manage_journals_details' ,:id => params[:id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end
  end

  #message boards

  def message_boards_approve_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @comment =MessageBoard.find(params[:comment_id])
    @comment['status'] = 'accept'
    @comment.save
    flash[:message] = 'Guest comment was Successfully Approved!!'
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
  end

  def message_boards_destroy_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    MessageBoard.find(params[:comment_id]).destroy
    flash[:message] = 'Guest comment was deleted!!'
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
  end

  #share comments

  def share_comments_approve_cmt
    puts session['redirect']
    @hmm_user=HmmUser.find(session[:hmm_user])
    @share_comment =ShareComments.find(params[:comment_id])
    @share_comment['e_approved'] = 'approved'
    @share_comment.save
    flash[:message] = 'Shared Moment Comment Approved!!'
    if(session['redirect']=='111')
      redirect_to :controller => 'tags', :action => 'memories', :id=> @share_comment[:share_id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end
  end

  def share_comments_reject_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @share_comment =ShareComments.find(params[:comment_id])
    @share_comment.destroy

    #@tag_cid = ChapterComment.find(:all, :conditions => "tag_jid=#{params[:id]} " , :order => "id DESC")

    $notice_ccr_list
    flash[:message] = 'Shared Moment Comment Rejected!!'
    if(session['redirect']=='111')
      redirect_to :controller => 'tags', :action => 'memories', :id=> @share_comment[:share_id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end
  end

  def share_comments_destroy_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @share_comment =ShareComments.find(params[:comment_id])
    @share_comment.destroy
    flash[:message] = 'Shared Moment Comment Deleted!!'
    if(session['redirect']=='111')
      redirect_to :controller => 'tags', :action => 'memories', :id=> @share_comment[:share_id]
    else
      #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
      redirect_to :controller => 'family_memory', :action => 'view' ,:id => params[:id]
    end
  end

  def create_moment_newblog_entry
    unless params[:moment_id].blank?
      @usercontent = UserContent.find(params[:moment_id])
      #      if(@usercontent.e_filetype=='video' || @usercontent.e_filetype=='swf')
      #        @image ="#{@usercontent.img_url}/user_content/videos/thumbnails/#{@usercontent.v_filename}"+".jpg"
      #      else
      #        if(@usercontent.e_filetype=='image')
      #          @image ="#{@usercontent.img_url}/user_content/photos/small_thumb/#{@usercontent.v_filename}"
      #        else
      #          @image ="#{@usercontent.img_url}/user_content/audios/speaker.jpg"
      #        end
      #      end
      if params[:apply_to] == "image"
        @btype = "image"
        @blog_type_id = @usercontent.id
      elsif params[:apply_to] == "album"
        @btype = "gallery"
        @blog_type_id = @usercontent.gallery_id
      elsif params[:apply_to] == "video"
        @btype = "video"
        @blog_type_id = @usercontent.id
      end
      @blog = Blog.find(:first, :conditions => "blog_type_id=#{@blog_type_id} and blog_type='#{@btype}'")
      if @blog
        @title = "Edit blog entry for '#{@usercontent.v_tagphoto}'"
      else
        @title = "Create a blog entry for '#{@usercontent.v_tagphoto}'"
      end
      if params[:make_blog] == "checked"
        userid = HmmUser.find(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')")
        uid = userid[0]['id']
        img_url=userid[0]['img_url']
        blogdate=Date.today
        if @blog
          @blog['blog_type']=@btype
          @blog['blog_type_id']= @blog_type_id
          @blog['user_id']=uid
          @blog['title']=params[:title]
          @blog['description']=params[:desc]
          @blog['added_date']=blogdate
          @blog['status']='active'
          @blog['access']= params[:access]
          @blog.save
          flash[:notice_com] = "Blog entry updated successfully!"
        else
          @blog = Blog.new()
          @blog['blog_type']=@btype
          @blog['blog_type_id']=@blog_type_id
          @blog['user_id']=uid
          @blog['title']=params[:title]
          @blog['description']=params[:desc]
          @blog['added_date']=blogdate
          @blog['access']= params[:access]
          @blog['status']='active'
          @blog.save
          flash[:notice_com] = "Blog entry added successfully!"
        end
        if params[:apply_to] == "image"
          user_cont=UserContent.find(@usercontent.id)
          user_cont.e_access= params[:access]
          user_cont.save
        elsif params[:apply_to] == "album"
          @user_cont = UserContent.find(:all, :conditions => "gallery_id = #{@usercontent.gallery_id}")
          @user_cont.each do |usercontent|
            usercontent.e_access = params[:access]
            usercontent.save
          end
          gal_cont = Galleries.find(@usercontent.gallery_id)
          gal_cont.e_gallery_acess = params[:access]
          gal_cont.save
        end
        #        if params[:redirect_url]
        #          redirect_to params[:redirect_url]
        #        else
        #          redirect_to :controller => "family_memory", :action => 'list', :id =>params[:id]
        #        end
      else
        if params[:apply_to] == "image" || params[:apply_to] == "video"
          @moment_comment = PhotoComment.new()
          @moment_comment['user_content_id'] = params[:moment_id]
          @moment_comment['uid']= @family_website_owner.id
          @moment_comment['v_name'] = @family_website_owner.v_user_name
          @moment_comment['v_comment'] = params[:desc]
          @moment_comment['e_approved'] = 'approve'
          @moment_comment['d_add_date']=Time.now
          @moment_comment['e_access']= params[:access]
          user_cont=UserContent.find(params[:moment_id])
          user_cont.e_access= params[:access]
          user_cont.save
        elsif params[:apply_to] == "album"
          @moment_comment = GalleryComment.new
          @moment_comment.v_name = @family_website_owner.v_user_name
          @moment_comment.v_comment = params[:desc]
          @moment_comment['uid'] = @family_website_owner.id
          @moment_comment['gallery_jid'] = 0
          @moment_comment['e_approval'] = 'approve'
          @moment_comment['gallery_id'] = @usercontent.gallery_id
          @moment_comment['d_created_on'] = Time.now
          @user_cont = UserContent.find(:all, :conditions => "gallery_id = #{@usercontent.gallery_id}")
          @user_cont.each do |usercontent|
            usercontent.e_access = params[:access]
            usercontent.save
          end
          gal_cont = Galleries.find(@usercontent.gallery_id)
          gal_cont.e_gallery_acess = params[:access]
          gal_cont.save
        end
        @moment_comment.save
        flash[:notice_com] = "Comment added successfully!"
      end
      if params[:redirect_url]
        redirect_to "/family_memory/gallery_details/#{params[:id]}?moment_id=#{@usercontent.id}"
      else
        redirect_to :controller => "family_memory", :action => 'list', :id =>params[:id]
      end
    else
      redirect_to :controller => "family_memory", :action => "home", :id => params[:id]
    end
  end



  def edit_image
    @paths = ContentPath.find(:first,:conditions=>"status='active'")
    @img=UserContent.find(:first,:conditions=>"id=#{params[:moment_id]}")
    @first_img=@img
  end

  def preview_image
    @hmm_user = HmmUser.find(logged_in_hmm_user.id)
    render :layout=>false
  end

  def showGallery

    @gallery=Galleries.find(params[:gallery_id])
    @sub_chapter = SubChapter.find(@gallery.subchapter_id)
    @userid = HmmUser.find(:all, :conditions => "id=#{@sub_chapter.uid}")
    @uid = @userid[0]['id']
    @family_name=@userid[0]['family_name']
    cond=self.subchapter_public()
    #    if params[:id].upcase=="BOB" || params[:id].upcase=="EVELETH"
    if !@sub_chapter.store_id.nil? && !@sub_chapter.store_id.blank?
      var="gallery_id"
      val=params[:gallery_id]
    else
      var="sub_chapid"
      val=@sub_chapter.id
    end
    #    else
    #      var="gallery_id"
    #      val=params[:gallery_id]
    #    end
    @contents = UserContent.find(:all, :group => 'v_filename', :conditions => "#{var}=#{val} and status='active' #{cond}", :order => "order_num ASC")
    render :layout => false
  end

  def add_nonhmm
    if params[:pa]
      email = params[:pa]
      @frindsEmail=email.split(',')
    end
  end

  def add_nonhmmWorker
    if params[:nonhmm_email]
      @email = params[:nonhmm_email]
      @nonhmmemails = @email.join(",")


      if params[:nonhmm_name]
        @name = params[:nonhmm_name]
        @nonhmmnames = @name.join(",")
      end


      @frindsEmail=@nonhmmemails.split(',')
      @frindsName=@nonhmmnames.split(',')
      i=0

      #finding the size of an array
      @emailsize=@frindsEmail.size()
      @namesize=@frindsName.size()

      #loop to insert new nonHMM friends which are added through e-mail
      @emailsize.times {|i|
        @addnonhmm = NonhmmUser.new()
        @addnonhmm['v_email'] = @frindsEmail[i]
        @addnonhmm['v_name'] = @frindsName[i]
        @addnonhmm['uid'] = logged_in_hmm_user.id
        @addnonhmm['v_city'] = 'edit city'
        @addnonhmm['v_country'] = 'edit country'
        @addnonhmm.save
      }
      $addnonhmm
      flash[:addnonhmm] = 'Non-HMM Users Were Successfully added!!'
      $share_journal_sc
      flash[:share_journal_sc] = 'Journal was Successfully Shared!!'
    end
    redirect_to :controller => 'family_memory', :action => 'home' , :id => params[:id]

  end

  def website_address
    unless params[:family_name].blank?
      family = HmmUser.find(:first, :conditions => "id!=#{logged_in_hmm_user.id} and (family_name like '#{removefamilySymbols(params[:family_name])}' or alt_family_name like '#{removefamilySymbols(params[:family_name])}')")
      unless family
        HmmUser.update(logged_in_hmm_user.id, :family_name => removefamilySymbols(params[:family_name]))
        logged_in_hmm_user.family_name = removefamilySymbols(params[:family_name])
        if params[:v]=="v4"
          flash[:address] = "Website address updated successfully!"
          redirect_to :controller=>"family_memory", :action => "edit_profile", :id => removefamilySymbols(params[:family_name])
        else
          flash[:error] = "Website address updated successfully!"
          redirect_to :action => "website_address", :id => removefamilySymbols(params[:family_name])
        end
      else
        if params[:v]=="v4"
          flash[:address] = "Family name already exists!"
        else
          flash[:error] = "Family name already exists!"
        end
      end
    end
  end


  def user_login

  end

  def subchapter_public
    if session[:hmm_user]
      if logged_in_hmm_user.id==@family_website_owner.id
        cond="and 1=1"
      else
        cond="and e_access='public'"
      end
    else
      cond="and e_access='public'"
    end
    return cond
  end

  def gallery_public
    if session[:hmm_user]
      if logged_in_hmm_user.id==@family_website_owner.id
        cond="and 1=1"
      else
        cond="and e_gallery_acess='public'"
      end
    else
      cond="and e_gallery_acess='public'"
    end
    return cond
  end

  def blog_public
    if session[:hmm_user]
      if logged_in_hmm_user.id==@family_website_owner.id
        cond="and 1=1"
      else
        cond="and access='public'"
      end
    else
      cond="and access='public'"
    end
    return cond
  end

  def share_by_email
    if params[:id]
      fid=params[:id]
    else
      fid=params[:familyname]
    end
    @block_check = HmmUser.count(:all, :conditions => "(family_name='#{fid}' || alt_family_name='#{fid}') and e_user_status='blocked'")
    if(@block_check > 0)
      redirect_to :controller => 'familywebsite', :action => 'blocked', :id => params[:id]
    else

      @userid = HmmUser.find(:all, :conditions => "family_name='#{fid}' || alt_family_name='#{fid}'")
      @uid = @userid[0]['id']
      @results1 = NonhmmUser.find(:all, :conditions => "uid='#{@userid[0]['id']}'")
      @link = params[:link]
    end

    if !params[:reciepent_email].blank? || !params[:address_email].nil?
      logger.info("*************inside*******************")
      if simple_captcha_valid? || (session[:hmm_user] && logged_in_hmm_user.id == @family_website_owner.id)
        @user = HmmUser.count_by_sql("SELECT count(*) FROM `hmm_users` WHERE family_name='#{params[:id]}' and familywebsite_password='#{params[:pass]}'")
        @pass_req = HmmUser.count_by_sql("SELECT count(*) FROM `hmm_users` WHERE family_name='#{params[:id]}' and password_required='yes'")
        #        @userid = HmmUser.find(:all, :conditions => "family_name='#{params[:id]}' || alt_family_name='#{params[:id]}'")
        @userid = UserContent.find(params[:moment_id])
        @uid = @userid.uid
        #        family_img = @userid[0]['family_pic']
        #        content_url = @userid[0].img_url
        family_img = @userid.v_filename
        content_url = @userid.img_url
        #        moment = UserContent.find(params[:moment_id])

        #        moment_img = moment.v_filename

        @count = 0

        if params[:reciepent_email]
          if session[:hmm_user]
            email = params[:reciepent_email]
            @frindsEmail=email.split(',')
            size = @frindsEmail.size
            for k in @frindsEmail
              #@friendscheck = NonhmmUser.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and v_email='#{k}'")
              @friendscheck = NonhmmUser.count_by_sql("SELECT count(*) FROM nonhmm_users where  v_email='#{k}' and uid=#{@userid['id']} group by v_email")
              i=0
              until i == size
                i=i+1
                if @friendscheck != 1
                  @count = @count +1
                else

                end
              end
            end
            if @count == 0
              @link = params[:link]
            else
              if params[:v] == "v4"
                @link="/family_memory/add_nonhmm/"+params[:id]+"/?pa="+params[:reciepent_email]
              else
                @link="/familywebsite/add_nonhmm/"+params[:id]+"/?pa="+params[:reciepent_email]
              end
            end
          else
            @link = params[:link]
          end
        else
          @link = params[:link]

        end

        if (@pass_req > 0 and params[:pass] !='')
          if (params[:pass] and @user > 0)
            puts '1'
            #modified fdwefwefwefwefwe

            sender_name = params[:sender_name]
            sender_email = params[:sender_email]
            reciepent_message=params[:reciepent_message]
            messageboard_link="http://www.holdmymemories.com/familywebsite/messageboard/"+params[:id]
            pass = params[:pass]

            if (params[:share_type] == 'journal' || params[:share_type] == 'biography')
              @sha_type = params[:share_type]
            else
              @sha_type = 'moment'
            end
            if params[:reciepent_email]
              @frdEmail = params[:reciepent_email]
              frindsEmail=@frdEmail.split(',')

              for i in frindsEmail

                Postoffice.deliver_shareMomentpages(i,sender_name,sender_email,params[:link],reciepent_message,@sha_type,pass,messageboard_link,family_img,content_url)
                @familywebsite_share = FamilywebsiteShare.new()
                @familywebsite_share['senders_name']=params[:sender_name]
                @familywebsite_share['senders_email']=params[:sender_email]
                @familywebsite_share['share_message']=params[:reciepent_message]
                @familywebsite_share['reciepent_emails']=i
                @familywebsite_share['website_owner_id']=@uid
                @familywebsite_share['share_date']=Time.now
                @familywebsite_share['family_website']=params[:id]
                @familywebsite_share.save
              end
            end

            #Send Email From Address Book
            if params[:address_email]

              adrsEmail=params[:address_email]
              for j in adrsEmail

                Postoffice.deliver_shareMomentpages(j,sender_name,sender_email,params[:link],reciepent_message,@sha_type,pass,messageboard_link,family_img,content_url)
                @familywebsite_share = FamilywebsiteShare.new()
                @familywebsite_share['senders_name']=params[:sender_name]
                @familywebsite_share['senders_email']=params[:sender_email]
                @familywebsite_share['share_message']=params[:reciepent_message]
                @familywebsite_share['reciepent_emails']=j
                @familywebsite_share['website_owner_id']=@uid
                @familywebsite_share['share_date']=Time.now
                @familywebsite_share['family_website']=params[:id]
                @familywebsite_share.save
              end
            end
            # puts adrsEmail

            Postoffice.deliver_shareFamilypages(adrsEmail,sender_name,sender_email,link,reciepent_message,@sha_type,pass,messageboard_link,family_img,content_url)

            #end
            session[:journal] = "journal"
            $share_familypage
            flash[:message] = "<font color='#e75e16' size=3>Your moment was successfully shared.</font>"
            redirect_to @link
          else

            $share_unsuccefull = 'Invalid Password'
            flash[:message] = 'Invalid Password, please try again!'
            redirect_to params[:redirect_url]
          end
        else
          @count = 0
          if params[:reciepent_email]
            if session[:hmm_user]
              email = params[:reciepent_email]
              @frindsEmail=email.split(',')
              size = @frindsEmail.size
              for k in @frindsEmail
                #@friendscheck = NonhmmUser.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and v_email='#{k}'")
                @friendscheck = NonhmmUser.count_by_sql("SELECT count(*) FROM nonhmm_users where  v_email='#{k}' and uid=#{@userid['id']} group by v_email")
                i=0
                until i == size
                  i=i+1
                  if @friendscheck != 1
                    @count = @count +1
                  else

                  end
                end
              end
              if @count == 0
                @link = params[:link]
              else
                if params[:v] == "v4"
                  @link="/family_memory/add_nonhmm/"+params[:id]+"/?pa="+params[:reciepent_email]
                else
                  @link="/familywebsite/add_nonhmm/"+params[:id]+"/?pa="+params[:reciepent_email]
                end
              end
            else
              @link = params[:link]
            end
          else
            @link = params[:link]

          end
          #          link=redirect_to :controller => 'my_familywebsite', :action => 'add_nonhmm', :pa => params[:email] , :id => params[:id]
          sender_name = params[:sender_name]
          sender_email = params[:sender_email]
          reciepent_message=params[:reciepent_message]
          messageboard_link="http://www.holdmymemories.com/familywebsite/messageboard/"+params[:id]

          pass = 'n'

          if (params[:share_type] == 'journal' || params[:share_type] == 'biography')
            @sha_type = params[:share_type]
          else
            @sha_type = 'moment'
          end
          if params[:reciepent_email]
            @frdEmail = params[:reciepent_email]
            frindsEmail=@frdEmail.split(',')
            for i in frindsEmail

              Postoffice.deliver_shareMomentpages(i,sender_name,sender_email,params[:link],reciepent_message,@sha_type,pass,messageboard_link,family_img,content_url)


              @familywebsite_share = FamilywebsiteShare.new()
              @familywebsite_share['senders_name']=params[:sender_name]
              @familywebsite_share['senders_email']=params[:sender_email]
              @familywebsite_share['share_message']=params[:reciepent_message]
              @familywebsite_share['reciepent_emails']=i
              @familywebsite_share['website_owner_id']=@uid
              @familywebsite_share['share_date']=Time.now
              @familywebsite_share['family_website']=params[:id]
              @familywebsite_share.save
            end
          end

          if params[:address_email]

            adrsEmail=params[:address_email]
            for j in adrsEmail

              Postoffice.deliver_shareMomentpages(j,sender_name,sender_email,params[:link],reciepent_message,@sha_type,pass,messageboard_link,family_img,content_url)

              @familywebsite_share = FamilywebsiteShare.new()
              @familywebsite_share['senders_name']=params[:sender_name]
              @familywebsite_share['senders_email']=params[:sender_email]
              @familywebsite_share['share_message']=params[:reciepent_message]
              @familywebsite_share['reciepent_emails']=j
              @familywebsite_share['website_owner_id']=@uid
              @familywebsite_share['share_date']=Time.now
              @familywebsite_share['family_website']=params[:id]
              @familywebsite_share.save
            end
          end
          session[:journal] = "journal"
          $share_familypage
          flash[:message] = "<font color='#e75e16' size=3>Your moment was successfully shared.</font>"
          redirect_to @link
        end
      else
        flash[:message] = "<font color='#e75e16' size=3>Please enter the correct code!</font>"
        redirect_to params[:redirect_url]
      end
    end
    #    render :layout => false
  end

  def comment_popup
    flash[:notice_com] = ""
    if params[:popup] != "true"
      unless params[:moment_comment].blank?
        if simple_captcha_valid?
          if params[:apply_to] == "image"
            @moment_comment = PhotoComment.new(params[:moment_comment])
            @moment_comment['v_uid']= @family_website_owner.id
            @moment_comment['d_add_date']=Time.now
          elsif params[:apply_to] == "album"
            gallery_id = UserContent.find(params[:moment_id]).gallery_id
            @moment_comment = GalleryComment.new
            @moment_comment.v_name = params[:moment_comment][:v_name]
            @moment_comment.v_comment = params[:moment_comment][:v_comment]
            @moment_comment['uid'] = @family_website_owner.id
            @moment_comment['gallery_jid'] = 0
            @moment_comment['gallery_id'] = gallery_id
            @moment_comment['d_created_on'] = Time.now
          end
          if @moment_comment.save
            Postoffice.deliver_family_memory_comment(params[:moment_comment][:v_comment],'0','Photo',params[:moment_comment][:v_name],@family_website_owner.v_e_mail,@family_website_owner.v_user_name,@family_website_owner.v_e_mail,@family_website_owner.v_myimage,@family_website_owner.img_url)
            flash[:notice_com] = 'Thank-you for adding your comment!'
            #          redirect_to "#{params[:redirect_url]}"
          else
            flash[:notice_com] = 'Please enter the correct code!'
            #          redirect_to "#{params[:redirect_url]}"
          end
        else
          flash[:notice_com] = 'Please enter the correct code!'
          flash[:v_comment]=params[:moment_comment][:v_comment]
          flash[:v_name]=params[:moment_comment][:v_name]
          #        redirect_to "#{params[:redirect_url]}"
        end
      end
    end
    render :layout => false
  end

  def login_popup
    render :layout => false
  end

  def edit_content_date
    user_content = UserContent.find(session[:data])
    if !params[:new_value].nil? && params[:new_value] != user_content.d_momentdate.strftime("%B %d, %Y")
      date = params[:new_value].split("-")
      user_content.d_createddate = "#{date[2]}-#{date[0]}-#{date[1]}"
      user_content.save
    end
    render :json => {:html => user_content.d_createddate.strftime("%B %d, %Y"), :is_error => false, :error_text => ""}.to_json
  end

  def change_album
    mobile_chapter = MobileTag.find(:first,:conditions => "uid = #{@family_website_owner.id} and tag_type = 'mobile_uploads' and status='active'")
    #      all_albums = Array.new
    if mobile_chapter
      @ml_present = false
      @mobile_events = MobileSubChapter.find(:all,:conditions=>"tagid=#{mobile_chapter.id} AND status='active' AND (subchapter_type != 'memory_lane' or subchapter_type IS NULL) and uid=#{@family_website_owner.id}", :select => "id, sub_chapname, subchapter_type")
      @user_content = UserContent.find(params[:moment_id])
      @sub_chap_selected = @user_content.sub_chapid
    end
    flash[:notice_com] = ""
    render :layout => false
  end

  def edit_album
    if params[:apply_to] == "image"
      user_content = UserContent.find(params[:moment_id])
      old_gallery_id = user_content.gallery_id
      if !params[:desc] || params[:desc].nil?
        params[:desc] = ""
      end
      #only single image is moved to specified album
      if params[:sub_chapter][:id] && params[:sub_chapter][:id]!= '' && params[:new_album].blank? && params[:sub_chapter][:id] != 'new_album'
        gal = Galleries.find(:first, :conditions => "	subchapter_id = #{params[:sub_chapter][:id]} and e_gallery_type='#{user_content.e_filetype}'")
        images_in_new_gal = UserContent.count(:all, :conditions => "gallery_id = #{gal.id}")
        subchap = SubChapter.find(params[:sub_chapter][:id])
        count_gal = UserContent.count(:all, :conditions => "gallery_id = #{old_gallery_id}")
        if count_gal == 1
          gal_comments = GalleryComment.find(:all, :conditions => "gallery_id = #{old_gallery_id}")
          if gal_comments.count > 0
            for gal_comment in gal_comments
              gal_comment.gallery_id = gal.id
              gal_comment.save
            end
          end
        end
        user_content.v_tagname = subchap.sub_chapname
        user_content.sub_chapid = params[:sub_chapter][:id]
        user_content.gallery_id = gal.id
        user_content.save
        flash[:notice_com] = "Successfully moved this moment to #{gal.v_gallery_name} album"
        if images_in_new_gal == 0
          @get_content_url=ContentPath.find(:first, :conditions => "status='active'")
          redirect_to "#{@get_content_url['content_path']}/manage_icon/set_gallery_icon?id=#{gal.id}&itemId=#{user_content.id}&alert_msg=#{flash[:notice_com]}&set_icon=true&family_name=#{params[:id]}"
        else
          redirect_to "/family_memory/gallery_details/#{params[:id]}?moment_id=#{user_content.id}"
        end
      elsif !params[:new_album].blank? #only image is moved to new album
        mobile_tag = Tag.find(:first,:conditions=>"uid=#{@family_website_owner.id} and tag_type = 'mobile_uploads' and status='active'")
        subchap = MobileSubChapter.save_subchapter(params[:new_album],params[:desc],@family_website_owner.id,mobile_tag.id,gallery_type="all",auto_share=0,facebook_share=0)
        gal = Galleries.find(:first, :conditions => "	subchapter_id = #{subchap.id} and e_gallery_type='#{user_content.e_filetype}'" )
        gal.v_gallery_name = subchap.sub_chapname
        gal.save
        count_gal = UserContent.count(:all, :conditions => "gallery_id = #{old_gallery_id}")
        if count_gal == 1
          gal_comments = GalleryComment.find(:all, :conditions => "gallery_id = #{old_gallery_id}")
          if gal_comments.count > 0
            for gal_comment in gal_comments
              gal_comment.gallery_id = gal.id
              gal_comment.save
            end
          end
          gal_blog = Blog.first(:conditions => "blog_type = 'gallery' and blog_type_id = #{old_gallery_id}")
          if gal_blog
            gal_blog.blog_type_id = gal.id
            gal_blog.save
          end
        end
        user_content.v_tagname = subchap.sub_chapname
        user_content.sub_chapid = subchap.id
        user_content.gallery_id = gal.id
        user_content.save
        if !params[:desc].blank? && params[:desc] != ""
          @moment_comment = GalleryComment.new
          @moment_comment.v_name = @family_website_owner.v_user_name
          @moment_comment.v_comment = params[:desc]
          @moment_comment['uid'] = @family_website_owner.id
          @moment_comment['gallery_jid'] = 0
          @moment_comment['e_approval'] = 'approve'
          @moment_comment['gallery_id'] = gal.id
          @moment_comment['d_created_on'] = Time.now
          @moment_comment.save
        end
        flash[:notice_com] = "Successfully moved this moment to #{gal.v_gallery_name} album"
        @get_content_url=ContentPath.find(:first, :conditions => "status='active'")
        redirect_to "#{@get_content_url['content_path']}/manage_icon/set_subchapter_icon?id=#{subchap.id}&itemId=#{user_content.id}&set_icon=popup&alert_msg=#{flash[:notice_com]}&gallery_id=#{gal.id}&family_name=#{params[:id]}"
      end
    elsif params[:apply_to] == "album"
      usercontent = UserContent.find(params[:moment_id])
      #all moments are moved to specified album
      if params[:sub_chapter][:id] && params[:sub_chapter][:id]!= '' && params[:new_album].blank? && params[:sub_chapter][:id] != 'new_album'
        gal = Galleries.find(:first, :conditions => "	subchapter_id = #{params[:sub_chapter][:id]} and e_gallery_type='#{usercontent.e_filetype}'")
        images_in_new_gal = UserContent.count(:all, :conditions => "gallery_id = #{gal.id}")
        gal_comments = GalleryComment.find(:all, :conditions => "gallery_id = #{usercontent.gallery_id}")
        if gal_comments.count > 0
          for gal_comment in gal_comments
            gal_comment.gallery_id = gal.id
            gal_comment.save
          end
        end
        subchap = SubChapter.find(params[:sub_chapter][:id])
        user_contents = UserContent.find(:all, :conditions => "gallery_id = #{usercontent.gallery_id}")
        for user_content1 in user_contents
          user_content1.v_tagname = subchap.sub_chapname
          user_content1.sub_chapid = params[:sub_chapter][:id]
          user_content1.gallery_id = gal.id
          user_content1.save
        end
        flash[:notice_com] = "Successfully moved all moments to #{gal.v_gallery_name} album"
        if images_in_new_gal == 0
          @get_content_url=ContentPath.find(:first, :conditions => "status='active'")
          redirect_to "#{@get_content_url['content_path']}/manage_icon/set_gallery_icon?id=#{gal.id}&itemId=#{user_content.id}&alert_msg=#{flash[:notice_com]}&set_icon=true&family_name=#{params[:id]}"
        else
          redirect_to "/family_memory/gallery_details/#{params[:id]}?moment_id=#{user_content1.id}"
        end
      elsif !params[:new_album].blank? #all moments are moved to new album
        mobile_tag = Tag.find(:first,:conditions=>"uid=#{@family_website_owner.id} and tag_type = 'mobile_uploads' and status='active'")
        subchap = MobileSubChapter.save_subchapter(params[:new_album],params[:desc],@family_website_owner.id,mobile_tag.id,gallery_type="all",auto_share=0,facebook_share=0)
        gal = Galleries.find(:first, :conditions => "	subchapter_id = #{subchap.id} and e_gallery_type='#{usercontent.e_filetype}'")
        gal.v_gallery_name = subchap.sub_chapname
        gal.save
        gal_comments = GalleryComment.find(:all, :conditions => "gallery_id = #{usercontent.gallery_id}")
        if gal_comments.count > 0
          for gal_comment in gal_comments
            gal_comment.gallery_id = gal.id
            gal_comment.save
          end
        end
        gal_blog = Blog.first(:conditions => "blog_type = 'gallery' and blog_type_id = #{usercontent.gallery_id}")
        if gal_blog
          gal_blog.blog_type_id = gal.id
          gal_blog.save
        end
        user_contents = UserContent.find(:all, :conditions => "gallery_id = #{usercontent.gallery_id}")
        for user_content2 in user_contents
          user_content2.v_tagname = subchap.sub_chapname
          user_content2.sub_chapid = subchap.id
          user_content2.gallery_id = gal.id
          user_content2.save
        end
        if !params[:desc].blank? && params[:desc] != ""
          @moment_comment = GalleryComment.new
          @moment_comment.v_name = @family_website_owner.v_user_name
          @moment_comment.v_comment = params[:desc]
          @moment_comment['uid'] = @family_website_owner.id
          @moment_comment['gallery_jid'] = 0
          @moment_comment['e_approval'] = 'approve'
          @moment_comment['gallery_id'] = gal.id
          @moment_comment['d_created_on'] = Time.now
          @moment_comment.save
        end
        flash[:notice_com] = "Successfully moved all moments to #{gal.v_gallery_name} album"
        @get_content_url=ContentPath.find(:first, :conditions => "status='active'")
        redirect_to "#{@get_content_url['content_path']}/manage_icon/set_subchapter_icon?id=#{subchap.id}&itemId=#{user_content2.id}&set_icon=popup&alert_msg=#{flash[:notice_com]}&gallery_id=#{gal.id}&family_name=#{params[:id]}"
      end
    end
  end


  def change_privacy
    if params[:access]
      if params[:apply_to] == "image"
        user_content = UserContent.find(params[:moment_id])
        user_content.e_access= params[:access]
        if user_content.save
          render :text => "Successfully updated privacy settings!"
        else
          render :text => "Failed to update privacy settings, retry!"
        end
      elsif params[:apply_to] == "album"
        user_contents = UserContent.find(:all, :conditions => "gallery_id = #{params[:gallery_id]}")
        for user_content in user_contents
          user_content.e_access= params[:access]
          user_content.save
        end
        gal = Galleries.find(user_content.gallery_id)
        gal.e_gallery_acess = params[:access]
        gal.save
        render :text => "Successfully updated privacy settings!"
      end
    end
  end

  def update_details
    if !params[:name].nil? &&  !params[:name].blank? &&  !params[:description].nil? &&  !params[:description].blank?&&  !params[:content_id].nil? &&  !params[:content_id].blank? &&  !params[:date].nil? &&  !params[:date].blank?
      name=CGI.escapeHTML(params[:name])
      description=CGI.escapeHTML(params[:description])
      if params[:type]=="subchapter"
        subchapter = SubChapter.find(params[:content_id])
        subchapter.id = params[:content_id]
        subchapter.edited_name = name
        subchapter.v_desc =description
        subchapter.d_created_on = params[:date]
        subchapter.date_updated=params[:date]
        subchapter.save
      elsif params[:type]=="gallery"
        gallery = Galleries.find(params[:content_id])
        gallery.id = params[:content_id]
        gallery.edited_name =name
        gallery.v_desc = description
        gallery.d_gallery_date = params[:date]
        gallery.save
      elsif params[:type]=="moment"
        usercontent = UserContent.find(params[:content_id])
        usercontent.id = params[:content_id]
        usercontent.v_tagname = name
        usercontent.v_desc =description
        usercontent.d_createddate =params[:date]
        #      if usercontent.e_filetype=="image" && params[:rotation]=="true"
        #        content=ContentPath(:first,:conditions=>"status='active'")
        #        redirect_to "#{content.content_path}/moment_rotation/rotate_moment?id=#{usercontent.id}&&rotate_angle=#{params[:rotate_angle]}"
        #      end
        #usercontent.d_createddate = params[:date]
        usercontent.save
      end
      render :text=>"true"
    else
      render :text=>"false"
    end
  end

  def fb_comments
    render :layout=>false
  end

  def gallery_comments
    blog_ids = []
    @user_content = UserContent.find(params[:moment_id])
    @first_img = @user_content
    @blog = Blog.find(:first, :conditions => "blog_type_id=#{@first_img.id} and blog_type='#{@first_img.e_filetype}' and status='active'", :select => "id,title,description,added_date")
    if @blog
      blog_ids.push(@blog.id)
    end
    @gallery_blog = Blog.find(:first, :conditions => "blog_type_id=#{@first_img.gallery_id} and blog_type='gallery' and status='active'", :select => "id,title,description,added_date")
    if @gallery_blog
      blog_ids.push(@gallery_blog.id)
    end
    if !@blog.nil? || !@gallery_blog.nil?
      blog_ids = blog_ids.join(',')
      @blogcomments=BlogComment.find(:all,:conditions=>"blog_id IN (#{blog_ids}) and 	status='approved'")
      logger.info(blog_ids)
    end
    @comments = PhotoComment.find(:all, :conditions => "e_approved = 'approve' and user_content_id = #{@first_img.id}", :order => "id asc", :select =>"v_comment as comment,v_name as commenter,d_add_date as commented_date")
    @gallery_comments = GalleryComment.find(:all, :conditions => "e_approval = 'approve' and gallery_id = #{@first_img.gallery_id}", :order => "id asc", :select =>"v_comment as comment,v_name as commenter,d_created_on as commented_date")
    if !@first_img.nil? && !@first_img.v_desc.nil?
      desc = @first_img.v_desc.gsub(/\s+/, "")
      desc = desc.upcase
    end
    if !@gallery_blog.nil?
      gal_blog_desc = @gallery_blog.description.gsub(/\s+/, "")
      gal_blog_desc = gal_blog_desc.upcase
    end
    if @blog.nil?  && @blogcomments.nil? && @comments.nil? && @gallery_comments.nil? && (@gallery_blog.nil? && @gallery_blog.description == "" && !gal_blog_desc.match(/^ENTERDESCRIPTION/).nil?) && (@first_img.v_desc.blank? && @first_img.v_desc == "" && !desc.match(/^ENTERDESCRIPTION/).nil?)
      comment_present = true
      logger.info("*************first***************")
      logger.info(comment_present.inspect)
    else
      if ((!@comments.nil? && !@comments.empty?) ||( !@gallery_comments.nil? && !@gallery_comments.empty?) || !@blog.nil? || (!@blogcomments.nil? && !@blogcomments.empty?) || (!@gallery_blog.nil? && @gallery_blog.description != "" && gal_blog_desc.match(/^ENTERDESCRIPTION/).nil?) || (!@first_img.v_desc.blank? && @first_img.v_desc != "" && desc.match(/^ENTERDESCRIPTION/).nil?))
        comment_present = false
        logger.info("*************second*********#{@comments.inspect}******#{@gallery_comments.inspect}*******blog#{@blog.inspect}********#{@blogcomments.inspect}************gal_blog#{@gallery_blog.inspect}**********#{@first_img.v_desc.inspect}*****")
        logger.info(comment_present.inspect)
      else
        comment_present = true
        logger.info("*************third*********#{@comments.inspect}******#{@gallery_comments.inspect}*******blog#{@blog.inspect}********#{@blogcomments.inspect}************gal_blog#{@gallery_blog.inspect}**********#{@first_img.v_desc.inspect}*****")
        logger.info(comment_present.inspect)
      end
    end
    if params[:next] == "no"
      render :json => {:status => comment_present, :moment_id => "#{@first_img.id}", :album_name => "#{@first_img.v_tagname}", :moment_date => "#{@user_content.d_createddate.strftime("%B %d, %Y")}"}, :layout => false
    else
      session[:data] = @first_img.id
      render :partial => "comment_box", :locals => {:family_website_owner => @family_website_owner, :first_img => @first_img, :blog => @blog, :blogcomments => @blogcomments, :comments => @comments, :gallery_comments => @gallery_comments, :gal_blog => @gallery_blog, :comment_present => @comment_present2}
    end
  end

  def delete_item
    if !params[:user_id].nil? &&  !params[:user_id].blank? &&  !params[:type ].nil? &&  !params[:type].blank?&&  !params[:item_id].nil? &&  !params[:item_id].blank?
      if params[:type]=="subchapter"
        subchapter = SubChapter.find(:first,:conditions=>"id=#{params[:item_id]} and uid=#{params[:user_id]}")
        if !subchapter.nil? && !subchapter.blank?
          subchapter.status="inactive"
          subchapter.save
        end
        sql = ActiveRecord::Base.connection();
        sql.update "update galleries set status='inactive' where subchapter_id='#{params[:item_id]}'";
        sql.update "update user_contents set status='inactive' where sub_chapid='#{params[:item_id]}' and uid=#{params[:user_id]}";
      elsif params[:type]=="gallery"
        gallery = Galleries.find(params[:item_id])
        if !gallery.nil? && !gallery.blank?
          gallery.status="inactive"
          gallery.save
        end
        sql = ActiveRecord::Base.connection();
        sql.update "update user_contents set status='inactive' where gallery_id='#{params[:item_id]}' and uid=#{params[:user_id]}";
      elsif params[:type]=="moment"
        usercontent = UserContent.find(:first,:conditions=>"id=#{params[:item_id]} and uid=#{params[:user_id]}")
        if !usercontent.nil? && !usercontent.blank?
          usercontent.status="inactive"
          usercontent.save
        end
      end
    end
    render :text=>"true"
  end

  def update_date
    subs=SubChapter.find(:all,:conditions=>"status='active' and uid=4 and store_id is null and date_updated is not null",:limit=>10)
    for sub in subs
      if !sub.date_updated.nil? && !sub.date_updated.blank?
        sql = ActiveRecord::Base.connection();
        sql.update "update galleries set d_gallery_date='#{sub.date_updated}',date_updated='#{sub.date_updated}' where subchapter_id=#{sub.id}";
        sql.update "update user_contents set d_createddate='#{sub.date_updated}' where sub_chapid=#{sub.id} and uid=#{sub.uid}";
      end
    end
  end

  def update_studio_session_date
    subchapters=SubChapter.find(:all,:select=>"id",:conditions=>"status='active' and store_id!=''  and uid=4")
    for subchapter in subchapters
      gals=Galleries.find(:all,:conditions=>"id=#{subchapter.id} and date_updated is not null")
      for gal in gals
        if !gal.date_updated.nil? && !gal.date_updated.blank?
          sql = ActiveRecord::Base.connection();
          sql.update "update user_contents set d_createddate='#{gal.date_updated}' where gallery_id=#{gal.id} and uid=4";
        end
      end
    end
  end

end