class HmmStudiogroupsController < ApplicationController
  layout "admin"
  include SortHelper
  helper :sort
  include SortHelper
  helper :customers
  include CustomersHelper
  require 'will_paginate'
  require 'money'
  require 'active_merchant'
  ssl_required :all

  def index
    list
    render :action => 'list'
  end

  before_filter :login_franchise_check, :except => [ :create, :update, :list, :new , :promocode_form ,:discount_code_excel,:promocode_form1,:promocode_form,:gen_promocode,:studiogroup_delete,:studiogroup_assign,:studiogroup_assign_form,:admin_shipping_price_list,:admin_new_shipprice,:admin_add_shipprice,:admin_edit_shipprice,:admin_update_shipprice,:admin_destroy_shipprice,:reassign_notes,:studio_management_customers,:manage_studio_logo,:manage_app_name,:manage_app_store_description,:admin_shipping_price_list,:admin_edit_shipprice]

 
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
    :redirect_to => { :action => :list }

  def login_franchise_check
    unless session[:franchise]
      flash[:notice] = 'Please Login to Access Franchise Admin Account'
      redirect_to :controller => 'account', :action => 'franchise_login'
      return false
    end
  end

  def list
    @hmm_studiogroups = HmmStudiogroup.paginate :per_page => 10, :page => params[:page]
  end

  def show
    @hmm_studiogroup = HmmStudiogroup.find(params[:id])
  end

  def new
    @hmm_studiogroup = HmmStudiogroup.new
  end

  def create
    @hmm_studiogroup = HmmStudiogroup.new(params[:hmm_studiogroup])

    username =params[:hmm_studiogroup][:studiogroup_username]
    user = HmmStudiogroup.count(:all, :conditions => "studiogroup_username='#{username}'")
    if user > 0
      flash[:notice] = 'User Name Already exists'
      render :action => 'new'
    else
      @hmm_studiogroup.save
      flash[:notice] = 'HmmStudiogroup was successfully created.'
      redirect_to :action => 'list'

    end
  end

  def edit
    @hmm_studiogroup = HmmStudiogroup.find(params[:id])
  end

  def update
    @hmm_studiogroup = HmmStudiogroup.find(params[:id])
    if @hmm_studiogroup.update_attributes(params[:hmm_studiogroup])
      flash[:notice] = 'HmmStudiogroup was successfully updated.'
      redirect_to :action => 'show', :id => @hmm_studiogroup
    else
      render :action => 'edit'
    end
  end

  def destroy
    HmmStudiogroup.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def validate
    color = 'red'
    username =params[:studiogroup_username]
    user = HmmStudiogroup.count(:all, :conditions => "studiogroup_username='#{username}'")
    if user > 0
      message = 'User Name Is Already Registered'
      @valid_username = false
    else
      message = 'User Name Is Available'
      color = 'green'
      @valid_username=true
    end
    @message = "<b style='color:#{color}'>#{message}</b>"
    render :partial=>'message' , :layout => false
  end


  def change_password



  end

  def update_password

    password=params[:confirm][:old_password]
    user = HmmStudiogroup.count(:all, :conditions => "password='#{password}'")

    if user>0

      @hmm_group = HmmStudiogroup.find(12)
      @hmm_group.password=params[:hmm_studiogroup][:password]
      @hmm_group.save

      flash[:notice] = 'Password Changed Successfully'
      render :action => 'change_password'

    else

      flash[:notice] = 'Current Password is Incorrect'
      render :action => 'change_password'

    end

  end

  def franchise_home

  end

  def employee_list
    @hmm_studio = HmmStudio.find(:all, :conditions => "studio_groupid = '#{session[:franchise]}'")

  end

  def customer_list
    @hmm_studio = HmmStudio.find(:all, :conditions => "studio_groupid = '#{session[:franchise]}'")
  end

  def studiogroup_editprofile

    @hmm_studio = HmmStudiogroup.find(session[:franchise])
    @states_list=State.find(:all)

  end

  def studiogroup_changepassword

    @hmm_studio = HmmStudiogroup.find(session[:franchise])
    @states_list=State.find(:all)

  end

  def studioshipping_list
    @hmm_studios = HmmStudio.paginate :per_page => 10,:conditions=>"studio_groupid=#{session[:franchise]}", :page => params[:page]

  end

  #Shipping Prices
  def shipping_price_list
    unless params[:id].blank?
      studio_id = params[:id]
    else
      studio_id = 0
      @fstudio=HmmStudio.find(:first,:conditions=>"status='active' and studio_groupid=#{session[:franchise]}",:order=>"id asc")
      redirect_to :action => "shipping_price_list", :id =>@fstudio.id
    end


    @shippingmethod=ShippingMethod.find(:all,:conditions=>"studio_id=#{studio_id}",:order=>"id desc")

    @studios=HmmStudio.find(:all,:conditions=>"status='active' and studio_groupid=#{session[:franchise]}",:order=>"id asc")

  end

  def add_shipprice

    @shipmethod=ShippingMethod.new
    @shipmethod.method_name=params[:ship_method]
    @shipmethod.studio_id=params[:sid]
    @shipmethod.save

    @last_index= ShippingMethod.find(:first, :order => "id desc")

    j=0
    j=9
    i=0
    until i == Integer(j)
      i=i+1

      @shipprice = ShippingPrice.new
      @shipprice.start_price=params["start_value#{i}"]
      @shipprice.end_price=params["end_value#{i}"]
      @shipprice.ship_price=params["ship_price#{i}"]
      @shipprice.method_id=@last_index['id']
      @shipprice.save

    end

    flash[:notice] = 'Shipping Price was successfully added.'
    redirect_to :action => 'shipping_price_list' ,:id =>params[:sid]

  end

  def edit_shipprice
    @shipname=ShippingMethod.find(params[:id])

    @shipprice=ShippingPrice.find(:all,:conditions=>"method_id=#{params[:id]}")

  end



  def update_shipprice

    @shipname=ShippingMethod.find(params[:id])
    @shipname.method_name=params[:ship_method]
    @shipname.save

    j=0
    j=9
    i=0
    until i == Integer(j)
      i=i+1
      @shipprice=ShippingPrice.find(params["sid#{i}"])
      @shipprice.ship_price=params["ship_price#{i}"]
      @shipprice.save
    end
    flash[:notice] = 'Shipping Price was successfully updated.'
    redirect_to :action => 'shipping_price_list' ,:id =>params[:sid]

  end

  def destroy_shipprice

    ShippingMethod.find(params[:id]).destroy
    @ship=ShippingPrice.find(:all , :conditions=>"method_id=#{params[:id]}")
    for k in @ship
      ShippingPrice.find(k.id).destroy
    end

    flash[:notice] = 'Shipping Price was successfully deleted.'
    redirect_to :action => 'shipping_price_list' , :id=>params[:sid]
  end


  #Manage Admin Shipping Prices

  def admin_shipping_price_list
    unless params[:id].blank?
      studio_id = params[:id]
    else
      studio_id = 0
    end


    @shippingmethod=ShippingMethod.find(:all,:conditions=>"studio_id=#{studio_id}",:order=>"id desc")

    @studios=HmmStudio.find(:all,:conditions=>"status='active'",:order=>"id asc")

  end

  def admin_new_shipprice

  end

  def admin_add_shipprice

    @shipmethod=ShippingMethod.new
    @shipmethod.method_name=params[:ship_method]
    @shipmethod.studio_id=params[:sid]
    @shipmethod.save

    @last_index= ShippingMethod.find(:first, :order => "id desc")

    j=0
    j=9
    i=0
    until i == Integer(j)
      i=i+1

      @shipprice = ShippingPrice.new
      @shipprice.start_price=params["start_value#{i}"]
      @shipprice.end_price=params["end_value#{i}"]
      @shipprice.ship_price=params["ship_price#{i}"]
      @shipprice.method_id=@last_index['id']
      @shipprice.save

    end

    flash[:notice] = 'Shipping Price was successfully added.'
    redirect_to :action => 'admin_shipping_price_list' ,:id =>params[:sid]

  end

  def admin_edit_shipprice
    @shipname=ShippingMethod.find(params[:id])

    @shipprice=ShippingPrice.find(:all,:conditions=>"method_id=#{params[:id]}")

  end

  def admin_update_shipprice

    @shipname=ShippingMethod.find(params[:id])
    @shipname.method_name=params[:ship_method]
    @shipname.save

    j=0
    j=9
    i=0
    until i == Integer(j)
      i=i+1
      @shipprice=ShippingPrice.find(params["sid#{i}"])
      @shipprice.ship_price=params["ship_price#{i}"]
      @shipprice.save
    end
    flash[:notice] = 'Shipping Price was successfully updated.'
    redirect_to :action => 'admin_shipping_price_list' ,:id =>params[:sid]

  end

  def admin_destroy_shipprice

    ShippingMethod.find(params[:id]).destroy
    @ship=ShippingPrice.find(:all , :conditions=>"method_id=#{params[:id]}")
    for k in @ship
      ShippingPrice.find(k.id).destroy
    end

    flash[:notice] = 'Shipping Price was successfully deleted.'
    redirect_to :action => 'admin_shipping_price_list' , :id=>params[:sid]
  end

  # Manage Admin Ship price ends


  #Manage Sizes & Prices
  def studioprices_list
    @hmm_studios = HmmStudio.paginate :per_page => 10,:conditions=>"studio_groupid=#{session[:franchise]}", :page => params[:page]
  end



  def pricelist_company
    #@product_pages, @products = paginate :products, :per_page => 10
    @pcount=Size.count(:all,:conditions=>"studio_type='company' and studio_id='#{params[:sid]}' and default_size='1'")

    if(@pcount==0)
      @pdetcount=Size.count(:all,:conditions=>"studio_id=#{params[:sid]}")
      if(@pdetcount>0)
        @pdet=Size.find(:first,:conditions=>"studio_type='company' and studio_id='#{params[:sid]}'",:order=>"id asc")
        @products_update = Size.find(@pdet.id)
        @products_update.default_size=1
        @products_update.save
      end
    end

    @products=Size.find(:all,:conditions=>"studio_type='company' and studio_id='#{params[:sid]}'")

  end

  def new_company
    @product = Size.new
  end

  def create_company
    if(Float(params[:width])<=20.0 && Float(params[:width])<=20.0)
      @product = Size.new()
      @product.studio_type='company'
      @product.name=params[:name]
      @product.width=params[:width]
      @product.height=params[:height]
      @product.dpi=params[:dpi]
      @product.price=params[:price]
      @product.studio_id=params[:sid]

      if @product.save
        flash[:notice] = 'Product was successfully created.'
        redirect_to :action => 'pricelist_company' , :sid =>params[:sid]
      else
        render :action => 'new_company'
      end

    else
      flash[:notice] = 'Height & Width should be in inches and not more than 20'
      redirect_to :action => 'new_company'
    end

  end

  def edit_company
    @product = Size.find(params[:id])
  end

  def update_company
    if(Float(params[:width])<=20.0 && Float(params[:width])<=20.0)
      @product =Size.find(params[:id])
      @product.name=params[:name]
      @product.studio_type='company'
      @product.width=params[:width]
      @product.height=params[:height]
      @product.dpi=params[:dpi]
      @product.price=params[:price]
      @product.studio_id=params[:sid]

      if @product.save
        flash[:notice] = 'Product was successfully updated.'
        redirect_to :action => 'pricelist_company' , :sid =>params[:sid]
      else
        render :action => 'edit_company'
      end
    else
      flash[:notice] = 'Height & Width should be in inches and not more than 20'
      redirect_to :action => 'edit_company'
    end
  end

  def destroy_company
    Size.find(params[:id]).destroy
    redirect_to :action => 'pricelist_company' , :sid =>params[:sid]
  end

  def set_default_studio

    if(params[:sid])
      studioid=params[:sid]
    else
      studioid=0
    end

    sql = ActiveRecord::Base.connection();
    @temp_access_arr = sql.execute("update sizes set default_size='0' where studio_id='#{studioid}'");
    @defsize = sql.execute("update sizes set default_size='1' where studio_id='#{studioid}' and id='#{params[:id]}'");
    sql.commit_db_transaction;
    flash[:notice] = 'Shipping Price was successfully updated.'
    redirect_to :action => 'pricelist_company' ,:sid=>params[:sid]
  end

  #Manage Orders
  def order_details


    sort_init 'id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "id desc"
      else
        sort = "id desc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end

    if(params[:store_id]!=nil && params[:store_id]!='')
      storecond=" and process_studio_id=#{params[:store_id]}"
    end

    if(params[:order_number]!=nil && params[:order_number]!='')
      ordcond=" and order_number='#{params[:order_number]}'"
    end

    if(params[:status]!=nil && params[:status]!='')
      statuscond=" and orders_status='#{params[:status]}'"
    end

    if(params[:store_id]== nil && params[:order_number]== nil && params[:status]== nil)
      #session[:search_cond]=""
    else
      searchcond="#{storecond} #{ordcond} #{statuscond}"
    end


    @studios=HmmStudio.find(:all,:conditions=>"studio_groupid=#{session[:franchise]}")

    if(@studios.length>0)

      a = Array.new
      for @studio in @studios
        a.push(@studio.id)
      end

      @list_studios=a.join(",")
      @ordcnt=Order.count(:all,:conditions=>"1=1 and process_studio_id IN (#{@list_studios}) #{searchcond}")
      @order_details = Order.paginate :per_page => 10, :page => params[:page],:order =>sort,:conditions=>"1=1 and process_studio_id IN (#{@list_studios}) #{searchcond}"

    else
      @ordcnt=0
    end
  end

  def order_view
    @get_content_url=ContentPath.find(:first, :conditions => "status='active'")
    @proxyurl=@get_content_url['content_path']
    @order_details=Order.find(params[:id])
    @order_products = OrderProduct.find(:all,:conditions=>"order_id='#{params[:id]}'",:order => "order_num asc")
    if(@order_details.studio_id!=0)
      @studio_details=HmmStudio.find(@order_details.studio_id)
    end
  end

  def print_orderview
    @get_content_url=ContentPath.find(:first, :conditions => "status='active'")
    @proxyurl=@get_content_url['content_path']
    @order_details=Order.find(params[:id])
    @order_products = OrderProduct.find(:all,:conditions=>"order_id='#{params[:id]}'",:order => "order_num asc")
    if(@order_details.studio_id!=0)
      @studio_details=HmmStudio.find(@order_details.studio_id)
    end
    render(:layout => false)
  end

  def delete_order
    #OrderProduct.find(:all,:conditions=>"order_id='#{params[:id]}'").destroy
    Order.find(params[:id]).destroy
    @ordprods=OrderProduct.find(:all,:conditions=>"order_id='#{params[:id]}'")
    for k in @ordprods
      OrderProduct.find(k.id).destroy
    end
    flash[:notice] = 'Order was successfully deleted.'
    redirect_to :action => 'order_details'
  end

  def update_status
    @order_details=Order.find(params[:id])
    @order_details.orders_status=params[:order_status]
    @order_details.save
    flash[:notice] = 'Order Status was successfully updated.'
    redirect_to :action => 'order_view' , :id => params[:id]
  end

  #My Customners
  def my_customers

    @empid=EmployeAccount.find(:first, :conditions => "id=#{params[:studioid]}")
    if(@empid.id>0)
      @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and emp_id=#{@empid.id}")
      @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and emp_id=#{@empid.id}")
      sort_init 'id'
      sort_update
      srk=params[:sort_key]
      sort="#{srk}  #{params[:sort_order]}"

      if( srk==nil)
        sort="id  desc"
      end
      @hmm_users  = HmmUser.paginate :per_page => 10, :page => params[:page],:order =>sort,:conditions => "emp_id=#{@empid.id}"

      render :layout => true
    end
  end

  def mycustomer_search
    sort_init 'id'
    sort_update
    @empid=EmployeAccount.find(:first, :conditions => "id=#{params[:studioid]}")
    if(@empid.id>0)
      @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and emp_id=#{@empid.id} ")
      @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and emp_id=#{@empid.id}")

      if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
      else
        @uname=params[:username]
        if(@uname!="" && params[:username]!=nil)
          usernamecondition="and v_user_name like '#{@uname}%' "
        end

        @email=params[:email]
        if(@email!="" && params[:email]!=nil)
          emailcondition="and v_e_mail like '#{@email}%' "
        end

        @acc_type=params[:account_type]
        if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
          acc_typecondition="and account_type='#{@acc_type}' "
        end

        @email=params[:email]
        if(@email!="" && params[:email]!=nil)
          emailcondition="and v_e_mail like '#{@email}%' "
        end

        @fname=params[:firstname]
        if(@fname!="" && params[:firstname]!=nil)
          firstnamenamecondition="and v_fname like '#{@fname}%' "
        end
        @lname=params[:lastname]
        if(@lname!="" && params[:lastname]!=nil)
          lastnamecondition="and v_lname like '#{@lname}%' "
        end

        @country=params[:v_country]
        @zip=params[:zip]

        if(@country=='USA' && params[:v_country]!=nil)
          if( @zip!="" && params[:zip]!=nil)
            countrycond="and v_zip='#{@zip}'"
          end
        else
          if( @zip!="" && params[:zip]!=nil)
            countrycond="and v_city like '#{@zip}%' "
          end
        end

      end

      if params[:sort_key]==nil && params[:sort_order]==nil
        @srk="id  desc"
      else

        @sort_key=params[:sort_key]



        @order=params[:sort_order]
      end
      puts @sort_key
      puts @order
      @srk="#{@sort_key}"+" "+"#{@order}"
      if( @srk==nil || @srk=="" )
        @srk="id  desc"
      end
      puts @srk

      @hmm_users = (HmmUser.paginate  :per_page => 10, :page => params[:page], :conditions =>"id!='' and emp_id=#{session[:employe]} #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}", :order =>  @srk )

      render :layout => true
    end
  end

  def create_account

  end

  def change_password

    @cnt=HmmStudiogroup.count(:all,:conditions=>"password='#{params[:oldpassword]}' and id=#{params[:id]}")

    if(@cnt>0)

      @sg=HmmStudiogroup.find(params[:id])
      @sg['password']=params[:confirm_password]
      @sg.save
      flash[:notice] = 'Password successfully updated.'
      redirect_to :action => 'studiogroup_changepassword'
    else
      flash[:notice] = 'Current Password is Incorrect'
      redirect_to :action => 'studiogroup_changepassword'
    end

  end

  def update_profile

    @sg=HmmStudiogroup.find(params[:id])
    @sg['hmm_franchise_studio']=params[:company_name]
    @sg['contact_email']=params[:contact_email]
    @sg.save
    flash[:notice] = 'Profile successfully updated.'
    redirect_to :action => 'studiogroup_editprofile'


  end

  #Studio License Agreement
  def license_form

  end

  def pay_form

    @states=State.find(:all)
    session[:license_info]=params[:license_info]
    session[:license_date]=params[:license_date]
    session[:license_licensor]=params[:license_licensor]
    session[:license_studio]=params[:license_studio]
    session[:license_location]=params[:license_location]
    session[:licensor_address]=params[:licensor_address]
    session[:licensor_attn]=params[:licensor_attn]
    session[:licensor_attn1]=params[:licensor_attn1]
    session[:licensor_attn2]=params[:licensor_attn2]
    session[:licensor_fax]=params[:licensor_fax]
    session[:licensor_studio]=params[:licensor_studio]
    session[:licensor_studio_by]=params[:licensor_studio_by]
    session[:licensor_studio_title]=params[:licensor_studio_title]

    if(params[:act]!=nil && params[:act]!='')
      redirect_to '/hmm_studiogroups/enter_promocode'
    end
    if(params[:dis]!=nil && params[:dis]!='')
      redirect_to '/hmm_studiogroups/enter_discountcode'
    end

  end

  def process_payment

    card_no=params[:card_no]
    cvv_no=params[:cardcvv_no]
    exp_month=params[:exp_month]
    exp_year=params[:exp_year]
    fname=params[:bfname]
    lname=params[:blname]
    street_address = params[:street_address]
    postcode = params[:postcode]
    city = params[:city]
    state = params[:state]
    country = params[:country]
    telephone = params[:telephone]
    email = params[:email]
    amt= Float(params[:amt])

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

      flash[:message] ="Creditcard Info saved!"

      gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(:test => false, :login => "8GxD65y84", :password=> "89j6d34cW8CKhp9S")
      amount_to_charge = amt * 100  #1000 = ten US dollars
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
          :name     => "#{fname} lname",
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

        @lic=StudioOwnerLicense.new
        @lic.owner_id=session[:franchise]
        @lic.license_info=session[:license_info]
        @lic.license_date=session[:license_date]
        @lic.license_licensor=session[:license_licensor]
        @lic.license_studio=session[:license_studio]
        @lic.license_location=session[:license_location]
        @lic.licensor_address=session[:licensor_address]
        @lic.licensor_attn=session[:licensor_attn]
        @lic.licensor_attn1=session[:licensor_attn1]
        @lic.licensor_attn2=session[:licensor_attn2]
        @lic.licensor_fax=session[:licensor_fax]
        @lic.licensor_studio=session[:licensor_studio]
        @lic.licensor_studio_by=session[:licensor_studio_by]
        @lic.licensor_studio_title=session[:licensor_studio_title]
        @lic.billing_fname=params[:bfname]
        @lic.billing_lname=params[:blname]
        @lic.billing_address=params[:street_address]
        @lic.billing_city=params[:city]
        @lic.billing_state=params[:state]
        @lic.billing_zip=params[:postcode]
        @lic.billing_country=params[:country]
        @lic.billing_phone=params[:telephone]
        @lic.billing_email=params[:email]
        @lic.menu_show=1
        @lic.save

        @studiogroupdet=HmmStudiogroup.find(session[:franchise])

        Postoffice.deliver_licensepass(@studiogroupdet.hmm_franchise_studio)

        session[:license_info]=""
        session[:license_date]=""
        session[:license_licensor]=""
        session[:license_studio]=""
        session[:license_location]=""
        session[:licensor_address]=""
        session[:licensor_attn]=""
        session[:licensor_attn1]=""
        session[:licensor_attn2]=""
        session[:licensor_fax]=""
        session[:licensor_studio]=""
        session[:licensor_studio_by]=""
        session[:licensor_studio_title]=""

        flash[:success] = response.message
        redirect_to "/hmm_studiogroups/pay_success/#{@lic.id}"


      else
        flash[:error] = "Transaction has been declined, below is the reason from authorize.net<br>"+response.message
        redirect_to "/hmm_studiogroups/pay_form/"
      end
    else
      flash[:error] = "Error in credit card info! this error is from our website so the reason is invalid information added as wrong count of credit card numbers or cvv number is alphanumeric etc"
      redirect_to "/hmm_studiogroups/pay_form/"
    end
  end

  def pay_success
    @licdet=StudioOwnerLicense.find(:first,:conditions=>"owner_id=#{session[:franchise]}")
  end

  def license_details
    @licdet=StudioOwnerLicense.find(:first,:conditions=>"owner_id=#{session[:franchise]}")
  end

  def print_license_details
    @licdet=StudioOwnerLicense.find(:first,:conditions=>"owner_id=#{session[:franchise]}")
    render :layout => false
  end

  def promocode_form
    @promocodes = PromoCode.paginate :per_page => 10, :page => params[:page],:order =>"id desc"

  end

  def promocode_form1
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="promocodesreport.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end
    @promocodes = PromoCode.find(:all,:conditions=>"code_type='promo'",:order=>"id desc")
    render :layout => false

  end

  def discount_code_excel
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="discountcodesreport.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end
    @promocodes = PromoCode.find(:all,:conditions=>"code_type='discount'",:order=>"id desc")
    render :layout => false
  end


  def gen_promocode

    #case1

    #    i=001
    #    while i<=250
    #      @coupon=PromoCode.new()
    #      if(i<=9)
    #      @coupon['promocode'] ="ImagingUSA00#{i}"
    #      end
    #      if(i>=10 && i<=99)
    #      @coupon['promocode'] ="ImagingUSA0#{i}"
    #      end
    #      if(i>=100)
    #      @coupon['promocode'] ="ImagingUSA#{i}"
    #      end
    #      @coupon.save
    #      i=i+1
    #    end

    #case2
    @start=Integer(params[:start_range])
    @end=Integer(params[:end_range])
    @title=params[:title]

    if(params[:start_range]=="0001")
      @z3="000"
      @z2="00"
      @z1="0"
    elsif (params[:start_range]=="001")
      @z3="00"
      @z2="0"
      @z1=""
    else
      @z3=""
      @z2=""
      @z1=""
    end

    i=@start
    while i<=@end
      @coupon=PromoCode.new()

      @couponcnt=PromoCode.count(:all,:conditions=>"promocode='#{@title}#{@z3}#{i}' or  promocode='#{@title}#{@z2}#{i}' or promocode='#{@title}#{@z1}#{i}'" )

      if(@couponcnt==0)

        #case1
        if(i<=9)
          @coupon['promocode'] ="#{@title}#{@z3}#{i}"
        end
        if(i>=10 && i<=99)
          @coupon['promocode'] ="#{@title}#{@z2}#{i}"
        end
        if(i>=100 && i<=999)
          @coupon['promocode'] ="#{@title}#{@z1}#{i}"
        end

        if(i>=1000)
          @coupon['promocode'] ="#{@title}#{i}"
        end
        @coupon['code_type']="#{params[:code_type]}"
        @coupon['amt']="#{params[:amount]}"
        @coupon.save

      end
      i=i+1
    end

    flash[:promomsg]="Promo Codes Generated Successfully"
    redirect_to "/hmm_studiogroups/promocode_form"


    # case3
    # i=1001
    #    while i<=1500
    #     @coupon=PromoCode.new()
    #     @coupon['promocode'] ="WPP#{i}"
    #     @coupon.save
    #     i=i+1
    #    end

  end

  def enter_promocode

  end

  def enter_discountcode

  end

  def submit_discountcode
    @promo=PromoCode.count(:all,:conditions=>"promocode='#{params[:promocode]}' and used='0' and code_type='discount'")
    if(@promo>0)

      @promo_det=PromoCode.find(:first,:conditions=>"promocode='#{params[:promocode]}' and used='0' and code_type='discount'")

      @promo_updt=PromoCode.find(@promo_det.id)
      @promo_updt['used']=1
      @promo_updt.save


      redirect_to "/hmm_studiogroups/pay_discountform/#{@promo_det.id}"

    else
      flash[:promomsg]="Invalid Discount Code / Discount Code is Already Used"
      redirect_to "/hmm_studiogroups/enter_discountcode"
    end

  end


  def pay_discountform

    @states=State.find(:all)
    @promocode=PromoCode.find(params[:id])

  end


  def process_discountpayment

    @promocode=PromoCode.find(params[:pid])

    card_no=params[:card_no]
    cvv_no=params[:cardcvv_no]
    exp_month=params[:exp_month]
    exp_year=params[:exp_year]
    fname=params[:bfname]
    lname=params[:blname]
    street_address = params[:street_address]
    postcode = params[:postcode]
    city = params[:city]
    state = params[:state]
    country = params[:country]
    telephone = params[:telephone]
    email = params[:email]
    amt= Float(295.00)-Float(@promocode.amt)

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

      flash[:message] ="Creditcard Info saved!"

      gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(:test => false, :login => "8GxD65y84", :password=> "89j6d34cW8CKhp9S")
      #amount_to_charge = Money.ca_dollar(amt) #1000 = ten US dollars
      amount_to_charge = amt * 100  #1000 = ten US dollars
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
          :name     => "#{fname} lname",
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

        @lic=StudioOwnerLicense.new
        @lic.owner_id=session[:franchise]
        @lic.license_info=session[:license_info]
        @lic.license_date=session[:license_date]
        @lic.license_licensor=session[:license_licensor]
        @lic.license_studio=session[:license_studio]
        @lic.license_location=session[:license_location]
        @lic.licensor_address=session[:licensor_address]
        @lic.licensor_attn=session[:licensor_attn]
        @lic.licensor_attn1=session[:licensor_attn1]
        @lic.licensor_attn2=session[:licensor_attn2]
        @lic.licensor_fax=session[:licensor_fax]
        @lic.licensor_studio=session[:licensor_studio]
        @lic.licensor_studio_by=session[:licensor_studio_by]
        @lic.licensor_studio_title=session[:licensor_studio_title]
        @lic.billing_fname=params[:bfname]
        @lic.billing_lname=params[:blname]
        @lic.billing_address=params[:street_address]
        @lic.billing_city=params[:city]
        @lic.billing_state=params[:state]
        @lic.billing_zip=params[:postcode]
        @lic.billing_country=params[:country]
        @lic.billing_phone=params[:telephone]
        @lic.billing_email=params[:email]
        @lic.promocode=@promocode.promocode
        @lic.code_type="discount"
        @lic.menu_show=1
        @lic.save

        @studiogroupdet=HmmStudiogroup.find(session[:franchise])

        Postoffice.deliver_licensepass(@studiogroupdet.hmm_franchise_studio)

        session[:license_info]=""
        session[:license_date]=""
        session[:license_licensor]=""
        session[:license_studio]=""
        session[:license_location]=""
        session[:licensor_address]=""
        session[:licensor_attn]=""
        session[:licensor_attn1]=""
        session[:licensor_attn2]=""
        session[:licensor_fax]=""
        session[:licensor_studio]=""
        session[:licensor_studio_by]=""
        session[:licensor_studio_title]=""

        flash[:success] = response.message
        redirect_to "/hmm_studiogroups/pay_success/#{@lic.id}"


      else
        flash[:error] = "Transaction has been declined, below is the reason from authorize.net<br>"+response.message
        redirect_to "/hmm_studiogroups/pay_discountform/#{params[:pid]}"
      end
    else
      flash[:error] = "Error in credit card info! this error is from our website so the reason is invalid information added as wrong count of credit card numbers or cvv number is alphanumeric etc"
      redirect_to "/hmm_studiogroups/pay_discountform/#{params[:pid]}"
    end
  end


















  def submit_promocode
    @promo=PromoCode.count(:all,:conditions=>"promocode='#{params[:promocode]}' and used='0' and code_type='promo'")
    if(@promo>0)

      @promo_det=PromoCode.find(:first,:conditions=>"promocode='#{params[:promocode]}' and used='0' and code_type='promo'")

      @promo_updt=PromoCode.find(@promo_det.id)
      @promo_updt['used']=1
      @promo_updt.save

      @lic=StudioOwnerLicense.new
      @lic.owner_id=session[:franchise]
      @lic.license_info=session[:license_info]
      @lic.license_date=session[:license_date]
      @lic.license_licensor=session[:license_licensor]
      @lic.license_studio=session[:license_studio]
      @lic.license_location=session[:license_location]
      @lic.licensor_address=session[:licensor_address]
      @lic.licensor_attn=session[:licensor_attn]
      @lic.licensor_attn1=session[:licensor_attn1]
      @lic.licensor_attn2=session[:licensor_attn2]
      @lic.licensor_fax=session[:licensor_fax]
      @lic.licensor_studio=session[:licensor_studio]
      @lic.licensor_studio_by=session[:licensor_studio_by]
      @lic.licensor_studio_title=session[:licensor_studio_title]
      @lic.menu_show=1
      @lic.promocode=params[:promocode]
      @lic.code_type="promo"
      @lic.save

      @studiogroupdet=HmmStudiogroup.find(session[:franchise])

      Postoffice.deliver_licensepass(@studiogroupdet.hmm_franchise_studio)

      session[:license_info]=""
      session[:license_date]=""
      session[:license_licensor]=""
      session[:license_studio]=""
      session[:license_location]=""
      session[:licensor_address]=""
      session[:licensor_attn]=""
      session[:licensor_attn1]=""
      session[:licensor_attn2]=""
      session[:licensor_fax]=""
      session[:licensor_studio]=""
      session[:licensor_studio_by]=""
      session[:licensor_studio_title]=""

      flash[:success] = "Activated with Promo Code Successfully"
      redirect_to "/hmm_studiogroups/pay_success/#{@lic.id}"

    else
      flash[:promomsg]="Invalid Promo Code / Promo Code is Already Used"
      redirect_to "/hmm_studiogroups/enter_promocode"
    end

  end


  #Studio Group Deletion


  def studiogroup_delete

    if(params[:id]!='' && params[:id]!=nil)

      @stdgrp=HmmStudiogroup.find(params[:id])
      @stdgrp['status']='inactive'
      @stdgrp.save

      @studios=HmmStudio.find(:all , :conditions=>"studio_groupid=#{params[:id]}")
      for k in @studios
        @studio=HmmStudio.find(k.id)
        @studio['status']='inactive'
        @studio.save
      end
      flash[:msg]="Studio Group deleted successfully"
      redirect_to "/account/list_hmmgroup"
    else
      flash[:msg]="Studio Group Deletion failed"
      redirect_to "/account/list_hmmgroup"
    end

  end

  def studiogroup_assign_form
    if(params[:id]!='' && params[:id]!=nil)
      @stdgrp=HmmStudiogroup.find(params[:id])
      @hmm_studios=HmmStudio.find(:all,:conditions=>"studio_groupid=#{params[:id]}")
      @hmm_studiogroups=HmmStudiogroup.find(:all,:conditions=>"id!=#{params[:id]} and status='active'")
    end
  end

  def studiogroup_assign

    if(params[:old_studiogroup_id]!='' && params[:old_studiogroup_id]!=nil && params[:new_studiogroup_id]!='' && params[:new_studiogroup_id]!=nil)

      @studios=HmmStudio.find(:all , :conditions=>"studio_groupid=#{params[:old_studiogroup_id]}")
      for k in @studios
        @studio=HmmStudio.find(k.id)
        @studio['studio_groupid']=params[:new_studiogroup_id]
        @studio.save
      end

      @stdgrp=HmmStudiogroup.find(params[:old_studiogroup_id])
      @stdgrp['status']='inactive'
      @stdgrp.save

      flash[:msg]="New Studio Group Assigned to studios successfully"
      redirect_to "/account/list_hmmgroup"
    else
      flash[:msg]="Studio Group Assign failed"
      redirect_to "/account/list_hmmgroup"
    end

  end

  #studio management customers
  def studio_management_customers
    sort_init 'id'
    sort_update
    hmmstudios=HmmStudio.find(:all,:select =>"id",:conditions =>"studio_groupid='#{session[:franchise]}'")
    studio_list = "0"
    for hmmstudio in hmmstudios
      studio_list= "#{studio_list},#{hmmstudio.id}"
    end
    studio_list= "#{studio_list},0"
    if(params[:username]==nil && params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
    else
      @uname=params[:username]
      if(@uname!="" && params[:username]!=nil)
        params[:username] = (params[:username].gsub("'","")).gsub('"',"")
        usernamecondition="and v_user_name like '#{params[:username]}%' "
      end

      @email=params[:email]
      if(@email!="" && params[:email]!=nil)
        params[:email] = (params[:email].gsub("'","")).gsub('"',"")
        emailcondition="and v_e_mail like '#{params[:email]}%' "
      end

      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end

      @email=params[:email]
      if(@email!="" && params[:email]!=nil)
        params[:email] = (params[:email].gsub("'","")).gsub('"',"")
        emailcondition="and v_e_mail like '#{params[:email]}%' "
      end

      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        params[:firstname] = (params[:firstname].gsub("'","")).gsub('"',"")
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && params[:lastname]!=nil)
        params[:lastname] = (params[:lastname].gsub("'","")).gsub('"',"")
        lastnamecondition="and v_lname like '#{@lname}%' "
      end

      @country=params[:v_country]
      @zip=params[:zip]

      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end

    end

    if params[:sort_key]==nil && params[:sort_order]==nil
      @srk="id  desc"
    else
      @sort_key=params[:sort_key]
      @order=params[:sort_order]
    end
    puts @sort_key
    puts @order
    @srk="#{@sort_key}"+" "+"#{@order}"
    if( @srk==nil || @srk=="" )
      @srk="id  desc"
    end
    puts @srk
    #@hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and studio_id=#{@employee.store_id} #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}")
    #@hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and studio_id=#{@employee.store_id}  #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}")


    @hmmuser_blockcnt = HmmUser.count(:all, :conditions => "e_user_status='blocked' and old_studio_id in (#{studio_list}) #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}")
    @hmmuser_unblockcnt = HmmUser.count(:all, :conditions => "e_user_status='unblocked' and old_studio_id in (#{studio_list})  #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}")


    sort_init 'id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="id  desc"
    end

    #@hmm_users = HmmUser.paginate :per_page => 10, :page => params[:page], :select => "*", :conditions => "studio_id=#{@employee.store_id} #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}", :order => sort
    logger.info("Studio list=> #{studio_list}")
    @hmm_users = HmmUser.paginate :per_page => 10, :page => params[:page], :select => "*", :conditions => " old_studio_id in (#{studio_list}) #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition} #{emailcondition}", :order => sort


    render :layout => true
  end
  def reassign_notes

    if params[:sub]

      @hmmuser=HmmUser.find(params[:user_id])
      @hmmuser['studio_manager_notes']=params[:notes]
      @hmmuser['studio_id']=@hmmuser.old_studio_id
      @hmmuser['emp_id']=@hmmuser.old_emp_id
      @hmmuser['old_studio_id']=''
      @hmmuser.save

      flash[:error] = "Account Reassigned Successfully"

      redirect_to "/hmm_studiogroups/studio_management_customers"



    end
  end

  def manage_studio_logo
    studios=HmmStudio.find(:first, :conditions => "studio_groupid = '#{session[:franchise]}'")
    @studio=IphoneAboutusStudioLogo.find_by_studio_id(studios.id)
    @employee =HmmStudiogroup.find(:first,:conditions=>"id='#{session[:franchise]}'")
  end

  def manage_app_name
    if params[:sub]
      @studio_groups=HmmStudio.find(:all, :conditions => "studio_groupid = '#{session[:franchise]}'")
      for @studio_group in @studio_groups
        @studio=HmmStudio.find(:first,:conditions=>"id=#{@studio_group.id}")
        @studio.iphone_app_name=params[:app_name]
        @studio.iphone_app_full_name=params[:iphone_app_full_name]
        @studio.save
      end
    else
      @studio=HmmStudio.find(:first, :conditions => "studio_groupid = '#{session[:franchise]}'")
    end
  end

  def manage_app_store_description
    if params[:sub]
      @studio_groups=HmmStudio.find(:all, :conditions => "studio_groupid = '#{session[:franchise]}'")
      for @studio_group in @studio_groups
        @studio=HmmStudio.find(:first,:conditions=>"id=#{@studio_group.id}")
        @studio.app_store_description=params[:app_store_description]
        @studio.save
      end
    else
      @studio=HmmStudio.find(:first, :conditions => "studio_groupid = '#{session[:franchise]}'")
    end
  end
  
  protected
  def ssl_required?
    true
  end
end