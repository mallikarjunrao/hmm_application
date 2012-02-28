class Ownify::BakeSheetController < LoginController
  def index
    
    if get_access_level == 3
      access_denied
    else      
      tomorrow = Time.now + 3600*24
      params[:date_1] = tomorrow.year.to_s + "-" + tomorrow.strftime("%m").to_s + "-" + tomorrow.strftime("%d")
      get_report
    end    
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  #def get_orders
    #@orders = Order.find(:all, :order => "date_of_order", :page => { :size => 30, :current => params[:page] })
  #end

  def get_report

    if get_access_level == 3
      access_denied
    else
        if params[:date_1] != nil
          session[:date_1] = params[:date_1]
        end
        if params[:date_2] != nil
          session[:date_2] = params[:date_2]
        end

        if params[:store_id] != nil
          session[:store_id] = params[:store_id]
        end
        store_id = session[:store_id]

        @dates = Order.find(:all,:select => "DISTINCT date_of_order", :order => "date_of_order, time_of_order", :conditions =>["store_id = ? AND date_of_order = ?", store_id, session[:date_1]])

        if @dates.empty? == false
           params[:date] = session[:date_1]#(params[:date] == nil)? @dates[0].date_of_order : params[:date]
           render :action => 'report'
        else
          @msg = "No orders placed for this date."
          render :action => "index"
        end
    end
  end
end