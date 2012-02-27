class LoadDataController < ApplicationController

  def chapterlist
    @hmm_user=HmmUser.find(session[:hmm_user])
    if(session[:friend]=="" || session[:friend]==nil)
      uid=logged_in_hmm_user.id
    else
      uid=session[:friend]
    end
    @results = Tag.find(:all, :conditions => "uid='#{uid}' and status='active'" , :order => "order_num ASC" )
    @userid="#{uid}"

    #checking payment status for studio session chapter
    @flag = 0
    cur_time=Time.now.strftime("%Y-%m-%d")
    @hmm_user_check =  HmmUser.count(:all, :conditions =>" account_expdate < Current_Date and id='#{logged_in_hmm_user.id}'")
    if @hmm_user_check > 0
      @flag = 1
    end


    render :layout => false
  end

  def chapterlistdragdrop
    @hmm_user=HmmUser.find(session[:hmm_user])
    if(session[:friend]=="" || session[:friend]==nil)
      uid=logged_in_hmm_user.id
    else
      uid=session[:friend]
    end
    @results = Tag.find(:all, :conditions => "uid='#{uid}' and status='active'" , :order => "order_num ASC" )
    @userid="#{uid}"

    #checking payment status for studio session chapter
    @flag = 0
    cur_time=Time.now.strftime("%Y-%m-%d")
    @hmm_user_check =  HmmUser.count(:all, :conditions =>" account_expdate <= '#{cur_time}' and id='#{logged_in_hmm_user.id}'")
    if @hmm_user_check > 0
      @hmm_user_max =  HmmUser.find_by_sql(" select account_expdate as m from hmm_users where id='#{logged_in_hmm_user.id}'")
      nextbilingdate = @hmm_user_max[0]['m']
    else
      nextbilingdate = "#{logged_in_hmm_user.account_expdate}"
    end
    if(nextbilingdate == nil || nextbilingdate == "")
      @flag = 1
      nextbilingdate2 = "Subscription Expired/cancelled"
      renewal_days = "Subscription already expired"
    else
      nextbilingdate1=nextbilingdate.split('-');
      nextbilingdate2="#{nextbilingdate1[1]} - #{nextbilingdate1[2]} - #{nextbilingdate1[0]}"
      @hmm_leftdays=HmmUser.find_by_sql("  SELECT DATEDIFF('#{nextbilingdate1}',CURDATE( ) ) as d  ")
      renewal_days = Integer(@hmm_leftdays[0]['d'])
      if(renewal_days <= 0)
        @flag = 1
      end
    end
    if logged_in_hmm_user.substatus=="suspended"
      @flag = 1
    end


    render :layout => false
  end

  #album listing in the upload component
  def albumlist
    @hmm_user=HmmUser.find(session[:hmm_user])
    if(session[:friend]=="" || session[:friend]==nil)
      uid=logged_in_hmm_user.id
    else
      uid=session[:friend]
    end
    @results = Tag.find(:all, :conditions => "uid='#{uid}' and status='active' and tag_type!='chapter'" , :order => "order_num ASC" )
    @userid="#{uid}"
    render :layout => false
  end

  def subchapterlist
    @tag = Tag.find(:first ,:conditions =>" id = '#{params[:id]}'")
    @sub_chapters = SubChapter.find(:all ,:conditions =>" tagid = '#{params[:id]}' and status='active'", :order => "order_num ASC" )
    render :layout => false
  end

  def gallerylist
    @galleries = Galleries.find(:all ,:conditions =>"subchapter_id = '#{params[:id]}' and status='active'", :order => "order_num ASC" )
    render :layout => false
  end

  def contentlist
    @user_content = UserContent.find(:all, :group => 'v_filename', :conditions => "gallery_id = '#{params[:id]}' and status='active' " , :order => "order_num ASC" )
    render :layout => false
  end

  def videolist
    @user_content = UserContent.find(:all, :group => 'v_filename', :conditions => " status='active' and e_filetype='video' and uid='#{params[:id]}' and e_access='public' " , :order => "gallery_id ASC" )
    render :layout => false
  end


  #album moments listing in the upload component
  def album_contentlist
    @user_content = UserContent.find(:all, :group => 'v_filename', :conditions => "tagid = '#{params[:id]}' and status='active' " , :order => "order_num ASC" )
    render :layout => false
  end

  def loaddataalbumlevel
    @user_content = UserContent.find(:all, :group => 'v_filename', :conditions => "tagid = '#{params[:id]}' and status='active' " , :order => "order_num ASC" )
    render :layout => false
  end

  def loadalldatachapterlevel
    @sub_chapters = SubChapter.find(:all ,:conditions =>" tagid = '#{params[:id]}' and status='active'", :order => "order_num ASC")
    render :layout => false
  end

  def loadalldatasubchapterlevel
    @galleries = Galleries.find(:all ,:conditions =>"subchapter_id = '#{params[:id]}' and status='active'", :order => "order_num ASC")
    render :layout => false
  end

  def loadalldatagallerylevel
    @user_content = UserContent.find(:all, :group => 'v_filename', :conditions => "gallery_id = '#{params[:id]}' and status='active' " , :order => "order_num ASC" )
    render :layout => false
  end

  def get_gallery_coverflow_details
    #@user_content = UserContent.find(:all, :conditions => "gallery_id = #{params[:id]} and status='active' " , :order => 'id' )
    @userid = logged_in_hmm_user.id;
    @gallery123 = Galleries.find(params[:id])
    render :layout => false
  end

  def get_moment_details
    @user_content = UserContent.find(:first,:conditions => "id=#{params[:id]}", :select => 'latitude,longitude,audio_tag,img_url')
    unless(@user_content.audio_tag=='' || @user_content.audio_tag==nil)
      @user_content.audio_tag ="#{@user_content.img_url}/user_content/audio_tags/#{@user_content.audio_tag}"
    end
    render :xml => @user_content.to_xml({:root=>'response',:dasherize =>false,:except =>'img_url'})
  end

  def studio_session_videos

  @user_contents=UserContent.find(:all,:select=>"a.*",:joins=>"as a,galleries as b,sub_chapters as c",:conditions=>"c.id = b.subchapter_id and a.gallery_id = b.id and  a.status='active' and b.status='active' and c.status='active' and c.e_access='public' and b.e_gallery_acess ='public' and a.e_access='public' and c.store_id!='' and b.e_gallery_type ='video' and a.e_filetype  ='video' and c.uid=#{params[:id]}",:order=>"a.id desc")
#  @user_contents=UserContent.find(:all,:joins=>"INNER JOIN galleries ON user_contents.gallery_id = galleries.id INNER JOIN sub_chapters ON sub_chapters.id = galleries.subchapter_id INNER JOIN tags ON tags.id = sub_chapters.tagid",
#      :conditions => "user_contents.e_filetype='video' and  tags.uid=#{params[:id]} and  (tags.v_tagname ='STUDIO SESSIONS' or tags.v_tagname = 'studio sessions' or tags.v_tagname ='STUDIO SESSION'  or tags.v_tagname = 'Studio session'  or tags.v_tagname = 'studio session'  or tags.v_tagname = 'Studio Sessions'  or tags.v_tagname = 'Studio Session' ) and  sub_chapters.store_id!=''  and tags.status='active' and (user_contents.e_access='public' or user_contents.e_access='semiprivate')",
#      :select =>"user_contents.*",:order=>"user_contents.id desc")
    render :layout=> false
end

end