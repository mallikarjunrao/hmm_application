class FaqsController < ApplicationController
   layout "admin"
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
  
  before_filter :authenticate_admin, :only => [ :new, :edit, :show, :list]

  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "https://www.holdmymemories.com/account/login"
    return false
    end
  end
  
  def list
    @faq_pages, @faqs = paginate :faqs, :per_page => 100 , :order => 'id asc'
  end
  
  def up
    previousid=params[:prev]
    currentid=params[:id]
    faqmax =  Faq.find_by_sql("select max(id) as m from faqs")
    if(faqmax[0]['m']=='')
      faq_next_id=1
    else
      faqmax=faqmax[0]['m']
      faq_next_id= Integer(faqmax) + 1
    end
    
     sql = ActiveRecord::Base.connection();
     sql.update "UPDATE faqs SET id = #{faq_next_id}  WHERE id =#{currentid}";
     
     sql.update "UPDATE faqs SET id = #{currentid}  WHERE id =#{previousid}";
      
     sql.update "UPDATE faqs SET id = #{previousid}  WHERE id =#{faq_next_id}";
    redirect_to :action => 'list'
  
end

def down
    nextid=params[:nextid]
    currentid=params[:id]
    faqmax =  Faq.find_by_sql("select max(id) as m from faqs")
    if(faqmax[0]['m']=='')
      faq_next_id=1
    else
      faqmax=faqmax[0]['m']
      faq_next_id= Integer(faqmax) + 1
    end
    
     sql = ActiveRecord::Base.connection();
     sql.update "UPDATE faqs SET id = #{faq_next_id}  WHERE id =#{currentid}";
     
     sql.update "UPDATE faqs SET id = #{currentid}  WHERE id =#{nextid}";
      
     sql.update "UPDATE faqs SET id = #{nextid}  WHERE id =#{faq_next_id}";
    redirect_to :action => 'list'
  
  end

  def show
    @faq = Faq.find(params[:id])
  end

  def new
    @faq = Faq.new
  end

  def create
    @faq = Faq.new(params[:faq])
    if @faq.save
      flash[:notice] = 'Faq was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @faq = Faq.find(params[:id])
  end

  def update
    @faq = Faq.find(params[:id])
    if @faq.update_attributes(params[:faq])
      flash[:notice] = 'Faq was successfully updated.'
      redirect_to :action => 'show', :id => @faq
    else
      render :action => 'edit'
    end
  end

  def destroy
    Faq.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
