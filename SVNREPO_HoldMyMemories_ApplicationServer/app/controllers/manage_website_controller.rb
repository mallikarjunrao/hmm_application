class ManageWebsiteController < ApplicationController

  include SortHelper
  helper :sort
  include SortHelper
  require 'will_paginate'
  layout 'familywebsite'
  require 'will_paginate'
  include SortHelper
  helper :sort
  include SortHelper
  before_filter  :check_account #checks for valid family name, terms of use check and user block check

  def initialize()
    @current_page = 'manage my site'
    @hide_float_menu = true
  end
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
        elsif !session[:hmm_user] || logged_in_hmm_user.id!=@family_website_owner.id
          redirect_to "/familywebsite/login/#{params[:id]}"
        else
          @path = ContentPath.find(:first, :conditions => "status='active'")
          @content_server_url = @path.content_path
          @content_server_name = @path.proxyname
          return true #returns true if all the conditions are cleared
        end
      else
        redirect_to '/'
      end
    end
  end


  def home
    @current_item = 'home'

    HmmUser.update(logged_in_hmm_user.id,:msg =>'1') if params[:msg]=='1'
    HmmUser.update(logged_in_hmm_user.id,:msg =>'1') if params[:msg]=='2'

    @total = FamilyFriend.count(:all,:conditions => "fid=#{logged_in_hmm_user.id} and status='pending' ")

    @total1 = Share.count(:all, :joins=>"as b , hmm_users as a ",
      :conditions => "a.id=#{logged_in_hmm_user.id} and b.email_list LIKE '%#{logged_in_hmm_user.v_e_mail}%' and shown='false'")   #

    #contest entry approval alert
    @contest_image = Contest.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and moment_type='image' and status='active'")
    @contest_image_details = Contest.find(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and moment_type='image' and status='active'")
    for n in @contest_image_details
      @moment_id = n.moment_id
    end
    @contest_video = Contest.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and moment_type='video' and status='active'")

    @share_journal = 0 #ShareJournal.count(:all, :joins => "as a, hmm_users as b", :conditions => "b.id=#{logged_in_hmm_user.id} and a.e_mail = '#{logged_in_hmm_user.v_e_mail}' and DATE_FORMAT(a.expiry_date,'%Y-%m-%d') >= curdate() and shown='false'")  #
    @sharemomentcnt = 0# ShareMoment.count(:all, :joins => "as a, hmm_users as b", :conditions => "b.id=#{logged_in_hmm_user.id} and a.email=b.v_e_mail and DATE_FORMAT(a.expiry_date,'%Y-%m-%d') >= curdate() and shown='false' and status = 'pending'")  #
    #@total1 = Share.count(:all,:conditions => "presenter_id=#{logged_in_hmm_user.id}  ")
    @total2 = 0 #Export.count(:all,:conditions => "exported_to=#{logged_in_hmm_user.id} and status='pending'")

    # @sharejournalcomment=ShareJournalcomment.count(:all, :conditions => "presenter_id=#{logged_in_hmm_user.id} and DATE_FORMAT(comment_date, '%Y-%m-%d' ) = CURDATE() and status='pending'")
    @sharejournalcomment=ShareJournalcomment.count(:all, :joins => "as a, share_journals as b", :conditions => "b.id=a.shareid and b.presenter_id=#{logged_in_hmm_user.id} and a.status='pending'")
    @sharemomentcomment = 0#ShareMomentcomment.count(:all, :joins => "as a, share_moments as b", :conditions => "b.id=a.share_id and b.presenter_id=#{logged_in_hmm_user.id} and DATE_FORMAT(a.added_date, '%Y-%m-%d' ) = CURDATE() and a.e_approved='pending'")
    @chapcmt = Tag.count(:all, :joins=>"as a, chapter_comments as b  WHERE b.tag_id=a.id and a.uid='#{logged_in_hmm_user.id}' and b.e_approval='pending'")
    @subcmt = SubChapter.count(:all, :joins=>"as a, subchap_comments as b  WHERE b.subchap_id=a.id and a.uid='#{logged_in_hmm_user.id}' and b.e_approval='pending'")
    @galcmt = Galleries.count(:all, :joins=>"as a, gallery_comments AS b, sub_chapters AS c  WHERE b.gallery_id = a.id and a.subchapter_id = c.id and c.uid ='#{logged_in_hmm_user.id}' and b.e_approval='pending'")
    @momentcmt = UserContent.count(:all, :joins=>"as a, photo_comments as b  WHERE b.user_content_id = a.id and a.uid='#{logged_in_hmm_user.id}' and b.e_approved='pending'")
    @guestcmt = GuestComment.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and status='pending' ")
    @sharecmt = 0 #ShareComments.count(:all, :joins => "as a, shares as b", :conditions => "a.share_id=b.id and b.presenter_id='#{logged_in_hmm_user.id}' and DATE_FORMAT( a.d_add_date, '%Y-%m-%d' ) = CURDATE() and a.e_approved='pending' ")
    @msgboardcmt = MessageBoard.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and status='pending' ")
    @blogcmt = Blog.count(:all,:joins=>" as a , blog_comments as b", :conditions => "a.id=b.blog_id and a.user_id='#{logged_in_hmm_user.id}' and b.status='pending' ")

    @total_comments = (@chapcmt + @subcmt + @galcmt + @momentcmt +  @msgboardcmt + @sharejournalcomment + @blogcmt)
    @total_alertcount = (@chapcmt + @subcmt + @galcmt + @momentcmt + @guestcmt + @msgboardcmt + @sharejournalcomment + @blogcmt)

    @creditpt=CreditPoint.find(:first,:conditions=>"user_id=#{logged_in_hmm_user.id}")
    @cp=CreditPoint.count(:all,:conditions=>"user_id=#{logged_in_hmm_user.id}")
    @studio_groups=HmmUser.find(:first,:select => "a.*,b.*,c.*,d.* ", :joins =>"as a ,employe_accounts as b,hmm_studios as c,hmm_studiogroups  as d ",:conditions => "a.id=#{logged_in_hmm_user.id} and b.id=a.emp_id and b.store_id=c.id and c.studio_groupid=d.id ")
    now = Time.now
    @check_date = now.strftime("%Y-%m-%d")
    unless @studio_groups.blank?
      unless @studio_groups.account_expdate.blank?
        if  @cp == 0 || (@studio_groups.account_expdate < @check_date.to_date )
          @creditpt_count=0
        else
          @creditpt_count=1
        end
      else
        if  @cp == 0
          @creditpt_count=0
        else
          @creditpt_count=1
        end
      end
    end


    session[:alert] = nil
  end

  def get_proxy_urls
    proxyurls = nil
    contentservers = ContentPath.find(:all)
    for server in contentservers
      if(proxyurls == nil)
        proxyurls = server['content_path']
      else
        proxyurls = proxyurls +','+server['content_path']
      end
    end
    return proxyurls
  end

  def file_manager
    @current_item = 'file manager'
    @proxyurls = get_proxy_urls()
    @versions=VersionDetail.find(:first,:conditions=>"file_url='/flash/release/AlbumUploadNew.swf'")
  end

  def classic_upload
    @proxyurls = get_proxy_urls()
  end

  def organize
    @current_item = 'organize'
    @proxyurls = get_proxy_urls()
  end

  def create_slideshow
    @current_item = 'create slideshow'
    @versions=VersionDetail.find(:first,:conditions=>"file_url='/flash/release/SlideShowCreator.swf'")
  end

  def edit_profile

    @current_item = 'edit_profile'
    @hmm_user = HmmUser.find(logged_in_hmm_user.id)
    if params[:sucess].nil?
    else
      flash[:notice] = 'Your Profile information has been Successfully Updated.'
    end


    @get_content_url=ContentPath.find(:all, :conditions => "status='active'")
    @content_path=@get_content_url[0]['content_path']
    servername=@get_content_url[0]['proxyname']


    @user_det=HmmUser.find(logged_in_hmm_user.id)

    #chapters
    @familyvactioncnt=Tag.count(:all,:conditions=>"v_tagname='Family Vacations' and uid=#{logged_in_hmm_user.id}")

    if(@familyvactioncnt>0)
      @familyvaction=Tag.find(:first,:conditions=>"v_tagname='Family Vacations' and uid=#{logged_in_hmm_user.id}")
      @v=@familyvaction.id
    else
      @v=0
    end

    @familyholidaycnt=Tag.count(:all,:conditions=>"v_tagname='Family Holidays' and uid=#{logged_in_hmm_user.id}")

    if(@familyholidaycnt>0)
      @familyholiday=Tag.find(:first,:conditions=>"v_tagname='Family Holidays' and uid=#{logged_in_hmm_user.id}")
      @h=@familyholiday.id
    else
      @h=0
    end

    @familyeventcnt=Tag.count(:all,:conditions=>"v_tagname='Family Events' and uid=#{logged_in_hmm_user.id}")

    if(@familyeventcnt>0)
      @familyevent=Tag.find(:first,:conditions=>"v_tagname='Family Events' and uid=#{logged_in_hmm_user.id}")
      @e=@familyevent.id
    else
      @e=0
    end


    #subchapters
    @vacations=SubChapter.count(:all,:conditions=>"sub_chapname='Vacations' and tagid=#{@v} and uid=#{logged_in_hmm_user.id}")

    @newyear=SubChapter.count(:all,:conditions=>"sub_chapname='New Year' and tagid=#{@h} and uid=#{logged_in_hmm_user.id}")
    @christmas=SubChapter.count(:all,:conditions=>"sub_chapname='Christmas' and tagid=#{@h} and uid=#{logged_in_hmm_user.id}")
    @hanukkah=SubChapter.count(:all,:conditions=>"sub_chapname='Hanukkah' and tagid=#{@h} and uid=#{logged_in_hmm_user.id}")
    @thanksgiving=SubChapter.count(:all,:conditions=>"sub_chapname='Thanksgiving' and tagid=#{@h} and uid=#{logged_in_hmm_user.id}")
    @easter=SubChapter.count(:all,:conditions=>"sub_chapname='Easter' and tagid=#{@h} and uid=#{logged_in_hmm_user.id}")

    @birthdayparties=SubChapter.count(:all,:conditions=>"sub_chapname='Birthday Parties' and tagid=#{@e} and uid=#{logged_in_hmm_user.id}")
    @gettogethers=SubChapter.count(:all,:conditions=>"sub_chapname='Get Togethers' and tagid=#{@e} and uid=#{logged_in_hmm_user.id}")


    if(params[:sub]!='' && params[:sub]!=nil)

      if(params[:vocation]=="1")

        createeventchapter("Family Vacations",@content_path)
        createeventsubchapter("Family Vacations","Vacations",@content_path)
      end

      if(params[:holidays]=="1")
        createeventchapter("Family Holidays",@content_path)

        if(params[:newyear]=="1")
          createeventsubchapter("Family Holidays","New Year",@content_path)
        end

        if(params[:cristmas]=="1")
          createeventsubchapter("Family Holidays","Christmas",@content_path)
        end

        if(params[:hanukkah]=="1")
          createeventsubchapter("Family Holidays","Hanukkah",@content_path)
        end

        if(params[:thanksgiving]=="1")
          createeventsubchapter("Family Holidays","Thanksgiving",@content_path)
        end

        if(params[:easter]=="1")
          createeventsubchapter("Family Holidays","Easter",@content_path)
        end

        if(params[:eid]=="1")
          createeventsubchapter("Family Holidays","Eid",@content_path)
        end
      end

      if(params[:events]=="1")
        createeventchapter("Family Events",@content_path)
        if(params[:birthday]=="1")
          createeventsubchapter("Family Events","Birthday Parties",@content_path)
        end
        if(params[:gettogether]=="1")
          createeventsubchapter("Family Events","Get Togethers",@content_path)
        end
      end
      flash[:notice] = "Updated successfully!"
      redirect_to :action => 'edit_profile'
    else
      render(:layout => true)
    end
  end

  def website_address
    @current_item="edit website address"
    unless params[:family_name].blank?
      family = HmmUser.find(:first, :conditions => "id!=#{logged_in_hmm_user.id} and (family_name like '#{removefamilySymbols(params[:family_name])}' or alt_family_name like '#{removefamilySymbols(params[:family_name])}')")
      unless family
        HmmUser.update(logged_in_hmm_user.id, :family_name => removefamilySymbols(params[:family_name]))
        logged_in_hmm_user.family_name = removefamilySymbols(params[:family_name])
        if params[:v]=="v4"
          flash[:address] = "Website address updated successfully!"
          redirect_to :controller=>"family_memory", :action => "edit_profile", :id => removefamilySymbols(params[:family_name])
        else
          flash[:error] = "Website address updated successfully!"
          redirect_to :action => "website_address", :id => removefamilySymbols(params[:family_name])
        end
      else
        if params[:v]=="v4"
          flash[:address] = "Family name already exists!"
          redirect_to :controller=>"family_memory", :action => "edit_profile", :id => logged_in_hmm_user.family_name
        else
          flash[:error] = "Family name already exists!"
        end
      end
    end
  end

  def themes
    @current_item="themes"
    unless params[:theme].blank?
      update = HmmUser.update(@family_website_owner.id, :theme_id => params[:theme])
      logged_in_hmm_user.theme_id = params[:theme]
      flash[:error] = "Theme updated successfully!"
      redirect_to :action => "themes", :id => params[:id] if update
    else
      #@themes = Theme.find(:all,:conditions => "status='active'",:order=>"category_id")
      @themes = HmmUser.find(:all,:joins=>"RIGHT JOIN themes ON themes.id=hmm_users.theme_id",:select=>"COUNT(*) as cnt,themes.*",:conditions=>"themes.status='active' and themes.id!=1",:group=>"themes.id",:order=>"cnt desc")
      @theme_category=ThemeCategory.find(:all)
      @length=@theme_category.length
      i=1
      @length.times do if @length > 0
          if i==1
            @slider="#slider#{i} li"
            @controls="p#controls#{i}"
            @prevnextbtn="#prevBtn#{i}, #nextBtn#{i}"
            @nextbtn="#nextBtn#{i}"
            @prevbtna="#prevBtn#{i} a, #nextBtn#{i} a"
            @nextbtna="#nextBtn#{i} a"
          else
            @slider= @slider.concat(",#slider#{i} li")
            @controls=@controls.concat(",p#controls#{i}")
            @prevnextbtn=@prevnextbtn.concat(",#prevBtn#{i}, #nextBtn#{i}")
            @nextbtn=@nextbtn.concat(",#nextBtn#{i}")
            @prevbtna=@prevbtna.concat(",#prevBtn#{i} a, #nextBtn#{i} a")
            @nextbtna=@nextbtna.concat(",#nextBtn#{i} a")
          end
          i=i+1
        end
      end
    end
  end

  def account_settings

  end




  def password_settings
    @current_item="password settings"
  end

  def admin_password
    @current_item="password settings"
    unless params[:password].blank? && params[:old_password].blank?
      check = HmmUser.find(:first, :conditions => "id =#{@family_website_owner.id} and v_password like '#{params[:old_password]}'")
      if check
        sql = ActiveRecord::Base.connection();
        sql.update "UPDATE hmm_users SET v_password='#{params[:password]}' WHERE id=#{logged_in_hmm_user.id}";
        #HmmUser.update(@family_website_owner.id,:v_password => "#{params[:password]}")
        flash[:notice] = 'Admin password changed successfully!'
      else
        flash[:notice] = 'Please enter correct current password!'
      end
    end
    if params[:v]=="v4"
      flash[:admin_pass] = 'Admin password changed successfully!'
      redirect_to :controller=>"family_memory", :action => 'edit_profile', :id => params[:id]
    end
  end

  def website_password
    @current_item="password settings"
    unless params[:password_required].blank?
      HmmUser.update(logged_in_hmm_user.id,:password_required => params[:password_required])
      HmmUser.update(logged_in_hmm_user.id,:familywebsite_password => params[:password]) if (params[:password_required]=='yes')

      if params[:v]=="v4"
        flash[:web_pass] = "Changes updated successfully!"
        redirect_to :controller=>"family_memory", :action => 'edit_profile', :id => params[:id]
      else
        flash[:notice] = "Changes updated successfully!"
        redirect_to :action => 'website_password', :id => params[:id]
      end

    end
  end

  def website_header
    @current_item="website header"
  end

  def credit_more
    @creditpt=CreditPoint.find(:first,:conditions=>"user_id=#{logged_in_hmm_user.id}")
    @studio_groups=HmmUser.find(:first,:select => "a.*,b.*,c.*,c.studio_logo as logo,d.* ", :joins =>"as a ,employe_accounts as b,hmm_studios as c,hmm_studiogroups  as d ",:conditions => "a.id=#{logged_in_hmm_user.id} and b.id=a.emp_id and b.store_id=c.id and c.studio_groupid=d.id ")
    if @studio_groups.credit_percentage == nil
      @percentage=0
    else
      @percentage=@studio_groups.credit_percentage
    end
    render :layout => false
  end

  def wizard_location
    @current_item="customizesite"

    @get_content_url=ContentPath.find(:all, :conditions => "status='active'")
    @content_path=@get_content_url[0]['content_path']
    servername=@get_content_url[0]['proxyname']

    @user_det=HmmUser.find(logged_in_hmm_user.id)

    #chapters
    @familyvactioncnt=Tag.count(:all,:conditions=>"v_tagname='Family Vacations' and uid=#{logged_in_hmm_user.id}")

    if(@familyvactioncnt>0)
      @familyvaction=Tag.find(:first,:conditions=>"v_tagname='Family Vacations' and uid=#{logged_in_hmm_user.id}")
      @v=@familyvaction.id
    else
      @v=0
    end

    @familyholidaycnt=Tag.count(:all,:conditions=>"v_tagname='Family Holidays' and uid=#{logged_in_hmm_user.id}")

    if(@familyholidaycnt>0)
      @familyholiday=Tag.find(:first,:conditions=>"v_tagname='Family Holidays' and uid=#{logged_in_hmm_user.id}")
      @h=@familyholiday.id
    else
      @h=0
    end

    @familyeventcnt=Tag.count(:all,:conditions=>"v_tagname='Family Events' and uid=#{logged_in_hmm_user.id}")

    if(@familyeventcnt>0)
      @familyevent=Tag.find(:first,:conditions=>"v_tagname='Family Events' and uid=#{logged_in_hmm_user.id}")
      @e=@familyevent.id
    else
      @e=0
    end


    #subchapters
    @vacations=SubChapter.count(:all,:conditions=>"sub_chapname='Vacations' and tagid=#{@v} and uid=#{logged_in_hmm_user.id}")

    @newyear=SubChapter.count(:all,:conditions=>"sub_chapname='New Year' and tagid=#{@h} and uid=#{logged_in_hmm_user.id}")
    @christmas=SubChapter.count(:all,:conditions=>"sub_chapname='Christmas' and tagid=#{@h} and uid=#{logged_in_hmm_user.id}")
    @hanukah=SubChapter.count(:all,:conditions=>"sub_chapname='Hanukah' and tagid=#{@h} and uid=#{logged_in_hmm_user.id}")
    @thanksgiving=SubChapter.count(:all,:conditions=>"sub_chapname='Thanksgiving' and tagid=#{@h} and uid=#{logged_in_hmm_user.id}")
    @easter=SubChapter.count(:all,:conditions=>"sub_chapname='Easter' and tagid=#{@h} and uid=#{logged_in_hmm_user.id}")

    @birthdayparties=SubChapter.count(:all,:conditions=>"sub_chapname='Birthday Parties' and tagid=#{@e} and uid=#{logged_in_hmm_user.id}")
    @gettogethers=SubChapter.count(:all,:conditions=>"sub_chapname='Get Togethers' and tagid=#{@e} and uid=#{logged_in_hmm_user.id}")


    if(params[:sub]!='' && params[:sub]!=nil)
      @user_det['v_abt_me']=params['v_abt_me']
      @user_det['v_link1']=params['v_link1']
      @user_det['v_link2']=params['v_link2']
      @user_det['v_link3']=params['v_link3']
      @user_det['about_family']=params['about_family']
      @user_det['family_history']=params['family_history']
      if(@user_det.save)

        if(params[:vocation]=="1")

          createeventchapter("Family Vacations",@content_path)
          createeventsubchapter("Family Vacations","Vacations",@content_path)
        end

        if(params[:holidays]=="1")
          createeventchapter("Family Holidays",@content_path)

          if(params[:newyear]=="1")
            createeventsubchapter("Family Holidays","New Year",@content_path)
          end

          if(params[:cristmas]=="1")
            createeventsubchapter("Family Holidays","Christmas",@content_path)
          end

          if(params[:hanukah]=="1")
            createeventsubchapter("Family Holidays","Hanukah",@content_path)
          end

          if(params[:thanksgiving]=="1")
            createeventsubchapter("Family Holidays","Thanksgiving",@content_path)
          end

          if(params[:easter]=="1")
            createeventsubchapter("Family Holidays","Easter",@content_path)
          end

          if(params[:eid]=="1")
            createeventsubchapter("Family Holidays","Eid",@content_path)
          end
        end

        if(params[:events]=="1")

          createeventchapter("Family Events",@content_path)
          if(params[:birthday]=="1")
            createeventsubchapter("Family Events","Birthday Parties",@content_path)
          end

          if(params[:gettogether]=="1")
            createeventsubchapter("Family Events","Get Togethers",@content_path)
          end

        end


        flash[:notice] = "Updated successfully!"
        redirect_to :action => 'wizard_location'
      end
    end
  end


  def createeventchapter(name,content_path)
    @get_content_url=ContentPath.find(:all, :conditions => "status='active'")
    content_path=@get_content_url[0]['content_path']
    t = Time.now
    @tag = Tag.new()
    @tag['v_tagname']=name
    @tag['uid']=logged_in_hmm_user.id
    @tag.e_access = 'public'
    @tag.e_visible = 'yes'
    @tag['d_updateddate']=Time.now
    @tag['d_createddate']=Time.now
    @tag['v_chapimage']="folder_img.png"
    @tag['img_url']=content_path
    @tag.save

  end


  def createeventsubchapter(chapname,subchapname,content_path)
    t = Time.now
    @get_content_url=ContentPath.find(:all, :conditions => "status='active'")
    content_path=@get_content_url[0]['content_path']
    @tagval = Tag.find(:all, :conditions => "uid=#{logged_in_hmm_user.id} and v_tagname='#{chapname}'")
    puts @tagval[0]['id']
    @sub_chapter = SubChapter.new

    @sub_chapter['uid']=logged_in_hmm_user.id
    @sub_chapter['tagid']=@tagval[0]['id']
    @sub_chapter['sub_chapname']=subchapname
    @sub_chapter['v_image']="folder_img.png"
    @sub_chapter['e_access']="public"
    @sub_chapter['d_updated_on'] = t
    @sub_chapter['d_created_on'] = t
    @sub_chapter['img_url']=content_path
    @sub_chapter.save

    @galleries_photo = Galleries.new()


    @galleries_photo['v_gallery_name']="Photo Gallery"
    @galleries_photo['e_gallery_type']="image"
    @galleries_photo['d_gallery_date']=Time.now
    @galleries_photo['e_gallery_acess']="public"
    @galleries_photo['v_gallery_image']="picture.png"
    @galleries_photo['subchapter_id']=@sub_chapter.id
    @galleries_photo['img_url']=content_path
    @galleries_photo.save

    @galleries_audio = Galleries.new()


    @galleries_audio['v_gallery_name']="Audio Gallery"
    @galleries_audio['e_gallery_type']="audio"
    @galleries_audio['d_gallery_date']=Time.now
    @galleries_audio['e_gallery_acess']="public"
    @galleries_audio['v_gallery_image']="audio.png"
    @galleries_audio['subchapter_id']=@sub_chapter.id
    @galleries_audio['img_url']=content_path
    @galleries_audio.save

    @galleries_video = Galleries.new()
    @galleries_video['v_gallery_name']="Video Gallery"
    @galleries_video['e_gallery_type']="video"
    @galleries_video['d_gallery_date']=Time.now
    @galleries_video['e_gallery_acess']="public"
    @galleries_video['v_gallery_image']="video.png"
    @galleries_video['subchapter_id']=@sub_chapter.id
    @galleries_video['img_url']=content_path
    @galleries_video.save

  end

  def image_import
    @current_item = 'imageimport'
    # render :layout => false
    #     f = File.new("#{RAILS_ROOT}/public/photos/test1.jpg", "w+")
    #     f = File.open("#{RAILS_ROOT}/public/photos/test1.jpg", "wb") { |f| f.write("http://photos-f.ak.fbcdn.net/hphotos-ak-snc3/hs572.snc3/31202_103243129722476_100001103691165_33707_4684095_t.jpg".read) }

    #    @contents = File.read('')
    #    File.open("", 'w') {|f| f.write(@contents) }
  end

  def fx_list_audio()
    @audio_ary = UserContent.find(:all, :select => "id,v_tagphoto as title,CONCAT(img_url,'/user_content/audios/',v_filename) as url", :conditions => "uid = #{session[:hmm_user]} and e_filetype = 'audio'")
    render :text => @audio_ary.to_json # render output
  end


end