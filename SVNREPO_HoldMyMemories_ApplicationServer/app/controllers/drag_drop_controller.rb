class DragDropController < ApplicationController


  def subchapter_dragdrop
    tagid=params[:tagid]
    subchapid=params[:subchapid]
    sql = ActiveRecord::Base.connection();
    sql.update "update sub_chapters set tagid='#{tagid}' where id='#{subchapid}'";
    galleries = Galleries.find(:all,:conditions => "subchapter_id='#{subchapid}'")
    sql.update "update user_contents set tagid='#{tagid}' where id='#{galleries[0].id}'";

    render(:layout => false)
  end

  def gallery_dragdrop
    galid=params[:galid]
    subchapid=params[:subchapid]
    subchapter=SubChapter.find(params[:subchapid])
    sql = ActiveRecord::Base.connection();
    sql.update "update galleries set subchapter_id='#{subchapid}' where id='#{galid}'";
    sql.update "update user_contents set tagid='#{subchapter.tagid}', sub_chapid='#{subchapid}' where gallery_id='#{galid}'";

    render(:layout => false)
  end

  def moment_dragdrop
    sql = ActiveRecord::Base.connection();
    if(params[:tagid]==nil)
    	galid=params[:galid]
	    momentid=params[:momentid]
	    galleries = Galleries.find(galid)
	    subchapter=SubChapter.find(galleries.subchapter_id)
      sql.update "update user_contents set tagid='#{subchapter.tagid}', sub_chapid='#{galleries.subchapter_id}', gallery_id='#{galid}' where id='#{momentid}'";
    else
    	tagid=params[:tagid]
	    momentid=params[:momentid]
	    subchapter=SubChapter.find(:all,:conditions=>"tagid='#{tagid}'")
	    galleries=Galleries.find(:all,:conditions => "subchapter_id='#{subchapter[0].id}'")
	    sql.update "update user_contents set tagid='#{tagid}', sub_chapid='#{subchapter[0].id}', gallery_id='#{galleries[0].id}' where id='#{momentid}'";
    end
    render(:layout => false)

  end


  def dragdrop_chapterlist
    @hmm_user=HmmUser.find(session[:hmm_user])
    if(session[:friend]=="" || session[:friend]==nil)
      uid=logged_in_hmm_user.id
    else
      uid=session[:friend]
    end
    @results = Tag.find(:all, :conditions => "uid=#{uid} and status='active'" , :order => "id ASC" )
    @userid="#{uid}"
    render :layout => false
  end

  def chapter_list
    uid=logged_in_hmm_user.id
    @results=Tag.find_by_sql("SELECT T1. * , T2.no_count as subchapter_count
FROM (

SELECT tags. *
FROM `tags`
WHERE tags.uid =#{uid}
AND tags.tag_type = 'chapter'
AND tags.status = 'active'
) AS T1
LEFT JOIN (

SELECT sub_chapters.tagid, count( sub_chapters.id ) AS no_count
FROM sub_chapters
WHERE sub_chapters.status = 'active'
GROUP BY sub_chapters.tagid
) AS T2 ON T2.tagid = T1.id
UNION SELECT T3. * , T4.no_count
FROM (

SELECT tags. *
FROM tags, sub_chapters, galleries
WHERE tags.uid =#{uid}
AND tags.tag_type <> 'chapter'
AND tags.status = 'active'
AND tags.id = sub_chapters.tagid
AND sub_chapters.id = galleries.subchapter_id
) AS T3
LEFT JOIN (

SELECT sub_chapters.tagid, count( user_contents.id ) AS no_count
FROM sub_chapters, galleries, user_contents
WHERE sub_chapters.id = galleries.subchapter_id
AND galleries.id = user_contents.gallery_id
GROUP BY sub_chapters.tagid
) AS T4 ON T3.id = T4.tagid ORDER BY order_num ASC")
    @userid="#{uid}"
    render :layout => false
  end

  def subchapter_list
    chapter_id = params[:chapter_id]
    #@sub_chapters = SubChapter.find(:all, :conditions => "tagid = #{chapter_id} and status='active'" , :order => "id ASC" )
    #@sub_chapters = SubChapter.find(:all,:select=>"a.*,count(b.id) as gallery_count",:joins=>"as a,galleries as b", :conditions => "a.tagid =#{chapter_id} and a.status='active' and a.id=b.subchapter_id" , :group => "a.id",:order => "a.order_num DESC,a.id DESC" )
    @sub_chapters = SubChapter.find_by_sql("SELECT T1. * ,coalesce( T2.no_count, '0' ) as gallery_count
FROM (

SELECT sub_chapters. *
FROM `sub_chapters`
WHERE STATUS = 'active' AND tagid=#{chapter_id}  ORDER BY order_num ASC
) AS T1
LEFT JOIN (

SELECT galleries.subchapter_id, count( galleries.id ) AS no_count
FROM galleries
WHERE galleries.status = 'active'
GROUP BY galleries.subchapter_id
) AS T2 ON T2.subchapter_id = T1.id")
    render :layout => false
  end

  def gallery_list
    subchapter_id = params[:subchapter_id]
    @tag = Tag.find(:first, :select => "a.tag_type", :joins => "as a, sub_chapters as b", :conditions => "a.id = b.tagid and b.id = #{subchapter_id} ")
    unless @tag.tag_type == "mobile_uploads"
      #@galleries = Galleries.find(:all, :conditions => "subchapter_id = #{subchapter_id} and status='active'" , :order => "id ASC" )
      #@galleries = Galleries.find(:all,:select=>"a.*,count(b.id) as contentcount",:joins=>"as a,user_contents as b", :conditions => "a.subchapter_id = #{subchapter_id} and a.status='active' and a.id=b.gallery_id" , :group => "a.id" )
      @galleries=Galleries.find_by_sql("SELECT T1. * ,coalesce( T2.no_count, '0' ) as contentcount
FROM (

SELECT galleries. *
FROM `galleries`
WHERE STATUS = 'active' AND subchapter_id=#{subchapter_id}  ORDER BY order_num ASC
) AS T1
LEFT JOIN (

SELECT user_contents.gallery_id, count( user_contents.id ) AS no_count
FROM user_contents
WHERE user_contents.status = 'active'
GROUP BY user_contents.gallery_id
) AS T2 ON T2.gallery_id = T1.id")
    else
      gallery_ary = Array.new
      @galleries = Galleries.find(:all, :conditions => "subchapter_id = #{subchapter_id}")
      for gallery in @galleries
        gallery_ary.push(gallery.id)
      end
      @gallery_list = gallery_ary.join(",")
      @user_content = UserContent.find(:all, :conditions => "gallery_id IN (#{@gallery_list}) and status='active'" , :order => "order_num ASC" )
    end
    render :layout => false
  end

  def user_content_list
    gallery_id = params[:gallery_id]
    @user_content = UserContent.find(:all, :conditions => "gallery_id = #{gallery_id} and status='active'" , :order => "order_num ASC" )
    render :layout => false
  end

  def album_content_list
    tag_id = params[:tag_id]
    @user_content = UserContent.find(:all, :conditions => "tagid = #{tag_id} and status='active'" , :order => "order_num ASC" )
    render :layout => false
  end

end