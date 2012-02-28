class Ownify::OrdersController < LoginController
	def index
		if get_access_level == 3
			access_denied
		else
			list
			render :action => 'list'
		end    
	end

	# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
	verify :method => :post, :only => [ :destroy, :create, :update ], :redirect_to => { :action => :list }

	#def set_filter(par, key)
	#	session[:filters][key] = par[key]
	#end

	def list
		if get_access_level == 3
			access_denied
		else

      @access_l = get_access_level

			if params[:reset] == "Reset"
				session[:store_id] = nil
				session[:delivery_method] = nil
				session[:payment_type] = nil
				session[:query] = nil
				session[:sort_col] = "id"
				session[:sort_order] = "desc"
				session[:start_date_1] = nil
				session[:end_date_1] = nil
				session[:start_date_2] = nil
				session[:end_date_2] = nil
			else
				session[:store_id] = params[:store_id]					if params[:store_id] != nil
				session[:delivery_method] = params[:delivery_method]		if params[:delivery_method] != nil
				session[:payment_type] = params[:payment_type]			if params[:payment_type] != nil
				session[:query] = params[:query]					if params[:query] != nil
				session[:sort_col] = params[:sort_col] 					if params[:sort_col] != nil
				session[:sort_order] = params[:sort_order] 				if params[:sort_order] != nil
				session[:start_date_1] = params[:start_date_1] 			if (params[:start_date_1] != nil && params[:start_date_1] != "")
				session[:end_date_1] = params[:end_date_1] 			if (params[:end_date_1] != nil && params[:end_date_1] != "")
				session[:start_date_2] = params[:start_date_2] 			if (params[:start_date_2] != nil && params[:start_date_2] != "")
				session[:end_date_2] = params[:end_date_2] 			if (params[:end_date_2] != nil && params[:end_date_2] != "")
			end
=begin
			if Date.parse(session[:start_date_1]) > Date.parse(session[:end_date_1])
				session[:end_date_1] = session[:start_date_1]
			end
			if Date.parse(session[:start_date_2]) > Date.parse(session[:end_date_2])
				session[:end_date_2] = session[:start_date_2]
			end
=end
			if session[:sort_col] == nil
				session[:sort_col] = "id"
				session[:sort_order] = "desc"
			end
			cond = ""
			if session[:store_id] != nil && session[:store_id] != ""
				cond += " AND " if cond != ""
				cond += "store_id = "+session[:store_id]
			end
			if session[:delivery_method] != nil && session[:delivery_method] != ""
				cond += " AND " if cond != ""
				cond += "delivery_method = '"+session[:delivery_method]+"'"
			end
			if session[:payment_type] != nil && session[:payment_type] != ""
				cond += " AND " if cond != ""
				cond += "payment_type = '"+session[:payment_type]+"'"
			end
			if session[:start_date_1] != nil && session[:start_date_1] != "" && session[:end_date_1] != nil && session[:end_date_1] != ""
				cond += " AND " if cond != ""
				cond += "date(placed_on) >= '"+session[:start_date_1]+"' AND date(placed_on) <= '"+session[:end_date_1]+"'"
			end
			if session[:start_date_2] != nil && session[:start_date_2] != "" && session[:end_date_2] != nil && session[:end_date_2] != ""
				cond += " AND " if cond != ""
				cond += "date_of_order >= '"+session[:start_date_2]+"' AND date_of_order <= '"+session[:end_date_2]+"'"
			end
			if session[:query] != nil && session[:query] != ""
				query = session[:query].gsub("'", "''")
				cond += " AND " if cond != ""
				cond += "(first_name LIKE '%"+query+"%' OR " +
						"last_name LIKE '%"+query+"%' OR " +
						"b_fname LIKE '%"+query+"%' OR " +
						"b_lname LIKE '%"+query+"%' OR " +
						"primary_phone LIKE '%"+query+"%' OR " +
						"alt_phone LIKE '%"+query+"%')"
			end
			if cond == ""
				cond = nil
			end
=begin
			@c = cond
			#@orders = Order.find(:all, :order =>  "placed_on desc")
			#@order_page, @orders = paginate :o @orders = Order.find(:all, :order => rders, :per_page => 20, :order =>  "date_of_order  desc, time_of_order desc"
			#@orders = Order.find(:all, :order =>  "id DESC, date_of_order  desc, time_of_order desc", :page => { :size => 20, :current => params[:page] })
=end
			@sort_col = session[:sort_col]
			if @sort_col == "date_of_order"
				@sort_col = "date_of_order "+session[:sort_order]+", time_of_order"
			end
			if cond != nil
				@orders = Order.find(:all, :order =>  [@sort_col + " " + session[:sort_order]], :conditions => cond, 	:page => { :size => 20, :current => params[:page] })
			else
				@orders = Order.find(:all, :order =>  [@sort_col + " " + session[:sort_order]], 				:page => { :size => 20, :current => params[:page] })
			end
			#@orders = Order.find(:all, :page => { :size => 20, :current => params[:page] })
			#@orders = Order.find(:all, :order =>  [name + " " + order], :conditions => cond, :page => { :size => 20, :current => params[:page] })
			@order_times = ["Select"] + HALF_HOUR_TIMES[ DEFAULT_START .. DEFAULT_END ]
		end
	end

	def show
		if get_access_level == 3
			access_denied
		else
			@one_order =Order.find(params[:id])
			# @order_items = OrderItem.find(:all,:conditions=>["order_id=?",params[:id]])
			@order_items = OrderItem.find(:all,:conditions=>["order_id=? AND item_type != 3",params[:id]], :order => "item_type = 2  DESC, item_type = 2  DESC")

      @order_items_mini_cupcakes = OrderItem.find(:all,:conditions=>["order_id=? AND item_type = 5",params[:id]], :order => "item_title ASC")

			@order_items_cupcakes = OrderItem.find(:all,:conditions=>["order_id=? AND item_type = 2",params[:id]], :order => "item_title ASC")
			@order_items_products = OrderItem.find(:all,:conditions=>["order_id=? AND item_type = 3",params[:id]], :order => "item_title ASC")
			@seasonal_items = OrderItem.find(:all,:conditions=>["order_id=? AND item_type = 1", params[:id]], :order => "item_type = 1  DESC")
			@order_times = ["Select"] + HALF_HOUR_TIMES[ DEFAULT_START .. DEFAULT_END ]
		end
	end

	def destroy

		if get_access_level != 1
			access_denied
		else

			p = Order.find(params[:id])
			p.destroy
	
			c = OrderCount.find(:first, :conditions => ["order_id = ?", params[:id]])
			c.destroy	
	
			items = OrderItem.find(:all, :conditions => ["order_id = ?", params[:id]])
			for item in items
				item.destroy
			end	
	
			redirect_to :action => 'list'
		end
	end
end
