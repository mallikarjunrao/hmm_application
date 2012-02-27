class MobileAutoSharesController < ApplicationController
  require 'json/pure'
  layout false
  before_filter :response_header

  def response_header
    response.headers['Pragma' ] = 'no-cache'
    response.headers['Cache-Control' ] = 'no-store, no-cache, max-age=0, must-revalidate'
    response.headers['Content-Type' ] = 'text/x-json'
  end
  
  def get_share_details
    @retval = Hash.new()
    unless params[:type].blank? && params[:id].blank?
      emails = Array.new
      case params[:type]
      when 'chapter'
        fshare = MobileTag.find(params[:id],:select => 'facebook_share')
        type = params[:type]
      when 'subchapter'
        fshare = MobileSubChapter.find(params[:id],:select => 'facebook_share')
         type = params[:type]
      when 'gallery'
        fshare = MobileGallery.find(params[:id],:select => 'facebook_share')
         type = params[:type]
      when 'event'
        fshare = MobileSubChapter.find(params[:id],:select => 'facebook_share')
         type = 'subchapter'
      end
      share_emails = AutoShare.find(:all, :conditions => "share_type = '#{type}' and share_type_id = #{params[:id]}",:select => 'email')
      for share in share_emails
        emails.push(share.email)
      end if share_emails.length>0
      @retval[:facebook_share] = fshare.facebook_share
      @retval[:emails] = emails
      @retval['status'] = true
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    render :text => @retval.to_json
  end 
end
