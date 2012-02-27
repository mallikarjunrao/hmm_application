class SubChapterController < ApplicationController
	
	
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [  :update ],
         :redirect_to => { :action => :list }

  def list
    @sub_chapter_pages, @sub_chapters = paginate :sub_chapters, :per_page => 10
  end
  def show
    @sub_chapter = SubChapter.find(params[:id])
  end

  def new
	  @sub_chapter = SubChapter.new
      @tags = Tag.find(:all ,:conditions =>"uid=#{logged_in_hmm_user.id}")
  end
  
  def updateSubChapter
	  @subChapter = SubChapter.find(params[:id])
	  @subChapter.id = params[:id]
	  @subChapter.sub_chapname = params[:name]
	  @subChapter.v_subchapter_tags = params[:tags]
	  @subChapter.v_desc = params[:description]
	  @subChapter.save
	  render(:layout => false)
  end

  def create
    
    #@sub_chapter = SubChapter.new(params[:sub_chapter])
    #if @sub_chapter.save
    #  flash[:notice] = 'SubChapter was successfully created.'
    #  redirect_to :action => 'list'
    #else
    #  render :action => 'new'
    # end
    subChapter = SubChapter.new()
    subChapterData = Array.new
    subChapter['sub_chapname'] = "New Sub Chapter"
	
    subChapter['uid'] = params[:userId]
    subChapter['tagid'] = params[:tagid]
    subChapter['order_num'] = params[:ordernum]
    subChapter['v_image'] = "folder_img.png"
    subChapter['e_access'] = params[:access]#"semiprivate"
    subChapter['e_visible'] = "yes"
    
    subChapter['permissions'] = params[:userId]
	subChapter.d_created_on = Time.now
	subChapter.d_updated_on = Time.now
    #@tag['']
    
    subChapter['v_image'] = "folder_img.png"
	@arr = Array.new()
	@arr[0] = 0
	@arr[1] = 1
	@arr[2] = 2
	@sub_chapter = subChapter
	if (subChapter.save )
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
			gallery.subchapter_id = subChapter.id
			gallery.e_gallery_acess = params[:access]
			gallery.d_gallery_date = Time.now
			if gallery.save 
				logger.info("gallery created id:#{gallery.id}")
				@arr[i] = gallery.id
			end
		end
	end
    render(:layout => false)
  end

  def createsubchapter
    subChapter = SubChapter.new()
    if(params[:name == nil])
      subChapter['sub_chapname'] = "New Sub Chapter"
    else
      subChapter['sub_chapname'] = params[:name]
	
    subChapter['uid'] = params[:userId]
    subChapter['tagid'] = params[:tagid]
    subChapter['v_image'] = "folder_img.png"
    subChapter['e_access'] = "semiprivate"
    subChapter['e_visible'] = "yes"
    subChapter['permissions'] = params[:userId]
    subChapter.d_created_on = Time.now
    subChapter.d_updated_on = Time.now
    subChapter['v_image'] = "folder_img.png"
    if(subChapter.save)
      @subchapter = subChapter;
    end
    end
    render(:layout => false)
  end
  def edit
    @sub_chapter = SubChapter.find(params[:id])
  end

  def update
    @sub_chapter = SubChapter.find(params[:id])
    if @sub_chapter.update_attributes(params[:sub_chapter])
      flash[:notice] = 'SubChapter was successfully updated.'
      redirect_to :action => 'show', :id => @sub_chapter
    else
      render :action => 'edit'
    end
  end
  
  def renameSubChapter
    @item = SubChapter.find(params[:id])
    @item.sub_chapname = params[:name];
    @retval = @item.save
    render :layout => false
  end
 
  def renameGalleryItem
    @item = UserContent.find(params[:id])
    @item.v_tagphoto = params[:name];
    @retval = @item.save
    render :layout => false
  end
  
  def rearrange
    @ids = params[:id]
    @ordernum = params[:ordernum]
    @orderarray = @ordernum.split('$')
   @idarray = @ids.split('$')
   @i = 0
   for id in @idarray
     @subChapter = SubChapter.find(id)
     @subChapter.order_num = @orderarray[@i]
     if(@subChapter.save)
      @retval = "success"
     else
      @retval = "failed"
     end
     @i = @i + 1
   end
   
   render :layout => false
 end

  def destroy
    @subChapter = SubChapter.find(params[:id])
    #@subChapter.sub_chapname=@subChapter.sub_chapname+"-deleted"
    @subChapter.status = "inactive"
    @subChapter.save
    render :layout => false
  end
  
  def permissions
    sql = ActiveRecord::Base.connection();
    chap_arr=sql.execute("select tags.e_access from sub_chapters,tags where sub_chapters.id=#{params[:id]} and tags.id=sub_chapters.tagid") ;
    sql.commit_db_transaction;
    access = params[:permission]
    for tempaccess in  chap_arr
      chap_access = tempaccess[0];
    end
    @result = "nothing"
    case(chap_access)
    when "private":
        case(access)
        when "private":
            #change permission of subchapter
            sql = ActiveRecord::Base.connection();
            sql.execute("update sub_chapters set sub_chapters.e_access='#{params[:permission]}' where sub_chapters.id=#{params[:id]} ") ;
            sql.commit_db_transaction;
        when "semiprivate":
            #change permission of chapter and subchapter
            sql = ActiveRecord::Base.connection();
            sql.execute("update tags,sub_chapters set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}' where tags.id=sub_chapters.tagid and sub_chapters.id=#{params[:id]}") ;
            sql.commit_db_transaction; 
            @result = "chapter"              
        when "public":
            #change permission of chapter and subchapter            
            sql = ActiveRecord::Base.connection();
            sql.execute("update tags,sub_chapters set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}' where tags.id=sub_chapters.tagid and sub_chapters.id=#{params[:id]}") ;
            sql.commit_db_transaction;          
            @result = "chapter"
        end
    when "semiprivate":
        case(access)
        when "private":
            #change permission of subchapter
            sql = ActiveRecord::Base.connection();
            sql.execute("update sub_chapters set sub_chapters.e_access='#{params[:permission]}' where sub_chapters.id=#{params[:id]}");
            sql.commit_db_transaction;
        when "semiprivate":
            #change permission of subchapter
            sql = ActiveRecord::Base.connection();
            sql.execute("update sub_chapters set sub_chapters.e_access='#{params[:permission]}' where sub_chapters.id=#{params[:id]}");
            sql.commit_db_transaction;
        when "public":
            #change permission of chapter and subchapter            
            sql = ActiveRecord::Base.connection();
            sql.execute("update tags,sub_chapters set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}' where tags.id=sub_chapters.tagid and sub_chapters.id=#{params[:id]}");
            sql.commit_db_transaction;
            @result = "chapter"            
        end
    when "public":
        #change permission of subchapter
        sql = ActiveRecord::Base.connection();
        sql.execute("update sub_chapters set sub_chapters.e_access='#{params[:permission]}' where sub_chapters.id=#{params[:id]}");
        sql.commit_db_transaction;
    end  
    render :layout => false
   
  end
  
  def permissionsall
     sql = ActiveRecord::Base.connection();
     chap_arr=sql.execute("select tags.e_access from sub_chapters,tags where sub_chapters.id=#{params[:id]} and tags.id=sub_chapters.tagid") ;
     sql.commit_db_transaction;
     access = params[:permission]
     for tempaccess in  chap_arr
      chap_access = tempaccess[0];
    end
    @result = "nothing"
    case(chap_access)
    when "private":
        case(access)
        when "private":
            #change permissions of subchapter gallery and contents
            sql = ActiveRecord::Base.connection();
            #sql.execute("update sub_chapters,galleries,user_contents set sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where sub_chapters.id=#{params[:id]} and galleries.subchapter_id=sub_chapters.id and user_contents.sub_chapid=#{params[:id]}") ;
            sql.execute("update sub_chapters set sub_chapters.e_access='#{params[:permission]}' where sub_chapters.id=#{params[:id]}") ;
            sql.execute("update galleries set galleries.e_gallery_acess='#{params[:permission]}'  where  galleries.subchapter_id=#{params[:id]} ") ;
            sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where user_contents.sub_chapid=#{params[:id]}") ;
            sql.commit_db_transaction;
        when "semiprivate":
            #change permissions of chapter subchapter gallery and contents
            sql = ActiveRecord::Base.connection();
            #sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=#{params[:id]} and galleries.subchapter_id=sub_chapters.id and user_contents.sub_chapid=#{params[:id]}") ;
            sql.execute("update tags set tags.e_access='#{params[:permission]}' where tags.id in ( select sub_chapters.tagid from sub_chapters where sub_chapters.id=#{params[:id]} )") ;
            sql.execute("update sub_chapters set sub_chapters.e_access='#{params[:permission]}' where sub_chapters.id=#{params[:id]}") ;
            sql.execute("update galleries set galleries.e_gallery_acess='#{params[:permission]}' where user_contents.sub_chapid=#{params[:id]}") ;
            sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where user_contents.sub_chapid=#{params[:id]}") ;
           sql.commit_db_transaction;
            @result = "chapter"
        when "public":
            #change permissions of chapter subchapter gallery and contents            
            sql = ActiveRecord::Base.connection();
            #sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=#{params[:id]} and galleries.subchapter_id=sub_chapters.id and user_contents.sub_chapid=#{params[:id]}") ;
             sql.execute("update tags set tags.e_access='#{params[:permission]}' where tags.id in ( select sub_chapters.tagid from sub_chapters where sub_chapters.id=#{params[:id]} )") ;
            sql.execute("update sub_chapters set sub_chapters.e_access='#{params[:permission]}' where sub_chapters.id=#{params[:id]}") ;
            sql.execute("update galleries set galleries.e_gallery_acess='#{params[:permission]}' where user_contents.sub_chapid=#{params[:id]}") ;
            sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where user_contents.sub_chapid=#{params[:id]}") ;
            sql.commit_db_transaction;
            @result = "chapter"
        end
    when "semiprivate":
        case(access)
        when "private":
            #change permissions of  subchapter gallery and contents
            sql = ActiveRecord::Base.connection();
          #  sql.execute("update sub_chapters,galleries,user_contents set sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where sub_chapters.id=#{params[:id]} and galleries.subchapter_id=sub_chapters.id and user_contents.sub_chapid=#{params[:id]}") ;
            sql.execute("update sub_chapters set sub_chapters.e_access='#{params[:permission]}' where sub_chapters.id=#{params[:id]}") ;
            sql.execute("update galleries set galleries.e_gallery_acess='#{params[:permission]}'  where  galleries.subchapter_id=#{params[:id]} ") ;
            sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where user_contents.sub_chapid=#{params[:id]}") ;
            sql.commit_db_transaction;          
        when "semiprivate":
            #change permissions of  subchapter gallery and contents
            sql = ActiveRecord::Base.connection();
          #  sql.execute("update sub_chapters,galleries,user_contents set sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where sub_chapters.id=#{params[:id]} and galleries.subchapter_id=sub_chapters.id and user_contents.sub_chapid=#{params[:id]}") ;
            sql.execute("update sub_chapters set sub_chapters.e_access='#{params[:permission]}' where sub_chapters.id=#{params[:id]}") ;
            sql.execute("update galleries set galleries.e_gallery_acess='#{params[:permission]}'  where  galleries.subchapter_id=#{params[:id]} ") ;
            sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where user_contents.sub_chapid=#{params[:id]}") ;
            sql.commit_db_transaction;          
        when "public":
            #change permissions of  chapter subchapter gallery and contents            
            sql = ActiveRecord::Base.connection();
          #  sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=#{params[:id]} and galleries.subchapter_id=sub_chapters.id and user_contents.sub_chapid=#{params[:id]}") ;
             sql.execute("update tags set tags.e_access='#{params[:permission]}' where tags.id in ( select sub_chapters.tagid from sub_chapters where sub_chapters.id=#{params[:id]} )") ;
            sql.execute("update sub_chapters set sub_chapters.e_access='#{params[:permission]}' where sub_chapters.id=#{params[:id]}") ;
            sql.execute("update galleries set galleries.e_gallery_acess='#{params[:permission]}' where user_contents.sub_chapid=#{params[:id]}") ;
            sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where user_contents.sub_chapid=#{params[:id]}") ;
            sql.commit_db_transaction;          
            @result = "chapter"
        end        
    when "public":
         #change permissions of subchapter gallery and contents        
         sql = ActiveRecord::Base.connection();
        # sql.execute("update sub_chapters,galleries,user_contents set sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where sub_chapters.id=#{params[:id]} and galleries.subchapter_id=sub_chapters.id and user_contents.sub_chapid=#{params[:id]}") ;
          sql.execute("update sub_chapters set sub_chapters.e_access='#{params[:permission]}' where sub_chapters.id=#{params[:id]}") ;
            sql.execute("update galleries set galleries.e_gallery_acess='#{params[:permission]}'  where  galleries.subchapter_id=#{params[:id]} ") ;
            sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where user_contents.sub_chapid=#{params[:id]}") ;          
         sql.commit_db_transaction;          
    end
    
   render :layout => false
    
  end
  
   def hide
   @sub_chapter = SubChapter.find(params[:id])
   @sub_chapter.e_access = "private"
   
   galleries = Galleries.find(:all, :conditions=>"subchapter_id=#{@sub_chapter.id}")
   for gallery in galleries
	   usercontents = UserContent.find(:all, :conditions=>"gallery_id=#{gallery.id}")
	   for usercontent in usercontents
		   usercontent.e_access = "private"
		   usercontent.save()
	   end
	   gallery.e_gallery_acess = "private"
	   gallery.save()
   end
   
   
   if(@sub_chapter.save)
    @retval = "success"
  else
    @retval = "failed"
  end
  render :layout => false
 end
 
  def unhide
	  @sub_chapter = SubChapter.find(params[:id])
	  galleries = Galleries.find(:all, :conditions=>"subchapter_id=#{@sub_chapter.id}")
	  for gallery in galleries
		  usercontents = UserContent.find(:all, :conditions=>"gallery_id=#{gallery.id}")
		  for usercontent in usercontents
			  usercontent.e_access = "public"
			  usercontent.save()
		  end
		  gallery.e_gallery_acess = "public"
		  gallery.save()
	  end
	  
	  @sub_chapter.e_access = "public"
	  if(@sub_chapter.save)
		  @retval = "success"
	  else
		  @retval = "failed"
	  end
	  render :layout => false
  end


  def setThumbnail
	  subchapter = SubChapter.find(:all, :conditions=>"id=#{params[:id]}")
	  content = UserContent.find(:all, :conditions =>"id=#{params[:itemId]}")
	  if(subchapter[0]['v_chapimage'] != "folder_img.png")
		  begin
			  logger.info("Deleting old icon file #{subchapter[0]['v_chapimage']}")
			  File.delete("#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/#{subchapter[0]['v_chapimage']}")
			  
		  rescue
			  logger.info("Error deleting file")
		  end
		  
	  end
	  chars = ["A".."Z","a".."z","0".."9"].collect { |r| r.to_a }.join 
	  newfilename = (1..8).collect { chars[rand(chars.size)] }.pack("C*")
	  
	  # read the newly uploaded image to create the thumb nails
	  if(content[0] != nil)
		  if(content[0].e_filetype == "image")
			  img1 = Magick::Image.read("#{RAILS_ROOT}/public/user_content/photos/#{content[0].v_filename}").first
		  elsif(content[0].e_filetype == "audio")
			  img1 = Magick::Image.read("#{RAILS_ROOT}/public/user_content/audios/speaker.jpg").first
		  elsif(content[0].e_filetype == "video")
			  img1 = Magick::Image.read("#{RAILS_ROOT}/public/user_content/videos/thumbnails/#{content[0].v_filename}.jpg").first
		  end
	  end
	  img2 = resize(img1, 72, 72,"#{RAILS_ROOT}/public/user_content/photos/big_thumb/#{content[0].v_filename}")
	  #img = Magick::Image.read("#{RAILS_ROOT}/public/user_content/photos/cropthumb/#{content[0].v_filename}").first
	  folderImage = Magick::Image.read("#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/folder_img.png").first
#	  if(img.rows < img.columns)
#		  croppedImage = img.crop(0,0,img.rows, img.rows)
#	  else
#		  croppedImage = img.crop(0,0,img.columns, img.columns)
#	  end
#	  scaledImage = croppedImage.scale(72,72)
	  finalImage = folderImage.composite(img2, 4, 9, CopyCompositeOp)
	  imageName = newfilename
	  #imageName.slice!(-4..-1)
  	  @newsubchapterIcon = "#{newfilename}.png"
	  finalImage.write("#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/#{@newsubchapterIcon}")
	  img1.write("#{RAILS_ROOT}/public/user_content/photos/flex_icon/#{newfilename}.jpg")
	  subchapter[0]['v_image'] = @newsubchapterIcon 
	  subchapter[0].save
     
   big_thumb = resizeWithoutBorder(img1,320,240,"nil")
   big_thumb.write("#{RAILS_ROOT}/public/user_content/photos/flex_icon/#{newfilename}.jpg")

    
 
	  render :layout => false
	  
  end
  
  def coverFlowImages
	      @subchaapter_belongs_to=SubChapter.find_by_sql("select a.*,b.* from sub_chapters as a,  hmm_users as b where a.id=#{params[:id]} and  a.uid=b.id")
    
    if(@subchaapter_belongs_to[0]['uid']==logged_in_hmm_user.id)
		e_access = "and (e_gallery_acess='public' or e_gallery_acess='semiprivate' or e_gallery_acess='private')"
    else
      session[:friend]=@subchaapter_belongs_to[0]['uid']
       @total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid and a.fid=#{session[:friend]} and a.status='accepted'")
       puts @total 
       if(@total>0)
         session[:semiprivate]="activate"
         e_access="and (e_gallery_acess='public' or e_gallery_acess='semiprivate')"
         
       else
         session[:semiprivate]=""
         e_access="and e_gallery_acess='public'"
         puts e_access
      end  
    end
      
#      
#      if(session[:friend]!='')
#			
#			
#            e_access="and e_gallery_acess='public'"
#			
#            
#		end
		@subchapterid = params[:id]
	  @galleries = Galleries.find(:all, :conditions=>"subchapter_id=#{params[:id]} and status='active' #{e_access}", :order=> 'order_num asc')
	  render :layout => false
	end
 
  def remove
   @ids = params[:id]
   @idarray = @ids.split('$')
   for id in @idarray
     @sub_chapter = SubChapter.find(id)
     @sub_chapter.status = "inactive"
     @sub_chapter.deleted_date = Time.now
     galleries = Galleries.find(:all, :conditions=>"subchapter_id=#{@sub_chapter.id}")
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
     if(@sub_chapter.save)
      @retval = "success"
     else
      @retval = "failed"
     end
   end
   render :layout => false
  end
 
  def restore
   @sub_chapter = SubChapter.find(params[:id])
   @sub_chapter.status = "inactive"
   @sub_chapter.deleted_date = nil
   galleries = Galleries.find(:all, :conditions=>"subchapter_id=#{@sub_chapter.id}")
   for gallery in galleries
      usercontents = UserContent.find(:all, :conditions=>"gallery_id=#{gallery.id}")
       for usercontent in usercontents
         usercontent.status = "inactive"
         usercontent.deleted_date = nil
         usercontent.save()
    end
    gallery.status = "inactive"
    gallery.deleted_date = DateTime.now
    gallery.save()
    if(@sub_chapter.save)
     @retval = "success"
    else
     @retval = "failed"
    end
   end
   render :layout => false
 end
end
