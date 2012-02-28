class Ownify::NewsController < LoginController
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
        @dyno_type=DynoType.find_by_slug('news')
        @dyno_pages = DynoPage.find(:all, :conditions => {:dyno_type_id => @dyno_type}, :order =>  "page_on desc")
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
      @dyno_page = DynoPage.new
    end    
  end

  def create
    @dyno_page = DynoPage.new(params[:dyno_page])
				@dyno_type=DynoType.find_by_slug('news')
				@dyno_page.dyno_type_id= @dyno_type.id
				
				# SEO stuff
				seo = SeoSetting.new
				seo.path = "/article/#{@dyno_page.slug}"
				seo.page_title = "Crave Cupcakes - #{@dyno_page.title}"
				seo.meta_description = @dyno_page.summary
				seo.meta_keywords = @dyno_page.summary
				seo.save
				
				if @dyno_page.sub_title == ''
				  @dyno_page.sub_title = 'publication'
				end
    if @dyno_page.save
						expire_dyno_pages
      flash[:notice] = 'Page was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    if get_access_level != 1
      access_denied
    else
      @dyno_page = DynoPage.find(params[:id])
    end    
  end

  def update
    @dyno_page = DynoPage.find(params[:id])
				if @dyno_page.sub_title == ''
				  @dyno_page.sub_title = 'publication'
				end
    if @dyno_page.update_attributes(params[:dyno_page])
						expire_dyno_pages
      flash[:notice] = 'DynoPage was successfully updated.'
      redirect_to :action => 'list', :dyno_type_id => @dyno_page.dyno_type_id
    else
      render :action => 'edit'
    end
  end
		
  def seo
    @dyno_page = DynoPage.find(params[:id])
    @seo_setting = SeoSetting.find_by_path( "/article/#{@dyno_page.slug}" )
  end

  def update_seo
    @seo_setting = SeoSetting.find(params[:id])
    @dyno_page = DynoPage.find(params[:dyno_page_id])
    if @seo_setting.update_attributes(params[:seo_setting])
      flash[:notice] = 'SeoSetting was successfully updated.'
						expire_dyno_pages
      redirect_to :action => 'seo', :id => @dyno_page
    else
      render :action => 'seo'
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
    redirect_to :action => 'list'
  end
end
