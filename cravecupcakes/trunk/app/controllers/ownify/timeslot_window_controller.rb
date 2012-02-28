class Ownify::TimeslotWindowController < LoginController
  def index
    if get_access_level != 1
      access_denied
    else
      list
      render :action => 'list'
    end
    
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list

    store_id = (params[:store_id] != nil)? params[:store_id] : 1

    if get_access_level != 1
      access_denied
    else
      #@date=Date.today
      @timeslot = TimeslotWindow .find(:all, :order => "id", :conditions => ["store_id = ?", store_id], :page => { :size => 6, :current => params[:page] })
    end
    
    
  end

#  def new
#    @cupcake = Cupcake.new
#  end
#
#  def create
#
#   # params[:cupcake][:cutoff_date]= params[:cupcake][:cutoff_date].to_time(:local)
#    @cupcake = Cupcake.new(params[:cupcake])
#    if @cupcake.save
#      flash[:notice] = 'Cupcake was successfully created.'
#						expire_all_pages
#      redirect_to :action => 'list'
#    else
#      render :action => 'new'
#    end
#  end

  def edit
    if get_access_level != 1
      access_denied
    else
      @cupcake = TimeslotWindow.find(params[:id])
    end
    
  end

  def update
    @price = TimeslotWindow.find(params[:id])
    if @price.update_attributes(params[:cupcake])
      flash[:notice] = 'Time Slot was successfully updated.'
						expire_cupcakes

      if params[:id].to_i < 7
        redirect_to :action => 'list', :id => @price, :store_id => "1"
      else
        redirect_to :action => 'list', :id => @price, :store_id => "2"
      end

      #redirect_to :action => 'list', :id => @price

    else
      render :action => 'edit'
    end
  end

  def destroy
    TimeslotWindow.find(params[:id]).destroy
				expire_all_pages
    redirect_to :action => 'list'
  end
end
