class CardsSelectorController < ApplicationController
  require 'cgi'
  layout 'familywebsite'

  require 'RMagick'
  include Magick

  before_filter  :check_account #checks for valid family name, terms of use check and user block check

  def initialize()
    #@hide_float_menu = true
  end

  def check_account
    unless params[:id].blank?
      @family_website_owner = HmmUser.find(:first,:joins =>"INNER JOIN themes on hmm_users.theme_id=themes.id", :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')",:select => "hmm_users.*,themes.stylesheet as theme") #get the user details
      if @family_website_owner
        if (@family_website_owner.account_expdate!=nil && @family_website_owner.account_expdate < Date.current())
          flash[:expired] = 'expired'
          redirect_to "/familywebsite/login/#{params[:id]}" if params[:action]!='login' unless (session[:hmm_user])
        elsif(session[:employe]==nil && @family_website_owner.terms_checked == 'false' ) #if the logged in user is not employee and terms is not agreed
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
          if(params[:facebook]=='true')
            session[:visitor]=@family_website_owner.family_name
          else
            redirect_to :controller =>"familywebsite", :action => 'visitor_login', :id => params[:id], :redirect_url => request.url if (params[:action]!='login' && params[:action]!='visitor_login' && params[:action]!='forgot_password')
          end
        else
        end
      else
        redirect_to '/'
      end
    end
    @path = ContentPath.find(:first, :conditions => "status='active'")
    if(params[:id]=='bob')
      @content_server_url = "http://content.holdmymemories.com"
    else
      @content_server_url = @path.content_path
    end
    return true #returns true if all the conditions are cleared
  end


  def home
    @userid=HmmUser.find(:first,:select=>"id",:conditions=>"family_name='#{params[:id]}'")
    @path = ContentPath.find(:all)
    if(params[:id]=='bob')
      @content_server_url = "http://content.holdmymemories.com"
    else
      @content_server_url = @path[0].content_path
    end
  end



  def get_cards
    @theme = Theme.find(@family_website_owner.theme_id) #get theme details
    header_logo_color = @theme.header_logo_color
    studio_header_img="default_top_logo_#{header_logo_color}.png" #default logo depending upon the header logo color specified in the themes table
    logo_path=@content_server_url+'/user_content/studio_top_logos/'+studio_header_img
    unless @family_website_owner.studio_id==0
      @studio_header = HmmStudio.find(@family_website_owner.studio_id)
      if @studio_header
        studio_header_img = "#{@studio_header.studio_logo}" if @studio_header.studio_logo != nil
        logo_path= @content_server_url+'/user_content/studio_logos/'+studio_header_img
      end
    end

     picture_id=@family_website_owner.family_pic.split("_")
    if !is_a_number?(picture_id[1])
      logger.info(picture_id[0].to_i)
      logger.info(@family_website_owner.id)
      family_image=@family_website_owner.img_url+'/hmmuser/familyphotos/'+@family_website_owner.family_pic
      logger.info(family_image)
    else
      img=@family_website_owner.family_pic.split("_")
      content=UserContent.find(:first,:select=>"img_url,v_filename",:conditions=>"id=#{img[1]}")
      family_image=content.img_url+'/user_content/photos/'+content.v_filename
      logger.info(family_image)
    end
    
    contents = Array.new
    contents.push("start")
    contents.push(family_image)
    contents.push(logo_path)
    text="<TEXTFORMAT LEADING='2'><P ALIGN='CENTER'><FONT FACE='BoumBoum' SIZE='20' COLOR='#F7BE81' LETTERSPACING='0' KERNING='0'>May</font> <FONT FACE='verdana' SIZE='20' COLOR='#F7BE81' LETTERSPACING='0' KERNING='0'>pease, love, </font> <FONT FACE='BoumBoum' SIZE='20' COLOR='#F7BE81' LETTERSPACING='0' KERNING='0'>and</font><FONT FACE='BoumBoum' SIZE='20' COLOR='#F7BE81' LETTERSPACING='0' KERNING='0'> joy </font> <FONT FACE='BoumBoum' SIZE='20' COLOR='#F7BE81' LETTERSPACING='0' KERNING='0'>be with you and yours <br />this holiday season.<br />Love the </font><FONT FACE='verdana' SIZE='20' COLOR='#F7BE81' LETTERSPACING='0' KERNING='0'>#{@family_website_owner.v_lname} family</font></P>"
    #text = CGI::escape(text)
    contents.push(text)

    allcards = Hash.new
    cards = Array.new
    template_infos = Card.find(:all,:select =>"id,image_name,image_path,height,width,image_type,img_url")

    if template_infos
      @status = "success"
    else
      @status ="failure"
    end

    if @family_website_owner.studio_id != 0
      book_session = "#{@path.proxyname}/my_familywebsite/book_session?studio_id=#{@family_website_owner.studio_id}"
    else
      book_session ="http://s121.com/bookonline.asp"
    end

    if @family_website_owner.studio_id.to_i == 0
    address="14149 Westfair East Drive"
    phone="281-890-8171"
    city = "Houston"
    zip_code = "TX 77041"
    else
    studio_address = HmmStudio.find(:first,:conditions=>"id=#{@family_website_owner.studio_id}")
    address=  studio_address.studio_address
    phone= studio_address.studio_phone
    city = studio_address.city
    zip_code = studio_address.zip_code

    end
   
    for template_info in template_infos
      i=1
      card_image = Hash.new
      card_image ={:id =>template_info.id,:name =>template_info.image_name,:icon =>template_info.img_url+'/themes/'+template_info.image_path,:height =>template_info.height,:width =>template_info.width,:type=>template_info.image_type}
      images=CardItem.find(:all,:select =>"image_type,x,y,height,width")
      image_array = Array.new()
      for image in images
        card_items=Hash.new()
        card_items ={:type => image.image_type,:x=> image.x,:y=>image.y,:height =>image.height,:width =>image.width,:source=>contents[i] }
        image_array.push(card_items)
        i = i+1
      end
      card_items ={:type => "background",:height =>template_info.height,:width =>template_info.width,:source=>template_info.img_url+'/themes/'+template_info.image_path }
      image_array.push(card_items)
      card_image['items']= image_array
      cards.push(card_image)
    end
    allcards['body'] = cards
    allcards['studio_session_url'] = book_session
    allcards['status'] = @status
    allcards['address'] = "#{address} | #{city}, #{zip_code} | #{phone}"
    logger.info(allcards.inspect)
    render :text => allcards.to_json
  end

  def is_a_number?(s)
    s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end

  
  def card_cart_list
    puts "==================="
    puts params.inspect
    puts session[:hmm_user]
    puts "==================="
    session[:card_id] = params[:card_id]
    @user = HmmUser.find(session[:hmm_user])

    card = Card.find(session[:card_id])
    
    @shipping_address = ShippingInformation.find(:first,:joins => "INNER JOIN states ON states.id = shipping_informations.state",
        :conditions=>"user_id='#{@user.id}'", :select => "shipping_informations.*,states.state as state_name")

    #unless card.nil?
      @card_carts = CardCart.find_all_by_user_id_and_status(@user.id,"cart")
      #@card_cart = CardCart.find_by_id_and_user_id(params[:card_id],@user.id)
      #if @card_cart.nil?
        @card_cart = CardCart.new()
        @card_cart.card_id = card.id
        @card_cart.user_id = @user.id
        @card_cart.image_data = card.image_path
        @card_cart.quantity = 1
        @card_cart.status = "cart"
        @card_cart.studio_id = @user.studio_id
        @card_cart.price = 19.95
        @card_cart.net_price = 0.0
        @card_cart.save
      #end

      subtotal = 0
      price = 0
      salestax = 0
      @card_carts.each do |item|
        #card_price = CardPrice.find_by_card_id(item.card_id)
        if item.quantity == 1
            #price = card_price.price
            item.price = 19.95
        else
            #price = card_price.net_price rescue nil
            item.net_price = (item.quantity * item.price)
        end
        subtotal = (subtotal + price.to_i)
        sales_tax = StateSalestax.find_by_state_id(@shipping_address.id)
        salestax = salestax + sales_tax.tax_rate
      end
      @shipping_method = ShippingMethod.find_by_studio_id(@user.studio_id)
      
      get_studio_shipping(@user.studio_id,@shipping_method.id,subtotal,salestax)
      
    #end
   
  
 end

 def get_studio_shipping(studio_id,method_id,subtotal,salestax)
      @shipping = ShippingMethod.find(:first,:joins=>"as a,shipping_prices as b",
        :conditions=>"a.id=b.method_id and a.studio_id=#{studio_id} and b.method_id=#{method_id} and
  b.start_price <= #{subtotal} and b.end_price >= #{subtotal}",:select=>"b.ship_price") 
      @shipping_price = Float(@shipping.ship_price).round(2)
      @total = Float(subtotal) + @shipping_price
      
      unless salestax == 0.0 
        @salestax = (Float(Float(salestax)/100))*Float(@total)
        @total = Float(@total)+Float(@salestax).round(2)
      end
      

  #    i=0
  #    for order in session[:orders]
  #      if order[:studio_id] == Integer(studio_id)
  #        session[:grand_total] = (session[:grand_total] - session[:orders][i][:total])+@total
  #        session[:orders][i][:shipping_price] = @shipping_price
  #        session[:orders][i][:total] = @total
  #      end
  #      i=i+1
  #    end
    
  end

 def update_card_cart_quantity
     user = HmmUser.find(session[:hmm_user])
     @card_cart = CardCart.find(params[:id])
     @card_cart.update_attributes(:quantity=>params[:qty],:net_price=>@cart_cart.price * params[:qty].to_i)
     #@cart_price = CardPrice.find_by_card_id(@card_cart.card_id)
     #@cart_price.update_attributes(:net_price=>@cart_price.price * params[:qty].to_i)
     redirect_to "/cards_selector/card_cart_list/#{user.v_fname}"
 end

 def delete_item_cart
    user = HmmUser.find(session[:hmm_user])
    @card_cart = CardCart.find_by_id_and_status(params[:id],"cart")
    @card_cart.destroy
    redirect_to "/cards_selector/card_cart_list/#{user.v_fname}"
 end

  def clear_cart
    user = HmmUser.find(session[:hmm_user])
    card_carts = CardCart.find_all_by_user_id_and_status(session[:hmm_user],"cart")
    CardCart.destroy card_carts.collect(&:id)
    redirect_to "/carts/cart_list/#{user.v_fname}"
  end

  def draw_image
    puts "======================="
    puts params.inspect
    puts "======================="
    text = "<html><body>May <I>please,love</I> and <I>joy</I> be with you and yours this holiday season. Love, The <I>#{params[:id]}</I> Family</body></html>"
    #Image parameters
    options = {:img_width => 500, :img_height => 300, :text_color => "#FF0000", :font_size => 12,
    :text => "text", :bg_color => "#FFD700"}

    #Initialize a container with it's width and height
    container=Magick::Image.new(options[:img_width],options[:img_height]){
    self.background_color = options[:bg_color]
    }

    #Initialize a new image
    image=Magick::Draw.new
    image.stroke('transparent')
    image.fill(options[:text_color])
    image.font='/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType/Verdana_Italic.ttf'
    image.pointsize=options[:font_size]
    image.font_weight=Magick::BoldWeight
    image.text(0,0,options[:text])
    image.text_antialias(false)
    image.font_style=Magick::NormalStyle
    image.gravity=Magick::CenterGravity


    #Place the image onto the container
    image.draw(container)
    #container=container.raise(3,1)

    # To test the image(a pop up will show you the generated dynamic image)
    container.display

    # generated image will be saved in public directory
    container.write("public/image.jpg")
  end

end
