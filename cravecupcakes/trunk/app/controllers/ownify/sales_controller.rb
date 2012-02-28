class Ownify::SalesController < LoginController
  def index
    
    if get_access_level == 3
      access_denied
    else
      #get_orders
      render :action => 'index'
    end    
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  #def get_orders
    #@orders = Order.find(:all, :order => "date_of_order", :page => { :size => 30, :current => params[:page] })
  #end

  def get_ext_report

    if get_access_level == 3
      access_denied
    else
        if params[:sales_date] != nil
          session[:sales_date] = params[:sales_date]
        end        
                
        if params[:store_id] != nil
          session[:store_id] = params[:store_id]
        end
        
        #@ids = Order.find(:all,:select => "id", :order => "payment_type ASC", :conditions => ["store_id = '1' AND (date_of_order = '" + prev_day + "' AND time_of_order > 35) OR (date_of_order = '" + session[:sales_date] + "' AND time_of_order < 36)", store_id])

        arg_item_type = "((item_type = 2) OR (item_type = 1))"

        @cupcakes_visa = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'VISA')        
        @cupcakes_mc = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'MasterCard')
        @cupcakes_ae = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'American Express')
        @cupcakes_discover = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'Discover')

        @cupcakes_prepaid_creditcard = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'prepaid_creditcard')
        @cupcakes_prepaid_cash = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'prepaid_cash')
        @cupcakes_no_charge = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'no_charge')
        @cupcakes_payment_on_delivery = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'payment_on_delivery')
        @cupcakes_Pay_with_a_CRAVE_gift_card = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'Pay_with_a_CRAVE_gift_card')
        @cupcakes_emp_payment_at_pos = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'emp_payment_at_pos')

        arg_item_type = "item_type = 5"

        @cupcakes_visa_mini = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'VISA')
        @cupcakes_mc_mini = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'MasterCard')
        @cupcakes_ae_mini = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'American Express')
        @cupcakes_discover_mini = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'Discover')

        @cupcakes_prepaid_creditcard_mini = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'prepaid_creditcard')
        @cupcakes_prepaid_cash_mini = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'prepaid_cash')
        @cupcakes_no_charge_mini = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'no_charge')
        @cupcakes_payment_on_delivery_mini = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'payment_on_delivery')
        @cupcakes_Pay_with_a_CRAVE_gift_card_mini = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'Pay_with_a_CRAVE_gift_card')
        @cupcakes_emp_payment_at_pos_mini = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'emp_payment_at_pos')

        arg_item_type = "((item_type = 3) OR (item_type = 1 AND includes_a_giftbox = 1))"

        @retail_visa = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'VISA')
        @retail_mc = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'MasterCard')
        @retail_ae = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'American Express')
        @retail_discover = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'Discover')

        @retail_prepaid_creditcard = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'prepaid_creditcard') 
        @retail_prepaid_cash = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'prepaid_cash')
        @retail_no_charge = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'no_charge')
        @retail_payment_on_delivery = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'payment_on_delivery')
        @retail_Pay_with_a_CRAVE_gift_card = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'Pay_with_a_CRAVE_gift_card')
        @retail_emp_payment_at_pos = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'emp_payment_at_pos')

        @other_visa = get_other_data_within_the_day(session[:store_id], session[:sales_date], 'VISA') 
        @other_mc = get_other_data_within_the_day(session[:store_id], session[:sales_date], 'MasterCard')
        @other_ae = get_other_data_within_the_day(session[:store_id], session[:sales_date], 'American Express')
        @other_discover = get_other_data_within_the_day(session[:store_id], session[:sales_date], 'Discover')
        
        @other_prepaid_creditcard = get_other_data_within_the_day(session[:store_id], session[:sales_date], 'prepaid_creditcard')
        @other_prepaid_cash = get_other_data_within_the_day(session[:store_id], session[:sales_date], 'prepaid_cash')
        @other_no_charge = get_other_data_within_the_day(session[:store_id], session[:sales_date], 'no_charge')
        @other_payment_on_delivery = get_other_data_within_the_day(session[:store_id], session[:sales_date], 'payment_on_delivery')
        @other_Pay_with_a_CRAVE_gift_card = get_other_data_within_the_day(session[:store_id], session[:sales_date], 'Pay_with_a_CRAVE_gift_card')
        @other_emp_payment_at_pos = get_other_data_within_the_day(session[:store_id], session[:sales_date], 'emp_payment_at_pos')
        
        @s_cupcakes = get_no_of_cupcakes_within_the_day_extended(session[:store_id], session[:sales_date], '2')
        @cupcakes_in_seasonals = get_no_of_cupcakes_within_the_day_extended(session[:store_id], session[:sales_date], '4')
        @mini_cupcakes = get_no_of_cupcakes_within_the_day_extended(session[:store_id], session[:sales_date], '5')
        @sp_boxes = get_no_of_seasoanls_incl_cupcakes_within_the_day_extended(session[:store_id], session[:sales_date])

        render :action => 'ext_report'
        
    end
  end

  def get_report

    if get_access_level == 3
      access_denied
    else
        if params[:sales_date] != nil
          session[:sales_date] = params[:sales_date]
        end

        if params[:store_id] != nil
          session[:store_id] = params[:store_id]
        end

        #@ids = Order.find(:all,:select => "id", :order => "payment_type ASC", :conditions => ["store_id = '1' AND (date_of_order = '" + prev_day + "' AND time_of_order > 35) OR (date_of_order = '" + session[:sales_date] + "' AND time_of_order < 36)", store_id])

        arg_item_type = "((item_type = 2) OR (item_type = 1))"

        @cupcakes_visa = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'VISA')
        @cupcakes_mc = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'MasterCard')
        @cupcakes_ae = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'American Express')
        @cupcakes_discover = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'Discover')

        #@cupcakes_prepaid_creditcard = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'prepaid_creditcard')
        #@cupcakes_prepaid_cash = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'prepaid_cash')
        #@cupcakes_no_charge = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'no_charge')
        #@cupcakes_payment_on_delivery = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'payment_on_delivery')
        #@cupcakes_Pay_with_a_CRAVE_gift_card = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'Pay_with_a_CRAVE_gift_card')


        arg_item_type = "item_type = 5"

        @cupcakes_visa_mini = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'VISA')
        @cupcakes_mc_mini = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'MasterCard')
        @cupcakes_ae_mini = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'American Express')
        @cupcakes_discover_mini = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'Discover')


        arg_item_type = "((item_type = 3) OR (item_type = 1 AND includes_a_giftbox = 1))"

        @retail_visa = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'VISA')
        @retail_mc = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'MasterCard')
        @retail_ae = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'American Express')
        @retail_discover = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'Discover')

        #@retail_prepaid_creditcard = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'prepaid_creditcard')
        #@retail_prepaid_cash = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'prepaid_cash')
        #@retail_no_charge = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'no_charge')
        #@retail_payment_on_delivery = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'payment_on_delivery')
        #@retail_Pay_with_a_CRAVE_gift_card = get_products_within_the_day(session[:store_id], session[:sales_date], arg_item_type, 'Pay_with_a_CRAVE_gift_card')

        @other_visa = get_other_data_within_the_day(session[:store_id], session[:sales_date], 'VISA')
        @other_mc = get_other_data_within_the_day(session[:store_id], session[:sales_date], 'MasterCard')
        @other_ae = get_other_data_within_the_day(session[:store_id], session[:sales_date], 'American Express')
        @other_discover = get_other_data_within_the_day(session[:store_id], session[:sales_date], 'Discover')

        #@other_prepaid_creditcard = get_other_data_within_the_day(session[:store_id], session[:sales_date], 'prepaid_creditcard')
        #@other_prepaid_cash = get_other_data_within_the_day(session[:store_id], session[:sales_date], 'prepaid_cash')
        #@other_no_charge = get_other_data_within_the_day(session[:store_id], session[:sales_date], 'no_charge')
        #@other_payment_on_delivery = get_other_data_within_the_day(session[:store_id], session[:sales_date], 'payment_on_delivery')
        #@other_Pay_with_a_CRAVE_gift_card = get_other_data_within_the_day(session[:store_id], session[:sales_date], 'Pay_with_a_CRAVE_gift_card')

        @s_cupcakes = get_no_of_cupcakes_within_the_day_standard(session[:store_id], session[:sales_date], '2')
        @cupcakes_in_seasonals = get_no_of_cupcakes_within_the_day_standard(session[:store_id], session[:sales_date], '4')
        @mini_cupcakes = get_no_of_cupcakes_within_the_day_standard(session[:store_id], session[:sales_date], '5')
        @sp_boxes = get_no_of_seasoanls_incl_cupcakes_within_the_day_standard(session[:store_id], session[:sales_date])

        render :action => 'report'

    end
  end

  def get_products_within_the_day(store_id, sales_day, item_type, payment_type)

    @prev_day = Date.parse(sales_day.to_s)
    @prev_day = @prev_day - 1
    prev_day = @prev_day.year.to_s + "-" + @prev_day.strftime("%m").to_s + "-" + @prev_day.strftime("%d")
    return OrderItem.find(
        :all,
        :select => "item_id, item_title, CONCAT(item_id, item_title) AS gro, IF(item_type=5, ROUND(SUM(qty)/24, 0), SUM(qty)) AS p_total, item_type, price, includes_a_giftbox",
        :order => "item_type = 2 DESC, item_type = 1 DESC, item_type = 3 DESC, item_title ASC",
        :group => "gro",
        :conditions => "
            order_id IN (
                SELECT id FROM orders
                WHERE store_id = " + store_id + " AND
                      ((DATE(placed_on) = '" + prev_day + "' AND TIME(placed_on) >= '18:00:00') OR
                      (DATE(placed_on) = '" + sales_day + "' AND TIME(placed_on) <= '17:59:59')) AND
                      payment_type = '" + payment_type + "'
            ) AND " + item_type
      )
  end
    
    
  def get_other_data_within_the_day(store_id, sales_day, payment_type)

    @prev_day = Date.parse(sales_day.to_s)
    @prev_day = @prev_day - 1
    prev_day = @prev_day.year.to_s + "-" + @prev_day.strftime("%m").to_s + "-" + @prev_day.strftime("%d")
    return Order.find(
        :all,
        :select => "
          sum(sales_tax) AS sales_tax,
          SUM(sales_tax_packaging) AS sales_tax_packaging,
          SUM(delivery_surcharge) AS delivery_surcharge,
          SUM(oversize_order_surcharge) AS oversize_order_surcharge,
          SUM(order_discount) AS order_discount,
          SUM(sales_tax_seasonal_packaging) AS sales_tax_seasonal_packaging,
          SUM(pack_fee) AS pack_fee,
          SUM(order_shipping) AS order_shipping
        ",
        :conditions => "
            store_id = " + store_id + " AND
            ((DATE(placed_on) = '" + prev_day + "' AND TIME(placed_on) >= '18:00:00') OR
            (DATE(placed_on) = '" + sales_day + "' AND TIME(placed_on) <= '17:59:59')) AND
            payment_type = '" + payment_type + "'" )          
      
  end

  def get_no_of_cupcakes_within_the_day_standard(store_id, sales_day, item_type)

    @prev_day = Date.parse(sales_day.to_s)
    @prev_day = @prev_day - 1
    prev_day = @prev_day.year.to_s + "-" + @prev_day.strftime("%m").to_s + "-" + @prev_day.strftime("%d")
    return OrderItem.find(
        :first,
        :select => "SUM(qty) AS total",
        :conditions => "
            order_id IN (
                SELECT id FROM orders
                WHERE store_id = " + store_id + " AND
                      ((DATE(placed_on) = '" + prev_day + "' AND TIME(placed_on) >= '18:00:00') OR
                      (DATE(placed_on) = '" + sales_day + "' AND TIME(placed_on) <= '17:59:59')) AND
                      payment_type IN ('VISA', 'MasterCard', 'American Express', 'Discover')
            ) AND item_type = " + item_type
      )

  end
  
  def get_no_of_seasoanls_incl_cupcakes_within_the_day_standard(store_id, sales_day)

    @prev_day = Date.parse(sales_day.to_s)
    @prev_day = @prev_day - 1
    prev_day = @prev_day.year.to_s + "-" + @prev_day.strftime("%m").to_s + "-" + @prev_day.strftime("%d")
    return OrderItem.find(
        :first,
        :select => "SUM(qty) AS total",
        :conditions => "
            order_id IN (
                SELECT id FROM orders
                WHERE store_id = " + store_id + " AND
                      ((DATE(placed_on) = '" + prev_day + "' AND TIME(placed_on) >= '18:00:00') OR
                      (DATE(placed_on) = '" + sales_day + "' AND TIME(placed_on) <= '17:59:59')) AND
                      payment_type IN ('VISA', 'MasterCard', 'American Express', 'Discover')
            ) AND item_type = 1 AND  cupcakes_exists = 1"
      )

  end
  
  def get_no_of_cupcakes_within_the_day_extended(store_id, sales_day, item_type)

    @prev_day = Date.parse(sales_day.to_s)
    @prev_day = @prev_day - 1
    prev_day = @prev_day.year.to_s + "-" + @prev_day.strftime("%m").to_s + "-" + @prev_day.strftime("%d")
    return OrderItem.find(
        :first,
        :select => "SUM(qty) AS total",
        :conditions => "
            order_id IN (
                SELECT id FROM orders
                WHERE store_id = " + store_id + " AND
                      ((DATE(placed_on) = '" + prev_day + "' AND TIME(placed_on) >= '18:00:00') OR
                      (DATE(placed_on) = '" + sales_day + "' AND TIME(placed_on) <= '17:59:59')) AND
                      payment_type IN ('VISA', 'MasterCard', 'American Express', 'Discover', 'prepaid_creditcard', 'prepaid_cash', 'no_charge', 'payment_on_delivery', 'Pay_with_a_CRAVE_gift_card')
            ) AND item_type = " + item_type
      )

  end
  
  def get_no_of_seasoanls_incl_cupcakes_within_the_day_extended(store_id, sales_day)

    @prev_day = Date.parse(sales_day.to_s)
    @prev_day = @prev_day - 1
    prev_day = @prev_day.year.to_s + "-" + @prev_day.strftime("%m").to_s + "-" + @prev_day.strftime("%d")
    return OrderItem.find(
        :first,
        :select => "SUM(qty) AS total",
        :conditions => "
            order_id IN (
                SELECT id FROM orders
                WHERE store_id = " + store_id + " AND
                      ((DATE(placed_on) = '" + prev_day + "' AND TIME(placed_on) >= '18:00:00') OR
                      (DATE(placed_on) = '" + sales_day + "' AND TIME(placed_on) <= '17:59:59')) AND
                      payment_type IN ('VISA', 'MasterCard', 'American Express', 'Discover', 'prepaid_creditcard', 'prepaid_cash', 'no_charge', 'payment_on_delivery', 'Pay_with_a_CRAVE_gift_card')
            ) AND  item_type = 1 AND  cupcakes_exists = 1"
      )

  end

end