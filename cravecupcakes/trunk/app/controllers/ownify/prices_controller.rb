class Ownify::PricesController < LoginController
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
      @price_pages, @prices = paginate :prices, :per_page => 30
    end    
  end

  def new
    if get_access_level != 1
      access_denied
    else
      @price = Price.new
    end    
  end

  def create
    @price = Price.new(params[:price])
    if @price.save
      flash[:notice] = 'Price was successfully created.'
						expire_cupcakes
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    if get_access_level != 1
      access_denied
    else
      @price = Price.find(params[:id])
    end    
  end

  def update
    @price = Price.find(params[:id])
    if @price.update_attributes(params[:price])
      flash[:notice] = 'Price was successfully updated.'
						expire_cupcakes
      redirect_to :action => 'list', :id => @price
    else
      render :action => 'edit'
    end
  end

  def destroy
    Price.find(params[:id]).destroy
				expire_cupcakes
    redirect_to :action => 'list'
  end
end
