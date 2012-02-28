class Ownify::SubscribersController < LoginController
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
				@subscribers = Subscriber.find( :all, :conditions => create_conditions_string, :order => "last_name, first_name", :page => { :size => 30, :current => @page } )
    end
				
  end

	def export_excel
		headers['Content-Type'] = "application/vnd.ms-excel" 
		headers['Content-Disposition'] = "attachment; filename=subscribers-#{Time.now.strftime('%m-%d-%Y')}.xls"
		headers['Cache-Control'] = ''
		@columns=['last_name', 'first_name', 'email_address', 'subscribed_on', 'address1', 'address2', 'city', 'state', 'zip']
		
		@records = Subscriber.find(:all, :conditions => create_conditions_string )
		render(:layout => false)
	end

	def export_text
		headers['Content-Type'] = "text/plain" 
		headers['Content-Disposition'] = "attachment; filename=subscribers-#{Time.now.strftime('%m-%d-%Y')}.txt"
		headers['Cache-Control'] = ''
		@columns=['last_name', 'first_name', 'email_address', 'subscribed_on', 'address1', 'address2', 'city', 'state', 'zip']
		
		@records = Subscriber.find(:all, :conditions => create_conditions_string )
		render(:layout => false)
	end
	
  def new
    if get_access_level != 1
      access_denied
    else
      @subscriber = Subscriber.new
    end
		  
  end

  def create
    @subscriber = Subscriber.new(params[:subscriber])
				@subscriber.subscribed_on = Time.now
    if @subscriber.save
      flash[:notice] = 'Subscriber was successfully created.'
      redirect_to :action => 'list'
    else
		      render :action => 'new'
    end
  end

  def edit
    if get_access_level != 1
      access_denied
    else
      @subscriber = Subscriber.find(params[:id])
		  get_select_arrays
    end
    
  end

  def update
    @subscriber = Subscriber.find(params[:id])
    if @subscriber.update_attributes(params[:subscriber])
      flash[:notice] = 'Subscriber was successfully updated.'
      redirect_to :action => 'list', :id => @subscriber
    else
		      render :action => 'edit'
    end
  end

  def destroy
			Subscriber.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
		
		protected		
		
		
		def create_conditions_string
		  
		  cond=[' 1=1']
				
				
    if params[:first] && ! params[:first].empty?
      cond[0]+=" and first_name like ?"
      cond[cond.size] = params[:first]+'%'
    end
    if params[:last] && ! params[:last].empty?
      cond[0]+=" and last_name like ?"
      cond[cond.size] = params[:last]+'%'
    end
    if params[:email] && ! params[:email].empty?
      cond[0]+=" and email_address like ?"
      cond[cond.size] = '%'+params[:email]+'%'
    end
    if params[:start_date] && ! params[:start_date].empty?
      cond[0]+=" and subscribed_on >= ?"
      cond[cond.size] = params[:start_date]
    end
    if params[:end_date] && ! params[:end_date].empty?
      cond[0]+=" and subscribed_on <= ?"
      cond[cond.size] = params[:end_date]
    end
   
				cond
		end
		
end
