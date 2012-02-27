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
    @faqs = Faq.paginate  :per_page => 100 , :order => 'id asc', :page => params[:page]
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
  
  def check_emails
    require 'public/pop_ssl' # I renamed the file from pop.rb to pop_ssl.rb to ensure I was requiring the correct version
    username = 'accountingreport@holdmymemories.com'
    password = '7X6288'
    pop = Net::POP3.new("pop.gmail.com", 995)
    pop.enable_ssl
    pop.start(username, password)
    if pop.mails.empty?
      puts 'No mail.'
    else
      i = 0
      pop.each_mail do |m| 
#        Mailman.receive(m.pop)
 
      email_text = m.pop
#      arguments = Hash.new()
#    arguments['email_text'] = email_text
#    arguments['i'] = i
    
      Mailman.receive(email_text)
      puts "#{i} <br>" 
      i+i+1
      end
  end
  pop.finish 
 end
  
  
  def facebook_share_video5
    @usercontent = UserContent.find(params[:id])
    render :layout => false
  end
  
end
