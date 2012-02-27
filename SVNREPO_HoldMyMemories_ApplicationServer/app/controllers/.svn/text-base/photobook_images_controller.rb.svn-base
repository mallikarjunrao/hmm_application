class PhotobookImagesController < ApplicationController
  require 'json/pure'
  def add_photobook_images_service
    data =  JSON.parse(params[:content]) #parse the JSON content
    items = data['source']
    @pcnt=PhotobookImage.count(:all)
    if(@pcnt>0)
      @pmax=PhotobookImage.maximum(:page_id)
      @pval=@pmax+1
      @ordmax=PhotobookImage.maximum(:order)
      @ordval=@ordmax+1
    else
      @pval=1
      @ordval=1
    end
    for item in items
      @photobookdet=PhotobookImage.new
      @photobookdet['page_id']=@pval
      @photobookdet['user_content_id']=item['image_id']
      @usercont=UserContent.find(item['image_id'])
      @photobookdet['file_name']=@usercont.v_filename
      @photobookdet['x']=1
      @photobookdet['y']=1
      @photobookdet['rotation']=0
      @photobookdet['height']=400
      @photobookdet['width']=300
      @photobookdet['order']=@ordval
      @photobookdet.save
    end
    render :text =>'true'
  end
end
