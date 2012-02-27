class MobileSubChapter < ActiveRecord::Base
  def
    self.table_name() "sub_chapters"
  end
  def to_json
    self.attributes.to_json
  end

  # returns chapters of given user id and if modified date is given, returns chapters created after that date
  # input:user_id,updated_date
  # output:json,returns the chapter list of the given user id
  # created by :parthi

  def self.return_new_subchapters(params)
    if(params[:type]!=nil && params[:type]=='events')
      select = "id as chapter_id,DATE_FORMAT(created_at,'%c/%e/%Y %T') as created_date,sub_chapname as chapter_name,v_desc as chapter_description,'event' as type,auto_share,CONCAT(img_url,'/user_content/photos/icon_thumbnails/',v_image) as chapter_image"
    else
      select = "v_desc as subchapter_description,id as subchapter_id,sub_chapname as subchapter_name,CONCAT(img_url,'/user_content/photos/icon_thumbnails/',v_image) as subchapter_image,DATE_FORMAT(d_created_on,'%c/%e/%Y %T') as created_date,auto_share"
    end

    @conditions= ["tagid= :chapter_id AND status='active' AND created_at > :updated_date",{:updated_date => params[:updated_date],:chapter_id => params[:chapter_id]}]
    @subchapters = self.find(:all,:conditions=>@conditions,:select=> select)
    if @subchapters.length > 0
      return @subchapters
    else
      return nil
    end
  end

  # returns chapters of given user id and if modified date is given, returns chapters modified after that date
  # input:user_id,updated_date
  # output:json,returns the chapter list of the given user id
  # created by :parthi

  def self.return_updated_subchapters(params)
    if(params[:type]!=nil && params[:type]=='events')
      select = "id as chapter_id,DATE_FORMAT(created_at,'%c/%e/%Y %T') as created_date,sub_chapname as chapter_name,v_desc as chapter_description,'event' as type,auto_share,CONCAT(img_url,'/user_content/photos/icon_thumbnails/',v_image) as chapter_image"
    else
      select = "v_desc as subchapter_description,id as subchapter_id,sub_chapname as subchapter_name,CONCAT(img_url,'/user_content/photos/icon_thumbnails/',v_image) as subchapter_image,DATE_FORMAT(d_created_on,'%c/%e/%Y %T') as created_date,auto_share"
    end
    @conditions= ["tagid= :chapter_id AND status='active' AND updated_at > :updated_date AND created_at <= :updated_date",{:updated_date => params[:updated_date],:chapter_id => params[:chapter_id]}]
    @subchapters = self.find(:all,:conditions=>@conditions,:select=>select)
    if @subchapters.length > 0
      return @subchapters
    else
      return nil
    end
  end

  # returns chapters of given user id and if modified date is given, returns chapters deleted after that date
  # input:user_id,updated_date
  # output:json,returns the chapter list of the given user id
  # created by :parthi
  def self.return_deleted_subchapters(params)
    @conditions= ["tagid= :chapter_id AND status!='active' AND updated_at > :updated_date",{:updated_date => params[:updated_date],:chapter_id => params[:chapter_id]}]
    if(params[:type]!=nil && params[:type]=='events')
      select = "id as chapter_id"
    else
      select = "id as subchapter_id"
    end
    @subchapters = self.find(:all,:conditions=>@conditions,:select=>select)
    if @subchapters.length > 0
      return @subchapters
    else
      return nil
    end
  end

  def self.save_subchapter(subchapter_name,subchapter_description,user_id,chapter_id,gallery_type='all',auto_share=0,facebook_share=0)
    @content_url = ContentPath.find :first,:conditions=>"status='inactive'"
    @subChapter = self.new()
    @subChapter['sub_chapname'] = subchapter_name
    @subChapter['v_desc'] = subchapter_description
    @subChapter['uid'] = user_id
    @subChapter['tagid'] = chapter_id
    @subChapter['order_num'] = 0
    @subChapter['v_image'] = "mobile_uploads.png"
    @subChapter['img_url'] = @content_url['content_path']
    @subChapter['e_access'] = "public"
    @subChapter['e_visible'] = "yes"
    @subChapter['client'] = "iphone"
    @subChapter['permissions'] = user_id
    @subChapter['auto_share'] = auto_share
    @subChapter['facebook_share'] = facebook_share
    @subChapter.d_created_on = Time.now
    @subChapter.d_updated_on = Time.now
    if (@subChapter.save )
      if(gallery_type=='all' || gallery_type=='image')
        MobileGallery.save_gallery("Photo Gallery", "Enter Description Here", "image", user_id, @subChapter.id)
      end
      if(gallery_type=='all' || gallery_type=='video')
        MobileGallery.save_gallery("Video Gallery", "Enter Description Here", "video", user_id, @subChapter.id)
      end
      if(gallery_type=='all' || gallery_type=='audio')
        MobileGallery.save_gallery("Audio Gallery", "Enter Description Here", "audio", user_id, @subChapter.id)
      end
      return @subChapter
    else
      return false
    end
  end

  def self.save_studio_sessions_subchapter(subchapter_name,user_id,chapter_id,content_path,gallery_type)
    @content_url = ContentPath.find :first,:conditions=>"status='inactive'"
    @sub_chapter_studio = SubChapter.new()
    @sub_chapter_studio['uid']=user_id
    @sub_chapter_studio['tagid']=chapter_id
    @sub_chapter_studio['sub_chapname']=subchapter_name
    @sub_chapter_studio['v_image']="folder_img.png"
    @sub_chapter_studio['d_updated_on'] = Time.now()
    @sub_chapter_studio['d_created_on'] = Time.now()
    @sub_chapter_studio['e_access'] = "public"
    @sub_chapter_studio['img_url']=@content_url['content_path']
    @sub_chapter_studio['order_num']=0
    if @sub_chapter_studio.save()
      gallery_name = Time.now.strftime("%B %d, %Y")
      MobileGallery.save_gallery(gallery_name, "Enter description here", gallery_type, user_id, @sub_chapter_studio.id)
    end
  end

  def self.synchronize_subchapters(params)
    if !params[:chapter_id].blank?
      @chapters1 = Hash.new()
      record = self.find_by_sql("select NOW() as updated_time")
      @chapters1['updated_time'] = record[0]['updated_time']
      @new = self.return_new_subchapters(params)
      if @new != nil
        @chapters1['new_records'] = @new
      end
      @updated = self.return_updated_subchapters(params)
      if @updated != nil
        @chapters1['updated_records'] = @updated
      end
      @deleted = self.return_deleted_subchapters(params)
      if @deleted != nil
        @chapters1['deleted_records'] = @deleted
      end
      @chapters1['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      return @chapters1
    else
      return false
    end
  end

  def self.save_memory_lane_subchapter(subchapter_name,subchapter_description,user_id,chapter_id)
    @content_url = ContentPath.find :first,:conditions=>"status='inactive'"
    @subChapter = self.new()
    @subChapter['sub_chapname'] = subchapter_name
    @subChapter['v_desc'] = subchapter_description
    @subChapter['uid'] = user_id
    @subChapter['tagid'] = chapter_id
    @subChapter['order_num'] = 0
    @subChapter['v_image'] = "mobile_uploads.png"
    @subChapter['img_url'] = @content_url['content_path']
    @subChapter['e_access'] = "public"
    @subChapter['e_visible'] = "yes"    
    @subChapter['v_subchapter_tags'] = "Memory Lane"
    @subChapter['client'] = "mliphoneapp"
    @subChapter['permissions'] = user_id
    @subChapter['subchapter_type'] = "memory_lane"
    @subChapter.d_created_on = Time.now
    @subChapter.d_updated_on = Time.now
    if (@subChapter.save )
      MobileGallery.save_gallery(Date.today.strftime("%b %d %Y"), "Enter Description Here", "image", user_id, @subChapter.id)
      MobileGallery.save_gallery(Date.today.strftime("%b %d %Y"), "Enter Description Here", "video", user_id, @subChapter.id)
      MobileGallery.save_gallery(Date.today.strftime("%b %d %Y"), "Enter Description Here", "audio", user_id, @subChapter.id)
      return @subChapter
    else
      return false
    end
  end

end