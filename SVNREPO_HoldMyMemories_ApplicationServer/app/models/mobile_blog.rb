class MobileBlog < ActiveRecord::Base
  def
    self.table_name() "blogs"
  end

  def to_json
    self.attributes.to_json
  end

  def self.format_results(entries)
    result = Array.new
    for @entry in entries
      newentry = Hash.new
      newentry[:blog_id] = @entry.blog_id
      newentry[:title] = @entry.title
      newentry[:description] = @entry.description
      newentry[:type] = @entry.blog_type
      newentry[:created_date] = @entry.created_date
      newentry[:client] = @entry.client
      case @entry.blog_type
      when "chapter"
        newentry[:chapter_id] = @entry.blog_type_id
        newentry[:thumbnail] = @entry.chapter_image
        if @entry.chapter_type=='photo' || @entry.chapter_type == 'audio' || @entry.chapter_type == 'video'
          newentry[:type] = 'album'
          @entry.chapter_type=='image' if @entry.chapter_type == 'photo'
          newentry[:album_type] = @entry.chapter_type
        end
      when "subchapter"
        newentry[:subchapter_id] = @entry.blog_type_id
        newentry[:thumbnail] = @entry.subchapter_image
      when "gallery"
        newentry[:gallery_id] = @entry.blog_type_id
        newentry[:thumbnail] = @entry.gallery_image
        newentry[:gallery_type] = @entry.gallery_type
      when "image"
        if @entry.client == 'website'
          newentry[:content_id] = @entry.blog_type_id
          newentry[:thumbnail] = @entry.content_image_url
          temp = @entry.content_image_url
          newentry[:source] = temp.gsub('small_thumb','journal_thumb')
        else
          newentry[:thumbnail] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/images/thumbnails/' + @entry.mobile_file_name
          newentry[:source] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/images/big_thumbnails/' + @entry.mobile_file_name
        end

      when "video"
        if @entry.client == 'website'
          newentry[:content_id] = @entry.blog_type_id
          newentry[:thumbnail] = @entry.content_video_url
          temp = @entry.content_video_url.gsub("thumbnails/",'')
          temp1 = temp.gsub(".jpg",".mp4")
          newentry[:source] = temp.gsub('small_thumb','journal_thumb')
        else
          filename = @entry.mobile_file_name
          filename.slice!(-3..-1)
          newentry[:thumbnail] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/videos/thumbnails/' + filename+'jpg'
          newentry[:source] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/videos/iphone/' + @entry.mobile_file_name+'mp4'
        end

      when "audio"
        if @entry.client == 'website'
          newentry[:content_id] = @entry.blog_type_id
          newentry[:thumbnail] = @entry.content_audio_url          
          newentry[:source] = @entry.content_audio_source_url
        else
          filename = @entry.mobile_file_name
          newentry[:thumbnail] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/audios/speaker.jpg'
          newentry[:source] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/audios/' + @entry.mobile_file_name
        end
      end
      result.push(newentry)
    end
    return result
  end
  
  def self.return_new_blogs(params)
    @conditions= ["blogs.user_id = :user_id AND blogs.status='active' AND blogs.created_at > :updated_date",{:updated_date => params[:updated_date],:user_id => params[:user_id]}]
    @entries = self.find(:all,:conditions => @conditions,
      :joins =>"LEFT JOIN tags on (blogs.blog_type='chapter' and blogs.blog_type_id = tags.id)
        LEFT JOIN sub_chapters on (blogs.blog_type='subchapter' and blogs.blog_type_id = sub_chapters.id)
        LEFT JOIN galleries on (blogs.blog_type='gallery' and blogs.blog_type_id = galleries.id)
        LEFT JOIN user_contents on (blogs.blog_type in ('image','audio','video') and blogs.blog_type_id = user_contents.id) and blogs.client='website'
        LEFT JOIN mobile_blog_contents on blogs.client='iphone' and blogs.blog_type in ('image','audio','video') and blogs.blog_type_id=mobile_blog_contents.id",
      :select => "blogs.id as blog_id,blog_type,blogs.client,title,description,blog_type_id,DATE_FORMAT(blogs.created_at,'%c/%e/%Y %T') as created_date,
        CONCAT(tags.img_url,'/user_content/photos/icon_thumbnails/',tags.v_chapimage) as chapter_image,
        CONCAT(sub_chapters.img_url,'/user_content/photos/icon_thumbnails/',sub_chapters.v_image) as subchapter_image,
        CONCAT(galleries.img_url,'/user_content/photos/icon_thumbnails/',galleries.v_gallery_image) as gallery_image,
        CONCAT(user_contents.img_url,'/user_content/photos/small_thumb/',v_filename) as content_image_url,
        CONCAT(user_contents.img_url,'/user_content/videos/iphone/thumbnails/',v_filename,'.jpg') as content_video_url,
        CONCAT(user_contents.img_url,'/user_content/audios/speaker.jpg') as content_audio_url,
CONCAT(user_contents.img_url,'/user_content/audios/',v_filename) as content_audio_source_url,
        tags.tag_type as chapter_type,galleries.e_gallery_type as gallery_type,mobile_blog_contents.server_url as mobile_server_url,
        mobile_blog_contents.file_name as mobile_file_name")
    if @entries.length > 0
      result = self.format_results(@entries)
      return result
    else
      return nil
    end
  end

  def self.return_updated_blogs(params)
    @conditions= ["blogs.user_id= :user_id AND blogs.status='active' AND blogs.updated_at > :updated_date AND blogs.created_at <= :updated_date ",{:updated_date => params[:updated_date],:user_id => params[:user_id]}]
    @entries = self.find(:all,:conditions => @conditions,
      :joins =>"LEFT JOIN tags on (blogs.blog_type='chapter' and blogs.blog_type_id = tags.id)
        LEFT JOIN sub_chapters on (blogs.blog_type='subchapter' and blogs.blog_type_id = sub_chapters.id)
        LEFT JOIN galleries on (blogs.blog_type='gallery' and blogs.blog_type_id = galleries.id)
        LEFT JOIN user_contents on (blogs.blog_type in ('image','audio','video') and blogs.blog_type_id = user_contents.id) and blogs.client='website'
        LEFT JOIN mobile_blog_contents on blogs.client='iphone' and blogs.blog_type in ('image','audio','video') and blogs.blog_type_id=mobile_blog_contents.id",
      :select => "blogs.id as blog_id,blog_type,blogs.client,title,description,blog_type_id,DATE_FORMAT(blogs.created_at,'%c/%e/%Y %T') as created_date,
        CONCAT(tags.img_url,'/user_content/photos/icon_thumbnails/',tags.v_chapimage) as chapter_image,
        CONCAT(sub_chapters.img_url,'/user_content/photos/icon_thumbnails/',sub_chapters.v_image) as subchapter_image,
        CONCAT(galleries.img_url,'/user_content/photos/icon_thumbnails/',galleries.v_gallery_image) as gallery_image,
        CONCAT(user_contents.img_url,'/user_content/photos/small_thumb/',v_filename) as content_image_url,
        CONCAT(user_contents.img_url,'/user_content/videos/iphone/thumbnails/',v_filename,'.jpg') as content_video_url,
        CONCAT(user_contents.img_url,'/user_content/audios/speaker.jpg') as content_audio_url,
CONCAT(user_contents.img_url,'/user_content/audios/',v_filename) as content_audio_source_url,
        tags.tag_type as chapter_type,galleries.e_gallery_type as gallery_type,mobile_blog_contents.server_url as mobile_server_url,
        mobile_blog_contents.file_name as mobile_file_name")
    if @entries.length > 0
      result = self.format_results(@entries)
      return result
    else
      return nil
    end
  end

  # returns chapters of given user id and if modified date is given, returns chapters deleted after that date
  # input:user_id,updated_date
  # output:json,returns the chapter list of the given user id
  # created by :parthi
  def self.return_deleted_blogs(params)
    @conditions= ["user_id= :user_id AND status!='active' AND updated_at > :updated_date",{:updated_date => params[:updated_date],:user_id => params[:user_id]}]
    @entries = self.find(:all, :conditions=>@conditions, :select=>"id as blog_id")
    if @entries.length > 0
      return @entries
    else
      return nil
    end
  end
end