class MobileBlogsController < ApplicationController
  require 'json/pure'
  layout false
  before_filter :response_header

  def response_header
    response.headers['Pragma' ] = 'no-cache'
    response.headers['Cache-Control' ] = 'no-store, no-cache, max-age=0, must-revalidate'
    response.headers['Content-Type' ] = 'text/x-json'
  end
  
  def get_blog_entries
    @retval = Hash.new()
    unless params[:user_id].blank?      
      @conditions= ["user_id = :user_id AND blogs.status='active'",{:user_id => params[:user_id]}]
      @entries = MobileBlog.find(:all,:conditions => @conditions,
        :joins =>"LEFT JOIN tags on (blogs.blog_type='chapter' and blogs.blog_type_id = tags.id)
        LEFT JOIN sub_chapters on (blogs.blog_type='subchapter' and blogs.blog_type_id = sub_chapters.id)
        LEFT JOIN galleries on (blogs.blog_type='gallery' and blogs.blog_type_id = galleries.id)
        LEFT JOIN user_contents on (blogs.blog_type in ('image','audio','video') and blogs.blog_type_id = user_contents.id) and blogs.client='website'
        LEFT JOIN mobile_blog_contents on blogs.client='iphone' and blogs.blog_type in ('image','audio','video') and blogs.blog_type_id=mobile_blog_contents.id",
        :select => "blogs.id as blog_id,blog_type,blogs.client as client,title,description,blog_type_id,DATE_FORMAT(blogs.created_at,'%c/%e/%Y %T') as created_date,
        CONCAT(tags.img_url,'/user_content/photos/icon_thumbnails/',tags.v_chapimage) as chapter_image,
        CONCAT(sub_chapters.img_url,'/user_content/photos/icon_thumbnails/',sub_chapters.v_image) as subchapter_image,
        CONCAT(galleries.img_url,'/user_content/photos/icon_thumbnails/',galleries.v_gallery_image) as gallery_image,
        CONCAT(user_contents.img_url,'/user_content/photos/small_thumb/',v_filename) as content_image_url,
        CONCAT(user_contents.img_url,'/user_content/videos/iphone/thumbnails/',v_filename,'.jpg') as content_video_url,
        CONCAT(user_contents.img_url,'/user_content/audios/speaker.jpg') as content_audio_url,
CONCAT(user_contents.img_url,'/user_content/audios/',v_filename) as content_audio_source_url,
        tags.tag_type as chapter_type,galleries.e_gallery_type as gallery_type,mobile_blog_contents.server_url as mobile_server_url,
        mobile_blog_contents.file_name as mobile_file_name")
      result = MobileBlog.format_results(@entries)        
      @retval['count'] = result.length
      @retval['body'] = result
      @retval['status'] = true
    else
      @retval['status'] = false
      @retval['message'] = "Incomplete data provided!"
    end

    @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    render :text => @retval.to_json
  end

  def create_blog_entry
    @retval = Hash.new()
    if !params[:user_id].blank? && !params[:blog_title].blank?  && !params[:blog_type].blank?
      @get_content_url=ContentPath.find(:first, :conditions => "status='active'")
      content_path = @get_content_url['content_path']

      unless params[:Filedata].blank?
        case params[:blog_type]
        when 'image'
          filename = MobileBlogContent.save_image(params)
        when 'video'
          filename = MobileBlogContent.save_video(params)
        when 'audio'
          filename = MobileBlogContent.save_audio(params)
        end 
        blog_content = MobileBlogContent.new
        blog_content.file_name = filename if filename        
        blog_content.file_type = params[:blog_type]
        blog_content.server_url = content_path
        blog_content.save()
      end


      blog = MobileBlog.new()
      blog.title = params[:blog_title]
      blog.description = params[:blog_description]
      blog.blog_type = params[:blog_type]
      blog.blog_type_id = blog_content.id if blog_content
      blog.user_id = params[:user_id]
      blog.added_date = Time.now
      blog.client = 'iphone'
      if blog.save()
        if !params[:emails].blank?
          url = request.subdomains[0]
          logger.info "subdomain : #{url}"
          if url == 'contentbackup'
            url = 'staging'
          else
            url = 'www'
          end
          @user = MobileHmmUser.find(:first,:conditions=>"id=#{params[:user_id]}")
          logger.info "url : #{url}"
          link = "http://#{url}.holdmymemories.com/blog/list/#{@user.family_name}"
          logger.info "link : #{link}"
          if params[:journal_type]=='image'
            image = "http://#{request.subdomains}.holdmymemories.com/user_content/mobile_blog_contents/images/thumbnails/#{filename}"
          elsif params[:journal_type]=='video'
            image = "http://#{request.subdomains}.holdmymemories.com/user_content/mobile_blog_contents/videos/thumbnails/#{filename}.jpg"
          else
            image = "http://#{request.subdomains}.holdmymemories.com/hmmuser/familyphotos/thumbs/#{@user.v_myimage}"
          end

          emails = JSON.parse(params[:emails])
          for email in emails
            MobilePostOffice.deliver_share_blog_entry(@user.v_user_name,@user.v_e_mail,email,link,image,request.subdomains[0])
          end
        end
        blogs = self.synchronize_blogs(params)
        if blogs
          @retval['body'] = blogs
          @retval['status'] = true
          @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
        else
          @retval['message'] = 'Error while sync journals'
          @retval['status'] = false
        end
      else
        @retval['status'] = false
        @retval['message'] = "Blog creation failed!"
      end
    else
      @retval['status'] = false
      @retval['message'] = "Incomplete data provided!"
    end
    render :text => @retval.to_json
  end

  def update_blog_entry
    @retval = Hash.new()
    if !params[:blog_id].blank? && !params[:blog_title].blank? && !params[:blog_description].blank? && !params[:blog_type].blank?     
      blog = MobileBlog.find(params[:blog_id])
      if blog != nil
        unless params[:Filedata].blank?
          blog_content = nil
          blog_content = MobileBlogContent.find(blog.blog_type_id) if blog.blog_type_id!=0
          if blog_content == nil
            blog_content = MobileBlogContent.new
            blog_content_id = nil
          else
            blog_content_id = blog_content.id           
            rand = rand(99999)
            temp_id = "#{blog_content_id}_#{rand}"
          end
          case params[:blog_type]
          when 'image'
            file_name = MobileBlogContent.save_image(params,temp_id)
          when 'video'
            file_name = MobileBlogContent.save_video(params,temp_id)
          when 'audio'
            file_name = MobileBlogContent.save_audio(params,temp_id)
          end         
          blog_content.file_name = file_name if file_name
          blog_content.file_type = params[:blog_type]
          blog_content.save()
        end

        blog.title = params[:blog_title]
        blog.description = params[:blog_description]
        blog.blog_type = params[:blog_type]
        blog.blog_type_id = blog_content.id if blog_content
        blog.client = 'iphone'
        blog.updated_at = Time.now()
        if blog.save()          
          blogs = self.synchronize_blogs(params)
          if blogs
            @retval['body'] = blogs
            @retval['status'] = true
            @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
          else
            @retval['message'] = 'Error while sync blogs'
            @retval['status'] = false
          end
        else
          @retval['status'] = false
          @retval['message'] = "Blog update failed!"
        end
      else
        @retval['status'] = false
        @retval['message'] = "Blog entry not found!"
      end
      
    else
      @retval['status'] = false
      @retval['message'] = "Incomplete data provided!"
    end
    render :text => @retval.to_json
  end

  def synchronize_blogs(params)
    unless params[:user_id].blank?
      @galleries = Hash.new()
      @new = MobileBlog.return_new_blogs(params)
      if @new != nil
        @galleries['new_records'] = @new
      end
      @updated = MobileBlog.return_updated_blogs(params)
      if @updated != nil
        @galleries['updated_records'] = @updated
      end
      @deleted = MobileBlog.return_deleted_blogs(params)
      if @deleted != nil
        @galleries['deleted_records'] = @deleted
      end
      @galleries['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      return @galleries
    else
      return false
    end
  end

  def delete_blog_entry
    @retval = Hash.new()
    unless params[:selected_id].blank? && !params[:user_id].blank? && !params[:updated_date].blank?  
        MobileBlog.update(params[:selected_id], :status => 'inactive')
      #ids = journal_ids.join(',')
      #MobileJournal.update_all("status='inactive'", "id in (#{ids})") if journal_ids.length > 0
      blogs = self.synchronize_blogs(params)
      if blogs
        @retval['body'] = blogs
        @retval['status'] = true
        @retval['type'] = params[:type] if params[:type]
        @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      else
        @retval['message'] = 'Error while sync journal!'
        @retval['status'] = false
      end
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    render :text => @retval.to_json
  end

 
end
