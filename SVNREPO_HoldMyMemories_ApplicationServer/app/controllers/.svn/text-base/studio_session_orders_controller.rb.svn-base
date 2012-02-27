class StudioSessionOrdersController < ApplicationController

  require 'json/pure'
  #require 'mini_exiftool'
  layout "familywebsite_studio"
  #service to return the active image galleries and albums for the family website.
  helper :user_account
  include UserAccountHelper

  before_filter :check_account, :only => [:gallery_list,:logged_gallery_list,:print_orders,:gallery_contents_service]
#  before_filter :visitor_check_account, :only => [:print_orders]
#
#  def visitor_check_account
#    @path = ContentPath.find(:first, :conditions => "status='active'")
#    unless session[:vistor_id].nil?
#      puts "=========filter================"
#      @visitor = OrderRequest.find(session[:vistor_id])
#      redirect_to :action=>"test"
#    else
#
#    end
#
#  end

  def check_account
    unless params[:id].blank?
      #if session[:visitor_id]
       # visitor = OrderRequest.find(session[:visitor_id])
        #owner = HmmUser.find(visitor.owner_id)
        #session[:hmm_user] = owner.id
        #@family_website_owner = HmmUser.find(:first,:joins =>"INNER JOIN themes on hmm_users.theme_id=themes.id", :conditions => "(family_name='#{owner.family_name}' || alt_family_name='#{owner.family_name}')",:select => "hmm_users.*,themes.stylesheet as theme") #get the user details
      #else
        @family_website_owner = HmmUser.find(:first,:joins =>"INNER JOIN themes on hmm_users.theme_id=themes.id", :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')",:select => "hmm_users.*,themes.stylesheet as theme") #get the user details
      #end
      if @family_website_owner
        if(session[:employe]==nil && @family_website_owner.terms_checked == 'false' ) #if the logged in user is not employee and terms is not agreed
          flash[:terms] = 'terms'
          if(session[:hmm_user]) #f the user is logged in, takes to agree terms page
            redirect_to "/user_account/update_terms/"
          elsif(session[:visitor_id])
            redirect_to "/studio_session_orders/print_orders/#{params[:id]}"
          else #if the user is not logged in, takes to login page
            redirect_to "/familywebsite/login/#{params[:id]}" if params[:action]!='login'
          end
        elsif @family_website_owner.e_user_status=='blocked' #displays message, if the user is blocked
          render :text => "This Familywebsite has been Blocked. Please contact Website Administrator at <a href='mailto:admin@holdmymemories.com' >admin@HoldMyMemories.com</a>"
        elsif session[:visitor]==nil && session[:hmm_user]==nil && @family_website_owner.password_required == 'yes'
          #render :text =>"Password protected. Redirect to family website login page"
          redirect_to :controller =>"familywebsite", :action => 'visitor_login', :id => params[:id], :redirect_url => request.url if (params[:action]!='login' && params[:action]!='visitor_login')
          elsif session[:visitor_id]
            logger.info "==========visitor login============="
            logger.info params.inspect
            logger.info session[:visitor_id]
            #redirect_to "/studio_session_orders/print_orders/#{params[:id]}"
#        elsif !session[:hmm_user] || logged_in_hmm_user.id!=@family_website_owner.id
#          redirect_to "/familywebsite/login/#{params[:id]}"
#          logger.info("In controller5")
        else
          logger.info "88888888888888"
          logger.info session[:visitor_id]
          logger.info params.inspect
          logger.info "88888888888888"
          @path = ContentPath.find(:first, :conditions => "status='inactive'")
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

  #  def gallery_list
  #    allgallery = Array.new
  #    userimage = Hash.new
  #    if params[:gallery_id].nil?
  #      subchapters= SubChapter.find(:all,:select=>"id",:conditions=>"uid=#{@family_website_owner.id} and store_id!=''",:order=>"id desc")
  #      type="print_orders"
  #      #@userimages = FamilywebsiteStudio.getinfo(suchapter_images,type)
  #      @userimages = Galleries.find_all_by_subchapter_id(subchapters.collect{|ele| ele.id },:order=>"created_at desc")
  #      @userimages.each do |gallery|
  #        img1 = "#{gallery.img_url}/user_content/photos/icon_thumbnails/#{gallery.v_gallery_image}"
  #        userimage = {:id=>gallery.id,:img_url=>img1,:gallery_name=>gallery.v_gallery_image}
  #        allgallery << userimage
  #      end
  #    else
  #      @userimages = UserContent.find(:all,:select =>"id,img_url",:conditions=>"gallery_id=#{params[:gallery_id]}",:order=>"id desc")
  #      gallery = Galleries.find(params[:gallery_id])
  #      @userimages.each do |img|
  #        img1 = "#{img.img_url}/user_content/photos/big_thumb/#{img.v_filename}"
  #        userimage = {:id=>img.id,:img_url=>img1,:file_name=>img.v_filename,:gallery_name=>gallery.v_gallery_image}
  #        allgallery << userimage
  #      end
  #    end
  #    render :text => allgallery.to_json
  #  end

  def gallery_list
    if params[:visitor_id].to_i > 0
      @family_website_owner = HmmUser.find_by_family_name(params[:id])
    end
    allgallery = Array.new
    userimage = Hash.new
    subchapters= SubChapter.find(:all,:select=>"id",:conditions=>"uid=#{@family_website_owner.id} and store_id!=''",:order=>"id desc")
    for subchapter in subchapters
      galleries = Galleries.find(:all,:conditions=>"subchapter_id=#{subchapter.id} and 	e_gallery_type='image'",:order=>"id desc")
      for gallery in galleries
        usercontent=UserContent.count(:all,:conditions=>"gallery_id=#{gallery.id}")
        if usercontent.to_i > 0
          img1 = "#{gallery.img_url}/user_content/photos/icon_thumbnails/#{gallery.v_gallery_image}"
          userimage = {:id=>gallery.id,:img_url=>img1,:gallery_name=>gallery.v_gallery_image,:gallery_name=>gallery.v_gallery_name}
          allgallery.push(userimage)
        end
      end
    end
    render :text => allgallery.to_json
  end

  def logged_gallery_list
    allgallery = Array.new
    userimage = Hash.new
    subchapters= SubChapter.find(:all,:select=>"id",:conditions=>"uid=#{@family_website_owner.id} and status='active' and e_access='public' and store_id!=''",:order=>"id desc")
    for subchapter in subchapters
      galleries = Galleries.find(:all,:conditions=>"subchapter_id=#{subchapter.id} and  e_gallery_acess='public' and status='active' and 	e_gallery_type='image'",:order=>"id desc")
      for gallery in galleries
        usercontent=UserContent.count(:all,:conditions=>"gallery_id=#{gallery.id} and status='active' and e_access='public'")
        if usercontent.to_i > 0
          img1 = "#{gallery.img_url}/user_content/photos/icon_thumbnails/#{gallery.v_gallery_image}"
          userimage = {:id=>gallery.id,:img_url=>img1,:gallery_name=>gallery.v_gallery_image,:gallery_name=>gallery.v_gallery_name}
          allgallery.push(userimage)
        end
      end
    end
    render :text => allgallery.to_json
  end

  def gallery_contents_service
    #sizes = Hash.new
    #userimage = Hash.new
    variants = Array.new
    gallery = Galleries.find(params[:gallery_id]) rescue nil
    type = "print_orders"
    if gallery.nil?
      subchapters= SubChapter.find(:all,:select=>"id",:conditions=>"uid=#{@family_website_owner.id} and store_id!=''",:order=>"id desc")
      type="image"
      @userimages = FamilywebsiteStudio.getinfo(subchapters,type)
    else
      @userimages=UserContent.find(:all,:conditions=>"gallery_id=#{gallery.id}",:order=>"id desc")
    end
    #    unless @userimages.nil?
    #        @userimages.each do |img|
    #            subchapter = SubChapter.find(img.sub_chapid)
    #            unless subchapter.store_id.nil?
    #              studio = HmmStudio.find(subchapter.store_id)
    #              printsizeprice = PrintSizePrice.find(studio.id)
    #              printsize = PrintSize.find(printsizeprice.print_size_id)
    #              img1 = "#{img.img_url}/public/user_content/photos/big_thumb/#{img.v_filename}"
    #              sizes = {:id=>printsize.id,:label=>printsize.label,:width=>printsize.width,:height=>printsize.height}
    #              userimage = {:id=>img.id,:img_url=>img1,:file_name=>img.v_filename,:type=>"print_orders",:sizes => sizes}
    #              variants << userimage
    #            end
    #        end
    #    end
    unless @userimages.nil?
      @userimages.each do |img|
        subchapter = SubChapter.find(img.sub_chapid)
        unless subchapter.store_id.nil?
          @userimages1 = FamilywebsiteStudio.elligible_size_images(img,subchapter.store_id)
        end
        variants << @userimages1
      end
    end

    render :text => variants.to_json
  end

  def print_orders
     user = HmmUser.find_by_family_name(params[:id])
    if session[:hmm_user] or user.v_user_name == params[:username] or session[:visitor_id]
      @path1 = ContentPath.find(:first, :conditions => "status='active'")
      if session[:visitor_id]
        content1 = ContentPath.find(:first, :conditions => "status='inactive'")
        @content_server_url = content1.content_path
      end
    else
      flash[:error] = "Either your username or password is incorrect. Please try again."
      redirect_to :controller=>"familywebsite_studio",:action => 'home', :id => params[:id]
    end
  end

 def check_user_session
    if(session[:hmm_user])
      if (logged_in_hmm_user.alt_family_name == params[:id] || logged_in_hmm_user.family_name == params[:id])
        render :text=>"true"
      else
        render :text=>"false"
      end
    elsif session[:visitor_id]
      render :text=>"true"
    else
      render :text=>"false"
    end
  end

end