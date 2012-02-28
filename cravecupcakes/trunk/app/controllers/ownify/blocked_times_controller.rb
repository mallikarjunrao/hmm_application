class Ownify::BlockedTimesController < LoginController
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

      @blocked_times = BlockedTime.find(:all, :conditions => ["store_id = ?", store_id], :order => "block_on, start_time", :page => { :size => 30, :current => params[:page] })
    end    
  end

  def new
    if get_access_level != 1
      access_denied
    else
      @blocked_time = BlockedTime.new
    end
    
  end

  def create
    @blocked_time = BlockedTime.new(params[:blocked_time])
    if @blocked_time.save
      flash[:notice] = 'Blocked Time was successfully created.'
      
      if params[:blocked_time][:store_id].to_i == 2
        redirect_to :action => 'list', :id => @blocked_time, :store_id => "2"
      else
        redirect_to :action => 'list', :id => @blocked_time, :store_id => "1"
      end

    else
      render :action => 'new'
    end
  end

  def edit
    if get_access_level != 1
      access_denied
    else
      @blocked_time = BlockedTime.find(params[:id])
    end
    
  end

  def update
    @blocked_time = BlockedTime.find(params[:id])
    if @blocked_time.update_attributes(params[:blocked_time])
      flash[:notice] = 'Blocked Time was successfully updated.'

      if params[:blocked_time][:store_id].to_i == 2
        redirect_to :action => 'list', :id => @blocked_time, :store_id => "2"
      else
        redirect_to :action => 'list', :id => @blocked_time, :store_id => "1"
      end
      
    else
      render :action => 'edit'
    end
  end

  def destroy
    BlockedTime.find(params[:id]).destroy
    redirect_to :action => 'list', :store_id => params[:store_id]
  end
end
