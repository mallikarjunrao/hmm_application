class Ownify::SeoSettingsController < LoginController
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
      @page = params[:page]
        if params[:search_term]
            search_term = "%#{params[:search_term].downcase}%"
            @seo_settings = SeoSetting.find(:all, :conditions => ["path like ? ", search_term], :order => 'page_title', :page => { :size => 30, :current => @page })
        else
            @seo_settings = SeoSetting.find(:all, :order => 'page_title', :page => { :size => 30, :current => @page })
        end
    end				
  end

  def show
    if get_access_level != 1
      access_denied
    else
      @seo_setting = SeoSetting.find(params[:id])
    end    
  end

  def new
    if get_access_level != 1
      access_denied
    else
      @seo_setting = SeoSetting.new
    end    
  end

  def create
    @seo_setting = SeoSetting.new(params[:seo_setting])
    if @seo_setting.save
      flash[:notice] = 'SeoSetting was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    if get_access_level != 1
      access_denied
    else
      @seo_setting = SeoSetting.find(params[:id])
    end    
  end

  def update
    @seo_setting = SeoSetting.find(params[:id])
    if @seo_setting.update_attributes(params[:seo_setting])
						expire_seo_setting( @seo_setting.path )
      flash[:notice] = 'SeoSetting was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    @seo_setting = SeoSetting.find(params[:id])
				expire_seo_setting( @seo_setting.path )
    @seo_setting.destroy
    redirect_to :action => 'list'
  end
		
end
