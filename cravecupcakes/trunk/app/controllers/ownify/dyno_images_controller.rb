class Ownify::DynoImagesController < LoginController
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
	
		
  def order
    if get_access_level != 1
      access_denied
    else
      @dyno_page=DynoPage.find(params[:dyno_page_id])
      params[:sort_list].each_with_index { |id,idx| DynoImage.update(id, :position => idx) }
      @dyno_images = DynoImage.find(:all, :conditions => {:dyno_page_id => params[:dyno_page_id]}, :order => 'position')
			expire_dyno_pages
      render :layout => false, :partial => "order"
    end			
  end

  def list
    if get_access_level != 1
      access_denied
    else
      @dyno_page=DynoPage.find(params[:dyno_page_id])
      @dyno_images = DynoImage.find(:all, :conditions => {:dyno_page_id => params[:dyno_page_id]}, :order => 'position')
    end 	  
  end

  def new
    if get_access_level != 1
      access_denied
    else
      @dyno_page=DynoPage.find(params[:dyno_page_id])
    @dyno_image = DynoImage.new
    @dyno_image.dyno_page_id = @dyno_page.id
    end    	
  end

  def create
    @dyno_image = DynoImage.new(params[:dyno_image])
    if @dyno_image.save
      flash[:notice] = 'Image was successfully created.'
						expire_dyno_pages
      redirect_to :action => 'list', :dyno_page_id => @dyno_image.dyno_page_id
    else
      render :action => 'new'
    end
  end

  def edit
    if get_access_level != 1
      access_denied
    else
      @dyno_image = DynoImage.find(params[:id])
    end    
  end

  def update
    @dyno_image = DynoImage.find(params[:id])
    if @dyno_image.update_attributes(params[:dyno_image])
						expire_dyno_pages
      flash[:notice] = 'Image was successfully updated.'
      redirect_to :action => 'list', :dyno_page_id => @dyno_image.dyno_page_id
    else
 				@dyno_page=DynoPage.find(params[:dyno_page_id])
      render :action => 'edit'
    end
  end

  def destroy
    _pi=DynoImage.find(params[:id])
				_pid=_pi.dyno_page_id
						expire_dyno_pages
				_pi.destroy
    redirect_to :action => 'list', :dyno_page_id => _pid
  end
		
		
end
