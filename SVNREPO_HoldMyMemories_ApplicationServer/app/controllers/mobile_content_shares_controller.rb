class MobileContentSharesController < ApplicationController
  require 'json/pure'
  layout false
  before_filter :response_header

  def response_header
    response.headers['Pragma' ] = 'no-cache'
    response.headers['Cache-Control' ] = 'no-store, no-cache, max-age=0, must-revalidate'
    response.headers['Content-Type' ] = 'text/x-json'
  end

  def add_shares
    @retval = Hash.new()
    unless params[:share_emails].blank? && params[:share_contents].blank?  && params[:user_id].blank?
      share = MobileContentShare.new
      share.user_contents = params[:share_contents]
      share.save()
      moments = JSON.parse(params[:share_contents])
      content_id = moments[0]
      @user_content = MobileUserContent.find(:first,:conditions => "id=#{content_id}")

      if(request.subdomains[0]=="staging")
        subdomain = 'contentbackup'
      else
        subdomain = 'content'
      end

      @user = MobileHmmUser.find(:first,:conditions=>"id=#{params[:user_id]}")
      link = "http://#{request.subdomains[0]}.holdmymemories.com/familywebsite/shared_moments/#{@user.family_name}?share_id=#{share.id}"
      image = "#{@user_content.img_url}.holdmymemories.com/user_content/photos/big_thumb/#{@user_content.v_filename}"
      if params[:share_emails] && params[:share_emails]!=nil
        emails =  JSON.parse(params[:share_emails])
        for email in emails
          logger.info "Emailed to:#{email}"
          MobilePostOffice.deliver_share_user_contents(@user.v_user_name,@user.v_e_mail,email,link,image,@user_content.img_url)
        end
      end
      @retval['status'] = true
      @retval['facebook_share'] = params[:facebook_share]
      if params[:facebook_share]=="1"
        @retval['share_url']= link
        @retval['moment_url']= image
      end
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    render :text => @retval.to_json
  end


  def add_facebook_shares
    @retval = Hash.new()
    unless params[:share_contents].blank?  && params[:user_id].blank?
      share = MobileContentShare.new
      share.user_contents = params[:share_contents]
      share.save()
      moments = JSON.parse(params[:share_contents])
      content_id = moments[0]
      @user_content = MobileUserContent.find(:first,:conditions => "id=#{content_id}")
      if(request.subdomains[0]=="staging")
        subdomain = 'contentbackup'
      else
        subdomain = 'content'
      end

      content_type =@user_content.e_filetype
      if content_type=='image'
        image = "#{@user_content.img_url}/user_content/photos/small_thumb/#{@user_content.v_filename}"
      elsif content_type=='video'
        image = "#{@user_content.img_url}/user_content/videos/thumbnails/#{@user_content.v_filename}.jpg"
      elsif content_type=='audio'
        image = "#{@user_content.img_url}/user_content/audios/speaker.jpg"
      end


      @user = MobileHmmUser.find(:first,:conditions=>"id=#{params[:user_id]}")
      link = "http://#{request.subdomains[0]}.holdmymemories.com/familywebsite/shared_moments/#{@user.family_name}?share_id=#{share.id}"
      @retval['status'] = true
      @retval['share_url']= link
      @retval['moment_url']= image
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    render :text => @retval.to_json
  end


  def add_email_shares
    @retval = Hash.new()
    unless params[:share_contents].blank?  && params[:user_id].blank?
      share = MobileContentShare.new
      share.user_contents = params[:share_contents]
      share.save()
      moments = JSON.parse(params[:share_contents])
      content_id = moments[0]
      @user_content = MobileUserContent.find(:first,:conditions => "id=#{content_id}")
      if(request.subdomains[0]=="staging")
        subdomain = 'contentbackup'
      else
        subdomain = 'content'
      end

      content_type =@user_content.e_filetype
      if content_type=='image'
        @image = "#{@user_content.img_url}/user_content/photos/big_thumb/#{@user_content.v_filename}"
      elsif content_type=='video'
        @image = "#{@user_content.img_url}/user_content/videos/thumbnails/#{@user_content.v_filename}.jpg"
      elsif content_type=='audio'
        @image = "#{@user_content.img_url}/user_content/audios/speaker.jpg"
      end



      @user = MobileHmmUser.find(:first,:conditions=>"id=#{params[:user_id]}")
      @link = "http://#{request.subdomains[0]}.holdmymemories.com/familywebsite/shared_moments/#{@user.family_name}?share_id=#{share.id}"

      email = render_to_string :action => "email_share_template",:layout => false

      #logger.info(email)
      @retval['status'] = true
      @retval['email_template']= email
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    render :text => @retval.to_json
  end


  def add_email_gallery_shares
    @retval = Hash.new()
    unless params[:share_contents].blank?  && params[:user_id].blank?
      @user = MobileHmmUser.find(:first,:conditions=>"id=#{params[:user_id]}")
      if params[:share_moment_type]=="gallery"
        gallery=Galleries.find(params[:share_contents])
        @link = "http://#{request.subdomains[0]}.holdmymemories.com/familywebsite/gallery_contents/#{@user.family_name}?gallery_id=#{gallery.id}"
        imagename  = gallery.v_gallery_image
        imagename.slice!(-3..-1)
        @image = "#{gallery.img_url}/user_content/photos/flex_icon/#{imagename}jpg"
      else
        gallery=SubChapter.find(params[:share_contents])
        @link = "http://#{request.subdomains[0]}.holdmymemories.com/familywebsite/events_moments/#{@user.family_name}?event_id=#{gallery.id}"
        imagename  = gallery.v_image
        imagename.slice!(-3..-1)
        @image = "#{gallery.img_url}/user_content/photos/flex_icon/#{imagename}jpg"
      end
 
      email = render_to_string :action => "email_share_template",:layout => false

      #logger.info(email)
      @retval['status'] = true
      @retval['email_template']= email
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    render :text => @retval.to_json
  end



  def add_facebook_gallery_shares
    @retval = Hash.new()
    unless params[:share_contents].blank?  && params[:user_id].blank?
      @user = MobileHmmUser.find(:first,:conditions=>"id=#{params[:user_id]}")
      if params[:share_moment_type]=="gallery"
        gallery=Galleries.find(params[:share_contents])
        link = "http://#{request.subdomains[0]}.holdmymemories.com/familywebsite/gallery_contents/#{@user.family_name}?gallery_id=#{gallery.id}"
        imagename  = gallery.v_gallery_image
        imagename.slice!(-3..-1)
        image = "#{gallery.img_url}/user_content/photos/flex_icon/#{imagename}jpg"
      else
        gallery=SubChapter.find(params[:share_contents])
        link = "http://#{request.subdomains[0]}.holdmymemories.com/familywebsite/events_moments/#{@user.family_name}?event_id=#{gallery.id}&&f=true"
        imagename  = gallery.v_image
        imagename.slice!(-3..-1)
        image = "#{gallery.img_url}/user_content/photos/flex_icon/#{imagename}jpg"
      end
      @retval['status'] = true
      @retval['share_url']= link
      @retval['moment_url']= image
      @retval['type']="video"
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    render :text => @retval.to_json
  end

 

  def shared_moments_service #flex service
    @retval = Hash.new()
    unless params[:share_id].blank?
      content = MobileContentShare.find(:first,:conditions => "id=#{params[:share_id]}")
      if content
        contents = JSON.parse(content.user_contents)
        output = Array.new
        for content in contents
          details = UserContent.find(:first,:conditions => "id=#{content}")
          if details
            temp = Hash.new()
            if details['e_filetype']=='image'
              source_dir = '/user_content/photos/'
              temp['thumbnail'] = "#{details['img_url']}#{source_dir}small_thumb/#{details[:v_filename]}"
              temp['source']= "#{details['img_url']}#{source_dir}#{details[:v_filename]}"
              temp['file_type'] = 'image'
            elsif details['e_filetype'] =='video'
              source_dir = '/user_content/videos/'
              temp['thumbnail'] = "#{details['img_url']}#{source_dir}thumbnails/#{details[:v_filename]}.jpg"
              temp['source']= "#{details['img_url']}#{source_dir}#{details[:v_filename]}.flv"
              temp['file_type'] = 'video'
            elsif details['e_filetype'] =='audio'
              source_dir = '/user_content/audios/'
              temp['thumbnail'] = "#{details['img_url']}#{source_dir}/speaker.jpg"
              temp['source'] = "#{details['img_url']}#{source_dir}#{details[:v_filename]}"
              temp['file_type'] = 'audio'
            end
            temp['content_id'] = details['id']
            output.push(temp)
          end
        end
        @retval['message'] = output
        @retval['status'] = true
      else
        @retval['message'] = 'No contents shared!'
        @retval['status'] = false
      end
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    render :text => @retval.to_json
  end
end