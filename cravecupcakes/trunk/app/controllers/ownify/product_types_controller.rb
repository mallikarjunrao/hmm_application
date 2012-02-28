class Ownify::ProductTypesController < LoginController
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
      @product_types = ProductType.find(:all, :order => 'position')
    end    
  end

  def order
    if get_access_level != 1
      access_denied
    else
      params[:sort_list].each_with_index { |id,idx| ProductType.update(id, :position => idx) }
      @product_types = ProductType.find(:all, :order => 'position')
      render :layout => false, :partial => "order"
    end    
  end

  def new
    if get_access_level != 1
      access_denied
    else
      @product_type = ProductType.new
    end    
  end

  def create
    @product_type = ProductType.new(params[:product_type])
    if @product_type.save
      flash[:notice] = 'Product Type was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    if get_access_level != 1
      access_denied
    else
      @product_type = ProductType.find(params[:id])
    end    
  end

  def update
    @product_type = ProductType.find(params[:id])
    if @product_type.update_attributes(params[:product_type])
      flash[:notice] = 'Product Type was successfully updated.'
      redirect_to :action => 'list', :id => @product_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    ProductType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
