class GalleriesController < ApplicationController
	layout "standard"
  helper :user_account
  include UserAccountHelper

  
  
   before_filter :authenticate, :only => [ :gallery_coverflow, :gallery_fisheye, :edit, :deleteSelection, :deleteSelection1, :update,:manage_moments]
  

#   protected
    def authenticate
      unless session[:hmm_user]
           flash[:notice] = 'Please Login to Access your Account'
           redirect_to :controller => "user_account" , :action => 'login'
        
        return false
      end
    end
  
  def index
    
  end

  # GET /galleries/1
  # GET /galleries/1.xml
#  def show
#    @galleries = Galleries.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.rhtml
#      format.xml  { render :xml => @galleries.to_xml }
#    end
#  end

  # GET /galleries/new
  def new
    @galleries = Galleries.new
  end

  # GET /galleries/1;edit
  def edit
    @galleries = Galleries.find(params[:id])
  end

  # POST /galleries
  # POST /galleries.xml
 # def create
    
   # format.xml  { head :created, :location => galleries_url(@galleries) }
#    respond_to do |format|
#      if 
#        flash[:notice] = 'Galleries was successfully created.'
#        format.html { redirect_to galleries_url(@galleries) }
#        format.xml  { head :created, :location => galleries_url(@galleries) }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @galleries.errors.to_xml }
#      end
#    end
#  render :layout => false
#  end

  # PUT /galleries/1
  # PUT /galleries/1.xml
  def update
    @galleries = Galleries.find(params[:id])

    respond_to do |format|
      if @galleries.update_attributes(params[:galleries])
        flash[:notice] = 'Galleries was successfully updated.'
        format.html { redirect_to galleries_url(@galleries) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @galleries.errors.to_xml }
      end
    end
  end
  
  def createGallery
    gallery = Galleries.new()
	gallery.d_gallery_date = Time.now
	
    gallery.subchapter_id = params[:subchapter_id]
    gallery.permissions = params[:userId]
    gallery.v_gallery_name = params[:name]
    gallery.order_num = params[:ordernum]
    gallery.e_gallery_type = params[:type]
    gallery.e_gallery_acess = params[:access]
    if(gallery.e_gallery_type == "image")
      gallery.v_gallery_image = "picture.png"
    end
    if(gallery.e_gallery_type == "video")
      gallery.v_gallery_image = "video.png"
    end
    if(gallery.e_gallery_type == "audio")
      gallery.v_gallery_image = "audio.png"
    end  
    gallery.d_gallery_date = Time.now
    
    gallery.save 
    @result = gallery.id
	render :layout => false
  end
  
  def destroyGallery
    @galleries = Galleries.find(params[:id])
    #@galleries.v_gallery_name=@galleries.v_gallery_name+"-deleted"
    @galleries.status = "inactive"
    
    if(@galleries.save)
      @results = "success"
    else
      @results = "failed"
    end
  end
  
  # DELETE /galleries/1
  # DELETE /galleries/1.xml
  def destroy
    @galleries = Galleries.find(params[:id])
    @galleries.status = "inactive"
    
    if(@galleries.save)
      @results = "success"
    else
      @results = "failed"
    end
  end
  
  def permissions
	  gallery = Galleries.find(params[:id])
	  if(gallery != nil)
		  gallery.e_gallery_acess = params[:permission]
		  @result = gallery.save
	  end
          sql = ActiveRecord::Base.connection();
          @temp_access_arr = sql.execute("select tags.e_access,sub_chapters.e_access from tags,sub_chapters,galleries where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]}") ;
          sql.commit_db_transaction;
          i =0
          for access in @temp_access_arr
            case(i)
            when 0:
                @access_arr = access;
            end
            i = i+ 1;
          end
          chap_access = @access_arr[0];
          sub_access = @access_arr[1];
          access = params[:permission]
    @result = "nothing"
    case(chap_access)
    when "private":
        case(sub_access)
        when "private":
            case(access)
            when "semiprivate":
                #change permission of chapter subchapter gallery and contents
              sql = ActiveRecord::Base.connection();
              sql.execute("update tags,sub_chapters,galleries set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}' where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]}") ;
              sql.commit_db_transaction;
              @result = "chapter$subchapter"
            when "public":
                #change permission of chapter subchapter gallery and contents                
                sql = ActiveRecord::Base.connection();
                sql.execute("update tags,sub_chapters,galleries set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}' where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]}") ;
                sql.commit_db_transaction;
                @result = "chapter$subchapter"
            end
        when "semiprivate":
            case(access)
            when "semiprivate":
                #change permission of chapter gall and contents
                sql = ActiveRecord::Base.connection();
              sql.execute("update tags,sub_chapters,galleries set tags.e_access='#{params[:permission]}' where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]}") ;
              sql.commit_db_transaction;
              @result = "chapter"
            when "public":
                #change permission of chapter subchapter gallery and contents                
              sql = ActiveRecord::Base.connection();
              sql.execute("update tags,sub_chapters,galleries set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}' where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]}") ;
              sql.commit_db_transaction;
              @result = "chapter$subchapter"
            end
        when "public":
            case(access)
            when "semiprivate":
                #change permission of chapter gallery and contents
                sql = ActiveRecord::Base.connection();
                sql.execute("update tags,sub_chapters,galleries set tags.e_access='#{params[:permission]}' where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]}") ;
                sql.commit_db_transaction;
                @result = "chapter"
            when "public":
                #change permission of chapter gallery and contents                
                sql = ActiveRecord::Base.connection();
                sql.execute("update tags,sub_chapters,galleries set tags.e_access='#{params[:permission]}' where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]}") ;
                sql.commit_db_transaction;
                @result = "chapter"
            end            
        end
    when "semiprivate":
        case(sub_access)
        when "private":
            case(access)
            when "semiprivate":
                #change permission of subchapter gallery and contents
                sql = ActiveRecord::Base.connection();
                sql.execute("update sub_chapters,galleries set sub_chapters.e_access='#{params[:permission]}' where sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]}") ;
                sql.commit_db_transaction;
                @result = "subchapter"
            when "public":
                #change pemission of chapter subchapter gallery and contents                
                sql = ActiveRecord::Base.connection();
                sql.execute("update tags,sub_chapters,galleries set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}' where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]}") ;
                sql.commit_db_transaction;
                @result = "chapter$subchapter"
            end
        when "semiprivate":
            case(access)
            when "public":
                #change permissions of chapter subchapter gallery and contents                 
                sql = ActiveRecord::Base.connection();
                sql.execute("update tags,sub_chapters,galleries set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}' where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]}") ;
                sql.commit_db_transaction;
                @result = "chapter$subchapter"
            end            
        when "public":
            case(access)
            when "public":
                #change permissions of chapter gallery and contents                
                sql = ActiveRecord::Base.connection();
                sql.execute("update tags,sub_chapters,galleries set tags.e_access='#{params[:permission]}' where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]}") ;
                sql.commit_db_transaction;
                @result = "chapter"
            end            
        end
    when "public"
        case(sub_access)
        when "private":
            case(access)
            when "semiprivate":
                #change permissions of subchapter gallery and contents
                sql = ActiveRecord::Base.connection();
                sql.execute("update sub_chapters,galleries set sub_chapters.e_access='#{params[:permission]}' where sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]}") ;
                sql.commit_db_transaction;
                @result = "subchapter"
            when "public":
                #change permissions of subchapter gallery and contents                
                sql = ActiveRecord::Base.connection();
                sql.execute("update sub_chapters,galleries set sub_chapters.e_access='#{params[:permission]}' where sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]}") ;
                sql.commit_db_transaction;
                @result = "subchapter"
            end
        when "semiprivate":
             case(access)
             when "public":
                 #change permissions of subchapter gallery and contents
                 sql = ActiveRecord::Base.connection();
                 sql.execute("update sub_chapters,galleries set sub_chapters.e_access='#{params[:permission]}' where sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]}") ;
                 sql.commit_db_transaction;
                 @result = "subchapter"
             end            
        end      
    end
    
	  render :layout => false
  end
  
  def permissionsall
    sql = ActiveRecord::Base.connection();
    @temp_access_arr = sql.execute("select tags.e_access,sub_chapters.e_access from tags,sub_chapters,galleries where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]}") ;
    sql.commit_db_transaction;
    i =0
    for access in @temp_access_arr
       case(i)
         when 0:
           @access_arr = access;
       end
         i = i+ 1;
    end
    chap_access = @access_arr[0];
    sub_access = @access_arr[1];
    access = params[:permission]
    @result = "nothing"
    case(chap_access)
    when "private":
        case(sub_access)
        when "private":
            case(access)
            when "private":
                #change permission of gallery and contents only
                sql = ActiveRecord::Base.connection();
                sql.execute("update galleries,user_contents set galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction;
            when "semiprivate":
                #change permission of chapter subchapter gallery and contents
                sql = ActiveRecord::Base.connection();
                sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction;
                @result = "chapter$subchapter"
            when "public":
                #change permission of chapter subchapter gallery and contents                
                sql = ActiveRecord::Base.connection();
                sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction;   
                @result = "chapter$subchapter"
            end
        when "semiprivate":
            case(access)
            when "private":
                #change permission of gallery and contents only
                sql = ActiveRecord::Base.connection();
                sql.execute("update galleries,user_contents set galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction;
            when "semiprivate":
                #change permission of chapter gall and contents
                sql = ActiveRecord::Base.connection();
                sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction;    
                @result = "chapter"                
            when "public":
                #change permission of chapter subchapter gallery and contents                
                sql = ActiveRecord::Base.connection();
                sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction;              
                @result = "chapter$subchapter"
            end
        when "public":
            case(access)
            when "private":
                #change permission of gallery and contents only
                sql = ActiveRecord::Base.connection();
                sql.execute("update galleries,user_contents set galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction; 
            when "semiprivate":
                #change permission of chapter gallery and contents
                sql = ActiveRecord::Base.connection();
                sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction;   
                @result = "chapter"                
            when "public":
                #change permission of chapter gallery and contents                
                sql = ActiveRecord::Base.connection();
                sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction;              
                @result = "chapter"
            end            
        end
    when "semiprivate":
        case(sub_access)
        when "private":
            case(access)
            when "private":
                #change permissions of gallery and contents only
                sql = ActiveRecord::Base.connection();
                sql.execute("update galleries,user_contents set galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction; 
            when "semiprivate":
                #change permission of subchapter gallery and contents
                sql = ActiveRecord::Base.connection();
                sql.execute("update sub_chapters,galleries,user_contents set sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction;  
                @result = "subchapter"
            when "public":
                #change pemission of chapter subchapter gallery and contents       
                sql = ActiveRecord::Base.connection();
                sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction; 
                @result = "chapter$subchapter"
            end
        when "semiprivate":
            case(access)
            when "private":
                #change permissions of gallery and contents only
                sql = ActiveRecord::Base.connection();
                sql.execute("update galleries,user_contents set galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction; 
            when "semiprivate":
                #change permissions of gallery and contents anly
                sql = ActiveRecord::Base.connection();
                sql.execute("update galleries,user_contents set galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction; 
            when "public":
                #change permissions of chapter subchapter gallery and contents                 
                sql = ActiveRecord::Base.connection();
                sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction; 
                @result = "chapter$subchapter"
            end            
        when "public":
            case(access)
            when "private":
                #change permissions of gallery and contents only
                sql = ActiveRecord::Base.connection();
                sql.execute("update galleries,user_contents set galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction; 
            when "semiprivate":
                #change perrmissions of gallery and contents only
                sql = ActiveRecord::Base.connection();
                sql.execute("update galleries,user_contents set galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction; 
            when "public":
                #change permissions of chapter gallery and contents                
                sql = ActiveRecord::Base.connection();
                sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction;   
                @result = "chapter"                
            end            
        end
    when "public"
        case(sub_access)
        when "private":
            case(access)
            when "private":
                #change permissions of gallery and contents only
                sql = ActiveRecord::Base.connection();
                sql.execute("update galleries,user_contents set galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction; 
            when "semiprivate":
                #change permissions of subchapter gallery and contents
                sql = ActiveRecord::Base.connection();
                sql.execute("update sub_chapters,galleries,user_contents set sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction;  
                @result = "subchapter"
            when "public":
                #change permissions of subchapter gallery and contents                
                sql = ActiveRecord::Base.connection();
                sql.execute("update sub_chapters,galleries,user_contents set sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction;  
                @result = "subchapter"
            end
        when "semiprivate":
             case(access)
             when "private":
                 #change permissions of gallery and contents
                sql = ActiveRecord::Base.connection();
                sql.execute("update galleries,user_contents set galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction; 
             when "semiprivate":
                 #change permissions of gallery and contents
                 sql = ActiveRecord::Base.connection();
                sql.execute("update galleries,user_contents set galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction; 
             when "public":
                 #change permissions of subchapter gallery and contents
                 sql = ActiveRecord::Base.connection();
                sql.execute("update sub_chapters,galleries,user_contents set sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where sub_chapters.id=galleries.subchapter_id and galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
                sql.commit_db_transaction;  
                @result = "subchapter"
             end            
        when "public":
             #change permissions of gallery and contents only            
             sql = ActiveRecord::Base.connection();
             sql.execute("update galleries,user_contents set galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where galleries.id=#{params[:id]} and user_contents.gallery_id=#{params[:id]}") ;
             sql.commit_db_transaction; 
        end      
    end
    render :layout => false
  end
  
  
  def hide
   @galleries = Galleries.find(params[:id])
   @galleries.e_gallery_acess = "private"
   if(@galleries.save)
    @retval = "success"
  else
    @retval = "failed"
  end
  render :layout => false
 end
 
  def unhide
   @galleries = Galleries.find(params[:id])
   @galleries.e_gallery_acess = "public"
   if(@galleries.save)
      @retval = "success"
    else
      @retval = "failed"
    end
    render :layout => false
  end
  
  def renameGallery
	  @item = Galleries.find(params[:id])
	  @item.v_gallery_name = params[:name];
	  @retval = @item.save
	  render :layout => false
  end
  
  def updateGallery
	  @gallery = Galleries.find(params[:id])
	  @gallery.id = params[:id]
	  @gallery.v_gallery_name = params[:name]
	  @gallery.v_gallery_tags = params[:tags]
	  @gallery.v_desc = params[:description]
	  @gallery.save
	  render(:layout => false)
  end
  
  def rearrange
    @ids = params[:id]
    @ordernum = params[:ordernum]
    @orderarray = @ordernum.split('$')
   @idarray = @ids.split('$')
   @i = 0
   for id in @idarray
     @gallery = Galleries.find(id)
     @gallery.order_num = @orderarray[@i]
     if(@gallery.save)
      @retval = "success"
     else
      @retval = "failed"
     end
     @i = @i + 1
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
		  img.scale(w, h)
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
		  img.scale(w, h)
		  
		  finalImage = finalImage.composite(img,x,y,CopyCompositeOp) 
		  
	  end
	  return finalImage
	  #finalImage.write("output.jpg")
	  #finalImage.write("#{path}")
  end
  
  
  def setThumbnail
	  gallery = Galleries.find(:all, :conditions=>"id=#{params[:id]}")
	   chars = ["A".."Z","a".."z","0".."9"].collect { |r| r.to_a }.join 
	   newfilename = (1..8).collect { chars[rand(chars.size)] }.pack("C*")
	  content = UserContent.find(params[:itemId])
	  # read the newly uploaded image to create the thumb nails
	  if(content != nil)
		  if(content.e_filetype == "image")
			  if(gallery[0]['v_chapimage'] != "picture.png")
				  begin
					  logger.info("Deleting old icon file #{gallery[0]['v_chapimage']}")
					  File.delete("#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/#{gallery[0]['v_chapimage']}")
					  File.delete("#{RAILS_ROOT}/public/user_content/photos/flex_icon/#{gallery[0]['v_chapimage']}")
				  rescue
					  logger.info("Error deleting file")
				  end
				  
			  end
			  img1 = Magick::Image.read("#{RAILS_ROOT}/public/user_content/photos/big_thumb/#{content.v_filename}").first
			  folderImage = Magick::Image.read("#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/gallery.png").first
			  #croppedImage = resize(img1, 72, 72,"#{RAILS_ROOT}/public/user_content/photos/big_thumb/#{content.v_filename}")
			  #img = Magick::Image.read("#{RAILS_ROOT}/public/user_content/photos/cropthumb/#{content[0].v_filename}").first
			  
			  scaledImage = img1.scale(58,61)
			  finalImage = folderImage.composite(scaledImage, 14, 16, CopyCompositeOp)
			  @galleryIcon= "#{params[:id]}_#{newfilename}"
			  #@galleryIcon.slice!(-4..-1)
			  finalImage.write("#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/#{@galleryIcon}.png")
			  gallery[0]['v_gallery_image'] = @galleryIcon+".png" 
			  gallery[0].save
			  img2 = Magick::Image.read("#{RAILS_ROOT}/public/user_content/photos/#{content.v_filename}").first
			  img3 = resizeWithoutBorder(img2, 320, 240,"#{RAILS_ROOT}/public/user_content/photos/flex_icon/#{content.v_filename}")
			  img3.write("#{RAILS_ROOT}/public/user_content/photos/flex_icon/#{@galleryIcon}.jpg")
			  @galleryIcon = "#{@galleryIcon}.png"
		  elsif(content.e_filetype == "audio")
			  img1 = Magick::Image.read("#{RAILS_ROOT}/public/user_content/audios/speaker.jpg").first
			  folderImage = Magick::Image.read("#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/gallery.png").first
		  elsif(content.e_filetype == "video" || content.e_filetype == "swf")
			  if(gallery[0]['v_chapimage'] != "video.png")
				  begin
					  logger.info("Deleting old icon file #{gallery[0]['v_gallery_image']}")
					  File.delete("#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/#{gallery[0]['v_gallery_image']}.png")
					  filename = "#{gallery[0]['v_gallery_image']}"
					  filename.slice!(-4..-1)
					  File.delete("#{RAILS_ROOT}/public/user_content/photos/flex_icon/#{filename}.jpg")
				  rescue
					  logger.info("Error deleting file")
				  end
				  
			  end
			  img1 = Magick::Image.read("#{RAILS_ROOT}/public/user_content/videos/thumbnails/#{content.v_filename}.jpg").first
			  folderImage = Magick::Image.read("#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/videogallery1.png").first
			  croppedImage = resizeWithoutBorder(img1, 68, 36,"#{RAILS_ROOT}/public/user_content/photos/big_thumb/#{content.v_filename}")
			  #img = Magick::Image.read("#{RAILS_ROOT}/public/user_content/photos/cropthumb/#{content[0].v_filename}").first
			  
			  
			  #scaledImage = croppedImage.rotate(-15)
			  scaledImage = croppedImage.scale(61,38)
			  #scaledImage = scaledImage.matte_replace(0,0)
			  finalImage = folderImage.composite(scaledImage, 10, 35, CopyCompositeOp)
			  @galleryIcon= "#{params[:id]}_#{newfilename}"
			  #@galleryIcon.slice!(-4..-1)
			  finalImage.write("#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/#{@galleryIcon}.png")
			  gallery[0]['v_gallery_image'] = "#{@galleryIcon}.png" 
			  gallery[0].save
			  img1.write("#{RAILS_ROOT}/public/user_content/photos/flex_icon/#{@galleryIcon}.jpg")
			  @galleryIcon = "#{@galleryIcon}.png"
			  #img3 = resize(img2, 192, 192,"#{RAILS_ROOT}/public/user_content/photos/flex_icon/#{content[0].v_filename}")
			  #img3.write("#{RAILS_ROOT}/public/user_content/photos/flex_icon/#{@galleryIcon}")
		  end
	  end
	  
  
	  render :layout => false	
  end
  
  def gallery_coverflow
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
	    @subchaapter_belongs_to=SubChapter.find_by_sql("select a.*,b.* from sub_chapters as a,  hmm_users as b where a.id=#{params[:id]} and  a.uid=b.id")
    
    if(@subchaapter_belongs_to[0]['uid']==logged_in_hmm_user.id)
      # for button visibility in the coverflow
     @buttonVisibility = "true"
    else
      session[:friend]=@subchaapter_belongs_to[0]['uid']
       @total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid and a.fid=#{session[:friend]} and a.status='accepted'")
       puts @total 
       if(@total>0)
         session[:semiprivate]="activate"
         e_access="and (e_gallery_acess='private' or e_gallery_acess='semiprivate')"
         
       else
         session[:semiprivate]=""
         e_access="and e_gallery_acess='public'"
         puts e_access
       end
      @buttonVisibility = "false";
    end
     
      
     
     session[:sub_id]=params[:id]
    @hmm_user=HmmUser.find(session[:hmm_user])
    items_per_page = 9
    $galery_id=params[:id]
    if(params['sort'] != nil)
    sort = case params['sort']
              when "tagname"  then "v_tagname"
              when "tagname_reverse"  then "v_tagname DESC"
          end
    else
      
    end       
           if(!params['v_tagname.x'].nil?)
              @sort='d_gallery_date'
            end
            
            if(!params['v_tagname.x'].nil?)
              @sort='v_gallery_name'
             
            end
            if (@sort.nil?)
              @sort='d_gallery_date'
            end
            
            @order=params[:order]
            if(@order=='')
              @order='asc'
            end
            
           conditions = ["v_tagname LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?
           #@total = Tag.count(:joins => 'as b , user_contents as a ', :conditions => "a.uid=#{logged_in_hmm_user.id} and  a.uid=b.uid")
           #@total = Tag.count(:conditions => "uid=#{logged_in_hmm_user.id}")
           #@tags_pages, @tags = paginate :tags , :order => sort, :per_page => items_per_page, :joins => 'as b , user_contents as a ', :conditions => "a.uid=#{logged_in_hmm_user.id} and  a.uid=b.uid"
           @sub_chapters_gallerie = Galleries.find(:all, :conditions => "subchapter_id  =#{params[:id]} and status='active' #{e_access}" ,:order => " #{@sort.to_s} #{@order.to_s} ") #:order => sort, :per_page => items_per_page, 
            
              countcheck=Galleries.count(:all, :conditions => "subchapter_id=#{params[:id]} and status='active'    #{e_access}")
      for subchap in @sub_chapters_gallerie
      @sub_chapter_count=UserContent.count(:all, :conditions => " gallery_id=#{subchap.id} and status='active'") 
      if(@sub_chapter_count<=0)
        countcheck=countcheck-1
      else
        actualid=subchap.id
      
    end 
   end
            
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
              render :partial => "sub_chapter_gallery", :layout => false
          end
          @sub_chapter_journal = SubChapJournal.find(:all, :conditions => "sub_chap_id=#{params[:id]}", :order=>"id DESC")
         # @tagid = ChapterJournal.find(:all, :conditions => "tag_id=#{params[:id]}")
       @sub_chapter = SubChapter.find(params[:id])
         session[:subchap_id]=params[:id]
         session[:sub_chapname]=@sub_chapter['sub_chapname']
         params[:id]=@sub_chapter['tagid']
        @tag = Tag.find(params[:id])
          session[:chap_id]=params[:id]
          session[:chap_name]=@tag['v_tagname']
       params[:id]=$galery_id
        @subchap_cnt = SubChapJournal.count(:all, :conditions => "sub_chap_id=#{params[:id]}")
    
    
    
    @gallery = Galleries.find(:all, :conditions => "subchapter_id=#{params[:id]}")
	  
    if(countcheck==1)
             redirect_to :controller => "galleries" , :action => 'gallery_fisheye', :id =>actualid
         else 
    render :layout => true
    end
  end
  
  def showGallery
	  
	  @gallery_belongs_to=Galleries.find_by_sql("select a.*,b.* from galleries as a, sub_chapters as b, hmm_users as c where a.id=#{params[:id]} and a.subchapter_id=b.id and b.uid=c.id")
	  @gallery_belongs_to[0]['uid']
	  if(@gallery_belongs_to[0]['uid']!="#{logged_in_hmm_user.id}")
		  session[:friend]=@gallery_belongs_to[0]['uid']
		  @total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid and a.fid=#{session[:friend]} and a.status='accepted'",:order =>'a.id desc')
		  if(@total>0)
			  session[:semiprivate]="activate"
		  else
			  session[:semiprivate]=""
		  end  
	  end
	  
	  
	  if(session[:friend]!='')
		  e_access="and e_access='public'"
		  if(session[:semiprivate]=="activate")
			  e_access=" and (e_access='public' or e_access='semiprivate')"
		  end
	  end
	  
	  
	  
	  @contents = UserContent.find(:all, :conditions => "gallery_id=#{params[:id]} and status='active' #{e_access}",:order =>'order_num ASC')
	  render :layout => false
  end
  
  def showAudioGallery
	  @gallery_belongs_to=Galleries.find_by_sql("select a.*,b.* from galleries as a, sub_chapters as b, hmm_users as c where a.id=#{params[:id]} and a.subchapter_id=b.id and b.uid=c.id")
	  @gallery_belongs_to[0]['uid']
	  if(@gallery_belongs_to[0]['uid']!="#{logged_in_hmm_user.id}")
		  session[:friend]=@gallery_belongs_to[0]['uid']
		  @total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid and a.fid=#{session[:friend]} and a.status='accepted'",:order =>'a.id desc')
		  if(@total>0)
			  session[:semiprivate]="activate"
		  else
			  session[:semiprivate]=""
		  end  
	  end
	  
	  
	  if(session[:friend]!='')
		  e_access="and e_access='public'"
		  if(session[:semiprivate]=="activate")
			  e_access=" and (e_access='public' or e_access='semiprivate')"
		  end
	  end
	  
	  
	  
	  @contents = UserContent.find(:all, :conditions => "gallery_id=#{params[:id]} and status='active' #{e_access}",:order =>'order_num asc')
	  render :layout => false
  end
  
  def gallery_fisheye
    @get_content_url=ContentPath.find(:all, :conditions => "status='active'")
    @serverurl=@get_content_url[0]['content_path']
    @servername=@get_content_url[0]['proxyname']
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
#     @gallery_belongs_to=Galleries.find_by_sql("select a.*,b.* from galleries as a, sub_chapters as b, hmm_users as c where a.id=#{params[:id]} and a.subchapter_id=b.id and b.uid=c.id")
#     puts @gallery_belongs_to[0]['uid']
#     if(@gallery_belongs_to[0]['uid']==logged_in_hmm_user.id)
#      # for button visibility in the coverflow
#     @buttonVisibility = "true"
#     else
#      session[:friend]=@gallery_belongs_to[0]['uid']
#       @total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid and a.fid=#{session[:friend]}")
#       if(@total>0)
#         session[:semiprivate]="activate"
#       else
#         session[:semiprivate]=""
#      end 
#       @buttonVisibility = "false";
#     end
     
     if(session[:friend]==nil ||  session[:friend]=='')
      @buttonVisibility = "true";
     else
       @buttonVisibility = "false";
    end
    
     session[:galery_id]=params[:id]
     $gal=params[:id]
      items_per_page = 9
      $chapter_id=params[:id]
      @hmm_user=HmmUser.find(session[:hmm_user])
      #@user_contents = UserContent.find(:all,:conditions=>"tagid=#{params[:id]}")
       if(!params['v_tagname.x'].nil?)
              @sort='d_createddate'
            end
            
            if(!params['v_tagname.x'].nil?)
              @sort='v_tagphoto'
             
            end
            if (@sort.nil?)
              @sort='d_createddate'
            end
            
            @order=params[:order]
            if(@order=='')
              @order='asc'
            end
            
      
      @user_contents_pages, @user_content = UserContent.paginate :conditions=>"gallery_id=#{params[:id]} && uid=#{logged_in_hmm_user.id}", :order => " #{@sort.to_s} #{@order.to_s} ",:page => params[:page]
            if params[:order]=='asc'
               params[:order]='desc'
            else
             if params[:order]=='desc'
                params[:order]='asc' 
            else
                
                params[:order]='asc'
            end
            end
      if request.xml_http_request?
              render :partial => "chapgallery_list", :layout => false
      end
      @gallery_journal = GalleryJournal.find(:all, :conditions => "galerry_id=#{params[:id]}", :order=>"id DESC")
      #@chapter_journal = GalleryJournal.find(:all, :conditions => "galerry_id=#{params[:id]}")
     
      # Bread crumb sessions
        @galleries = Galleries.find(params[:id])
          session[:gal]=params[:id]
         session[:gallery_name]=@galleries['v_gallery_name']
       
      
       @gal_cnt = GalleryJournal.count(:all, :conditions => "galerry_id=#{params[:id]}")

    
    
    
    @galleryId = params[:id]
    @galleries = Galleries.find(params[:id])
      session[:gal]=params[:id]
      session[:gallery_name]=@galleries['v_gallery_name']
       params[:id]=@galleries['subchapter_id']
        @sub_chapter = SubChapter.find(params[:id])
          session[:subchap_id]=params[:id]
          session[:sub_chapname]=@sub_chapter['sub_chapname']
          params[:id]=@sub_chapter['tagid']
        @tag = Tag.find(params[:id])
          session[:chap_id]=params[:id]
          session[:chap_name]=@tag['v_tagname'] 
      
      
      params[:id]=session[:gal]
	@gallery  = Galleries.find(:all, :conditions => "id=#{params[:id]}", :order => "order_num ASC")
	@galleryUrl = ""
	if(@gallery[0].e_gallery_type == "video")
		logger.info("Gallery Type Video")
		@swfName = "CoverFlowVideo"
		@galleryUrl = "/myvideos/videoCoverflow/"+params[:id]
	elsif(@gallery[0].e_gallery_type == "image")
		logger.info("Gallery Type Image")
		@swfName = "PhotoGallery"
		@galleryUrl = "/galleries/showGallery/"+params[:id]
	elsif(@gallery[0].e_gallery_type == "audio")
		logger.info("Gallery Type Audio")
		@swfName = "CoverFlowAudio"
		@galleryUrl = "/galleries/showAudioGallery/"+params[:id]
	end
    render :layout => true
  end
  
  def remove
   @ids = params[:id]
   @idarray = @ids.split('$')
   for id in @idarray
     @galleries = Galleries.find(id)
     @galleries.status = "inactive"
     @galleries.deleted_date = Time.now
     if(@galleries.save)
       @retval = "success"
     else
       @retval = "failed"
     end
     @deletedId = params[:ids]
   end
   render :layout => false
  end
 
  def restore
   @galleries = Galleries.find(params[:id])
   @galleries.status = "active"
   @galleries.deleted_date = DateTime.now
   if(@galleries.save)
    @retval = "success"
   else
    @retval = "failed"
   end
   render :layout => false
 end
 
  def timeLine
    @hmm_user=HmmUser.find(session[:hmm_user])
   # render :layout => false
  end
end
