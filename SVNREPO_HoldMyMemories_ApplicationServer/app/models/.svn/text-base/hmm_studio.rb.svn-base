class HmmStudio < ActiveRecord::Base


  def self.users_info(account_type,date_period,studio_id)
    hmm_userscount=HmmUser.count(:all,:conditions => "account_type='#{account_type}' and #{date_period} and studio_id='#{studio_id}'")
    return hmm_userscount
  end

  def self.total_studio_session_info(account_type,date_period,studio_id,type)
    total_galleries= Galleries.find(:all,:select=>"b.uid as uid",:joins=>"as a,sub_chapters as b",:conditions =>"a.d_gallery_date between  '#{date_period}' and a.subchapter_id=b.id and b.store_id='#{studio_id}' and a.e_gallery_type='#{type}'")
    logger.info("total_small galleries")
    total_gallery= Array.new
    for total_galleri in total_galleries
      total_gallery.push(total_galleri.uid)
    end
    logger.info(total_gallery.inspect)
    total_gallery=total_gallery.uniq
    total_gallery=total_gallery.join(",")
    logger.info(total_gallery.inspect)
    if total_gallery.length > 0
      total_galleries = HmmUser.count(:conditions=>"account_type='#{account_type}' and id in(#{total_gallery})")
      return total_galleries
    else
      return 0
    end
  end

  def self.studio_session_info(account_type,date_period,studio_id,type)
    total_galleries= Galleries.find(:all,:select=>"a.id",:joins=>"as a,sub_chapters as b",:conditions =>"a.d_gallery_date between  '#{date_period}' and a.subchapter_id=b.id and b.store_id='#{studio_id}' and a.e_gallery_type='#{type}'")
    logger.info("total_galleries")
    logger.info(total_galleries.inspect)
    hmmuser=Array.new
    for gal in total_galleries
      user_images=UserContent.find(:first,:conditions => "gallery_id='#{gal.id}'")
      if(user_images)
        hmmuser.push(user_images.uid)
      end
    end
    hmmuser=hmmuser.uniq
    hmmuser=hmmuser.join(",")
    if hmmuser.length > 0
      @hmm_users=HmmUser.find(:all,:conditions=>"id in(#{hmmuser}) and account_type='#{account_type}'")
      return @hmm_users.length
    else
      return 0
    end
  end

  #this is for the new user
  def self.users_new_info(account_type,date_period,studio_id)

    @id="SELECT * FROM hmm_users AS t1 INNER JOIN galleries AS t2 ON t1.d_created_date = t2.d_gallery_date";
    arr = Array.new
    for @id1 in @id
      arr.push(@id1.id)
    end
    @ids=arr.join(",")
    hmm_userscount=HmmUser.count(:all,:conditions => "account_type='#{account_type}' and id IN (#{@ids})  and #{date_period} and studio_id='#{studio_id}'")
    return hmm_userscount
  end


  #this is for the new user
  def self.studio_session_new_info(account_type,date_period,studio_id,type)
    hmm_users=HmmUser.find(:all, :select => "id,studio_id,d_created_date", :conditions => "account_type='#{account_type}' and #{date_period} and studio_id='#{studio_id}'")
    cnt = 0
    for hmmuser in hmm_users
      subchapters=SubChapter.count(:all, :conditions => "uid='#{hmmuser.id}' and store_id='#{hmmuser.studio_id}'")
      if(subchapters > 0 )
        subchapters=SubChapter.find(:first,:select => "id", :conditions => "uid='#{hmmuser.id}' and store_id='#{hmmuser.studio_id}'")
        galleries = Galleries.count(:first, :select => "id", :conditions => "subchapter_id = '#{subchapters.id}' ",:order => "d_gallery_date DESC",:limit => "0,1" )
        if(galleries > 0 )
          galleries = Galleries.find(:first, :select => "id,d_gallery_date", :conditions => "subchapter_id = '#{subchapters.id}'  ",:order => "d_gallery_date DESC",:limit => "0,1" )
          #if(hmmuser.d_created_date.strftime("%Y-%m")== galleries.d_gallery_date.strftime("%Y-%m"))
          datediff = HmmUser.find_by_sql("select DATEDIFF('#{galleries.d_gallery_date.strftime('%Y-%m-%d')}','#{hmmuser.d_created_date.strftime('%Y-%m-%d')}') as datedif")
          datedifference=datediff[0].datedif.to_i
          if(datedifference < 10 )
            cnt = cnt + 1
          end
        elsif(galleries == 0)
          cnt = cnt + 1
        end
      elsif(subchapters == 0)
        cnt = cnt + 1
      end
    end
    return cnt
  end

  def self.premium_users_info(date_period,studio_id)


    count = HmmUser.count(:joins =>" LEFT JOIN hmm_studios ON hmm_users.studio_id=hmm_studios.id",:conditions=>"hmm_studios.studio_groupid=1  and account_type='platinum_user' and #{date_period} and hmm_studios.id=#{studio_id}")

    return count
  end

  #this is for the repeated user
  def self.studio_session_repeat_info(account_type,date_period,studio_id,type)
    hmm_users=HmmUser.find(:all, :select => "id,studio_id,d_created_date", :conditions => "account_type='#{account_type}' and #{date_period} and studio_id='#{studio_id}'")
    cnt = 0
    for hmmuser in hmm_users
      subchapters=SubChapter.count(:all, :conditions => "uid='#{hmmuser.id}' and store_id='#{hmmuser.studio_id}'")
      if(subchapters > 0 )
        subchapters=SubChapter.find(:first,:select => "id", :conditions => "uid='#{hmmuser.id}' and store_id='#{hmmuser.studio_id}'")
        galleries = Galleries.count(:first, :select => "id", :conditions => "subchapter_id = '#{subchapters.id}'",:order => "d_gallery_date DESC",:limit => "0,1" )
        if(galleries > 0 )
          galleries = Galleries.find(:first, :select => "id,d_gallery_date", :conditions => "subchapter_id = '#{subchapters.id}'  ",:order => "d_gallery_date DESC",:limit => "0,1" )
          datediff = HmmUser.find_by_sql("select DATEDIFF('#{galleries.d_gallery_date.strftime('%Y-%m-%d')}','#{hmmuser.d_created_date.strftime('%Y-%m-%d')}') as datedif")
          datedifference=datediff[0].datedif.to_i
          if(datedifference > 10 )
            cnt = cnt + 1
          end
        end
      end
    end
    return cnt
  end

  def self.studiosession(id)
    get_content_url=ContentPath.find(:all, :conditions => "status='active'")
    content_path=get_content_url[0]['content_path']
    hmm_user_det = HmmUser.find(id)
    if(hmm_user_det.emp_id)
      employedet=EmployeAccount.find(hmm_user_det.emp_id)
      hmmstudio=HmmStudio.find(employedet.store_id)
      subchaptercount=SubChapter.count(:all, :conditions => "store_id > 0 and uid=#{hmm_user_det.id}")
      if(subchaptercount > 0)
        subchaptercheck = SubChapter.count(:all, :conditions => "store_id = #{employedet.store_id}  and uid=#{hmm_user_det.id} ")
        if(subchaptercheck > 0)
          return "STUDIO SESSIONS CHAPTER IS PRESENT"
        else
          subchapterfind=SubChapter.find(:first, :conditions => "store_id > 0  and uid=#{hmm_user_det.id}")
          subchapter_new = SubChapter.new
          subchapter_new['uid']= hmm_user_det.id
          subchapter_new['tagid']= subchapterfind.tagid
          subchapter_new['sub_chapname']="#{hmmstudio.studio_name}"
          subchapter_new['v_image']="folder_img.png"
          subchapter_new['e_access'] = "public"
          subchapter_new['d_updated_on'] = Time.now
          subchapter_new['d_created_on'] = Time.now
          subchapter_new['img_url']=content_path
          subchapter_new['store_id']= hmmstudio.id
          subchapter_new.save
          return "STUDIO SESSIONS CHAPTER IS PRESENT"
        end
      else
        return "Not Present"
      end
    else
      return "Not Present"
    end

  end

  #  def self.studiosession1(id)
  #    @get_content_url=ContentPath.find(:all, :conditions => "status='active'")
  #    content_path=@get_content_url[0]['content_path']
  #    if(session[:employe])
  #      hmm_user_det = HmmUser.find(id)
  #            employedet=EmployeAccount.find(session[:employe])
  #            hmmstudio=HmmStudio.find(employedet.store_id)
  #            subchaptercount=SubChapter.count(:all, :conditions => "store_id > 0 and uid=#{hmm_user_det.id}")
  #            if(subchaptercount > 0)
  #              subchaptercheck = SubChapter.count(:all, :conditions => "store_id = #{employedet.store_id}  and uid=#{hmm_user_det.id} ")
  #              if(subchaptercheck > 0)
  #              else
  #                subchapterfind=SubChapter.find(:first, :conditions => "store_id > 0  and uid=#{hmm_user_det.id}")
  #                subchapter_new = SubChapter.new
  #                subchapter_new['uid']= hmm_user_det.id
  #                subchapter_new['tagid']= subchapterfind.tagid
  #                subchapter_new['sub_chapname']="#{hmmstudio.studio_name}"
  #                subchapter_new['v_image']="folder_img.png"
  #                subchapter_new['e_access'] = "public"
  #                subchapter_new['d_updated_on'] = Time.now
  #                subchapter_new['d_created_on'] = Time.now
  #                subchapter_new['img_url']=content_path
  #                subchapter_new['store_id']= hmmstudio.id
  #                subchapter_new.save
  #              end
  #            else
  #              tag_default = Tag.new
  #              tag_default.default_tag='no'
  #              tag_default.v_tagname="STUDIO SESSIONS"
  #              tag_default.uid=hmm_user_det.id
  #              tag_default.default_tag="yes"
  #              tag_default.e_access = 'public'
  #              tag_default.e_visible = 'yes'
  #              tag_default.d_updateddate= Time.now
  #              tag_default.d_createddate= Time.now
  #              tag_default.img_url=content_path
  #              tag_default.v_chapimage = "folder_img.png"
  #              tag_default.save
  #              subchapter_new = SubChapter.new
  #              subchapter_new['uid']= hmm_user_det.id
  #              subchapter_new['tagid']= tag_default.id
  #              subchapter_new['sub_chapname']="#{hmmstudio.studio_name}"
  #              subchapter_new['v_image']="folder_img.png"
  #              subchapter_new['e_access'] = "public"
  #              subchapter_new['d_updated_on'] = Time.now
  #              subchapter_new['d_created_on'] = Time.now
  #              subchapter_new['img_url']=content_path
  #              subchapter_new['store_id']= hmmstudio.id
  #              subchapter_new.save
  #            end
  #          end
  #  end


end