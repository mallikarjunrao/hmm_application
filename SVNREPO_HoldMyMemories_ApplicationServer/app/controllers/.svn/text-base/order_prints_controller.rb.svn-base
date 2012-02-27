class OrderPrintsController < ApplicationController
  require 'json/pure'
  #layout "ecommerce"
  layout "familywebsite"
  #service to return the active image galleries and albums for the family website.
  helper :user_account
  include UserAccountHelper

  before_filter :check_account, :only => [:gallery_list,:print_orders]

  #method to check whether the family name in the url is valid or invalid
  #if family name doesn't exist, redirects to hmm home page
  #if user is blocked, displays message
  #if user didn't agee for terms of use,
  # => if the user is not logged in, takes to login page
  # => if the user is logged in, takes to agree terms page

  def initialize()
    #@current_page = 'manage my site'
    @hide_float_menu = true
  end


  def check_account
    unless params[:id].blank?
      @family_website_owner = HmmUser.find(:first,:joins =>"INNER JOIN themes on hmm_users.theme_id=themes.id", :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')",:select => "hmm_users.*,themes.stylesheet as theme") #get the user details
      if @family_website_owner
        if(session[:employe]==nil && @family_website_owner.terms_checked == 'false' ) #if the logged in user is not employee and terms is not agreed
          flash[:terms] = 'terms'
          if(session[:hmm_user]) #f the user is logged in, takes to agree terms page
            redirect_to "/user_account/update_terms/"
          else #if the user is not logged in, takes to login page
            redirect_to "/familywebsite/login/#{params[:id]}" if params[:action]!='login'
          end
        elsif @family_website_owner.e_user_status=='blocked' #displays message, if the user is blocked
          render :text => "This Familywebsite has been Blocked. Please contact Website Administrator at <a href='mailto:admin@holdmymemories.com' >admin@HoldMyMemories.com</a>"
        elsif session[:visitor]==nil && session[:hmm_user]==nil && @family_website_owner.password_required == 'yes'
          #render :text =>"Password protected. Redirect to family website login page"
          redirect_to :controller =>"familywebsite", :action => 'visitor_login', :id => params[:id], :redirect_url => request.url if (params[:action]!='login' && params[:action]!='visitor_login')
        elsif !session[:hmm_user] || logged_in_hmm_user.id!=@family_website_owner.id
          redirect_to "/familywebsite/login/#{params[:id]}"
        else
          @path = ContentPath.find(:first, :conditions => "status='active'")
          @content_server_url = @path.content_path
          @content_server_name = @path.proxyname
          return true #returns true if all the conditions are cleared
        end
      else
        redirect_to '/'
      end
    end
  end

  def authenticate
    unless session[:hmm_user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "/user_account/login"
      return false
    end
  end

  def gallery_list_service
    @galleries = Hash.new()
    @selected_gallery=Array.new()
    @cnt=0
    if(session[:hmm_user])
      if(params[:id])
        conditions = "tags.uid = #{session[:hmm_user]} and galleries.id!=#{params[:id]} and galleries.status='active' and galleries.e_gallery_type='image' and tags.status='active' and tags.default_tag='yes'  and user_contents.status = 'active'"
        @cnt=1
        @selected_gallery = Galleries.find :first, :joins => "INNER JOIN sub_chapters ON galleries.subchapter_id = sub_chapters.id INNER JOIN tags ON sub_chapters.tagid = tags.id INNER JOIN user_contents ON user_contents.gallery_id = galleries.id",
          :select => "galleries.id,galleries.v_gallery_name,galleries.img_url,galleries.v_gallery_image,tags.v_tagname,tags.tag_type,tags.id as user_content_id,sub_chapters.sub_chapname,tags.v_chapimage,tags.v_chapimage as album_img_url",
          :conditions => "tags.uid = #{session[:hmm_user]} and galleries.id=#{params[:id]} and galleries.status='active' and galleries.e_gallery_type='image' and tags.status='active' and tags.default_tag='yes'  and user_contents.status = 'active'",
          :order => "d_gallery_date desc",
          :group =>"user_contents.gallery_id"


      else

        conditions = "tags.uid = #{session[:hmm_user]} and galleries.status='active' and galleries.e_gallery_type='image' and tags.status='active' and tags.default_tag='yes' and user_contents.status = 'active'"

      end
      @galleries = Galleries.find :all, :joins => "INNER JOIN sub_chapters ON galleries.subchapter_id = sub_chapters.id INNER JOIN tags ON sub_chapters.tagid = tags.id INNER JOIN user_contents ON user_contents.gallery_id = galleries.id",
        :select => "galleries.id,galleries.v_gallery_name,galleries.img_url,galleries.v_gallery_image,tags.v_tagname,tags.tag_type, tags.img_url as album_img_url, tags.id as user_content_id,sub_chapters.sub_chapname,tags.v_chapimage,user_contents.gallery_id",
        :conditions => conditions,
        :order => "d_gallery_date desc",
        :group =>"user_contents.gallery_id"

    end
    render :layout => false
  end

  def gallery_list
    @gallery_id=''
    @user_id = session[:hmm_user]
    if(params[:gallery_id]!=nil)
      @gallery_id = params[:gallery_id]
    end
    get_content_urls=ContentPath.find(:all)
    @proxyurl = Array.new
    for get_content_url in get_content_urls
    @proxyurl.push(get_content_url.content_path)
    end

   # logger.info("HIGH RES :#{high_resoltuion}")
   # logger.info("LOW RES :#{low_resoltuion}")
  end

  def print_orders
    @gallery_id=''
    @user_id = session[:hmm_user]
    if(params[:gallery_id]!=nil)
      @gallery_id = params[:gallery_id]
    end
    get_content_urls=ContentPath.find(:all)
    @proxyurl = Array.new
    for get_content_url in get_content_urls
    @proxyurl.push(get_content_url.content_path)
    end
    @versions=VersionDetail.find(:first,:conditions=>"file_name='PrintOrder'")

   # logger.info("HIGH RES :#{high_resoltuion}")
   # logger.info("LOW RES :#{low_resoltuion}")

  end

  def get_sizes
    @sizes = Hash.new
    @hmm_sizes = Hash.new
    @user = HmmUser.find(:first,:conditions=>"id = #{session[:hmm_user]}")
    if(@user.emp_id!=nil)
      @studio = EmployeAccount.find(:first,:conditions=>"id=#{@user.emp_id}")
      @sizes = PrintSizePrice.find(:all, :joins =>"INNER JOIN print_sizes on print_sizes.id = print_size_prices.print_size_id",:conditions=>"studio_id = #{@studio.store_id}",
        :select =>"print_size_prices.id,print_sizes.label as name,print_size_prices.price,print_sizes.width,print_sizes.height")
    end
    @hmm_sizes = PrintSizePrice.find(:all, :joins =>"INNER JOIN print_sizes on print_sizes.id = print_size_prices.print_size_id",:conditions=>"studio_type='hmm'",
      :select =>"print_size_prices.id,print_sizes.label as name,print_size_prices.price,print_sizes.width,print_sizes.height")
    if @sizes.length == 0
      @sizes = @hmm_sizes
    end
    return @sizes,@hmm_sizes
  end

  def get_order_prints_service

    if(session[:hmm_user])

      conditions = "carts.user_id =#{session[:hmm_user]} and carts.status='order_print'"

      @items = Cart.find :all, :joins => "INNER JOIN print_size_prices ON carts.size_id = print_size_prices.id INNER JOIN print_sizes on print_size_prices.print_size_id=print_sizes.id INNER JOIN user_contents ON carts.user_content_id = user_contents.id",
        :conditions => conditions ,
        :select =>"carts.*,print_sizes.label as name,print_size_prices.price,user_contents.v_tagname,user_contents.gallery_id",:order=>"order_num"
      #@sizes,@hmm_sizes = self.get_sizes
      @hmm_sizes = Hash.new
        #logger.info("studio id => #{subchapterdet.store_id}")
      @hmm_sizes = PrintSizePrice.find(:all, :joins =>"INNER JOIN print_sizes on print_sizes.id = print_size_prices.print_size_id",:conditions=>"studio_type='hmm'",
      :select =>"print_size_prices.id,print_sizes.id as size_id,print_sizes.label as name,print_size_prices.price,print_sizes.width,print_sizes.height")
      @sizes = Hash.new

      #get list of studio ids of session images
      #      @studios=Cart.find :all , :joins => "as carts , user_contents, hmm_users, sub_chapters, hmm_studios" , :select=>"hmm_studios.id AS studio_id, hmm_studios.studio_groupid AS studio_groupid, hmm_studios.studio_branch AS studio_name",:conditions=>"hmm_users.id =#{session[:hmm_user]}
      #      AND carts.user_content_id = user_contents.id
      #      AND carts.status = 'order_print'
      #
      #      AND user_contents.sub_chapid = sub_chapters.id
      #      AND sub_chapters.store_id = hmm_studios.id
      #      AND hmm_studios.print_order!='hmm'" , :group=>"hmm_studios.id"
      #      @studios_count=@studios.length
      #@studios_count=0

    end
    render :layout => false

  end

  def get_order_print_item_service
    conditions = "carts.id = #{params[:id]} and carts.user_id = #{session[:hmm_user]} and carts.status = 'order_print'"
    @item = Cart.find(:first, :joins => "INNER JOIN print_size_prices ON carts.size_id = print_size_prices.id INNER JOIN print_sizes on print_size_prices.print_size_id=print_sizes.id INNER JOIN user_contents ON carts.user_content_id = user_contents.id",
      :conditions =>conditions,:select =>"carts.*,print_size_prices.price,print_sizes.height,print_sizes.width,user_contents.v_tagname,user_contents.gallery_id")
    #@sizes,@hmm_sizes = self.get_sizes
    @hmm_sizes = Hash.new
        #logger.info("studio id => #{subchapterdet.store_id}")
         @hmm_sizes = PrintSizePrice.find(:all, :joins =>"INNER JOIN print_sizes on print_sizes.id = print_size_prices.print_size_id",:conditions=>"studio_type='hmm'",
            :select =>"print_size_prices.id,print_sizes.label as name,print_size_prices.price,print_sizes.width,print_sizes.height")
    @sizes = Hash.new
    render :layout => false
  end

  def add_to_cart_service
    logger.info(params[:content])
    params[:content]= CGI::unescape(params[:content])
    logger.info(params[:content])
    items =  JSON.parse(params[:content])

    if params[:visitor_id].to_i > 0
      logger.info "$$$$$$$$$$$session[:visitor_id]$$$$$$$$$$$$$$$$$"
      logger.info session[:hmm_user]
      for item in items
        logger.info "*************************"
        logger.info item.inspect
        conditions = "carts.visitor_id =#{params[:visitor_id].to_i} and carts.status='order_print' and carts.id =#{item['id']}"
        Cart.update_all("status='cart',quantity=#{item['quantity']}",conditions)
      end
    else
      logger.info "$$$$$$$$$$@@@@@@@@@@@@@@@@$$$$$$$$$$$$$$$$$$"
      logger.info session[:hmm_user]
      for item in items
        logger.info "*************************"
        logger.info item.inspect
        conditions = "carts.user_id =#{session[:hmm_user]} and carts.status='order_print' and carts.id =#{item['id']}"
        Cart.update_all("status='cart',quantity=#{item['quantity']}",conditions)
      end
    end

    #assign orders to studio id

    if(params[:studio_id])

      @studios=Cart.find :all , :joins => "as carts , user_contents, hmm_users, sub_chapters, hmm_studios" , :select=>"carts.id as cartid",:conditions=>"hmm_users.id =#{session[:hmm_user]}
AND carts.user_content_id = user_contents.id

AND user_contents.sub_chapid = sub_chapters.id
AND sub_chapters.store_id = hmm_studios.id
AND hmm_studios.print_order!='hmm'"

      a = Array.new

      for @studio in @studios
        a.push(@studio.cartid)
      end

      @list_studios=a.join(",")
      sql = ActiveRecord::Base.connection();
      sql.update "UPDATE carts SET order_type='other' , studio_id =#{params[:studio_id]} WHERE id IN (#{@list_studios})";

    end
    render :text =>'true'

  end

  def delete_order_print_item_service
    conditions = "carts.id = #{params[:id]} and carts.user_id = #{session[:hmm_user]} and carts.status = 'order_print'"
    if Cart.delete_all(conditions)
      render :text => "true"
    else
      render :text => "false"
    end
  end

  def delete_order_print_items_service
    conditions = " carts.user_id = #{session[:hmm_user]} and carts.status = 'order_print' and id IN (#{params[:idList]})"
    if Cart.delete_all(conditions)
      render :text => "true"
    else
      render :text => "false"
    end
  end

  def delete_all_cart_items
    if(session[:hmm_user])
      conditions = " carts.user_id = #{session[:hmm_user]} and carts.status = 'cart'"
      if Cart.delete_all(conditions)
        render :text => "true"
      else
        render :text => "false"
      end
    else
      render :text => "false"
    end
  end

  def delete_order_print_service
    conditions = "carts.user_id = #{session[:hmm_user]} and carts.status = 'order_print'"
    if Cart.delete_all(conditions)
      render :text => "true"
    else
      render :text => "false"
    end
  end

  def update_order_print_item_service
    size_details = PrintSizePrice.find(params[:size_id])
    @content =Cart.find(params[:cart_id])
	  @content.quantity=params[:quantity]
    @content.size_id=params[:size_id]
    @content.studio_id=size_details.process_studio_id
    if @content.save
      render :text => "true"
    else
      render :text => "false"
    end
  end


end