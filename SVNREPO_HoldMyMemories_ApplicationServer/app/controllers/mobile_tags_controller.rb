class MobileTagsController < ApplicationController
  require 'json/pure'
  layout false
  before_filter :response_header

  def response_header
    response.headers['Pragma' ] = 'no-cache'
    response.headers['Cache-Control' ] = 'no-store, no-cache, max-age=0, must-revalidate'
    response.headers['Content-Type' ] = 'text/x-json'
  end

  # chapter service for the mobile application
  # input:user_id
  # output:json,returns the chapter list of the given user id
  # created by :parthi
  def get_chapters
    @retval = Hash.new()
    if !params[:user_id].blank? #&& !params[:offset].blank?
      @output = Array.new
      mobile_chapter = MobileTag.find(:first,:conditions => "uid = #{params[:user_id]} and tag_type = 'mobile_uploads' and status='active'")
      if mobile_chapter
        select = "id as chapter_id,sub_chapname as chapter_name,v_desc as chapter_description,'event' as type,auto_share,CONCAT(img_url,'/user_content/photos/icon_thumbnails/',v_image) as chapter_image"
        @conditions= ["tagid= :chapter_id AND status='active'",{:chapter_id => mobile_chapter.id}]
        @mobile_events = MobileSubChapter.find(:all,:conditions=>@conditions,:select=> select)
      end

      @chapters = MobileTag.find(:all,
        :conditions=>["uid=? and status='active' and default_tag='yes' and v_tagname not like 'STUDIO SESSIONS' and tag_type not like 'mobile_uploads'",params[:user_id]],
        :select=>"v_desc as chapter_description,id as chapter_id,v_tagname as chapter_name,CONCAT(img_url,'/user_content/photos/icon_thumbnails/',v_chapimage) as chapter_image,tag_type as type,auto_share")

      if(@mobile_events!=nil && @chapters!=nil)
        @output = @mobile_events + @chapters
      elsif @mobile_events!=nil
        @output = @mobile_events
      elsif @chapters!=nil
        @output = @chapters
      end

      @retval['count'] = @output.length
      @retval['body'] = @output
      @retval['status'] = true
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    render :text => @retval.to_json
  end

  # create chapter service for the mobile application
  # input:user_id,chapter name, chapter description
  # output:json,returns the chapter list of the given user id
  # created by :parthi
  def create_chapter
    @retval = Hash.new()
    if !params[:chapter_name].blank? && !params[:user_id].blank?
      if !params[:auto_share].blank? && params[:auto_share]=='1'
        auto_share = 1
      else
        auto_share = 0
      end

      unless params[:chapter_description].blank?
        desc = params[:chapter_description]
      else
        desc = 'Enter description here...'
      end

      if !params[:facebook_share].blank? && params[:facebook_share]=='1'
        facebook_share = 1
      else
        facebook_share = 0
      end

      result = MobileTag.save_chapter(params[:chapter_name], params[:user_id], desc,auto_share,facebook_share)
      chapters = MobileTag.synchronize_chapters(params)
      if chapters && result
        if auto_share==1 && !params[:emails].blank?
          emails = JSON.parse(params[:emails])
          for email in emails
            share = AutoShare.new()
            share.share_type = 'chapter'
            share.share_type_id = result.id
            share.email = email
            share.save()
          end
        end
        @retval['body'] = chapters
        @retval['status'] = true
      else
        @retval['status'] = false
        @retval['message'] = "Chapter creation failed!"
      end
    else
      @retval['message'] = "Incomplete data provided!"
      @retval['status'] = false
    end
    logger.info @retval.to_json
    render :text=>@retval.to_json
  end

  # create quick album service for the mobile application
  # input:user_id,album name, album description,type
  # output:json,returns the details of created quick album
  # created by :parthi
  def create_quick_album
    @retval = Hash.new()
    if !params[:album_name].blank? && !params[:user_id].blank? && !params[:type].blank?

      if !params[:auto_share].blank? && params[:auto_share]=='1'
        auto_share = 1
      else
        auto_share = 0
      end

      unless params[:chapter_description].blank?
        desc = params[:chapter_description]
      else
        desc = 'Enter description here...'
      end

      if !params[:facebook_share].blank? && params[:facebook_share]=='1'
        facebook_share = 1
      else
        facebook_share = 0
      end

      result = MobileTag.save_quick_album(params[:album_name],desc, params[:user_id], params[:type],auto_share,facebook_share)
      chapters = MobileTag.synchronize_chapters(params)
      if chapters && result
        if auto_share==1 && !params[:emails].blank?
          emails = JSON.parse(params[:emails])
          for email in emails
            share = AutoShare.new()
            share.share_type = 'chapter'
            share.share_type_id = result.id
            share.email = email
            share.save()
          end
        end
        @retval['body'] = chapters
        @retval['status'] = true
      else
        @retval['status'] = false
        @retval['message'] = "Quick album creation failed!"
      end
    else
      @retval['message'] = "Incomplete data provided!"
      @retval['status'] = false
    end
    render :text=>@retval.to_json
  end

  #service to update the chapter details
  #input : chapter_id
  #output : returns sync chapters
  def update_chapter
    @retval = Hash.new()
    unless params[:chapter_id].blank? && params[:chapter_name].blank? && params[:auto_share].blank?
      if !params[:auto_share].blank? && params[:auto_share]=='1'
        auto_share = 1
      else
        auto_share = 0
      end
      result = MobileTag.update(params[:chapter_id], :v_tagname => params[:chapter_name], :auto_share => auto_share)
      if params[:auto_share] == '1'
        unless params[:emails].blank?
          emails = JSON.parse(params[:emails])
          AutoShare.delete_all("share_type='chapter' and share_type_id=#{params[:chapter_id]}")
          for email in emails
            share = AutoShare.new()
            share.share_type = 'chapter'
            share.share_type_id = params[:chapter_id]
            share.email = email
            share.save()
          end
        else
          AutoShare.delete_all("share_type = 'chapter' and share_type_id = #{params[:chapter_id]}")
        end
        unless params[:facebook_share].blank?
          if params[:facebook_share]=='1'
            facebook_share = 1
          else
            facebook_share = 0
          end
          MobileTag.update(params[:chapter_id], :facebook_share => facebook_share)
        end
      end

      if result
        chapters = MobileTag.synchronize_chapters(params)
        if chapters
          @retval['body'] = chapters
          @retval['status'] = true
          @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
        else
          @retval['message'] = 'Error while sync chapter!'
          @retval['status'] = false
        end
      else
        @retval['message'] = 'Error while updating chapter!'
        @retval['status'] = false
      end
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end

    render :text => @retval.to_json
  end

  def all_get_chapters
    @retval = Hash.new()
    if !params[:user_id].blank? #&& !params[:offset].blank?
      @output = Array.new
      mobile_chapter = MobileTag.find(:first,:conditions => "uid = #{params[:user_id]} and tag_type = 'mobile_uploads' and status='active'")
      if mobile_chapter
        select = "id as chapter_id,sub_chapname as chapter_name,v_desc as chapter_description,'event' as type,auto_share,CONCAT(img_url,'/user_content/photos/icon_thumbnails/',v_image) as chapter_image,store_id as studio_id"
        @conditions= ["tagid= :chapter_id AND status='active'",{:chapter_id => mobile_chapter.id}]
        @mobile_events = MobileSubChapter.find(:all,:conditions=>@conditions,:select=> select)
      end

      @chapters = MobileTag.find(:all,
        :conditions=>["a.uid=? and a.status='active' and a.default_tag='yes'  and a.tag_type not like 'mobile_uploads' and a.id=b.tagid",params[:user_id]],
        :joins=>"as a,sub_chapters as b",
        :select=>"a.v_desc as chapter_description,a.id as chapter_id,a.v_tagname as chapter_name,CONCAT(a.img_url,'/user_content/photos/icon_thumbnails/',a.v_chapimage) as chapter_image,a.tag_type as type,a.auto_share,b.store_id as studio_id",
        :group=>"a.id")
      if(@mobile_events!=nil && @chapters!=nil)
        @output = @mobile_events + @chapters
      elsif @mobile_events!=nil
        @output = @mobile_events
      elsif @chapters!=nil
        @output = @chapters
      end
      @retval['count'] = @output.length
      @retval['body'] = @output
      @retval['status'] = true
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    logger.info(@output.inspect)
    render :text => @retval.to_json
  end
end