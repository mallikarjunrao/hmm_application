class Ownify::MainMenuController < LoginController
  def index  
    if get_access_level != 1
      access_denied
    else
      render :action => 'index'
    end    
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :index }
  
  def upload_image
    if get_access_level != 1
      access_denied
    else

      if params[:upload] != nil
        if params[:upload][:menu_file].to_s != ""
          DataFile.save(params[:upload])
          expire_all_pages
          @msg = "Image uploaded successfully.";
        else
          @msg = "Please select an image.";
        end
      end        
        
      render :action => "index"
    end   
  end

end