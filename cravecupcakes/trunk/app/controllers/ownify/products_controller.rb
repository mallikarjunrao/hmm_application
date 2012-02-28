class Ownify::ProductsController < LoginController
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
      @product_types=ProductType.select_options
        if params[:product_type_id]
          session[:product_type_id] = params[:product_type_id]
          @product_type=ProductType.find(params[:product_type_id])
          @products = Product.find(:all, :conditions => {:product_type_id => params[:product_type_id]}, :order =>  "title")
        end
    end				
  end

  def new
    if get_access_level != 1
      access_denied
    else
      @product_types=ProductType.select_options
      @product = Product.new
      if params[:product_type_id]
          @product_type=ProductType.find(params[:product_type_id])
          @product.product_type_id= params[:product_type_id]
      end
    end		
  end

  def create
    @product = Product.new(params[:product])
    if @product.save
      flash[:notice] = 'Product was successfully created.'
      redirect_to :action => 'list', :product_type_id => @product.product_type_id
    else
				  @product_types=ProductType.select_options
      render :action => 'new'
    end
  end

  def edit
    if get_access_level != 1
      access_denied
    else
        @product_types=ProductType.select_options
        @product = Product.find(params[:id])
    end				
  end

  def update
    @product = Product.find(params[:id])
    #if params[:product][:exclude_tax] == "on"
    #  params[:product][:exclude_tax] = 1
    #else
    #  params[:product][:exclude_tax] = 0
    #end
    if @product.update_attributes(params[:product])
      flash[:notice] = 'Product was successfully updated.'
      redirect_to :action => 'list', :product_type_id => @product.product_type_id
    else
      @product_types=ProductType.select_options
      render :action => 'edit'
    end
  end

  def destroy
		  p = Product.find(params[:id])
				ptid = p.product_type_id
    p.destroy
    redirect_to :action => 'list', :product_type_id => ptid
  end
end
