class LoadDataController < ApplicationController
  
  def chapterlist
    @hmm_user=HmmUsers.find(session[:hmm_user])
    if(session[:friend]=="" || session[:friend]==nil)
      uid=logged_in_hmm_user.id
    else
      uid=session[:friend]
    end  
    @results = Tag.find(:all, :conditions => "uid=#{uid} and status='active'" , :order => "id ASC" )
    @userid="#{uid}"
    render :layout => false
  end
  
  def subchapterlist
    @sub_chapters = SubChapter.find(:all ,:conditions =>" tagid = #{params[:id]} and status='active'")
    render :layout => false
  end
  
  def gallerylist
    @galleries = Galleries.find(:all ,:conditions =>"subchapter_id = #{params[:id]} and status='active'", :order =>'e_gallery_type')
    render :layout => false
  end
  
  def contentlist
    @user_content = UserContent.find(:all, :conditions => "gallery_id = #{params[:id]} and status='active' " , :order => 'id' )
    render :layout => false
  end
  
  def loadalldatachapterlevel
    @sub_chapters = SubChapter.find(:all ,:conditions =>" tagid = #{params[:id]} and status='active'")
    render :layout => false
  end
  
  def loadalldatasubchapterlevel
    @galleries = Galleries.find(:all ,:conditions =>"subchapter_id = #{params[:id]} and status='active'", :order =>'e_gallery_type')
    render :layout => false
  end
  
  def loadalldatagallerylevel
    @user_content = UserContent.find(:all, :conditions => "gallery_id = #{params[:id]} and status='active' " , :order => 'id' )
    render :layout => false
  end

  def get_gallery_coverflow_details
    #@user_content = UserContent.find(:all, :conditions => "gallery_id = #{params[:id]} and status='active' " , :order => 'id' )
    @userid = logged_in_hmm_user.id;
    @gallery123 = Galleries.find(params[:id])
    render :layout => false
  end
end
