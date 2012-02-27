class MyCartsController < ApplicationController
  layout "standard"
  
  helper :user_account
  include UserAccountHelper
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
         
    before_filter :authenticate, :only => [ :create, :selected_items ]
    #   protected
    def authenticate
      unless session[:hmm_user]
           flash[:notice] = 'Please Login to Access your Account'
           redirect_to "https://www.holdmymemories.com/user_account/login"
      return false
      else
        if (session[:flag] == 1 && request.request_uri != "/customers/upgrade/platinum_account")
          flash[:error] = "Your credit card payment to your HoldMyMemories.com has been declined by your credit card company. This could be for a number of reasons, including an expired card. <br><br><br>Please re-enter your credit card information, or use a different card for the renewal of your account."
          redirect_to @server_url_chk+"/customers/upgrade/platinum_account"
        end  
      end
    end

  def list
    @my_cart_pages, @my_carts = paginate :my_carts, :per_page => 10
  end

  def show
    @my_cart = MyCart.find(params[:id])
  end

  def new
    @my_cart = MyCart.new
  end
  
  def validate_item
    moment_type = params[:moment_type]
    mom_id = params[:id]
    if moment_type == "chap"
      @chap_content_count = UserContent.count(:all, :conditions => "tagid = '#{mom_id}' and e_filetype='image'")
         if @chap_content_count > 0
            redirect_to "/my_carts/create_item/?id=#{mom_id}&moment_type=#{moment_type}&link=#{params[:link]}"
         else
            flash[:order_invalid] = "This "+moment_type+"ter contains no images!!"
            redirect_to params[:link]
         end
    elsif moment_type == "subchapter"
      @subchap_content_count = UserContent.count(:all, :conditions => "sub_chapid = '#{mom_id}'  and e_filetype='image'")
          if @subchap_content_count > 0
            redirect_to "/my_carts/create_item/?id=#{mom_id}&moment_type=#{moment_type}&link=#{params[:link]}"
         else
            flash[:order_invalid] = "This "+moment_type+" contains no images!!"
            redirect_to params[:link]
         end
    elsif moment_type == "gallery"
      @gal_content_count = UserContent.count(:all, :conditions => "gallery_id = '#{mom_id}'  and e_filetype='image'")
          if @gal_content_count > 0
            redirect_to "/my_carts/create_item/?id=#{mom_id}&moment_type=#{moment_type}&link=#{params[:link]}"
         else
            flash[:order_invalid] = "This "+moment_type+" contains no images!!"
            redirect_to params[:link]
         end
    elsif moment_type == "moment"
      redirect_to "/my_carts/create_item/?id=#{mom_id}&moment_type=#{moment_type}&link=#{params[:link]}"
    end
    
  end
  
  def create_item
    puts params[:moment_type]
    @my_cart = MyCart.new()
    @my_cart['uid']=logged_in_hmm_user.id
    @my_cart['moment_id']=params[:id]
    @my_cart['added_item']=params[:moment_type]
    @my_cart['status']='pending'
#    @my_cart['no_of_copies']=
    if @my_cart.save
      flash[:notice_mycart] = 'Item was successfully added to cart.'
      redirect_to params[:link]
    else
      flash[:notice_mycart] = 'item was could not be added to cart. please try after some time'
      render :action => 'new'
    end
  end

  def edit
    @my_cart = MyCart.find(params[:id])
  end

  def update
    @my_cart = MyCart.find(params[:id])
    if @my_cart.update_attributes(params[:my_cart])
      flash[:notice] = 'MyCart was successfully updated.'
      redirect_to :action => 'show', :id => @my_cart
    else
      render :action => 'edit'
    end
  end

  def destroy
    MyCart.find(params[:id]).destroy
    redirect_to :action => 'selected_items'
  end
  
  def destroy_item
    MyCart.find(params[:id]).destroy
   # redirect_to :action => 'selected_items'
   redirect_to :controller =>'my_familywebsite', :action => 'selected_items', :id => params[:familyname]
  end
  
  def selected_items

    @my_carts = MyCart.find(:all, :conditions => "uid=#{logged_in_hmm_user.id}", :order=>"id DESC" )
    @my_carts_count = MyCart.count(:all, :conditions => "uid=#{logged_in_hmm_user.id}" )
    @moment_count = MyCart.count(:all, :conditions => "uid=#{logged_in_hmm_user.id} and added_item = 'moment'" )
    @product = Product.find(:all)
  end
  
  def update_copies
    #adding no of copies in my_carts table
     @find_cartid = MyCart.find(:all, :conditions => "uid = '#{logged_in_hmm_user.id}' and status='pending'")
     i=0
     require 'pp'
     pp params[:mycart_id]
     for m in @find_cartid
        sizes= "sizes#{params[:mycart_id][i]}"
        @my_cart = MyCart.find(params[:mycart_id][i])
        @my_cart.no_of_copies=params[:copies][i]
        @my_cart.no_of_moments=params[:no_moments][i]
        @my_cart.product_id=params["#{sizes}"]
            @product_price = Product.find(:all, :conditions => "id='#{@my_cart.product_id}'")
         @noof_moment =  (@my_cart.no_of_moments * @my_cart.no_of_copies)
         @my_cart.price = (@product_price[0]['price'] * @noof_moment)
        @my_cart.save
        i=i+1
     end
    redirect_to :controller => "order_details", :action => 'process_payment', :id => logged_in_hmm_user.id , :familyname => params[:familyname]
    
  end
  
  def preview
    if params[:type]=='chap'
       @selected_items = UserContent.paginate  :conditions => "tagid='#{params[:id]}' and e_filetype='image'" ,:order =>'id asc', :per_page => 1, :page => params[:page]

    elsif params[:type]=='subchapter'
      @selected_items =UserContent.paginate  :conditions => "sub_chapid='#{params[:id]}' and e_filetype='image'" ,:order =>'id asc', :per_page => 1, :page => params[:page]
    elsif params[:type]=='gallery'
      @selected_items = UserContent.paginate  :conditions => "gallery_id='#{params[:id]}' and e_filetype='image'",:order =>'id asc', :per_page => 1, :page => params[:page]
    elsif params[:type]=='moment'
      @selected_items = UserContent.find(:all, :conditions => "id='#{params[:id]}'")
    end
     render :layout => true
  end
  
end
