class GridViewController < ApplicationController
  layout 'familywebsite'
  require 'will_paginate'
  include SortHelper
  helper :sort
  before_filter  :check_account,:redirect_url #checks for valid family name, terms of use check and user block check

  #method to check whether the family name in the url is valid or invalid
  #if family name doesn't exist, redirects to hmm home page
  #if user is blocked, displays message
  #if user didn't agee for terms of use,
  # => if the user is not logged in, takes to login page
  # => if the user is logged in, takes to agree terms page
  def check_account
    unless params[:id].blank?
      @family_website_owner = HmmUser.find(:first,:joins =>"INNER JOIN themes on hmm_users.theme_id=themes.id", :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')",:select => "hmm_users.*,themes.stylesheet as theme") #get the user details
      if @family_website_owner
        if(session[:employe]==nil && @family_website_owner.terms_checked == 'false' ) #if the logged in user is not employee and terms is not agreed
          flash[:terms] = 'terms'
          if(session[:hmm_user]) #f the user is logged in, takes to agree terms page
            redirect_to "/user_account/update_terms/"
          else #if the user is not logged in, takes to login page
            redirect_to "/familywebsite/login/#{params[:id]}" if params[:action]!='login'
          end
        elsif @family_website_owner.e_user_status=='blocked' #displays message, if the user is blocked
          render :text => "This Familywebsite has been Blocked. Please contact Website Administrator at <a href='mailto:admin@holdmymemories.com' >admin@HoldMyMemories.com</a>"
        elsif session[:visitor]==nil && session[:hmm_user]==nil && @family_website_owner.password_required == 'yes'
          #render :text =>"Password protected. Redirect to family website login page"
          redirect_to :controller =>"familywebsite", :action => 'visitor_login', :id => params[:id], :redirect_url => request.url if (params[:action]!='login' && params[:action]!='visitor_login')
        else
          @path = ContentPath.find(:first, :conditions => "status='active'")
          if(params[:id]=='bob')
            @content_server_url = "http://content.holdmymemories.com"
          else
            @content_server_url = @path.content_path
          end

          return true #returns true if all the conditions are cleared
        end
      else
        redirect_to '/'
      end
    end
  end

   def redirect_url
    url= request.url.split("/")
    for i in 0..url.length
      if url[i]
        url[i]=url[i].upcase
        logger.info(url[i])
        if((url[i].match("<SCRIPT>")) || (url[i].match("</SCRIPT>")) || (url[i].match("</SCRIP>")) || (url[i].match("<SCRIP")) ||(url[i].match("JAVASCRIPT:ALERT"))||(url[i].match("%3C")))
          redirect_to "/nonexistent_page.html"
        end
      end
    end
  end

  def chapters
    @hmm_user = HmmUser.find(:first, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}') and e_user_status='unblocked'")
    if(@hmm_user)
      items_per_page = 9
      sort_init 'd_updateddate'
      sort_update
      if(params[:sort_key]==nil)
        sort="order_num  asc"
      else
        sort="#{params[:sort_key]}  #{params[:sort_order]}"
      end
      @tags = Tag.paginate  :per_page => items_per_page, :page => params[:page], :order => sort, :conditions => "uid='#{@hmm_user.id}' and status='active' and e_access ='public'"
      @countcheck=Tag.count(:all,:conditions => "uid=#{@hmm_user. id} and status='active' and e_access ='public'")
    end
  end

  def subchapters
    #unless params[:chapter_id].blank?
      items_per_page = 9
      sort_init 'd_updated_on'
      sort_update
      if(!params[:chapter_id].nil?)
        session[:chapter_id]=params[:chapter_id]
      else
        params[:chapter_id]= session[:chapter_id]
      end
      if(params[:sort_key]==nil)
        sort="order_num  asc"
      else
        sort="#{params[:sort_key]}  #{params[:sort_order]}"
      end


      @sub_chapters = SubChapter.paginate :per_page => items_per_page, :page => params[:page], :conditions => "tagid='#{params[:chapter_id]}' and status='active' and e_access ='public'" , :order => sort

      @countcheck=SubChapter.count(:all,:conditions => "tagid='#{params[:chapter_id]}' and status='active' and e_access ='public'")

      #@chapter_journal = ChapterJournal.find(:all, :conditions => "tag_id='#{params[:chapter_id]}'", :order=>"id DESC")
      #@chap_cnt = ChapterJournal.count(:all, :conditions => "tag_id='#{params[:chapter_id]}'")
      @chapter = Tag.find(params[:chapter_id],:select => "tags.v_tagname as chapter_name,tags.id as chapter_id,tags.tag_type,tags.v_chapimage as chapter_image,tags.img_url as chapter_image_url")
      if(@chapter.tag_type!='mobile_uploads')
      @chapter = Tag.find :first, :joins => "INNER JOIN sub_chapters ON sub_chapters.tagid = tags.id INNER JOIN galleries ON galleries.subchapter_id = sub_chapters.id",:conditions => "tags.id=#{params[:chapter_id]}",
        :select =>"tags.v_tagname as chapter_name,tags.id as chapter_id,sub_chapters.id as subchapter_id,sub_chapters.sub_chapname as subchapter_name,galleries.id as gallery_id,tags.tag_type"
      #@blog = ChapterJournal.find(:first, :conditions => "tag_id=#{params[:chapter_id]}", :select => "v_tag_title as blog_title,v_tag_journal as blog_content,d_created_at as blog_date")
      end
      @blog = Blog.find(:first, :conditions => "blog_type_id=#{params[:chapter_id]} and blog_type='chapter'", :select => "title as blog_title,description as blog_content,created_at as blog_date")
      @comments = ChapterComment.find(:all, :conditions => "e_approval = 'approve' and tag_id = #{params[:chapter_id]}", :order => "id asc", :select =>"v_comment as comment,v_name as commenter,d_created_on as commented_date")

#    else
#      redirect_to :action => 'home', :id => params[:id]
#    end
  end

  def galleries
    #unless params[:subchapter_id].blank?
      items_per_page = 9
      sort_init 'd_updated_on'
      sort_update
      if(params[:sort_key]==nil)
        sort="order_num  asc"
      else
        sort="#{params[:sort_key]}  #{params[:sort_order]}"
      end
      if(!params[:subchapter_id].nil?)
        session[:subchapter_id]=params[:subchapter_id]
      else
        params[:subchapter_id]= session[:subchapter_id]
      end
      @sub_chapter_journal = SubChapJournal.find(:all, :conditions => "sub_chap_id=#{params[:subchapter_id]}", :order=>"id DESC")
      @galleries = Galleries.paginate :per_page => items_per_page, :page => params[:page], :conditions => "subchapter_id=#{params[:subchapter_id]} and status='active' and e_gallery_acess='public'" ,:order => sort
      @countcheck=Galleries.count(:all, :conditions => "subchapter_id=#{params[:subchapter_id]} and status='active' and e_gallery_acess='public'")
      @detail = Tag.find :first, :joins => "INNER JOIN sub_chapters ON sub_chapters.tagid = tags.id",:conditions => "sub_chapters.id=#{params[:subchapter_id]}",
        :select =>"tags.v_tagname as chapter_name,tags.id as chapter_id,sub_chapters.id as subchapter_id,sub_chapters.sub_chapname as subchapter_name"
      #@blog = SubChapJournal.find(:first, :conditions => "sub_chap_id = #{params[:subchapter_id]}", :select => "journal_title as blog_title,subchap_journal as blog_content,created_on as blog_date")
      @blog = Blog.find(:first, :conditions => "blog_type_id=#{params[:subchapter_id]} and blog_type='subchapter'", :select => "title as blog_title,description as blog_content,created_at as blog_date")
      @comments = SubchapComment.find(:all, :conditions => "e_approval = 'approve' and subchap_id = #{params[:subchapter_id]}", :order => "id asc", :select =>"v_comments as comment,v_name as commenter,d_created_on as commented_date")
#    else
#      redirect_to :action => 'home', :id => params[:id]
#    end
  end

  def gallery_contents
   # unless params[:gallery_id].blank?
      items_per_page = 9
      sort_init 'd_updated_on'
      sort_update
      if(params[:sort_key]==nil)
        sort="order_num  asc"
      else
        sort="#{params[:sort_key]}  #{params[:sort_order]}"
      end
      if(!params[:gallery_id].nil?)
        session[:gallery_id]=params[:gallery_id]
      else
        params[:gallery_id]= session[:gallery_id]
      end
      @gallery  = Galleries.find(:all, :conditions => "id=#{params[:gallery_id]}", :order => "order_num ASC")
      @gallery_journal = GalleryJournal.find(:all, :conditions => "galerry_id=#{params[:gallery_id]}", :order=>"id DESC")
      @user_content = UserContent.paginate :per_page => items_per_page, :page => params[:page], :conditions=>"gallery_id=#{params[:gallery_id]}  and status='active' and e_access ='public'", :order => sort
      @countcheck=UserContent.count(:all, :conditions => "gallery_id=#{params[:gallery_id]} and status='active' and e_access ='public'")
      @detail = Tag.find :first, :joins => "INNER JOIN sub_chapters ON sub_chapters.tagid = tags.id INNER JOIN galleries ON galleries.subchapter_id = sub_chapters.id",:conditions => "galleries.id=#{params[:gallery_id]}",
        :select =>"tags.v_tagname as chapter_name,tags.id as chapter_id,sub_chapters.id as subchapter_id,sub_chapters.sub_chapname as subchapter_name,galleries.v_gallery_name as gallery_name,tags.tag_type as chapter_type,galleries.e_gallery_type as gallery_type,galleries.id as gallery_id"
      logger.info "count #{@countcheck}"
      #@blog = GalleryJournal.find(:first, :conditions => "galerry_id = #{params[:gallery_id]}", :select => "v_title as blog_title,v_journal as blog_content,d_created_on as blog_date")
     @blog = Blog.find(:first, :conditions => "blog_type_id=#{params[:gallery_id]} and blog_type='gallery'", :select => "title as blog_title,description as blog_content,created_at as blog_date")
     @comments = GalleryComment.find(:all, :conditions => "e_approval = 'approve' and gallery_id = #{params[:gallery_id]}", :order => "id asc", :select =>"v_comment as comment,v_name as commenter,d_created_on as commented_date")
#    else
#      redirect_to :action => 'home', :id => params[:id]
#    end
  end
end