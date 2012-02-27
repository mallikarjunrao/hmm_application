class MobileGallery < ActiveRecord::Base
  has_many :user_contents, :foreign_key => "gallery_id"
  def
    self.table_name() "galleries"
  end

  def to_json
    self.attributes.to_json
  end

  # returns chapters of given user id and if modified date is given, returns chapters created after that date
  # input:user_id,updated_date
  # output:json,returns the chapter list of the given user id
  # created by :parthi

  def self.return_new_galleries(params)
    @conditions= ["subchapter_id= :subchapter_id AND status='active' AND created_at > :updated_date",{:updated_date => params[:updated_date],:subchapter_id => params[:subchapter_id]}]
    @chapters = self.find(:all,
      :conditions=>@conditions,
      :select=>"v_desc as gallery_description,id as gallery_id,v_gallery_name as gallery_name,CONCAT(img_url,'/user_content/photos/icon_thumbnails/',v_gallery_image) as gallery_image,e_gallery_type as gallery_type,DATE_FORMAT(d_gallery_date,'%c/%e/%Y %T') as created_date,auto_share")
    if @chapters.length > 0
      return @chapters
    else
      return nil
    end
  end

  # returns chapters of given user id and if modified date is given, returns chapters modified after that date
  # input:user_id,updated_date
  # output:json,returns the chapter list of the given user id
  # created by :parthi

  def self.return_updated_galleries(params)
    @conditions= ["subchapter_id= :subchapter_id AND status='active' AND updated_at > :updated_date AND created_at <= :updated_date",{:updated_date => params[:updated_date],:subchapter_id => params[:subchapter_id]}]
    @chapters = self.find(:all,
      :conditions=>@conditions,
      :select=>"v_desc as gallery_description,id as gallery_id,v_gallery_name as gallery_name,CONCAT(img_url,'/user_content/photos/icon_thumbnails/',v_gallery_image) as gallery_image,e_gallery_type as gallery_type,DATE_FORMAT(d_gallery_date,'%c/%e/%Y %T') as created_date,auto_share")
    if @chapters.length > 0
      return @chapters
    else
      return nil
    end
  end

  # returns chapters of given user id and if modified date is given, returns chapters deleted after that date
  # input:user_id,updated_date
  # output:json,returns the chapter list of the given user id
  # created by :parthi
  def self.return_deleted_galleries(params)
    @conditions= ["subchapter_id= :subchapter_id AND status!='active' AND updated_at > :updated_date",{:updated_date => params[:updated_date],:subchapter_id => params[:subchapter_id]}]
    @chapters = self.find(:all,
      :conditions=>@conditions,
      :select=>"id as gallery_id")
    if @chapters.length > 0
      return @chapters
    else
      return nil
    end
  end

  def self.save_gallery(gallery_name,gallery_description,gallery_type,user_id,subchapter_id,auto_share=0,facebook_share = 0)
    @content_url = ContentPath.find :first,:conditions=>"status='inactive'"
    @gallery = self.new()
    @gallery.d_gallery_date = Time.now
    @gallery.subchapter_id = subchapter_id
    @gallery.permissions = user_id
    @gallery.v_gallery_name = gallery_name
    @gallery.v_desc = gallery_description
    @gallery.img_url = @content_url['content_path']
    @gallery.order_num = 0
    @gallery.e_gallery_type = gallery_type
    @gallery.e_gallery_acess = "public"
    @gallery.auto_share = auto_share
    @gallery.facebook_share = facebook_share
    @gallery.client = 'iphone'
    if(@gallery.e_gallery_type == "image")
      @gallery.v_gallery_image = "picture.png"
    end
    if(@gallery.e_gallery_type == "video")
      @gallery.v_gallery_image = "video.png"
    end
    if(@gallery.e_gallery_type == "audio")
      @gallery.v_gallery_image = "audio.png"
    end
    @gallery.d_gallery_date = Time.now
    if @gallery.save
      return @gallery
    else
      return false
    end
  end


  def self.synchronize_galleries(params)
    unless params[:subchapter_id].blank?
      @galleries = Hash.new()
      @new = self.return_new_galleries(params)
      if @new != nil
        @galleries['new_records'] = @new
      end
      @updated = self.return_updated_galleries(params)
      if @updated != nil
        @galleries['updated_records'] = @updated
      end
      @deleted = self.return_deleted_galleries(params)
      if @deleted != nil
        @galleries['deleted_records'] = @deleted
      end
      @galleries['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      return @galleries
    else
      return false
    end
  end



end