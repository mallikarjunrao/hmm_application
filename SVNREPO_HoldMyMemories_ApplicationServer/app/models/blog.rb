class Blog < ActiveRecord::Base
  serialize :free_form_data

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
        newentry[:link]= "/familywebsite/subchapters/#{fname}?chapter_id=#{@entry.blog_type_id}"
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
        newentry[:link]= "/familywebsite/galleries/#{fname}?subchapter_id=#{@entry.blog_type_id}"
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
        newentry[:link]= "/familywebsite/gallery_contents/#{fname}?gallery_id=#{@entry.blog_type_id}"
      when "image"
        if @entry.client == 'website'
          newentry[:blog_type_id] = @entry.blog_type_id
          newentry[:thumbnail] = @entry.content_image_url
          newentry[:link]= "/familywebsite/moments/#{fname}?moment_id=#{@entry.blog_type_id}"
        else
          newentry[:blog_type_id] = @entry.blog_type_id
          newentry[:thumbnail] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/images/big_thumbnails/' + @entry.mobile_file_name
          newentry[:source] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/images/' + @entry.mobile_file_name
          newentry[:link]= "/blog/view_more/#{fname}?bid=#{@entry.blog_id}"
        end

      when "video"
        if @entry.client == 'website'
          newentry[:blog_type_id] = @entry.blog_type_id
          newentry[:thumbnail] = @entry.content_video_url
          newentry[:link]= "/familywebsite/moments/#{fname}?moment_id=#{@entry.blog_type_id}"
        else
          filename = @entry.mobile_file_name
          filename.slice!(-3..-1)
          newentry[:blog_type_id] = @entry.blog_type_id
          newentry[:thumbnail] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/videos/thumbnails/' + filename+'jpg'
          newentry[:source] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/videos/' + @entry.mobile_file_name+".flv"
          newentry[:link]= "/blog/view_more/#{fname}?bid=#{@entry.blog_id}"
        end

      when "audio"
        if @entry.client == 'website'
          newentry[:blog_type_id] = @entry.blog_type_id
          newentry[:thumbnail] = @entry.content_audio_url
          newentry[:link]= "/familywebsite/moments/#{fname}?moment_id=#{@entry.blog_type_id}"
        else
          filename = @entry.mobile_file_name
          newentry[:blog_type_id] = @entry.blog_type_id
          newentry[:thumbnail] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/audios/speaker.jpg'
          newentry[:source] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/audios/' + @entry.mobile_file_name
          newentry[:link]= "/blog/view_more/#{fname}?bid=#{@entry.blog_id}"
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
        newentry[:link]= "/blog/view_more/#{fname}?bid=#{@entry.blog_id}"


      when  ""
        newentry[:blog_type_id] =-1
        newentry[:thumbnail] ="/user_content/photos/icon_thumbnails/blogtextimage.png"
        newentry[:link]= "/blog/view_more/#{fname}?bid=#{@entry.blog_id}"
        
      when  "wordpress"
        newentry[:blog_type_id] = -1
        newentry[:thumbnail] ="/user_content/photos/icon_thumbnails/blogtextimage.png"
        newentry[:link]= "/blog/view_more/#{fname}?bid=#{@entry.blog_id}"
        
      when   "blogspot"
        newentry[:blog_type_id] =-1
        newentry[:thumbnail] ="/user_content/photos/icon_thumbnails/blogtextimage.png"
        newentry[:link]= "/blog/view_more/#{fname}?bid=#{@entry.blog_id}"

      end

      result.push(newentry)
    end
   
    return result
  end

  def self.format_results2(entries,fname,img_url)
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
          imgpath="#{img_url}/user_content/photos/flex_icon/"+imageName+"jpg"
          newentry[:thumbnail] = imgpath
        end
        newentry[:link]= "/familywebsite/subchapters/#{fname}?chapter_id=#{@entry.blog_type_id}"
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
          imgpath="#{img_url}/user_content/photos/flex_icon/"+imageName+"jpg"
          newentry[:thumbnail] = imgpath

        end
        newentry[:link]= "/familywebsite/galleries/#{fname}?subchapter_id=#{@entry.blog_type_id}"
      when "gallery"
        newentry[:blog_type_id] = @entry.blog_type_id

        if(@entry.gallery_image=="picture.png" || @entry.gallery_image=="audio.png" || @entry.gallery_image=="video.png")
          newentry[:thumbnail] ="/user_content/photos/icon_thumbnails/noimage.jpg"
        else
          imageName  = @entry.gallery_image
          if imageName
            imageName.slice!(-3..-1)
            imgpath="#{@entry.galleries_url}/user_content/photos/flex_icon/"+imageName+"jpg"
          else
            imgpath="/user_content/photos/icon_thumbnails/noimage.jpg"
          end
          newentry[:thumbnail] = imgpath

        end

        newentry[:gallery_type] = @entry.gallery_type
        newentry[:link]= "/familywebsite/gallery_contents/#{fname}?gallery_id=#{@entry.blog_type_id}"
      when "image"
        if @entry.client == 'website'
          newentry[:blog_type_id] = @entry.blog_type_id
          newentry[:thumbnail] = @entry.content_image_url
          newentry[:link]= "/familywebsite/moments/#{fname}?moment_id=#{@entry.blog_type_id}"
        else
          newentry[:thumbnail] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/images/thumbnails/' + @entry.mobile_file_name
          newentry[:source] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/images/' + @entry.mobile_file_name
          newentry[:link]= "#"
        end

      when "video"
        if @entry.client == 'website'
          newentry[:blog_type_id] = @entry.blog_type_id
          newentry[:thumbnail] = @entry.content_video_url
          newentry[:link]= "/familywebsite/moments/#{fname}?moment_id=#{@entry.blog_type_id}"
          newentry[:filename] = @entry.v_filename
          newentry[:uimg_url] = @entry.uimg_url
          newentry[:user_content_id] = @entry.user_content_id
          newentry[:filetype] = @entry.filetype
        else
          filename = @entry.mobile_file_name
          filename.slice!(-3..-1)
          newentry[:thumbnail] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/videos/thumbnails/' + filename+'jpg'
          newentry[:source] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/videos/' + @entry.mobile_file_name+"flv"
          newentry[:link]= "#"
        end

      when "audio"
        if @entry.client == 'website'
          newentry[:blog_type_id] = @entry.blog_type_id
          newentry[:thumbnail] = @entry.content_audio_url
          newentry[:link]= "/familywebsite/moments/#{fname}?moment_id=#{@entry.blog_type_id}"
          newentry[:filename] = @entry.v_filename
          newentry[:uimg_url] = @entry.uimg_url
          newentry[:user_content_id] = @entry.user_content_id
          newentry[:filetype] = @entry.filetype
        else
          filename = @entry.mobile_file_name
          newentry[:thumbnail] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/audios/speaker.jpg'
          newentry[:source] = @entry.mobile_server_url + '/user_content/mobile_blog_contents/audios/' + @entry.mobile_file_name
          newentry[:link]= "#"          
        end
      when "text"
        newentry[:blog_type_id] = @entry.blog_type_id
        if @entry.client == 'website'
          newentry[:thumbnail] ="/user_content/photos/icon_thumbnails/blogtextimage.png"
        else
          newentry[:thumbnail] ="/user_content/photos/icon_thumbnails/mobiletextblog.png"
        end
        newentry[:link]= "#"
      end
      result.push(newentry)
    end
    return result
  end

end