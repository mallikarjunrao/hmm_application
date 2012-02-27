class TagsController < ApplicationController
  layout "application"
  require 'will_paginate'
  before_filter :authenticate, :only => [:coverflow,:subchap_coverflow,:list,:new,:edit,:delete,:update]
  #   protected
  def authenticate
    unless session[:hmm_user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to :controller => "user_account" , :action => 'login'

      return false
    else
      if (session[:flag] == 1 && request.request_uri != "/customers/upgrade/platinum_account")
        flash[:error] = "Your credit card payment to your HoldMyMemories.com has been declined by your credit card company. This could be for a number of reasons, including an expired card. <br><br><br>Please re-enter your credit card information, or use a different card for the renewal of your account."
        redirect_to "https://www.holdmymemories.com/customers/upgrade/platinum_account"
      end
    end
  end

  def initialize
    super
    # @tags = [Item.new('item1'), Item.new('item2'), Item.new('item3'), Item.new('item4'), Item.new('item5')]
    #@tags = Tag.find(:all)
  end

  def index

  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy,  :update ],
  :redirect_to => { :action => :list }

  def list
    @tag_pages, @tags = paginate :tags, :per_page => 10

    render :action => 'list' , :layout => false
  end

  def family
    condition1 = 'family'
    @tag_pages, @tags = paginate :tags,
    :per_page => 10,
    :conditions => "e_tagtype = 'family'"

  end

  def events
    condition1 = 'event'
    @tag_pages, @tags = paginate :tags,
    :per_page => 10,
    :conditions => "e_tagtype = 'event'"

  end
  def paperwork
    condition1 = 'paperwork'
    @tag_pages, @tags = paginate :tags,
    :per_page => 10,
    :conditions => "e_tagtype = 'paperwork'"

  end

  def show
    @tag = Tag.find(params[:id])
    render(:layout => false)
  end

  def new
    @tag = Tag.new
    render(:layout => false)
  end

  def createchapter

    @tag = Tag.new()
    @tag['v_tagname'] = params[:name]
    @tag['uid'] = params[:userId]
    @tag['v_chapimage'] = "folder_img.png"
    @tag['e_access'] = "semiprivate"
    @tag['e_visible'] = "yes"
    @tag.d_updateddate = Time.now
    @tag.d_createddate = Time.now
    if @tag.save
      logger.info("cHapter created id:#{@tag.id}")
    end
    render(:layout => false)
  end
  def createsubchapter

    @sub_chapter = SubChapter.new()
    @sub_chapter['uid']=params[:userId]
    @sub_chapter['tagid']=params[:tagid]
    @sub_chapter['e_access'] = "semiprivate"
    @sub_chapter['sub_chapname']= "Sub Chapter"
    @sub_chapter['v_image'] = "folder_img.png"
    @sub_chapter['d_created_on'] = Time.now
    @sub_chapter['d_updated_on'] = Time.now

  end

  def creategallery

  end

  def create
    @tag = Tag.new()
    @tag['v_tagname'] = params[:name]
    @tag['uid'] = params[:userId]
    @tag['order_num'] = params[:ordernum]
    @tag['v_chapimage'] = "folder_img.png"
    @tag['e_access'] = "semiprivate"
    @tag['e_visible'] = "yes"

    @tag.d_updateddate = Time.now
    @tag.d_createddate = Time.now
    #@tag['']

    if @tag.save

      @sub_chapter = SubChapter.new()
      @sub_chapter['uid']=params[:userId]
      @sub_chapter['tagid']=@tag.id
      @sub_chapter['e_access'] = "semiprivate"
      @sub_chapter['sub_chapname']= "Sub Chapter"
      @sub_chapter['v_image'] = "folder_img.png"
      @sub_chapter['d_created_on'] = Time.now
      @sub_chapter['d_updated_on'] = Time.now
      @arr = Array.new()
      @arr[0] = 0
      @arr[1] = 1
      @arr[2] = 2
      if (@sub_chapter.save )
        for i in @arr
          gallery = Galleries.new

          if(i == 0)
            gallery["v_gallery_name"] = "Photo Gallery"
            gallery.e_gallery_type = "image"

            gallery.v_gallery_image = "picture.png"
          end
          if (i == 1)
            gallery["v_gallery_name"] = "Video Gallery"
            gallery.e_gallery_type = "video"
            gallery.v_gallery_image = "video.png"
          end
          if (i == 2)
            gallery["v_gallery_name"] = "Audio Gallery"
            gallery.e_gallery_type = "audio"
            gallery.v_gallery_image = "audio.png"
          end
          gallery.e_gallery_acess = "semiprivate"
          gallery.subchapter_id = @sub_chapter.id
          gallery.d_gallery_date = Time.now
          if gallery.save
            logger.info("gallery created id:#{gallery.id}")
            @arr[i] = gallery.id
          end
        end
      end


    end
    render(:layout => false)
  end

  def delete

  end

  def rearrange
    @ids = params[:id]
    @ordernum = params[:ordernum]
    @orderarray = @ordernum.split('$')
    @idarray = @ids.split('$')
    @i = 0
    for id in @idarray
      @tag = Tag.find(id)
      @tag.order_num = @orderarray[@i]
      if(@tag.save)
        @retval = "success"
      else
        @retval = "failed"
      end
      @i = @i + 1
    end

    render :layout => false
  end


  def edit
    @tag = Tag.find(params[:id])
    @tag.id = params[:id]
    @tag.v_chapter_tags = params[:tags]
    @tag.v_desc = params[:description]
    @tag.save
    render(:layout => false)
  end

  def update
    @tag = Tag.find(params[:id])
    if @tag.update_attributes(params[:tag])
      flash[:notice] = 'Tag was successfully updated.'
      render :action => 'show', :id => @tag
    else
      render :action => 'edit'
    end
  end

  def updateTag
    @tag = Tag.find(params[:id])
    @tag.id = params[:id]
    @tag.v_tagname = params[:name]
    @tag.v_chapter_tags = params[:tags]
    @tag.v_desc = params[:description]
    @tag.save
    render(:layout => false)
  end

  def destroy
    Tag.find(params[:id]).destroy
    redirect_to :action => 'tags', :action => ''
  end

  def live_search

    @phrase = request.raw_post.chop || request.query_string
    a1 = "%"
    a2 = "%"
    @searchphrase = a1 + @phrase + a2

    @results = Tag.find(:all, :conditions => [ "v_Tagname LIKE ?", @searchphrase])

    @number_match = @results.length

    render(:layout => false)
  end

  def search
    @results = Tag.find(:all) #, :conditions => [ "v_fname LIKE ?", @searchphrase])

    render(:layout => false)

  end

  def deleteSelection
    i = 0
    colmns = @tags.clone
    colmns.each { |colmn|
      i = i + 1
      if (params['colmn_'+i.to_s] != nil) then
        checked = params['colmn_'+i.to_s]
        if (checked != nil && checked.length > 0) then
          Tag.find(checked).destroy
          #@tags.delete(item)
          #redirect_to :action => :list
          # else
        end
      end
    }
    redirect_to :action => :list
  end

  def deleteSelection1
    i = 0
    colmns = @tags.clone
    colmns.each { |colmn|
      i = i + 1
      if (params['colmn_'+i.to_s] != nil) then
        checked = params['colmn_'+i.to_s]
        if (checked != nil && checked.length > 0) then
          Tag.find(checked).destroy
        end
      end
    }
    render :action => :search
  end

  def tagDestroy
    #@val = params[:id]
    @tag = Tag.find(params[:id])
    #@tag.v_tagname=@tag.v_tagname+"-deleted"
    @tag.status = "inactive"
    @tag.save
    render :layout => false
  end

  def renameTag
    @tag = Tag.find(params[:id])
    @tag.v_tagname = params[:name]
    if(@tag.save)
      @retval = "success"
    else
      @retval = "failed"
    end
    render :layout => false
  end

  def permissions
    chapter = Tag.find(params[:id])
    if(chapter != nil)
      chapter.e_access = params[:permission]
      @result = chapter.save
    end
    @result = "nothing"
    render :layout => false
  end

  def permissionsall

    chapter = Tag.find(params[:id])
    if(chapter != nil)
      chapter.e_access = params[:permission]
      @result = chapter.save
      sql = ActiveRecord::Base.connection();
      sql.execute("update sub_chapters set sub_chapters.e_access='#{params[:permission]}' where sub_chapters.tagid=#{params[:id]}") ;
      sql.commit_db_transaction;
      sql = ActiveRecord::Base.connection();
      sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where user_contents.tagid=#{params[:id]}") ;
      sql.commit_db_transaction;
      @subids = Tag.find_by_sql("select sub_chapters.id as id from sub_chapters where sub_chapters.tagid=#{params[:id]}")
      for subid in @subids
        sql = ActiveRecord::Base.connection();
        sql.execute("update galleries set galleries.e_gallery_acess='#{params[:permission]}' where galleries.subchapter_id=#{subid.id}") ;
        sql.commit_db_transaction;
      end
    end
    #   sql = ActiveRecord::Base.connection();
    #   sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=#{params[:id]} and sub_chapters.tagid=#{params[:id]} and galleries.subchapter_id=sub_chapters.id and user_contents.tagid=#{params[:id]}") ;
    #  sql.commit_db_transaction;
    #   chapter = Tag.find(params[:id])
    #   if(chapter != nil)
    #	chapter.e_access = params[:permission]
    #	@result = chapter.save
    #        sql = ActiveRecord::Base.connection();
    #        sql.execute("update sub_chapters set e_access=#{params[:permission]} where tagid=#{params[:id]}");
    #        sql.commit_db_transaction;
    #        @subchpids = SubChapter.find_by_sql("select id from sub_chapters where tagid=#{params[:id]}");
    #        for subid in subchpids
    #          sql = ActiveRecord::Base.connection();
    #          sql.execute("update galleries set e_gallery_acess=#{params[:permission]} where subchapter_id=#{subid}");
    #          sql.commit_db_transaction;
    #        end
    #        sql = ActiveRecord::Base.connection();
    #        sql.execute("update user_contents set e_access=#{params[:permission]} where tagid=#{params[:id]}");
    #        sql.commit_db_transaction;
    #   end

    render :layout => false

  end

  def hide
    @tag = Tag.find(params[:id])
    @tag.e_access = "private"
    # set the subchapters and galleries private
    subchapters  = SubChapter.find(:all, :conditions=>"tagid=#{@tag.id}")
    for subchapter in subchapters
      galleries = Galleries.find(:all, :conditions=>"subchapter_id=#{subchapter.id}")
      for gallery in galleries
        usercontents = UserContent.find(:all, :conditions=>"gallery_id=#{gallery.id}")
        for usercontent in usercontents
          usercontent.e_access = "private"
          usercontent.save()
        end
        gallery.e_gallery_acess = "private"
        gallery.save()
      end
      subchapter.e_access = "private"
      subchapter.save()
    end

    if(@tag.save)
      @retval = "success"
    else
      @retval = "failed"
    end
    render :layout => false
  end

  def unhide
    @tag = Tag.find(params[:id])
    @tag.e_access = "public"
    subchapters  = SubChapter.find(:all, :conditions=>"tagid=#{@tag.id}")
    for subchapter in subchapters
      galleries = Galleries.find(:all, :conditions=>"subchapter_id=#{subchapter.id}")
      for gallery in galleries
        usercontents = UserContent.find(:all, :conditions=>"gallery_id=#{gallery.id}")
        for usercontent in usercontents
          usercontent.e_access = "public"
          usercontent.save()
        end
        gallery.e_gallery_acess = "public"
        gallery.save()
      end
      subchapter.e_access = "public"
      subchapter.save()
    end
    if(@tag.save)
      @retval = "success"
    else
      @retval = "failed"
    end
    render :layout => false
  end

  def resize(img, destinationH, destinationW,path)
    # maxU = destinationH/img.rows
    # maxV = destinationW/img.columns

    finalImage =  Image.new(destinationW,destinationH) { self.background_color = "black" }
    if(img.rows > img.columns)
      w = destinationH*img.columns/img.rows
      puts w
      h = destinationH
      x = (destinationW - w)/2
      y = 0
      img.scale!(w, h)
      finalImage = finalImage.composite(img,x,y,CopyCompositeOp)
    else
      w = destinationW
      h = destinationW*img.rows/img.columns

      puts h
      puts w
      y = (destinationH - h)/2
      x = 0
      puts x
      puts y
      img.scale!(w, h)

      finalImage = finalImage.composite(img,x,y,CopyCompositeOp)

    end
    return finalImage
    #finalImage.write("output.jpg")
    #finalImage.write("#{path}")
  end

  def setThumbnail
    chapter = Tag.find(:all, :conditions=>"id=#{params[:id]}")
    if(chapter[0]['v_chapimage'] != "folder_img.png")
      begin
        logger.info("Deleting old icon file #{chapter[0]['v_chapimage']}")
        File.delete("#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/#{chapter[0]['v_chapimage']}")
        File.delete("#{RAILS_ROOT}/public/user_content/photos/flex_icon/#{chapter[0]['v_chapimage']}")
      rescue
        logger.info("Error deleting file")
      end

    end
    content = UserContent.find(:all, :conditions =>"id=#{params[:itemId]}")
    # read the newly uploaded image to create the thumb nails
    filename = "empty"
    iconname = "empty"
    if(content[0] != nil)
      if(content[0].e_filetype == "image")
        iconname = content[0].v_filename
        filename = "#{RAILS_ROOT}/public/user_content/photos/#{content[0].v_filename}"
        logger.info(filename)
        img1 = Magick::Image.read(filename).first

      elsif(content[0].e_filetype == "audio")
        iconname = "speaker.jpg"
        filename = "#{RAILS_ROOT}/public/user_content/audios/speaker.jpg"
        logger.info(filename)
        img1 = Magick::Image.read(filename).first
      elsif(content[0].e_filetype == "video" || content[0].e_filetype == "swf")
        iconname = "#{content[0].v_filename}.jpg"
        filename = "#{RAILS_ROOT}/public/user_content/videos/thumbnails/#{content[0].v_filename}.jpg"
        logger.info(filename)
        img1 = Magick::Image.read(filename).first
      end
    end
    chars = ["A".."Z","a".."z","0".."9"].collect { |r| r.to_a }.join
    newfilename = (1..8).collect { chars[rand(chars.size)] }.pack("C*")
    img2 = resize(img1, 72, 72,"#{RAILS_ROOT}/public/user_content/photos/big_thumb/#{content[0].v_filename}")
    #img = Magick::Image.read("#{RAILS_ROOT}/public/user_content/photos/cropthumb/#{content[0].v_filename}").first
    folderImage = Magick::Image.read("#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/folder_img.png").first
    uploadedImage = Magick::Image.read(filename).first
    big_thumb = resizeWithoutBorder(uploadedImage,320,240,"nil")
    big_thumb.write("#{RAILS_ROOT}/public/user_content/photos/flex_icon/#{newfilename}.jpg")
    #	 IF(IMG.ROWS < IMG.COLUMNS)
    #		 CROPPEDIMAGE = IMG.CROP(0,0,IMG.ROWS, IMG.ROWS)
    #
    #
    #	 ELSE
    #		 CROPPEDIMAGE = IMG.CROP(0,0,IMG.COLUMNS, IMG.COLUMNS)
    #
    #
    #	 END
    #scaledImage = croppedImage.scale(72,72)

    imageName = newfilename

    finalImage = folderImage.composite(img2, 4, 9, CopyCompositeOp)
    @newchapterIcon = "#{imageName}.png"
    chapter[0]['v_chapimage'] = @newchapterIcon
    finalImage.write("#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/#{@newchapterIcon}")

    chapter[0].save



    render :layout => false
  end

  def gohome
    session[:friend]=""
    redirect_to :controller => "tags" , :action => 'coverflow'

  end

  def chaptersList
    if(session[:friend]=="" || session[:friend]==nil)
      uid=logged_in_hmm_user.id
    else
      uid=session[:friend]
    end
    @chapterList = Tags.find(:all, :conditions => "uid=#{uid} and status='active'" , :order => "id ASC")
  end


  def memories
    @paths = ContentPath.find(:first,:conditions=>"status='active'")
    @versions =  VersionDetail.find(:first,:conditions=>"file_name='ShareCoverFlow'")
    sql = ActiveRecord::Base.connection();
    sql.update "UPDATE shares SET shown='true' WHERE id = '#{params[:id]}'";
    @swfName = "PhotoGallery"
    @presenter_name=Share.find(:all,:select => "a.*,b.*",:joins => "as a, hmm_users as b", :conditions => "a.id=#{params[:id]} and a.presenter_id=b.id")
    @galleryUrl = "/share/getMemories/"+params[:id]
    shid=params[:id]
    session[:shid]=shid
    shar=Share.find(params[:id])
    params[:id]=shar.presenter_id
    email_list1=shar.email_list
    email_list=email_list1.split(",")
    newlist=email_list[0]
    # for emailfind in email_list
    #  if(logged_in_hmm_user.v_e_mail==emailfind || newlist==emailfind)
    # else
    #  newlist=newlist+","+emailfind
    #end
    #end
    email_list=shar.email_list
    email_array=email_list.split(',')
    for email in email_array
      #check for if email id exists in hmm database
      hmm_userscount = HmmUser.count(:all, :conditions => "id='#{logged_in_hmm_user.id}' and v_e_mail='#{email}'  ")
      if(hmm_userscount>0)
        flag=1
        hmm_userscount = Share.count(:all, :conditions => "id='#{shar.id}' and presenter_id='#{logged_in_hmm_user.id}'")
        if(hmm_userscount>0)
          flag=1
          #          else
          #           flag=0
        end
      else
        flag=0
      end
    end
    puts hmm_userscount
    filename = shar.xml_name
    #      sqlCmd = "select * from content_paths where content_path=\'"+shar.img_url+"\'";
    #      contentpath = Tag.find_by_sql(sqlCmd)
    #      puts contentpath[0].proxyname
    @swfName = "ShareCoverFlow"
    @galleryUrl = "/share/shared_moments_list/#{shar.id}"
    #      shareXml = XmlSimple.xml_in("http://192.168.4.116/share/#{filename}")
    #
    #      # message that needs to be sent.
    #
    #       if(shareXml["content"] != nil)
    #	  if(shareXml["content"][0]==nil)
    #            hmmtype = shareXml["content"]["hmmtype"]
    #          else
    #            begin
    #              hmmtype = shareXml["content"][0]["hmmtype"]
    #          rescue
    #             hmmtype = shareXml["content"]["hmmtype"]
    #          end
    #          end
    #       end

    #   hmmtype = 'image'
    #
    #       if(flag==1)
    #          if hmmtype == "image"
    #            @swfName = "PhotoGallery"
    #            @galleryUrl = "/share/getMemories/"+shid
    #            @norecords=""
    #          else if hmmtype == "video"
    #            @swfName = "ShareVideoCoverflow"
    #            @galleryUrl = "/share/getMemories/"+shid
    #            @norecords=""
    #          else if hmmtype == "audio"
    #            @swfName = "ShareAudioCoverflow"
    #            @galleryUrl = "/share/getMemories/"+shid
    #            @norecords=""
    #          end
    #        end
    #       end
    #      else
    #        @norecords="No records found"
    #      end

    #shar.email_list=newlist
    #shar.save
    hmm_user=HmmUser.find(params[:id])
    @fname=hmm_user.v_fname
    hmm_userid=params[:id]
    params[:id]=shid
    if logged_in_hmm_user.id == hmm_userid

    else
      session[:friend]=hmm_user.id
      session[:share]=""
      session[:share_with_hmm]="check"
    end
    render :layout => true

  end

  def coverflow
    session[:sharepath]=nil
    session[:share_with_hmm]=nil
    session[:shid]=nil
    session[:share]=nil

    if(session[:friend]=="" || session[:friend]==nil)
      uid=logged_in_hmm_user.id
    else
      uid=session[:friend]
    end
    contentservers = ContentPath.find(:all)
    @proxyurls = nil
    for server in contentservers
      if(@proxyurls == nil)
        @proxyurls = server['content_path']
      else
        @proxyurls = @proxyurls +','+server['content_path']
      end
    end
    @tag = Tag.find(:all, :conditions=>"uid=#{logged_in_hmm_user.id}")
    @fnf_req = FamilyFriend.find_by_sql("SELECT b.*, a.id as frnid, a.* FROM family_friends  as a ,hmm_users as b  WHERE (a.fid=#{logged_in_hmm_user.id} and a.uid=b.id and a.status='pending')")
    @fnf_req1 = FamilyFriend.find_by_sql("SELECT b.*, a.id as frnid, a.* FROM family_friends  as a ,hmm_users as b  WHERE (a.uid=#{logged_in_hmm_user.id} and a.uid=b.id and a.status='pending')")
    @total = FamilyFriend.count(:all,:conditions => "fid=#{logged_in_hmm_user.id} and status='pending'")

    #contest entry approval alert
    @contest = Contest.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and status='active'")

    #@share_journal = ShareJournal.count(:all, :joins => "as a, hmm_users as b", :conditions => "b.id=#{logged_in_hmm_user.id} and a.e_mail = '#{logged_in_hmm_user.v_e_mail}' and DATE_FORMAT(a.expiry_date,'%Y-%m-%d') >= curdate() and shown='false' ")
    @share_journal = ShareJournal.count(:all, :joins => "as a, hmm_users as b", :conditions => "b.id=#{logged_in_hmm_user.id} and a.e_mail = '#{logged_in_hmm_user.v_e_mail}' and DATE_FORMAT(a.expiry_date,'%Y-%m-%d') >= curdate() and shown='false'")
    @sharemomentcnt = ShareMoment.count(:all, :joins => "as a, hmm_users as b", :conditions => "b.id=#{logged_in_hmm_user.id} and a.email=b.v_e_mail and DATE_FORMAT(a.expiry_date,'%Y-%m-%d') >= curdate() and shown='false' and status = 'pending'")

    #@total1 = Share.count(:all, :joins=>"as b , hmm_users as a ", :conditions => " a.id=#{logged_in_hmm_user.id} and b.email_list=a.v_e_mail and DATE_FORMAT(b.expiry_date,'%Y-%m-%d') >= curdate()")
    @total1 = Share.count(:all, :joins=>"as b , hmm_users as a ", :conditions => " a.id=#{logged_in_hmm_user.id} and b.email_list LIKE '%#{logged_in_hmm_user.v_e_mail}%' and DATE_FORMAT(b.expiry_date,'%Y-%m-%d') >= curdate() and shown='false'")
    @total2 = Export.count(:all,:conditions => "exported_to=#{logged_in_hmm_user.id} and status='pending'")
    @chapcmt = HmmUser.count(:all, :joins=>"as a, chapter_comments as b  WHERE a.id=b.uid and a.id='#{logged_in_hmm_user.id}'")

    @sharemomentcomment = ShareMomentcomment.count(:all, :joins => "as a, share_moments as b", :conditions => "b.id=a.share_id and b.presenter_id=#{logged_in_hmm_user.id} and DATE_FORMAT(a.added_date, '%Y-%m-%d' ) = CURDATE() and a.e_approved='pending'")
    @chapcmt = Tag.count(:all, :joins=>"as a, chapter_comments as b  WHERE b.tag_id=a.id and a.uid='#{logged_in_hmm_user.id}' and DATE_FORMAT( b.d_created_on, '%Y-%m-%d' ) = CURDATE() and b.e_approval='pending'")
    @subcmt = SubChapter.count(:all, :joins=>"as a, subchap_comments as b  WHERE b.subchap_id=a.id and a.uid='#{logged_in_hmm_user.id}' and DATE_FORMAT( b.d_created_on, '%Y-%m-%d' ) = CURDATE() and b.e_approval='pending'")
    @galcmt = Galleries.count(:all, :joins=>"as a, gallery_comments AS b, sub_chapters AS c  WHERE b.gallery_id = a.id and a.subchapter_id = c.id and c.uid ='#{logged_in_hmm_user.id}' and DATE_FORMAT( b.d_created_on, '%Y-%m-%d' ) = CURDATE() and b.e_approval='pending'")
    @momentcmt = UserContent.count(:all, :joins=>"as a, photo_comments as b  WHERE b.user_content_id = a.id and a.uid='#{logged_in_hmm_user.id}' and DATE_FORMAT( b.d_add_date, '%Y-%m-%d' ) = CURDATE() and b.e_approved='pending'")
    @guestcmt = GuestComment.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and DATE_FORMAT( comment_date, '%Y-%m-%d' ) = CURDATE() and status='pending' ")
    @sharecmt = ShareComments.count(:all, :joins => "as a, shares as b", :conditions => "a.share_id=b.id and b.presenter_id='#{logged_in_hmm_user.id}' and DATE_FORMAT( a.d_add_date, '%Y-%m-%d' ) = CURDATE() and a.e_approved='pending' ")
    @msgboardcmt = MessageBoard.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and DATE_FORMAT( created_at, '%Y-%m-%d' ) = CURDATE() and status='pending' ")

    @total_comments = @chapcmt + @subcmt + @galcmt + @momentcmt + @sharemomentcomment + @guestcmt + @sharecmt + @msgboardcmt
    $prototype = false
    render :layout => true
  end

  def fnfAlert
    sql = ActiveRecord::Base.connection();
    @total = FamilyFriend.count(:all,:conditions => "fid=#{logged_in_hmm_user.id} and status='pending' ")

    @total1 = Share.count(:all, :joins=>"as b , hmm_users as a ",
    :conditions => "a.id=#{logged_in_hmm_user.id} and b.email_list LIKE '%#{logged_in_hmm_user.v_e_mail}%' and DATE_FORMAT(b.expiry_date,'%Y-%m-%d') >= curdate() and shown='false'")   #

    #contest entry approval alert
    @contest_image = Contest.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and moment_type='image' and status='active'")
    @contest_image_details = Contest.find(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and moment_type='image' and status='active'")
    for n in @contest_image_details
      @moment_id = n.moment_id
    end
    @contest_video = Contest.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and moment_type='video' and status='active'")

    @share_journal = ShareJournal.count(:all, :joins => "as a, hmm_users as b", :conditions => "b.id=#{logged_in_hmm_user.id} and a.e_mail = '#{logged_in_hmm_user.v_e_mail}' and DATE_FORMAT(a.expiry_date,'%Y-%m-%d') >= curdate() and shown='false'")  #
    @sharemomentcnt = ShareMoment.count(:all, :joins => "as a, hmm_users as b", :conditions => "b.id=#{logged_in_hmm_user.id} and a.email=b.v_e_mail and DATE_FORMAT(a.expiry_date,'%Y-%m-%d') >= curdate() and shown='false' and status = 'pending'")  #
    #@total1 = Share.count(:all,:conditions => "presenter_id=#{logged_in_hmm_user.id}  ")
    @total2 = Export.count(:all,:conditions => "exported_to=#{logged_in_hmm_user.id} and status='pending'")
    @sharemomentcomment = ShareMomentcomment.count(:all, :joins => "as a, share_moments as b", :conditions => "b.id=a.share_id and b.presenter_id=#{logged_in_hmm_user.id} and DATE_FORMAT(a.added_date, '%Y-%m-%d' ) = CURDATE() and a.e_approved='pending'")
    @chapcmt = Tag.count(:all, :joins=>"as a, chapter_comments as b  WHERE b.tag_id=a.id and a.uid='#{logged_in_hmm_user.id}' and DATE_FORMAT( b.d_created_on, '%Y-%m-%d' ) = CURDATE() and b.e_approval='pending'")
    @subcmt = SubChapter.count(:all, :joins=>"as a, subchap_comments as b  WHERE b.subchap_id=a.id and a.uid='#{logged_in_hmm_user.id}' and DATE_FORMAT( b.d_created_on, '%Y-%m-%d' ) = CURDATE() and b.e_approval='pending'")
    @galcmt = Galleries.count(:all, :joins=>"as a, gallery_comments AS b, sub_chapters AS c  WHERE b.gallery_id = a.id and a.subchapter_id = c.id and c.uid ='#{logged_in_hmm_user.id}' and DATE_FORMAT( b.d_created_on, '%Y-%m-%d' ) = CURDATE() and b.e_approval='pending'")
    @momentcmt = UserContent.count(:all, :joins=>"as a, photo_comments as b  WHERE b.user_content_id = a.id and a.uid='#{logged_in_hmm_user.id}' and DATE_FORMAT( b.d_add_date, '%Y-%m-%d' ) = CURDATE() and b.e_approved='pending'")
    @guestcmt = GuestComment.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and DATE_FORMAT( comment_date, '%Y-%m-%d' ) = CURDATE() and status='pending' ")
    @sharecmt = ShareComments.count(:all, :joins => "as a, shares as b", :conditions => "a.share_id=b.id and b.presenter_id='#{logged_in_hmm_user.id}' and DATE_FORMAT( a.d_add_date, '%Y-%m-%d' ) = CURDATE() and a.e_approved='pending' ")
    @msgboardcmt = MessageBoard.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and DATE_FORMAT( created_at, '%Y-%m-%d' ) = CURDATE() and status='pending' ")

    @total_comments = (@chapcmt + @subcmt + @galcmt + @momentcmt + @sharemomentcomment + @sharecmt + @msgboardcmt)
    @total_alertcount = (@chapcmt + @subcmt + @galcmt + @momentcmt + @sharemomentcomment + @sharemomentcnt + @share_journal + @total1 + @total + @total2 + @guestcmt + @sharecmt + @msgboardcmt + @contest_video + @contest_image)



    #sql.update "UPDATE exports SET shown='true' WHERE exported_from=#{logged_in_hmm_user.id}";
    #sql.update "UPDATE family_friends SET shown='true' WHERE fid=#{logged_in_hmm_user.id}";
    session[:alert] = nil
    render :layout => false

  end

  def subchap_coverflow
    contentservers = ContentPath.find(:all)
    @proxyurls = nil
    for server in contentservers
      if(@proxyurls == nil)
        @proxyurls = server['content_path']
      else
        @proxyurls = @proxyurls +','+server['content_path']
      end
    end
    @hmm_user=HmmUser.find(session[:hmm_user])
    session[:share_with_hmm]=nil
    session[:shid]=nil
    session[:share]=nil
    @chapter_belongs_to=Tag.find_by_sql("select a.*,b.* from tags as a,  hmm_users as b where a.id=#{params[:id]} and  a.uid=b.id")
    if(@chapter_belongs_to[0]['uid']!=logged_in_hmm_user.id)
      session[:friend]=@chapter_belongs_to[0]['uid']
      # for button visibility in the coverflow
      @buttonVisibility = "false";
      @total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid and a.fid=#{session[:friend]} and a.status='accepted'")
      if(@total>0)
        session[:semiprivate]="activate"
      else
        session[:semiprivate]=""
      end
    else
      # for button visibility in the coverflow
      @buttonVisibility = "true"
    end
    @tag = Tag.find(params[:id])
    if(@tag.uid!=session[:hmm_user])

      session[:friend]=@tag.uid
      @total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid and a.fid=#{session[:friend]}")

      if(@total>0)
        session[:semiprivate]="activate"

        e_access="and (e_access='public' or e_access='semiprivate')"
      else
        session[:semiprivate]=""

        e_access="and e_access='public'"
      end



    end
    #@hmm_user=HmmUser.find(session[:hmm_user])
    #items_per_page = 3
    #sort = case params['sort']
    #       when "tagname"  then "v_tagname"
    #      when "tagname_reverse"  then "v_tagname DESC"
    #  end
    #   conditions = ["v_tagname LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?
    #    @chapters = Tag.find(params[:id])
    #@total = Tag.count(:joins => 'as b , user_contents as a ', :conditions => "a.uid=#{logged_in_hmm_user.id} and  a.uid=b.uid")
    #    @moments_total = UserContent.count(:conditions => "tagid=#{params[:id]}")
    #@tags_pages, @tags = paginate :tags , :order => sort, :per_page => items_per_page, :joins => 'as b , user_contents as a ', :conditions => "a.uid=#{logged_in_hmm_user.id} and  a.uid=b.uid"
    #      @moments_pages, @moments = paginate :user_contents , :order => sort, :per_page => items_per_page, :conditions => "tagid=#{params[:id]}"
    # @tags = Tag.find_by_sql("SELECT a.*,b.* FROM user_contents as a,tags as b where a.uid='logged_in_hmm_user.id' and a.uid=b.uid")
    #        if request.xml_http_request?
    #         render :partial => "chapter_next", :layout => false
    #      end


    if(!params[:id].nil?)
      session[:tag_id]=params[:id]
    end
    @hmm_user=HmmUser.find(session[:hmm_user])

    # $subchap_id=params[:id]

    items_per_page = 9
    sort = case params['sort']
      when "tagname"  then "v_tagname"
      when "tagname_reverse"  then "v_tagname DESC"
    end
    conditions = ["v_tagname LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?
    #@total = Tag.count(:joins => 'as b , user_contents as a ', :conditions => "a.uid=#{logged_in_hmm_user.id} and  a.uid=b.uid")
    #@total = Tag.count(:conditions => "uid=#{logged_in_hmm_user.id}")
    #@tags_pages, @tags = paginate :tags , :order => sort, :per_page => items_per_page, :joins => 'as b , user_contents as a ', :conditions => "a.uid=#{logged_in_hmm_user.id} and  a.uid=b.uid"
    @sub_chapters = SubChapter.find(:all, :conditions => "tagid=#{params[:id]} #{e_access} and status='active'", :order => " id desc ")
    countcheck=SubChapter.count(:all,:conditions => "tagid=#{params[:id]} #{e_access} and status='active'")

    if params[:order]=='asc'
      params[:order]='desc'
    else
      if params[:order]=='desc'
        params[:order]='asc'
      else

        params[:order]='asc'
      end
    end
    # @tags = Tag.find_by_sql("SELECT a.*,b.* FROM user_contents as a,tags as b where a.uid='logged_in_hmm_user.id' and a.uid=b.uid")
    if request.xml_http_request?
      render :partial => "chapters_next", :layout => false
    end

    @chapter_journal = ChapterJournal.find(:all, :conditions => "tag_id=#{params[:id]}", :order=>"id DESC")
    @tagid = ChapterJournal.find(:all, :conditions => "tag_id=#{params[:id]}")
    @chap_cnt = ChapterJournal.count(:all, :conditions => "tag_id=#{params[:id]}")

    @tag = Tag.find(params[:id])
    if(@tag.uid!=session[:hmm_user])

      session[:friend]=@tag.uid


    end

    session[:chap_id]=params[:id]
    session[:chap_name]=@tag['v_tagname']


    # @sub_chap = SubChapter.find(:all, :conditions => "tagid=#{params[:id]} && uid=#{logged_in_hmm_user.id}" )
    @sub_chapid = "#{params[:id]}"
    @tag = Tag.find(params[:id])
    session[:chap_id]=@tag['id']
    session[:chap_name]=@tag['v_tagname']
    if(countcheck==1)
      gallery = Galleries.find(:all,:conditions=>"subchapter_id='#{@sub_chapters[0]['id']}'")
      redirect_to :controller => "galleries" , :action => 'gallery_coverflow', :id => @sub_chapters[0]['id']
    else
      render :layout => true
    end
  end

  def coverFlowImages
    @chapter_belongs_to=Tag.find_by_sql("select a.*,b.* from tags as a,  hmm_users as b where a.id=#{params[:id]} and  a.uid=b.id")
    if(@chapter_belongs_to[0]['uid']!=logged_in_hmm_user.id)
      session[:friend]=@chapter_belongs_to[0]['uid']
      @total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid and a.fid=#{session[:friend]}")
      if(@total>0)
        session[:semiprivate]="activate"
      else
        session[:semiprivate]=""
      end
    end
    @tag = Tag.find(params[:id])
    if(@tag.uid!=session[:hmm_user])

      session[:friend]=@tag.uid
      @total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid and a.fid=#{session[:friend]}")
      if(@total>0)
        session[:semiprivate]="activate"
        e_access="and (e_access='public' or e_access='semiprivate')"
      else
        session[:semiprivate]=""
        e_access="and e_access='public'"
      end



    end
    @subchapters = SubChapter.find(:all, :conditions=>"tagid=#{params[:id]} and status='active' #{e_access}")
    #	  @Images = Array.new
    #	  @SubChapterNames = Array.new
    #	  i = 0
    #	  for subchapter in @subchapters
    #		  @SubChapterNames[i] = subchapter
    #		  content = UserContent.find(:all, :conditions=>"sub_chapid=#{subchapter.id}")
    #		  if(content[0] == nil)
    #			  @Images[i] = '/user_content/photos/big_thumb/noimage.jpg'
    #		  elsif(content[0].e_filetype == "image")
    #			  @Images[i] = '/user_content/photos/big_thumb/'+content[0].v_filename
    #		  elsif(content[0].e_filetype == "video")
    #			  @Images[i] = '/user_content/videos/thumbnails/'+content[0].v_filename+".jpg"
    #		  elsif(content[0].e_filetype == "audio")
    #			  @Images[i] = '/user_content/audios/speaker.jpg'
    #		  end
    #		  i = i +1
    #	  end
    @chapterid = params[:id]
    render :layout => false
  end

  def remove
    @ids = params[:id]
    @idarray = @ids.split('$')
    for id in @idarray
      @tag = Tag.find(id)
      @tag.status = "inactive"
      @tag.deleted_date = Time.now
      # set the subchapters and galleries private
      subchapters  = SubChapter.find(:all, :conditions=>"tagid=#{@tag.id}")
      for subchapter in subchapters
        galleries = Galleries.find(:all, :conditions=>"subchapter_id=#{subchapter.id}")
        for gallery in galleries
          usercontents = UserContent.find(:all, :conditions=>"gallery_id=#{gallery.id}")
          for usercontent in usercontents
            usercontent.status = "inactive"
            usercontent.deleted_date = Time.now
            usercontent.save()
          end
          gallery.status = "inactive"
          gallery.deleted_date = Time.now
          gallery.save()
        end
        subchapter.status = "inactive"
        subchapter.deleted_date = Time.now
        subchapter.save()
      end

      if(@tag.save)
        @retval = "success"
      else
        @retval = "failed"
      end
    end
    render :layout => false
  end

  def restore
    @tag = Tag.find(params[:id])
    @tag.status = "active"
    @tag.deleted_date = nil
    # set the subchapters and galleries private
    subchapters  = SubChapter.find(:all, :conditions=>"tagid=#{@tag.id}")
    for subchapter in subchapters
      galleries = Galleries.find(:all, :conditions=>"subchapter_id=#{subchapter.id}")
      for gallery in galleries
        usercontents = UserContent.find(:all, :conditions=>"gallery_id=#{gallery.id}")
        for usercontent in usercontents
          usercontent.status = "active"
          usercontent.deleted_date = nil
          usercontent.save()
        end
        gallery.status = "active"
        gallery.deleted_date = nil
        gallery.save()
      end
      subchapter.status = "active"
      subchapter.deleted_date = nil
      subchapter.save()
    end

    if(@tag.save)
      @retval = "success"
    else
      @retval = "failed"
    end
    render :layout => false
  end

  def export
    tagid = Tag.find(params[:tagid])
    exportTag = Tag.new

  end



  def rejectshare
    share = Share.find(params[:id])
    emaillist=share.email_list.split(',')

    emailnewlist=''
    for emails in emaillist
      if(emails==logged_in_hmm_user.v_e_mail)
      else
        emailnewlist= emailnewlist+','+emails
      end

    end
    # redirect :action => 'coverflow'
    puts emailnewlist

    share.email_list=emailnewlist
    share.save
    flash[:notice_reg]="The \"Shared Moments\" removed successfully!"
    if(session[:sharepath]=='fnf')
      flash[:notice_reg]
      redirect_to :controller => "customers" , :action => 'list_share'
    else
      redirect_to :controller => "tags" , :action => 'coverflow'
    end
  end

  def chaptercreate
    sql = ActiveRecord::Base.connection();
    sql.execute("delete * from ischaptercreated where uid=#{logged_in_hmm_user.id}")
    sql.execute("insert into ischaptercreated('created','uid') values('1',#{logged_in_hmm_user.id})")
    sql.commit_db_transaction
    render :layout => false
  end

  def initiallizeChaptercreate
    sql = ActiveRecord::Base.connection();
    sql.execute("delete * from ischaptercreated where uid=#{logged_in_hmm_user.id}")
    sql.commit_db_transaction
    render :layout => false
  end

  def chapterrenamed
    sql = ActiveRecord::Base.connection();
    sql.execute("update ischaptercreated set created='0' where uid=#{logged_in_hmm_user.id}")
    sql.commit_db_transaction
    render :layout => false
  end

  def chapterrenamestatus
    sql = ActiveRecord::Base.connection();
    @result = sql.execute("select created from ischaptercreated where uid=#{logged_in_hmm_user.id}")
    sql.commit_db_transaction
    render :layout => false
    render :layout => false
  end

  def createNewChapter
    @tag = Tag.new()
    @tag['v_tagname'] = params[:name]
    @tag['uid'] = params[:userId]
    @tag['v_chapimage'] = "folder_img.png"
    @tag['e_access'] = "public"
    @tag['e_visible'] = "yes"

    @tag.d_updateddate = Time.now
    @tag.d_createddate = Time.now
    #@tag['']

    if @tag.save

      @sub_chapter = SubChapter.new()
      @sub_chapter['uid']=params[:userId]
      @sub_chapter['tagid']=@tag.id
      @sub_chapter['e_access'] = "public"
      @sub_chapter['sub_chapname']= "Sub Chapter"
      @sub_chapter['v_image'] = "folder_img.png"
      @sub_chapter['d_created_on'] = Time.now
      @sub_chapter['d_updated_on'] = Time.now
      @arr = Array.new()
      @arr[0] = 0
      @arr[1] = 1
      @arr[2] = 2
      if (@sub_chapter.save )
        for i in @arr
          gallery = Galleries.new

          if(i == 0)
            gallery["v_gallery_name"] = "Photo Gallery"
            gallery.e_gallery_type = "image"

            gallery.v_gallery_image = "picture.png"
          end
          if (i == 1)
            gallery["v_gallery_name"] = "Video Gallery"
            gallery.e_gallery_type = "video"
            gallery.v_gallery_image = "video.png"
          end
          if (i == 2)
            gallery["v_gallery_name"] = "Audio Gallery"
            gallery.e_gallery_type = "audio"
            gallery.v_gallery_image = "audio.png"
          end
          gallery.e_gallery_acess = "public"
          gallery.subchapter_id = @sub_chapter.id
          gallery.d_gallery_date = Time.now
          if gallery.save
            logger.info("gallery created id:#{gallery.id}")
            @arr[i] = gallery.id
          end
        end
      end


    end
    render(:layout => false)
  end

  #creating new album
  def createNewalbum
    @tag = Tag.new()
    @tag['v_tagname'] = params[:name]
    @tag['tag_type'] = params[:type]
    @tag['uid'] = params[:userId]
    if(params[:type] == 'video')
      @tag['v_chapimage'] = "videogallery.png"
    else if(params[:type] == 'photo')
      @tag['v_chapimage'] = "photo_album.png"
    else
      @tag['v_chapimage'] = "speaker.jpg";
    end
  end
  @tag['e_access'] = "public"
  @tag['e_visible'] = "yes"

  @tag.d_updateddate = Time.now
  @tag.d_createddate = Time.now
  #@tag['']

  if @tag.save

    @sub_chapter = SubChapter.new()
    @sub_chapter['uid']=params[:userId]
    @sub_chapter['tagid']=@tag.id
    @sub_chapter['e_access'] = "public"
    @sub_chapter['sub_chapname']= "Sub Chapter"
    @sub_chapter['v_image'] = "folder_img.png"
    @sub_chapter['d_created_on'] = Time.now
    @sub_chapter['d_updated_on'] = Time.now

    if (@sub_chapter.save )

      @gallery = Galleries.new

      if(params[:type] == 'photo')
        @gallery["v_gallery_name"] = "Photo Gallery"
        @gallery.e_gallery_type = "image"

        @gallery.v_gallery_image = "picture.png"

      elsif (params[:type] == 'video')
        @gallery["v_gallery_name"] = "Video Gallery"
        @gallery.e_gallery_type = "video"
        @gallery.v_gallery_image = "video.png"

      elsif (params[:type] == 'audio')
        @gallery["v_gallery_name"] = "Audio Gallery"
        @gallery.e_gallery_type = "audio"
        @gallery.v_gallery_image = "audio.png"
      end
      @gallery.e_gallery_acess = "public"
      @gallery.subchapter_id = @sub_chapter.id
      @gallery.d_gallery_date = Time.now
      if @gallery.save
        logger.info("gallery created id:#{@gallery.id}")

      end
    end
  end



  render(:layout => false)
end


def newChapter
    @tag = Tag.new()
    @tag['v_tagname'] = params[:chapname]
    @tag['uid'] = params[:userId]
    @tag['v_chapimage'] = "folder_img.png"
    @tag['e_access'] = "public"
    @tag['e_visible'] = "yes"

  @tag.d_updateddate = Time.now
  @tag.d_createddate = Time.now
  #@tag['']

  if @tag.save

    @sub_chapter = SubChapter.new()
    @sub_chapter['uid']=params[:userId]
    @sub_chapter['tagid']=@tag.id
    @sub_chapter['e_access'] = "public"
    @sub_chapter['sub_chapname']= params[:subchapname]
    @sub_chapter['v_image'] = "folder_img.png"
    @sub_chapter['d_created_on'] = Time.now
    @sub_chapter['d_updated_on'] = Time.now

    if (@sub_chapter.save )

      @gallery = Galleries.new

      if(params[:type] == 'photo')
        @gallery["v_gallery_name"] = params[:galname]
        @gallery.e_gallery_type = "image"

        @gallery.v_gallery_image = "picture.png"

      elsif (params[:type] == 'video')
        @gallery["v_gallery_name"] = params[:galname]
        @gallery.e_gallery_type = "video"
        @gallery.v_gallery_image = "video.png"

      elsif (params[:type] == 'audio')
        @gallery["v_gallery_name"] = params[:galname]
        @gallery.e_gallery_type = "audio"
        @gallery.v_gallery_image = "audio.png"
      end
      @gallery.e_gallery_acess = "public"
      @gallery.subchapter_id = @sub_chapter.id
      @gallery.d_gallery_date = Time.now
      if @gallery.save
        logger.info("gallery created id:#{@gallery.id}")

      end
    end
  end



  render(:layout => false)
end

def newSubchapter
    @sub_chapter = SubChapter.new()
    @sub_chapter['uid']=params[:userId]
    @sub_chapter['tagid']=params[:tagId]
    @sub_chapter['e_access'] = params[:access]
    @sub_chapter['sub_chapname']= params[:subchapname]
    @sub_chapter['v_image'] = "folder_img.png"
    @sub_chapter['d_created_on'] = Time.now
    @sub_chapter['d_updated_on'] = Time.now

    if (@sub_chapter.save )

      @gallery = Galleries.new

      if(params[:type] == 'photo')
        @gallery["v_gallery_name"] = params[:galname]
        @gallery.e_gallery_type = "image"

        @gallery.v_gallery_image = "picture.png"

      elsif (params[:type] == 'video')
        @gallery["v_gallery_name"] = params[:galname]
        @gallery.e_gallery_type = "video"
        @gallery.v_gallery_image = "video.png"

      elsif (params[:type] == 'audio')
        @gallery["v_gallery_name"] = params[:galname]
        @gallery.e_gallery_type = "audio"
        @gallery.v_gallery_image = "audio.png"
      end
      @gallery.e_gallery_acess = @sub_chapter.e_access
      @gallery.subchapter_id = @sub_chapter.id
      @gallery.d_gallery_date = Time.now
      if @gallery.save
        logger.info("gallery created id:#{@gallery.id}")

      end
    end
  render(:layout => false)
end

def newGallery
       @gallery = Galleries.new
      if(params[:type] == 'photo')
        @gallery["v_gallery_name"] = params[:galname]
        @gallery.e_gallery_type = "image"

        @gallery.v_gallery_image = "picture.png"

      elsif (params[:type] == 'video')
        @gallery["v_gallery_name"] = params[:galname]
        @gallery.e_gallery_type = "video"
        @gallery.v_gallery_image = "video.png"

      elsif (params[:type] == 'audio')
        @gallery["v_gallery_name"] = params[:galname]
        @gallery.e_gallery_type = "audio"
        @gallery.v_gallery_image = "audio.png"
      end
      @gallery.e_gallery_acess = params[:acess]
      @gallery.subchapter_id = params[:subchapId]
      @gallery.d_gallery_date = Time.now
      if @gallery.save
        logger.info("gallery created id:#{@gallery.id}")
      end
  render(:layout => false)
end

def facebook_share_chapter
  contentservers = ContentPath.find(:all)
  @proxyurls = nil
  for server in contentservers
    if(@proxyurls == nil)
      @proxyurls = server['content_path']
    else
      @proxyurls = @proxyurls +','+server['content_path']
    end
  end
  render(:layout => false)
end



end