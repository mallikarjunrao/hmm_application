class Ownify::SpecialProdWindowsController < LoginController
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
    if get_access_level != 1
      access_denied
    else
      #@date=Date.today
    
      #@timeslot = SpecialProdWindow .find(:all, :order =>  " prod_win_id ASC", :page => { :size => 5, :current => params[:page] })
      @timeslot = SpecialProdWindow .find(:all, :order => "day='Monday' DESC,day='Tuesday' DESC,day='Wednesday' DESC,day='Thursday' DESC,day='Friday' DESC,day='Saturday' DESC, day='Sunday' DESC, prod_win_id ASC", :page => { :size => 5, :current => params[:page] })
    end
    
  end

  def new
    if get_access_level != 1
      access_denied
    else
      @day_types=Day.select_options
      @time_types=TimeslotWindow.select_options
      @timeslot = SpecialProdWindow.new
    end
    
  end

  def create

   # params[:cupcake][:cutoff_date]= params[:cupcake][:cutoff_date].to_time(:local)
    @cupcake = SpecialProdWindow.new(params[:cupcake])
    if @cupcake.save
      flash[:notice] = 'Special production window was successfully created.'
						expire_all_pages
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    if get_access_level != 1
      access_denied
    else
      @day_types=Day.select_options
      @time_types=TimeslotWindow.select_options
      @cupcake = SpecialProdWindow.find(params[:id])
    end
    
  end

  def update
    @price = SpecialProdWindow.find(params[:id])
    if @price.update_attributes(params[:cupcake])
      flash[:notice] = 'Time Slot was successfully updated.'
						expire_cupcakes
      redirect_to :action => 'list', :id => @price
    else
      render :action => 'edit'
    end
  end

  def destroy
    SpecialProdWindow.find(params[:id]).destroy
				expire_all_pages
    redirect_to :action => 'list'
  end
end
