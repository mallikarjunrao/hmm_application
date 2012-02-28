class Ownify::EditableTextsController < LoginController
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
      @editable_text_pages, @editable_texts = paginate :editable_texts, :per_page => 30
    end    
  end

  def new
    if get_access_level != 1
      access_denied
    else
      @editable_text = EditableText.new
    end    
  end

  def create
    @editable_text = EditableText.new(params[:editable_text])
    if @editable_text.save
      flash[:notice] = 'EditableText was successfully created.'
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
      @editable_text = EditableText.find(params[:id])
    end    
  end

  def update
    ## Upload file for top banner
    if params[:editable_text][:title] == "top_banner"
	if params[:top_banner] == nil || params[:top_banner] == ""
	else
		upload = params[:top_banner]
		filename = "top_banner.jpg";
		path = File.join("public/images", filename)
		File.open(path, "wb") { |f| f.write(upload.read) }
	end
	#params[:editable_text][:html_body] = "<a href=\""+params[:link]+"\">"+params[:editable_text][:html_body]+"</a>"
	#if params[:editable_text][:html_body] == ""
	#	params[:editable_text][:html_body] == "null"
	#end
    end
    ##
    @editable_text = EditableText.find(params[:id])
    if @editable_text.update_attributes(params[:editable_text])
      flash[:notice] = 'EditableText was successfully updated.'
						expire_all_pages
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def delete
    filename = "top_banner.jpg";
    path = File.join("public/images", filename)
    File.unlink(path)
    #@editable_text = EditableText.find(params[:id])
    #@editable_text.update_attributes(params[:editable_text])
    flash[:notice] = 'Top banner is deleted'
						expire_all_pages
    redirect_to :action => 'list'
  end

  def xxx
    EditableText.find(params[:id]).destroy
				expire_all_pages
    redirect_to :action => 'list'
  end
		
		private
		
end
