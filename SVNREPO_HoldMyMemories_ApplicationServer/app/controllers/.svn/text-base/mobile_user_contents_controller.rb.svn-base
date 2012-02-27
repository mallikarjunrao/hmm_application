class MobileUserContentsController < ApplicationController
  require 'json/pure'
  layout false
  require 'will_paginate'
  before_filter :respose_header,:except => [:synchronize_contents]

  def respose_header
    response.headers['Pragma' ] = 'no-cache'
    response.headers['Cache-Control' ] = 'no-store, no-cache, max-age=0, must-revalidate'
    response.headers['Content-Type' ] = 'text/x-json'
  end
  #caches_action :memory_lane_studio_blog_data,:memory_lane_mobile_blog_data,:memory_lane_studio_grid_data,:memory_lane_mobile_grid_data,:search_tags,:memory_lane_gallery_images
  # User Content service for the mobile application
  # input:gallery_id
  # output:json,returns the chapter list of the given gallery id
  # created by :parthi
  def get_contents
    @retval = Hash.new()
    if !params[:gallery_id].blank?
      extension = ''
      @type = MobileGallery.find(:first,
        :conditions=>{:id=>params[:gallery_id],:status=>'active'},
        :select=>"e_gallery_type as content_type")
      content_type =@type['content_type']
      if content_type=='image'
        content_dir = '/user_content/photos/small_thumb/'
      elsif content_type=='video'
        content_dir = '/user_content/videos/iphone/thumbnails/'
        extension = '.jpg'
      elsif content_type=='audio'
        content_dir = '/user_content/audios/'
      end
      @contents = MobileUserContent.find(:all,
        :conditions=>{:gallery_id=>params[:gallery_id],:status=>'active'},
        :select=>"v_desc as content_description,id as content_id,v_tagphoto as content_name,CONCAT(img_url,'#{content_dir}',v_filename,'#{extension}') as content_url,e_filetype as content_type,DATE_FORMAT(d_createddate,'%c/%e/%Y %T') as created_date,latitude,longitude,CONCAT(img_url,'/user_content/audio_tags/',audio_tag) as audio_tag_url")
      @retval['body'] = @contents
      @retval['status'] = true
      @retval['count'] = @contents.length
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    render :text => @retval.to_json
  end

  # User Content service of quick albums for the mobile application
  # input:chapter_id
  # output:json,returns the chapter list of the given gallery id
  # created by :parthi
  def get_album_contents
    @retval = Hash.new()
    if !params[:chapter_id].blank?
      @type = MobileTag.find(:first,
        :conditions=>{:id=>params[:chapter_id],:status=>'active'},
        :select=>"tag_type")
      content_type =@type['tag_type']
      extension = ''
      if content_type=='photo'
        content_dir = '/user_content/photos/small_thumb/'
      elsif content_type=='video'
        content_dir = '/user_content/videos/iphone/thumbnails/'
        extension = '.jpg'
      elsif content_type=='audio'
        content_dir = '/user_content/audios/'
      end
      @contents = MobileUserContent.find(:all,
        :conditions=>{:tagid=>params[:chapter_id],:status=>'active'},
        :select=>"v_desc as content_description,id as content_id,v_tagphoto as content_name,CONCAT(img_url,'#{content_dir}',v_filename,'#{extension}') as content_url,e_filetype as content_type,DATE_FORMAT(d_createddate,'%c/%e/%Y %T') as created_date,latitude,longitude,CONCAT(img_url,'/user_content/audio_tags/',audio_tag) as audio_tag_url")
      @retval['body'] = @contents
      @retval['status'] = true
      @retval['count'] = @contents.length
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    render :text => @retval.to_json
  end

  def synchronize_contents(params)
    if !params[:gallery_id].blank?
      extension=''
      content_dir=''
      @type = MobileGallery.find(:first,
        :conditions=>{:id=>params[:gallery_id],:status=>'active'},
        :select=>"e_gallery_type as content_type")
      content_type =@type['content_type']
      if content_type=='image'
        content_dir = '/user_content/photos/small_thumb/'
      elsif content_type=='video'
        content_dir = '/user_content/videos/iphone/thumbnails/'
        extension = '.jpg'
      elsif content_type=='audio'
        content_dir = '/user_content/audios/'
      end
      @contents = Hash.new()
      @contents['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      @new = MobileUserContent.return_new_contents(params,content_dir,extension)
      if @new != nil
        @contents['new_records'] = @new
      end
      @updated = MobileUserContent.return_updated_contents(params,content_dir,extension)
      if @updated != nil
        @contents['updated_records'] = @updated
      end
      @deleted = MobileUserContent.return_deleted_contents(params)
      if @deleted != nil
        @contents['deleted_records'] = @deleted
      end
      return @contents
    else
      return false
    end
  end

  # User Content service of events for the mobile application
  # input:event_id,offset(record to begin with during paging)
  # output:json,returns the chapter list of the given gallery id
  # created by :parthi
  def get_event_contents
    @retval = Hash.new()
    if !params[:event_id].blank?
      gallery = Array.new
      @galleries = MobileGallery.find(:all,:conditions=>{:subchapter_id=>params[:event_id],:status=>'active'},:select=>"id")
      for @gallery in @galleries
        gallery.push(@gallery['id'])
      end
      @gallery_ids = gallery.join(",")
      @contents = MobileUserContent.find(:all,:conditions=>"gallery_id in (#{@gallery_ids}) and status='active'",
        :select=>"id as content_id,v_desc as content_description,id as content_id,v_tagphoto as content_name,v_filename,e_filetype as content_type,img_url,DATE_FORMAT(d_createddate,'%c/%e/%Y %T') as created_date,latitude,longitude,CONCAT(img_url,'/user_content/audio_tags/',audio_tag) as audio_tag_url")
      logger.info(@contents)
      @contents.each_with_index do |content, i|
        if content['content_type']=='image'
          content_dir = '/user_content/photos/small_thumb/'
          @contents[i]['content_url']="#{content['img_url']}#{content_dir}#{content['v_filename']}"
        elsif content['content_type'] =='video'
          content_dir = '/user_content/videos/iphone/thumbnails/'
          @contents[i]['content_url']="#{content['img_url']}#{content_dir}#{content['v_filename']}.jpg"
        elsif content['content_type'] =='audio'
          content_dir = '/user_content/audios/'
          @contents[i]['content_url']="#{content['img_url']}#{content_dir}#{content['v_filename']}"
        end
      end
      @retval['body'] = @contents
      @retval['status'] = true
      @retval['count'] = @contents.length
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    logger.info "#{@retval.to_json}"
    render :text => @retval.to_json
  end

  def synchronize_event_contents(params)
    if !params[:subchapter_id].blank?
      extension=''
      content_dir=''
      @contents = Hash.new()
      @contents['new_records'] = Array.new()
      @contents['updated_records'] = Array.new()
      @contents['deleted_records'] = Array.new()
      @types = MobileGallery.find(:all,:conditions=>{:subchapter_id=>params[:subchapter_id],:status=>'active'},:select=>"e_gallery_type as content_type,id as gallery_id")
      for @type in @types
        extension=''
        content_type =@type['content_type']
        params[:gallery_id] = @type.gallery_id
        if content_type=='image'
          content_dir = '/user_content/photos/small_thumb/'
        elsif content_type=='video'
          content_dir = '/user_content/videos/iphone/thumbnails/'
          extension = '.jpg'
        elsif content_type=='audio'
          content_dir = '/user_content/audios/'
        end
        @contents['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
        @new = MobileUserContent.return_new_contents(params,content_dir,extension)
        if @new != nil
          @contents['new_records']=@contents['new_records'] + @new
        end
        @updated = MobileUserContent.return_updated_contents(params,content_dir,extension)
        if @updated != nil
          @contents['updated_records'] = @contents['updated_records'] + @updated
        end
        @deleted = MobileUserContent.return_deleted_contents(params)
        if @deleted != nil
          @contents['deleted_records'] = @contents['deleted_records'] + @deleted
        end
      end
      return @contents
    else
      return false
    end
  end


  #service to delete the sub chapter
  #input : gallery_id
  #output : sync content
  def delete_content
    @retval = Hash.new()
    unless params[:selected_ids].blank? && params[:parent_type].blank? && params[:parent_id].blank? && params[:type].blank?
      content_ids = JSON.parse(params[:selected_ids])
      for content_id in content_ids
        MobileUserContent.update(content_id, {:status=>'deleted', :deleted_date=>Time.now})
      end
      case params[:type]
      when "albumcontents"
        @detail = MobileSubChapter.find(:first,:joins => "JOIN galleries ON sub_chapters.id = galleries.subchapter_id",
          :conditions => "sub_chapters.tagid =#{params[:parent_id]}",:select =>"galleries.id")
        params[:gallery_id] = @detail.id
        contents = synchronize_contents(params)
      when "eventcontents"
        params[:subchapter_id] = params[:parent_id]
        contents = synchronize_journal_event_contents(params)
      when "journalcontents"
        params[:subchapter_id] = params[:parent_id]
        contents = synchronize_journal_event_contents(params)
      when "gallerycontents"
        params[:gallery_id] = params[:parent_id]
        contents = synchronize_contents(params)
      end

      if contents
        @retval['body'] = contents
        @retval['parent_id'] = params[:parent_id] if params[:parent_id]
        @retval['type'] = params[:type] if params[:type]
        @retval['status'] = true
        @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      else
        @retval['body'] = "Error while sync contents"
        @retval['status'] = false
      end
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    render :text => @retval.to_json
  end

  #service to update the user contents
  #input : content_id
  #output : returns sync chapters
  def update_content
    @retval = Hash.new()
    unless params[:content_id].blank? && params[:content_name].blank? && params[:content_description].blank?  && params[:type].blank? && params[:parent_id].blank?
      result = MobileUserContent.update(params[:content_id], :v_tagphoto => params[:content_name], :v_desc => params[:content_description])
      if result
        case params[:type]
        when "albums"
          @detail = MobileSubChapter.find(:first,:joins => "JOIN galleries ON sub_chapters.id = galleries.subchapter_id",
            :conditions => "sub_chapters.tagid =#{params[:parent_id]}",:select =>"galleries.id")
          params[:gallery_id] = @detail.id
          contents = synchronize_contents(params)
        when "events"
          params[:subchapter_id] = params[:parent_id]
          contents = synchronize_event_contents(params)
        when "galleries"
          params[:gallery_id] = params[:parent_id]
          contents = synchronize_contents(params)
        end

        if contents
          @retval['body'] = contents
          @retval['type'] = params[:type]
          @retval['status'] = true
        else
          @retval['message'] = 'Error while sync content!'
          @retval['status'] = false
        end
      else
        @retval['message'] = 'Error while updating content!'
        @retval['status'] = false
      end
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    render :text => @retval.to_json
  end

  def all_user_images
    @retval = Hash.new()
    if !params[:user_id].blank?
      total= MobileUserContent.count(:all,:conditions => "uid=#{params[:user_id]} and e_filetype='image' and status='active'")
      @contents = MobileUserContent.paginate(:per_page => params[:items], :page => params[:page],:conditions=>{:uid => "#{params[:user_id]}",:e_filetype=>'image', :status => 'active'},:select=>"img_url as image_url,v_filename as filename, '/user_content/photos/small_thumb/' as small_thumb, '/user_content/photos/iphone/big_thumb/' as big_thumb", :order =>"id desc")
      @retval['body'] = @contents
      @retval['total_count'] = total
      @retval['status'] = true
      @retval['count'] = @contents.length
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    render :text => @retval.to_json
  end

  def all_user_videos

    @retval = Hash.new()
    if !params[:user_id].blank?
      total= MobileUserContent.count(:all,:conditions => "uid=#{params[:user_id]} and e_filetype='video' and status='active'")
      @contents = MobileUserContent.paginate(:per_page => params[:items], :page => params[:page],:conditions=>{:uid => "#{params[:user_id]}",:e_filetype=>'video', :status => 'active'},:select=>"img_url as video_url, v_filename as filename, '/user_content/videos/iphone/thumbnails/' as image_path, '/user_content/videos/iphone/' as video_path ", :order => "id desc")
      @retval['body'] = @contents
      @retval['total_count'] = total
      @retval['status'] = true
      @retval['count'] = @contents.length
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    render :text => @retval.to_json
  end


  def memory_lane_mobile_blog_data
    @retval = Hash.new()
    allimages=Array.new
    if !params[:user_id].blank?
      tags=Tag.find(:first,:select=>"id",:conditions=>"uid=#{params[:user_id]} and status = 'active' and tag_type ='mobile_uploads'")
      total=MobileUserContent.count(:all,:select=>"distinct(id)",:conditions=>"status = 'active' and 	tagid=#{tags.id} and (e_filetype='video' or e_filetype='image')")
      contents = MobileUserContent.paginate(:select=>"id,sub_chapid,d_createddate,audio_tag,img_url,v_filename,e_filetype,uid,v_desc,v_tagname,audio_tag_url",:per_page => params[:items], :page => params[:page],:conditions=>"status = 'active' and 	tagid=#{tags.id} and (e_filetype='video' or e_filetype='image') ",:order =>"id desc")
      if total>0
        for content in contents
          if  !content.audio_tag.blank? || !content.audio_tag.nil?
            audio_tag= "#{content.audio_tag_url}/user_content/audio_tags/#{content.audio_tag}"
          else
            audio_tag= ""
          end
          if content.e_filetype=="image"
            val={:id=>content.id,:tags=>content.v_tagname,:sub_chapid=>content.sub_chapid,:user_id=>content.uid,:type=>content.e_filetype,:v_filename=>content.v_filename,:description=>content.v_desc,:d_createddate=>content.d_createddate.strftime("%a, %d %b %Y"),:small_thumb=>"#{content.img_url}/user_content/photos/small_thumb/#{content.v_filename}",:big_thumb=>"#{content.img_url}/user_content/photos/iphone/big_thumb/#{content.v_filename}",:audio_tag=>audio_tag,:data_type=>"mobile"}
            allimages.push(val)
          elsif content.e_filetype=="video"
            val={:id=>content.id,:tags=>content.v_tagname,:sub_chapid=>content.sub_chapid,:user_id=>content.uid,:type=>content.e_filetype,:v_filename=>content.v_filename,:description=>content.v_desc,:d_createddate=>content.d_createddate.strftime("%a, %d %b %Y"),:small_thumb=>"#{content.img_url}/user_content/videos/iphone/thumbnails/#{content.v_filename}.jpg",:big_thumb=>"#{content.img_url}/user_content/videos/thumbnails/#{content.v_filename}.jpg",:video_path=>"#{content.img_url}/user_content/videos/iphone/#{content.v_filename}.mp4",:audio_tag=>audio_tag,:data_type=>"mobile"}
            allimages.push(val)
          end
          @retval['body'] = allimages
          @retval['total_count'] = total
          @retval['page_number'] = params[:page]
          @retval['status'] = true
          @retval['count'] = contents.length

        end
      else
        @retval['body'] = allimages
        @retval['total_count'] = 0
        @retval['message'] = 'No Image Found!'
        @retval['status'] = false
      end
    else
      @retval['body'] = allimages
      @retval['total_count'] = 0
      @retval['message'] = 'Invalid Details'
      @retval['status'] = false
    end
    @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    render :text => @retval.to_json
  end


  def memory_lane_studio_blog_data
    allimages=Array.new
    if !params[:user_id].blank?
      @retval = Hash.new()
      sub_chaps=SubChapter.find(:first,:select=>"tagid",:conditions=>"uid=#{params[:user_id]} and status = 'active' and store_id!=''")
      if !sub_chaps.nil?
        total=MobileUserContent.count(:all,:select=>"distinct(id)",:conditions=>"tagid=#{sub_chaps.tagid} and 	status = 'active' and  (e_filetype='video' or e_filetype='image') ")
        contents = MobileUserContent.paginate(:select=>"id,sub_chapid,d_createddate,audio_tag,img_url,v_filename,e_filetype,uid,v_desc,v_tagname,audio_tag_url",:per_page => params[:items], :page => params[:page],:conditions=>"tagid=#{sub_chaps.tagid} and status = 'active'  and (e_filetype='video' or e_filetype='image') ",:group=>"id",:order =>"id desc")
        if total>0
          for content in contents
            if content
              logger.info(content.audio_tag)
              logger.info('content.audio_tag')
              if  !content.audio_tag.blank? || !content.audio_tag.nil?
                audio_tag= "#{content.audio_tag_url}/user_content/audio_tags/#{content.audio_tag}"
              else
                audio_tag= ""
              end
              if content.e_filetype=="image"
                val={:id=>content.id,:tags=>content.v_tagname,:sub_chapid=>content.sub_chapid,:user_id=>content.uid,:type=>content.e_filetype,:v_filename=>content.v_filename,:description=>content.v_desc,:d_createddate=>content.d_createddate.strftime("%a, %d %b %Y"),:small_thumb=>"#{content.img_url}/user_content/photos/small_thumb/#{content.v_filename}",:big_thumb=>"#{content.img_url}/user_content/photos/iphone/big_thumb/#{content.v_filename}",:audio_tag=>audio_tag,:data_type=>"mobile"}
                allimages.push(val)
              elsif content.e_filetype=="video"
                val={:id=>content.id,:tags=>content.v_tagname,:sub_chapid=>content.sub_chapid,:user_id=>content.uid,:type=>content.e_filetype,:v_filename=>content.v_filename,:description=>content.v_desc,:d_createddate=>content.d_createddate.strftime("%a, %d %b %Y"),:small_thumb=>"#{content.img_url}/user_content/videos/iphone/thumbnails/#{content.v_filename}.jpg",:big_thumb=>"#{content.img_url}/user_content/videos/thumbnails/#{content.v_filename}.jpg",:video_path=>"#{content.img_url}/user_content/videos/iphone/#{content.v_filename}.mp4",:audio_tag=>audio_tag,:data_type=>"mobile"}
                allimages.push(val)
              end
              @retval['body'] = allimages
              @retval['total_count'] = total
              @retval['page_number'] = params[:page]
              @retval['status'] = true
              @retval['count'] = contents.length
            end
          end
        else
          @retval['body'] = allimages
          @retval['total_count'] = 0
          @retval['message'] = 'No Image Found!'
          @retval['status'] = false
          @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
        end
      else
        @retval['body'] = allimages
        @retval['total_count'] = 0
        @retval['message'] = 'No Studio Session Chapter Found!'
        @retval['status'] = false
        @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      end
    else
      @retval['body'] = allimages
      @retval['total_count'] = 0
      @retval['message'] = 'Invalid Details'
      @retval['status'] = false
    end
    logger.info(@retval.inspect)
    render :text => @retval.to_json
  end


  def memory_lane_mobile_grid_data
    if !params[:user_id].blank?
      if params[:user_id].to_i==4
        album_count=2
      else
        gal_count=SubChapter.find_by_sql("SELECT COUNT( DISTINCT(sub_chapters.id) ) as count FROM  `sub_chapters` INNER JOIN user_contents ON sub_chapters.id = user_contents.sub_chapid WHERE sub_chapters.uid =#{params[:user_id]} AND sub_chapters.status =  'active'")
        album_count=gal_count[0]['count'].to_i
      end
      @retval = Hash.new()
      logger.info(album_count)
      if album_count == 1
        allimages=Array.new
        #total=MobileUserContent.count(:all,:select=>"distinct(id)",:conditions=>"status = 'active' and 	tagid=#{tags.id} and (e_filetype='video' or e_filetype='image')")
        contents = MobileUserContent.find(:all,:select=>"id,sub_chapid,d_createddate,audio_tag,img_url,v_filename,e_filetype,uid,v_desc,v_tagname,audio_tag_url",:conditions=>"uid=#{params[:user_id]} and status = 'active' and (e_filetype='video' or e_filetype='image')",:group=>"v_filename",:order =>"id desc")
        if contents
          for content in contents
            if  !content.audio_tag.blank? || !content.audio_tag.nil?
              audio_tag= "#{content.audio_tag_url}/user_content/audio_tags/#{content.audio_tag}"
            else
              audio_tag= ""
            end
            if  !content.v_tagname.blank? || !content.v_tagname.nil?
              tag=content.v_tagname
            else
              tag=" "
            end
            if content.e_filetype=="image"
              val={:id=>content.id,:tags=>tag,:sub_chapid=>content.sub_chapid,:user_id=>content.uid,:type=>content.e_filetype,:v_filename=>content.v_filename,:description=>content.v_desc,:d_createddate=>content.d_createddate.strftime("%a, %d %b %Y"),:small_thumb=>"#{content.img_url}/user_content/photos/small_thumb/#{content.v_filename}",:big_thumb=>"#{content.img_url}/user_content/photos/iphone/big_thumb/#{content.v_filename}",:audio_tag=>audio_tag,:data_type=>"mobile"}
              allimages.push(val)
            elsif content.e_filetype=="video"
              val={:id=>content.id,:tags=>tag,:sub_chapid=>content.sub_chapid,:user_id=>content.uid,:type=>content.e_filetype,:v_filename=>content.v_filename,:description=>content.v_desc,:d_createddate=>content.d_createddate.strftime("%a, %d %b %Y"),:small_thumb=>"#{content.img_url}/user_content/videos/iphone/thumbnails/#{content.v_filename}.jpg",:big_thumb=>"#{content.img_url}/user_content/videos/thumbnails/#{content.v_filename}.jpg",:video_path=>"#{content.img_url}/user_content/videos/iphone/#{content.v_filename}.mp4",:audio_tag=>audio_tag,:data_type=>"mobile"}
              allimages.push(val)
            end
            @retval['body'] = allimages
            @retval['total_count'] = contents.length
            @retval['page_number'] = params[:page]
            @retval['status'] = true
            @retval['count'] = contents.length
          end
        else
          @retval['body'] = allimages
          @retval['total_count'] = 0
          @retval['message'] = 'No Images Found!'
          @retval['status'] = false
          @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
        end
      elsif album_count > 1
        user_subchaps=UserContent.find(:all,:select=>"distinct(sub_chapid),max(d_createddate) as last_moment,v_filename,e_filetype,img_url",:conditions=>"sub_chapid is not null and uid=#{params[:user_id]} and status='active' and 	(e_filetype='image' or e_filetype='video')",:group=>"id")
        filtersubchap=Array.new
        user_content_ids={}
        imgs={}
        m_type={}
        server={}
        for user_subchap in user_subchaps
          filtersubchap.push(user_subchap.sub_chapid)
          user_content_ids.store(user_subchap.sub_chapid,user_subchap.last_moment)
          imgs.store(user_subchap.sub_chapid,user_subchap.v_filename)
          m_type.store(user_subchap.sub_chapid,user_subchap.e_filetype)
          server.store(user_subchap.sub_chapid,user_subchap.img_url)
        end
        filtersubchap=filtersubchap.uniq
        filtersubchap = filtersubchap.join(',')
        galleries=SubChapter.find(:all,:select=>"id,sub_chapname,updated_at,v_desc,img_url,v_image,v_desc,v_subchapter_tags,date_updated",:conditions=>"id in (#{filtersubchap})",:order=>"id desc")
        allgalleries=Array.new
        if galleries.length > 0
          for gallery in galleries
            imageName  = gallery.v_image
            imageName.slice!(-3..-1)
          
            full_desc=gallery.v_desc
            full_desc=full_desc.gsub(/\s+/, "")
            full_desc=full_desc.upcase
            if full_desc.match(/^ENTERDESCRIPTION/)
              desc=""
            else
              desc=gallery.v_desc
            end
            date_index = user_content_ids.key?(gallery.id)
            if date_index
              latest_gal_date = user_content_ids[gallery.id]
              img_file=user_content_ids[gallery.id]
              mom_type=user_content_ids[gallery.id]
              server_url=user_content_ids[gallery.id]
            end
            if !gallery.date_updated.nil? && !gallery.date_updated.blank?
              latest_gal_date=gallery.date_updated
            else
              latest_gal_date=latest_gal_date
            end
            if imageName=="folder_img."
              if mom_type=="image"
                file_name="#{server_url}/user_content/photos/coverflow/#{img_file}"
              elsif mom_type=="video"
                file_name="#{server_url}/user_content/videos/thumbnails/#{img_file}.jpg"
              end
            else
              file_name="#{gallery.img_url}/user_content/photos/flex_icon/#{imageName}jpg"
            end
            m_date=latest_gal_date.to_date.strftime("%a, %d %b %Y")
            val={:id=>gallery.id,:gallery_name=>gallery.sub_chapname,:sort_date=>latest_gal_date.to_date,:d_createddate=>m_date,:description=>desc,:tags=>gallery.sub_chapname,:small_thumb=>"#{gallery.img_url}/user_content/photos/icon_thumbnails/#{gallery.v_image}",:big_thumb=>file_name,:type=>"gallery"}
            allgalleries.push(val)
          end
          allgalleries.sort! { |x, y| y[:sort_date] <=> x[:sort_date] }
          @retval['body'] = allgalleries
          @retval['total_count'] =  galleries.length
          @retval['page_number'] = params[:page]
          @retval['status'] = true
          @retval['count'] = galleries.length
        else
          allgalleries=Array.new
          @retval['body'] = allgalleries
          @retval['total_count'] = 0
          @retval['message'] = 'No Subchapter Found!'
          @retval['status'] = false
          @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
        end
      elsif album_count == 0
        allgalleries=Array.new
        @retval['body'] = allgalleries
        @retval['total_count'] = 0
        @retval['message'] = 'No Subchapter with image Found!'
        @retval['status'] = false
        @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      end
    else
      allgalleries=Array.new
      @retval['body'] = allgalleries
      @retval['total_count'] = 0
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
      @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    end
    render :text => @retval.to_json
  end

  def memory_lane_studio_grid_data
    if !params[:user_id].blank?
      @retval = Hash.new()
      suchapters= SubChapter.find(:all,:select=>"id,tagid",:conditions=>"uid=#{params[:user_id]} and status='active' and store_id!=''",:order=>"id desc")

      if suchapters.length > 0
        subchap = Array.new
        for suchapter in suchapters
          subchap.push(suchapter.id)
        end
        gal_counts=Galleries.find(:all,:select =>"a.id",:joins=>"as a,user_contents as b",:conditions=>"a.subchapter_id in (#{subchap.join(',')}) and a.e_gallery_type!='audio' and 	a.status='active' and a.id=b.gallery_id and b.uid=#{params[:user_id]} and a.e_gallery_type!='audio'",:group=>"a.id")
        if  gal_counts.length > 0
          logger.info(gal_counts.length)
          if gal_counts.length == 1
            allimages=Array.new
            # total=MobileUserContent.count(:all,:select=>"distinct(id)",:conditions=>"tagid=#{suchapters.tagid} and 	status = 'active' and  (e_filetype='video' or e_filetype='image') ")
            contents = MobileUserContent.find(:all,:select=>"id,sub_chapid,d_createddate,audio_tag,img_url,v_filename,e_filetype,uid,v_desc,v_tagname,audio_tag_url",:conditions=>"tagid=#{suchapters[0].tagid} and status = 'active'  and (e_filetype='video' or e_filetype='image') ",:group=>"v_filename",:order =>"id desc")
            if contents.length>0
              for content in contents
                if  !content.audio_tag.blank? || !content.audio_tag.nil?
                  audio_tag= "#{content.audio_tag_url}/user_content/audio_tags/#{content.audio_tag}"
                else
                  audio_tag= ""
                end
                if  !content.v_tagname.blank? || !content.v_tagname.nil?
                  tag=content.v_tagname
                else
                  tag=" "
                end
                if content.e_filetype=="image"
                  val={:id=>content.id,:tags=>tag,:sub_chapid=>content.sub_chapid,:user_id=>content.uid,:type=>content.e_filetype,:v_filename=>content.v_filename,:description=>content.v_desc,:d_createddate=>content.d_createddate.strftime("%a, %d %b %Y"),:small_thumb=>"#{content.img_url}/user_content/photos/small_thumb/#{content.v_filename}",:big_thumb=>"#{content.img_url}/user_content/photos/iphone/big_thumb/#{content.v_filename}",:audio_tag=>audio_tag,:data_type=>"mobile"}
                  allimages.push(val)
                elsif content.e_filetype=="video"
                  val={:id=>content.id,:tags=>tag,:sub_chapid=>content.sub_chapid,:user_id=>content.uid,:type=>content.e_filetype,:v_filename=>content.v_filename,:description=>content.v_desc,:d_createddate=>content.d_createddate.strftime("%a, %d %b %Y"),:small_thumb=>"#{content.img_url}/user_content/videos/iphone/thumbnails/#{content.v_filename}.jpg",:big_thumb=>"#{content.img_url}/user_content/videos/thumbnails/#{content.v_filename}.jpg",:video_path=>"#{content.img_url}/user_content/videos/iphone/#{content.v_filename}.mp4",:audio_tag=>audio_tag,:data_type=>"mobile"}
                  allimages.push(val)
                end

                @retval['body'] = allimages
                @retval['total_count'] = contents.length
                @retval['page_number'] = params[:page]
                @retval['status'] = true
                @retval['count'] = contents.length
              end
            else
              @retval['body'] = allimages
              @retval['total_count'] = 0
              @retval['message'] = 'Incomplete details provided!'
              @retval['status'] = false
              @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
            end
          else
            user_content_ids={}
            galleries=Galleries.find(:all,:select=>"a.id,a.v_gallery_name,a.e_gallery_type,a.updated_at,a.v_desc,a.v_gallery_tags,a.img_url,a.v_gallery_image,max(d_createddate) as last_moment,a.date_updated",:joins=>"as a,user_contents as b",:conditions=>"a.subchapter_id in (#{subchap.join(',')}) and a.id=b.gallery_id and b.uid=#{params[:user_id]} and a.e_gallery_type!='audio' and a.status='active'",:group=>"a.id",:order=>"id desc")
            allgalleries=Array.new
            if galleries
              for gallery in galleries
                user_content_ids.store(gallery.id,gallery.last_moment)
                imageName  = gallery.v_gallery_image
                imageName.slice!(-3..-1)
                icon=gallery.img_url + '/user_content/photos/flex_icon/'+imageName+"jpg"
                full_desc=gallery.v_desc
                full_desc=full_desc.gsub(/\s+/, "")
                full_desc=full_desc.upcase
                logger.info(full_desc)
                if full_desc.match(/^ENTERDESCRIPTION/)
                  desc=""
                else
                  desc=gallery.v_desc
                end
                date_index = user_content_ids.key?(gallery.id)
                if date_index
                  latest_gal_date = user_content_ids[gallery.id]
                end
                if !gallery.date_updated.nil? && !gallery.date_updated.blank?
                  latest_gal_date=gallery.date_updated
                else
                  latest_gal_date=latest_gal_date
                end
                
                m_date=latest_gal_date.to_date.strftime("%a, %d %b %Y")
                sort_date=m_date.to_date
                val={:id=>gallery.id,:sort_date=>sort_date,:gallery_name=>gallery.v_gallery_name,:gallery_type=>gallery.e_gallery_type,:d_createddate=>m_date,:tags=>gallery.v_gallery_name,:description=>desc,:small_thumb=>"#{gallery.img_url}/user_content/photos/icon_thumbnails/#{gallery.v_gallery_image}",:big_thumb=>icon,:type=>"gallery"}
                allgalleries.push(val)
              end
              allgalleries.sort! { |x, y| y[:sort_date] <=> x[:sort_date] }
              @retval['body'] = allgalleries
              @retval['total_count'] = gal_counts.length
              @retval['page_number'] = params[:page]
              @retval['status'] = true
              @retval['count'] = galleries.length
            else
              @retval['body'] = allgalleries
              @retval['total_count'] = 0
              @retval['message'] = 'Incomplete details provided!'
              @retval['status'] = false
              @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
            end
          end
        else
          @retval['body'] = allgalleries
          @retval['total_count'] = 0
          @retval['message'] = 'No Studio Session Galley with image found'
          @retval['status'] = false
          @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
        end
      else
        @retval['message'] = 'No Studio Session Chapter Found!'
        @retval['total_count'] = 0
        @retval['status'] = false
        @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
    logger.info(galleries.inspect)
    render :text => @retval.to_json
  end



  def mobile_uploads_subchapters
    #    mobile_chapter = MobileTag.find(:first,:conditions => "uid = #{params[:user_id]} and tag_type = 'mobile_uploads' and status='active'")
    retval = Hash.new()
    allsub=Array.new
    user_content_ids={}
    #    if mobile_chapter
    ml_sub_count=0
    event_found=0
    mobile_events = MobileSubChapter.find(:all,:joins=>"as a,user_contents as b",:conditions=>"a.id=b.sub_chapid and a.uid=#{params[:user_id]} AND a.status='active' and b.status='active'",:select=>"max(d_createddate) as last_moment,date_updated,a.id as chapter_id,sub_chapname as chapter_name,a.v_desc as chapter_description,'event' as type,auto_share,CONCAT(a.img_url,'/user_content/photos/icon_thumbnails/',v_image) as chapter_image,store_id as studio_id,subchapter_type as subchapter_type",:group=>"a.id",:order=>"a.id desc")
    last_mobile_event = MobileSubChapter.find(:first,:conditions=>"uid=#{params[:user_id]} AND status='active'",:order=>"id desc")

    if mobile_events.length>0
      for mobile_event in  mobile_events
        user_content_ids.store(mobile_event.id,mobile_event.last_moment)
        date_index = user_content_ids.key?(mobile_event.id)
        if date_index
          latest_gal_date = user_content_ids[mobile_event.id]
        end
        if !mobile_event.date_updated.nil? && !mobile_event.date_updated.blank?
          latest_gal_date=mobile_event.date_updated
        else
          latest_gal_date=latest_gal_date
        end
        if mobile_event.subchapter_type=="memory_lane"
          ml_sub_count=1
        end
        val={:id=>mobile_event.chapter_id,:sub_chapname=>mobile_event.chapter_name,:icon=>"#{mobile_event.chapter_image}",:subchapter_type=>"#{mobile_event.subchapter_type}",:sort_date=>latest_gal_date.to_date}
        allsub.push(val)
        if last_mobile_event.id==mobile_event.chapter_id
          event_found=1
        else
          event_found=0
        end
      end
      if ml_sub_count==0
        ml_subchapter = MobileSubChapter.find(:first,:conditions => "uid = #{params[:user_id]} and subchapter_type = 'memory_lane' and status='active'")
        if !ml_subchapter.nil? && !ml_subchapter.blank?
          val={:id=>ml_subchapter.id.to_s,:sub_chapname=>ml_subchapter.sub_chapname,:icon=>"#{ml_subchapter.img_url}/user_content/photos/icon_thumbnails/#{ml_subchapter.v_image}",:subchapter_type=>"#{ml_subchapter.subchapter_type}",:sort_date=>ml_subchapter.d_created_on.to_date}
          allsub.push(val)
        end
      end
      if event_found==0
        ml_subchapter=last_mobile_event
        vals={:id=>ml_subchapter.id.to_s,:sub_chapname=>ml_subchapter.sub_chapname,:icon=>"#{ml_subchapter.img_url}/user_content/photos/icon_thumbnails/#{ml_subchapter.v_image}",:subchapter_type=>"#{ml_subchapter.subchapter_type}",:sort_date=>ml_subchapter.d_created_on.to_date}
      end
      allsub.sort! { |x, y| y[:sort_date] <=> x[:sort_date] }
      if vals!=nil
        allsub.unshift(vals)
      end
      
      retval['data']=allsub
      retval['status'] = true
    else
      retval['data']=allsub
      retval['desc']="No SubChapter Found"
      retval['status'] = false
    end
    #    else
    #      retval['data']=allsub
    #      retval['desc']="No Mobile Uploads Chapter Found"
    #      retval['status'] = false
    #    end
    render :text => retval.to_json
  end



  def memory_lane_data
    @retval = Hash.new()
    allimages=Array.new
    if !params[:user_id].blank?
      total= MobileUserContent.count(:all,:conditions => "uid=#{params[:user_id]} and status = 'active' and (e_filetype='video' or e_filetype='image')")
      contents = MobileUserContent.paginate(:per_page => params[:items], :page => params[:page],:conditions=>"uid =#{params[:user_id]} and status = 'active' and (e_filetype='video' or e_filetype='image') ",:order =>"id desc")
      for content in contents
        if content
          if content.e_filetype=="image"
            val={:id=>content.id,:gallery_id=>content.gallery_id,:tags=>content.v_tagname,:tagid=>content.tagid,:sub_chapid=>content.sub_chapid,:user_id=>content.uid,:type=>content.e_filetype,:e_access=>content.e_access,:e_visible=>content.e_visible,:v_filename=>content.v_filename,:description=>content.v_desc,:v_tagphoto=>content.v_tagphoto,:d_createddate=>content.d_createddate.strftime("%a, %d %b %Y"),:d_momentdate=>content.d_momentdate,:status=>content.status,:views=>content.views,:small_thumb=>"#{content.img_url}/user_content/photos/small_thumb/#{content.v_filename}",:big_thumb=>"#{content.img_url}/user_content/photos/iphone/big_thumb/#{content.v_filename}",:deleted_date=>content.deleted_date,:order_num=>content.order_num,:audio_tag=>content.audio_tag,:created_at=>content.created_at,:updated_at=>content.updated_at,:latitude=>content.latitude,:longitude=>content.longitude}
            allimages.push(val)
          elsif content.e_filetype=="video"
            val={:id=>content.id,:gallery_id=>content.gallery_id,:tags=>content.v_tagname,:tagid=>content.tagid,:sub_chapid=>content.sub_chapid,:user_id=>content.uid,:e_access=>content.e_access,:e_visible=>content.e_visible,:description=>content.v_desc,:type=>content.e_filetype,:v_tagphoto=>content.v_tagphoto,:d_createddate=>content.d_createddate.strftime("%a, %d %b %Y"),:d_momentdate=>content.d_momentdate,:status=>content.status,:views=>content.views,:small_thumb=>"#{content.img_url}/user_content/videos/iphone/thumbnails/#{content.v_filename}.jpg",:big_thumb=>"#{content.img_url}/user_content/videos/thumbnails/#{content.v_filename}.jpg",:video_path=>"#{content.img_url}/user_content/videos/iphone/#{content.v_filename}.mp4",:deleted_date=>content.deleted_date,:order_num=>content.order_num,:audio_tag=>content.audio_tag,:created_at=>content.created_at,:updated_at=>content.updated_at,:latitude=>content.latitude,:longitude=>content.longitude}
            allimages.push(val)
          elsif content.e_filetype=="audio"
            val={:id=>content.id,:gallery_id=>content.gallery_id,:tags=>content.v_tagname,:tagid=>content.tagid,:sub_chapid=>content.sub_chapid,:user_id=>content.uid,:e_access=>content.e_access,:e_visible=>content.e_visible,:description=>content.v_desc,:type=>content.e_filetype,:v_tagphoto=>content.v_tagphoto,:d_createddate=>content.d_createddate.strftime("%a, %d %b %Y"),:d_momentdate=>content.d_momentdate,:status=>content.status,:views=>content.views,:small_thumb=>"#{content.img_url}/user_content/audios/speaker.jpg",:audio_path=>"#{content.img_url}/user_content/audio/#{content.v_filename}",:deleted_date=>content.deleted_date,:order_num=>content.order_num,:audio_tag=>content.audio_tag,:created_at=>content.created_at,:updated_at=>content.updated_at,:latitude=>content.latitude,:longitude=>content.longitude}
            allimages.push(val)
          end
          @retval['body'] = allimages
          @retval['total_count'] = total
          @retval['page_number'] = params[:page]
          @retval['status'] = true
          @retval['count'] = contents.length
        else
          @retval['message'] = 'Incomplete details provided!'
          @retval['status'] = false
        end
        @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
    render :text => @retval.to_json
  end



  def memory_lane_gallery_images
    if !params[:gallery_id].blank?
      @retval = Hash.new()
      allimages=Array.new
      if params[:mobile] # For Mobile Uploads Image
        # total= MobileUserContent.count(:all,:conditions => "sub_chapid=#{params[:gallery_id]} and status = 'active'")
        contents = MobileUserContent.find(:all,:select=>"id,sub_chapid,d_createddate,audio_tag,img_url,v_filename,e_filetype,uid,v_desc,v_tagname,audio_tag_url",:conditions=>"sub_chapid=#{params[:gallery_id]} and status = 'active'",:group=>"v_filename",:order =>"id desc")
        data_type="mobile"
      else  # For Studio Session  Image
        #total= MobileUserContent.count(:all,:conditions => "gallery_id=#{params[:gallery_id]} and status = 'active'")
        contents = MobileUserContent.find(:all,:select=>"id,sub_chapid,d_createddate,audio_tag,img_url,v_filename,e_filetype,uid,v_desc,v_tagname,audio_tag_url",:conditions=>"gallery_id=#{params[:gallery_id]} and status = 'active'",:group=>"v_filename",:order =>"id asc")
        data_type="studio"
      end
      if contents
        for content in contents
          if  !content.audio_tag.blank? || !content.audio_tag.nil?
            audio_tag= "#{content.audio_tag_url}/user_content/audio_tags/#{content.audio_tag}"
          else
            audio_tag= ""
          end
          if  !content.v_tagname.blank? || !content.v_tagname.nil?
            tag=content.v_tagname
          else
            tag=" "
          end
          
          full_desc=content.v_desc
          full_desc=full_desc.gsub(/\s+/, "")
          full_desc=full_desc.upcase
          if full_desc.match(/^ENTERDESCRIPTION/)
            desc=""
          else
            desc=content.v_desc
          end

          if content.e_filetype=="image"
            val={:id=>content.id,:tags=>tag,:sub_chapid=>content.sub_chapid,:user_id=>content.uid,:type=>content.e_filetype,:v_filename=>content.v_filename,:description=>desc,:d_createddate=>content.d_createddate.strftime("%a, %d %b %Y"),:small_thumb=>"#{content.img_url}/user_content/photos/small_thumb/#{content.v_filename}",:big_thumb=>"#{content.img_url}/user_content/photos/iphone/big_thumb/#{content.v_filename}",:audio_tag=>audio_tag,:data_type=>data_type}
            allimages.push(val)
          elsif content.e_filetype=="video"
            val={:id=>content.id,:tags=>tag,:sub_chapid=>content.sub_chapid,:user_id=>content.uid,:type=>content.e_filetype,:v_filename=>content.v_filename,:description=>desc,:d_createddate=>content.d_createddate.strftime("%a, %d %b %Y"),:small_thumb=>"#{content.img_url}/user_content/videos/iphone/thumbnails/#{content.v_filename}.jpg",:big_thumb=>"#{content.img_url}/user_content/videos/thumbnails/#{content.v_filename}.jpg",:video_path=>"#{content.img_url}/user_content/videos/iphone/#{content.v_filename}.mp4",:audio_tag=>audio_tag,:data_type=>data_type}
            allimages.push(val)
          end
        end
        @retval['body'] = allimages
        @retval['total_count'] = contents.length
        @retval['page_number'] = params[:page]
        @retval['status'] = true
        @retval['count'] = contents.length
        @retval['id'] = params[:gallery_id]
      else
        @retval['message'] = 'Incomplete details provided!'
        @retval['total_count'] = 0
        @retval['status'] = false
        @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      end
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['total_count'] = 0
      @retval['status'] = false
      @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    end
    render :text => @retval.to_json
  end

  def update_description
    @retval = Hash.new()
    MobileUserContent.update(params[:image_id],:v_desc=>params[:description])
    @retval['status'] = true
    render :text => @retval.to_json
  end

  def update_tags
    @retval = Hash.new()
    MobileUserContent.update(params[:image_id],:v_tagname=>params[:tagname])
    @retval['status'] = true
    render :text => @retval.to_json
  end

  def search_tags
    @retval = Hash.new()
    allimages=Array.new
    tags=params[:tagname].split(" ")
    logger.info(tags.inspect)
    tags = tags.map {|y| y.upcase }
    search_query=''
    search_query << "2=1 "
    for search in tags
      search=search.gsub(/[^0-9A-Za-z]/, '')
      search_query << "OR v_tagname LIKE '%#{search}%'"
      search_query << "OR user_contents.v_desc LIKE '%#{search}%'"
    end
    if !params[:user_id].blank? || !params[:tagname].blank?
      if params[:mobile] # For Studio Session Image tags Search
        data_type="mobile"
        sub_chapters=SubChapter.find(:all,:select=>"a.id",:joins=>"as a,tags as b",:conditions=>"a.tagid=b.id and b.tag_type='mobile_uploads'  and b.uid=#{params[:user_id]} and a.status = 'active'",:group=>"a.id")
        user_tags=Tag.find(:first,:conditions=>"tag_type='mobile_uploads' and status='active' and uid=#{params[:user_id]}")
        contents =MobileUserContent.find(:all,:select=>"id,d_createddate,audio_tag,img_url,v_filename,e_filetype,uid,v_desc,v_tagname,audio_tag_url,sub_chapid",:conditions=>"uid = #{params[:user_id]} and (#{search_query}) and status = 'active' and tagid=#{user_tags.id} and (e_filetype='video' or e_filetype='image') ",:order =>"id desc")
      elsif params[:studio]
        data_type="studio" # For Mobile Uploads Image tags Search
        sub_chapters=SubChapter.find(:all,:select=>"id",:conditions=>"store_id is NOT NULL and uid=#{params[:user_id]} and status = 'active'")
        subchapter_id=Array.new
        for sub_chapter in  sub_chapters
          subchapter_id.push(sub_chapter.id)
        end
        contents =MobileUserContent.find(:all,:select=>"id,d_createddate,audio_tag,img_url,v_filename,e_filetype,uid,v_desc,v_tagname,audio_tag_url,sub_chapid",:conditions=>"uid = #{params[:user_id]}  and (#{search_query})  and status = 'active' and sub_chapid in(#{subchapter_id.join(',')}) and (e_filetype='video' or e_filetype='image') ",:order =>"id desc")
      elsif params[:general]
        for search in tags
          search=search.gsub(/[^0-9A-Za-z]/, '')
          search_query << "OR v_tagname LIKE '%#{search}%'"
          search_query << "OR user_contents.v_desc LIKE '%#{search}%'"
        end
        user_tags=Tag.find(:first,:conditions=>"tag_type='mobile_uploads' and status='active' and uid=#{params[:user_id]}")
        contents =MobileUserContent.find(:all,:select=>"user_contents.id,user_contents.d_createddate,user_contents.audio_tag,user_contents.img_url,user_contents.v_filename,user_contents.e_filetype,user_contents.uid,user_contents.v_desc,user_contents.v_tagname,user_contents.audio_tag_url,user_contents.sub_chapid,sub_chapters.store_id",:joins => "INNER JOIN sub_chapters ON sub_chapters.id = user_contents.sub_chapid",:conditions=>"user_contents.uid = #{params[:user_id]}  and (#{search_query}) and user_contents.status = 'active' and (e_filetype='video' or e_filetype='image') and (store_id is NOT NULL or sub_chapters.tagid=#{user_tags.id}) ",:order =>"user_contents.id desc")
      end
      if contents
        for content in contents
          if  !content.audio_tag.blank? || !content.audio_tag.nil?
            audio_tag= "#{content.audio_tag_url}/user_content/audio_tags/#{content.audio_tag}"
          else
            audio_tag= ""
          end
          if  !content.v_tagname.blank? || !content.v_tagname.nil?
            tag=content.v_tagname
          else
            tag=" "
          end
          if params[:general]
            if content.store_id.nil? || content.store_id.blank?
              data_type="mobile"
            else
              data_type="studio"
            end
          else
            data_type=data_type
          end
          if content.e_filetype=="image"
            val={:id=>content.id,:tags=>tag,:sub_chapid=>content.sub_chapid,:user_id=>content.uid,:type=>content.e_filetype,:v_filename=>content.v_filename,:description=>content.v_desc,:d_createddate=>content.d_createddate.strftime("%a, %d %b %Y"),:small_thumb=>"#{content.img_url}/user_content/photos/small_thumb/#{content.v_filename}",:big_thumb=>"#{content.img_url}/user_content/photos/iphone/big_thumb/#{content.v_filename}",:audio_tag=>audio_tag,:data_type=>data_type}
            allimages.push(val)
          elsif content.e_filetype=="video"
            val={:id=>content.id,:tags=>tag,:sub_chapid=>content.sub_chapid,:user_id=>content.uid,:type=>content.e_filetype,:v_filename=>content.v_filename,:description=>content.v_desc,:d_createddate=>content.d_createddate.strftime("%a, %d %b %Y"),:small_thumb=>"#{content.img_url}/user_content/videos/iphone/thumbnails/#{content.v_filename}.jpg",:big_thumb=>"#{content.img_url}/user_content/videos/thumbnails/#{content.v_filename}.jpg",:video_path=>"#{content.img_url}/user_content/videos/iphone/#{content.v_filename}.mp4",:audio_tag=>audio_tag,:data_type=>data_type}
            allimages.push(val)
          end
        end
        @retval['body'] = allimages
        @retval['total_count'] = allimages.length
        @retval['status'] = true
        @retval['count'] = allimages.length
      else
        @retval['message'] = 'No Image Found!'
        @retval['total_count'] = 0
        @retval['status'] = false
      end
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['total_count'] = 0
      @retval['status'] = false
    end
    render :text => @retval.to_json
  end

  def shift_data
    retval = Hash.new()
    if !params[:image_id].nil? &&  !params[:image_id].blank? && !params[:destination_subchap_id].nil? && !params[:destination_subchap_id].blank? && !params[:user_id].nil? &&  !params[:user_id].blank? && !params[:data_type].nil? &&  !params[:data_type].blank?
      image_id=params[:image_id]
      destination_subchap_id=params[:destination_subchap_id]
      user_id=params[:user_id]
      type=params[:data_type]
      image_data=UserContent.find(:first,:conditions=>"id=#{image_id} and uid=#{user_id}")
      sub_chapter=SubChapter.find(destination_subchap_id)
      gallery_data=Galleries.find(:first,:conditions=>"subchapter_id=#{destination_subchap_id} and 	e_gallery_type='#{type}' and status='active'")
      image_data.sub_chapid=destination_subchap_id
      image_data.gallery_id=gallery_data.id
      image_data.v_tagname=sub_chapter.sub_chapname
      if image_data.save
        retval['message'] = 'Success!'
        retval['status'] = true
      else
        retval['message'] = 'Wrong data Supplied !'
        retval['status'] = false
      end
    else
      retval['message'] = 'Incomplete details provided!'
      retval['status'] = false
    end
    render :text => retval.to_json
  end

  def get_subchapter_details
    retval = Hash.new()
    subchapter=SubChapter.find(:first,:conditions=>"id=#{params[:id]}")
    val={:id=>subchapter.id,:name=>subchapter.sub_chapname,:store_id=>subchapter.store_id}
    retval['body'] = val
    retval['status'] = true
    render :text => retval.to_json
  end

  def tell_friend
    retval  = Hash.new()

    @link="http://itunes.apple.com/us/app/holdmymemories.com/id477073119?ls=1&mt=8"
    @user =HmmUser.find(:first,:conditions=>"id=#{params[:user_id]}")
    @image = "#{@user.img_url}/hmmuser/familyphotos/thumbs/#{@user.family_pic}"
    email = render_to_string :action => "email_share_template",:layout => false
    retval['status'] = true
    retval['email_template']= email
    render :text => retval.to_json
  end

  def subchapter_rename
    retval  = Hash.new()
    if params[:sub_chap_id] && params[:user_id] && params[:sub_chapname]
      sub_chapter=SubChapter.find(:first,:conditions=>"id=#{params[:sub_chap_id]} and uid=#{params[:user_id]} and store_id is null")
      sub_chapter.sub_chapname=params[:sub_chapname]
      sub_chapter.save
      retval['status'] = true
    else
      retval['status'] = false
    end
    render :text => retval.to_json
  end



  def starts_with?(characters)
    self.match(/^#{characters}/) ? true : false
  end

end