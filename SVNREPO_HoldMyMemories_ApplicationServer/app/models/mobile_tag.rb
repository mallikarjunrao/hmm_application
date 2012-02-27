class MobileTag < ActiveRecord::Base
  def
    self.table_name() "tags"
  end

  def to_json
    self.attributes.to_json
  end

  # returns chapters of given user id and if modified date is given, returns chapters created after that date
  # input:user_id,updated_date
  # output:json,returns the chapter list of the given user id
  # created by :parthi

  def self.return_new_chapters(params)
    @conditions= ["uid= :user_id AND status='active' AND created_at > :updated_date AND default_tag='yes' and v_tagname not like 'STUDIO SESSIONS' and tag_type not like 'event'",{:updated_date => params[:updated_date],:user_id => params[:user_id]}]
    @output = Array.new
    mobile_chapter = self.find(:first,:conditions => "uid = #{params[:user_id]} and tag_type = 'mobile_uploads' and status='active'")
    if mobile_chapter
      params[:type] = 'events'
      params['chapter_id'] = mobile_chapter.id
      @mobile_events  = MobileSubChapter.return_new_subchapters(params)
    end

    @chapters = self.find(:all,
      :conditions=>@conditions,
      :select=>"v_desc as chapter_description,id as chapter_id,v_tagname as chapter_name,CONCAT(img_url,'/user_content/photos/icon_thumbnails/',v_chapimage) as chapter_image,DATE_FORMAT(d_createddate,'%c/%e/%Y %T') as created_date,tag_type as type,auto_share")

    if(@mobile_events!=nil && @chapters!=nil)
      @output = @mobile_events + @chapters
    elsif @mobile_events!=nil
      @output = @mobile_events
    elsif @chapters!=nil
      @output = @chapters
    end

    if @output.length > 0
      return @output
    else
      return nil
    end
  end

  # returns chapters of given user id and if modified date is given, returns chapters modified after that date
  # input:user_id,updated_date
  # output:json,returns the chapter list of the given user id
  # created by :parthi

  def self.return_updated_chapters(params)
    @output = Array.new
    mobile_chapter = self.find(:first,:conditions => "uid = #{params[:user_id]} and tag_type = 'mobile_uploads' and status='active'")
    if mobile_chapter
      params[:type] = 'events'
      params['chapter_id'] = mobile_chapter.id
      @mobile_events  = MobileSubChapter.return_updated_subchapters(params)
    end

    @conditions= ["uid= :user_id AND status='active' AND updated_at > :updated_date AND created_at <= :updated_date AND default_tag='yes' and v_tagname not like 'STUDIO SESSIONS' and tag_type not like 'event'",{:updated_date => params[:updated_date],:user_id => params[:user_id]}]
    @chapters = self.find(:all,
      :conditions=>@conditions,
      :select=>"v_desc as chapter_description,id as chapter_id,v_tagname as chapter_name,CONCAT(img_url,'/user_content/photos/icon_thumbnails/',v_chapimage) as chapter_image,DATE_FORMAT(d_createddate,'%c/%e/%Y %T') as created_date,tag_type as type,auto_share")

    if(@mobile_events!=nil && @chapters!=nil)
      @output = @mobile_events + @chapters
    elsif @mobile_events!=nil
      @output = @mobile_events
    elsif @chapters!=nil
      @output = @chapters
    end

    if @output.length > 0
      return @output
    else
      return nil
    end
  end

  # returns chapters of given user id and if modified date is given, returns chapters deleted after that date
  # input:user_id,updated_date
  # output:json,returns the chapter list of the given user id
  # created by :parthi
  def self.return_deleted_chapters(params)

    @output = Array.new
    mobile_chapter = self.find(:first,:conditions => "uid = #{params[:user_id]} and tag_type = 'mobile_uploads' and status='active'")
    if mobile_chapter
      params[:type] = 'events'
      params['chapter_id'] = mobile_chapter.id
      @mobile_events  = MobileSubChapter.return_deleted_subchapters(params)
    end

    @conditions= ["uid= :user_id AND status!='active' AND updated_at > :updated_date",{:updated_date => params[:updated_date],:user_id => params[:user_id]}]
    @chapters = self.find(:all,
      :conditions=>@conditions,
      :select=>"id as chapter_id")
    if(@mobile_events!=nil && @chapters!=nil)
      @output = @mobile_events + @chapters
    elsif @mobile_events!=nil
      @output = @mobile_events
    elsif @chapters!=nil
      @output = @chapters
    end

    if @output.length > 0
      return @output
    else
      return nil
    end
  end

  def self.save_chapter(chapter_name,user_id,chapter_description,auto_share=0,facebook_share=0)
    if !chapter_name.blank? && !user_id.blank? && !chapter_description.blank?
      @content_url = ContentPath.find :first,:conditions=>"status='inactive'"
      @tag = self.new()
      @tag['v_tagname'] = chapter_name
      @tag['v_desc'] =chapter_description
      @tag['uid'] = user_id
      @tag['v_chapimage'] = "folder_img.png"
      @tag['e_access'] = "public"
      @tag['e_visible'] = "yes"
      @tag['default_tag'] = "no" if chapter_name == 'HOLDING FOLDER'
      @tag['img_url'] = @content_url['content_path']
      @tag['auto_share'] = auto_share
      @tag['facebook_share'] = facebook_share
      @tag['client'] = 'iphone'
      @tag.d_updateddate = Time.now
      @tag.d_createddate = Time.now
      if @tag.save
        MobileSubChapter.save_subchapter('Sub Chapter', 'Enter description here', user_id, @tag.id)
        return @tag
      else
        return false
      end
    else
      return false
    end
  end

  def self.save_quick_album(album_name,album_description,user_id,type,auto_share = 0, facebook_share = 0)
    if !album_name.blank? && !user_id.blank? && !type.blank?
      @content_url = ContentPath.find :first,:conditions=>"status='inactive'"
      @tag = self.new()
      @tag['v_tagname'] = album_name
      @tag['v_desc'] = album_description
      @tag['tag_type'] = type
      @tag['uid'] = user_id
      @tag['img_url'] = @content_url['content_path']
      if(type == 'video')
        @tag['v_chapimage'] = "videogallery.png"
      else if(type == 'photo')
          @tag['v_chapimage'] = "photo_album.png"
        else
          @tag['v_chapimage'] = "speaker.jpg";
        end
      end
      @tag['e_access'] = "public"
      @tag['e_visible'] = "yes"
      @tag['auto_share'] = auto_share
      @tag['client'] = 'iphone'
      @tag['facebook_share'] = facebook_share
      @tag.d_updateddate = Time.now
      @tag.d_createddate = Time.now
      if @tag.save
        if(type == 'photo')
          type='image'
        end
        MobileSubChapter.save_subchapter('Sub Chapter', 'Enter description here', user_id, @tag.id,type)
        return @tag
      else
        return false
      end
    else
      return false
    end
  end

  def self.save_studio_sessions_chapter(user_id)
    @get_content_url=ContentPath.find(:all, :conditions => "status='inactive'")
    content_path=@get_content_url[0]['content_path']
    @tag_studio = self.new()
    @tag_studio['v_tagname']="STUDIO SESSIONS"
    @tag_studio['uid']=user_id
    @tag_studio['default_tag']="yes"
    @tag_studio.e_access = 'public'
    @tag_studio.e_visible = 'yes'
    @tag_studio['d_updateddate']=Time.now()
    @tag_studio['d_createddate' ]=Time.now()
    @tag_studio['img_url']=content_path
    @tag_studio['v_chapimage'] = "folder_img.png"
    if @tag_studio.save()
      MobileSubChapter.save_studio_sessions_subchapter('Portraits', user_id, @tag_studio.id,content_path,'image')
      MobileSubChapter.save_studio_sessions_subchapter('Videos', user_id, @tag_studio.id,content_path,'video')
    end
  end

  # synchronize chapters service for the mobile application
  # input:user_id,updated_date
  # output:json,returns the details of new,updated and deleted records
  # created by :parthi
  def self.synchronize_chapters(params)
    if !params[:user_id].blank?
      @chapters1 = Hash.new()
      @new = self.return_new_chapters(params)
      if @new != nil
        @chapters1['new_records'] = @new
      end
      @updated = self.return_updated_chapters(params)
      if @updated != nil
        @chapters1['updated_records'] = @updated
      end
      @deleted = self.return_deleted_chapters(params)
      if @deleted != nil
        @chapters1['deleted_records'] = @deleted
      end
      @chapters1['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      return @chapters1
    else
      return false
    end
  end

  def self.save_mobile_uploads_chapter(user_id)
    if !user_id.blank?
      @get_content_url=ContentPath.find(:all, :conditions => "status='inactive'")
      content_path=@get_content_url[0]['content_path']
      mobile_uploads = self.new()
      mobile_uploads['v_tagname']="Mobile Uploads"
      mobile_uploads['uid']=user_id
      mobile_uploads['default_tag']="yes"
      mobile_uploads['e_access'] = 'public'
      mobile_uploads['e_visible'] = 'yes'
      mobile_uploads['tag_type'] = 'mobile_uploads'
      mobile_uploads['d_updateddate']=Time.now()
      mobile_uploads['d_createddate' ]=Time.now()
      mobile_uploads['img_url']=content_path
      mobile_uploads['client']= 'iphone'
      mobile_uploads['v_chapimage'] = "mobile_uploads.png"
      mobile_uploads.save()
    end
    return mobile_uploads
  end
end