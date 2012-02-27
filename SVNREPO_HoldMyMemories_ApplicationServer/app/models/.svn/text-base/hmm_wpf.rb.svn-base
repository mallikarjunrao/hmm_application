class HmmWpf < ActiveRecord::Base

  def self.save_chapter(chapter_name,user_id,chapter_description,chapter_type='chapter',gallery_type ='all')
    if !chapter_name.blank? && !user_id.blank? && !chapter_description.blank?
      @content_url = ContentPath.find :first,:conditions=>"status='inactive'"
      @tag = Tag.new()
      @tag['v_tagname'] = chapter_name
      @tag['v_desc'] =chapter_description
      @tag['uid'] = user_id
      @tag['tag_type'] = chapter_type
      @tag['e_access'] = "private"
      @tag['e_visible'] = "yes"
      @tag['img_url'] = @content_url['content_path']
      @tag['d_updateddate'] = Time.now
      @tag['d_createddate'] = Time.now
      if(chapter_type == 'video')
        @tag['v_chapimage'] = "videogallery.png"
      elsif(chapter_type == 'photo')
        @tag['v_chapimage'] = "photo_album.png"
      elsif(chapter_type == 'audio')
        @tag['v_chapimage'] = "speaker.jpg";
      else
        @tag['v_chapimage'] = "folder_img.png"
      end

      if @tag.save
        save_subchapter('Sub Chapter', 'Enter description here', user_id, @tag.id, gallery_type)
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def self.save_subchapter(subchapter_name,subchapter_description,user_id,chapter_id,gallery_type='all',store_id=nil)
    @content_url = ContentPath.find :first,:conditions=>"status='inactive'"
    @subChapter = SubChapter.new()
    @subChapter['sub_chapname'] = subchapter_name
    @subChapter['v_desc'] = subchapter_description
    @subChapter['uid'] = user_id
    @subChapter['tagid'] = chapter_id
    @subChapter['order_num'] = 0
    @subChapter['v_image'] = "folder_img.png"
    @subChapter['img_url'] = @content_url['content_path']
    @subChapter['e_access'] = "private"
    @subChapter['e_visible'] = "yes"
    @subChapter['permissions'] = user_id
    if store_id!=nil
      @subChapter['store_id'] = store_id
      studio=HmmStudio.find(:first,:select=>"studio_name",:conditions=>"id=#{store_id}")
      today_date=Date.today.strftime("%B. %d, %Y")
      photo_gallery="#{studio.studio_name} #{today_date}"
      video_gallery="#{studio.studio_name} #{today_date}"
      audio_gallery="#{studio.studio_name} #{today_date}"
    else
      photo_gallery="Photo Gallery"
      video_gallery="Video Gallery"
      audio_gallery="Audio Gallery"
    end

    @subChapter.d_created_on = Time.now
    @subChapter.d_updated_on = Time.now
    @subChapter['v_image'] = "folder_img.png"
    if (@subChapter.save )
     
      if(gallery_type=='all' || gallery_type=='image')
        save_gallery(photo_gallery, "Enter Description Here", "image", user_id, @subChapter.id)
      end
      if(gallery_type=='all' || gallery_type=='video')
        save_gallery(video_gallery, "Enter Description Here", "video", user_id, @subChapter.id)
      end
      if(gallery_type=='all' || gallery_type=='audio')
        save_gallery(audio_gallery, "Enter Description Here", "audio", user_id, @subChapter.id)
      end
      return @subChapter.id
    else
      return false
    end
  end

  def self.save_gallery(gallery_name,gallery_description,gallery_type,user_id,subchapter_id)
    @content_url = ContentPath.find :first,:conditions=>"status='inactive'"
  
    @gallery = Galleries.new()
    @gallery.d_gallery_date = Time.now
    @gallery.subchapter_id = subchapter_id
    @gallery.permissions = user_id
    @gallery.v_gallery_name = gallery_name
    @gallery.v_desc = gallery_description
    @gallery.img_url = @content_url['content_path']
    @gallery.order_num = 0
    @gallery.e_gallery_type = gallery_type
    @gallery.e_gallery_acess = "public"
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
      return @gallery.id
    else
      return false
    end
  end

  def self.update_customer_studio(id,emp_id,notes_to_link_customer)
    @hmmuser = HmmUser.find(id)
    @hmm_studiogroup_new=HmmStudio.find(:first,:select =>"a.studio_groupid,a.id as studioid,a.studio_name",:joins=>"as a, employe_accounts as b", :conditions=>"a.id=b.store_id and b.id=#{emp_id}")

    HmmStudio.find(:all, :select => "a.*", :joins => "as a, hmm_studiogroups as b ", :conditions => " b.id!=1 and b.id=a.studio_groupid")
    if(@hmmuser['emp_id']!=nil && @hmmuser['emp_id']!='')
      @hmm_studiogroup_old=HmmStudio.find(:first,:select =>"a.studio_groupid,a.id as studioid,a.studio_name",:joins=>"as a, employe_accounts as b", :conditions=>"a.id=b.store_id and b.id=#{@hmmuser['emp_id']}")

      if @hmm_studiogroup_old.studio_groupid == @hmm_studiogroup_new.studio_groupid  && @hmmuser.account_expdate > Date.today-1.month  #if studio groups are same and expiry date is greater than last month then no credit loss
        credit_lost=0
      else
        @credit_points=CreditPoint.find(:first,:conditions =>"user_id=#{id}")
        if @credit_points
          credit_lost=@credit_points.available_credits
          CreditPoint.update(@credit_points.id, :hmm_studiogroup_id =>"#{@hmm_studiogroup_new.studio_groupid}",:available_credits=>"0.00".to_f)
        else
          credit_lost=0
        end
      end
    end
    if(@hmmuser.emp_id)
      @hmmuser.old_emp_id="#{@hmmuser.emp_id}"
      @hmmuser.old_studio_id="#{@hmmuser.studio_id}"
      user=UserStudioLog.new
      user.user_id=@hmmuser.id
      user.emp_id=@hmmuser.emp_id
      user.studio_id=@hmmuser.studio_id
      user.credits_lost=credit_lost
      user.notes_link_to_customer=notes_to_link_customer
      user.save
    end
    @hmmuser['studio_id']=@hmm_studiogroup_new.studioid
    @hmmuser['emp_id']=emp_id
    @hmmuser.save
    @get_content_url=ContentPath.find(:all, :conditions => "status='inactive'")
    content_path=@get_content_url[0]['content_path']
    servername=@get_content_url[0]['proxyname']
    store_id = @hmm_studiogroup_new.studioid
    studiodet = HmmStudio.find(store_id)
    t = Time.now

    subchapter_check=SubChapter.count(:all,:conditions => "uid=#{@hmmuser.id} and store_id is not null")
    if(subchapter_check > 0)
      subchapter_get=SubChapter.find(:first,:conditions => "uid=#{@hmmuser.id} and store_id is not null")
      tagid=subchapter_get.tagid
      @tag_studio = Tag.find(tagid)
      subchapter_available=SubChapter.count(:all,:conditions => "uid=#{@hmmuser.id} and store_id=#{store_id}")
      if(subchapter_available>0)
        subchapter_avl=SubChapter.find(:first,:conditions => "uid=#{@hmmuser.id} and store_id=#{store_id}")

        @sub_chapter_studio_pho = SubChapter.find(subchapter_avl.id)
      else
        # Start preparing for a new sub chapter to be created for studio sessions photo
        @sub_chapter_studio_pho = SubChapter.new
        @sub_chapter_studio_pho['uid']=@hmmuser.id
        @sub_chapter_studio_pho['tagid']=@tag_studio.id
        @sub_chapter_studio_pho['sub_chapname']=@hmm_studiogroup_new.studio_name
        @sub_chapter_studio_pho['v_image']="folder_img.png"
        @sub_chapter_studio_pho['d_updated_on'] = Time.now
        @sub_chapter_studio_pho['d_created_on'] = Time.now
        @sub_chapter_studio_pho['e_access'] = "public"
        @sub_chapter_studio_pho['img_url']=content_path
        @sub_chapter_studio_pho['store_id']=store_id
        @sub_chapter_studio_pho.save
      end
      studio=HmmStudio.find(:first,:select=>"studio_name",:conditions=>"id=#{store_id}")
      today_date=Date.today.strftime("%B. %d, %Y")
      # Start preparing for a new gallery to be created studio sessions
      @galleries1_studio = Galleries.new()
      @galleries1_studio['v_gallery_name']="#{studio.studio_name} #{today_date}"
      @galleries1_studio['e_gallery_type']="image"
      @galleries1_studio['d_gallery_date']=Time.now
      @galleries1_studio['e_gallery_acess']="public"
      @galleries1_studio['v_gallery_image']="picture.png"
      @galleries1_studio['subchapter_id']=@sub_chapter_studio_pho.id
      @galleries1_studio['img_url']=content_path
      @galleries1_studio.save


    else
      # Start preparing for a new chapter to be created as studio sessions
      @tag_studio=Tag.new
      @tag_studio['v_tagname']="STUDIO SESSIONS"
      @tag_studio['uid']=@hmmuser.id
      @tag_studio['default_tag']="yes"
      @tag_studio.e_access = 'public'
      @tag_studio.e_visible = 'yes'
      @tag_studio['d_updateddate']= Time.now
      @tag_studio['d_createddate' ]= Time.now
      @tag_studio['img_url']=content_path
      @tag_studio['v_chapimage'] = "folder_img.png"
      @tag_studio.save

      # Start preparing for a new sub chapter to be created for studio sessions photo
      @sub_chapter_studio_pho = SubChapter.new
      @sub_chapter_studio_pho['uid']=@hmmuser.id
      @sub_chapter_studio_pho['tagid']=@tag_studio.id
      @sub_chapter_studio_pho['sub_chapname']=studiodet.studio_name
      @sub_chapter_studio_pho['v_image']="folder_img.png"
      @sub_chapter_studio_pho['d_updated_on'] = Time.now
      @sub_chapter_studio_pho['d_created_on'] = Time.now
      @sub_chapter_studio_pho['e_access'] = "public"
      @sub_chapter_studio_pho['img_url']=content_path
      @sub_chapter_studio_pho['store_id']=store_id
      @sub_chapter_studio_pho.save

      # Start preparing for a new gallery to be created studio sessions
      studio=HmmStudio.find(:first,:select=>"studio_name",:conditions=>"id=#{store_id}")
      today_date=Date.today.strftime("%B. %d, %Y")
      @galleries1_studio = Galleries.new()
      @galleries1_studio['v_gallery_name']="#{studio.studio_name} #{today_date}"
      @galleries1_studio['e_gallery_type']="image"
      @galleries1_studio['d_gallery_date']=Time.now
      @galleries1_studio['e_gallery_acess']="public"
      @galleries1_studio['v_gallery_image']="picture.png"
      @galleries1_studio['subchapter_id']=@sub_chapter_studio_pho.id
      @galleries1_studio['img_url']=content_path
      @galleries1_studio.save
    end
    hmmuser=HmmUser.find(id)
    employeinfo=EmployeAccount.find(emp_id)

    sql = ActiveRecord::Base.connection();

    if(employeinfo.store_id=170 or employeinfo.store_id='170')
      if(hmmuser.emp_id)
        hmmuser.notes_link_to_customer="#{notes_to_link_customer}"

        hmmuser.save
      else
        hmmuser.notes_link_to_customer="#{notes_to_link_customer}"
        hmmuser.save
      end
    else
      hmmuser.notes_link_to_customer="#{notes_to_link_customer}"
      hmmuser.save
    end
    sql.update "UPDATE hmm_users  SET emp_id='#{emp_id}' WHERE id=#{id}";

  end


  def self.other_studio_commision_report(store_id,start_date,end_date,page)
    sort = "a.id desc"
    customers = HmmUser.paginate :select =>"a.*,b.*,c.*, c.amount as commission, c.id as commmission_id", :joins => "as a, employe_accounts as b, studio_commissions  as c", :conditions => "b.store_id='#{store_id}' and b.id=c.emp_id and a.id=c.uid and  a.emp_id=b.id and a.account_type='platinum_user'  and c.payment_recieved_on between '#{start_date}' and '#{end_date}'",:order=>sort, :per_page => 25, :page => page
    return customers
  end

  def self.create_stud_chap(user_id,store_id)
    studio=HmmStudio.find(store_id)
    @get_content_url=ContentPath.find(:first, :conditions => "status='inactive'")
    content_path=@get_content_url['content_path']
    @galleries_max =  Galleries.find_by_sql("select max(id) as m from galleries")
    for galleries_max in @galleries_max
      galleries_max_id = "#{galleries_max.m}"
    end
    if(galleries_max_id == '')
      galleries_max_id = '0'
    end
    galleries_next_id= Integer(galleries_max_id) + 1

    @tag_max =  Tag.find_by_sql("select max(id) as m from tags")
    for tag_max in @tag_max
      tag_max_id = "#{tag_max.m}"
    end
    if(tag_max_id == '')
      tag_max_id = '0'
    end
    tag_next_id= Integer(tag_max_id) + 1

    t = Time.now
    studio_chapter =  Tag.find(:first, :conditions=> "v_tagname like 'STUDIO SESSIONS' and uid=#{user_id} and status='active'") #get the studio sessions chapter details
    if studio_chapter.nil?
      @tag_studio = Tag.new()
      @tag_studio['id'] = tag_next_id
      @tag_studio['v_tagname']="STUDIO SESSIONS"
      @tag_studio['uid']=user_id
      @tag_studio['default_tag']="yes"
      @tag_studio.e_access = 'public'
      @tag_studio.e_visible = 'yes'
      @tag_studio['d_updateddate']=t
      @tag_studio['d_createddate' ]=t
      @tag_studio['img_url']=content_path
      #@tag['v_chapimage']=@hmm_user['v_myimage']
      @tag_studio['v_tagname'] == 'STUDIO SESSIONS'
      @tag_studio['v_chapimage'] = "folder_img.png"

      @tag_studio.save
    else
      @tag_studio=studio_chapter
    end

    @subchapter_max =  SubChapter.find_by_sql("select max(id) as n from sub_chapters")
    for subchapter_max in @subchapter_max
      subchapter_max_id = "#{subchapter_max.n}"
    end
    if(subchapter_max_id == '')
      subchapter_max_id = '0'
    end
    subchapter_next_id= Integer(subchapter_max_id) + 1

    @sub_chapter_studio_video = SubChapter.new
    @sub_chapter_studio_video['id'] = subchapter_next_id
    @sub_chapter_studio_video['uid']=user_id
    @sub_chapter_studio_video['tagid']=@tag_studio.id
    @sub_chapter_studio_video['sub_chapname']=studio.studio_name
    @sub_chapter_studio_video['v_image']="folder_img.png"
    @sub_chapter_studio_video['d_updated_on'] = t
    @sub_chapter_studio_video['d_created_on'] = t
    @sub_chapter_studio_video['e_access'] = "public"
    @sub_chapter_studio_video['img_url']=content_path
    @sub_chapter_studio_video['order_num']=2
    @sub_chapter_studio_video['store_id']= store_id

    @sub_chapter_studio_video.save

    studio=HmmStudio.find(:first,:select=>"studio_name",:conditions=>"id=#{store_id}")
    @galleries1_studio = Galleries.new()
    today_date=Date.today.strftime("%B. %d, %Y")
    @galleries1_studio['id'] = galleries_next_id
    #img_gal=@galleries1_studio['id']
    @galleries1_studio['v_gallery_name']= "#{studio.studio_name} #{today_date}"
    @galleries1_studio['e_gallery_type']="image"
    @galleries1_studio['d_gallery_date']=Time.now
    @galleries1_studio['e_gallery_acess']="public"
    @galleries1_studio['v_gallery_image']="picture.png"
    @galleries1_studio['subchapter_id']=@sub_chapter_studio_video.id
    @galleries1_studio['img_url']=content_path
    @galleries1_studio.save



    @galleries2_studio = Galleries.new()
    @galleries2_studio['id'] = galleries_next_id +1
    @galleries2_studio['v_gallery_name']="#{studio.studio_name} #{today_date}"
    @galleries2_studio['e_gallery_type']="video"
    @galleries2_studio['d_gallery_date']=Time.now
    @galleries2_studio['e_gallery_acess']="public"
    @galleries2_studio['v_gallery_image']="video.png"
    @galleries2_studio['subchapter_id']=@sub_chapter_studio_video.id
    @galleries2_studio['img_url']=content_path
    @galleries2_studio.save

    @galleries3_studio = Galleries.new()
    @galleries3_studio['id'] = galleries_next_id + 2
    @galleries3_studio['v_gallery_name']="#{studio.studio_name} #{today_date}"
    @galleries3_studio['e_gallery_type']="audio"
    @galleries3_studio['d_gallery_date']=Time.now
    @galleries3_studio['e_gallery_acess']="public"
    @galleries3_studio['v_gallery_image']="audio.png"
    @galleries3_studio['subchapter_id']=@sub_chapter_studio_video.id
    @galleries3_studio['img_url']=content_path
    @galleries3_studio.save
    return @sub_chapter_studio_video
  end
end