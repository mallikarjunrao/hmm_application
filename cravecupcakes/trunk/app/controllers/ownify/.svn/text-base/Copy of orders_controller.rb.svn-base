class Ownify::OrdersController < LoginController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
    :redirect_to => { :action => :list }

  def list

#    @orders = Order.find(:all, :order =>  "placed_on desc")
    @order_page, @orders = paginate :orders, :per_page => 20, :order =>  "date_of_order  desc, time_of_order desc"
    @order_times = ["Select"] + HALF_HOUR_TIMES[ DEFAULT_START .. DEFAULT_END ]

  end

  def show
    @one_order =Order.find(params[:id])
   @order_items = OrderItem.find(:all,:conditions=>["order_id=?",params[:id]])
   @order_times = ["Select"] + HALF_HOUR_TIMES[ DEFAULT_START .. DEFAULT_END ]
   
  end

  def destroy
    p = Order.find(params[:id])
    p.destroy
    redirect_to :action => 'list'
  end
end
