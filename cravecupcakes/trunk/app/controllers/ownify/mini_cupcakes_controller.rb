class Ownify::MiniCupcakesController < LoginController
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
      @date=Date.today
      @cupcakes = MiniCupcake.find(:all, :order => "title", :page => { :size => 30, :current => params[:page] })
    end    
  end

  def new
    if get_access_level != 1
      access_denied
    else
      @cupcake = MiniCupcake.new
    end    
  end

  def create

   # params[:cupcake][:cutoff_date]= params[:cupcake][:cutoff_date].to_time(:local)
    @cupcake = MiniCupcake.new(params[:cupcake])
    if @cupcake.save
      flash[:notice] = 'Mini Cupcake was successfully created.'
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
      @cupcake = MiniCupcake.find(params[:id])
    end    
  end

  def update
		  params[:cupcake][:day_ids] ||= []

    @cupcake = MiniCupcake.find(params[:id])
    if @cupcake.update_attributes(params[:cupcake])
      flash[:notice] = 'Mini Cupcake was successfully updated.'
						expire_cupcakes
      redirect_to :action => 'list', :id => @cupcake
    else
      render :action => 'edit'
    end
  end

  def destroy
    MiniCupcake.find(params[:id]).destroy

	expire_all_pages
    redirect_to :action => 'list'
    
  end
end
