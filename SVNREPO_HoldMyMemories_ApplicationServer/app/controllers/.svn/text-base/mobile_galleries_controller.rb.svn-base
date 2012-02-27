class MobileGalleriesController < ApplicationController
  require 'json/pure'
  layout false
  before_filter :response_header

  def response_header
    response.headers['Pragma' ] = 'no-cache'
    response.headers['Cache-Control' ] = 'no-store, no-cache, max-age=0, must-revalidate'
    response.headers['Content-Type' ] = 'text/x-json'
  end

  #gallery service for the mobile application
  # input:subchapter_id,offset(record to begin with during paging)
  # output:json,returns the chapter list of the given subchapter id
  # created by :parthi
  def get_galleries
    @retval = Hash.new()
    if !params[:subchapter_id].blank? #&& !params[:offset].blank?
      @galleries = MobileGallery.find(:all,
        :conditions=>{:subchapter_id=>params[:subchapter_id],:status=>'active'},
        :select=>"v_desc as gallery_description,id as gallery_id,v_gallery_name as gallery_name,CONCAT(img_url,'/user_content/photos/icon_thumbnails/',v_gallery_image) as gallery_image,e_gallery_type as gallery_type,DATE_FORMAT(d_gallery_date,'%c/%e/%Y %T') as created_date,auto_share")
      @retval['count'] = @galleries.length
      @retval['body'] = @galleries
      @retval['status'] = true
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    render :text => @retval.to_json
  end

  # create gallery service for the mobile application
  # input:user_id,subchapter_id,gallery_name,gallery type(image/video,audio)
  # output:json,returns the details of created gallery
  # created by :parthi
  def create_gallery
    @retval = Hash.new()
    if !params[:subchapter_id].blank? && !params[:user_id].blank? && !params[:gallery_name].blank? && !params[:gallery_type].blank?
      if !params[:auto_share].blank? && params[:auto_share]=='1'
        logger.info "auto_share params:#{params[:auto_share]}"
        auto_share = 1
      else
        auto_share = 0
      end

      unless params[:gallery_description].blank?
        desc = params[:gallery_description]
      else
        desc = 'Enter description here...'
      end

      if !params[:facebook_share].blank? && params[:facebook_share]=='1'
        facebook_share = 1
      else
        facebook_share = 0
      end
      
      if(result = MobileGallery.save_gallery(params[:gallery_name], desc, params[:gallery_type], params[:user_id], params[:subchapter_id],auto_share,facebook_share))
        galleries = MobileGallery.synchronize_galleries(params)
        if auto_share==1 && !params[:emails].blank?
          emails = JSON.parse(params[:emails])
          for email in emails
            share = AutoShare.new()
            share.share_type = 'gallery'
            share.share_type_id = result.id
            share.email = email
            share.save()
          end
        end
        @retval['body'] = galleries
        @retval['status'] = true
      else
        @retval['status'] = false
        @retval['message'] = "Sub chapter creation failed!"
      end       
    else
      @retval['message'] = "Incomplete data provided!"
      @retval['status'] = false
    end
    render :text => @retval.to_json
  end

  

  #service to delete the gallery
  #input : gallery_id
  #output : Gallery deleted successfully!
  def delete_gallery
    @retval = Hash.new()
    unless params[:selected_ids].blank?
      params[:subchapter_id] = params[:parent_id] #for sync service
      gallery_ids = JSON.parse(params[:selected_ids])
      for gallery_id in gallery_ids
        MobileGallery.update(gallery_id, :status => 'deleted', :deleted_date=>Time.now)
      end     
      galleries = MobileGallery.synchronize_galleries(params)
      if galleries
        @retval['body'] = galleries
        @retval['status'] = true
        @retval['type'] = 'galleries'
        @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      else
        @retval['message'] = 'Error while sync gallery!'
        @retval['status'] = false 
      end
           
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end    
    render :text => @retval.to_json
  end

  #service to update the gallery
  #input : gallery_id,
  #output : Gallery deleted successfully!
  def update_gallery
    @retval = Hash.new()
    unless params[:gallery_id].blank? && params[:gallery_name].blank? && params[:auto_share].blank?
      if !params[:auto_share].blank? && params[:auto_share]=='1'
        auto_share = 1
      else
        auto_share = 0
      end
      result = MobileGallery.update(params[:gallery_id], :v_gallery_name => params[:gallery_name], :auto_share => auto_share)
      if result
        if params[:auto_share] == '1'
          unless params[:emails].blank?
            emails = JSON.parse(params[:emails])
            AutoShare.delete_all("share_type='gallery' and share_type_id=#{params[:gallery_id]}")
            for email in emails
              share = AutoShare.new()
              share.share_type = 'gallery'
              share.share_type_id = params[:gallery_id]
              share.email = email
              share.save()
            end
          else
            AutoShare.delete_all("share_type = 'gallery' and share_type_id = #{params[:gallery_id]}")
          end
          unless params[:facebook_share].blank?
            if params[:facebook_share]=='1'
              facebook_share = 1
            else
              facebook_share = 0
            end
            MobileGallery.update(params[:gallery_id], :facebook_share => facebook_share)
          end
        end
        galleries = MobileGallery.synchronize_galleries(params)
        @retval['body'] = galleries
        @retval['status'] = true
        @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      else
        @retval['message'] = 'Error while deleting gallery!'
        @retval['status'] = false
      end
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    render :text => @retval.to_json
  end
end