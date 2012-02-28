class Ownify::ConfigurationsController < LoginController
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
      @configurations = Configuration.find(:all, :order => "name ASC", :page => { :size => 30, :current => params[:page] })
    end
    
  end

  def new
    if get_access_level != 1
      access_denied
    else
      @configuration = Configuration.new
    end
    
  end

  def create
    @configuration = Configuration.new(params[:configuration])
    if @configuration.save
      flash[:notice] = 'Configuration was successfully created.'
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
      @configuration = Configuration.find(params[:id])
    end
    
  end

  def update
		
    @configuration = Configuration.find(params[:id])
    if @configuration.update_attributes(params[:configuration])
      flash[:notice] = 'Configuration was successfully updated.'
						expire_all_pages
      redirect_to :action => 'list', :id => @configuration
    else
      render :action => 'edit'
    end
  end

  def destroy
    Configuration.find(params[:id]).destroy
				expire_all_pages
    redirect_to :action => 'list'
  end
end
