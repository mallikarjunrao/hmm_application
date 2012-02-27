class OrderDetailsController < ApplicationController
  
  require 'money'
  
  layout "admin"
  require 'will_paginate'
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list    
    @order_details = OrderDetail.paginate :per_page => 10, :page => params[:page]
  end

  def show
    @order_detail = OrderDetail.find(params[:id])
  end

  def new
    @order_detail = OrderDetail.new

  end

  def create
    @order_detail = OrderDetail.new(params[:order_detail])
    if @order_detail.save
      flash[:notice] = 'OrderDetail was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @order_detail = OrderDetail.find(params[:id])
  end

  def update
    @order_detail = OrderDetail.find(params[:id])
    if @order_detail.update_attributes(params[:order_detail])
      flash[:notice] = 'OrderDetail was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    OrderDetail.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def shoppingcart_payment
    @hmm_user=HmmUser.find(params[:id])
    @amount = MyCart.sum('price', :conditions => "uid='#{logged_in_hmm_user.id}' " )
    render :layout => true
  end
  
  def process_payment
#    #adding no of copies in my_carts table
    
    
    card_no=params[:card_no]
    cvv_no=params[:cardcvv_no]
    exp_month=params[:exp_month]
    exp_year=params[:exp_year]
    fname=params[:fname]
    lname=params[:lname]
    street_address = params[:street_address]
    postcode = params[:postcode]
    city = params[:city]
    state = params[:state]
    country = params[:country]
    telephone = params[:telephone]
    
   
    
     amttest = Integer(params[:amount])
     
   
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
        gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(:test => true, :login => "8GxD65y84", :password=> "89j6d34cW8CKhp9S")
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
          gateway.capture(amount_to_charge, response.authorization)
          
          #creating unid for order_id
          @paymentdetail_max =  PaymentDetail.find_by_sql("select max(id) as n from payment_details")
          for paymentdetail_max in @paymentdetail_max
            paymentdetail_max_id = "#{paymentdetail_max.n}"
          end
          if(paymentdetail_max_id == '')
            paymentdetail_max_id = '0'
          end
          
          paymentdetail_next_id= Integer(paymentdetail_max_id) + 1
          orderuuid=PaymentDetail.find_by_sql("select uuid() as id")
          @unid=String(orderuuid.id)+"_"+"#{paymentdetail_next_id}"
          
            @find_itemsincart = MyCart.find(:all, :conditions => "uid = '#{logged_in_hmm_user.id}' and status='pending'") 
            for k in @find_itemsincart
              @order_detail = OrderDetail.new
              @order_detail['uid']= logged_in_hmm_user.id
              @order_detail['moment_type']= k.added_item
              @order_detail['order_unid']= @unid
              @order_detail['moment_id']= k.moment_id
              @order_detail['no_of_copies']= k.no_of_copies
              @order_detail['product_id']= k.product_id
              @order_detail['payment_status']= 'yes'
              @order_detail['order_status']= 'yes'
              @order_detail['shippment_status']= 'pending'
              @order_detail['order_date']=Time.now
              @order_detail['shippment_date']=Time.now + 3
              if @order_detail.save
                 MyCart.find(k.id).destroy
                 flag=1
              end
            end
            if flag == 1
            #saving payemnt deatils and order id
                 @payment_detail = PaymentDetail.new
                 @payment_detail['user_id']= logged_in_hmm_user.id
                 @payment_detail['order_id']= @unid
                 @payment_detail['fname']=fname
                 @payment_detail['lname']=lname
                 @payment_detail['amount']=amttest
                 @payment_detail['street_address']=street_address
                 @payment_detail['city']=city
                 @payment_detail['state']=state
                 @payment_detail['country']=country
                 @payment_detail['postcode']=postcode
                 @payment_detail['telephone']=telephone
                 @payment_detail['shipment_street_address']=street_address
                 @payment_detail['shipment_city']=city
                 @payment_detail['shipment_state']=state
                 @payment_detail['shipment_country']=country
                 @payment_detail['shipment_postcode']=postcode
                 @payment_detail['shipment_telephone']=telephone
                 @payment_detail['exp_month']=exp_month
                 @payment_detail['exp_year']=exp_year
                 @payment_detail['order_date']=Time.now
                 @payment_detail['shippment_date']=Time.now + 3
                 @payment_detail.save
             end
                 
            flash[:succes] = "Payment was successfully done, You will recieve your images in 7 working days."
            #redirect_to "https://www.holdmymemories.com/customers/authorise_payment/?id=#{params[:hmm_id]}&type=#{acctype}"
            redirect_to "/order_details/payment_complete"
         else   
            flash[:error] = "Transaction has been declined, below is the reason from authorize.net<br>"+message
            #redirect_to "https://www.holdmymemories.com/customers/authorise_payment/?id=#{params[:hmm_id]}&type=#{acctype}"
            redirect_to "/order_details/shoppingcart_payment/#{logged_in_hmm_user.id}"
         end
    else
      flash[:error] = "Error in credit card info! this error is from our website so the reason is invalid information added as wrong count of credit card numbers or cvv number is alphanumeric etc"
      #redirect_to "https://www.holdmymemories.com/customers/authorise_payment/?id=#{params[:hmm_id]}&type=#{acctype}"
      redirect_to "/order_details/shoppingcart_payment/#{logged_in_hmm_user.id}"
    end

  end

  def reciept
    @cart_detals = MyCart.find(:all, :conditions => "uid='#{logged_in_hmm_user.id}'")
    @amount = MyCart.sum('price', :conditions => "uid='#{logged_in_hmm_user.id}' " )    
    render :layout => false
  end
  
  def success
   
  end
 
  def failed
   
  end 
  
  def fill_form
   
 end
 
 def sizes_list
   @tag=OrderDetail.find(params[:id])
   @pids=@tag.product_id
    @m=@pids.split(',')   
 end
  
end
