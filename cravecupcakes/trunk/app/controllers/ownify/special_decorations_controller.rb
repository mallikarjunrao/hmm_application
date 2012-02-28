class Ownify::SpecialDecorationsController < LoginController
  def index    
      list
      render :action => 'list'    
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list

      if params[:reset] == "Reset"
				session[:group] = nil
				session[:req_two] = nil
				session[:original] = nil
				session[:mini] = nil				
      elsif params[:submit] == "Search"
				session[:group] = params[:group]					#if params[:group]
				session[:req_two] = params[:req_two]		#if params[:req_two]
				session[:original] = params[:original]		#	if params[:original]
				session[:mini] = params[:mini]					#if params[:mini]
			end

      cond = "name != 'Numbers' AND name != 'Letters' "
			if session[:group] != nil && session[:group] != ""
				cond += " AND " if cond != ""
				cond += "`group` = \""+session[:group]+"\""
			end
			if session[:req_two] != nil && session[:req_two] != ""
				cond += " AND " if cond != ""
				cond += "colors = '"+session[:req_two]+"'"
			end
			if session[:original] != nil && session[:original] != ""
				cond += " AND " if cond != ""
				cond += "standard = '"+session[:original]+"'"
			end
			if session[:mini] != nil && session[:mini] != ""
				cond += " AND " if cond != ""
				cond += "mini = '"+session[:mini]+"'"
			end      
      
      if cond != ""
				@sp_decorations = SpecialDecoration.find(:all, :conditions => cond, :order => "`group` ASC, name ASC", :page => { :size => 30, :current => params[:page] })
			else
				@sp_decorations = SpecialDecoration.find(:all,  :order => "`group` ASC, name ASC", :page => { :size => 30, :current => params[:page] })
			end

      @groups = SpecialDecoration.find(:all, :select => "DISTINCT `group`", :order => "`group`")
      @colors = Color.find(:all, :order => "id ASC") 
  end
  
  def new
    if get_access_level != 1
      access_denied
    else
      @special_decoration = SpecialDecoration.new
    end
    
  end

  def create
    @special_decoration = SpecialDecoration.new(params[:special_decoration])
    if @special_decoration.save
      flash[:notice] = 'Special decoration was successfully created.'
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
      @special_decoration = SpecialDecoration.find(params[:id])
    end
    
  end

  def update
		
    @special_decoration = SpecialDecoration.find(params[:id])
    if @special_decoration.update_attributes(params[:special_decoration])
      flash[:notice] = 'Special decoration was successfully updated.'
						expire_all_pages
      redirect_to :action => 'list', :id => @special_decoration
    else
      render :action => 'edit'
    end
  end

  def destroy
    SpecialDecoration.find(params[:id]).destroy
				expire_all_pages
    redirect_to :action => 'list'
  end
  
  def upload
    if get_access_level != 1
      access_denied
    else

      if params[:upload] != nil
        if params[:upload][:standard_file].to_s != "" || params[:upload][:mini_file].to_s != ""
            @msg = ""
          if params[:upload][:standard_file].to_s != ""
              DataFile.save_popup_stnd(params[:upload])
              expire_all_pages
              @msg = "Standard special decoartion image uploaded successfully.";
          end
          if params[:upload][:mini_file].to_s != ""
              DataFile.save_popup_mini(params[:upload])
              expire_all_pages
              @msg += "<br>Mini special decoartion image uploaded successfully.";
          end
          expire_all_pages
        else
          @msg = "Please select an image.";
        end
      end        
        
      render :action => "upload"
    end   
  end
  
end