class CartsController < ApplicationController

  #layout "ecommerce"

  layout :v2_v4

  require 'money'
  require 'active_merchant'
  include ApplicationHelper
  helper :user_account
  include UserAccountHelper

  before_filter :check_account, :only => [  :cart_list, :update_cart, :clear_cart, :delete_item_cart, :billing_process, :process_payment, :payment_complete,:payment_complete2, :print_order, :shipping,:add_shipping,:edit_shipping,:update_shipping,:order_receipt]

  def v2_v4
    if params[:v]=='v4'
      return "family_memory"
    else
      return  "familywebsite"
    end
  end

  def initialize()
    #@current_page = 'manage my site'
    @hide_float_menu = true
  end
  #method to check whether the family name in the url is valid or invalid
  #if family name doesn't exist, redirects to hmm home page
  #if user is blocked, displays message
  #if user didn't agee for terms of use,
  # => if the user is not logged in, takes to login page
  # => if the user is logged in, takes to agree terms page
  def check_account
    unless params[:id].blank?
      @family_website_owner = HmmUser.find(:first,:joins =>"INNER JOIN themes on hmm_users.theme_id=themes.id", :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')",:select => "hmm_users.*,themes.stylesheet as theme") #get the user details
      if @family_website_owner
        if(session[:employe]==nil && @family_website_owner.terms_checked == 'false' ) #if the logged in user is not employee and terms is not agreed
          flash[:terms] = 'terms'
          if(session[:hmm_user]) #f the user is logged in, takes to agree terms page
            redirect_to "/user_account/update_terms/"
          else #if the user is not logged in, takes to login page
            redirect_to "/familywebsite/login/#{params[:id]}" if params[:action]!='login'
          end
        elsif @family_website_owner.e_user_status=='blocked' #displays message, if the user is blocked
          render :text => "This Familywebsite has been Blocked. Please contact Website Administrator at <a href='mailto:admin@holdmymemories.com' >admin@HoldMyMemories.com</a>"
        elsif session[:visitor]==nil && session[:hmm_user]==nil && @family_website_owner.password_required == 'yes'
          #render :text =>"Password protected. Redirect to family website login page"
          redirect_to :controller =>"familywebsite", :action => 'visitor_login', :id => params[:id], :redirect_url => request.url if (params[:action]!='login' && params[:action]!='visitor_login')
        elsif !session[:hmm_user] || logged_in_hmm_user.id!=@family_website_owner.id
          redirect_to "/familywebsite/login/#{params[:id]}"
        else
          @path = ContentPath.find(:first, :conditions => "status='active'")
          @content_server_url = @path.content_path
          @content_server_name = @path.proxyname
          return true #returns true if all the conditions are cleared
        end
      else
        redirect_to '/'
      end
    end
  end

  def authenticate
    unless session[:hmm_user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "/user_account/login"
      return false
    end
  end

=begin
  def cart_list_old

    @url=@content_server_name.split("/")
    if @url[2]=="holdmymemories.com"
      @secure_url="https://#{@url[2]}"
    else
      @secure_url="http://#{@url[2]}"
    end
    @cart_items = Array.new
    # User's Shipping Information
    @shipping_address = ShippingInformation.find(:first,:joins => "INNER JOIN states ON states.id = shipping_informations.state",
      :conditions=>"user_id='#{session[:hmm_user]}'", :select => "shipping_informations.*,states.state as state_name")

    if @shipping_address
      shipping_state_id = @shipping_address.state
    else
      shipping_state_id = nil
    end

    studios = Cart.find(:all, :select => "DISTINCT(carts.studio_id)", :conditions => "carts.user_id=#{@family_website_owner.id}
    and carts.status='cart'")
    for studio in studios
      studio_id = studio.studio_id

      #Shopping cart details
      items = Cart.find(:all,:joins=>" as carts,user_contents as a ,print_size_prices as b, print_sizes as c",
        :conditions => "carts.size_id=b.id and carts.user_content_id=a.id and carts.user_id=#{@family_website_owner.id}
    and carts.status='cart' and carts.studio_id = #{studio_id} and b.print_size_id = c.id",
        :select => "carts.*,carts.id as cid ,a.*,b.*,c.id as size_id,c.label",:order=>"carts.order_num asc")
      # shipping
      #shipping_methods = Array.new
      shipping_methods = ShippingMethod.find(:all,:conditions=>"studio_id=#{studio_id}",:order=>"id")

      # Sales tax
      if studio.studio_id == 0
        sales_tax =Configuration.find(:first,:conditions =>"configuration_option='HMM_SALES_TAX'")
        studio_sales_tax = Float(sales_tax.configuration_value)
        processed_by = 'HMM'
        studio_state_id = 43
      else
        hmm_studios=HmmStudio.find(:first,:conditions => "id=#{studio.studio_id}",:select => "state_id,tax_rate,studio_name" )
        processed_by = hmm_studios.studio_name
        studio_state_id = hmm_studios.state_id
        if hmm_studios.tax_rate == 0.00
          sales_tax = Configuration.find(:first,:conditions =>"configuration_option='HMM_SALES_TAX'")
          studio_sales_tax = Float(sales_tax.configuration_value)
        else
          studio_sales_tax = hmm_studios.tax_rate
        end
      end

      cart_items = Hash.new()
      cart_items ={:items => items, :shipping_methods => shipping_methods, :studio_sales_tax => studio_sales_tax, :studio_id => studio_id, :studio_state_id => studio_state_id, :shipping_state_id => shipping_state_id, :processed_by => processed_by}
      @cart_items.push(cart_items)
    end

  end
=end

  def cart_list

    #logger.info("HIGH RES :#{high_resoltuion}")
    #logger.info("LOW RES :#{low_resoltuion}")
    session[:credit_amount] =nil
    @Contents = UserContent.find(:first, :conditions => "e_filetype= 'image' and status='active' and e_access='public' and uid=#{@family_website_owner.id}",:group => "id", :order=>"sub_chapid desc")
    @url=@content_server_name.split("/")
    if @url[2]=="holdmymemories.com"
      @secure_url="https://#{@url[2]}"
    else
      @secure_url="http://#{@url[2]}"
    end
    @cart_items = Array.new
    # User's Shipping Information
    @shipping_address_count = ShippingInformation.count(:all,:conditions=>"user_id='#{session[:hmm_user]}'")
    if(@shipping_address_count > 0)
      @shipping_address = ShippingInformation.find(:first,:joins => "INNER JOIN states ON states.id = shipping_informations.state",
        :conditions=>"user_id='#{session[:hmm_user]}'", :select => "shipping_informations.*,states.state as state_name")

      if @shipping_address
        shipping_state_id = @shipping_address.state
      else
        shipping_state_id = nil
      end

      @studio_groups=HmmUser.find(:first,:select => "a.*,b.*,c.*,d.* ", :joins =>"as a ,employe_accounts as b,hmm_studios as c,hmm_studiogroups  as d ",:conditions => "a.id=#{@family_website_owner.id} and b.id=a.emp_id and b.store_id=c.id and c.studio_groupid=d.id ")
      @creditpt=CreditPoint.find(:first,:conditions=>"user_id=#{@family_website_owner.id}")
      @cp=CreditPoint.count(:all,:conditions=>"user_id=#{@family_website_owner.id}")
      now = Time.now
      @check_date = now.strftime("%Y-%m-%d")
      unless @studio_groups.blank?
        unless @studio_groups.account_expdate.blank?
          if  @cp == 0 || (@studio_groups.account_expdate < @check_date.to_date )
            @creditpt_count=0
          else
            @creditpt_count=1
          end
        else
          if  @cp == 0
            @creditpt_count=0
          else
            @creditpt_count=1
          end
        end
      end
      logger.info("@creditpt_count")
      logger.info(@creditpt_count)
      studios = Cart.find(:all, :select => "DISTINCT(carts.studio_id)", :conditions => "carts.user_id=#{@family_website_owner.id}
    and carts.status='cart'")
      for studio in studios
        studio_id = studio.studio_id

        #Shopping cart details
        items = Cart.find(:all,:joins=>" as carts,user_contents as a ,print_size_prices as b, print_sizes as c",
          :conditions => "carts.size_id=b.id and carts.user_content_id=a.id and carts.user_id=#{@family_website_owner.id}
    and carts.status='cart' and carts.studio_id = #{studio_id} and b.print_size_id = c.id",
          :select => "carts.*,carts.quantity as qty,carts.id as cid ,a.*,b.*,c.id as size_id,c.label, carts.img_url as itemurl",:order=>"carts.order_num asc")
        # shipping
        #shipping_methods = Array.new
        shipping_methods = ShippingMethod.find(:all,:conditions=>"studio_id=#{studio_id}",:order=>"id")

        # Sales tax
        if studio.studio_id == 0
          sales_tax=StateSalestax.find(:first,:conditions => "state_id=#{shipping_state_id} and order_from='hmm'",:select => "tax_rate" )
          studio_sales_tax=sales_tax.tax_rate
          #sales_tax =Configuration.find(:first,:conditions =>"configuration_option='HMM_SALES_TAX'")
          #studio_sales_tax = Float(sales_tax.configuration_value)
          processed_by = 'HMM'
          studio_state_id = 43
        else
          hmm_studios=HmmStudio.find(:first,:conditions => "id=#{studio.studio_id}",:select => "state_id,studio_name" )
          sales_tax=StateSalestax.find(:first,:conditions => "state_id=#{shipping_state_id} and order_from='others'",:select => "tax_rate" )
          processed_by = hmm_studios.studio_name
          studio_state_id = hmm_studios.state_id
          studio_sales_tax=sales_tax.tax_rate

        end
        cart_items = Hash.new()
        cart_items ={:items => items, :shipping_methods => shipping_methods, :studio_sales_tax => studio_sales_tax, :studio_id => studio_id, :studio_state_id => studio_state_id, :shipping_state_id => shipping_state_id, :processed_by => processed_by}
        @cart_items.push(cart_items)
      end
    end
  end

  def get_studio_shipping
    session[:ship_option] = nil
    @shipping = ShippingMethod.find(:first,:joins=>"as a,shipping_prices as b",
      :conditions=>"a.id=b.method_id and a.studio_id=#{params[:studio_id]} and b.method_id=#{params[:ship_option]} and
b.start_price <= #{params[:subtotal]} and b.end_price >= #{params[:subtotal]}",:select=>"b.ship_price")
    @shipping_price = Float(@shipping.ship_price).round(2)
    @subtotal_digital = params[:subtotal_digital]
    @total = Float(params[:subtotal]) + Float(@subtotal_digital) + @shipping_price
    unless params[:sales_tax]== "0"
      @salestax = (Float(Float(params[:sales_tax])/100))*Float(@total)
      @total = Float(@total)+Float(@salestax).round(2)
    else
      @salestax=0.00
    end

    i=0
    for order in session[:orders]
      if order[:studio_id] == Integer(params[:studio_id])
        session[:grand_total] = (session[:grand_total] - session[:orders][i][:total])+@total
        session[:orders][i][:shipping_price] = @shipping_price
        session[:orders][i][:total] = @total
      end
      i=i+1
    end
    render :layout => false
  end

  def get_discount
    session[:credit_amount] =nil
    if params[:type] == "discount"
      @coupon_details = EcommerceCoupon.find(:first, :select => "a.*", :joins => "as a, ecommerce_coupons_studios as b", :conditions => "a.id = b.ecommerce_coupon_id and b.studio_id = #{params[:studio_id]} and a.coupon_id = '#{params[:coupon_id]}' and a.start_date <= CURDATE() and a.end_date >= CURDATE() and a.status = 'active'" )
      coupon_type=EcommerceCoupon.find(:first,:conditions=>"coupon_id ='#{params[:coupon_id]}'")
      if coupon_type
        if coupon_type.discount_type=='' || coupon_type.discount_type=='percentage'
          @check = EcommerceCoupon.find(:all, :select => "a.id", :joins => "as a, orders as b", :conditions => "a.id = b.ecommerce_coupon_id and a.coupon_id = '#{params[:coupon_id]}' and b.user_id = #{session[:hmm_user]}")
        else
          @check = EcommerceCoupon.find(:all, :select => "a.id", :joins => "as a, orders as b", :conditions => "a.id = b.ecommerce_coupon_id and a.coupon_id = '#{params[:coupon_id]}'  and b.coupon_balance='' and b.user_id = #{session[:hmm_user]}")
        end
      end
      if @coupon_details && @check.length == 0
        @status = "true"
        if @coupon_details.discount_type=="percentage"
          unless @coupon_details.discount_percentage.blank?
            @discount_prints = (Float(Float(@coupon_details.discount_percentage)/100))*Float(params[:subtotal])
            @subtotal = params[:subtotal].to_f - @discount_prints.to_f
            unless params[:subtotal_digital] == "0"
              @discount_digital = (Float(Float(@coupon_details.discount_percentage)/100))*Float(params[:subtotal_digital])
              @subtotal_digital = params[:subtotal_digital].to_f - @discount_digital.to_f
            else
              @discount_digital = 0
              @subtotal_digital = 0.00
            end
            @discount = @discount_prints.to_f + @discount_digital.to_f
          else
            @subtotal = params[:subtotal].to_f
            @subtotal_digital = params[:subtotal_digital].to_f
            @discount = 0.00
          end
          @credit = "percentage"
        else
          @credit = "dollar"
          unless @coupon_details.discount_amount.blank?
            amount_rem =  EcommerceCoupon.find(:first, :select => "b.*", :joins => "as a, ecommerce_coupons_amounts as b", :conditions => "a.id = b.coupon_id and a.coupon_id='#{params[:coupon_id]}'  and b.uid=#{session[:hmm_user]}  and a.start_date <= CURDATE() and a.end_date >= CURDATE() and a.status = 'active'" )
            if amount_rem
              if amount_rem.amount_left!=''
                @balance=amount_rem.amount_left
              else
                @balance = 0
              end
            end
            logger.info("Old:#{@balance}")
            if params[:subtotal]
              subval = params[:subtotal]
            else
              subval = 0
            end

            if params[:subtotal_digital]
              subvaldig = params[:subtotal_digital]
            else
              subvaldig = 0
            end
            logger.info("subtotal_digital:#{subvaldig}")
            coupon_discount_exist=Order.find(:first,:conditions=>"user_id=#{session[:hmm_user]} and ecommerce_coupon_id=#{@coupon_details.id}")
            if coupon_discount_exist
              coupon_discount =0
            else
              coupon_discount =@coupon_details.discount_amount
            end
            session[:subtotal_prints_digital]=Float(subval) +Float(subvaldig)
            if Float(subval) +Float(subvaldig)   < coupon_discount.to_f + @balance.to_f
              @discount = subval.to_f + subvaldig .to_f
              logger.info("Discount is #{@discount}")
              logger.info("dst is #{@balance}")
            else
              @discount = coupon_discount.to_f + @balance.to_f
              logger.info("Discount1 is #{@discount}")
            end

            

            @subtotal = params[:subtotal].to_f   - (coupon_discount.to_f + @balance.to_f)
            if @subtotal < 0
              @balance=@subtotal.abs
              @subtotal = 0
            else
              @balance= 0
            end

            unless params[:subtotal_digital] == "0"
              @subtotal_digital = params[:subtotal_digital].to_f - @balance
              if @subtotal_digital < 0
                @balance=@subtotal_digital.abs
                @subtotal_digital = 0
              else
                @balance= 0
              end
            else
              @subtotal_digital = 0.00
            end
            logger.info("subtotal_digital1:#{@subtotal_digital}")
          else
            @subtotal = params[:subtotal].to_f
            @subtotal_digital = params[:subtotal_digital].to_f
            @discount = 0.00
          end
        end

        if @balance==0 && !amount_rem
        else
          session[:balance_amount]=@balance
        end
        logger.info("bal is #{session[:balance_amount]}")
        i=0
        for order in session[:orders]
          if order[:studio_id] == Integer(params[:studio_id])
            @shipping_price = 0.00
            unless @coupon_details.free_shipping == "false"
              session[:orders][i][:free_shipping] = true
            else
              unless session[:orders][i][:shipping_price].blank?
                @shipping_price = session[:orders][i][:shipping_price]
              end
              session[:orders][i][:free_shipping] = false
            end
            unless params[:sales_tax]== "0"
              if @coupon_details.discount_type=="percentage"
                @tax_per = @coupon_details.discount_percentage
              else
                @tax_per = @coupon_details.discount_amount
              end
              @salestax = (Float(Float(params[:sales_tax])/100))*Float(@subtotal + @subtotal_digital + @shipping_price)
            else
              if @coupon_details.discount_type=="percentage"
                @tax_per = @coupon_details.discount_percentage
              else
                @tax_per = @coupon_details.discount_amount
              end
              @salestax = 0.00
            end
            @display_amt = @total = Float(@subtotal) + Float(@subtotal_digital)+ Float(@shipping_price) + Float(@salestax).round(2)
            session[:orders][i][:subtotal] = @subtotal
            session[:orders][i][:subtotal_digital] = @subtotal_digital
            session[:orders][i][:shipping_price] = @shipping_price
            session[:orders][i][:sales_tax] = @salestax
            session[:orders][i][:ecommerce_coupon_id] = @coupon_details.id
            session[:orders][i][:discount_price] = @discount
            session[:orders][i][:total] = @total
            session[:grand_total] = (session[:grand_total] - session[:orders][i][:total])+@total
          end
          i=i+1
        end
      else
        @status = "fail"
        @subtotal = params[:subtotal].to_f
        @subtotal_digital = params[:subtotal_digital].to_f
        @discount = 0
        i=0
        for order in session[:orders]
          if order[:studio_id] == Integer(params[:studio_id])

            if session[:orders][i][:shipping_price]
              @shipping_price = session[:orders][i][:shipping_price]
            else
              @shipping_price = 0.00
            end
            unless params[:sales_tax]== "0"
              @tax_per = params[:sales_tax]
              @salestax = (Float(Float(params[:sales_tax])/100))*Float(@subtotal + @subtotal_digital + @shipping_price)
            else
              @tax_per = params[:sales_tax]
              @salestax = 0.00
            end
            @total = Float(@subtotal + @subtotal_digital)+ Float(@shipping_price) + Float(@salestax).round(2)
            @display_amt = @total
          end
          i=i+1
        end
      end
      session[:grand_total] = @total
      render :layout => false
      return session[:grand_total]
    else
      @status = "true"

    
      @subtotal_digital = params[:subtotal_digital].to_f
      @subtotal = params[:subtotal].to_f
    
      @credit = "credit"
      session[:credit_amount] = params[:coupon_id].to_f
      i=0
      @totalorderprice = 0
      for order in session[:orders]
        if order[:studio_id] == Integer(params[:studio_id])
          if session[:orders][i][:shipping_price]
            if (@subtotal + @subtotal_digital > session[:credit_amount])
              shipping_methods = ShippingMethod.find(:all,:conditions=>"studio_id=#{params[:studio_id].to_i}",:order=>"id")
              if  shipping_methods.length > 0
                if params[:subtotal].to_f > params[:coupon_id].to_f
                  @shipping_prices = ShippingMethod.find(:first,:joins=>"as a,shipping_prices as b",
                    :conditions=>"a.id=b.method_id and a.studio_id=#{params[:studio_id]} and b.method_id=#{params[:ship_option]} and
                b.start_price <= #{params[:subtotal].to_f-params[:coupon_id].to_f} and b.end_price >= #{params[:subtotal].to_f-params[:coupon_id].to_f}",:select=>"b.ship_price")
                  @shipping_price =  @shipping_prices.ship_price
                else
                  @shipping_price = 0.00
                end
              else
                @shipping = Configuration.find(:first,:conditions =>"configuration_option='DEFAULT_SHIPPING'")
                @shipping_price = Float(@shipping.configuration_value).round(2)
              end
            else
              @shipping_price = 0.00
            end
          else
            @shipping_price = 0.00
          end
          unless params[:sales_tax]== "0"
            if (@subtotal + @subtotal_digital + @shipping_price.to_f > session[:credit_amount])
              @salestax = (Float(Float( params[:sales_tax])/100))*Float(@subtotal + @subtotal_digital +@shipping_price.to_f  - session[:credit_amount])
            else
              @salestax = 0.00
            end
          else
            @salestax = 0.00
          end

          @total = Float(@subtotal + @subtotal_digital)+ Float(@shipping_price) + Float(@salestax).round(2)
          logger.info "++++++++++++++++++++++"
          logger.info @total.inspect
          @totalorderprice = @totalorderprice + @total
          avail_credit=CreditPoint.find_by_user_id(session[:hmm_user])


          if params[:coupon_id].to_f > @total
            @available_credit= (@totalorderprice - params[:coupon_id].to_f).abs
            @discount = params[:coupon_id].to_f - @available_credit.abs
          else
            @available_credit= avail_credit.available_credits.to_f - params[:coupon_id].to_f
            @discount = params[:coupon_id].to_f
          end

          session[:orders][i][:subtotal] = @subtotal
          session[:orders][i][:subtotal_digital] = @subtotal_digital
          logger.info(@shipping_price)
          session[:orders][i][:shipping_price] = @shipping_price.to_f
          session[:orders][i][:sales_tax] = @salestax
          session[:orders][i][:discount_price] = @discount
          session[:orders][i][:total] = @total
          if @total > avail_credit.available_credits
            session[:orders][i][:total] = @display_amt = @total - avail_credit.available_credits
            session[:orders][i][:credits_ded] = avail_credit.available_credits
          else
            session[:orders][i][:total] = @display_amt = 0
            session[:orders][i][:credits_ded] = @total
          end
          session[:grand_total] = (session[:grand_total] - session[:orders][i][:total])+@total
        end
        i=i+1
      end
      logger.info "-------------------------"
      logger.info @totalorderprice.inspect
      logger.info "-------------------------"


      render :layout => false
      return session[:grand_total]
    end
  end



  def update_cart

    @content =Cart.find(params[:cid])
    @content.quantity=params[:qty]
    @content.save
    if params[:v]=="v4"
      link="?v=v4"
    else
      link=""
    end
    flash[:notice] = "Quantity Updated Successfully"
    redirect_to "/carts/cart_list/#{params[:id]}#{link}"

  end

  def clear_cart
    if(params[:familyname])
      fname=params[:familyname]
    else
      fname=params[:id]
    end

    @userid=HmmUser.find(:all, :conditions => "family_name='#{fname}'")

    sql = ActiveRecord::Base.connection();
    @temp_access_arr = sql.execute("delete from carts where user_id='#{@userid[0]['id']}'") ;
    sql.commit_db_transaction;
    if params[:v]=="v4"
      link="?v=v4"
    else
      link=""
    end
    redirect_to "/carts/cart_list/#{params[:id]}#{link}"
  end

  def delete_item_cart
    flash[:notice] = "Item Deleted Successfully"
    Cart.find(params[:did]).destroy
    if params[:v]=="v4"
      link="?v=v4"
    else
      link=""
    end
    redirect_to "/carts/cart_list/#{params[:id]}#{link}"
  end


  def billing_process
    @cart_subtotal=0
    @cart_shippingprice = 0
    @cart_salestax = 0
    @cart_total = 0
    @discount = 0
    if session[:orders]
      for order in session[:orders]
        @cart_subtotal = @cart_subtotal + order[:subtotal].to_f + order[:subtotal_digital].to_f
        @cart_shippingprice = @cart_shippingprice + order[:shipping_price]
        @cart_salestax = @cart_salestax + order[:sales_tax]
        @cart_total = @cart_total + order[:total]
        if order[:discount_price] > 0 && session[:credit_amount]
          @discount = @discount + order[:credits_ded]
        end
        logger.info( @cart_total)
      end
      session[:grand_total] = @cart_total
      if session[:credit_amount]
        session[:final_credit_discount] = @discount
      end
    end
    @states=State.find(:all)
    @shipinfo=ShippingInformation.find(:first,:conditions=>"user_id=#{session[:hmm_user]}")

  end


  def process_payment

    @shipinfo=ShippingInformation.find(:first,:conditions=>"user_id=#{session[:hmm_user]}")
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
    email = params[:email]

    session[:fname]=params[:bfname]
    session[:lname]=params[:blname]
    session[:street_address]=street_address
    session[:postcode]= postcode
    session[:city]=city
    session[:state]=state
    session[:country]=country
    session[:telephone]=telephone
    session[:email]=email
    session[:ship_sel]=params[:sel_ship]

    amt = session[:grand_total]
    logger.info(amt)
    logger.info("amt")
    if params[:v]=="v4"
      link="&&v=v4"
      link1="?v=v4"
    else
      link=""
      link1=""
    end
    # this is in the case of grand total is equal to  0
    if session[:grand_total].to_f <= 0.0

      @ship_info=ShippingInformation.find(:first,:conditions=>"user_id='#{session[:hmm_user]}'")
      @ship_info['name']=params[:sfname]
      @ship_info['lname']=params[:slname]
      @ship_info['address']=params[:saddress]
      @ship_info['city']=params[:scity]
      @ship_info['zip']=params[:spostcode]
      @ship_info['state']=params[:sstate]
      @ship_info['country']="United States"
      @ship_info['phno']=params[:stelephone]
      @ship_info['email']=params[:semail]
      @ship_info.save

      orderuuid=Order.find_by_sql("select uuid() as id")
      #increment group id
      @ord=Order.count(:all)
      if(@ord>0)
        @maxgroupid=Order.maximum(:order_group_id)
        @groupid=@maxgroupid+1
      else
        @groupid=1
      end


      if session[:orders] != nil
        orders = session[:orders]
        i=1
        for order in orders
          @new_order = Order.new
          @new_order['order_number'] = "#{orderuuid.id}_#{i}"
          @new_order['user_id'] = session[:hmm_user]
          @new_order['studio_id'] = order[:studio_id]
          @new_order['shipping_method'] = order[:shipping_method]
          @new_order['shipping_price']=Float(order[:shipping_price])
          @new_order['shipping_name']=@ship_info.name
          @new_order['shipping_lname']=@ship_info.lname
          @new_order['shipping_address']=@ship_info.address
          @new_order['shipping_city']=@ship_info.city
          @new_order['shipping_zip']=@ship_info.zip
          @new_order['shipping_state']=@ship_info.state
          @new_order['shipping_country']=@ship_info.country
          @new_order['shipping_phone']=@ship_info.phno
          @new_order['shipping_email']=@ship_info.email
          @new_order['billing_name'] = session[:fname]
          @new_order['billing_lname']= session[:lname]
          @new_order['billing_address']=street_address
          @new_order['billing_city']=city
          @new_order['billing_zip']=postcode
          @new_order['billing_state']=state
          @new_order['billing_country']=country
          @new_order['billing_phone']=telephone
          @new_order['billing_email']=email
          @new_order['payment_method']='authorize'
          @new_order['tax_rate']=Float(order[:sales_tax_rate])
          @new_order['sales_tax']=Float(order[:sales_tax])
          @new_order['total_price']=Float(order[:total])
          @new_order['process_studio_id'] = order[:studio_id]
          @new_order['order_group_id'] = @groupid
          @new_order['ecommerce_coupon_id'] = order[:ecommerce_coupon_id]
          if session[:balance_amount]
            @new_order['coupon_balance'] =session[:balance_amount]
          end
          if session[:final_credit_discount]
            @new_order['discount_price'] = session[:final_credit_discount]
          else
            @new_order['discount_price'] = order[:discount_price]
          end
          if session[:final_credit_discount]
            @new_order['credit_point_amount'] = session[:final_credit_discount]
          end
          @new_order['free_shipping'] = order[:free_shipping]
          if order[:studio_id]

          end
          if @new_order.save
            cart_items = Cart.find(:all,:joins => "as a,print_size_prices as b",:select => "a.*,b.print_size_id", :conditions => "a.user_id='#{logged_in_hmm_user.id}' and a.status = 'cart' and a.studio_id=#{order[:studio_id]} and a.size_id = b.id ")
            digital_sizes=Carts.get_digital_downloads()
            for cart_item in cart_items
              @new_order_product = OrderProduct.new
              @new_order_product['order_id']= @new_order.id
              @new_order_product['user_id']=  cart_item.user_id
              @new_order_product['user_content_id']=  cart_item.user_content_id
              @new_order_product['img_url']= cart_item.img_url
              @new_order_product['original_image']= cart_item.original_image
              @new_order_product['print_image']= cart_item.print_image
              @new_order_product['quantity'] = cart_item.quantity
              @new_order_product['size_id']= cart_item.size_id
              @new_order_product['operations']= cart_item.operations
              @new_order_product['order_num']= cart_item.order_num
              if (Integer(cart_item.print_size_id) == Integer(high_resolution) || Integer(cart_item.print_size_id) == Integer(low_resolution)  || digital_sizes.include?(cart_item.print_size_id.to_i))
                @new_order_product['order_type']= "digital"
              end
              @price = PrintSizePrice.find(:first,:conditions =>"id=#{cart_item.size_id}")
              image_added_date = UserContent.find(:first,:conditions=>"id=#{cart_item.user_content_id}")
              price=Cart.image_price(@family_website_owner.account_type,image_added_date.d_createddate.to_s,@price.pricelt72,@price.price)
              @new_order_product['price']  = price
              if @new_order_product.save
                Cart.delete(cart_item.id)
              end
            end
          end
          i = i+1
        end
        if session[:final_credit_discount]
          credit_point=CreditPoint.find_by_user_id(session[:hmm_user])
          credit_point.available_credits=credit_point.available_credits.to_f - session[:final_credit_discount].to_f
          credit_point.used_credits =	credit_point.used_credits.to_f + session[:final_credit_discount].to_f
          credit_point.save

          user_studio=HmmUser.find(:first,:select=>"studio_id",:conditions=>"id=#{session[:hmm_user]}")
          logs=CreditLog.new
          logs.credit_point_id=credit_point.id
          logs.hmm_studio_id=user_studio.studio_id
          logs.used_credit=session[:final_credit_discount].ceil
          logs.save

        end

        if session[:balance_amount]
          deduct_user_balance(order[:ecommerce_coupon_id])
        end

        session[:orders]=nil
        session[:grand_total]=nil

        session[:fname]=nil
        session[:lname]=nil
        session[:street_address]=nil
        session[:postcode]=nil
        session[:city]=nil
        session[:state]=nil
        session[:country]=nil
        session[:telephone]=nil
        session[:email]=nil
        session[:ship_sel]=nil
        session[:credit_amount]=nil
        session[:final_credit_discount]=nil


        redirect_to "/carts/order_receipt/#{params[:id]}/?order_group=#{@groupid}#{link}"
      end

      # this is in the case of grand total is greater than 0
    else

      creditcard = ActiveMerchant::Billing::CreditCard.new(
        #:type => params[:creditcard][:card_type],
        :number => card_no,
        :month => exp_month,
        :year => exp_year,
        :first_name => fname,
        :last_name => lname,
        :verification_value => cvv_no
      )
      logger.info("amt")
      logger.info(amt)
      logger.info("amt")
      if creditcard.valid?
        # flash[:message] ="Creditcard Info saved!"
        gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(:test => false, :login => "8GxD65y84", :password=> "89j6d34cW8CKhp9S")
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

          @ship_info=ShippingInformation.find(:first,:conditions=>"user_id='#{session[:hmm_user]}'")
          @ship_info['name']=params[:sfname]
          @ship_info['lname']=params[:slname]
          @ship_info['address']=params[:saddress]
          @ship_info['city']=params[:scity]
          @ship_info['zip']=params[:spostcode]
          @ship_info['state']=params[:sstate]
          @ship_info['country']="United States"
          @ship_info['phno']=params[:stelephone]
          @ship_info['email']=params[:semail]
          @ship_info.save

          orderuuid=Order.find_by_sql("select uuid() as id")
          #increment group id
          @ord=Order.count(:all)
          if(@ord>0)
            @maxgroupid=Order.maximum(:order_group_id)
            @groupid=@maxgroupid+1
          else
            @groupid=1
          end


          if session[:orders] != nil
            orders = session[:orders]
            i=1
            for order in orders
              @new_order = Order.new
              @new_order['order_number'] = "#{orderuuid.id}_#{i}"
              @new_order['user_id'] = session[:hmm_user]
              @new_order['studio_id'] = order[:studio_id]
              @new_order['shipping_method'] = order[:shipping_method]
              @new_order['shipping_price']=Float(order[:shipping_price])
              @new_order['shipping_name']=@ship_info.name
              @new_order['shipping_lname']=@ship_info.lname
              @new_order['shipping_address']=@ship_info.address
              @new_order['shipping_city']=@ship_info.city
              @new_order['shipping_zip']=@ship_info.zip
              @new_order['shipping_state']=@ship_info.state
              @new_order['shipping_country']=@ship_info.country
              @new_order['shipping_phone']=@ship_info.phno
              @new_order['shipping_email']=@ship_info.email
              @new_order['billing_name'] = fname
              @new_order['billing_lname']= lname
              @new_order['billing_address']=street_address
              @new_order['billing_city']=city
              @new_order['billing_zip']=postcode
              @new_order['billing_state']=state
              @new_order['billing_country']=country
              @new_order['billing_phone']=telephone
              @new_order['billing_email']=email
              @new_order['payment_method']='authorize'
              @new_order['tax_rate']=Float(order[:sales_tax_rate])
              @new_order['sales_tax']=Float(order[:sales_tax])
              @new_order['total_price']=Float(order[:total])
              @new_order['process_studio_id'] = order[:studio_id]
              @new_order['order_group_id'] = @groupid
              @new_order['ecommerce_coupon_id'] = order[:ecommerce_coupon_id]
              if session[:balance_amount]
                @new_order['coupon_balance'] =session[:balance_amount]
              end
              if session[:final_credit_discount]
                @new_order['discount_price'] = session[:final_credit_discount]
              else
                @new_order['discount_price'] = order[:discount_price]
              end
              if session[:final_credit_discount]
                @new_order['credit_point_amount'] = session[:final_credit_discount]
              end
              @new_order['free_shipping'] = order[:free_shipping]
              if order[:studio_id]

              end
              if @new_order.save
                cart_items = Cart.find(:all,:joins => "as a,print_size_prices as b",:select => "a.*,b.print_size_id", :conditions => "a.user_id='#{logged_in_hmm_user.id}' and a.status = 'cart' and a.studio_id=#{order[:studio_id]} and a.size_id = b.id ")
                digital_sizes=Carts.get_digital_downloads()
                for cart_item in cart_items
                  @new_order_product = OrderProduct.new
                  @new_order_product['order_id']= @new_order.id
                  @new_order_product['user_id']=  cart_item.user_id
                  @new_order_product['user_content_id']=  cart_item.user_content_id
                  @new_order_product['img_url']= cart_item.img_url
                  @new_order_product['original_image']= cart_item.original_image
                  @new_order_product['print_image']= cart_item.print_image
                  @new_order_product['quantity'] = cart_item.quantity
                  @new_order_product['size_id']= cart_item.size_id
                  @new_order_product['operations']= cart_item.operations
                  @new_order_product['order_num']= cart_item.order_num
                  if (Integer(cart_item.print_size_id) == Integer(high_resolution) || Integer(cart_item.print_size_id) == Integer(low_resolution) || digital_sizes.include?(cart_item.print_size_id.to_i))
                    @new_order_product['order_type']= "digital"
                  end
                  @price = PrintSizePrice.find(:first,:conditions =>"id=#{cart_item.size_id}")
                  image_added_date = UserContent.find(:first,:conditions=>"id=#{cart_item.user_content_id}")
                  price=Cart.image_price(@family_website_owner.account_type,image_added_date.d_createddate.to_s,@price.pricelt72,@price.price)
                  @new_order_product['price']  = price
                  if @new_order_product.save
                    Cart.delete(cart_item.id)
                  end
                end
              end
              i = i+1
            end
            if session[:final_credit_discount]
              credit_point=CreditPoint.find_by_user_id(session[:hmm_user])
              credit_point['available_credits']=credit_point['available_credits'].to_f - session[:final_credit_discount].to_f
              credit_point['used_credits'] =	credit_point['used_credits'].to_f + session[:final_credit_discount].to_f
              credit_point.save

              user_studio=HmmUser.find(:first,:select=>"studio_id",:conditions=>"id=#{session[:hmm_user]}")
              logs=CreditLog.new
              logs.credit_point_id=credit_point.id
              logs.hmm_studio_id=user_studio.studio_id
              logs.used_credit=session[:final_credit_discount].ceil
              logs.save
            end

            if session[:balance_amount]
              deduct_user_balance(order[:ecommerce_coupon_id])
            end

            session[:orders]=nil
            session[:grand_total]=nil

            session[:fname]=nil
            session[:lname]=nil
            session[:street_address]=nil
            session[:postcode]=nil
            session[:city]=nil
            session[:state]=nil
            session[:country]=nil
            session[:telephone]=nil
            session[:email]=nil
            session[:ship_sel]=nil
            session[:credit_amount]=nil
            session[:final_credit_discount]=nil

            redirect_to "/carts/order_receipt/#{params[:id]}/?order_group=#{@groupid}#{link}"
          end
        else
          flash[:error] = "Transaction has been declined, below is the reason from authorize.net<br>"+response.message
          #redirect_to "https://holdmymemories.com/carts/billing_process/#{params[:id]}"
          redirect_to "/carts/billing_process/#{params[:id]}#{link1}"
        end
      else
        flash[:error] = "Error in credit card info! this error is from our website so the reason is invalid information added as wrong count of credit card numbers or cvv number is alphanumeric etc"
        #redirect_to "https://holdmymemories.com/carts/billing_process/#{params[:id]}"
        redirect_to "/carts/billing_process/#{params[:id]}#{link1}"
      end
    end

  end


  def deduct_user_balance(coupon_id)
    amount_rem =  EcommerceCoupon.find(:first, :select => "b.*", :joins => "as a, ecommerce_coupons_amounts as b", :conditions => "a.id = b.coupon_id and b.uid=#{session[:hmm_user]} and b.coupon_id='#{coupon_id}'  and a.start_date <= CURDATE() and a.end_date >= CURDATE() and a.status = 'active'" )
    if amount_rem
      balance=EcommerceCouponsAmount.find(:first,:conditions=>"coupon_id='#{coupon_id}' and uid=#{session[:hmm_user]}")
      balance_amount=session[:balance_amount]
      balance.amount_left=balance_amount
      balance.save
    else
      balance=EcommerceCouponsAmount.new
      balance.uid=session[:hmm_user]
      balance.coupon_id=coupon_id
      balance.amount_left= session[:balance_amount]
      balance.save
    end
  end


  def order_receipt
    @Contents = UserContent.find(:first, :conditions => "e_filetype= 'image' and status='active' and e_access='public' and uid=#{@family_website_owner.id}",:group => "id", :order=>"sub_chapid desc")
    unless params[:order_group].blank?
      @orders = Array.new()
      @order_det = Hash.new
      orders = Order.find(:all, :conditions =>"order_group_id = #{params[:order_group]} and user_id=#{session[:hmm_user]}")
      for order in orders
        if order.process_studio_id !=0
          studio_details = HmmStudio.find(order.process_studio_id)
          processed_by = studio_details.studio_name
          studio_email = studio_details.contact_email
        else
          processed_by = "Hmm"
          studio_details = nil
          studio_email = "seth.johnson@holdmymemories.com,bob@s121.com"
        end
        order_products = OrderProduct.find(:all,:conditions=>"order_id='#{order.id}'",:order => "order_num asc")
        @order_det = {:order_details => order, :order_products =>order_products,:studio => studio_details,:processed_by => processed_by}
        @orders.push(@order_det)
        unless studio_email == "" || studio_email == nil
          Postoffice.deliver_neworder_confirmation_studio(@order_det,studio_email)
        end
      end
      @getemail=Order.find(:first, :conditions =>"order_group_id = #{params[:order_group]} and user_id=#{session[:hmm_user]}")
      Postoffice.deliver_neworder_confirmation(@orders,@getemail.billing_email,@getemail.shipping_email)
    else
      redirect_to :controller=>'familywebsite',:action=>"home",:id=>params[:id]
    end

  end

  def payment_complete
    @order_details=Order.find(params[:oid])
    @order_products = OrderProduct.find(:all,:conditions=>"order_id='#{params[:oid]}'",:order => "order_num asc")
    if(@order_details.process_studio_id!=0)
      @studio_details=HmmStudio.find(@order_details.process_studio_id)
    end
    Postoffice.deliver_order_confirmation(@order_details,@order_products,@studio_details)
  end


  def payment_complete2

    #HMM ORDER
    @order_details=Order.find(:first,:conditions=>"id=#{params[:oid]} and process_studio_id=0",:order=>"id desc")
    @order_products = OrderProduct.find(:all,:conditions=>"order_id='#{@order_details.id}'",:order => "order_num asc")
    if(@order_details.process_studio_id!=0)
      @studio_details=HmmStudio.find(@order_details.process_studio_id)
    end
    Postoffice.deliver_order_confirmation(@order_details,@order_products,@studio_details)

    #STUDIO ORDER
    @order_details2=Order.find(:first,:conditions=>"process_studio_id!=0",:order=>"id desc")
    @order_products2 = OrderProduct.find(:all,:conditions=>"order_id='#{@order_details2.id}'",:order => "order_num asc")
    @studio_details2=HmmStudio.find(@order_details2.process_studio_id)

    Postoffice.deliver_order_confirmation(@order_details2,@order_products2,@studio_details2)

  end


  def print_order
    unless params[:order_group].blank?
      @orders = Array.new()
      order_det = Hash.new
      orders = Order.find(:all, :conditions =>"order_group_id = #{params[:order_group]} and user_id=#{session[:hmm_user]}")
      for order in orders
        if order.process_studio_id !=0
          studio_details = HmmStudio.find(order.process_studio_id)
        else
          studio_details = nil
        end
        order_products = OrderProduct.find(:all,:conditions=>"order_id='#{order.id}'",:order => "order_num asc")
        order_det = {:order_details => order, :order_products =>order_products,:studio => studio_details}
        @orders.push(order_det)
      end
    else
      redirect_to :controller=>'familywebsite',:action=>"home",:id=>params[:id]
    end
    #
    #    @order_details=Order.find(params[:oid])
    #    @order_products = OrderProduct.find(:all,:conditions=>"order_id='#{params[:oid]}'",:order => "order_num asc")
    #    if(@order_details.process_studio_id!=0)
    #      @studio_details=HmmStudio.find(@order_details.process_studio_id)
    #    end
    render(:layout => false)
  end

  def print_order2

    #HMM ORDER
    @order_details=Order.find(:first,:conditions=>"id=#{params[:oid]} and process_studio_id=0",:order=>"id desc")
    @order_products = OrderProduct.find(:all,:conditions=>"order_id='#{@order_details.id}'",:order => "order_num asc")
    if(@order_details.process_studio_id!=0)
      @studio_details=HmmStudio.find(@order_details.process_studio_id)
    end

    #STUDIO ORDER
    @order_details2=Order.find(:first,:conditions=>"process_studio_id!=0",:order=>"id desc")
    @order_products2 = OrderProduct.find(:all,:conditions=>"order_id='#{@order_details2.id}'",:order => "order_num asc")
    @studio_details2=HmmStudio.find(@order_details2.process_studio_id)

    render(:layout => false)
  end

  def shipping

    @states=State.find(:all)
    render :layout => false
  end

  def add_shipping
    @ship_info=ShippingInformation.new()
    @ship_info['user_id']=session[:hmm_user]
    @ship_info['name']=params[:fname]
    @ship_info['lname']=params[:lname]
    @ship_info['address']=params[:address]
    @ship_info['city']=params[:city]
    @ship_info['zip']=params[:zip]
    @ship_info['state']=params[:state]
    @ship_info['country']="United States"
    @ship_info['phno']=params[:phno]
    @ship_info['email']=params[:email]

    if @ship_info.save
      flash[:notice] = 'Shipping Address was successfully added.'
      if params[:v]=="v4"
        link="?v=v4"
      else
        link=""
      end
      redirect_to "/carts/cart_list/#{params[:id]}#{link}"
    end
  end

  def edit_shipping

    @states=State.find(:all)
    render :layout => false
  end

  def update_shipping
    @ship_info=ShippingInformation.find(:first,:conditions=>"user_id='#{session[:hmm_user]}'")

    @ship_info['name']=params[:fname]
    @ship_info['lname']=params[:lname]
    @ship_info['address']=params[:address]
    @ship_info['city']=params[:city]
    @ship_info['zip']=params[:zip]
    @ship_info['state']=params[:state]
    @ship_info['country']="United States"
    @ship_info['phno']=params[:phno]
    @ship_info['email']=params[:email]
    if params[:v]=="v4"
      link="?v=v4"
    else
      link=""
    end
    if @ship_info.save
      flash[:notice] = 'Shipping Address was successfully updated.'
      redirect_to "/carts/cart_list/#{params[:id]}#{link}"
    end
  end

  def cvv

    render :layout => false
  end

end