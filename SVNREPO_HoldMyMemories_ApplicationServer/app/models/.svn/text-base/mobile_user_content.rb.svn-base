class MobileUserContent < ActiveRecord::Base
  def
    self.table_name() "user_contents"
  end
  def to_json
    self.attributes.to_json
  end

  # returns contents of given gallery id and if modified date is given, returns contents created after that date
  # input:gallery_id,updated_date
  # output:json,returns the contents list of the given gallery id
  # created by :parthi

  def self.return_new_contents(params,content_dir='',extension='')
    unless params[:updated_date]==nil
      @conditions= ["gallery_id= :gallery_id AND status='active' AND created_at > :updated_date",{:updated_date => params[:updated_date],:gallery_id => params[:gallery_id]}]
    else
      @conditions= ["gallery_id= :gallery_id AND status='active'",{:gallery_id => params[:gallery_id]}]
    end
    
    @contents = self.find(:all,
      :conditions=>@conditions,
      :select=>"v_desc as content_description,id as content_id,v_tagphoto as content_name,CONCAT(img_url,'#{content_dir}',v_filename,'#{extension}') as content_url,e_filetype as content_type,DATE_FORMAT(d_createddate,'%c/%e/%Y %T') as created_date,latitude,longitude,CONCAT(img_url,'/user_content/audio_tags/',audio_tag) as audio_tag_url")
    if @contents.length > 0
      return @contents
    else
      return nil
    end
  end

  # returns contents of given gallery id and if modified date is given, returns contents modified after that date
  # input:gallery_id,updated_date
  # output:json,returns the contents list of the given gallery id
  # created by :parthi

  def self.return_updated_contents(params,content_dir='',extension='')
    @conditions= ["gallery_id= :gallery_id AND status='active' AND updated_at > :updated_date AND created_at <= :updated_date",{:updated_date => params[:updated_date],:gallery_id=> params[:gallery_id]}]
    @contents = self.find(:all,
      :conditions=>@conditions,
      :select=>"v_desc as content_description,id as content_id,v_tagphoto as content_name,CONCAT(img_url,'#{content_dir}',v_filename,'#{extension}') as content_url,e_filetype as content_type,DATE_FORMAT(d_createddate,'%c/%e/%Y %T') as created_date,latitude,longitude,CONCAT(img_url,'/user_content/audio_tags/',audio_tag) as audio_tag_url")
    if @contents.length > 0
      return @contents
    else
      return nil
    end
  end

  # returns contents of given gallery id and if modified date is given, returns contents deleted after that date
  # input:gallery_id,updated_date
  # output:json,returns the content list of the given gallery id
  # created by :parthi
  def self.return_deleted_contents(params)
    @conditions= ["user_contents.gallery_id= :gallery_id AND user_contents.status!='active' AND user_contents.updated_at > :updated_date",{:updated_date => params[:updated_date],:gallery_id => params[:gallery_id]}]
    @contents = self.find(:all,:joins =>"join tags on user_contents.tagid = tags.id", :conditions=>@conditions,:select=>"user_contents.id as content_id,tags.tag_type as parent_type")
    if @contents.length > 0
      return @contents
    else
      return nil
    end
  end
end