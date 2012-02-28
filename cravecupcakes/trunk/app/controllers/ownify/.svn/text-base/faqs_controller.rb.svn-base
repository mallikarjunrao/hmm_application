class Ownify::FaqsController < LoginController
  def index
    if get_access_level != 1
      access_denied
    else
      list
      render :action => 'list'
    end    
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :create, :update ],
         :redirect_to => { :action => :list }

  def list
    if get_access_level != 1
      access_denied
    else
      @faqs = Faq.find(:all, :order => 'position')
    end    
  end

  def order
    if get_access_level != 1
      access_denied
    else
      params[:sort_list].each_with_index { |id,idx| Faq.update(id, :position => idx) }
      @faqs = Faq.find(:all, :order => 'position')
      expire_faqs
      render :layout => false, :partial => "order"
    end
    
  end

  def new
    if get_access_level != 1
      access_denied
    else
      @faq = Faq.new
    end    
  end

  def create
    @faq = Faq.new(params[:faq])
    if @faq.save
      flash[:notice] = 'Faq was successfully created.'
						expire_faqs
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    if get_access_level != 1
      access_denied
    else
      @faq = Faq.find(params[:id])
    end    
  end

  def update
    @faq = Faq.find(params[:id])
    if @faq.update_attributes(params[:faq])
      flash[:notice] = 'Faq was successfully updated.'
						expire_faqs
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Faq.find(params[:id]).destroy
				expire_faqs
    redirect_to :action => 'list'
  end
end
