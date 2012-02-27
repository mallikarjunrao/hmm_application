class MobileSubChaptersController < ApplicationController
  require 'json/pure'
  layout false
  before_filter :response_header

  def response_header
    response.headers['Pragma' ] = 'no-cache'
    response.headers['Cache-Control' ] = 'no-store, no-cache, max-age=0, must-revalidate'
    response.headers['Content-Type' ] = 'text/x-json'
  end

  # subchapter service for the mobile application
  # input:chapter_id,offset(record to begin with during paging)
  # output:json,returns the chapter list of the given chapter id
  # created by :parthi
  def get_subchapters
    @retval = Hash.new()
    if !params[:chapter_id].blank?
      @subChapters = MobileSubChapter.find(:all,
        :conditions=>{:tagid=>params[:chapter_id],:status=>'active'},
        :select=>"v_desc as subchapter_description,id as subchapter_id,sub_chapname as subchapter_name,CONCAT(img_url,'/user_content/photos/icon_thumbnails/',v_image) as subchapter_image,auto_share")
      @retval['body'] = @subChapters
      @retval['status'] = true
      @retval['count'] = @subChapters.length
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    render :text => @retval.to_json
  end

  # create subchapter service for the mobile application
  # input:user id, chapter id,
  # output:json,returns the sub chapter details of created subchapter
  # created by :parthi
  def create_subchapter
    @retval = Hash.new()
    if !params[:subchapter_name].blank? && !params[:user_id].blank? && !params[:chapter_id].blank?
      if !params[:auto_share].blank? && params[:auto_share]=='1'
        auto_share = 1
      else
        auto_share = 0
      end

      if !params[:facebook_share].blank? && params[:facebook_share]=='1'
        facebook_share = 1
      else
        facebook_share = 0
      end

      unless params[:subchapter_description].blank?
        desc = params[:subchapter_description]
      else
        desc = 'Enter description here...'
      end
      if (result = MobileSubChapter.save_subchapter(params[:subchapter_name], desc, params[:user_id], params[:chapter_id],'all',auto_share,facebook_share))
        if auto_share==1 && !params[:emails].blank?
          emails = JSON.parse(params[:emails])
          for email in emails
            share = AutoShare.new()
            share.share_type = 'subchapter'
            share.share_type_id = result.id
            share.email = email
            share.save()
          end
        end
        subchapters = self.synchronize_subchapters(params)
        @retval['body'] = subchapters
        @retval['status'] = true
      else
        @retval['status'] = false
        @retval['message'] = "Sub chapter creation failed!"
      end
    else
      @retval['message'] = "Incomplete data provided!"
      @retval['status'] = false
    end
    render :text=>@retval.to_json
  end

  # returns the sync subchapter result for the mobile application
  # input:chapter_id, updated_date
  # output:array of new,updated and deleted records of the particular chapter
  # created by :parthi
  def synchronize_subchapters(params)
    if !params[:chapter_id].blank?
      @chapters1 = Hash.new()
      record = MobileSubChapter.find_by_sql("select NOW() as updated_time")
      @chapters1['updated_time'] = record[0]['updated_time']
      @new = MobileSubChapter.return_new_subchapters(params)
      if @new != nil
        @chapters1['new_records'] = @new
      end
      @updated = MobileSubChapter.return_updated_subchapters(params)
      if @updated != nil
        @chapters1['updated_records'] = @updated
      end
      @deleted = MobileSubChapter.return_deleted_subchapters(params)
      if @deleted != nil
        @chapters1['deleted_records'] = @deleted
      end
      @chapters1['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      return @chapters1
    else
      return false
    end
  end





  #service to delete the sub chapter
  #input : subchapter_id
  #output : subchapter sync
  def delete_subchapter
    @retval = Hash.new()
    unless params[:selected_ids].blank?
      subchapter_ids = JSON.parse(params[:selected_ids])
      subchapter = MobileSubChapter.find(:first,:conditions => "id=#{subchapter_ids[0]}",:select => "tagid")
      params[:chapter_id] = subchapter.tagid
      for subchapter_id in subchapter_ids
        MobileSubChapter.update(subchapter_id, :status => 'deleted', :deleted_date=>Time.now)
      end
      subchapters = self.synchronize_subchapters(params)
      if subchapters
        @retval['body'] = subchapters
        @retval['status'] = true
        @retval['type'] = params[:type] if params[:type]
        @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      else
        @retval['message'] = 'Error while sync subchapter!'
        @retval['status'] = false
      end

    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    render :text => @retval.to_json
  end

  #service to update the sub chapter
  #input : subchapter_id
  #output : subchapter sync
  def update_subchapter
    @retval = Hash.new()
    unless params[:subchapter_id].blank? && params[:subchapter_name].blank? && params[:auto_share].blank?
      if !params[:auto_share].blank? && params[:auto_share]=='1'
        auto_share = 1
      else
        auto_share = 0
      end
      result = MobileSubChapter.update(params[:subchapter_id], :sub_chapname => params[:subchapter_name], :auto_share => auto_share)
      if result
        if params[:auto_share] == '1'
          unless params[:emails].blank?
            emails = JSON.parse(params[:emails])
            AutoShare.delete_all("share_type='subchapter' and share_type_id=#{params[:subchapter_id]}")
            for email in emails
              share = AutoShare.new()
              share.share_type = 'subchapter'
              share.share_type_id = params[:subchapter_id]
              share.email = email
              share.save()
            end
          else
            AutoShare.delete_all("share_type = 'subchapter' and share_type_id = #{params[:subchapter_id]}")
          end
          unless params[:facebook_share].blank?
            if params[:facebook_share]=='1'
              facebook_share = 1
            else
              facebook_share = 0
            end
            MobileSubChapter.update(params[:subchapter_id], :facebook_share => facebook_share)
          end
        end
        subchapters = self.synchronize_subchapters(params)
        if subchapters
          @retval['body'] = subchapters
          @retval['status'] = true
          @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
        else
          @retval['message'] = 'Error while sync subchapter!'
          @retval['status'] = false
        end
      else
        @retval['message'] = 'Error while updating subchapter!'
        @retval['status'] = false
      end
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    render :text => @retval.to_json
  end


  # create event service for the mobile application
  # input:user id, event details
  # output:json,returns the sub chapter details of created event
  # created by :parthi
  def create_event
    @retval = Hash.new()
    if !params[:event_name].blank? && !params[:user_id].blank? && !params[:updated_date].blank?

      if !params[:auto_share].blank? && params[:auto_share]=='1'
        auto_share = 1
      else
        auto_share = 0
      end
      if !params[:facebook_share].blank? && params[:facebook_share]=='1'
        facebook_share = 1
      else
        facebook_share = 0
      end

      @chapter = MobileTag.find(:first,:conditions=>"uid=#{params[:user_id]} and tag_type='mobile_uploads' and status='active'")
      if (!@chapter)
        @chapter  = MobileTag.save_mobile_uploads_chapter(params[:user_id])
      end
      event = MobileSubChapter.save_subchapter(params[:event_name], "Enter description here", params[:user_id], @chapter.id,'all',auto_share,facebook_share)
      if (event)
        if auto_share==1 && !params[:emails].blank?
          emails = JSON.parse(params[:emails])
          for email in emails
            share = AutoShare.new()
            share.share_type = 'subchapter'
            share.share_type_id = event.id
            share.email = email
            share.save()
          end
        end
        subchapters = MobileTag.synchronize_chapters(params)
        @retval['body'] = subchapters
        @retval['status'] = true
      else
        @retval['status'] = false
        @retval['message'] = "Event creation failed!"
      end
    else
      @retval['message'] = "Incomplete data provided!"
      @retval['status'] = false
    end
    render :text=>@retval.to_json
  end

  #service to update the sub chapter
  #input : subchapter_id
  #output : subchapter sync
  def update_event
    @retval = Hash.new()
    unless params[:event_id].blank? && params[:event_name].blank? && !params[:updated_date].blank?
      if !params[:auto_share].blank? && params[:auto_share]=='1'
        auto_share = 1
      else
        auto_share = 0
      end
      if !params[:facebook_share].blank? && params[:facebook_share]=='1'
        facebook_share = 1
      else
        facebook_share = 0
      end
      result = MobileSubChapter.update(params[:event_id], :sub_chapname => params[:event_name], :facebook_share => facebook_share, :auto_share => auto_share, :e_access => params[:access])
      if result
        AutoShare.delete_all("share_type='subchapter' and share_type_id=#{params[:event_id]}")
        if auto_share==1 && !params[:emails].blank?
          emails = JSON.parse(params[:emails])
          for email in emails
            share = AutoShare.new()
            share.share_type = 'subchapter'
            share.share_type_id = params[:event_id]
            share.email = email
            share.save()
          end
        end
        subchapters = MobileTag.synchronize_chapters(params)
        if subchapters
          @retval['body'] = subchapters
          @retval['status'] = true
          @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
        else
          @retval['message'] = 'Error while sync event!'
          @retval['status'] = false
        end
      else
        @retval['message'] = 'Error while updating event!'
        @retval['status'] = false
      end
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    render :text => @retval.to_json
  end

  def get_event_setting
    @retval = Hash.new()
    unless params[:event_id].blank?
      event = MobileSubChapter.find(params[:event_id],:select => 'e_access')
      @retval['body'] = Hash.new()
      @retval['body']['access'] = event.e_access
      @retval['status'] = true
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    render :text => @retval.to_json
  end

end