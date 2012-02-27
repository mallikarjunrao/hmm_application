class CustomerGiftCertificatesController < ApplicationController
  require 'money'
  require 'active_merchant'

  before_filter  :redirect_url
  ssl_required :select_certificate_processing,:select_certificate,:submit_certificate,:get_description
  ssl_allowed  :user_type,:update_cert_image

  def redirect_url
    url= request.url.split("/")
    for i in 0..url.length
      if url[i]
        url[i]=url[i].upcase
        logger.info(url[i])
        if((url[i].match("<SCRIPT>")) || (url[i].match("</SCRIPT>")) || (url[i].match("</SCRIP>")) || (url[i].match("<SCRIP")) ||(url[i].match("JAVASCRIPT:ALERT"))||(url[i].match("<<<<<<<<<<$URL$>>>>>")))
          redirect_to "/nonexistent_page.html"
        end
      end
    end
  end

  def select_certificate
    @stud_id=Base64.decode64(params[:id])
    @stud_id=@stud_id.to_i
    @acc=params[:acc]
    # @membership_terms=MembershipTerm.find(:all,:select=>"a.*,b.id as cid,b.total_price,b.certificate_price,b.certificate_name",:joins=>"as a,gift_certificates as b,gift_certificate_studios as c",:conditions=>"a.status='active' and b.status='active' and a.id=b.membership_term_id and b.id=c.gift_certificates_id and studio_id=#{@stud_id}")
    @membership_terms=GiftCertificate.find(:all,:select=>"a.*,a.id as cid,a.total_price,a.certificate_price,a.certificate_name",:joins=>"as a,gift_certificate_studios as c",:conditions=>"a.status='active' and a.id=c.gift_certificates_id and studio_id=#{@stud_id}",:order=>"id desc")
    @states=State.find(:all)
  end

  def get_description
    if params[:cert_id]!=''
      descriptions=GiftCertificateDescription.find(:all,:conditions=>"gift_certificates_id=#{params[:cert_id]}")
      disclaimer=GiftCertificate.find(:first,:conditions=>"id=#{params[:cert_id]}")
      if descriptions
        res=''
        for description in descriptions
          res=res.concat("<span class='orange-headlink'>*#{description.description}</span><br>")
        end
        if params[:acc]=="HMM"
        else
          if disclaimer.membership_option=="yes"
            desc=MembershipTerm.find(:first,:conditions=>"id=#{disclaimer.membership_term_id}")
            res=res.concat("<span class='orange-headlink'>*#{desc.full_text}</span><br>")
          end
        end
        res=res.concat("<br><br>")
        res=res.concat("<span class='smaltxt'><em>#{disclaimer.disclaimer_notes}</em></span><br>")
      else
        res="No Description Found"
      end
    end
    render :text => res
  end

  def submit_certificate

    if !params[:certificate_id].nil? && !params[:studio_id].nil? && !params[:street_address].nil? && !params[:city].nil? && !params[:state].nil? && !params[:zip].nil? && !params[:telephone].nil? && !params[:email].nil? && !params[:deliver_email].nil?
      card_no=params[:card_number]
      cvv_no=params[:card_cvv]
      exp_month=params[:exp_month]
      exp_year=params[:exp_year]
      fname=params[:first_name]
      lname=params[:last_name]

      creditcard = ActiveMerchant::Billing::CreditCard.new(
        #:type => params[:creditcard][:card_type],
        :number => card_no,
        :month => exp_month,
        :year => exp_year,
        :first_name => fname,
        :last_name => lname,
        :verification_value => cvv_no
      )
      # certificate_info=GiftCertificate.find(:first,:select=>"a.*,b.*",:joins=>"as a,membership_terms as b",:conditions=>"a.membership_term_id=b.id and a.id=#{params[:certificate_id]}")
      certificate_info=GiftCertificate.find(:first,:conditions=>"id=#{params[:certificate_id]}")
      if certificate_info.membership_option=="yes"
        logger.info("amt")
        logger.info(certificate_info.total_price)
        membership_terms=MembershipTerm.find(:first,:conditions=>"id=#{certificate_info.membership_term_id}")
        if params[:acc]=="HMM"
          amt=certificate_info.total_price.to_f-membership_terms.charge.to_f
          membership_fee=0
        else
          amt=certificate_info.total_price
          membership_fee=membership_terms.charge
        end
      else
        amt=certificate_info.total_price
        membership_fee=0
      end
      logger.info(amt)
      logger.info(amt)

      logger.info("amt")




      if creditcard.valid?
        # flash[:message] ="Creditcard Info saved!"
        gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(:test =>false, :login => "8GxD65y84", :password=> "89j6d34cW8CKhp9S")
        amount_to_charge = amt * 100 #1000 = ten US dollars
        creditcard = ActiveMerchant::Billing::CreditCard.new(

          :number => card_no,
          :month => exp_month,
          :year => exp_year,
          :first_name => fname,
          :last_name => lname,
          :verification_value => cvv_no
        )

        options = {
          :address => {},
          :billing_address => {
            :name     => "#{fname} #{lname}",
            :address1 => params[:street_address],
            :city     => params[:city],
            :state    => params[:state],
            :country  => "United States",
            :zip      => params[:zip],
            :phone    =>  params[:telephone]
          }
        }
        response = gateway.authorize(amount_to_charge,creditcard,options)
        if response.success?
          gateway.capture(amount_to_charge, response.authorization)



          orderuuid=CustomerOrderCertificate.find_by_sql("select uuid() as id")
          customer=CustomerOrderCertificate.new
          customer.certificate_id=params[:certificate_id]
          customer.studio_id=params[:studio_id]
          customer.membership_fee=membership_fee
          customer.amount=amt
          customer.first_name=fname
          customer.last_name=lname
          customer.street_address=params[:street_address]
          customer.city=params[:city]
          customer.state=params[:state]
          customer.zip=params[:zip]
          #phone=number_to_phone(params[:telephone], :area_code => true)
          customer.telephone=params[:telephone]
          customer.email=params[:email]
          customer.deliver_email=params[:deliver_email]
          customer.purchased_date=Date.today
          customer.order_no=orderuuid.id
          customer.save

          Postoffice.deliver_studio_certificates(customer.certificate_id,customer.studio_id,customer.id)

          Postoffice.deliver_studio_certificate_receipt(customer)

          session[:membership_term_id]=''
          session[:acc]=''
          session[:street_address]=''
          session[:city]=''
          session[:state]=''
          session[:zip]=''
          session[:telephone]=''
          session[:email]=''
          session[:deliver_email]=''
          session[:studio_id]=''

          redirect_to "/customer_gift_certificates/show_certificate/#{customer.certificate_id}?studio_id=#{Base64.encode64(customer.studio_id.to_s)}&&cert_id=#{Base64.encode64(customer.id.to_s)}"
        else
          flash[:errors] = "Transaction has been declined, below is the reason from authorize.net<br>"+response.message
          redirect_to "/customer_gift_certificates/select_certificate_processing"
        end
      else

        flash[:errors] = "Error in credit card info! this error is from our website so the reason is invalid information added as wrong count of credit card numbers or cvv number is alphanumeric etc"
        redirect_to "/customer_gift_certificates/select_certificate_processing"
      end
    else
      redirect_to "/customer_gift_certificates/select_certificate_processing"
      flash[:errors] = "Some of the parameters missing"
    end
    logger.info(flash[:errors])
  end

  def show_certificate
    @studio_id=Base64.decode64(params[:studio_id])
    @studio_id= @studio_id.to_i

    @cert_id=Base64.decode64(params[:cert_id])
    @cert_id= @cert_id.to_i

    @certificate_info=GiftCertificate.find(:first,:conditions=>"id=#{params[:id]}")
    @certificate_desc=GiftCertificateDescription.find(:all,:conditions=>"gift_certificates_id=#{params[:id]}")
    @studio=HmmStudio.find(:first,:conditions=>"id=#{@studio_id}")
    @cert_info=CustomerOrderCertificate.find(:first,:conditions=>"id=#{@cert_id}")
    @other_studios=GiftCertificate.find(:all,:select=>"c.studio_name,c.studio_phone",:joins=>"as a,gift_certificate_studios as b,hmm_studios as c",:conditions=>"a.id=b.gift_certificates_id and c.id=b.studio_id and a.id=#{params[:id]}")
  end

  def user_type
    render :layout=>false
  end

  def number_to_phone(number, options = {})
    number       = number.to_s.strip unless number.nil?
    options      = options.symbolize_keys
    area_code    = options[:area_code] || nil
    delimiter    = options[:delimiter] || "-"
    extension    = options[:extension].to_s.strip || nil
    country_code = options[:country_code] || nil

    begin
      str = ""
      str << "+#{country_code}#{delimiter}" unless country_code.blank?
      str << if area_code
        number.gsub!(/([0-9]{1,3})([0-9]{3})([0-9]{4}$)/,"(\\1) \\2#{delimiter}\\3")
      else
        number.gsub!(/([0-9]{0,3})([0-9]{3})([0-9]{4})$/,"\\1#{delimiter}\\2#{delimiter}\\3")
        number.starts_with?('-') ? number.slice!(1..-1) : number
      end
      str << " x #{extension}" unless extension.blank?
      str
    rescue
      number
    end
  end

  def update_cert_image
    unless params[:cert_id].nil? || params[:cert_id].blank?
    cert = GiftCertificate.find(:first,:conditions=>"id=#{params[:cert_id]}")
    cert_image = cert.certificate_image
    if cert_image != "" && !cert_image.nil?
      render :text => "<img src='#{cert.img_url}/user_content/gift_certificates/#{cert_image}' border='0' width='232' height='132'/>", :layout => false
    else
      render :text => "false", :layout => false
    end
    else
      render :text => "false", :layout => false
    end
  end

end