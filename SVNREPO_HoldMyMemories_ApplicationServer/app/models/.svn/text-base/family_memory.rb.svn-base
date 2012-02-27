class FamilyMemory < ActiveRecord::Base

  def self.format_results(entries,fname,img_url)
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
        newentry[:blog_type_id] = @entry.blog_type_id
        if(@entry.chapter_image=="folder_img.png")
          newentry[:thumbnail] ="/user_content/photos/icon_thumbnails/noimage.jpg"
        else
          imageName  = @entry.chapter_image
          imageName.slice!(-3..-1)
          imgpath="#{@entry.tag_url}/user_content/photos/flex_icon/"+imageName+"jpg"
          newentry[:thumbnail] = imgpath
        end
        newentry[:link]= "/family_memory/gallery_details/#{fname}?chapter_id=#{@entry.blog_type_id}"
        if @entry.chapter_type=='photo' || @entry.chapter_type == 'audio' || @entry.chapter_type == 'video'
          newentry[:type] = 'album'
          @entry.chapter_type=='image' if @entry.chapter_type == 'photo'
          newentry[:album_type] = @entry.chapter_type
        end
      when "subchapter"
        newentry[:blog_type_id] = @entry.blog_type_id
        if(@entry.subchapter_image=="folder_img.png")
          newentry[:thumbnail] ="/user_content/photos/icon_thumbnails/noimage.jpg"
        else
          imageName  = @entry.subchapter_image
          imageName.slice!(-3..-1)
          imgpath="#{@entry.sub_chapter_url}/user_content/photos/flex_icon/"+imageName+"jpg"
          newentry[:thumbnail] = imgpath

        end
        newentry[:link]= "/family_memory/gallery_details/#{fname}?sub_chapid=#{@entry.blog_type_id}"
      when "gallery"
        newentry[:blog_type_id] = @entry.blog_type_id

        if(@entry.gallery_image=="picture.png" || @entry.gallery_image=="audio.png" || @entry.gallery_image=="video.png")
          newentry[:thumbnail] ="/user_content/photos/icon_thumbnails/noimage.jpg"
        else
          imageName  = @entry.gallery_image
          imageName.slice!(-3..-1)
          imgpath="#{@entry.galleries_url}/user_content/photos/flex_icon/"+imageName+"jpg"
          newentry[:thumbnail] = imgpath

        end

        newentry[:gallery_type] = @entry.gallery_type
        newentry[:link]= "/family_memory/gallery_details/#{fname}?gallery_id=#{@entry.blog_type_id}"
      when "image"
        if @entry.client == 'website'
          newentry[:blog_type_id] = @entry.blog_type_id
          newentry[:thumbnail] = @entry.content_image_url
          newentry[:link]= "/family_memory/gallery_details/#{fname}?moment_id=#{@entry.blog_type_id}"
        else
          newentry[:blog_type_id] = @entry.blog_type_id
          newentry[:thumbnail] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/images/big_thumbnails/' + @entry.mobile_file_name
          newentry[:source] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/images/' + @entry.mobile_file_name
          newentry[:link]= "/family_memory/blog_view/#{fname}?bid=#{@entry.blog_id}"
        end

      when "video"
        if @entry.client == 'website'
          newentry[:blog_type_id] = @entry.blog_type_id
          newentry[:thumbnail] = @entry.content_video_url
          newentry[:link]= "/family_memory/gallery_details/#{fname}?moment_id=#{@entry.blog_type_id}"
        else
          filename = @entry.mobile_file_name
          filename.slice!(-3..-1)
          newentry[:blog_type_id] = @entry.blog_type_id
          newentry[:thumbnail] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/videos/thumbnails/' + filename+'jpg'
          newentry[:source] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/videos/' + @entry.mobile_file_name+".flv"
          newentry[:link]= "/family_memory/blog_view/#{fname}?bid=#{@entry.blog_id}"
        end

      when "audio"
        if @entry.client == 'website'
          newentry[:blog_type_id] = @entry.blog_type_id
          newentry[:thumbnail] = @entry.content_audio_url
          newentry[:link]= "/family_memory/gallery_details/#{fname}?moment_id=#{@entry.blog_type_id}"
        else
          filename = @entry.mobile_file_name
          newentry[:blog_type_id] = @entry.blog_type_id
          newentry[:thumbnail] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/audios/speaker.jpg'
          newentry[:source] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/audios/' + @entry.mobile_file_name
          newentry[:link]= "/family_memory/blog_view/#{fname}?bid=#{@entry.blog_id}"
        end
      when "text"
        newentry[:blog_type_id] = @entry.blog_type_id
        if @entry.client == 'website'
          newentry[:blog_type_id] =-1
          newentry[:thumbnail] ="/user_content/photos/icon_thumbnails/blogtextimage.png"
        else
          newentry[:blog_type_id] =-1
          newentry[:thumbnail] ="/user_content/photos/icon_thumbnails/mobiletextblog.png"
        end
        newentry[:link]= "/family_memory/blog_view/#{fname}?bid=#{@entry.blog_id}"


      when  ""
        newentry[:blog_type_id] =-1
        newentry[:thumbnail] ="/user_content/photos/icon_thumbnails/blogtextimage.png"
        newentry[:link]= "/family_memory/blog_view/#{fname}?bid=#{@entry.blog_id}"

      when  "wordpress"
        newentry[:blog_type_id] = -1
        newentry[:thumbnail] ="/user_content/photos/icon_thumbnails/blogtextimage.png"
        newentry[:link]= "/family_memory/blog_view/#{fname}?bid=#{@entry.blog_id}"

      when   "blogspot"
        newentry[:blog_type_id] =-1
        newentry[:thumbnail] ="/user_content/photos/icon_thumbnails/blogtextimage.png"
        newentry[:link]= "/family_memory/blog_view/#{fname}?bid=#{@entry.blog_id}"

      end

      result.push(newentry)
    end

    return result
  end

  def self.homepage_data(subdomain,session,owner_id,family_name,logged_id)
    subdomain = 'www' if subdomain.blank?
    all_galleries=Array.new
    gal_access=self.gallery_public(session,owner_id,logged_id)
    sub_access=self.subchapter_public(session,owner_id,logged_id)
    logger.info(sub_access)
    logger.info("sub_access")
    subchapters=SubChapter.find(:all,:select=>"id",:conditions=>"status='active' and store_id!='' #{sub_access} and uid=#{owner_id}")
    if !subchapters.nil? &&  !subchapters.blank?
      subchap=[]
      for subchapter in subchapters
        subchap.push(subchapter.id)
      end
      subchap=subchap.join(",")
      galleries_lists=[]
      user_content_ids={}
      gallery_imgs=UserContent.find(:all,:select=>"distinct(gallery_id),max(d_createddate) as last_moment",:conditions=>"sub_chapid in (#{subchap}) and status='active' #{sub_access} and (e_filetype='image' or e_filetype='video')",:group=>"gallery_id")
      if gallery_imgs
        if gallery_imgs.length>0
          for  gallery_img in gallery_imgs
            galleries_lists.push(gallery_img.gallery_id)
            user_content_ids.store(gallery_img.gallery_id,gallery_img.last_moment)
          end
          galleries_lists=galleries_lists.join(",")
          gals = MobileGallery.find(:all,:conditions => "id in (#{galleries_lists})  #{gal_access}",
            :select =>"edited_name,date_updated,id,v_gallery_name,d_gallery_date,img_url,v_gallery_image,v_desc")
          allstudio_gals=Hash.new
          if !gals.nil?
            if gals.length>0
              for gal in gals
                imageName  = gal.v_gallery_image
                imageName.slice!(-3..-1)
                date_index = user_content_ids.key?(gal.id)
                if !gal.edited_name.nil? && !gal.edited_name.blank?
                  disp_name=gal.edited_name
                else
                    disp_name="#{gal.v_gallery_name}"
                end
                if date_index
                  latest_gal_date = user_content_ids[gal.id]

                  if !gal.date_updated.nil? && !gal.date_updated.blank?
                    latest_gal_date=latest_gal_date
                  else
                    latest_gal_date=gal.d_gallery_date
                  end
                  allstudio_gals={:text=>disp_name,:gallery_id=>gal.id,:file_name=>disp_name,:sort_date=>latest_gal_date.to_date,:created_date=>latest_gal_date.to_date.strftime('%m/%d/%Y'),:img_url=>"#{gal.img_url}/user_content/photos/flex_icon/#{imageName}jpg",:orginal_img_url=>"#{gal.img_url}/user_content/photos/flex_icon/#{imageName}jpg",:displayDate=>"#{latest_gal_date.to_date.strftime("%b. %d, %Y")}",:type=>"galleries",:navigateUrl=>"/family_memory/gallery_contents/#{family_name}?gallery_id=#{gal.id}", :response_type => 'navigate_V4',:facebook_share_url=>CGI.escape("http://#{subdomain}.holdmymemories.com/family_memory/home/#{family_name}?familyname=#{family_name}&&t=#{rand(1000)}&&t=text"),:data_type => "gallery",:service_url=>"/family_memory/gallery_contents_data/#{family_name}?gallery_id=#{gal.id}",:back_service_url=>"",:folder_icon=>"#{gal.img_url}/user_content/photos/icon_thumbnails/#{gal.v_gallery_image}",:description=>gal.v_desc,:edit_tag_type=>"gallery",:studio_sessions=>"true"}
                  all_galleries.push(allstudio_gals)
                end
              end
            end
          end
        end
      end
    end
    #      if family_name.upcase=="BOB" || family_name.upcase=="EVELETH"
    subchapters_ser=self.gallery_data_bob(subdomain,session,owner_id,family_name,logged_id)
    all_galleries=all_galleries+subchapters_ser
    #      else
    #        tags=Tag.find(:first,:select=>"id",:conditions=>"tag_type='mobile_uploads' and uid=#{owner_id}")
    #        if !tags.nil? || !tags.blank?
    #          if session
    #            if logged_id==owner_id
    #              cond2="and 1=1"
    #            else
    #              cond2="and a.e_gallery_acess='public'"
    #            end
    #          else
    #            cond2="and a.e_gallery_acess='public'"
    #          end
    #          all_gal_mls=MobileGallery.find(:all,:select=>"a.edited_name,a.id,a.v_gallery_name,b.d_createddate as d_gallery_date,a.img_url,a.v_gallery_image,a.d_gallery_date,c.sub_chapname,a.v_desc",:joins=>"as a,sub_chapters as c, user_contents as b",:conditions=>"a.subchapter_id=c.id and b.tagid=#{tags.id} and a.id = b.gallery_id and c.uid=#{owner_id} and a.status='active'  #{cond2} and         (a.e_gallery_type='image' or a.e_gallery_type='video')",:group=>"a.id")
    #          allstudio_gals=Hash.new
    #          if !all_gal_mls.nil?
    #            if all_gal_mls.length>0
    #
    #              for all_gal_ml in all_gal_mls
    #                #          latest_gal = UserContent.find(:first, :conditions => "gallery_id = #{all_gal_ml.id}", :order => "d_createddate desc")
    #                #          if latest_gal
    #                #            latest_gal_date = latest_gal.d_createddate
    #                #          else
    #
    #                latest_gal_date = all_gal_ml.d_gallery_date
    #                #          end
    #                #all_gal_ml.user_contents.find(:first, :order => "d_createddate desc")
    #                imageName  = all_gal_ml.v_gallery_image
    #                imageName.slice!(-3..-1)
    #
    #                if !all_gal_ml.edited_name.nil? && !all_gal_ml.edited_name.blank?
    #                  disp_name1="#{all_gal_ml.edited_name}"
    #                else
    #                  disp_name1="#{all_gal_ml.v_gallery_name}"
    #                end
    #                allstudio_gals={:text=> disp_name1,:gallery_id=>all_gal_ml.id,:file_name=> disp_name1,:sort_date=>all_gal_ml.d_gallery_date.to_date,:created_date=>all_gal_ml.d_gallery_date.strftime('%m/%d/%Y'),:img_url=>"#{all_gal_ml.img_url}/user_content/photos/flex_icon/#{imageName}jpg",:orginal_img_url=>"#{all_gal_ml.img_url}/user_content/photos/flex_icon/#{imageName}jpg",:displayDate=>"#{latest_gal_date.strftime("%b. %d, %Y")}",:type=>"galleries",:navigateUrl=>"/family_memory/gallery_contents/#{family_name}?gallery_id=#{all_gal_ml.id}", :response_type => 'navigate_V4',:facebook_share_url=>CGI.escape("http://#{subdomain}.holdmymemories.com/family_memory/home/#{family_name}?familyname=#{family_name}&&t=#{rand(1000)}&&fb=text"),:data_type => "gallery",:service_url=>"/family_memory/gallery_contents_data/#{family_name}?gallery_id=#{all_gal_ml.id}",:back_service_url=>"",:folder_icon=>"#{all_gal_ml.img_url}/user_content/photos/icon_thumbnails/#{all_gal_ml.v_gallery_image}",:description=>all_gal_ml.v_desc,:edit_tag_type=>"gallery",:studio_sessions=>"false"}
    #                all_galleries.push(allstudio_gals)
    #              end
    #            end
    #          end
    #        end
    #      end

    if all_galleries.length!=1
      all_galleries.sort! { |x, y| y[:sort_date] <=> x[:sort_date] }
    else
      all_galleries=self.get_gallery_data(subdomain,session,owner_id,family_name,logged_id)
    end

    return all_galleries
  end

  def self.gallery_data_bob(subdomain,session,owner_id,family_name,logged_id)
    sub=[]
    sub_data=[]
    subdomain = 'www' if subdomain.blank?
    all_sub_data=UserContent.find(:all,:select=>"distinct(sub_chapid),max(d_createddate) as last_moment,v_filename,e_filetype,img_url",:conditions=>"uid=#{owner_id} and status='active' and sub_chapid is not null  and 	(e_filetype='image' or e_filetype='video')",:group=>"sub_chapid")
    user_content_ids={}
    imgs={}
    m_type={}
    server={}
    for ml_sub in all_sub_data
      sub.push(ml_sub.sub_chapid)
      user_content_ids.store(ml_sub.sub_chapid,ml_sub.last_moment)
      imgs.store(ml_sub.sub_chapid,ml_sub.v_filename)
      m_type.store(ml_sub.sub_chapid,ml_sub.e_filetype)
      server.store(ml_sub.sub_chapid,ml_sub.img_url)
    end
    mob_sub= sub.join(',')
    if session
      if logged_id==owner_id
        cond2="and 1=1"
      else
        cond2="and sub_chapters.e_access='public'"
      end
    else
      cond2="and sub_chapters.e_access='public'"
    end
    all_sub_chapters=SubChapter.find(:all,:select=>"sub_chapters.sub_chapname,sub_chapters.edited_name,sub_chapters.date_updated,sub_chapters.id,sub_chapters.img_url,sub_chapters.v_image,sub_chapters.v_desc",:conditions=>"sub_chapters.id in (#{mob_sub}) and sub_chapters.status='active' #{cond2} and store_id is null")
    for all_sub_chapter in all_sub_chapters
      imageName  = all_sub_chapter.v_image
      imageName.slice!(-3..-1)
      date_index = user_content_ids.key?(all_sub_chapter.id)
      if date_index
        latest_gal_date = user_content_ids[all_sub_chapter.id]
        img_file=imgs[all_sub_chapter.id]
        mom_type=m_type[all_sub_chapter.id]
        server_url=server[all_sub_chapter.id]
      end
     
      sub_chap=all_sub_chapter.sub_chapname.gsub(/\s+/, "")
      sub_chap=sub_chap.gsub(/[^0-9A-Za-z]/, '')
      sub_chap_name=sub_chap.upcase

      sub_chap_name=sub_chap_name.gsub(/[^0-9A-Za-z]/, '')
      if all_sub_chapter.edited_name.nil? || all_sub_chapter.edited_name.blank?
        disp_name="#{all_sub_chapter.sub_chapname}"
      else
        disp_name=all_sub_chapter.edited_name
      end
      if !all_sub_chapter.date_updated.nil? && !all_sub_chapter.date_updated.blank?
        latest_gal_date=all_sub_chapter.date_updated
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
        file_name="#{all_sub_chapter.img_url}/user_content/photos/flex_icon/#{imageName}jpg"
      end
      allsub_chaps={:text=>disp_name,:gallery_id=>all_sub_chapter.id,:file_name=>disp_name,:sort_date=>latest_gal_date.to_date,:created_date=>latest_gal_date.to_date.strftime('%m/%d/%Y'),:img_url=>file_name,:orginal_img_url=>file_name,:displayDate=>"#{latest_gal_date.to_date.strftime("%b. %d, %Y")}",:type=>"galleries",:navigateUrl=>"/family_memory/gallery_details/#{family_name}?moment_id=#{all_sub_chapter.id}", :response_type => 'navigate_V4',:facebook_share_url=>CGI.escape("http://#{subdomain}.holdmymemories.com/family_memory/home/#{family_name}?&&facebook=#{rand(1000)}&&t=text"),:data_type =>"gallery",:service_url=>"/family_memory/gallery_contents_data/#{family_name}?subchapter_id=#{all_sub_chapter.id}",:back_service_url=>"",:folder_icon=>"#{all_sub_chapter.img_url}/user_content/photos/icon_thumbnails/#{all_sub_chapter.v_image}",:description=>all_sub_chapter.v_desc,:edit_tag_type=>"subchapter",:studio_sessions=>"false"}
      sub_data.push(allsub_chaps)
    end
    return sub_data
  end

  def self.get_gallery_data(subdomain,session,owner_id,family_name,logged_id)
    all_galleries=[]
    subdomain = 'www' if subdomain.blank?
    cond=self.subchapter_public(session,owner_id,logged_id)
    gals=UserContent.find(:all,:conditions=>"uid=#{owner_id} #{cond} and status='active' and 	(e_filetype='image' or e_filetype='video')",:order=>"id asc")
    allstudio_gals=Hash.new
    subchapters=SubChapter.find(:first,:select=>"id",:conditions=>"status='active' and store_id!='' #{cond} and uid=#{owner_id} ")
    if !subchapters.nil? && !subchapters.blank?
      studio_sessions="true"
    else
      studio_sessions="false"
    end
    for gal in gals
      if gal.e_filetype=="image"
        small_thumb="#{gal.img_url}/user_content/photos/coverflow/#{gal.v_filename}"
        url="#{gal.img_url}/user_content/photos/journal_thumb/#{gal.v_filename}"
      elsif gal.e_filetype=="video"
        small_thumb="#{gal.img_url}/user_content/videos/thumbnails/#{gal.v_filename}.jpg"
        url="#{gal.img_url}/user_content/videos/#{gal.v_filename}.flv"
      end
      
      allstudio_gals={:text=>gal.v_tagname,:gallery_id=>gal.id,:file_name=>gal.v_tagname,:created_date=>gal.d_createddate.strftime('%m/%d/%Y'),:sort_date=>gal.d_createddate.to_date,:img_url=>"#{small_thumb}",:orginal_img_url=>"#{small_thumb}",:displayDate=>"#{gal.d_createddate.strftime("%b. %d, %Y")}",:type=>"galleries",:navigateUrl=>"/family_memory/gallery_details/#{family_name}?moment_id=#{gal.id}", :response_type => 'navigate_V4',:facebook_share_url=>CGI.escape("http://#{subdomain}.holdmymemories.com/family_memory/gallery_details/#{family_name}?gallery_id=#{gal.gallery_id}&&facebook=t"),:data_type =>"#{gal.e_filetype}",:video_url=>url,:service_url=>"/family_memory/gallery_contents_data/#{family_name}?gallery_id=#{gal.gallery_id}",:back_service_url=>"/family_memory/homepage_data/#{family_name}",:studio_sessions=>studio_sessions,:edit_tag_type=>"moment",:folder_icon=>"#{small_thumb}",:description=>gal.v_desc}
      all_galleries.push(allstudio_gals)
    end
    return all_galleries
  end

  def self.subchapter_public(session,owner_id,logged_id)
    logger.info(session)
    if session
      if logged_id==owner_id
        cond="and 1=1"
      else
        cond="and e_access='public'"
      end
    else
      cond="and e_access='public'"
    end
    return cond
  end

  def self.gallery_public(session,owner_id,logged_id)
    if session
      if logged_id==owner_id
        cond="and 1=1"
      else
        cond="and e_gallery_acess='public'"
      end
    else
      cond="and e_gallery_acess='public'"
    end
    return cond
  end
end