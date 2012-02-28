class Ownify::DynoPagesController < LoginController
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
      @dyno_types=DynoType.select_options
      if params[:dyno_type_id]
					@dyno_type=DynoType.find(params[:dyno_type_id])
					@dyno_pages = DynoPage.find(:all, :conditions => {:dyno_type_id => params[:dyno_type_id]}, :order =>  "page_on desc")
			end
    end			
  end

  def show
    if get_access_level != 1
      access_denied
    else
      @dyno_page = DynoPage.find(params[:id])
    end    
  end

  def new
    if get_access_level != 1
      access_denied
    else
        @dyno_types=DynoType.select_options
        @dyno_page = DynoPage.new
        if params[:dyno_type_id]
						@dyno_page.dyno_type_id= params[:dyno_type_id]
				end
    end				
  end

  def create
    @dyno_page = DynoPage.new(params[:dyno_page])
    if @dyno_page.save
						expire_dyno_pages
      flash[:notice] = 'DynoPage was successfully created.'
      redirect_to :action => 'list', :dyno_type_id => @dyno_page.dyno_type_id
    else
				  @dyno_types=DynoType.select_options
      render :action => 'new'
    end
  end

  def edit
    if get_access_level != 1
      access_denied
    else
        @dyno_types=DynoType.select_options
        @dyno_page = DynoPage.find(params[:id])
    end				
  end

  def update
    @dyno_page = DynoPage.find(params[:id])
    if @dyno_page.update_attributes(params[:dyno_page])
						expire_dyno_pages
      flash[:notice] = 'DynoPage was successfully updated.'
      redirect_to :action => 'list', :dyno_type_id => @dyno_page.dyno_type_id
    else
						@dyno_types=DynoType.select_options
      render :action => 'edit'
    end
  end

  def activate
    @dyno_page = DynoPage.find(params[:id])
    @dyno_page.is_active = true 
				@dyno_page.save
				expire_dyno_pages
    flash[:notice] = 'DynoPage was activated.'
    redirect_to :action => 'list', :dyno_type_id => @dyno_page.dyno_type_id
  end

  def deactivate
    @dyno_page = DynoPage.find(params[:id])
    @dyno_page.is_active = false 
				@dyno_page.save
				expire_dyno_pages
    flash[:notice] = 'DynoPage was deactivated.'
    redirect_to :action => 'list', :dyno_type_id => @dyno_page.dyno_type_id
  end

  def xxx
				@dyno_page = DynoPage.find(params[:id])
				_dt = @dyno_page.dyno_type_id
				expire_dyno_pages
				@dyno_page.destroy
    redirect_to :action => 'list', :dyno_type_id => _dt
				_dt = nil
  end
end
