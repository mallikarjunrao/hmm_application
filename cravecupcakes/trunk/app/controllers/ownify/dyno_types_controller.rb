class Ownify::DynoTypesController < LoginController
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
      @dyno_type_pages, @dyno_types = paginate :dyno_types, :per_page => 10
    end    
  end

  def show
    if get_access_level != 1
      access_denied
    else
      @dyno_type = DynoType.find(params[:id])
    end    
  end

  def new
    if get_access_level != 1
      access_denied
    else
      @dyno_type = DynoType.new
    end    
  end

  def create
    @dyno_type = DynoType.new(params[:dyno_type])
    if @dyno_type.save
      flash[:notice] = 'DynoType was successfully created.'
						expire_dyno_pages
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    if get_access_level != 1
      access_denied
    else
      @dyno_type = DynoType.find(params[:id])
    end    
  end

  def update
    @dyno_type = DynoType.find(params[:id])
    if @dyno_type.update_attributes(params[:dyno_type])
      flash[:notice] = 'DynoType was successfully updated.'
						expire_dyno_pages
      redirect_to :action => 'show', :id => @dyno_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    @dyno_type = DynoType.find(params[:id])
				expire_dyno_pages
    @dyno_type.destroy
    redirect_to :action => 'list'
  end
end
