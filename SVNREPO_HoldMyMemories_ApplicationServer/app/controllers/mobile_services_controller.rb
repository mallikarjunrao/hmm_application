class MobileServicesController < ApplicationController
  require 'json/pure'
  # require 'mobile_tags_controller.rb'
  layout false
  before_filter :response_header
  
  def response_header
    response.headers['Pragma' ] = 'no-cache'
    response.headers['Cache-Control' ] = 'no-store, no-cache, max-age=0, must-revalidate'
    response.headers['Content-Type' ] = 'text/x-json'
  end

  def synchronize
    @retval = Hash.new()
    if !params[:type].blank? && !params[:updated_date].blank?
      @retval['type'] = params[:type]
      contents = ''
      @retval['body'] = contents
      @retval['status'] = true
      case params[:type]
      when "chapters"
        unless params[:user_id].blank?         
          contents = MobileTag.synchronize_chapters(params)
        else
          @retval['message'] = 'Incomplete details provided!'
          @retval['status'] = false
        end        
      when "subchapters"
        unless params[:chapter_id].blank?
          @temp = MobileSubChaptersController.new()
          contents = @temp.synchronize_subchapters(params)
        else
          @retval['message'] = 'Incomplete details provided!'
          @retval['status'] = false
        end
      when "galleries"
        unless params[:subchapter_id].blank?
          @temp = MobileGalleriesController.new()
          contents = MobileGallery.synchronize_galleries(params)
        else
          @retval['message'] = 'Incomplete details provided!'
          @retval['status'] = false
        end
        #      when "events"
        #        unless params[:user_id].blank?
        #          chapter = MobileTag.find(:first, :conditions => "tag_type='mobile_uploads' and uid = #{params[:user_id]}", :select => "id")
        #          params[:chapter_id] = chapter.id
        #          @temp = MobileSubChaptersController.new()
        #          contents = @temp.synchronize_subchapters(params)
        #        else
        #          @retval['message'] = 'Incomplete details provided!'
        #          @retval['status'] = false
        #        end
      
      when "gallerycontents"
        unless params[:gallery_id].blank?
          @temp = MobileUserContentsController.new()
          contents = @temp.synchronize_contents(params)
        else
          @retval['message'] = 'Incomplete details provided!'
          @retval['status'] = false
        end
      
      when "eventcontents"
        unless params[:event_id].blank?
          params[:subchapter_id] = params[:event_id]
          parent_id = params[:event_id]
          @temp = MobileUserContentsController.new()
          contents = @temp.synchronize_event_contents(params)
        else
          @retval['message'] = 'Incomplete details provided!'
          @retval['status'] = false
        end      
      when "albumcontents"
        unless params[:album_id].blank?
          parent_id = params[:album_id]
          @detail = MobileSubChapter.find(:first,:joins => "JOIN galleries ON sub_chapters.id = galleries.subchapter_id",
            :conditions => "sub_chapters.tagid =#{params[:album_id]}",:select =>"galleries.id")
          params[:gallery_id] = @detail.id
          @temp = MobileUserContentsController.new()
          contents = @temp.synchronize_contents(params)
        else
          @retval['message'] = 'Incomplete details provided!'
          @retval['status'] = false
        end
      when "Blog"
        unless params[:user_id].blank?
          @temp = MobileBlogsController.new()
          contents = @temp.synchronize_blogs(params)
        else
          @retval['message'] = 'Incomplete details provided!'
          @retval['status'] = false
        end
      end
      @retval['body'] = contents
      @retval['body']['parent_type'] = params[:parent_type] if params[:parent_type]!=nil
      @retval['parent_id'] = parent_id if parent_id
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    render :text => @retval.to_json
  end


  def synchronize_old
    @retval = Hash.new()
    if !params[:type].blank? && !params[:updated_date].blank?
      if params[:type]=='chapters' && !params[:user_id].blank?
        @temp = MobileTagsController.new()
        chapters = @temp.synchronize_chapters(params)
        if chapters!=nil
          @retval['body'] = chapters
        end
        @retval['type'] = params[:type]
        @retval['status'] = true
      elsif params[:type]=='subchapters' && !params[:chapter_id].blank?
        @temp = MobileSubChaptersController.new()
        subchapters = @temp.synchronize_subchapters(params)
        if subchapters!=nil
          @retval['body'] = subchapters
        end
        @retval['type'] = params[:type]
        @retval['status'] = true
      elsif params[:type]=='galleries' && !params[:subchapter_id].blank?
        @temp = MobileGalleriesController.new()
        galleries = @temp.synchronize_galleries(params)
        if galleries!=nil
          @retval['body'] = galleries
        end
        @retval['type'] = params[:type]
        @retval['status'] = true
      elsif params[:type]=='contents'
        @temp = MobileUserContentsController.new()
        if params[:parent_type]=='album' #for album synchronize
          @detail = MobileSubChapter.find(:first,:joins => "JOIN galleries ON sub_chapters.id = galleries.subchapter_id",
            :conditions => "sub_chapters.tagid =#{params[:album_id]}",:select =>"galleries.id")
          params[:gallery_id] = @detail.id
          contents = @temp.synchronize_contents(params)
        elsif params[:parent_type]=='event' #for event synchronize
          params[:subchapter_id] = params[:event_id]
          contents = @temp.synchronize_journal_event_contents(params)
        elsif params[:parent_type]=='journal' #for journal synchronize
          params[:subchapter_id] = params[:journal_id]
          contents = @temp.synchronize_journal_event_contents(params)
        else #for gallery synchronize
          contents = @temp.synchronize_contents(params)
        end
        @retval['body'] = contents
        if params[:parent_type]!=nil
          @retval['body']['parent_type'] = params[:parent_type]
        else
          @retval['body']['parent_type'] = 'gallery'
        end
        @retval['type'] = params[:type]
        @retval['status'] = true
      elsif params[:type]=='events' && !params[:user_id].blank?
        chapter = MobileTag.find(:first, :conditions => "tag_type='event' and uid = #{params[:user_id]}", :select => "id")
        params[:chapter_id] = chapter.id
        @temp = MobileSubChaptersController.new()
        subchapters = @temp.synchronize_subchapters(params)
        if subchapters!=nil
          @retval['body'] = subchapters
        end
        @retval['type'] = params[:type]
        @retval['status'] = true
      elsif params[:type]=='journals' && !params[:user_id].blank?
        chapter = MobileTag.find(:first, :conditions => "tag_type='journal' and uid = #{params[:user_id]}", :select => "id")
        params[:chapter_id] = chapter.id
        @temp = MobileSubChaptersController.new()
        subchapters = @temp.synchronize_subchapters(params)
        if subchapters!=nil
          @retval['body'] = subchapters
        end
        @retval['type'] = params[:type]
        @retval['status'] = true
      elsif params[:type]=='eventcontents' && !params[:event_id].blank?
        params[:subchapter_id] = params[:event_id]
        contents = @temp.synchronize_journal_event_contents(params)
        @retval['body'] = contents
        @retval['type'] = params[:type]
        @retval['status'] = true
      elsif params[:type]=='journalcontents' && !params[:journal_id].blank?
        params[:subchapter_id] = params[:event_id]
        contents = @temp.synchronize_journal_event_contents(params)
        @retval['body'] = contents
        @retval['type'] = params[:type]
        @retval['status'] = true
      elsif params[:type]=='albumcontents' && !params[:album_id].blank?
        @detail = MobileSubChapter.find(:first,:joins => "JOIN galleries ON sub_chapters.id = galleries.subchapter_id",
          :conditions => "sub_chapters.tagid =#{params[:album_id]}",:select =>"galleries.id")
        params[:gallery_id] = @detail.id
        contents = @temp.synchronize_contents(params)
        @retval['body'] = contents
        @retval['type'] = params[:type]
        @retval['status'] = true
      else
        @retval['message'] = 'Incomplete details provided!'
        @retval['status'] = false
      end
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    render :text => @retval.to_json
  end

  def get_website_blog_entries
    @retval = Hash.new()
    unless params[:user_id].blank? && params[:type].blank?
      case params[:type]
      when 'chapter'
        conditions = "tags.uid=#{params[:user_id]} and tags.status='active'"
        joins = "INNER JOIN chapter_journals on tags.id = chapter_journals.tag_id"
        select = "tags.id as chapter_id,chapter_journals.id as blog_id,chapter_journals.v_tag_title as blog_title,chapter_journals.v_tag_journal as blog_description,DATE_FORMAT(d_created_at,'%c/%e/%Y %T') as created_date,CONCAT(img_url,'/user_content/photos/icon_thumbnails/',v_chapimage) as blog_source"
        result = MobileTag.find(:all, :conditions => conditions, :select => select, :joins => joins)
        @retval[:body] = result
      when 'subchapter'
        conditions = "sub_chapters.uid=#{params[:user_id]} and sub_chapters.status='active'"
        joins = "INNER JOIN sub_chap_journals on sub_chapters.id = sub_chap_journals.sub_chap_id"
        select = "sub_chapters.id as subchapter_id,sub_chap_journals.id as blog_id,sub_chap_journals.journal_title as journal_title,sub_chap_journals.subchap_journal as blog_description,DATE_FORMAT(created_on,'%c/%e/%Y %T') as created_date,CONCAT(img_url,'/user_content/photos/icon_thumbnails/',v_image) as blog_source"
        result = MobileSubChapter.find(:all, :conditions => conditions, :select => select, :joins => joins)
        @retval[:body] = result
      when 'gallery'        
        data = MobileSubChapter.find(:all,:conditions => "sub_chapters.uid=#{params[:user_id]} and sub_chapters.status='active'", :select => 'id')
        subchap = Array.new
        for temp in data
          subchap.push(temp.id)
        end
        subchapters = subchap.join(',')
        conditions = "galleries.subchapter_id in (#{subchapters}) and galleries.status='active'"
        joins = "INNER JOIN gallery_journals on galleries.id = gallery_journals.galerry_id"
        select = "galleries.id as gallery_id,gallery_journals.id as blog_id,gallery_journals.v_title as blog_title,gallery_journals.v_journal as blog_description,DATE_FORMAT(d_created_on,'%c/%e/%Y %T') as created_date,CONCAT(img_url,'/user_content/photos/icon_thumbnails/',v_gallery_image) as blog_source"
        result = MobileGallery.find(:all, :conditions => conditions, :select => select, :joins => joins)
        @retval[:body] = result
      end
      
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    render :text => @retval.to_json
  end


  #updates the auto share details of the given album or gallery
  #input : gallery/album id, subchapter/user id,updated date of subchapter/chapter
  #output : synchronize output of gallery/chapters
  def update_auto_share
    @retval = Hash.new()
    unless params[:autoshare_events].blank? && params[:updated_date].blank?
      events = JSON.parse(params[:autoshare_events])
      for event in events
        event_id = event['event_id']
        if event['emails']
          emails = event['emails']
          for email in emails
            auto_share = AutoShare.new
            auto_share.share_type = 'subchapter'
            auto_share.share_type_id = event_id
            auto_share.email = email
            auto_share.save
          end
        end
        MobileSubChapter.update(event_id, :auto_share => true, :facebook_share => event['facebook_share'])
      end
      subchapter = MobileSubChapter.find(:first, :conditions => "id=#{event_id}")
      params[:chapter_id] = subchapter.tagid
      
      params[:type]='events'
      contents = MobileSubChapter.synchronize_subchapters(params)
      @retval['body'] = contents
      @retval['status'] = true
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    render :text => @retval.to_json
  end

  def upgrade_notification
    hmm_user=HmmUser.count(:all, :conditions => "id='#{params[:id]}' and account_expdate < current_date()")
    if(hmm_user > 0)
      @retval['message'] = 'Please upgrade your account!'
      @retval['status'] = false
    end
    render :text => @retval.to_json
  end

 
end