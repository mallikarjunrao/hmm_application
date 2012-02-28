class Ownify::DaysController < LoginController
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
      @day_pages, @days = paginate :days, :per_page => 10
    end    
  end

  def show
    if get_access_level != 1
      access_denied
    else
      @day = Day.find(params[:id])
    end    
  end

  def new
    if get_access_level != 1
      access_denied
    else
      @day = Day.new
    end    
  end

  def create
    @day = Day.new(params[:day])
    if @day.save
      flash[:notice] = 'Day was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    if get_access_level != 1
      access_denied
    else
      @day = Day.find(params[:id])
    end    
  end

  def update
    @day = Day.find(params[:id])
    if @day.update_attributes(params[:day])
      flash[:notice] = 'Day was successfully updated.'
      redirect_to :action => 'show', :id => @day
    else
      render :action => 'edit'
    end
  end

  def destroy
    Day.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
