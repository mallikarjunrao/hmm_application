class Ownify::ColorsController < LoginController
  def index    
      list
      render :controller => 'special_decorations', :action => 'list'    
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
  
  def new
    if get_access_level != 1
      access_denied
    else
      @color = Color.new
    end
    
  end

  def create
    @color = Color.new(params[:color])
    if @color.save
      flash[:notice] = 'Color was successfully created.'
						expire_all_pages
      redirect_to :controller => 'special_decorations', :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    if get_access_level != 1
      access_denied
    else
      @color = Color.find(params[:id])
    end
    
  end

  def update
		
    @color = Color.find(params[:id])
    if @color.update_attributes(params[:color])
      flash[:notice] = 'Color was successfully updated.'
						expire_all_pages
      redirect_to :controller => 'special_decorations', :action => 'list', :id => @color
    else
      render :action => 'edit'
    end
  end

  def destroy
    Color.find(params[:id]).destroy
				expire_all_pages
    redirect_to :controller => 'special_decorations', :action => 'list'
  end
  
  
end
