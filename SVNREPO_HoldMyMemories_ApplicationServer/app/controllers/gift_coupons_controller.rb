class GiftCouponsController < ApplicationController

  require 'money'
  require 'active_merchant'

  def get_gift_coupon
    
  end

  def process_payment

    card_no=params[:card_no]
    cvv_no=params[:cardcvv_no]
    expiry_date=params[:exp_year]+"-"+params[:exp_month]
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

    if(params[:payment_type] == 'platinum_user')
        if(params[:amount_platinum]=="9.95")
          amttest=995
        elsif(params[:amount_platinum]=="49.95")
          amttest=4995
        elsif(params[:amount_platinum]=="99.95")
          amttest=9995
        end
      end
      if(params[:payment_type] == 'familyws_user')
        if(params[:amount_fws]=="4.95")
          amttest=495
        elsif(params[:amount_fws]=="24.95")
          amttest=2495
        elsif(params[:amount_fws]=="49.95")
          amttest=4995
        end
      end


    creditcard = ActiveMerchant::Billing::CreditCard.new(
        #:type => params[:creditcard][:card_type],
        :number => card_no,
        :month => exp_month,
        :year => exp_year,
        :first_name => fname,
        :last_name => lname,
        :verification_value => cvv_no
        )
  if creditcard.valid?
    #if @creditcard.save
      flash[:message] ="Creditcard Info saved!"
      #redirect_to :action => 'check_balance', :id=> @creditcard
      #@creditcard = Creditcard.find(params[:id])
        gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(:test => false, :login => "8GxD65y84", :password=> "89j6d34cW8CKhp9S")
        amount_to_charge = Money.ca_dollar(amttest) #1000 = ten US dollars
        creditcard = ActiveMerchant::Billing::CreditCard.new(
        #:type => params[:creditcard][:card_type],
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
          :name     => "#{fname}  #{lname}",
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

        gift_coupon = GiftCoupon.new()
        if(params[:payment_type] == 'platinum_user')
            gift_coupon.amount=params[:amount_platinum]
            if(params[:amount_platinum]=="9.95")
              gift_coupon.months="1"

            elsif(params[:amount_platinum]=="49.95")
              gift_coupon.months="6"

            elsif(params[:amount_platinum]=="99.95")
              gift_coupon.months="12"

            end
        end

        if(params[:payment_type] == 'familyws_user')
          gift_coupon.amount=params[:amount_fws]
        if(params[:amount_fws]=="4.95")
          gift_coupon.months="1"
        elsif(params[:amount_fws]=="24.95")
          gift_coupon.months="6"
        elsif(params[:amount_fws]=="49.95")
          gift_coupon.months="12"
        end
      end




        gift_coupon.gift_type=params[:payment_type]
        gift_coupon.street_address=params[:street_address]
        gift_coupon.city=params[:city]
        gift_coupon.state=params[:state]
        gift_coupon.telephone=params[:telephone]
        gift_coupon.zipcode=params[:postcode]
        gift_coupon.email_id=params[:email]
        gift_coupon.firstname=params[:fname]
        gift_coupon.lastname=params[:lname]
        gift_coupon.gifted_to_email = params[:gifted_to_email]
        gift_coupon.save
        @uuid =  HmmUser.find_by_sql(" select UUID() as u")
        unid = @uuid[0]['u']
        gift_coupon.unid = "#{gift_coupon.id}#{unid}"
        gift_coupon.save
       #redirect_to :action => "gift_coupon", :id => gift_coupon.unid
       redirect_to :action => "enter_sender_details", :id => gift_coupon.unid
      else
          message = response.message
          if(message == "No Match")
            message = "Card Code Status: No Match"
          end

        flash[:error] = "Transaction has been declined due to following reason <br>"+message
        redirect_to "/gift_coupons/get_gift_coupon/?gift=#{params[:typ]}"
      end
  else
        flash[:error] =  "Error Message = " +  "This is a general error Entered Credit card number or CVV number is invalid"
        redirect_to "/gift_coupons/get_gift_coupon/?gift=#{params[:typ]}"
  end

  end

  def gift_coupon
    @gift_coupon=GiftCoupon.find(:first, :conditions=>"unid='#{params[:id]}'" )
    render :layout => false
  end

  def activate_gift_coupon

  end

  def submit_gift_coupon
  #  if(params[:coupon_id]!='' && params[:coupon_id]!=nil)
     @user = HmmUser.count(:all, :conditions => "gift_coupon_id='#{params[:coupon_id]}'")
     @gift = GiftCoupon.count(:all, :conditions => "unid='#{params[:coupon_id]}'")
       if(@user>0 || @gift==0)
           flash[:error] =  " Invalid Coupon Number / Coupon Number Already Used"
           redirect_to "/gift_coupons/activate_gift_coupon"
       else
         flash[:error] =  " Coupon Number is Valid "
         redirect_to "/customers/new_gift_coupon_account/?coupon_no=#{params[:coupon_id]}"
       end
   #  end
  end

  def validate_coupon
    color = 'red'
   cpnnum = params[:coupon_id]
   user = HmmUser.count(:all, :conditions => "gift_coupon_id='#{cpnnum}'")
   gift = GiftCoupon.count(:all, :conditions => "unid='#{cpnnum}'")
   if (user > 0 || gift==0)
     message = 'Coupon Number is Invalid/Already Used'
     @valid_username = false
   else
     message = 'Coupon Number Is Available'
     color = 'green'
     @valid_username=true
   end
   @message = "<b style='color:#{color}'>#{message}</b>"
    render :partial=>'message' , :layout => false
  end

  def enter_sender_details
    
  end

  def submit_sender_details
   
    @gift= GiftCoupon.find(:first, :conditions => "unid='#{params[:id]}'")
    @gift['recipient_name']=params[:name]
    @gift['gifted_to_email']=params[:email]
    @gift['message']=params[:message]
    @gift.save

    #email to purchaser
    Postoffice.deliver_giftcoupon_mail(@gift.unid,params[:name],params[:email],@gift.created_at,@gift.email_id,@gift.gift_type,@gift.amount,@gift.months)


    #email to recipient
    Postoffice.deliver_giftcoupon_recipient_mail(@gift.unid,params[:name],params[:email],params[:message],@gift.firstname,@gift.lastname,@gift.gift_type)

    redirect_to :action => "gift_coupon", :id => @gift.unid

  end


end
