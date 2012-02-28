class Ownify::OwnersController < LoginController
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
      #@owner_pages, @owners = paginate :owners, :per_page => 1
      @owners = Owner .find(:all, :order =>  "id  desc", :page => { :size => 20, :current => params[:page] })

      #@orders = Order.find(:all, :order =>  "date_of_order  desc, time_of_order desc", :page => { :size => 20, :current => params[:page] })
    end    
  end

  def new
    if get_access_level != 1
      access_denied
    else
      @owner = Owner.new
    end    
  end

  def create
    @owner = Owner.new(params[:owner])
    if @owner.save
      flash[:notice] = 'Owner was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    if get_access_level != 1
      access_denied
    else
      @owner = Owner.find(params[:id])
    end    
  end

  def update
    @owner = Owner.find(params[:id])
    if @owner.update_attributes(params[:owner])
      flash[:notice] = 'Owner was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Owner.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
