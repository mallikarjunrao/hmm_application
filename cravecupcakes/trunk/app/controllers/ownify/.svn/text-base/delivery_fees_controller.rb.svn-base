class Ownify::DeliveryFeesController < LoginController
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

      if params[:store_id] != nil
        session[:store_id] = params[:store_id]
      end

      store_id = (session[:store_id] != nil)? session[:store_id] : 1

      @deliveryfees = DeliveryFee.find(:all, :conditions => ["store_id = ?", store_id], :order => "zip, store_id", :page => { :size => 30, :current => params[:page] })
    end    
  end

  def new
    if get_access_level != 1
      access_denied
    else
      @deliveryfee = DeliveryFee.new
    end    
  end

  def create
    @deliveryfee = DeliveryFee.new(params[:deliveryfee])
    if @deliveryfee.save
      flash[:notice] = 'Delivery Fee was successfully created.'
						expire_all_pages
      if params[:deliveryfee][:store_id].to_i == 2
        redirect_to :action => 'list', :store_id => "2"
      else
        redirect_to :action => 'list', :store_id => "1"
      end
    else
      render :action => 'new'
    end
  end

  def edit
    if get_access_level != 1
      access_denied
    else
      @deliveryfee = DeliveryFee.find(params[:id])
    end    
  end

  def update
		
    @deliveryfee = DeliveryFee.find(params[:id])
    if @deliveryfee.update_attributes(params[:deliveryfee])
      flash[:notice] = 'Delivery Fee was successfully updated.'
						expire_all_pages

      if params[:deliveryfee][:store_id].to_i == 2
        redirect_to :action => 'list', :id => @deliveryfee, :store_id => "2"
      else
        redirect_to :action => 'list', :id => @deliveryfee, :store_id => "1"
      end

      
    else
      render :action => 'edit'
    end
  end

  def destroy
    DeliveryFee.find(params[:id]).destroy
				expire_all_pages
    redirect_to :action => 'list', :store_id => params[:store_id]
  end
end
