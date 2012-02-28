
class PageController < ApplicationController
	caches_page :index, :gallery, :detail, :menu, :cupcake, :answers, :news_list, :news_detail
	require 'chronic'
	require 'time'

	def index
		@head_tags = "<meta name=\"google-site-verification\" content=\"aWg_FmJR-2_j0M7eiEF7kRty7fa_4CDAvLBaXYFGXz8\" />"
		@dyno_page = DynoPage.find(:first, :conditions => "dyno_type_id = 1 and slug = 'index'" )
	end

  def sessions_clear
    if params[:token] == '9d40xnsv5w'
      Session.clear
      render :text => "Sessions were cleared successfully"
    else
      render :text => "Error in clearing sessions"
    end
	end
  
	def gallery
		@dyno_page = DynoPage.find(:first, :conditions => "dyno_type_id = 1 and slug = 'gallery'" )
	end

	def detail
		@dyno_type = DynoType.find_by_slug( params[:page_type] )
		if not @dyno_type
			render :file => RAILS_ROOT + "/public/404.html", :status => 404
			return
		end
		@dyno_page = @dyno_type.dyno_pages.find_by_slug( params[:page_slug] )
		unless @dyno_page.is_active
			render :file => RAILS_ROOT + "/public/404.html", :status => 404
			return false
		end
		@body_id = @dyno_page.slug
	end
	
	def menu
    @prices = Price.find(:all)
		@days = Day.find(:all, :include => :cupcakes, :order => 'days.id, cupcakes.is_breakfast desc, cupcakes.title')
	end

	def menu_download
		render :file => RAILS_ROOT + "/public/menu_download.html"
		return false
	end

	def cupcake
    
		#if params[:slug] == 'first'
			#@cupcake = Cupcake.find( :first, :order => 'title' )
		#else
			#@cupcake = Cupcake.find_by_slug( params[:slug] )
		#end
		#unless @cupcake
			#render :file => RAILS_ROOT + "/public/404.html", :status => 404
			#return false
		#end

    @slug = (params[:slug] == 'first')? 'first' : params[:slug]
		#@cupcakes = Cupcake.find(:all, :order => 'title')
    @cupcakes = Cupcake.find(:all, :select => 'cupcakes.id, cupcakes.title AS title, \'1\' AS cup, slug, description, is_breakfast,image_file, cutoff_date, visible_start_date, available_start_date', :order => 'title, cup = \'1\' DESC', :joins => 'UNION (SELECT mini_cupcakes.id, mini_cupcakes.title AS title, \'2\' AS cup, slug, description, \'0\' AS is_breakfast,image_file, cutoff_date, visible_start_date, available_start_date FROM mini_cupcakes)')
		@prices = Price.find(:all)
	end

  def mini_cupcake
    @slug = (params[:slug] == 'first')? 'first' : params[:slug]
		#@mini_cupcakes = MiniCupcake.find(:all, :order => 'title')
    @mini_cupcakes = Cupcake.find(:all, :select => 'cupcakes.id, cupcakes.title AS title, \'1\' AS cup, slug, description, is_breakfast,image_file, cutoff_date, visible_start_date, available_start_date', :order => 'title, cup = \'1\' DESC', :joins => 'UNION (SELECT mini_cupcakes.id, mini_cupcakes.title AS title, \'2\' AS cup, slug, description, \'2\' AS is_breakfast,image_file, cutoff_date, visible_start_date, available_start_date FROM mini_cupcakes)')
		@prices = Price.find_by_title('two dozen mini')
	end

	def answers
		@faqs = Faq.find(:all, :order => 'position')
	end

	def news_list
		@dyno_type=DynoType.find_by_slug('news')
		@dyno_pages = DynoPage.find(:all, :conditions => {:dyno_type_id => @dyno_type, :is_active => true}, :order => "page_on desc")
	end

	def news_detail
		@dyno_page = DynoPage.find(:first, :conditions => ["dyno_type_id = 2 and slug = ?", params[:page_slug]] )
		unless @dyno_page && @dyno_page.is_active
			render :file => RAILS_ROOT + "/public/404.html", :status => 404
			return false
		end
		@body_id = 'story'
	end
  
  def crave_cares
    @dyno_type=DynoType.find_by_slug('care')
		@dyno_pages = DynoPage.find(:all, :conditions => {:dyno_type_id => @dyno_type, :is_active => true}, :order => "page_on desc")
  end

  def care_detail
		@dyno_page = DynoPage.find(:first, :conditions => ["dyno_type_id = 3 and slug = ?", params[:page_slug]] )
		unless @dyno_page && @dyno_page.is_active
			render :file => RAILS_ROOT + "/public/404.html", :status => 404
			return false
		end
		@body_id = 'story'
	end	

	def google_site_map
		@pages = DynoPage.find(:all, :include => :dyno_type, :conditions => "dyno_type_id in (1, 3)" )
		@categories = Category.find(:all, :include => :sub_categories,  :conditions => 'sub_categories.is_active = 1', :order => 'categories.position, sub_categories.position')
		@brands = Brand.find(:all)
		render(:layout => false)
	end

	def delivery
		if params[:zip] != ""
			@deli_fee = DeliveryFee.find(:first, :conditions =>["store_id = ? AND zip = ?", params[:store], params[:zip]])
			render :text => @deli_fee != nil ? ("<em>(Delivery Fee: <b>$" + (["%.2f" % @deli_fee.delivery_fee]).to_s + "</b>)</em>") : "0"
		else
			render :text => "<font color='red'>Please enter a zip code.</font>"
		end   
	end
  
	def order
    require 'tztime'
    
    @cst_houston = TZTime::LocalTime::Builder.new('Central Time (US & Canada)').now

    @delivery_order_notice = (Configuration.find_by_name("delivery_order_notice")).value

		# google code for order page - start
		@google_code = "<script type=text/javascript >
				var gaJsHost = (('https:' == document.location.protocol) ? 'https://ssl.' : 'http://www.');
				document.write(unescape('%3Cscript src=' + gaJsHost + 'google-analytics.com/ga.js type=text/javascript %3E%3C/script%3E'));
			</script>
			<script type=text/javascript>
				try {
					var pageTracker = _gat._getTracker('UA-18013795-1');
					pageTracker._trackPageview('order_funnel/start');
				}
				catch(err) {}
			</script>"
		# google code for order page - end

		# get the hours pickup is available
		@order_times = ["Select"] + HALF_HOUR_TIMES[ DEFAULT_START .. DEFAULT_END ]    
		@show_specials = (Configuration.find_by_name("seasonal_show_section")).value
		@intro_specials = (Configuration.find_by_name("seasonal_intro")).value
		@candle_specials = (Configuration.find_by_name("candle_special")).value


    if session[:user_name]==nil
      @product_types = ProductType.find(:all, :include => :products ,:order =>" position ASC", :conditions => "product_types.admin_only = 0" )
      @product_types_candles = Product.find(:all ,:conditions =>"product_type_id in (" +  @candle_specials + " )" )      
    else
      @product_types = ProductType.find(:all, :include => :products ,:order =>" position ASC" )
      @product_types_candles = Product.find(:all ,:conditions =>"product_type_id in (" +  @candle_specials + " )" )      
    end

    @admin_users = Owner.find(:all)
		    
      
    @override_msg = ""
        
    if params['override_button.x'] && ! params['override_button.x'].blank?
      
      logged_in_user = Owner.find(:first, :conditions => ["username = ? and password = ?", params['override_user'], params['override_psw']])
      if logged_in_user
        if logged_in_user.payment_type_restricted == false
          session[:user_overrode] = true
          session[:overridden_by] = logged_in_user.id
          session[:overridden_user] = logged_in_user.first_name + " " + logged_in_user.last_name
        else
          @override_msg = "Invalid credentials or that user is not authorized to override."
        end
      else
        @override_msg = "Invalid credentials or that user is not authorized to override."
      end
    end    
    
    if params['reset_override_button.x'] && ! params['reset_override_button.x'].blank?
      session[:user_overrode] = false
      session[:overridden_by] = 0
      session[:overridden_user] = ""
    end    
    
    
		if params['submit_button.x'] && ! params['submit_button.x'].blank?

      #t = Time.now      
      #cst = (t.gmtime) - (60*60*6)
      cst = TZTime::LocalTime::Builder.new('Central Time (US & Canada)').now
      cst_2moro = cst + (60 * 60 * 24)

      if params[:date_of_order].length < 10 
        render :action => :order
      elsif ((params[:date_of_order][0,10].to_s == cst_2moro.strftime("%m/%d/%Y").to_s) && cst.hour.to_i >= 17 && session[:user_name]==nil)
          @deli_error =  "Online orders for the next day must be placed prior to 5PM Central Time."

          @specials = Special.find(:all, :conditions => ["is_enable = 1"])

            session[:vars] = params
            session[:exp_month_val] = params[:exp_month]
            session[:vars][:cc_type] = get_cc_name(params[:cc_type])
            session[:vars][:exp_month] = get_full_month_name(params[:exp_month])
            order_day = Date.parse(params[:date_of_order])
            if order_day
              @day = Day.find( order_day.wday > 0 ? order_day.wday : 7 )
              @cupcakes = @day.cupcakes
              @mini_cupcakes = @day.mini_cupcakes
            end

          render :action => :order
      else
      
        # google code for order confirm page - start
        @google_code = "<script type=text/javascript >
                var gaJsHost = (('https:' == document.location.protocol) ? 'https://ssl.' : 'http://www.');
                document.write(unescape('%3Cscript src=' + gaJsHost + 'google-analytics.com/ga.js type=text/javascript %3E%3C/script%3E'));
              </script>
              <script type=text/javascript>
                try {
                  var pageTracker = _gat._getTracker('UA-18013795-1');
                  pageTracker._trackPageview('order_funnel/confirm');
                }
                catch(err) {}
              </script>"
        # google code for order confirm page - end

        # delivery fee
        store = params[:store] == "Uptown Park" ? 1 : 2
        deli_fee = DeliveryFee.find(:first, :conditions =>["store_id = ? AND zip = ?", store, params[:shipto_zip]])
        @deli_fee =  deli_fee != nil ? deli_fee.delivery_fee : 0

        #@vars = params
        session[:vars] = params
        session[:exp_month_val] = params[:exp_month]
        session[:vars][:cc_type] = get_cc_name(params[:cc_type])
        session[:vars][:exp_month] = get_full_month_name(params[:exp_month])
            

        if  @deli_fee == 0 && params[:delivery_method] == "delivery"

          @deli_error = "We do not deliver to your zip code. Please enter a different delivery address or schedule your order for pickup."
          @specials = Special.find(:all, :conditions => ["is_enable = 1"])

          order_day = Date.parse(params[:date_of_order])
          if order_day
            @day = Day.find( order_day.wday > 0 ? order_day.wday : 7 )
            @cupcakes = @day.cupcakes
            @mini_cupcakes = @day.mini_cupcakes
          end
        
        elsif session[:order_status] != nil && session[:order_status] == 1 && session[:user_name]==nil
          
          @deli_error = "We are booked for preorders during the time you have selected. If you need cupcakes during that time, please feel free to come by the store. We bake fresh in small batches throughout the day and endeavor to keep our shelves stocked with fresh cupcakes. Alternatively you can also place your order for another CRAVE location."
				            
          @specials = Special.find(:all, :conditions => ["is_enable = 1"])

          order_day = Date.parse(params[:date_of_order])
          if order_day
            @day = Day.find( order_day.wday > 0 ? order_day.wday : 7 )
            @cupcakes = @day.cupcakes
            @mini_cupcakes = @day.mini_cupcakes
          end

        else

          t = params[:date_of_order].to_date
          weekday = t.strftime("%A")

          if (params[:time_of_order] == "17" || params[:time_of_order] == "18" || params[:time_of_order] == "19" || params[:time_of_order] == "20" )
            slotid=1
          elsif (params[:time_of_order] == "21" || params[:time_of_order] == "22" || params[:time_of_order] == "23" || params[:time_of_order] == "24" )
            slotid=2
          elsif (params[:time_of_order] == "25" || params[:time_of_order] == "26" || params[:time_of_order] == "27" || params[:time_of_order] == "28" )
            slotid=3
          elsif (params[:time_of_order] == "29" || params[:time_of_order] == "30" || params[:time_of_order] == "31" || params[:time_of_order] == "32" )
            slotid=4
          elsif (params[:time_of_order] == "33" || params[:time_of_order] == "34" || params[:time_of_order] == "35" || params[:time_of_order] == "36" )
            slotid=5
          else (params[:time_of_order] == "37" || params[:time_of_order] == "38" || params[:time_of_order] == "39" || params[:time_of_order] == "40" || params[:time_of_order] == "41" )
            slotid=6
          end

          slotid = (params[:store] == "Uptown Park")? slotid : (slotid + 6)

          store_id = params[:store] == "Uptown Park" ? 1 : 2
          special_orders = TimeslotWindow.find(:first, :conditions => ["store_id = ? AND id = ? ", store_id, slotid])

          maximun_orders=0

          if weekday == 'Monday'
            maximun_orders = special_orders.mon
          elsif weekday == 'Tuesday'
            maximun_orders = special_orders.tue
          elsif weekday == 'Wednesday'
            maximun_orders = special_orders.wed
          elsif weekday == 'Thursday'
            maximun_orders = special_orders.thu
          elsif weekday == 'Friday'
            maximun_orders = special_orders.fri
          elsif weekday == 'Saturday'
            maximun_orders = special_orders.sat
          elsif weekday == 'Sunday'
            maximun_orders = special_orders.sun
          end

          store_id = params[:store] == "Uptown Park" ? 1 : 2
          cup_cake = OrderCount.find(:all , :select => "SUM(no_of_orders) as total", :conditions => ["store_id = ? AND date = ? AND prod_win_id = ? ", store_id, Time.parse(params[:date_of_order]), slotid])

          possible_value= (maximun_orders.to_i - cup_cake[0].total.to_i)
          @dozens= ((possible_value/12.0)).to_i


          spc_qty = 0
          if params[:specials] !=  nil
            params[:specials].each_pair{|key, value|
              _qty = value.to_i
              if _qty > 0
                spc_qty += _qty
              end
            }
          end
          cup_qty = 0
          if params[:cupcakes] != nil
            params[:cupcakes].each_pair{|key, value|
              _quantity = value.to_i
              if _quantity > 0
                cup_qty  += _quantity
              end
            }
          end
          
          mini_cup_qty_err = false         
          
          if params[:mini_cupcakes] != nil
            params[:mini_cupcakes].each_pair{|key, value|
              _quantity = value.to_i
              if _quantity % 12 != 0
                mini_cup_qty_err  = true
                break
              end
            }
          end

          mini_cup_qty = 0
          if params[:mini_cupcakes] !=  nil
            params[:mini_cupcakes].each_pair{|key, value|
              _qty = value.to_i
              if _qty > 0
                mini_cup_qty += _qty
              end
            }
          end

          if session[:user_name]==nil
                        
            if mini_cup_qty_err == false
                  if spc_qty < 1 && cup_qty < 12 && mini_cup_qty < 12
                    #@deli_error = "You must order at least 12 cupcakes (or a seasonal box, if available)."
                    @deli_error = "You must order at least 12 original size cupcakes, 12 mini cupcakes, or a seasonal box (if available)."
                    @specials = Special.find(:all, :conditions => ["is_enable = 1"])
                    order_day = Date.parse(params[:date_of_order])
                    if order_day
                      @day = Day.find( order_day.wday > 0 ? order_day.wday : 7 )
                      @cupcakes = @day.cupcakes
                      @mini_cupcakes = @day.mini_cupcakes
                    end
                  else
                    if possible_value < (params[:no_of_orders_sp_cake].to_i + params[:no_of_orders_cake].to_i + params[:no_of_orders_cake_mini].to_i)
                      @deli_error = "Given our current bookings, we are unable to fulfill your order at the time you have selected. <br> If you need cupcakes during those times, please feel free to come by the store. We bake fresh in small batches throughout the day and endeavor to keep our shelves stocked with fresh cupcakes. Alternatively you can also place your order for another CRAVE location."
                      @specials = Special.find(:all, :conditions => ["is_enable = 1"])

                      order_day = Date.parse(params[:date_of_order])
                      if order_day
                        @day = Day.find( order_day.wday > 0 ? order_day.wday : 7 )
                        @cupcakes = @day.cupcakes
                        @mini_cupcakes = @day.mini_cupcakes
                      end
                    else
                      render :action => :review_order
                    end
                  end
            else
                  @deli_error = "Please enter mini cupcakes in increments of dozen."
                  @specials = Special.find(:all, :conditions => ["is_enable = 1"])
                  order_day = Date.parse(params[:date_of_order])
                  if order_day
                    @day = Day.find( order_day.wday > 0 ? order_day.wday : 7 )
                    @cupcakes = @day.cupcakes
                    @mini_cupcakes = @day.mini_cupcakes
                  end
            end
            
          else
            render :action => :review_order
          end
              
        end
      
      end
      
			# when order review page submit pressed, it comes here
		elsif params[:order_review] == "true"# params['submit_order.x'] && ! params['submit_order.x'].blank?
      #t = Time.now
      #cst = (t.gmtime) - (60*60*6)
      cst = TZTime::LocalTime::Builder.new('Central Time (US & Canada)').now
      cst_2moro = cst + (60 * 60 * 24)

      if session[:vars]==nil
          render :controller => "page", :action => "order", :page_type => "order", :page_slug => "order"
      else

        if ((session[:vars][:date_of_order][0,10].to_s == cst_2moro.strftime("%m/%d/%Y").to_s) && cst.hour.to_i >= 17 && session[:user_name]==nil)
              @deli_error =  "Online orders for  the next day must be placed prior to 5PM Central Time."

              @specials = Special.find(:all, :conditions => ["is_enable = 1"])

              order_day = Date.parse(session[:vars][:date_of_order])
              if order_day
                @day = Day.find( order_day.wday > 0 ? order_day.wday : 7 )
                @cupcakes = @day.cupcakes
                @mini_cupcakes = @day.mini_cupcakes
              end

              render :action => :order
        else

          if session[:vars]==nil

            render :controller => "page", :action => "order", :page_type => "order", :page_slug => "order"

          else

            require 'delegating_attributes.rb'
            require 'active_merchant'

            session[:vars][:order_shipping] = (params[:order_shipping]).to_f
            session[:vars][:order_weekend] = (params[:order_weekend]).to_f

=begin
        # Save Order
        @ret = save_order(session[:vars])
        if @ret[0] != true
          @error = @ret[1]
          render :action => :msg
          return
        else
          GeneralMailer.deliver_preorder( session[:vars] )
          GeneralMailer.deliver_order_received( session[:vars] )
          render :action => :order_thanks
          return
        end
=end
          #=begin

            if session[:vars][:store] != "Uptown Park"
              session[:vars][:super_admin_email] = (Configuration.find_by_name("admin_email_wu")).value
            else
              session[:vars][:super_admin_email] = (Configuration.find_by_name("admin_email_up")).value
            end

            @order_ref = OrderRef.new(:order_total => session[:final_order_total][0], :store_id => (session[:vars][:store] != "Uptown Park")? 2 : 1 , :cus_name => session[:vars]['first_name'] + " " + session[:vars]['last_name'] )
            @order_ref.save
            session[:vars][:order_id] = @order_ref.id

            if session[:user_name]==nil
              require 'active_merchant'
              # Send requests to the gateway's test servers
              if session[:vars][:store] != "Uptown Park"
                ActiveMerchant::Billing::Base.mode = :live
              else
                ActiveMerchant::Billing::Base.mode = :live
              end

              number  = session[:vars]['ccn']
              month   = session[:exp_month_val]
              year    = session[:vars]['exp_year']
              fname   = session[:vars]['b_fname']
              lname   = session[:vars]['b_lname']
              ccv     = session[:vars]['ccv']
              type    = session[:vars]['cc_type']

              amount = (session[:final_order_total][0] ).to_f
              amount = amount * 100

              # Create a new credit card object
              credit_card = ActiveMerchant::Billing::CreditCard.new(
                :number				   => number,
                :month				=> month,
                :year				 => year,
                :first_name         => fname,
                :last_name				=> lname,
                :verification_value => ccv #,
                # :type				 => type
              )
#changed from true to false by malli
              if credit_card.valid?

                # Create a gateway object to the TrustCommerce service
                if session[:vars][:store] != "Uptown Park"
                  # 2nd store auth.
                  gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(
                    :login => "5DG7f8v9",
                    :password => "5USyH7n888F3K4a5", # "4r7f42Zd5bZrUB6M"
                    :test =>true
                  )
                else
                  # Crave auth.
                  gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(
                    :login => "4Tgz2fN56",
                    :password => "2KQ58La8447Mz8aH", # "4r7f42Zd5bZrUB6M"
                    :test =>true
                  )
                end

                response = gateway.authorize(amount, credit_card, options = {:order_id => @order_ref.id, :billing_address => {:zip => session[:vars]['b_zip'] }})

                if response.success?
                  # Save Order
                  @ret = save_order(session[:vars], @order_ref)

                  if @ret[0] != true
                    @error = " <font color='red' family='Arial,Verdana,sans-serif !important'> <b>   Given our current bookings, we are unable to fulfill your order at the time you have selected.  <br> If you need cupcakes during those times, please feel free to come by the store. We bake fresh in small batches throughout the day and endeavor to keep our shelves stocked with fresh cupcakes. Alternatively you can also place your order for another CRAVE location. </b> "
                    # google code - order reject page - user - start
                    @google_code = "
                               <script type=text/javascript >
                              var gaJsHost = (('https:' == document.location.protocol) ? 'https://ssl.' : 'http://www.');
                              document.write(unescape('%3Cscript src=' + gaJsHost + 'google-analytics.com/ga.js type=text/javascript %3E%3C/script%3E'));
                               </script>
                               <script type=text/javascript>
                              try {
                                var pageTracker = _gat._getTracker('UA-18013795-1');
                                pageTracker._trackPageview();
                              }
                              catch(err) {}
                            </script>"
                    # google code - order reject page - user - end
                    render :action => :msg
                    return
                  else
                    # Capture the money
                    gateway.capture(amount, response.authorization)

                    # send email
                    
                    begin
                      # .. process
                      GeneralMailer.deliver_preorder( session[:vars] )
                      GeneralMailer.deliver_order_received( session[:vars] )
                    rescue
                      # .. handle error
                    ensure
                      #
                    end
                    
                    

                    #-------------------google code start--------------------------------------

                    @google_code = "
                            <script type=text/javascript >
                              var gaJsHost = (('https:' == document.location.protocol) ? 'https://ssl.' : 'http://www.');
                              document.write(unescape('%3Cscript src=' + gaJsHost + 'google-analytics.com/ga.js type=text/javascript %3E%3C/script%3E'));
                            </script>
                            <script type=text/javascript>
                              try {
                                  var pageTracker = _gat._getTracker('UA-18013795-1');
                                  pageTracker._trackPageview('order_funnel/thankyou');
                              }
                              catch(err) {}
                            </script>"
                    #-----------------google e commerce tracking code start----------------------------------------

                    @google_code += "
                            <script type=text/javascript >
                              var google_conversion_id = 1006323543;
                              var google_conversion_language = 'en';
                              var google_conversion_format = '2';
                              var google_conversion_color = 'ffffff';
                              var google_conversion_label = '6sGfCNmx2wEQ147t3wM';
                              var google_conversion_value = 0;
                              if (50.00) {
                                google_conversion_value = 50.00;
                              }
                            </script>
                            <script type=text/javascript src=https://www.googleadservices.com/pagead/conversion.js></script>
                            <noscript>
                              <div style=display:inline; ><img height=1 width=1 style=border-style:none; alt='' src='https://www.googleadservices.com/pagead/conversion/1006323543/?value=50.00&amp;label=6sGfCNmx2wEQ147t3wM&amp;guid=ON&amp;script=0'/></div>
                            </noscript>"
                    @google_code += "
                            <script type=text/javascript>
                              var gaJsHost = (('https:' == document.location.protocol) ? 'https://ssl.' : 'http://www.');   document.write(unescape('%3Cscript src=' + gaJsHost + 'google-analytics.com/ga.js type=text/javascript %3E%3C/script%3E'));
                            </script>"
                    @google_code += "
                              <script type=text/javascript>
                                try {
                              var pageTracker = _gat._getTracker('UA-18013795-1');
                              pageTracker._trackPageview();

                              pageTracker._addTrans(
                                  '" + @ret[3].to_s + "', //order-id required
                                  'Crave " + session[:vars]['store'] + "',
                                  '" + params[:order_total] + "', // required
                                  '',
                                  '',
                                  '" + session[:vars]['b_city'] + "',
                                  '" + session[:vars]['b_state'] + "',
                                  'United States'
                              );"

                    if session[:vars]['specials'] !=  nil
                      for one_of_spc in session[:vars]['specials']
                        if one_of_spc[1] != ''
                          sp_cake = Special.find(:first, :conditions => ['id = ?', one_of_spc[0]])

                          @google_code += "
                                          pageTracker._addItem(
                                        '" + @ret[3].to_s + "', //order-id required
                                        '" + sp_cake.title + "', //SKU required
                                        '" + sp_cake.title + "', // product name
                                        'Seasonal', // product category
                                        '" + sp_cake.price.to_s + "',  //unit price required
                                        '" + one_of_spc[1] + "'  //quantity required
                                          );"
                        end
                      end
                    end

                    if session[:vars]['cupcakes'] !=  nil
                      breakfast1  = Price.find(:first, :conditions => ["title = 'breakfast' "])
                      if breakfast1 !=nil
                        breakfast = breakfast1.price
                      else
                        breakfast = 0.0
                      end

                      single1  = Price.find(:first, :conditions => ["title = 'single' "])
                      if single1 !=nil
                        single = single1.price
                      else
                        single = 0.0
                      end

                      for one_of_cupc in session[:vars]['cupcakes']
                        if one_of_cupc[1] != ''
                          cup_cake = Cupcake.find(:first, :conditions => ['id = ?', one_of_cupc[0]])
                          c_price = cup_cake.is_breakfast ? breakfast : single

                          @google_code += "
                                          pageTracker._addItem(
                                        '" + @ret[3].to_s + "',  //order-id required
                                        '" + cup_cake.title + "', //SKU required
                                        '" + cup_cake.title + "',// product name
                                        'Cupcakes',// product category
                                        '" + c_price.to_s + "',  //unit price required
                                        '" + one_of_cupc[1] + "'  //quantity required
                                          );"
                        end
                      end
                    end

                    if session[:vars]['products'] !=  nil

                      for one_of_prod in session[:vars]['products']
                        if one_of_prod[1] != ""
                          prod = Product.find(:first, :conditions => ['id = ?', one_of_prod[0]])

                          @google_code += "
                                        pageTracker._addItem(
                                      '" + @ret[3].to_s + "', //order-id required
                                      '" + prod.title + "', //SKU required
                                      '" + prod.title + "',// product name
                                      'Other Products',// product category
                                      '" + prod.price.to_s + "',  //unit price required
                                      '" + one_of_prod[1] + "'  //quantity required
                                        );"
                        end
                      end
                    end

                    @google_code += "pageTracker._trackTrans();  } catch(err) {}</script>"
                    #-------------------google code end--------------------------------------
                    # goto thank you page
                    # order_thanks page needs the session obj and it deletes it at the end of the page.
                    render :action => :order_thanks
                    return
                  end







                else
                  @error = response.message
                  render :action => :msg
                  # raise StandardError, response.message
                end
              else
                @error = "Invalid Credit Card. Please check the Credit Card info again."
                render :action => :msg
              end
            else

              # Save Order
              if session[:vars]['ccn']!=''

                require 'active_merchant'
                # Send requests to the gateway's test servers
                if session[:vars][:store] != "Uptown Park"
                  ActiveMerchant::Billing::Base.mode = :live
                else
                  ActiveMerchant::Billing::Base.mode = :live
                end

                number  = session[:vars]['ccn']
                month   = session[:exp_month_val]
                year    = session[:vars]['exp_year']
                fname   = session[:vars]['b_fname']
                lname   = session[:vars]['b_lname']
                ccv     = session[:vars]['ccv']
                type    = session[:vars]['cc_type']

                amount = (session[:final_order_total][0]).to_f
                amount = amount * 100

                # Create a new credit card object
                credit_card = ActiveMerchant::Billing::CreditCard.new(
                  :number             => number,
                  :month              => month,
                  :year               => year,
                  :first_name         => fname,
                  :last_name          => lname,
                  :verification_value => ccv #,
                  # :type               => type
                )

                if credit_card.valid?

                  # Create a gateway object to the TrustCommerce service
                  if session[:vars][:store] != "Uptown Park"
                    # 2nd store auth.
                    gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(
                      :login => "5DG7f8v9",
                      :password => "5USyH7n888F3K4a5", # "4r7f42Zd5bZrUB6M"
                      :test =>false
                    )
                  else
                    # Crave live auth.
                    gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(
                      :login => "4Tgz2fN56",
                      :password => "2KQ58La8447Mz8aH", # "4r7f42Zd5bZrUB6M"
                      :test =>false
                    )
                  end

                  response = gateway.authorize(amount, credit_card, options = {:order_id => @order_ref.id, :billing_address => {:zip => session[:vars]['b_zip']}})

                  if response.success?

                    @ret = save_order(session[:vars], @order_ref)
                    if @ret[0] != true

                      # google code - order reject page - admin - start
                      @google_code = "
                              <script type=text/javascript >
                                  var gaJsHost = (('https:' == document.location.protocol) ? 'https://ssl.' : 'http://www.');
                                  document.write(unescape('%3Cscript src=' + gaJsHost + 'google-analytics.com/ga.js type=text/javascript %3E%3C/script%3E'));
                              </script>
                              <script type=text/javascript>
                                  try {
                                    var pageTracker = _gat._getTracker('UA-18013795-1');
                                    pageTracker._trackPageview();
                                  }
                                  catch(err) {}
                              </script>"
                      # google code - order reject page - admin - end

                      #@error = " <font color='red' family='Arial,Verdana,sans-serif !important'> <b> " <<  @ret[2] << " <br>  Please select another time or a different store. If you need this order fulfilled at that time, please call the store."  << " </b></font>"

                      @error = " <font color='red' family='Arial,Verdana,sans-serif !important'> <b>   Given our current bookings, we are unable to fulfill your order at the time you have selected. <br> If you need cupcakes during those times, please feel free to come by the store. We bake fresh in small batches throughout the day and endeavor to keep our shelves stocked with fresh cupcakes. Alternatively you can also place your order for another CRAVE location. </b> "
                      render :action => :msg
                      return
                    else
                      # Capture the money
                      gateway.capture(amount, response.authorization)

                      # send email
                      
                      begin
                        # .. process
                        GeneralMailer.deliver_preorder( session[:vars] )
                        #GeneralMailer.deliver_order_received_admin( session[:vars] )
                        GeneralMailer.deliver_order_received( session[:vars] )
                      rescue
                        # .. handle error
                      ensure
                        #
                      end
                      
                      

                      #-------------------google code start--------------------------------------

                      @google_code = "
                                      <script type=text/javascript >
                                          var gaJsHost = (('https:' == document.location.protocol) ? 'https://ssl.' : 'http://www.');
                                          document.write(unescape('%3Cscript src=' + gaJsHost + 'google-analytics.com/ga.js type=text/javascript %3E%3C/script%3E'));
                                      </script>
                                      <script type=text/javascript>
                                          try {
                                              var pageTracker = _gat._getTracker('UA-18013795-1');
                                              pageTracker._trackPageview('order_funnel/thankyou');
                                          }
                                          catch(err) {}
                                      </script>"

                      #-----------------google e commerce tracking code start----------------------------------------

                      @google_code += "
                                <script type=text/javascript >
                                    var google_conversion_id = 1006323543;
                                    var google_conversion_language = 'en';
                                    var google_conversion_format = '2';
                                    var google_conversion_color = 'ffffff';
                                    var google_conversion_label = '6sGfCNmx2wEQ147t3wM';
                                    var google_conversion_value = 0;
                                    if (50.00) {
                                      google_conversion_value = 50.00;
                                    }
                                </script>
                                <script type=text/javascript src=https://www.googleadservices.com/pagead/conversion.js>
                                </script>
                                <noscript>
                                  <div style=display:inline; >
                                  <img height=1 width=1 style=border-style:none; alt='' src='https://www.googleadservices.com/pagead/conversion/1006323543/?value=50.00&amp;label=6sGfCNmx2wEQ147t3wM&amp;guid=ON&amp;script=0'/>
                                </div>
                                </noscript>"


                      @google_code += "
                                      <script type=text/javascript>
                                          var gaJsHost = (('https:' == document.location.protocol) ? 'https://ssl.' : 'http://www.');   document.write(unescape('%3Cscript src=' + gaJsHost + 'google-analytics.com/ga.js type=text/javascript %3E%3C/script%3E'));
                                      </script>"

                      @google_code += "
                                      <script type=text/javascript>
                                      try {
                                          var pageTracker = _gat._getTracker('UA-18013795-1');
                                          pageTracker._trackPageview();

                                          pageTracker._addTrans(
                                              '" + @ret[3].to_s + "', //order-id required
                                              'Crave " + session[:vars]['store'] + "',
                                              '" + params[:order_total] + "', // required
                                              '',
                                              '',
                                              '" + session[:vars]['b_city'] + "',
                                              '" + session[:vars]['b_state'] + "',
                                              'United States'
                                          );"

                      if session[:vars]['specials'] !=  nil
                        for one_of_spc in session[:vars]['specials']
                          if one_of_spc[1] != ''
                            sp_cake = Special.find(:first, :conditions => ['id = ?', one_of_spc[0]])

                            @google_code += "
                                                    pageTracker._addItem(
                                                        '" + @ret[3].to_s + "', //order-id required
                                                        '" + sp_cake.title + "', //SKU required
                                                        '" + sp_cake.title + "', // product name
                                                        'Seasonal', // product category
                                                        '" + sp_cake.price.to_s + "',  //unit price required
                                                        '" + one_of_spc[1] + "'  //quantity required
                                                    );"
                          end
                        end
                      end

                      if session[:vars]['cupcakes'] !=  nil
                        breakfast1  = Price.find(:first, :conditions => ["title = 'breakfast' "])
                        if breakfast1 !=nil
                          breakfast = breakfast1.price
                        else
                          breakfast = 0.0
                        end

                        single1  = Price.find(:first, :conditions => ["title = 'single' "])
                        if single1 !=nil
                          single = single1.price
                        else
                          single = 0.0
                        end
                        #breakfast = Price.find_by_title('breakfast').price
                        #single = Price.find_by_title('single').price

                        for one_of_cupc in session[:vars]['cupcakes']
                          if one_of_cupc[1] != ''
                            cup_cake = Cupcake.find(:first, :conditions => ['id = ?', one_of_cupc[0]])
                            c_price = cup_cake.is_breakfast ? breakfast : single

                            @google_code += "
                                                    pageTracker._addItem(
                                                        '" + @ret[3].to_s + "',  //order-id required
                                                        '" + cup_cake.title + "', //SKU required
                                                        '" + cup_cake.title + "',// product name
                                                        'Cupcakes',// product category
                                                        '" + c_price.to_s + "',  //unit price required
                                                        '" + one_of_cupc[1] + "'  //quantity required
                                                    );"
                          end
                        end
                      end

                      if session[:vars]['products'] !=  nil

                        for one_of_prod in session[:vars]['products']
                          if one_of_prod[1] != ""
                            prod = Product.find(:first, :conditions => ['id = ?', one_of_prod[0]])

                            @google_code += "
                                                    pageTracker._addItem(
                                                        '" + @ret[3].to_s + "', //order-id required
                                                        '" + prod.title + "', //SKU required
                                                        '" + prod.title + "',// product name
                                                        'Other Products',// product category
                                                        '" + prod.price.to_s + "',  //unit price required
                                                        '" + one_of_prod[1] + "'  //quantity required
                                                    );"
                          end
                        end
                      end

                      @google_code += "pageTracker._trackTrans();  } catch(err) {}</script>"
                      #-------------------google code end--------------------------------------

                      render :action => :order_thanks
                      return
                    end







                  else
                    @error = response.message
                    render :action => :msg
                    # raise StandardError, response.message
                  end
                else
                  @error = "Invalid Credit Card. Please check the Credit Card info again."
                  render :action => :msg
                end

              else

                @ret = save_order(session[:vars],  @order_ref)
                if @ret[0] != true

                  # google code - order reject page - admin - start
                  @google_code = "
                    <script type=text/javascript >
                        var gaJsHost = (('https:' == document.location.protocol) ? 'https://ssl.' : 'http://www.');
                        document.write(unescape('%3Cscript src=' + gaJsHost + 'google-analytics.com/ga.js type=text/javascript %3E%3C/script%3E'));
                    </script>
                    <script type=text/javascript>
                        try {
                          var pageTracker = _gat._getTracker('UA-18013795-1');
                          pageTracker._trackPageview();
                        }
                        catch(err) {}
                    </script>"
                  # google code - order reject page - admin - end

                  #@error = " <font color='red' family='Arial,Verdana,sans-serif !important'> <b> " <<  @ret[2] << " <br>  Please select another time or a different store. If you need this order fulfilled at that time, please call the store."  << " </b></font>"

                  @error = " <font color='red' family='Arial,Verdana,sans-serif !important'> <b>   Given our current bookings, we are unable to fulfill your order at the time you have selected. <br> If you need cupcakes during those times, please feel free to come by the store. We bake fresh in small batches throughout the day and endeavor to keep our shelves stocked with fresh cupcakes. Alternatively you can also place your order for another CRAVE location. </b> "
                  render :action => :msg
                  return
                else
                  
                  begin
                    # .. process
                    GeneralMailer.deliver_preorder( session[:vars] )
                    #GeneralMailer.deliver_order_received_admin( session[:vars] )
                    if session[:vars]['email']!=''
                      GeneralMailer.deliver_order_received_admin_customer( session[:vars] )
                    end
                  rescue
                    # .. handle error
                  ensure
                    #
                  end
                  
                  

                  #-------------------google code start--------------------------------------

                  @google_code = "
                                <script type=text/javascript >
                                    var gaJsHost = (('https:' == document.location.protocol) ? 'https://ssl.' : 'http://www.');
                                    document.write(unescape('%3Cscript src=' + gaJsHost + 'google-analytics.com/ga.js type=text/javascript %3E%3C/script%3E'));
                                </script>
                                <script type=text/javascript>
                                    try {
                                        var pageTracker = _gat._getTracker('UA-18013795-1');
                                        pageTracker._trackPageview('order_funnel/thankyou');
                                    }
                                    catch(err) {}
                                </script>"

                  #-----------------google e commerce tracking code start----------------------------------------

                  @google_code += "
                          <script type=text/javascript >
                              var google_conversion_id = 1006323543;
                              var google_conversion_language = 'en';
                              var google_conversion_format = '2';
                              var google_conversion_color = 'ffffff';
                              var google_conversion_label = '6sGfCNmx2wEQ147t3wM';
                              var google_conversion_value = 0;
                              if (50.00) {
                                google_conversion_value = 50.00;
                              }
                          </script>
                          <script type=text/javascript src=https://www.googleadservices.com/pagead/conversion.js>
                          </script>
                          <noscript>
                            <div style=display:inline; >
                            <img height=1 width=1 style=border-style:none; alt='' src='https://www.googleadservices.com/pagead/conversion/1006323543/?value=50.00&amp;label=6sGfCNmx2wEQ147t3wM&amp;guid=ON&amp;script=0'/>
                          </div>
                          </noscript>"


                  @google_code += "
                          <script type=text/javascript>
                              var gaJsHost = (('https:' == document.location.protocol) ? 'https://ssl.' : 'http://www.');   document.write(unescape('%3Cscript src=' + gaJsHost + 'google-analytics.com/ga.js type=text/javascript %3E%3C/script%3E'));
                          </script>"

                  @google_code += "
                          <script type=text/javascript>
                          try {
                              var pageTracker = _gat._getTracker('UA-18013795-1');
                              pageTracker._trackPageview();

                              pageTracker._addTrans(
                                  '" + @ret[3].to_s + "', //order-id required
                                  'Crave " + session[:vars]['store'] + "',
                                  '" + params[:order_total] + "', // required
                                  '',
                                  '',
                                  '" + session[:vars]['b_city'] + "',
                                  '" + session[:vars]['b_state'] + "',
                                  'United States'
                              );"

                  if session[:vars]['specials'] !=  nil
                    for one_of_spc in session[:vars]['specials']
                      if one_of_spc[1] != ''
                        sp_cake = Special.find(:first, :conditions => ['id = ?', one_of_spc[0]])

                        @google_code += "
                                        pageTracker._addItem(
                                            '" + @ret[3].to_s + "', //order-id required
                                            '" + sp_cake.title + "', //SKU required
                                            '" + sp_cake.title + "', // product name
                                            'Seasonal', // product category
                                            '" + sp_cake.price.to_s + "',  //unit price required
                                            '" + one_of_spc[1] + "'  //quantity required
                                        );"
                      end
                    end
                  end

                  if session[:vars]['cupcakes'] !=  nil
                    breakfast1  = Price.find(:first, :conditions => ["title = 'breakfast' "])
                    if breakfast1 !=nil
                      breakfast = breakfast1.price
                    else
                      breakfast = 0.0
                    end

                    single1  = Price.find(:first, :conditions => ["title = 'single' "])
                    if single1 !=nil
                      single = single1.price
                    else
                      single = 0.0
                    end
                    #breakfast = Price.find_by_title('breakfast').price
                    #single = Price.find_by_title('single').price

                    for one_of_cupc in session[:vars]['cupcakes']
                      if one_of_cupc[1] != ''
                        cup_cake = Cupcake.find(:first, :conditions => ['id = ?', one_of_cupc[0]])
                        c_price = cup_cake.is_breakfast ? breakfast : single

                        @google_code += "
                                        pageTracker._addItem(
                                            '" + @ret[3].to_s + "',  //order-id required
                                            '" + cup_cake.title + "', //SKU required
                                            '" + cup_cake.title + "',// product name
                                            'Cupcakes',// product category
                                            '" + c_price.to_s + "',  //unit price required
                                            '" + one_of_cupc[1] + "'  //quantity required
                                        );"
                      end
                    end
                  end

                  if session[:vars]['mini_cupcakes'] !=  nil
                    two_dozen  = (Price.find(:first, :conditions => ["title = 'two dozen mini' "])).price

                    for one_of_cupc in session[:vars]['mini_cupcakes']
                      if one_of_cupc[1] != ''
                        cup_cake = MiniCupcake.find(:first, :conditions => ['id = ?', one_of_cupc[0]])

                        @google_code += "
                                        pageTracker._addItem(
                                            '" + @ret[3].to_s + "',  //order-id required
                                            '" + cup_cake.title + "', //SKU required
                                            '" + cup_cake.title + "',// product name
                                            'Mini Cupcakes',// product category
                                            '" + two_dozen.to_s + "',  //unit price required
                                            '" + one_of_cupc[1] + "'  //quantity required
                                        );"
                      end
                    end
                  end

                  if session[:vars]['products'] !=  nil

                    for one_of_prod in session[:vars]['products']
                      if one_of_prod[1] != ""
                        prod = Product.find(:first, :conditions => ['id = ?', one_of_prod[0]])

                        @google_code += "
                                        pageTracker._addItem(
                                            '" + @ret[3].to_s + "', //order-id required
                                            '" + prod.title + "', //SKU required
                                            '" + prod.title + "',// product name
                                            'Other Products',// product category
                                            '" + prod.price.to_s + "',  //unit price required
                                            '" + one_of_prod[1] + "'  //quantity required
                                        );"
                      end
                    end
                  end

                  @google_code += "pageTracker._trackTrans();  } catch(err) {}</script>"
                  #-------------------google code end--------------------------------------

                  render :action => :order_thanks
                  return
                end
              end
            end
          end
          #=end
        end
      end
	  elsif params[:date_of_order] && ! params[:date_of_order].blank?

      #---------------------------------------------------
      if params[:order_page] == "true"
        session[:vars] = params
        session[:exp_month_val] = params[:exp_month]
        session[:vars][:cc_type] = get_cc_name(params[:cc_type])
        session[:vars][:exp_month] = get_full_month_name(params[:exp_month])
      end

      #---------------------------------------------------


      # cut off day of week to remove the day
      params[:date_of_order] = params[:date_of_order][0,10]
      # parse date
      order_day = Date.parse(params[:date_of_order])
      t = params[:date_of_order].to_date
      order_weekday = t.strftime("%A")
      # remove weekends from delivery orders - reset date if former date is not possible
      #			  if @params[:delivery_method] == "delivery" && ( order_day.wday == 0 || order_day.wday == 6 )
      #					  order_day = nil
      #            params[:date_of_order] = ''
      #				end
							
      if @params[:delivery_method] == "delivery"
        # switch to delivery hours if necessary

        @order_times = ["Select"] + HALF_HOUR_TIMES[ DELIVERY_START .. DELIVERY_END ]
      elsif @params[:delivery_method] == "pickup"
        # switch to pickup hours based on day array

        @order_times = ["Select"] + HALF_HOUR_TIMES[ PICKUP_START_DATES[order_day.wday] .. PICKUP_END_DATES[order_day.wday] ]
      end

			if order_day
				# adjust day from ruby's 0 index to JQuery's 1 index
				@day = Day.find( order_day.wday > 0 ? order_day.wday : 7 )

				# load up today's cupcakes
				@cupcakes = @day.cupcakes
        @mini_cupcakes = @day.mini_cupcakes

				isadmin='no'
				if session[:user_name]!=nil
					isadmin='yes'
				end

				store_id = params[:store] == "Uptown Park" ? 1 : 2

				@order_times, remove_time  = BlockedTime.process_max_order( order_day, @order_times, order_weekday, isadmin, store_id )

        if params[:time_of_order] != nil && params[:time_of_order] != "Select"
            @status, @remainings, @a = BlockedTime.process_max_order_new( order_day, order_weekday, isadmin, params[:time_of_order], store_id )
            session[:order_status] = @status
        end

				# remove blocked times, collect error messages
				@order_times, @blocked_messages = BlockedTime.process_date( order_day, @order_times, isadmin, store_id )
          
				#if !remove_time.empty?
        if @status == 1
					#aa=Array.new(2)
					aa=''
					for ti in (0..remove_time.length-1)
						aa += remove_time[ti][0]<< " "
					end

					#if session[:user_name]
          if @status == 1 && session[:user_name]
            @no_time_msg = "We are booked for preorders during the time you have selected. If you need cupcakes during that time, please feel free to come by the store. We bake fresh in small batches throughout the day and endeavor to keep our shelves stocked with fresh cupcakes. Alternatively you can also place your order for another CRAVE location.<br>(" + aa + ")"
						#@no_time_msg = " Please note Following Timeslots are Blocked, <br>" << aa            
						#@no_time_msg = "We are booked for preorders during certain times on the selected day. These times will not be available in the above list. If you need cupcakes during those times, please feel free to come by the store. We bake fresh in small batches throughout the day and endeavor to keep our shelves stocked with fresh cupcakes. Alternatively you can also place your order for another CRAVE location.<br>(" + aa + ")"
					else
            @no_time_msg = "We are booked for preorders during the time you have selected. If you need cupcakes during that time, please feel free to come by the store. We bake fresh in small batches throughout the day and endeavor to keep our shelves stocked with fresh cupcakes. Alternatively you can also place your order for another CRAVE location."
						#@no_time_msg = " Folowing Timeslots will not be available in the above list, <br>" << aa << " <br>If you need cupcakes during those times, please feel free to come to the store to pick some up."
						#@no_time_msg = "We are booked for preorders during certain times on the selected day. These times will not be available in the above list. If you need cupcakes during those times, please feel free to come by the store. We bake fresh in small batches throughout the day and endeavor to keep our shelves stocked with fresh cupcakes. Alternatively you can also place your order for another CRAVE location."
					end

				end

				# if no time slots available, display this error msg (6 = # of letters in "Select")
				if @order_times.to_s.length  == 6
					@no_time_msg = "<p>There are no time slots available on the selected date. Please select another date.</p>"
				end

			end
			# load specials
			@specials = Special.find(:all, :conditions => ["is_enable = 1"])

			if session[:user_name] == nil
				if params[:delivery_method] == "delivery" && (order_weekday == "Saturday" || order_weekday == "Sunday")
					params[:date_of_order] = ""
					@cupcakes = nil
					@specials = nil
					session[:vars][:no_of_orders_cake] = ""
					session[:vars][:no_of_orders_total_cake] = ""
				end
			end

		end
	end


  def save_order(vars, order_ref)

    # save promotional email start
    if vars[:promotional] == "true"
      save_promotional_email(vars)
    end
    # save promotional email end

    # @order = Order.new(vars[:order])
    a = Array.new(2)
    is_bluebox =  vars[:cupcake_boxed_special]
    labeled_cup = vars[:labeled_cups]
    potion_box =  vars[:remainder_cupcakes]
    patial_induvidual = vars[:noof_induv_cupcake].to_i

    ribbon_price1  = Price.find(:first, :conditions => ["title = 'ribbon' "])

    if ribbon_price1 !=nil
      @ribbon_price = ribbon_price1.price
    else
      @ribbon_price = 0.0
    end

    crave_blue_box1  = Configuration.find_by_name('packaging_gift_box_cost')
    if crave_blue_box1 !=nil
      @giftbox_price = crave_blue_box1.value.to_f
    else
      @giftbox_price = 0.0
    end

    induvidual_box_price1  = Configuration.find_by_name('packaging_flavor_box_cost')
    if induvidual_box_price1 !=nil
      @induvidual_price = induvidual_box_price1.value.to_f
    else
      @induvidual_price = 0.0
    end

    #@giftbox_price = Price.find_by_title('packaging_gift_box_cost').price
    #@induvidual_price= Price.find_by_title('packaging_ individual_ box_cost').price
    #@ribbon_price = Price.find_by_title('ribbon').price
    @option=''
    @induvual_box=''
    @induvidual_patial=''

   if labeled_cup == 'yes'
       @labeled_cup = 1
     else
       @labeled_cup = 0

     end
    if is_bluebox =='packed_in_standard_backary_box'
      @packOption= "Boxed in CRAVE standard bakery box(es)."
    end
    
    if is_bluebox =='packed_in_blue_box'
      @packOption= "Boxed in CRAVE Blue Gift Box(es).<br><em>(Additional $" +  ["%.2f" % @giftbox_price][0].to_s + "/box)</em>"
    end
    
    if is_bluebox =='packed_in_individual_box'
      @packOption= "Boxed in individual CRAVE gift box(es).<br><em>(Additional $" + ["%.2f" % @induvidual_price][0].to_s + " fee/box)</em>"
      @induvual_box= vars[:no_of_orders_cake]
    end
   
    @induvual_box= vars[:no_of_orders_cake]
    #if @option == "third"      
    #  @induvual_box= vars[:noof_induv_cupcake]
    #  @induvual_box_price = params[:patial_pack_free]
    #  @induvidual_patial = params[:patial_induvidual_boxes]
    #  @induvidual_patial_price = params[:patial_pack_box_free]
    #end
    
    @sp_dec_value = ""
    
    if vars[:has_special_decorations] == "true"
        
      name = vars[:sp_dd].split("*")
        
      if name[0] != "Select" && name[0]=="Holly-green leaf with red berries"


        @sp_dec = SpecialDecoration.find_by_name(name[0])
            
        @sp_dec_value = @sp_dec.name + " [" + @sp_dec.group.capitalize + "]"
      else 
           if name[0] != "Select" && name[0]!="Holly-green leaf with red berries"
              @sp_dec = SpecialDecoration.find_by_name(name[0])
              @sp_dec_value = @sp_dec.name + " [" + @sp_dec.group.capitalize + "] - " + ((vars[:clr_2] == "Select")? vars[:clr_1] : ("Base: " + vars[:clr_1] + ", Top: " + vars[:clr_2]))
              @sp_dec_value += ((vars[:number] != "Select")? ("<br>Number: " + vars[:number]) : "") + ((vars[:letter] != "Select")? ("<br>Letter: " + vars[:letter]) : "")
           else
              @sp_dec_value = ""
          end
      end
    end

    @mini_sp_dec_value = ""
    if vars[:has_special_decorations_mini] == "true"
      name = vars[:sp_dd_mini].split("*")
      if name[0] != "Select"
        @sp_dec = SpecialDecoration.find_by_name(name[0])
        @mini_sp_dec_value = @sp_dec.name + " [" + @sp_dec.group.capitalize + "] - " + ((vars[:clr_2_mini] == "Select")? vars[:clr_1_mini] : ("Base: " + vars[:clr_1_mini] + ", Top: " + vars[:clr_2_mini]))
        @mini_sp_dec_value += ((vars[:number_mini] != "Select")? ("<br>Number: " + vars[:number_mini]) : "") + ((vars[:letter_mini] != "Select")? ("<br>Letter: " + vars[:letter_mini]) : "")
      else
        @mini_sp_dec_value = ""
      end
    end

    require 'tztime'
    #t = Time.now
    #cst = (t.gmtime) - (60*60*6)
    cst = TZTime::LocalTime::Builder.new('Central Time (US & Canada)').now

    @mini_dozen = (Price.find_by_title('two dozen mini')).price.to_f

    if session[:user_name]==nil
      @credit_card = "XXXX-XXXX-XXXX-" + session[:vars]['ccn'][session[:vars]['ccn'].size-4, session[:vars]['ccn'].size-1]
      @order = Order.new(
        :order_id               => order_ref.id,
        :store_id         => vars[:store] == "Uptown Park" ? 1 : 2,
        :date_of_order    => Time.parse(vars[:date_of_order]) ,
        :time_of_order    => vars[:time_of_order],
        :delivery_method  => vars[:delivery_method],
        :how_to_pack      =>  @packOption,
        :labeled_cup => @labeled_cup,
        :how_to_pack_remainder => @packOption1,
        :induvidual_box   => @induvual_box,
        :induvual_box_price => @induvual_box_price,
        :induvidual_patial =>  @induvidual_patial,
        :induvidual_patial_price =>  @induvidual_patial_price,
        :gift_msg         => vars[:gift_msg] ,
        :spe_dec          => @sp_dec_value,
        :other_notes      => "",
        :first_name       => vars[:first_name],
        :last_name        => vars[:last_name],
        :primary_phone    => vars[:primary_phone],
        :alt_phone        => vars[:alt_phone],
        :email            => vars[:email],
        :special_decoration => vars[:has_special_decorations] == "true" ? 1 : 0,
        :shipto_is_business => vars[:shipto_is_business] == "true" ? 1 : 0,
        :shipto_business    => vars[:shipto_is_business] == "true" ? vars[:shipto_business] : "N/A",
        :shipto_first_name  => vars[:shipto_first_name] != nil ? vars[:shipto_first_name] : "N/A",
        :shipto_last_name   => vars[:shipto_last_name] != nil ? vars[:shipto_last_name] : "N/A",
        :shipto_phone     => vars[:shipto_phone] != nil ? vars[:shipto_phone] : "N/A",
        :shipto_address_1 => vars[:shipto_address_1] != nil ? vars[:shipto_address_1] : "N/A",
        :shipto_address_3 => vars[:shipto_address_3] != nil ? vars[:shipto_address_3] : "N/A",
        :shipto_zip       => vars[:shipto_zip] != nil ? vars[:shipto_zip] : "N/A",
        :ccn              => @credit_card,
        :b_fname          => vars[:b_fname],
        :b_lname          => vars[:b_lname],
        :b_adrs         => vars[:b_adrs],
        :b_city         => vars[:b_city],
        :b_state        => vars[:b_state],
        :b_zip          => vars[:b_zip],
        #:b_email        => vars[:b_email],
        #:b_phone        => vars[:b_phone],
        :payment_type   => vars[:cc_type],
        :person_pic_order => vars[:person_pic_order],
        :candle_method   => vars[:candle_method],
        :sales_tax      => (params[:sales_tax]).to_f,
        :sales_tax_packaging               => (params[:sales_tax_packaging]).to_f,
        :sales_tax_seasonal_packaging      => (params[:sales_tax_seasonal_packaging]).to_f,
        :order_shipping => (params[:order_shipping]).to_f,
        :order_discount => (params[:order_discount]).to_f,
        :pack_fee       => (params[:order_pack_fee]).to_f,
        :sub_tot        => (params[:order_sub_tot]).to_f,
        :gross_tot      => (params[:order_gross_tot]).to_f,
        :order_total    => (session[:final_order_total][0] ).to_f,
        :no_of_boxes    => params[:no_of_boxes],
        :no_of_sp_cupcakes => vars[:no_of_orders_sp_cake].to_i,
        :tax_rate       => params[:tax_rate].to_f,
        :sp_dec_notes   => "",
        :placed_on      => ('\''+ cst.strftime("%Y-%m-%d %H:%M:%S") + '\''),
        :oversize_order_surcharge => 0,
        :mini_sp_decoration => (vars[:has_special_decorations_mini] == "true")? 1 : 0,
        :mini_sp_dec        => @mini_sp_dec_value,
        :mini_sp_dec_notes  => "",
        :no_of_mini_cupcakes => vars[:no_of_orders_cake_mini]
      )
    else

      if session[:vars]['ccn']!=''
        @credit_card = "XXXX-XXXX-XXXX-" + session[:vars]['ccn'][session[:vars]['ccn'].size-4, session[:vars]['ccn'].size-1]

        b_fname   = vars[:b_fname]
        b_lname   = vars[:b_lname]
        b_adrs    = vars[:b_adrs]
        b_city    = vars[:b_city]
        b_state   = vars[:b_state]
        b_zip     = vars[:b_zip]
        b_email   = vars[:b_email]

        b_phone   = vars[:b_phone]

      else
        @credit_card=''
        b_fname   = ''
        b_lname   = ''
        b_adrs    = ''
        b_city    = ''
        b_state   = ''
        b_zip     = ''
        b_email   = ''
        b_phone   = ''
      end

      @order = Order.new(
        :order_id               => order_ref.id,
        :store_id         => vars[:store] == "Uptown Park" ? 1 : 2,
        :date_of_order    => Time.parse(vars[:date_of_order]) ,
        :time_of_order    => vars[:time_of_order],
        :delivery_method  => vars[:delivery_method],
        :how_to_pack      =>  @packOption,
        :how_to_pack_remainder => @packOption1,
        :induvidual_box   => @induvual_box,
        :induvual_box_price => @induvual_box_price,
        :induvidual_patial =>  @induvidual_patial,
        :induvidual_patial_price =>  @induvidual_patial_price,
        :gift_msg         => vars[:gift_msg] ,
        :special_decoration => (vars[:has_special_decorations] == "true")? 1 : 0,
        :other_notes      => (vars[:other_notes] != "")? vars[:other_notes] : "",
        :spe_dec          => @sp_dec_value,
        :first_name       => vars[:first_name],
        :last_name        => vars[:last_name],
        :primary_phone    => vars[:primary_phone],
        :alt_phone        => vars[:alt_phone],
        :email            => vars[:email],
        :shipto_is_business => vars[:shipto_is_business] == "true" ? 1 : 0,
        :shipto_business    => vars[:shipto_is_business] == "true" ? vars[:shipto_business] : "N/A",
        :shipto_first_name  => vars[:shipto_first_name] != nil ? vars[:shipto_first_name] : "N/A",
        :shipto_last_name   => vars[:shipto_last_name] != nil ? vars[:shipto_last_name] : "N/A",
        :shipto_phone     => vars[:shipto_phone] != nil ? vars[:shipto_phone] : "N/A",
        :shipto_address_1 => vars[:shipto_address_1] != nil ? vars[:shipto_address_1] : "N/A",
        :shipto_address_3 => vars[:shipto_address_3] != nil ? vars[:shipto_address_3] : "N/A",
        :shipto_zip       => vars[:shipto_zip] != nil ? vars[:shipto_zip] : "N/A",
        :ccn              => @credit_card,
        :b_fname          => b_fname,
        :b_lname          => b_lname,
        :b_adrs         => b_adrs,
        :b_city         => b_city,
        :b_state        =>  b_state,
        :b_zip          => b_zip,
        #:b_email        => b_email ,
        #:b_phone        =>  b_phone ,
        :payment_type   => (vars[:payment_type] != "Pay_with_a_credit_card")? vars[:payment_type] : vars[:cc_type],
        :admin_name   => vars[:admin_name],
        :person_pic_order => vars[:person_pic_order],
        :delivery_surcharge   => (params[:order_weekend]).to_f,
        :candle_method   => vars[:candle_method],
        :sales_tax      => (params[:sales_tax]).to_f,
        :sales_tax_packaging               => (params[:sales_tax_packaging]).to_f,
        :sales_tax_seasonal_packaging      => (params[:sales_tax_seasonal_packaging]).to_f,
        :order_shipping => (params[:order_shipping]).to_f,
        :order_discount => (params[:order_discount]).to_f,
        :pack_fee       => (params[:order_pack_fee]).to_f,
        :sub_tot        => (params[:order_sub_tot]).to_f,
        :gross_tot      => (params[:order_gross_tot]).to_f,
        :order_total    => (session[:final_order_total][0] ).to_f,
        :no_of_boxes    => params[:no_of_boxes],
        :no_of_sp_cupcakes => vars[:no_of_orders_sp_cake].to_i,
        :tax_rate       => params[:tax_rate].to_f,
        :overridden_by  => (session[:overridden_by] != nil)? session[:overridden_by] : 0,
        :sp_dec_notes   => (vars[:sp_dec_notes] != nil )? vars[:sp_dec_notes] : "",
        :placed_on      => ('\''+ cst.strftime("%Y-%m-%d %H:%M:%S") + '\''),
        :oversize_order_surcharge => vars[:oversize_order_surcharge],
        :mini_sp_decoration => (vars[:has_special_decorations_mini] == "true")? 1 : 0,
        :mini_sp_dec        => @mini_sp_dec_value,
        :mini_sp_dec_notes  => (vars[:sp_dec_notes_mini] != nil )? vars[:sp_dec_notes_mini] : "",
        :no_of_mini_cupcakes => vars[:no_of_orders_cake_mini]
        
      )

    end
   
    t = vars[:date_of_order].to_date
    weekday=t.strftime("%A")


    if (vars[:time_of_order] == "17" || vars[:time_of_order] == "18" || vars[:time_of_order] == "19" || vars[:time_of_order] == "20" )
      slotid=1
    elsif (vars[:time_of_order] == "21" || vars[:time_of_order] == "22" || vars[:time_of_order] == "23" || vars[:time_of_order] == "24" )
      slotid=2
    elsif (vars[:time_of_order] == "25" || vars[:time_of_order] == "26" || vars[:time_of_order] == "27" || vars[:time_of_order] == "28" )
      slotid=3
    elsif (vars[:time_of_order] == "29" || vars[:time_of_order] == "30" || vars[:time_of_order] == "31" || vars[:time_of_order] == "32" )
      slotid=4
    elsif (vars[:time_of_order] == "33" || vars[:time_of_order] == "34" || vars[:time_of_order] == "35" || vars[:time_of_order] == "36" )
      slotid=5
    else (vars[:time_of_order] == "37" || vars[:time_of_order] == "38" || vars[:time_of_order] == "39" || vars[:time_of_order] == "40" || vars[:time_of_order] == "41" )
      slotid=6
    end

    slotid = (vars[:store] == "Uptown Park")? slotid : (slotid + 6)

    maximun_orders=0
    #special_orders = SpecialProdWindow.find(:first, :conditions => ["day=? and prod_win_id=? ", weekday, slotid])
    #if special_orders!=nil
    #maximun_orders = special_orders.max_orders
    #else

    store_id = vars[:store] == "Uptown Park" ? 1 : 2
    special_orders = TimeslotWindow.find(:first, :conditions => ["store_id = ? AND id = ? ", store_id, slotid])

    if weekday == 'Monday'
      maximun_orders = special_orders.mon
    elsif weekday == 'Tuesday'
      maximun_orders = special_orders.tue
    elsif weekday == 'Wednesday'
      maximun_orders = special_orders.wed
    elsif weekday == 'Thursday'
      maximun_orders = special_orders.thu
    elsif weekday == 'Friday'
      maximun_orders = special_orders.fri
    elsif weekday == 'Saturday'
      maximun_orders = special_orders.sat
    elsif weekday == 'Sunday'
      maximun_orders = special_orders.sun
    end

      
    # maximun_orders = special_orders.no_of_orders
    #end

    cup_cake = OrderCount.find(:all , :select=>"SUM(no_of_orders) as total", :conditions=>["store_id = ? AND date = ? AND prod_win_id = ? ", store_id, Time.parse(vars[:date_of_order]), slotid])
    #cup_cake =  OrderItem.find_by_sql("SELECT sum( no_of_orders ) as total_mark FROM order_counts where order_id=2 AND item_type=2" )



    
    possible_value= (maximun_orders.to_i - cup_cake[0].total.to_i)
    @dozens= ((possible_value/12.0)).to_i
    #@dozens= (50/18).to_i
    if session[:user_name]==nil
      if possible_value >= params[:no_of_cupcake].to_i
  
        #save order
        order_saved = @order.save
 
      end
    else
      #save order
      order_saved = @order.save
    end
    #=begin
    if order_saved
       
      # get saved order id
      # order_id = (Order.find(:first, :order => "placed_on DESC")).id
      order_id = @order.id
      # get all prices
      breakfast1  = Price.find(:first, :conditions => ["title = 'breakfast' "])
      if breakfast1 !=nil
        breakfast = breakfast1.price
      else
        breakfast = 0.0
      end

      single1  = Price.find(:first, :conditions => ["title = 'single' "])
      if single1 !=nil
        single = single1.price
      else
        single = 0.0
      end

      #breakfast = Price.find_by_title('breakfast').price
      #single = Price.find_by_title('single').price

      # save specials
      if vars[:specials]
        for one_of_spc in vars[:specials]
          if one_of_spc[0] != ""
            sp_cake = Special.find(:first, :conditions => ["id = ?", one_of_spc[0]])
            OrderItem.new(
              :order_id => order_id,
              :item_id  => one_of_spc[0],
              :qty      => one_of_spc[1],
              :item_title 			=> sp_cake.title,
              :item_description 	=> sp_cake.description,
              :item_type=> 1,
              :price    => sp_cake.price,
              :includes_a_giftbox    => sp_cake.incl_gif_box,
              :cupcakes_exists => (SpecialCupcake.count(:all, :conditions => ["special_id = ?", one_of_spc[0]]) > 0)? 1 : 0
            ).save

            # save cupcakes inside the special
            if one_of_spc[1].to_i != 0
              sp_cupcakes = SpecialCupcake.find(:all, :conditions => ["special_id = ?", one_of_spc[0]])

              for one_of_cup in sp_cupcakes
                cup_cake = Cupcake.find(:first, :conditions => ["id = ?", one_of_cup.cupcake_id])
                OrderItem.new(
                  :order_id => order_id,
                  :item_id  => cup_cake.id,
                  :item_title 			=> cup_cake.title,
                  :item_description 	=> cup_cake.description,
                  :qty      => one_of_cup.qty.to_i * one_of_spc[1].to_i,
                  :item_type=> 4,
                  :price    => cup_cake.is_breakfast ? breakfast : single,
                  :cake => cup_cake.cake ,
                  :is_breakfast => cup_cake.is_breakfast,
                  :is_core => get_core(cup_cake.id)
                ).save
              end
            end
            # end saving cupcakes inside special
          end
        end
      end

      # save cupcakes
      for one_of_cup in vars[:cupcakes]
        if one_of_cup[0] != ""
          cup_cake = Cupcake.find(:first, :conditions => ["id = ?", one_of_cup[0]])
          OrderItem.new(
            :order_id => order_id,
            :item_id  => one_of_cup[0],
            :item_title 			=> cup_cake.title,
            :item_description 	=> cup_cake.description,
            :qty      => one_of_cup[1],
            :item_type=> 2,
            :price    => cup_cake.is_breakfast ? breakfast : single,
            :cake => cup_cake.cake ,
            :is_breakfast => cup_cake.is_breakfast,
            :is_core => get_core(cup_cake.id)
          ).save
        end
      end
      
      # save mini cupcakes
      if vars[:mini_cupcakes]
      for one_of_cup in vars[:mini_cupcakes]
        if one_of_cup[0] != ""
          cup_cake = MiniCupcake.find(:first, :conditions => ["id = ?", one_of_cup[0]])
          OrderItem.new(
            :order_id => order_id,
            :item_id  => one_of_cup[0],
            :item_title 			=> "<b>Mini:</b> "+cup_cake.title,
            :item_description 	=> cup_cake.description,
            :qty      => one_of_cup[1],
            :item_type=> 5,
            :price    => @mini_dozen,
            :cake => cup_cake.cake ,
            :is_core => get_core_mini(cup_cake.id)
          ).save
        end
      end
      end

      #save no_of_orders

      if one_of_cup[0] != ""
        store_id = vars[:store] == "Uptown Park" ? 1 : 2
        OrderCount.new(
          :date         => Time.parse(vars[:date_of_order]) ,
          :order_id     => order_id,
          :prod_win_id  => slotid,
          :no_of_orders => params[:no_of_cupcake],
          :store_id     => store_id
        ).save
      end

      # save other products
      for one_product in vars[:products]
        if one_product[0] != ""
          product = Product.find(:first, :conditions => ["id = ?", one_product[0]])
          OrderItem.new(
            :order_id => order_id,
            :item_id  => one_product[0],
            :qty      => one_product[1],
        		:item_title 			=> product.title + ((product.exclude_tax == true)? " (No Tax)" : ""),
            #:item_description 	=> product.description,
            :item_type=> 3,
            :price    => product.price
          ).save
        end
      end

    end
    #=end
    a[0] = order_saved
    a[1] = @order.errors
    #a[2] = " <br> Given our current bookings, we are unable to fulfill your order at the selected time. We can produce a maximum of " + @dozens.to_s + " dozen(s) cupcakes at that time."
    a[2] = "We can produce a maximum of " + @dozens.to_s + " dozen(s) cupcakes at that time."
    a[3] = order_id
    
    return a
  end


  def get_cc_name(val)
    if val == "visa"
      return "VISA"
    elsif val == "master"
      return "MasterCard"
    elsif val == "american_express"
      return "American Express"
    elsif val == "Discover"
      return "Discover"
    end
  end

  def get_full_month_name(val)
    if val == "1"
      return "January"
    elsif val == "2"
      return "February"
    elsif val == "3"
      return "March"
    elsif val == "4"
      return "April"
    elsif val == "5"
      return "May"
    elsif val == "6"
      return "June"
    elsif val == "7"
      return "July"
    elsif val == "8"
      return "August"
    elsif val == "9"
      return "September"
    elsif val == "10"
      return "October"
    elsif val == "11"
      return "November"
    elsif val == "12"
      return "December"
    end
  end

  def privacy			
    render :file => RAILS_ROOT + "/public/privacy.html"
    return false
  end
    
  def special_decorations			
    render :file => RAILS_ROOT + "/public/special_decorations.html"
    return false
	end

  def mini_special_decorations
    render :file => RAILS_ROOT + "/public/mini_special_decorations.html"
    return false
	end

  def special_decorations_download
    render :file => RAILS_ROOT + "/public/special_decorations_download.html"
    return false
	end

  def get_core(val)
    count = CupcakesDay.find(:all, :select => "count(*) AS c ", :conditions => ["cupcake_id = ?", val], :group => "cupcake_id")

    return (count[0].c.to_i == 7)? 1 : 0
  end
  
  def get_core_mini(val)
    count = MiniCupcakesDay.find(:all, :select => "count(*) AS c ", :conditions => ["mini_cupcake_id = ?", val], :group => "mini_cupcake_id")

    return (count[0].c.to_i == 7)? 1 : 0
  end

  def save_promotional_email(vars)
    PromotionalEmail.new(
      :fname => vars[:first_name],
      :lname => vars[:last_name],
      :email => vars[:email]
		).save
  end
end



