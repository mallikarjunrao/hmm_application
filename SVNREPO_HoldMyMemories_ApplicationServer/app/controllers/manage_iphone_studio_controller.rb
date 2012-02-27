class ManageIphoneStudioController < ApplicationController
  require 'cgi'
  require 'apns'
  require 'openssl'

  layout :phone_or_desktop
  #  layout "iphone_application"
  def manage_studiologo
    logo = Array.new
    info= Hash.new
    if !params[:studio_id].blank? && !params[:studio_id].nil?
      path = ContentPath.find(:first,:conditions=>"status='active'")
      studio=IphoneAboutusStudioLogo.find(:first,:select=>"mobile_studio_logo,logo_img_url",:conditions=>"studio_id=#{params[:studio_id]}")
      if studio
        if studio.mobile_studio_logo
          small_image = studio.mobile_studio_logo
          big_image = small_image.gsub("small", "big")
          logger.info( studio.inspect)
          info ={:small_mobile_studio_logo =>"#{studio.logo_img_url}/user_content/mobile_studio_logos/#{studio.mobile_studio_logo}",:big_mobile_studio_logo =>"#{studio.logo_img_url}/user_content/mobile_studio_logos/#{big_image}",:status =>"success"}
          logo.push(info)
        else
          info ={:status =>"failure"}
          logo.push(info)
        end
      else
        info ={:status =>"failure"}
        logo.push(info)
      end
    else
      info ={:status =>"failure"}
      logo.push(info)
    end
    render :text =>logo.to_json
  end

  def manage_aboutus
    path = ContentPath.find(:first,:conditions=>"status='active'")
    #aboutus = Array.new
    info= Hash.new
    if !params[:studio_id].blank? && !params[:studio_id].nil?
      studio=IphoneAboutusStudioLogo.find(:first,:select=>"aboutus_image,description,about_us_img_url",:conditions=>"studio_id=#{params[:studio_id]}")
      if studio
        if studio.aboutus_image || studio.description
          desc="<html><body style='background-color:#00192F'><table border='0' style='background-color:#00192F' width='100%' height='100%'><tr><td><font face='arial' size='15' color='#ffffff'>#{CGI.unescapeHTML(studio.description)}</font></td></tr></table></body></html>"
          logger.info( studio.inspect)
          info ={:aboutus_image =>"#{studio.about_us_img_url}/user_content/studio_aboutus_logos/#{studio.aboutus_image}",:description =>desc,:status =>"success"}

        else
          info ={:status =>"failure"}

        end
      else
        info ={:status =>"failure"}

      end
    else
      info ={:status =>"failure"}

    end
    render :text => info.to_json
  end

  def manage_studio_specials
    studio_specials = Hash.new
    if !params[:studio_id].blank? && !params[:studio_id].nil?
      studio_special_arr=StudioSpecial.find(:all,:select=>"title,description", :conditions => "studio_id=#{params[:studio_id]}", :order => "id desc")
      if  studio_special_arr
        specials = Array.new
        for studio_special in studio_special_arr
          info= Hash.new
          studio_special.description = studio_special.description
          desc = studio_special.description
          #desc = desc.gsub(/\n/,"<br />")
          desc = desc.gsub(/\r/,"")
          info ={:title => studio_special.title,:description =>(CGI.unescapeHTML desc)}
          specials.push(info)
        end
        logger.info(specials.inspect)
        studio_specials['status'] = "success"
        studio_specials['specials'] = specials
      else
        studio_specials['status'] = "failure"
      end
    else
      studio_specials['status'] = "failure"
    end
    render :text => studio_specials.to_json

  end

  def manage_booking_info
    studio_booking_info = Hash.new
    booking_infos = Array.new
    info= Hash.new
    if !params[:studio_id].blank? && !params[:studio_id].nil?
      infos=BookingInfo.find(:first,:conditions=>"studio_id=#{params[:studio_id]}")
      if infos
        info ={:phone_no => infos.phone_no,:email => infos.email,:url => infos.url}
        status="true"
        studio_booking_info={:status=>status, :body=> info}
      else
        status ="false"
        booking_infos.push(info)
        studio_booking_info={:status=>status}

      end
    else
      status ="false"
      booking_infos.push(info)
      studio_booking_info={:status=>status}
    end

    render :text =>  studio_booking_info.to_json
  end


  def manage_studio_portfolios
    all_studio_portfolios = Hash.new
    if !params[:studio_id].blank? && !params[:studio_id].nil?
      path = ContentPath.find(:first,:conditions=>"status='active'")
      studio_portfolios=StudioPortfolio.find(:all,:select=>"category_name,category_image,img_url" , :conditions => "studio_id=#{params[:studio_id]}" ,:group =>"category_name", :order => "id desc")
      if  studio_portfolios
        portfolios = Array.new
        for studio_portfolio in studio_portfolios
          small_image = studio_portfolio.category_image
          big_image = small_image.gsub("small", "big")
          portfolio = Hash.new
          portfolio ={:category_name => studio_portfolio.category_name,:small_category_image =>studio_portfolio.img_url+'/user_content/studio_portfolio_images/'+studio_portfolio.category_image}
          portfolios.push(portfolio)
        end
        all_studio_portfolios['portfolios'] = portfolios
        all_studio_portfolios['status'] = "success"
      else
        all_studio_portfolios['status'] = "failure"
      end
    else
      all_studio_portfolios['status'] = "failure"
    end
    render :text => all_studio_portfolios.to_json
  end


  def view_studio_sample_portfolio
    all_portfolio_sample = Hash.new
    if !params[:category_name].blank?  && !params[:category_name].blank?  && !params[:studio_id].blank? && !params[:studio_id].nil?
      path = ContentPath.find(:first,:conditions=>"status='active'")
      if(params[:category_name]!='' && params[:category_name]!=nil)
        samples=StudioPortfolio.find(:all,:select =>"category_name,category_image,img_url",:conditions => "category_name='#{params[:category_name]}' and studio_id=#{params[:studio_id]} " , :order => "category_name desc")
        if  samples
          portfolio_samples = Array.new
          for sample in samples
            small_image = sample.category_image
            big_image = small_image.gsub("small", "big")
            portfolio_sample = Hash.new
            portfolio_sample ={:category_name => sample.category_name,:small_category_image =>sample.img_url+'/user_content/studio_portfolio_images/'+sample.category_image,:big_category_image =>sample.img_url+'/user_content/studio_portfolio_images/'+big_image}
            portfolio_samples.push( portfolio_sample)
          end
          all_portfolio_sample['body'] =  portfolio_samples
          all_portfolio_sample['status'] = "success"
        else
          all_portfolio_sample['status'] = "failure"
        end
      else
        all_portfolio_sample['status'] = "failure"
      end
      render :text =>  all_portfolio_sample.to_json
    end
  end

  def booking_info
    if params[:studio_id] && params[:studio_id]!=nil
      @hmm_studio = HmmStudio.find(params[:studio_id])
      if  @hmm_studio
        unless @hmm_studio.studio_top_logo == nil || @hmm_studio.studio_top_logo == ""
          @studio_header_img = "#{ @hmm_studio.studio_top_logo}_white.png" if  @hmm_studio.studio_top_logo != nil
          @studio_website =  @hmm_studio.studio_website if  @hmm_studio.studio_website != nil
        else
          @studio_header_img="default_top_logo_white.png" #default logo depending upon the header logo color specified in the themes table
          @studio_website = "/" #default studio link
        end
      end

    end
    render(:layout => false)
  end

  def manage_get_studios
    all_portfolio_sample = Hash.new
    if(params[:studio_groupid]!='' && params[:studio_groupid]!=nil)
      studios=HmmStudio.find(:all,:conditions=>"iphone_app_status='Approved' and studio_groupid=#{params[:studio_groupid]}")
      if  studios
        portfolio_samples = Array.new
        for sample in studios
          studio_name = sample.studio_name
          studio_id = sample.id
          studio_list = Hash.new
          studio_list ={:studio_name => studio_name,:studio_id =>studio_id}
          portfolio_samples.push(studio_list)
        end
        all_portfolio_sample['body'] =  portfolio_samples
        all_portfolio_sample['status'] = "success"
      else
        all_portfolio_sample['status'] = "failure"
      end
    else
      all_portfolio_sample['status'] = "failure"
    end
    render :text =>  all_portfolio_sample.to_json
  end


  def home
    render :layout=>false
  end

  def send_studio_notification
    APNS.host = 'gateway.push.apple.com'
    APNS.pem  = "#{RAILS_ROOT}/config/apple_push_notification_studio_production.pem"
    APNS.pass = 's121studio'
    all_studio_specials=StudioSpecial.find(:all,:conditions=>"status='active'")
    logger.info("Inside special")
    for all_studio_special in all_studio_specials
      devices=IphoneDevice.find(:all,:conditions=>"studio_id=#{all_studio_special.studio_id}")
      for device in devices
        logger.info("Inside device")
        APNS.send_notification(device.token, :alert => all_studio_special.title, :badge => 1, :sound => 'default',:studio_id=>device.studio_id,:studio_groupid=>device.studio_groupid,:notification_target=>"studio_specials")
      end
      logger.info("Outside device")
      specials=StudioSpecial.find(:first,:conditions=>"id=#{all_studio_special.id}")
      specials.status="inactive"
      specials.save
    end
    logger.info("Outside special")
    render :text=>"true"
  end

  def register_notification_device
    if params[:device_token] && params[:studio_id] && params[:studio_group_id]
      devices_count=IphoneDevice.count(:conditions=>"token='#{params[:device_token]}' and studio_id=#{params[:studio_id]}")
      if devices_count == 0
        devices=IphoneDevice.new
        devices.token=params[:device_token]
        devices.studio_id=params[:studio_id]
        devices.studio_groupid=params[:studio_group_id]
        devices.save
      end
    end
  end

  def users_data
    #    if params[:type]=="gallery"
    #      @galleries=Galleries.find(:all,:conditions=>"subchapter_id=#{params[:id]} and e_gallery_acess='public' and status='active'",:order=>"id desc")
    #    elsif params[:type]=="images"
    #      @user_images=UserContent.find(:all,:conditions=>"gallery_id=#{params[:id]} and e_access='public' and status='active'",:order=>"id desc")
    #    elsif params[:type]=="subchapters"
    #      @sub_images=SubChapter.find(:all,:conditions=>"tagid=#{params[:id]} and e_access='public' and status='active'",:order=>"id desc")
    #    else
    #      user_id=HmmUser.find(:first,:select=>"id",:conditions=>"family_name='#{params[:id]}'")
    #      @chap_images=Tag.find(:all,:conditions=>"uid=#{user_id.id} and e_access='public' and status='active'",:order=>"id desc")
    user_id=HmmUser.find(:first,:select=>"id",:conditions=>"family_name='#{params[:id]}'")
    @user_images=UserContent.find(:all,:select =>"id,img_url,v_filename",:conditions=>"status='active' and e_access='public' and e_filetype='image' and uid=#{user_id.id}",:group => 'v_filename',:order=>"id desc",:limit=>100)

    #    end

  end


  def coverflow
    user_id=HmmUser.find(:first,:select=>"id",:conditions=>"family_name='#{params[:id]}'")
    if user_id
      @studio_portfolios = UserContent.find(:all,:select =>"img_url,v_filename,d_createddate",:conditions=>"status='active' and e_access='public' and e_filetype='image' and uid=#{user_id.id}",:group => 'v_filename',:order=>"id desc",:limit => 10)
    else
      @studio_portfolios = []
    end
    #    @studio_data = @studio_portfolios.to_xml(:dasherize => false, :skip_types => true, :only => [:img_url, :v_filename, :d_createddate])
    #    @studio_xml=@studio_xml.gsub('<?xml version="1.0" encoding="UTF-8"?>','')
    #    @studio_xml = @studio_xml.gsub(/\n/,'')
    if iphone_request?
      respond_to do |format|
        format.iphone do  # action.iphone.erb
        end
      end
      render :layout => false
    end
  end
    
  def upload
    if iphone_request?
      respond_to do |format|
        format.iphone do  # action.iphone.erb
        end
      end
    end
  end

  def uploader
    @filename = params['Filedata']

    newf = File.open('/home/guest1/test_result/' + @filename, "wb")
    str =  request.body.read
    if newf.write(str)
      render :json => '{success:true}'
    end
    newf.close
  end

  def test
    render :layout=>false
  end

  private

  def phone_or_desktop
    iphone_request? ? "iphone_application" : "application"
  end
end