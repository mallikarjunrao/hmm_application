class ManageSiteController < ApplicationController
  layout "myfamilywebsite"
  include SortHelper
  helper :sort
  include SortHelper
  include UserAccountHelper
  require 'rubygems'
  require 'base64'
  require 'money'
  require 'active_merchant'

   before_filter :login_check, :except => [:logged_momentdetails,:videomoment_details, :select_contestmoment, :vote_cal, :create_vote, :login_check,:mysite_authenticate,:mysite_login,:mysite_logout,:validate_familyname, :template1, :myimagePreview, :familywebsite_option, :upgrade, :upgrade_select, :upgrade_payment_family, :upgrade_payment_family_test, :upgrade1,:update_journal_photo,:update_gallery_journal,:update_chapter_journal,:update_subchap_journal ]
   require 'will_paginate'

  def initialize
     super

   end

   def upgrade
    session[:friend]=""
    @hmm_user=HmmUser.find(logged_in_hmm_user.id)

  end

  def upgrade1
    render(:layout => false)

  end

  def upgrade_select
    session[:friend]=""
  end

  def login_check #user login check for manage family website

     if session[:hmm_user]
       if(params[:familyname])
       params[:family_name]=params[:familyname]
      end
      if(params[:family_name]==nil)
        if(logged_in_hmm_user.family_name.downcase != params[:id].downcase)
        puts "first check"
           puts logged_in_hmm_user.family_name.downcase
           puts params[:id].downcase
           redirect_to :action=>'mysite_login',:id=>params[:id]
        end
       elsif(logged_in_hmm_user.family_name.downcase != params[:family_name].downcase)
        puts "second check"
           puts logged_in_hmm_user.family_name.downcase
           puts params[:family_name].downcase
           redirect_to :action=>'mysite_login',:id=>params[:family_name]
       end
    end
    unless session[:hmm_user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to :action => 'mysite_login', :id => params[:id]
      return false
    else
      hmm_payement_check = HmmUser.count(:all, :conditions => "id ='#{logged_in_hmm_user.id}' and account_expdate < CURDATE()")

      if (hmm_payement_check > 0 && request.request_uri != "/manage_site/upgrade/#{params[:id]}?atype=platinum_account&msg=payment_req")
        flash[:error] = "Your credit card payment to your HoldMyMemories.com has been declined by your credit card company. This could be for a number of reasons, including an expired card. <br><br><br>Please re-enter your credit card information, or use a different card for the renewal of your account."
        redirect_to "/manage_site/upgrade/#{params[:id]}?atype=platinum_account&msg=payment_req"
        return false
      end
    end




  end

  def mysite_authenticate
    self.logged_in_hmm_user = HmmUser.authenticate(params[:hmm_user][:v_user_name],params[:hmm_user][:v_password])
    #self.logged_in_hmm_user = HmmUser.authenticate("alok","alok")
    if is_userlogged_in?
      if logged_in_hmm_user.e_user_status == 'unblocked'
        #log file entry
        logger.info("[User]: #{params[:hmm_user][:v_user_name]} [Logged In] at #{Time.now} !")

        logger.info(logged_in_hmm_user.id)

        @client_ip = request.remote_ip
        @user_session = UserSessions.new()
        @user_session['i_ip_add'] = @client_ip
        @user_session['uid'] = logged_in_hmm_user.id
        @user_session['v_user_name'] = logged_in_hmm_user.v_user_name
        @user_session['d_date_time'] = Time.now
        @user_session['e_logged_in'] = "yes"
        @user_session['e_logged_out'] = "no"
        @user_session.save
        #  return "true"
        session[:alert] = "fnfalert"
        flag = 0
        cur_time=Time.now.strftime("%Y-%m-%d")
        hmm_user_check =  HmmUser.count(:all, :conditions =>" id='#{logged_in_hmm_user.id}' and (family_name='#{params[:familyname]}' or alt_family_name='#{params[:familyname]}')")
        if(hmm_user_check > 0)
          if(params[:family_name])
          pass_check=params[:family_name]
          else
          pass_check=params[:id]
          end

          session[:family]=pass_check
          hmm_terms_check = HmmUser.count(:all, :conditions => "id ='#{logged_in_hmm_user.id}' and terms_checked ='false'")
          if(session[:employe]==nil && hmm_terms_check > 0 )
            redirect_to "/user_account/update_terms/"
          else
            redirect_to :action => 'home', :id => params[:id]
          end

          return "false"
        else
          session[:hmm_user]=nil
          flash[:error] = " Invalid Login.You must be the owner of this site."
          #log file entry
          logger.error("[Invalid Login]: by [User]:#{params[:hmm_user][:v_user_name]} at #{Time.now}")
          redirect_to :action => 'mysite_login', :id => params[:id]
          return "false"
        end
      else
        session[:hmm_user]=nil
        flash[:error1] = "User is been blocked.. Contact Admin!!"
        redirect_to :action => 'mysite_login', :id => params[:id]
        return "false"
      end

    else
      flash[:error] = "I'm sorry; either your username or password was incorrect. Or You are not an owner of this site!"
      #log file entry
      logger.error("[Invalid Login]: by [User]:#{params[:hmm_user][:v_user_name]} at #{Time.now}")
      redirect_to :action => 'mysite_login', :id => params[:id]
      return "false"
    end
  end
  def mysite_logout
    if(session[:hmm_user])
      @user_session = UserSessions.new()
      if(logged_in_hmm_user.id)
        @user_session['uid'] = logged_in_hmm_user.id
      end
      if(logged_in_hmm_user.v_user_name)
        @user_session['v_user_name'] = logged_in_hmm_user.v_user_name
      end
    end
    #if request.post?

      reset_session
      flash[:notice] = "You Have Been Successfully logged out."
      @client_ip = request.remote_ip

      if(session[:hmm_user])
        @user_session['d_date_time'] = Time.now
        @user_session['i_ip_add'] = @client_ip
        @user_session['e_logged_in'] = "no"
        @user_session['e_logged_out'] = "yes"
        @user_session.save
      end
   # end
    #log file entry
    #logger.info("[User]: Logged Out at #{Time.now}")
    redirect_to :controller => 'my_familywebsite',:action => 'home', :id => params[:id]
  end

  def edit_profile
   @hmm_user = HmmUser.find(logged_in_hmm_user.id)
   @fnf_groups2 = FnfGroups.find(:all,:conditions=>"uid=#{logged_in_hmm_user.id}",:order=>"id DESC")
   if params[:sucess].nil?
   else
     flash[:notice] = 'Your Profile information has been Successfully Updated.'
   end
   render(:layout => true)
  end

  #functions To Display F&F OF the Logged In User
  def fnf_index
    items_per_page = 15
    uid=logged_in_hmm_user.id
    conditions1 = "uid=#{uid} and ((v_name LIKE '#{params[:query_hmm_user]}%' or v_email LIKE '#{params[:query_hmm_user]}%'))"


        @hmm_users_count = NonhmmUser.find(:all,:conditions =>"#{conditions1}",:group=>"v_email")
        @total=@hmm_users_count.size

       @hmm_users = NonhmmUser.paginate   :per_page => items_per_page,:page => params[:page],:group =>"v_email", :conditions => "uid=#{uid} and ((v_name LIKE '#{params[:query_hmm_user]}%' or v_email LIKE '#{params[:query_hmm_user]}%'))" ,:order => "v_name ASC"



  chkcond="uid=#{uid} and v_email='bob@s121.com'"
  @chktotal = NonhmmUser.count(:conditions =>  "#{chkcond}")

  if(@chktotal==0)
    @client_content = NonhmmUser.new()
    @client_content['uid']=uid
    @client_content['v_name']='Bob'
    @client_content['v_email']='Bob@s121.com'
    @client_content['v_city']=''
    @client_content['v_country']=''
    @client_content['invite']=''
    @client_content['v_street']=''
    @client_content['v_phone']=''
    @client_content.save
 end





   if request.xml_http_request?
      render :partial => "fnf_list", :layout => false
    end

  end

  #functions To create the video template
  def create
    @filename = params[:user_content][:v_filename].original_filename
    @user_content = UserContent.new(params[:user_content])
    post = UserContent.save2(params['user_content'])
    @user_content['v_filename']=@filename
    if @user_content.save
      flash[:notice] = 'UserContent was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def mysite_login

  end

  def edit_family_header
    @hmm_user = HmmUser.find(logged_in_hmm_user.id)
  end

  def home
    #if(!params[:id]) #if url doesn't have family name redirect it to message page
     # redirect_to :controller=>'my_familywebsite',:action => 'correct_familyname'
   # end
    @hmm_user = HmmUser.find(logged_in_hmm_user.id)

    sql = ActiveRecord::Base.connection();

   if params[:msg]=='1'
   sql.update "UPDATE hmm_users SET msg='1' WHERE id=#{logged_in_hmm_user.id}";
   end

   if params[:msg]=='2'
   sql.update "UPDATE hmm_users SET msg='0' WHERE id=#{logged_in_hmm_user.id}";
   end

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

    @total_comments = (@chapcmt + @subcmt + @galcmt + @momentcmt +  @msgboardcmt + @sharejournalcomment)
    @total_alertcount = (@chapcmt + @subcmt + @galcmt + @momentcmt + @guestcmt + @msgboardcmt + @sharejournalcomment )



    #sql.update "UPDATE exports SET shown='true' WHERE exported_from=#{logged_in_hmm_user.id}";
    #sql.update "UPDATE family_friends SET shown='true' WHERE fid=#{logged_in_hmm_user.id}";
    session[:alert] = nil

  end

  def edit_myprofile
    ps 'user id '+logged_in_hmm_user.id+' logged'
    @hmm_user = HmmUser.find(logged_in_hmm_user.id)
    require 'pp'
    pp @hmm_user
    @fnf_groups2 = FnfGroups.find(:all,:conditions=>"uid=#{logged_in_hmm_user.id}",:order=>"id DESC")
    if params[:sucess].nil?

    else
      flash[:notice] = 'Your Profile information has been Successfully Updated.'
    end
    render(:layout => true)
  end

  def choose_upload
    @upload_type = HmmUser.count(:all, :conditions => "id=#{logged_in_hmm_user.id} and upload_type='basic'")
    if @upload_type > 0
    else
      redirect_to(:action => "advance_upload", :id => params[:id])
    end
  end

  def advance_upload
    #get tag contents
    @get_content_url=ContentPath.find(:all, :conditions => "status='active'")
    @serverurl=@get_content_url[0]['content_path']
    @servername=@get_content_url[0]['proxyname']
    contentservers = ContentPath.find(:all)
    @proxyurls = nil
    for server in contentservers
      if(@proxyurls == nil)
        @proxyurls = server['content_path']
      else
        @proxyurls = @proxyurls +','+server['content_path']
      end
    end
    session[:friend]=''
    @tags = Tag.find(:all ,:conditions =>"uid=#{logged_in_hmm_user.id}")
    #get sub chapters

    @sub_chapters = SubChapter.find(:all ,:conditions =>"uid=#{logged_in_hmm_user.id}")
    @user_content = UserContent.new
    render :layout => true
  end

  def classic_upload
    #get tag contents
    @get_content_url=ContentPath.find(:all, :conditions => "status='active'")
    @serverurl=@get_content_url[0]['content_path']
    @servername=@get_content_url[0]['proxyname']
     contentservers = ContentPath.find(:all)
    @proxyurls = nil
    for server in contentservers
      if(@proxyurls == nil)
        @proxyurls = server['content_path']
      else
        @proxyurls = @proxyurls +','+server['content_path']
      end
    end
    session[:friend]=''
    @tags = Tag.find(:all ,:conditions =>"uid=#{logged_in_hmm_user.id}")
    #get sub chapters

    @sub_chapters = SubChapter.find(:all ,:conditions =>"uid=#{logged_in_hmm_user.id}")
    @user_content = UserContent.new
    render :layout => true
  end

  def basic_upload
    @get_content_url=ContentPath.find(:all, :conditions => "status='active'")
    @serverurl=@get_content_url[0]['content_path']
    @servername=@get_content_url[0]['proxyname']
    contentservers = ContentPath.find(:all)
    @proxyurls = nil
    for server in contentservers
      if(@proxyurls == nil)
        @proxyurls = server['content_path']
      else
        @proxyurls = @proxyurls +','+server['content_path']
      end
    end
  end

  def drag_drop
    #get tag contents
    @get_content_url=ContentPath.find(:all, :conditions => "status='active'")
    @serverurl=@get_content_url[0]['content_path']
    @servername=@get_content_url[0]['proxyname']
    contentservers = ContentPath.find(:all)
    @proxyurls = nil
    for server in contentservers
      if(@proxyurls == nil)
        @proxyurls = server['content_path']
      else
        @proxyurls = @proxyurls +','+server['content_path']
      end
    end
    session[:friend]=''
    @tags = Tag.find(:all ,:conditions =>"uid=#{logged_in_hmm_user.id}")
    #get sub chapters

    @sub_chapters = SubChapter.find(:all ,:conditions =>"uid=#{logged_in_hmm_user.id}")
    @user_content = UserContent.new
    render :layout => true
  end


  def comments_list

    @hmm_user=HmmUser.find(session[:hmm_user])

    uid1=logged_in_hmm_user.id

    tagcout = Tag.find_by_sql(" select
         count(*) as cnt
         from chapter_comments  as a,tags as t
         where
         a.tag_id=t.id
         and
         t.uid=#{uid1} ")
    subcount = SubChapter.find_by_sql("
       select
        count(*) as cnt
        from
        subchap_comments   as b,
        sub_chapters as s
        where
        s.uid=#{uid1}
        and
        b.subchap_id=s.id ")
    galcount = Galleries.find_by_sql("select
        count(*) as cnt
        from
        gallery_comments    as c,
        galleries as g,
        sub_chapters as s1
        where
        s1.uid=#{uid1}
        and
        c.gallery_id=g.id
        and g.subchapter_id=s1.id ")

    usercontentcount = UserContent.find_by_sql("
  select
       count(*) as cnt
        from
        photo_comments   as d,
        user_contents as u
        where
        d.user_content_id=u.id and u.uid=#{uid1}

  ")
    sharecount = Share.find_by_sql("
  select
       count(*) as cnt
        from
        share_comments    as d,
        shares as u
        where
        d.share_id =u.id and u.presenter_id=#{uid1}

  ")
    sharejournalcnt = ShareJournal.find_by_sql("
  select
    count(*) as cnt
    from
    share_journalcomments as d,
    share_journals as u
    where
    d.shareid = u.id and u.presenter_id=#{uid1}
    ")


    guestmessagecount = MessageBoard.count(:all, :conditions => "uid=#{uid1}")

    guestcommentcount = GuestComment.find_by_sql("
    select
    count(*) as cnt
    from
    guest_comments
    where
    uid=#{uid1}
    ")

    guestcommentcnt=Integer(guestcommentcount[0].cnt)
    galcnt=Integer(galcount[0].cnt)
    tagcnt=Integer(tagcout[0].cnt)
    subcnt=Integer(subcount[0].cnt)
    usercontentcnt=Integer(usercontentcount[0].cnt)
    sharecnt=Integer(sharecount[0].cnt)
    sharejournalcnt=Integer(sharejournalcnt[0].cnt)

    @total=tagcnt+subcnt+galcnt+usercontentcnt+sharecnt+sharejournalcnt+guestcommentcnt+guestmessagecount

    @numberofpagesres=@total/10

    @numberofpages=@numberofpagesres.round()

    if(params[:page]==nil)
      x=0
      y=10
      @page=0
      @nextpage=1
      if(@total<10)

        @nonext=1
      end
    else
      x=10*Integer(params[:page])
      y=10
      @page=Integer(params[:page])
      @nextpage=@page+1
      @previouspage=@page-1
      if(@page==@numberofpages)
        @nonext=1
      end

    end


    @tagid=ChapterComment.find_by_sql("
   (select

         a.id as id,
         a.tag_id as master_id,
         a.v_comment as comment,
         a.reply as reply,
         a.e_approval as e_approval,
         a.ctype as ctype,
         a.v_name as name,
         a.uid as user_id,
         a.d_created_on as d_created_at
         from chapter_comments as a,tags as t
         where
         a.tag_id=t.id
         and

         t.uid=#{uid1}
     )
     union
     (select

        b.id as id,
        b.subchap_id as master_id,
        b.v_comments as comment,
        b.reply as reply,
        b.e_approval as e_approval,
        b.ctype as ctype,
        b.v_name as name,
        b.uid as user_id,
        b.d_created_on as d_created_at
        from
        subchap_comments   as b,
        sub_chapters as s
        where
        s.uid=#{uid1}
        and
        b.subchap_id=s.id
     )
     union
     (select
        c.id as id,
        c.gallery_id as master_id,
        c.v_comment as comment,
        c.reply as reply,
        c.e_approval as e_approval,
        c.ctype as ctype,
        c.v_name as name,
        c.uid as user_id,
        c.d_created_on as d_created_at
        from
        gallery_comments    as c,
        galleries as g,
        sub_chapters as s1
        where
        s1.uid=#{uid1}
        and
        c.gallery_id=g.id
        and g.subchapter_id=s1.id)
     union
    (select
        d.id as id,
        d.user_content_id as master_id,
        d.v_comment as comment,
        d.reply as reply,
        d.e_approved as e_approval,
        d.ctype as ctype,
        d.v_name as name,
        d.uid as user_id,
        d.d_add_date as d_created_at
        from
        photo_comments  as d,
        user_contents as u
        where
        d.user_content_id=u.id
        and
        u.uid=#{uid1}
     )
     union
    (select
        d.id as id,
        d.share_id as master_id,
        d.comment as comment,
        d.reply as reply,
        d.e_approved as e_approval,
        d.reply as ctype,
        d.name as name,
        d.uid as user_id,
        d.d_add_date as d_add_date
        from
        share_comments as d,
        shares as s
        where
        d.share_id=s.id
        and
        s.presenter_id=#{uid1}
     )
     union
    (select
        p.id as id,
        p.share_id as master_id,
        p.comment as comment,
        p.reply as reply,
        p.e_approved as e_approval,
        p.ctype as ctype,
        p.name as name,
        p.uid as user_id,
        p.added_date as d_add_date
        from
        share_momentcomments as p,
        share_moments as q
        where
        p.share_id=q.id
        and
        q.presenter_id=#{uid1}
     )
      union
    (select
        r.id as id,
        r.shareid as master_id,
        r.comment as comment,
        r.reply as reply,
        r.status as e_approval,
        r.ctype as ctype,
        r.name as name,
        r.id as user_id,
        r.comment_date as d_add_date
        from
        share_journalcomments as r,
        share_journals as z
        where
        r.shareid=z.id
        and
        z.presenter_id=#{uid1}
     )
     union
    (select
        g.id as id,
        g.journal_typeid as master_id,
        g.comment as comment,
        g.ctype as reply,
        g.status as e_approval,
        g.ctype as ctype,
        g.name as name,
        g.uid as user_id,
        g.comment_date as d_add_date
        from
        guest_comments as g
        where
        g.uid=#{uid1}
     )
     union
    (select
        h.id as id,
        h.uid as master_id,
        h.message as message,
        h.reply as reply,
        h.status as e_approval,
        h.ctype as ctype,
        h.guest_name as name,
        h.uid as user_id,
        h.created_at as d_created_at
        from
        message_boards as h
        where
        h.uid=#{uid1}
     )
     order by d_created_at desc limit #{x}, #{y} ")



    puts x
    puts y


    if(params[:page]==nil)
    else
      render :layout => false
    end



  end

  def update_uploadtype
    sql = ActiveRecord::Base.connection()

    sql.update "UPDATE hmm_users SET upload_type='advance' WHERE id = '#{logged_in_hmm_user.id}'"
    redirect_to(:action => "advance_upload" , :id => params[:id])

  end

  def cutekid_contest
    @recent_entries = Contest.find_by_sql("SELECT a.*, b.* FROM contests as a, user_contents as b WHERE a.moment_id=b.id and a.moment_type = 'image' and a.status = 'active' order by a.new_votes desc limit 0,12")
  end

  def previous_contest
    @recent_entries = Contest.find_by_sql("SELECT a.*, b.* FROM contests as a, user_contents as b WHERE a.moment_id=b.id and a.moment_type = 'image' and a.status = 'active' order by a.new_votes desc limit 0,12")
  end

  def momentdetails_old_contest
    @moment_details = UserContent.find(:all, :conditions => "id='#{params[:momentid]}'")
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:momentid]}' ")
    @journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{params[:momentid]} ")
  end

  def videomoment_old_contest
    @moment_details = UserContent.find(:all, :conditions => "id='#{params[:momentid]}'")
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:momentid]}'")
    @journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{params[:momentid]} ")
  end

  def manage_journals_details
    @familyname=params[:id]
    @hmm_user=HmmUser.find(session[:hmm_user])

    # code to add new non_hmm users from e-mail text box
    if session[:nonhmm]
      if params[:email]
        @nonhmm = params[:email]
        @nonhmmids = @nonhmm.join(",")

        if params[:name]
          nonhmmna = params[:name]
          @nonhmmnames = nonhmmna.join(",")
        end
        frindsEmail=@nonhmmids.split(',')
        frindsName=@nonhmmnames.split(',')
        i=0

        #finding the size of an array
        emailsize=frindsEmail.size()
        namesize=frindsName.size()

        #loop to insert new nonHMM friends which are added through e-mail
        emailsize.times {|i|
          @addnonhmm = NonhmmUser.new()
          @addnonhmm['v_email'] = frindsEmail[i]
          @addnonhmm['v_name'] = frindsName[i]
          @addnonhmm['uid'] = logged_in_hmm_user.id
          @addnonhmm['v_city'] = 'edit city'
          @addnonhmm['v_country'] = 'edit country'
          @addnonhmm.save
        }
        session[:nonhmm] = nil #session nonhmm is killed
      end
    end

    #     for k in frindsEmail
    #       @addnonhmm = NonhmmUser.new()
    #       @addnonhmm['v_email'] = k
    #    j=k
    #    for j in frindsName
    #      @addnonhmm['v_name'] = j
    #
    #    end
    #
    #    end


    #add new friends code ends here


      uid1=logged_in_hmm_user.id


    tagcout = Tag.find_by_sql(" select
       count(*) as cnt
         from chapter_journals as a,tags as t
         where
         a.tag_id=t.id
         and
         t.uid=#{uid1} ")
    subcount = SubChapter.find_by_sql("
 select
        count(*) as cnt
        from
        sub_chap_journals  as b,
        sub_chapters as s
        where
        s.uid=#{uid1}
        and
        b.sub_chap_id=s.id
 "
    )
    galcount = Galleries.find_by_sql("select
        count(*) as cnt
        from
        gallery_journals   as c,
        galleries as g,
        sub_chapters as s1
        where
        s1.uid=#{uid1}
        and
        c.galerry_id=g.id
        and g.subchapter_id=s1.id ")

    usercontentcount = UserContent.find_by_sql("
  select
       count(*) as cnt
        from
        journals_photos   as d,
        user_contents as u
        where
        d.user_content_id=u.id and u.uid=#{uid1}

  ")
    galcnt=Integer(galcount[0].cnt)
    tagcnt=Integer(tagcout[0].cnt)
    subcnt=Integer(subcount[0].cnt)
    usercontentcnt=Integer(usercontentcount[0].cnt)

    @total=tagcnt+subcnt+galcnt+usercontentcnt

    @numberofpagesres=@total/10

    @numberofpages=@numberofpagesres.round()

    if(params[:page]==nil)
      x=0
      y=10
      @page=0
      @nextpage=1
      if(@total<=10)
        @nonext=1
      end
    else
      x=10*Integer(params[:page])
      y=10
      @page=Integer(params[:page])
      @nextpage=@page+1
      @previouspage=@page-1
      if(@page==@numberofpages)
        @nonext=1
      end

    end


    @tagid=ChapterJournal.find_by_sql("
   (select
        t.uid as uid,
         a.id as id,
         a.tag_id as master_id,
         a.v_tag_title as title,
         a.v_tag_journal as descr,
         a.jtype as jtype,
         a.d_created_at as d_created_at,
         a.d_updated_at as d_updated_at,
         t.img_url as img_url
         from chapter_journals as a,tags as t
         where
         a.tag_id=t.id
         and
         t.uid=#{uid1}
     )
     union
     (select
        s.uid as uid,
        b.id as id,
        b.sub_chap_id as master_id,
        b.journal_title as title,
        b.subchap_journal as descr,
        b.jtype as jtype,
        b.created_on as d_created_at,
        b.updated_on as d_updated_at,
        s.img_url as img_url
        from
        sub_chap_journals  as b,
        sub_chapters as s
        where
        s.uid=#{uid1}
        and
        b.sub_chap_id=s.id
     )
     union
     (select
        s1.uid as uid,
        c.id as id,
        c.galerry_id as master_id,
        c.v_title as title,
        c.v_journal as descr,
        c.jtype as jtype,
        c.d_created_on as d_created_at,
        c.d_updated_on as d_updated_on,
        g.img_url as img_url
        from
        gallery_journals   as c,
        galleries as g,
        sub_chapters as s1
        where
        s1.uid=#{uid1}
        and
        c.galerry_id=g.id
        and g.subchapter_id=s1.id)
     union
    (select
        u.uid as uid,
        d.id as id,
        d.user_content_id as master_id,
        d.v_title as title,
        d.v_image_comment as descr,
        d.jtype as jtype,
        d.date_added as d_created_at,
        d.date_added  as d_updated_on,
        u.img_url as img_url
        from
        journals_photos   as d,
        user_contents as u
        where
        d.user_content_id=u.id and u.uid=#{uid1}
     )
     order by d_created_at desc limit #{x}, #{y} ")

    #@tagid = ChapterJournal.paginating_sql_find(@cnt, sql, {:page_size => 10, :current => params[:page]})
    # @tagid1, @tagid = paginate_by_sql ChapterJournal, sql, 20





    if(params[:page]==nil)
    else
      render :layout => false
    end
  end

  def edit_photo_journal
    @journals_photoall = JournalsPhoto.find(:all, :conditions => "user_content_id= '#{params[:jid]}'")
    @usercontent = UserContent.find(params[:jid])
    if(@usercontent.e_filetype=='video' || @usercontent.e_filetype=='swf')
      @imgpath="/user_content/videos/thumbnails/#{@usercontent.v_filename}"+".jpg"
    else
      if(@usercontent.e_filetype=='image')
        @imgpath="/user_content/photos/small_thumb/#{@usercontent.v_filename}"
      else
        @imgpath="/user_content/audios/speaker.jpg"
      end
    end
    @imgname=@usercontent.v_tagphoto
    @ucontent_id=params[:jid]
    for j in @journals_photoall
      params[:jid]=j.id
      @journals_photo=JournalsPhoto.find(params[:jid])
    end

  end
  def update_journal_photo
    @journals_photo = JournalsPhoto.find(params[:jid])
    params['journals_photo']['date_added']=Time.now
    #params['journals_photo']['updated_date']=Time.now
    if @journals_photo.update_attributes(params[:journals_photo])
      flash[:notice] = 'Journal updated!'
      redirect_to  :action => 'manage_journals_details' , :id => params[:familyname]
    else
      redirect_to  :action => 'manage_journals_details' , :id => params[:familyname]
  end
end

def edit_chapter_journal
  @chapter_journal = ChapterJournal.find(params[:jid])

  @chap_j = ChapterJournal.find(:all, :select => "a.*, b.*", :joins => "as a , tags as b", :conditions => "a.tag_id=b.id and a.id=#{params[:jid]}")
end

def update_chapter_journal

  @chapter_journal = ChapterJournal.find(params[:jid])
  @chapter_journal['d_updated_at']=Time.now
  @chapter_journal['d_created_at']=Time.now

  if @chapter_journal.update_attributes(params[:chapter_journal])

    #@chapter_journal['d_created_at']=Time.now

    @chap_j = ChapterJournal.find(:all, :select => "a.*,b.*", :joins => "as a , tags as b", :conditions => "a.id=#{params[:jid]} and a.tag_id=b.id")
    $notice2
    flash[:notice] = 'Chapter Journal updated!'


    redirect_to  :action => 'manage_journals_details', :id => params[:family_name]
  else
    render :action => 'edit_chapter_journal',:id => params[:family_name], :jid => params[:jid]
  end
end

def edit_gallery_journal
  @gallery_journal = GalleryJournal.find(params[:jid])
  @gal_j = GalleryJournal.find(:all, :select => "a.*,b.*",:joins => "as a , galleries as b", :conditions => "a.galerry_id=b.id and a.id=#{params[:jid]}")
end

def update_gallery_journal
  family= logged_in_hmm_user.family_name
  @gallery_journal = GalleryJournal.find(params[:jid])
  @gallery_journal['d_updated_on']=Time.now
  @gallery_journal['d_created_on']=Time.now
  if @gallery_journal.update_attributes(params[:gallery_journal])



    redirect_to  :action => 'manage_journals_details', :id => family

  else
    render :action => 'edit_gallery_journal', :id => family, :jid => params[:jid]
  end
end

def edit_subchap_journal
  @sub_chap_journal = SubChapJournal.find(params[:jid])
  @subchap_j = SubChapJournal.find(:all,:select =>"a.*,b.*", :joins => "as a , sub_chapters as b", :conditions => "a.sub_chap_id=b.id and a.id=#{params[:jid]}")
end

def update_subchap_journal
  @sub_chap_journal = SubChapJournal.find(params[:jid])
  @sub_chap_journal['d_updated_on']=Time.now
  @sub_chap_journal['created_on']=Time.now
  if @sub_chap_journal.update_attributes(params[:sub_chap_journal])



    flash[:notice_sce] = 'Sub-Chapter Journal Updated!'
    flash[:notice] = 'Sub-Chapter Journal Updated!'

    redirect_to  :action => 'manage_journals_details', :id => params[:familyname]


  else
    render :action => 'edit', :id => params[:familyname], :jid => params[:jid]
  end
end

def manage_biography
  if params[:sucess].nil?
  else
    flash[:notice] = 'Family Information was successfully updated.'
    flash[:notice_website] = 'Congratulations! Your Family Website was successfully created.'
  end
end

def show_biography
  @family_members = FamilyMember.find(:all, :conditions => "id=#{params[:member_id]}")
  @uid=logged_in_hmm_user.id
  @family_member = FamilyMember.find(params[:member_id])
end

def edit_biography
  @family_member = FamilyMember.find(params[:member_id])
end

def delete_biography
  FamilyMember.find(params[:member_id]).destroy
  redirect_to :action => 'manage_biography',:id => params[:id]
end

def moveup_biography
  previousid=params[:prev]
  currentid=params[:currentid]
  famax =  FamilyMember.find_by_sql("select max(id) as m from family_members")
  if(famax[0]['m']=='')
    fa_next_id=1
  else
    famax=famax[0]['m']
    fa_next_id= Integer(famax) + 1
  end

  sql = ActiveRecord::Base.connection();
  sql.update "UPDATE family_members SET id = #{fa_next_id}  WHERE id =#{currentid}";

  sql.update "UPDATE family_members SET id = #{currentid}  WHERE id =#{previousid}";

  sql.update "UPDATE family_members SET id = #{previousid}  WHERE id =#{fa_next_id}";
  redirect_to :action => 'manage_biography',:id=>params[:id]

end

def manage_biography
  if(params[:journals])
    redirect_to :action => 'manage_journals_details', :id => params[:id]
  else
  if params[:sucess].nil?
  else
    flash[:notice1] = 'Family Information was successfully updated.'
    flash[:notice_website] = 'Congratulations! Your Family Website was successfully created.'
  end
  end
end

def show_biography
  @family_members = FamilyMember.find(:all, :conditions => "id=#{params[:member_id]}")
  @uid=logged_in_hmm_user.id
  @family_member = FamilyMember.find(params[:member_id])
end

def edit_biography
  @family_member = FamilyMember.find(params[:member_id])
end

def delete_biography
  FamilyMember.find(params[:member_id]).destroy
  redirect_to :action => 'manage_biography',:id => params[:id]
end

def moveup_biography
  previousid=params[:prev]
  currentid=params[:currentid]
  famax =  FamilyMember.find_by_sql("select max(id) as m from family_members")
  if(famax[0]['m']=='')
    fa_next_id=1
  else
    famax=famax[0]['m']
    fa_next_id= Integer(famax) + 1
  end

  sql = ActiveRecord::Base.connection();
  sql.update "UPDATE family_members SET id = #{fa_next_id}  WHERE id =#{currentid}";

  sql.update "UPDATE family_members SET id = #{currentid}  WHERE id =#{previousid}";

  sql.update "UPDATE family_members SET id = #{previousid}  WHERE id =#{fa_next_id}";
  redirect_to :action => 'manage_biography',:id=>params[:id]

end

def phase2_contest

  end

def hmm_contest

end

  def contest_terms_conditions
    if params[:contest] == "memorable"
      @type = params[:contest]
      session[:contests_type] = "video"
    else params[:contest] == "cutekid"
      @type = params[:contest]
      session[:contests_type] = "image"
    end
  end

  def contest_chapter
    @hmm_user=HmmUser.find(session[:hmm_user])
    items_per_page = 9
    sort_init 'd_updateddate'
    sort_update

    @total = HmmUser.count(:all , :conditions =>  "id=#{logged_in_hmm_user.id}")
    @friend=HmmUser.find(logged_in_hmm_user.id)
    uid=@friend.id
    uid=logged_in_hmm_user.id
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if(srk==nil)
      sort="id  asc"
    end
    if session[:contests_type] == 'image'
      @album_list = 'photo'
    else
      @album_list = 'video'
    end
    @tags_pages  = Tag.paginate :per_page => items_per_page,:page => params[:page], :order => sort, :conditions => "uid='#{uid}' and status='active' and (tag_type ='#{@album_list}' or tag_type = 'chapter') " # ,:order => " #{@sort.to_s} #{@order.to_s} "

    if request.xml_http_request?
      render :partial => "chapters_list", :layout => false
    end
  end

  def contest_sub_chapter
      sort_init 'd_updated_on'
  sort_update
  if(!params[:tagid].nil?)
    session[:tag_id]=params[:tagid]
  else

   params[:tagid]= session[:tag_id]
  end
  if(!params[:tagtype].nil?)
    session[:tagtype]=params[:tagtype]
  else
    params[:tagtype]=session[:tagtype]
  end

    @chapter_belongs_to=Tag.find_by_sql("select a.*,b.* from tags as a,  hmm_users as b where a.id='#{params[:tagid]}' and  a.uid=b.id")


  @hmm_user=HmmUser.find(session[:hmm_user])
  items_per_page = 9
  conditions = ["v_tagname LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?


    uid=logged_in_hmm_user.id

  srk=params[:sort_key]
  sort="#{srk}  #{params[:sort_order]}"

  if( srk==nil)
     sort="id  desc"
   end

  if (params[:tagtype]=='chapter')

    @subchaps = SubChapter.paginate :per_page => items_per_page,:page => params[:page], :order => sort, :conditions => "tagid=#{params[:tagid]} and status='active' " # ,:order => " #{@sort.to_s} #{@order.to_s} "
 # @sub_chapters_pages, @sub_chapters = paginate :sub_chapters ,  :per_page => items_per_page, :conditions => "tagid=#{params[:tagid]} and status='active' " , :order => sort #:order => " #{@sort.to_s} #{@order.to_s} "
   countcheck=SubChapter.count(:all,:conditions => "tagid=#{params[:tagid]} and status='active'")

  @chapter_journal = ChapterJournal.find(:all, :conditions => "tag_id=#{params[:tagid]}", :order=>"id DESC")
  @tagid = ChapterJournal.find(:all, :conditions => "tag_id=#{params[:tagid]}")
  @chap_cnt = ChapterJournal.count(:all, :conditions => "tag_id=#{params[:tagid]}")
  @tag = Tag.find(params[:tagid])
  session[:chap_id]=params[:tagid]
  session[:chap_name]=@tag['v_tagname']
#  if request.xml_http_request?
#      render :partial => "chapter_next", :layout => false
#  end
  @subchapter = SubChapter.find(:all, :conditions => "tagid=#{params[:tagid]} and status='active' ")
   @hmmuser = HmmUser.find(:all, :conditions => "id='#{uid}'")
   puts @subchapter[0]['id']
   if(countcheck==1)
             gallery = Galleries.find(:all,:conditions=>"subchapter_id='#{@subchapter[0]['id']}'")
            redirect_to :controller => "manage_site" , :action => 'contest_gallery', :id => @hmmuser[0]['family_name'], :subchapid => @subchapter[0]['id']

    end
else
  @content_count =UserContent.count(:all, :conditions => "tagid='#{params[:tagid]}'")
  puts @content_count
  if(@content_count >0)
    @gallery_id = UserContent.find(:first, :conditions => "tagid=#{params[:tagid]}").gallery_id
    redirect_to :controller=>'manage_site' , :action=>'contest_moments' ,:id =>params[:id],:moment_id => @gallery_id
  else
    flash[:notice] = 'You have no moments'
    @tag_id = params[:tagid]
    redirect_to :controller=>'manage_site' , :action=>'no_moments' ,:id =>params[:id],:moment_id => 0
  end
end




  end

  def no_moments

  end



   def contest_gallery

    sort_init 'd_updated_on'
    sort_update
    session[:sub_id]=params[:subchapid]
    @hmm_user=HmmUser.find(session[:hmm_user])
    items_per_page = 9
    if(!params[:subchapid].nil?)
    session[:subchapid]=params[:subchapid]
  else

   params[:subchapid]= session[:subchapid]
  end
    galery_id=params[:subchapid]
    conditions = ["v_tagname LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"
    if( srk==nil)
      sort="id  desc"
    end
#    @sub_chapters_galleries_pages, @sub_chapters_gallerie = paginate :galleriess , :order => sort, :per_page => items_per_page, :conditions => "subchapter_id=#{params[:subchapid]} and status='active' and e_gallery_type='#{session[:contests_type]}'" ,:order => sort
    @sub_chapters_gallerie = Galleries.paginate :per_page => items_per_page,:page => params[:page], :order => sort, :conditions => "subchapter_id=#{params[:subchapid]} and status='active' and e_gallery_type='#{session[:contests_type]}'"
    countcheck=Galleries.count(:all, :conditions => "subchapter_id=#{params[:subchapid]} and status='active' and e_gallery_type='#{session[:contests_type]}'")
    for subchap in @sub_chapters_gallerie
     @sub_chapter_count=UserContent.count(:all, :conditions => " gallery_id=#{subchap.id} and status='active'")
     if(@sub_chapter_count<=0)
       countcheck=countcheck
     else
       actualid=subchap.id
     end
    end

    @sub_chapter_journal = SubChapJournal.find(:all, :conditions => "sub_chap_id=#{params[:subchapid]}", :order=>"id DESC")

    #Bread crumb sessions
     @sub_chapter = SubChapter.find(params[:subchapid])
         session[:subchap_id]=params[:subchapid]
         session[:sub_chapname]=@sub_chapter['sub_chapname']
         params[:sbchap_id]=@sub_chapter['tagid']
     @tag = Tag.find(@sub_chapter['tagid'])
         session[:chap_id]=@sub_chapter['tagid']
         session[:chap_name]=@tag['v_tagname']
     # Journals count
     uid=logged_in_hmm_user.id
     @hmmuser = HmmUser.find(:all, :conditions => "id='#{uid}'")
     params[:galid]=galery_id
     @subchap_cnt = SubChapJournal.count(:all, :conditions => "sub_chap_id=#{params[:subchapid]}")
     if request.xml_http_request?
      render :partial => "sub_chapter_gallery", :layout => false
    end
    puts countcheck
     if(countcheck==1)
      redirect_to :controller => "manage_site" , :action => 'contest_moments', :id => @hmmuser[0]['family_name'], :moment_id => @sub_chapters_gallerie[0]['id']
     else
      render :layout => true
    end

  end


 def contest_moments
    @hmm_user=HmmUser.find(session[:hmm_user])
    session[:share_with_hmm]=nil
    session[:shid]=nil
    session[:share]=nil
    render :layout => true
    @galleries = Galleries.find(:all, :conditions =>"id='#{params[:moment_id]}'")

#         @sub_chapter = SubChapter.find(:all, :onditions => "id='#{@galleries[0]['subchapter_id']}'")
#         session[:subchap_id]=@galleries.subchapter_id
#         session[:sub_chapname]=@sub_chapter['sub_chapname']
#         params[:id]=@sub_chapter['tagid']
#         @tag = Tag.find(@sub_chapter['tagid'])
#         session[:chap_id]=params[:id]
#         session[:chap_name]=@tag['v_tagname']
    end

    def get_memories_list
        @moments=UserContent.find(:all, :conditions => "gallery_id='#{params[:moment_id]}'")
        @familyname=HmmUser.find(:all, :conditions => "id='#{logged_in_hmm_user.id}'")
        render :layout => false
    end

      def select_contestmoment
        issubmitted = Contest.find_by_sql("select *  from contests where contests.moment_id='#{params[:momentid]}' and contests.uid=#{logged_in_hmm_user.id}")

        #to get the moment thumb
        @moment = UserContent.find(:all, :conditions => "id='#{params[:momentid]}'")
        for mom_thumb in @moment
          moment_thumb = mom_thumb.v_filename
        end

        if(issubmitted.length == 0)
          @contest_namecheck = Contest.find_by_sql("select *  from contests where contests.first_name='#{params[:fname]}' and contests.uid='#{logged_in_hmm_user.id}' and moment_type = '#{params[:type]}' and status != 'inactive'")
          #Contest.count(:conditions => "uid=#{logged_in_hmm_user.id} and first_name!=#{params[:fname]}")
          if (@contest_namecheck.length == 0)
          @result = "true"
          if params[:journal] == "no"
            @journal = JournalsPhoto.new
            @journal['user_content_id']= params[:momentid]
            @journal['v_title']= params[:title]
            @journal['v_image_comment']= params[:journal_desc]
            @journal['date_added']= params[:date]
            @journal['updated_date']= Time.now
#            if params[:type] == 'image'
#              jtype = 'photo'
#            else if params[:type] == 'video'
#              jtype = 'video'
#            end
#            end
            @journal['jtype']= 'photo'
            @journal.save
            params[:jid] = @journal['id']
          elsif  params[:journal] == "edited"
            journaledited = JournalsPhoto.find(params[:jid])
            journaledited['v_title']=params[:title]
            journaledited['v_image_comment']=params[:journal_desc]
            journaledited['updated_date']=params[:date]
            journaledited.save;
          else

          end
            @contest = Contest.new
            @contest['uid']=logged_in_hmm_user.id
            @contest['moment_id']=params[:momentid]
            @contest['journal_id']= params[:jid]
            @contest['moment_type']=params[:type]
            @contest['contest_title']='Cute Kid contest'
            @contest['first_name']=params[:fname]
            @contest['contest_entry_date'] = Time.now
            @contest['contest_phase'] = 'phase4'
            @contest.save
            #Postoffice.deliver_contest_entrymail(params[:fname],moment_thumb,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_fname,logged_in_hmm_user.v_e_mail)
          else
            @result = "false"
          end
        else
          @result = "submited";
      end
      render :layout => false
    end

   def moments_vote
      items_per_page = 12

      sort_init 'contest_entry_date'
      sort_update

      srk=params[:sort_key]
    @sort="#{srk}  #{params[:sort_order]}"
    @sort1="desc"
    @sort2="desc"
    if(srk==nil)
      @sort="contest_entry_date  desc"
      @sort1="desc"
      @sort2="desc"
    end

    if(srk == 'contest_entry_date')
      @sort1="desc"
      if params[:sort_order] == 'desc'
        @sort1="asc"
      else
        @sort1="desc"
      end
    end

    if(srk == 'new_votes')
      @sort2="desc"
      if params[:sort_order] == 'desc'
        @sort2="asc"
      else
        @sort2="desc"
      end
    end

      @contest_memoriable = Contest.find(:all, :conditions => "moment_type = 'image' and contest_phase='phase3'")
      if (params[:query].nil?)
        conditions = "a.moment_id = b.id and a.moment_type = 'image' and a.status = 'active' and a.moment_id=c.user_content_id and b.id=c.user_content_id and a.contest_phase='phase3'"
      else
        conditions = "a.moment_id = b.id and a.moment_type = 'image' and a.status = 'active' and a.moment_id=c.user_content_id and b.id=c.user_content_id and ( a.first_name like '#{params[:query]}%' or c.v_image_comment like '%#{params[:query]}%') and a.contest_phase='phase3'"
      end
      @contest_cutekid = Contest.paginate :per_page => items_per_page, :page => params[:page], :select => "a.*, b.*,c.*,  a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b, journals_photos as c ",
        :conditions => "#{conditions}", :order => @sort,:group=>"a.id"
   end

   def logged_momentdetails
      @hmm_user = HmmUser.find(logged_in_hmm_user.id)
   if(params[:page]==nil || params[:page]=='')
     @counts =  Contest.count(:all, :conditions => " moment_type='image' and status='active' and contest_phase='phase3'",:order =>'first_name  asc')
      @allrecords =  Contest.find(:all, :conditions => " moment_type='image' and status='active' and contest_phase='phase3'" ,:order =>'first_name  asc')
      page=0


      #pp @allrecords
      for check in @allrecords
        page=page+1
        if("#{check.moment_id}" == "#{params[:id]}" )
         @nextpage=page
         puts "yes dude"
         redirect_to :action => :logged_momentdetails, :id=> params[:id], :page =>@nextpage, :familyname => params[:family_name]
         #redirect_to :action => :momentdetails, :id=> params[:id], :page =>@nextpage
       else
         puts "#{check.moment_id} == #{params[:id]}"

         puts "\n"
        end
      end

     else
       @user_content = Contest.paginate :per_page => 1, :page => params[:page], :conditions => "moment_type='image' and status='active' and contest_phase='phase3'  ",:order =>'first_name  asc'
      #@contest_cutekid = Contest.paginate :per_page => 1, :page => params[:page], :conditions => " moment_type='image' and status='active'" ,:order =>'first_name  asc'

    end
   end

   def videomoment_details
    @moment_details = UserContent.find(:all, :conditions => "id='#{params[:id]}'")
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:id]}'")
    @journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{params[:id]} ")
  end

   def videomoment_vote
    items_per_page = 6
    sort_init 'contest_entry_date'
      sort_update

     srk=params[:sort_key]
    @sort="#{srk}  #{params[:sort_order]}"
    @sort1="desc"
    @sort2="desc"
    if(srk==nil)
      @sort="contest_entry_date  desc"
      @sort1="desc"
      @sort2="desc"
    end

    if(srk == 'contest_entry_date')
      @sort1="desc"
      if params[:sort_order] == 'desc'
        @sort1="asc"
      else
        @sort1="desc"
      end
    end

    if(srk == 'new_votes')
      @sort2="desc"
      if params[:sort_order] == 'desc'
        @sort2="asc"
      else
        @sort2="desc"
      end
    end

    #@contest_cutekid = Contest.find(:all, :joins => "as a, user_contents as b", :conditions => "a.moment_id = b.id and a.contest_title = 'Cute Kid Contest'")
    @contest_memoriable = Contest.find(:all, :conditions => "moment_type='video' and contest_phase='phase3'")
    if (params[:query].nil?)
        conditions = "a.moment_id = b.id  and  a.moment_type = 'video' and a.moment_id=c.user_content_id and b.id=c.user_content_id and a.status='active' and a.contest_phase='phase3'"
    else
      conditions = "a.moment_id = b.id   and  a.moment_type = 'video' and a.moment_id=c.user_content_id and b.id=c.user_content_id and a.status='active' and ( a.first_name like '#{params[:query]}%' or c.v_image_comment like '%#{params[:query]}%') and a.contest_phase='phase3'"

    end
     @contest_cutekid = Contest.paginate :per_page => items_per_page, :page => params[:page], :select => "a.*, b.*,c.v_image_comment,  a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b, journals_photos as c ",
        :conditions => "#{conditions}", :order => @sort,:group=>"a.id"

  end

  def vote

      @mom_id = params[:id]
      @contests_det = Contest.find(params[:id])
      @moment_details = UserContent.find(:all, :conditions => "id='#{@contests_det.moment_id}'")
      @contests_fname = Contest.find(:all, :conditions => "moment_id='#{@contests_det.moment_id}'")
      @journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{@contests_det.moment_id} ")
      render :layout => false
  end

  def create_vote
    if (session[:hmm_user].nil?)
      @contest = Contest.find(params[:id])
      @uid = @contest.uid
      contetsid = @contest.id
      contetsfname = @contest.first_name
      moment_type = @contest.moment_type

      #working for thumb nail for e-mail
      momentid = @contest.moment_id
      @moment = UserContent.find(:all, :conditions => "id='#{momentid}'")
      for moment_name in @moment
        moment_filename = moment_name.v_filename
      end

      #working for fname and lastname of cntestant
      @username = HmmUser.find(:all, :conditions => "id='#{@uid}'")
      for user in @username
        user_fname = user.v_fname
        user_lname = user.v_lname
      end

      @contest_vote = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and email_id = '#{params[:email]}' ")
      if @contest_vote <= 0
       #calculating next id for the contest vote table
       @contestvote_max =  ContestVotes.find_by_sql("select max(id) as n from contest_votes")
       for contestvote_max in @contestvote_max
         contestvote_max_id = "#{contestvote_max.n}"
       end
       if(contestvote_max_id == '')
         contestvote_max_id = '0'
       end
       contestvote_next_id = Integer(contestvote_max_id) + 1
       #creating unid for the vote conform
       contestuuid=Share.find_by_sql("select uuid() as uid")
       unid=contestuuid[0].uid+""+"#{contestvote_next_id}"
       #inserting new values into contest vote table
       @vote = ContestVotes.new()
       @vote['uid']=@uid
       @vote['contest_id']=contetsid
       @vote['email_id']=params[:email]
       @vote['vote_date']= Time.now
       @vote['unid'] = unid
       if @vote.save
         $notice_vote1
         flash[:notice_vote] = 'Thank-you for casting your vote.  You will shortly receive an email verification that you must accept for your vote to be counted.  This helps us make sure that all votes are valid votes.  Your email address will not be shared with any other company.'
         #Postoffice.deliver_voteconform(params[:email],contetsid, unid,moment_filename,contetsfname,user_fname,user_lname,moment_type)
         if(moment_type=="video")
           redirect_to :action => 'videomoment_vote', :id => params[:familyname]
         else
          redirect_to :action => 'moments_vote', :id => params[:familyname]
         end
          else
         $notice_vote
         flash[:notice_vote] = 'Your was not submitted due to technical issue... Please try again!!'
         if(moment_type=="video")
           redirect_to :action => 'videomoment_vote', :id => params[:familyname]
         else
          redirect_to :action => 'moments_vote', :id => params[:familyname]
         end
       end

     else
      $notice_vote
      flash[:notice_vote] = 'You have already voted for this moment.. you can cast your vote only once per family!!'
      if(moment_type=="video")
         redirect_to :action => 'videomoment_vote', :id => params[:familyname]
      else
         redirect_to :action => 'moments_vote', :id => params[:familyname]
      end
    end
    else
      redirect_to :action => 'vote_cal', :id => params[:id], :familyname => params[:familyname]
    end
  end

  def vote_cal
    @contest = Contest.find(params[:id])
    @uid = @contest.uid
    contetsid = @contest.id
    contest_typ = @contest.moment_type
    puts params[:familyname]
    @contest_vote1 = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and hmm_voter_id = '#{logged_in_hmm_user.id}' ")
    @contest_vote2 = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and email_id = '#{logged_in_hmm_user.v_e_mail}' ")
    puts @contest_vote2
    if (@contest_vote1 <= 0 and @contest_vote2 <= 0)
      #calculating next id for the contest vote table
      @contestvote_max =  ContestVotes.find_by_sql("select max(id) as n from contest_votes")
      for contestvote_max in @contestvote_max
        contestvote_max_id = "#{contestvote_max.n}"
      end
      if(contestvote_max_id == '')
        contestvote_max_id = '0'
      end
      contestvote_next_id = Integer(contestvote_max_id) + 1

      #creating unid for the vote conform
#      contestuuid=Share.find_by_sql("select uuid() as uid")
#      unid=contestuuid[0].uid+""+"#{contestvote_next_id}"

      #inserting new values into contest vote table
      @vote = ContestVotes.new()
      @vote['uid']=@uid
      @vote['contest_id']=contetsid
      @vote['hmm_voter_id']=logged_in_hmm_user.id
      @vote['vote_date']= Time.now

      @vote['conformed'] = 'yes'
      if @vote.save

        @contest_vote_count = ContestVotes.count(:all, :conditions => "contest_id = '#{contetsid}' and conformed='yes'")
        countest_update = Contest.find(contetsid)
        countest_update.votes = @contest_vote_count
        countest_update.save

        #calculation for new votes
        @count = ContestVotes.count_by_sql("select COUNT(distinct CONCAT(IFNULL(email_id,''),IFNULL(hmm_voter_id,''))) AS COUNT from contest_votes where contest_id='#{contetsid}' and conformed='yes'")
        countest_update = Contest.find(contetsid)
        countest_update.new_votes = @count
        countest_update.save

        $notice_vote
        flash[:notice_vote] = 'Vote has been successfully submitted.. '
        #Postoffice.deliver_voteconform(params[:email],contetsid, unid)
        if contest_typ == 'image'
          redirect_to :action => 'moments_vote', :id => params[:familyname]
        else if contest_typ == 'video'
          redirect_to :action => 'videomoment_vote', :id => params[:familyname]
        end
        end
      else
        $notice_vote
        flash[:notice_vote] = 'Your was not submitted due to technical issue... Please try again!!'
        if contest_typ == 'image'
          redirect_to :action => 'moments_vote', :id => params[:familyname]
        else if contest_typ == 'video'
          redirect_to :action => 'videomoment_vote', :id => params[:familyname]
        end
        end
      end

    else
      $notice_vote
      flash[:notice_vote] = 'You have already voted for this moment.. you can cast your vote only once per family!!'
      if contest_typ == 'image'
          redirect_to :action => 'moments_vote', :id => params[:familyname]
        else if contest_typ == 'video'
          redirect_to :action => 'videomoment_vote', :id => params[:familyname]
        end
        end
    end

  end

  def logged_moments_vote
    items_per_page = 12
    sort_init 'contest_entry_date'
    sort_update

    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if(srk==nil)
      sort="first_name  asc"
    end
      #@contest_cutekid = Contest.find(:all, :joins => "as a, user_contents as b", :conditions => "a.moment_id = b.id and a.contest_title = 'Cute Kid Contest'")
      #@contest_memoriable = Contest.find(:all, :conditions => "contest_title = 'Memorable Moments Contest'")
      if (params[:query].nil?)
        conditions = "a.moment_id = b.id and a.moment_type = 'image' and contest_phase ='phase2' and a.status = 'active' and a.moment_id=c.user_content_id and b.id=c.user_content_id"
      else
        conditions = "a.moment_id = b.id and a.moment_type = 'image' and  a.status = 'active' and contest_phase ='phase2' and a.moment_id=c.user_content_id and b.id=c.user_content_id and ( a.first_name like '#{params[:query]}%' or c.v_image_comment like '%#{params[:query]}%')"
      end
       @contest_cutekid = Contest.paginate :per_page => items_per_page, :page => params[:page], :select =>  "a.*, b.*,c.v_image_comment,  a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b, journals_photos as c ",
      #@contest_cutekids_pages, @contest_cutekids = paginate :contests, :select => "a.*, b.*,c.v_image_comment,  a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b, journals_photos as c ", :per_page => items_per_page,
         :order => sort, :conditions => "#{conditions}"
  end

#chapter comments
def chapter_comment_approve_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @chapter_comment =ChapterComment.find(params[:id])
     @chapter_comment['e_approval'] = 'approve'
     @chapter_comment.save
      $notice_cca_list
     flash[:notice] = 'Chapter Comment was Approved!!'
    if(params[:jc]=='1')
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:family_name]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'manage_site', :action => 'comments_list' ,:id => params[:family_name]
    end

end

def chapter_comment_reject_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @chapter_comment =ChapterComment.find(params[:id])
      @chapter_comment.destroy
     # @chapter_comment['e_approval'] = 'reject'
      #@tag_cid = ChapterComment.find(:all, :conditions => "tag_jid=#{params[:id]} " , :order => "id DESC")
    #@chapter_comment.save
    $notice_ccr_list
     flash[:notice] = 'Chapter Comment Rejected'
     if(params[:jc]=='1')
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:family_name]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'manage_site', :action => 'comments_list' ,:id => params[:family_name]
    end

   end

def chapter_comment_destroy_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
    @chapter_comment =ChapterComment.find(params[:id])
    @chapter_comment.destroy
    $notice_ccd_list
     flash[:notice] = 'Chapter Comment was Deleted!!'
    if(params[:jc]=='1')
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:family_name]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'manage_site', :action => 'comments_list' ,:id => params[:family_name]
    end
end

#sub chapter comments
 def subchap_comment_approve_cmt
      @hmm_user=HmmUser.find(session[:hmm_user])
       @chapter_comment =SubchapComment.find(params[:id])
        @chapter_comment['e_approval'] = 'approve'
      @chapter_comment.save
      $notice_sca_list
        flash[:notice] = 'Sub-Chapter Comment Was Successfully Approved!!'
     if(params[:jc]=='1')
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:family_name]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'manage_site', :action => 'comments_list' ,:id => params[:family_name]
    end
 end

  def subchap_comment_reject_cmt
      @hmm_user=HmmUser.find(session[:hmm_user])
       @chapter_comment =SubchapComment.find(params[:id])
       @chapter_comment.destroy
      $notice_scr_list
        flash[:notice] = 'Sub-Chapter Comment was Rejected'
     if(params[:jc]=='1')
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:family_name]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'manage_site', :action => 'comments_list' ,:id => params[:family_name]
    end
 end

  def subchap_comment_destroy_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
      @chapter_comment =SubchapComment.find(params[:id])
      @chapter_comment.destroy
      $notice_scd_list
        flash[:notice] = 'Sub-Chapter Comment Was Successfully Deleted!!'
     if(params[:jc]=='1')
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:family_name]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'manage_site', :action => 'comments_list' ,:id => params[:family_name]
    end
  end

#gallery comments
def gallery_comment_approve_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @gallery_comment =GalleryComment.find(params[:id])
     @gallery_comment['e_approval'] = 'approve'
     @gallery_comment.save
     $notice_gca_list
      flash[:notice] = 'Gallery Comment Was Successfully Approved!!'

     if(params[:jc]=='1')
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:family_name]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'manage_site', :action => 'comments_list' ,:id => params[:family_name]
    end
end

 def gallery_comment_reject_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @gallery_comment =GalleryComment.find(params[:id])
      @gallery_comment.destroy
    $notice_gcr_list
      flash[:notice] = 'Gallery Comment Rejected!!'

   if(params[:jc]=='1')
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:family_name]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'manage_site', :action => 'comments_list' ,:id => params[:family_name]
    end
   end

 def gallery_comment_destroy_cmt

@hmm_user=HmmUser.find(session[:hmm_user])
    @gallery_comment =GalleryComment.find(params[:id])
    @gallery_comment.destroy
    $notice_gcd_list
      flash[:notice_gcd_list] = 'Gallery Comment Was Successfully Deleted!!'

    if(params[:jc]=='1')
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:family_name]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'manage_site', :action => 'comments_list' ,:id => params[:family_name]
    end
  end

#photo comments
def photo_comments_approve_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @comment =PhotoComment.find(params[:id])
    @comment['e_approved'] = 'approve'
    @comment.save
    $notice_pca_list
      flash[:notice] = 'Photo Comment was Successfully Approved!!'
     if(params[:jc]=='1')
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:family_name]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'manage_site', :action => 'comments_list' ,:id => params[:family_name]
    end
 end

 def photo_comments_reject_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
    @comment =PhotoComment.find(params[:id])
     @comment.destroy
    $notice_pcr_list
    flash[:notice] = 'Photo Comment Rejected'
    if(params[:jc]=='1')
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:family_name]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'manage_site', :action => 'comments_list' ,:id => params[:family_name]
    end
  end

def photo_comments_destroy_cmt

@hmm_user=HmmUser.find(session[:hmm_user])
    @comment =PhotoComment.find(params[:id])
    @comment.destroy
    $notice_pcd_list
      flash[:notice] = 'Photo Comment was Successfully Deleted!!'
    if(params[:jc]=='1')
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:family_name]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'manage_site', :action => 'comments_list' ,:id => params[:family_name]
    end
  end

  # share journal comments
  def share_journalcomments_approve_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @share_journalcomment =ShareJournalcomment.find(params[:id])
     @share_journalcomment.status = 'accepted'
     @share_journalcomment.save
      $notice_cca_list
     flash[:notice] = 'Shared Journal Comment Approved!!'
     if(params[:jc]=='1')
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:family_name]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'manage_site', :action => 'comments_list' ,:id => params[:family_name]
    end
 end

 def share_journalcomments_reject_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @share_comment =ShareJournalcomment.find(params[:id])

      #@tag_cid = ChapterComment.find(:all, :conditions => "tag_jid=#{params[:id]} " , :order => "id DESC")
    @share_comment.destroy
    $notice_ccr_list
     flash[:notice] = 'Shared Journal Comment Rejected!!'
     if(params[:jc]=='1')
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:family_name]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'manage_site', :action => 'comments_list' ,:id => params[:family_name]
    end
   end

   def share_journalcomments_destroy_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])

    @share_comment =ShareJournalcomment.find(params[:id])
    @share_comment.destroy
    $notice_ccd_list
     flash[:notice] = 'Shared Journal Comment Deleted!!'
     if(params[:jc]=='1')
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:family_name]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'manage_site', :action => 'comments_list' ,:id => params[:family_name]
    end
  end


# share moments controller

def share_momentcomments_approve_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     if(session['redirect']=='22')
     @share_comment =ShareMomentcomment.find(params[:cid])
   else
     @share_comment =ShareMomentcomment.find(params[:id])
     end
     @share_comment['e_approved'] = 'approved'
     @share_comment.save
      $notice_acceptcmt
     flash[:notice_acceptcmt] = 'Shared Moment Comment Approved!!'
     if(session['redirect']=='22')
        redirect_to :controller => 'photo_comments', :action => 'photo_comnt', :id => session[:usercontent_id1], :page1=>params[:page1], :id_journal => params[:id_journal]
     else
        #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
        redirect_to :controller => 'manage_site', :action => 'comments_list',:id => params[:family_name]
     end
 end

def share_momentcomments_reject_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     if(session['redirect']=='22')
     @share_comment =ShareMomentcomment.find(params[:cid])
   else
     @share_comment =ShareMomentcomment.find(params[:id])
     end


      #@tag_cid = ChapterComment.find(:all, :conditions => "tag_jid=#{params[:id]} " , :order => "id DESC")
    @share_comment.destroy
    $notice_rejectcmt
     flash[:notice] = 'Shared Moment Comment Rejected!!'
     if(session['redirect']=='22')
        redirect_to :controller => 'photo_comments', :action => 'photo_comnt', :id => session[:usercontent_id1], :page1=>params[:page1], :id_journal => params[:id_journal]
     else
       # redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
       redirect_to :controller => 'manage_site', :action => 'comments_list',:id => params[:family_name]
     end
   end

def share_momentcomments_destroy_cmt
  @hmm_user=HmmUser.find(session[:hmm_user])
    if(session['redirect']=='22')
     @share_comment =ShareMomentcomment.find(params[:cid])
   else
    @share_comment =ShareMomentcomment.find(params[:id])
    end
    @share_comment.destroy
    $notice_smtdestroy
     flash[:notice_smtdestroy] = 'Shared Moment Comment Deleted!!'
      if(session['redirect']=='22')
        redirect_to :controller => 'photo_comments', :action => 'photo_comnt', :id => session[:usercontent_id1], :page1=>params[:page1], :id_journal => params[:id_journal]
     else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'manage_site', :action => 'comments_list',:id => params[:family_name]
    end
  end

#guest comments
 def guest_comments_approve_jcmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @guest_comment =GuestComment.find(params[:id])
     @guest_comment['status'] = 'approve'
     @guest_comment.save
      $notice_cca_jlist
     flash[:notice_cca_jlist] = 'Guest Comment was Approved!!'
   flash[:notice] = 'Guest Comment was Approved!!'
      if(params[:jc]=='1')
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:family_name]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'manage_site', :action => 'comments_list' ,:id => params[:family_name]
    end
  end

  def guest_comments_reject_jcmt
    @hmm_user=HmmUser.find(session[:hmm_user])
     @guest_comment =GuestComment.find(params[:id])
      @guest_comment.destroy
     # @guest_comment['e_approval'] = 'reject'
      #@tag_cid = GuestComment.find(:all, :conditions => "tag_jid=#{params[:id]} " , :order => "id DESC")
    #@guest_comment.save
    $notice_ccr_list
     flash[:notice_cca_jlist] = 'Guest Comment Rejected'
   flash[:notice] = 'Guest Comment Rejected'
   if(params[:jc]=='1')
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:family_name]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'manage_site', :action => 'comments_list' ,:id => params[:family_name]
    end
   end

def guest_comments_destroy_jcmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @guest_comment =GuestComment.find(params[:id])
      @guest_comment.destroy
     # @guest_comment['e_approval'] = 'reject'
      #@tag_cid = GuestComment.find(:all, :conditions => "tag_jid=#{params[:id]} " , :order => "id DESC")
    #@guest_comment.save
    $notice_ccr_list
     flash[:notice] = 'Guest Comment was removed!!'

   if(params[:jc]=='1')
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details' ,:id => params[:family_name]
    else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'manage_site', :action => 'comments_list' ,:id => params[:family_name]
    end
   end

#message boards

def message_boards_approve_cmt
    @hmm_user=HmmUser.find(session[:hmm_user])
    @comment =MessageBoard.find(params[:id])
    @comment['status'] = 'accept'
    @comment.save
    $notice_mca_list
      flash[:notice_mca_list] = 'Guest comment was Successfully Approved!!'
     #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
     redirect_to :controller => 'manage_site', :action => 'comments_list',:id => params[:family_name]
 end

def message_boards_destroy_cmt
  @hmm_user=HmmUser.find(session[:hmm_user])
    MessageBoard.find(params[:id]).destroy
    $notice_mcd_list
      flash[:notice_mcd_list] = 'Guest comment was deleted!!'
     #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
     redirect_to :controller => 'manage_site', :action => 'comments_list',:id => params[:family_name]
  end

#share comments

def share_comments_approve_cmt
   puts session['redirect']
     @hmm_user=HmmUser.find(session[:hmm_user])
     @share_comment =ShareComments.find(params[:id])
     @share_comment['e_approved'] = 'approved'
     @share_comment.save
      $notice_cca_list
     flash[:notice_cca_list] = 'Shared Moment Comment Approved!!'
      if(session['redirect']=='111')
       redirect_to :controller => 'tags', :action => 'memories', :id=> @share_comment[:share_id]
      else
     #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
     redirect_to :controller => 'manage_site', :action => 'comments_list',:id => params[:family_name]
      end
 end

def share_comments_reject_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @share_comment =ShareComments.find(params[:id])
     @share_comment.destroy

      #@tag_cid = ChapterComment.find(:all, :conditions => "tag_jid=#{params[:id]} " , :order => "id DESC")

    $notice_ccr_list
     flash[:notice] = 'Shared Moment Comment Rejected!!'
    if(session['redirect']=='111')
       redirect_to :controller => 'tags', :action => 'memories', :id=> @share_comment[:share_id]
    else
   #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
   redirect_to :controller => 'manage_site', :action => 'comments_list',:id => params[:family_name]
    end
   end

 def share_comments_destroy_cmt
   @hmm_user=HmmUser.find(session[:hmm_user])
    @share_comment =ShareComments.find(params[:id])
    @share_comment.destroy
    $notice_ccd_list
     flash[:notice] = 'Shared Moment Comment Deleted!!'
      if(session['redirect']=='111')
       redirect_to :controller => 'tags', :action => 'memories', :id=> @share_comment[:share_id]
      else
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'manage_site', :action => 'comments_list',:id => params[:family_name]
      end
  end

#add contacts
def add_contact
    @nonhmm_user = NonhmmUser.new
    render :layout => false
end

def create_contact

    @nonhmm_user = NonhmmUser.new(params[:nonhmm_user])
    @nonhmm_user['uid'] = logged_in_hmm_user.id
    @hmm_user=HmmUser.find(session[:hmm_user])

    nonhmm_user_check =  NonhmmUser.count(:all, :conditions =>" uid='#{logged_in_hmm_user.id}' and v_email='#{params[:nonhmm_user][:v_email]}'")

    if nonhmm_user_check == 0

      @nonhmm_user.save
      $notice_nonhmm

   #invite email
   if params[:chk][:invite]=='yes'

      if params[:chk][:pass]=='yes'
        Postoffice.deliver_invite2(@hmm_user.v_fname,@hmm_user.v_e_mail,params[:nonhmm_user][:v_email],@hmm_user.familywebsite_password,@hmm_user.family_name)
      else
        Postoffice.deliver_invite2(@hmm_user.v_fname,@hmm_user.v_e_mail,params[:nonhmm_user][:v_email],'no',@hmm_user.family_name)
      end

   end

      flash[:notice_nonhmm] = 'New Contact was Successfully Added!!'

     redirect_to :controller => 'manage_site', :action => 'fnf_index' , :id=>params[:id]

  else
      flash[:notice_nonhmm] = 'Contact Already Exists!!'
      redirect_to :controller => 'manage_site', :action => 'fnf_index' , :id=>params[:id]
    end

end

def delete_contact

   NonhmmUser.find(params[:did]).destroy
   flash[:notice_nonhmm] = 'Contact Deleted Successfully!!'
   redirect_to :controller => 'manage_site', :action => 'fnf_index' , :id=>params[:id]

end

def movedown_biography
  nextid=params[:nextid]
  currentid=params[:currentid]
  famax =  FamilyMember.find_by_sql("select max(id) as m from family_members")
  if(famax[0]['m']=='')
    fa_next_id=1
  else
    famax=famax[0]['m']
    fa_next_id= Integer(famax) + 1
  end

  sql = ActiveRecord::Base.connection();
  sql.update "UPDATE family_members SET id = #{fa_next_id}  WHERE id =#{currentid}";

  sql.update "UPDATE family_members SET id = #{currentid}  WHERE id =#{nextid}";

  sql.update "UPDATE family_members SET id = #{nextid}  WHERE id =#{fa_next_id}";
  redirect_to :action => 'manage_biography',:id=>params[:id]

end

def myimagePreview
 # @hmm_user=HmmUser.find(session[:hmm_user])
  render :layout => false
end

  def edit_familyname
    @hmm_user = HmmUser.find(logged_in_hmm_user.id)
    @check_familyname = HmmUser.count(:all, :conditions => "id=#{logged_in_hmm_user.id} and family_name != ''")
  end

  def step1_update
     @hmm_user = HmmUser.find(logged_in_hmm_user.id)
     #system("convert  -gravity north   -fill '#454545' -background transparent -font #{RAILS_ROOT}/public/Bickham2.otf  -pointsize 72 label:#{@naming_family} #{RAILS_ROOT}/public/familytitleImages/#{logged_in_hmm_user.id}title.png")
     #pp  params[:hmm_user]
     @check_familyname = HmmUser.count(:all, :conditions => "id=#{logged_in_hmm_user.id} and family_name != ''")
     if @check_familyname > 0
       @message = "You have made change's to your HoldMyMemories.com Family website"
     else
       @message = "Congratulations, you have set up your Family website at HoldMyMemories.com!"
     end

#     link= params[:hmm_user][:family_name].capitalize
#     pass_req=params[:hmm_user][:password_required]
#     pass=params[:hmm_user][:familywebsite_password]
#     recipent = @hmm_user.v_e_mail
     @check_familyname1 = HmmUser.count(:all, :conditions => "id!=#{logged_in_hmm_user.id} and family_name = '#{params[:hmm_user][:family_name]}'")
    if @check_familyname1 > 0
      flash[:notice_step1fail] = 'sorry Family name already exists please try again with different name'
       redirect_to :action => 'familypage_step1', :id => logged_in_hmm_user.id
    else
      if @hmm_user.update_attributes(params[:hmm_user])
#       Postoffice.deliver_send_sitedetails(link,pass_req,pass,recipent,@message)
       flash[:notice_step1succes] = 'Family Name was successfully updated..'
       if(session[:family])
        session[:family]= @hmm_user.family_name
       end
       redirect_to :action => 'edit_familyname', :id => @hmm_user.family_name
      else
       flash[:notice_step1fail] = 'Family name was failed to update, as Family name already exisits..'
       redirect_to :action => 'edit_familyname', :id => @hmm_user.family_name
     end
   end
  end

  def validate_familyname
      color = 'red'
      familyname = params[:familyname]

      family = HmmUser.find(:all, :conditions => " id!='#{logged_in_hmm_user.id}' and ( family_name='#{params[:familyname].gsub(/('|"|\0)/, "\\\\\\1")}' || alt_family_name='#{params[:familyname].gsub(/('|"|\0)/, "\\\\\\1")}') ")
      if family.size > 0
        message_family = 'Family Name already exist'
        @valid = false
      else
        message_family = 'Family Name Is Available'
        color = 'green'
       @valid=true
      end
      @message_family = "<b style='color:#{color}'>#{message_family}</b>"

      render :partial=>'message_family'
  end

   def contact_details
     @nonhmm_user = NonhmmUser.find(params[:uid])



      conditions2 = "v_e_mail LIKE '#{@nonhmm_user.v_email}%'"
      @hmm = HmmUser.find(:all,:conditions =>"#{conditions2}")
      for colmn in @hmm
        @ulink="http://www.holdmymemories.com/#{colmn.family_name}"
      end

  end

  def update_contact

     @nonhmm_user = NonhmmUser.find(params[:uid])

     if(@nonhmm_user.v_email!=params[:nonhmm_user][:v_email])

        nonhmm_user_check =  NonhmmUser.count(:all, :conditions =>" uid='#{logged_in_hmm_user.id}' and v_email='#{params[:nonhmm_user][:v_email]}'")

        if nonhmm_user_check == 0

          @nonhmm_user.update_attributes(params[:nonhmm_user])
          flash[:notice_nonhmm] = 'Contact was successfully updated.'
          redirect_to :action => 'fnf_index', :id => params[:id]

        else
           flash[:notice_nonhmm] = 'Email address already exists in Contact'
           redirect_to :action => 'fnf_index', :id => params[:id]
        end

  else
      @nonhmm_user.update_attributes(params[:nonhmm_user])
      flash[:notice_nonhmm] = 'Contact was successfully updated.'
      redirect_to :action => 'fnf_index', :id => params[:id]

     end
  end

  def template1
    render :layout => true
  end

  def add_biograpy
    @fmname=params[:id]
  end

  def add_familyhistory

  end

  def add_all_friends

    @users=HmmUser.find(:all)
    if(@users.size>0)

     @users.each do |j|

     conditions2 = "uid='#{j.id}'"
     @family_friends = FamilyFriend.find(:all,:conditions =>"#{conditions2} and   status='accepted'")

       if(@family_friends.size>0)

       @family_friends.each do |i|

        @hmmcount=HmmUser.count(i.fid)
        if(@hmmcount>0)

            @hmm = HmmUser.find(i.fid)

            @client_content = NonhmmUser.new()
            @client_content['uid']=j.id
            @client_content['v_name']=@hmm.v_fname
            @client_content['v_email']=@hmm.v_e_mail
            @client_content['v_city']=@hmm.v_city
            @client_content['v_country']=@hmm.v_country
            @client_content['invite']=''
            @client_content['v_street']=@hmm.v_add1
            @client_content['v_phone']=@hmm.telephone
            @client_content.save

         end
        end
      end
    end
   end
    redirect_to :action => 'fnf_index', :id => params[:id]
  end



  def get_address_book

    @users=NonhmmUser.find(:all)
    if(@users.size>0)

      @users.each do |i|


         @check_familyname = NonhmmContact.count(:all, :conditions => "uid='#{i.uid}' and v_email='#{i.v_email}'")

          if(@check_familyname==0)
            @client_content = NonhmmContact.new()
            @client_content['uid']=i.uid
            @client_content['v_name']=i.v_name
            @client_content['v_email']=i.v_email
            @client_content['v_city']=i.v_city
            @client_content['v_country']=i.v_country
            @client_content['v_street']=i.v_street
            @client_content['v_phone']=i.v_phone
            @client_content['v_status']='yes'
            @client_content.save
         end
      end
    end
  end


 def update_family_history

    @hmm_user = HmmUser.find(params[:uid])
    #@hmm_user = HmmUser.new(params[:hmm_user])

    if @hmm_user.update_attributes(params[:hmm_user])
      flash[:notice] = 'Your Family History information has been Successfully Updated.'
      redirect_to :action => "manage_biography", :id => params[:family_name]
    else
      flash[:notice] = 'HmmUser update Failed due to technical problem.'
       redirect_to :action => "manage_biography", :id => params[:family_name]
      #redirect_to :controller => 'customers', :action => 'edit_profile', :id => @hmm_user
    end

 end

 def upgrade_payment_family

    require "ArbApiLib"

     card_no=params[:card_no]
    cvv_no=params[:cardcvv_no]
    expiry_date="#{params[:exp_year]}-#{params[:exp_month]}"
    exp_month=params[:exp_month]
    exp_year=params[:exp_year]
    fname=params[:fname]
    lname=params[:lname]
    #amount=Integer(params[:amount])
    street_address = params[:street_address]
    #suburb = params[:suburb]
    postcode = params[:postcode]
    city = params[:city]
    state = params[:state]
    country = params[:country]
    telephone = params[:telephone]
    fax = params[:fax]
    months=params[:months]
    account_type=params[:account_type]
    email = params[:email]
    invoicenumber = "HMM000HMM#{params[:hmm_id]}"
    if(logged_in_hmm_user.subscriptionnumber.nil? || logged_in_hmm_user.invoicenumber!="")
      invoicenumber = "HMM000HMM#{params[:hmm_id]}"
    else
      if(logged_in_hmm_user.subscriptionnumber=="One time payment")
        invoicenumber = "HMMAP0HMM#{params[:hmm_id]}"
      end
    end
    subnumber = logged_in_hmm_user.subscriptionnumber



    if(logged_in_hmm_user.account_type=='free_user')
            @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL #{months} MONTH) as m")
    else
            @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE('#{logged_in_hmm_user.account_expdate}',INTERVAL #{months} MONTH) as m")
     end

    account_expdate= @hmm_user_max[0]['m']

    @uuid =  HmmUser.find_by_sql(" select UUID() as u")

    unid = "#{@uuid[0]['u']}000#{params[:hmm_id]}"
    if(account_type == "familyws_user")
      acctype="family_website"
      if(months == "1")
        amount = 4.95
        amttest=495
        amount1 = "$4.95"
      end
      if(months == "6")
        amount = 4.95
        amttest=2495
        amount1 = "$24.95"
      end
      if(months == "12")
        amount = 4.95
        amttest=4995
        amount1 = "$49.95"
      end
    else
      if(account_type == "platinum_user")
        acctype="platinum_account"
        if(months == "1")
         amount = 9.95
         amttest=995
         amount1 = "$9.95"
        end
        if(months == "6")
         amount = 9.95
         amttest=4995
         amount1 = "$49.95"
        end
        if(months == "12")
         amount = 9.95
         amttest=9995
         amount1 = "$99.95"
        end
      end
    end

    #number = '4007000000027'

     creditcard = ActiveMerchant::Billing::CreditCard.new( #:number => number, #Authorize.net test card, error-producing
     :number => card_no, #Authorize.net test card, non-error-producing
      :month => exp_month,                #for test cards, use any date in the future
      :year => exp_year,
      :first_name => fname,
      :last_name => lname,
      :verification_value => cvv_no
      #:cvv => cvv_no

                  #note that MasterCard is 'master'
    )

    if creditcard.valid?

    if(logged_in_hmm_user.account_type == "platinum_user")
      if(account_type == "familyws_user")
        flag=2
      else
        flag=2
      end
    end

    if(flag==1)
      flash[:error] = "Sorry you cannot  downgrade your subscription."
      redirect_to "/manage_site/upgrade/#{params[:id]}?atype=#{acctype}"
    else
          #@creditcard = Creditcard.find(params[:id])
        gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(:test => false, :login => "8GxD65y84", :password=> "89j6d34cW8CKhp9S")
        amount_to_charge = Money.ca_dollar(amttest) #1000 = ten US dollars
        creditcard = ActiveMerchant::Billing::CreditCard.new( #:number => number, #Authorize.net test card, error-producing
     :number => card_no, #Authorize.net test card, non-error-producing
      :month => exp_month,                #for test cards, use any date in the future
      :year => exp_year,
      :first_name => fname,
      :last_name => lname,
      :verification_value => cvv_no
      #:cvv => cvv_no

                  #note that MasterCard is 'master'
    )

        options = {
          :address => {},
          :billing_address => {
          :name     => "#{fname} #{lname}",
          :address1 => street_address,
          :city     => city,
          :state    => state,
          :country  => country,
          :zip      => postcode,
          :phone    => telephone
        }
}
        response = gateway.authorize(amount_to_charge,creditcard,options)
        if response.success?
          #charge once
          gateway.capture(amount_to_charge, response.authorization)
          hmm_user_det=HmmUser.find(params[:hmm_id])
              hmm_user_det[:street_address]=params[:street_address]
              hmm_user_det[:suburb]=params[:suburb]
              hmm_user_det[:postcode]=params[:postcode]
              hmm_user_det[:city]=params[:city]
              hmm_user_det[:state]=params[:state]
              hmm_user_det[:country]=params[:country]
              hmm_user_det[:telephone]=params[:telephone]
              hmm_user_det[:account_type] = params[:account_type]
              hmm_user_det[:account_expdate] = account_expdate
              hmm_user_det[:cancel_status] = ''
              hmm_user_det[:canceled_by] = ''
              hmm_user_det[:first_payment_date] = Time.now
              hmm_user_det[:invoicenumber] = invoicenumber
              hmm_user_det[:months] = months
              hmm_user_det[:amount] = amount1
              hmm_user_det[:unid] = unid
              hmm_user_det[:membership_sold_by] = params[:sold_by]

              hmm_user_det.save








          start_date = Time.now.strftime("%Y-%m-%d")
          if(logged_in_hmm_user.account_type=='free_user')
            @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL #{months} MONTH) as m")
          else
            @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE('#{logged_in_hmm_user.account_expdate}',INTERVAL #{months} MONTH) as m")
          end
          account_expdate= @hmm_user_max[0]['m']

          # Write code for new subscription for  upgradation
          aReq = ArbApi.new
          if ARGV.length < 3
          puts "Usage: ArbApiSample.rb <url> <login> <txnkey> [<subscription name>]"
              #exit
            end
            ARGV[0]= "https://api.authorize.net/xml/v1/request.api"
            ARGV[1]= "8GxD65y84"
            ARGV[2]= "89j6d34cW8CKhp9S"
            #ARGV[1]= "cnpdev4289"
            #ARGV[2]= "SR2P8g4jdEn7vFLQ"
            #ARGV[3]= "644100"

            auth = MerchantAuthenticationType.new(ARGV[1], ARGV[2])
            subname = ARGV.length > 3? ARGV[3]: account_type
            interval = IntervalType.new(1, "months")
            schedule = PaymentScheduleType.new(interval, account_expdate, 9999, 0)
            cinfo = CreditCardType.new(card_no, expiry_date, cvv_no)
            binfo = NameAndAddressType.new(fname, lname,"Not added", street_address, city, state ,postcode, country,email,telephone )
            xmlout = aReq.CreateSubscription(auth,subname,schedule,amount, 0, cinfo,binfo,interval,invoicenumber)

            puts "Creating Subscription Name: #{subname}"
            puts "Submitting to URL: #{ARGV[0]}"
            xmlresp = HttpTransport.TransmitRequest(xmlout, ARGV[0])


            apiresp = aReq.ProcessResponse(xmlresp)

            if apiresp.success
              hmm_user_det=HmmUser.find(params[:hmm_id])
              hmm_user_det[:subscriptionnumber] = apiresp.subscriptionid

              hmm_user_det.save

              subscriptionid = apiresp.subscriptionid
              pw=HmmUser.find(:all, :select => "v_password as pword,password_required as preq, familywebsite_password as fpword ", :conditions => "id=#{hmm_user_det.id}")

              link = "http://www.holdmymemories.com/#{hmm_user_det.family_name}"
              pass_req = pw[0].preq
              pass = pw[0].pword
              #Postoffice.deliver_paymentsucess("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, params[:account_type], hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,apiresp.subscriptionid, hmm_user_det.v_user_name, hmm_user_det.v_password,link,pass_req,pass)

              flash[:sucess] =  "Subscription Created successfully"
              flash[:sucess_id] = "Your Subscription id is: #{apiresp.subscriptionid}"

              if(logged_in_hmm_user.account_type == "free_user")
                flag=1
              else
                flag=2
              end


              if ARGV.length < 3
              end
              ARGV[0]= "https://api.authorize.net/xml/v1/request.api"
              ARGV[1]= "8GxD65y84"
              ARGV[2]= "89j6d34cW8CKhp9S"

              auth = MerchantAuthenticationType.new(ARGV[1], ARGV[2])
              subname = ARGV.length > 3? ARGV[3]: account_type

              if(flag==2)
               xmlout = aReq.CalcelSubscription(auth,subnumber)
               xmlresp1 = HttpTransport.TransmitRequest(xmlout, ARGV[0])
               apiresp = aReq.ProcessResponse1(xmlresp1)
               puts "Subscription Creation Failed"
               apiresp.messages.each { |message|
                puts "Error Code=#{message.code}"
                puts "Error Message = #{message.text }"
                @res =  message.text
               }
               else
                @res = "no subscription"
               end
                if(@res == "The subscription has already been canceled." || @res == "Successful." || @res == "no subscription")

                end
                Postoffice.deliver_paymentsucessupdate("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, params[:account_type], hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,subscriptionid, hmm_user_det.v_user_name, pw[0].pword,link,pass_req,pass)

                redirect_to "/manage_site/upgrade/#{params[:id]}?atype=#{acctype}"

          else
            apiresp.messages.each { |message|
                puts "Error Code=#{message.code}"
                puts "Error Message =#{message.text } "
                 flash[:sucess] =  ""
                flash[:sucess_id] =  " Your Account has been upgraded successfully.<br>"
              }
                   pw=HmmUser.find(:all, :select => "v_password as pword,password_required as preq, familywebsite_password as fpword ", :conditions => "id=#{hmm_user_det.id}")

              link = "http://www.holdmymemories.com/#{hmm_user_det.family_name}"
              pass_req = pw[0].preq
              pass = pw[0].pword
                  Postoffice.deliver_paymentsucessupdate("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, params[:account_type], hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,"One time payment", hmm_user_det.v_user_name, pw[0].pword,link,pass_req,pass)

               redirect_to "/manage_site/upgrade/#{params[:id]}?atype=#{acctype}"

              hmm_user_det=HmmUser.find(params[:hmm_id])
              hmm_user_det[:subscriptionnumber] = "One time payment"

              hmm_user_det.save

            end

            puts "\nXML Dump:"
            @xmldet= xmlresp
        else

          flash[:error] ="Transaction has been declined please check your Credit card CVV number, Card Expiration date and try again"
          redirect_to "/manage_site/upgrade/#{params[:id]}?atype=#{acctype}"
        end

          end


    else


                flash[:error] =   "Error Message = This is a general error Entered Credit card number or CVV number is invalid"

               redirect_to "/manage_site/upgrade/#{params[:id]}?atype=#{acctype}"
    end

  end

  def cancel_subscription
   session[:friend]=''


   #if(logged_in_hmm_user.emp_id==nil || logged_in_hmm_user.emp_id=='')
    #redirect_to :controller => "payment_upgrade", :action => "cancel_subscript"
   #end
 end

 def cancel_sub
   session[:friend]=''
   reason = params[:reason]
   @hmm_user = HmmUser.find(logged_in_hmm_user.id)
   @hmm_user.cancel_reason=params[:reason]
   @hmm_user.cancel_status='pending'
   @hmm_user.cancellation_request_date = Time.now
   @hmm_user.save

   #Reset the credit points

#   @credit_points=CreditPoint.find(:first, :conditions => "user_id=#{session[:hmm_user]}")
#   @credit_points.available_credits=0.00
#   @credit_points.used_credits=0.00
#   @credit_points.save

     reason = params[:reason].gsub("'","`")
     sql = ActiveRecord::Base.connection();
     sql.update "UPDATE hmm_users  SET cancel_reason='#{reason}', cancel_status='pending', cancellation_request_date='#{Time.now.strftime("%Y-%m-%d")}' WHERE id=#{logged_in_hmm_user.id}";
    @hmm_user_day_dif =  HmmUser.find_by_sql("select (To_days( account_expdate ) - TO_DAYS( CURRENT_DATE() )) as difr from hmm_users where id='#{logged_in_hmm_user.id}'")
    no_of_days=@hmm_user_day_dif[0].difr
    family_pic=@hmm_user.family_pic
     img_url=@hmm_user.img_url
   if(@hmm_user.emp_id == nil || @hmm_user.emp_id == "")

    #@store_employee = EmployeAccount.find(@hmm_user.emp_id)
     flash[:notice] = 'Your Subscription Cancellation request has been sent sucessfully.'
     Postoffice.deliver_cancellation_request("Admin","admin@holdmymemories.com,,Rachel.Allen@S121.com,Bob.Eveleth@S121.com,Dan.Quinlan@holdmymemories.com,customerservice@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,logged_in_hmm_user.street_address,logged_in_hmm_user.postcode,logged_in_hmm_user.city,logged_in_hmm_user.state,logged_in_hmm_user.country,logged_in_hmm_user.telephone, reason)
     Postoffice.deliver_cancellation_request_response("admin@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,family_pic,no_of_days,img_url)

else
    @store_employee = EmployeAccount.find(@hmm_user.emp_id)
     flash[:notice] = 'Your Subscription Cancellation request has been sent sucessfully.'
     Postoffice.deliver_cancellation_request(@store_employee.employe_name,"#{@store_employee.e_mail},Rachel.Allen@S121.com,Bob.Eveleth@S121.com,Dan.Quinlan@holdmymemories.com,customerservice@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,logged_in_hmm_user.street_address,logged_in_hmm_user.postcode,logged_in_hmm_user.city,logged_in_hmm_user.state,logged_in_hmm_user.country,logged_in_hmm_user.telephone, reason)
     Postoffice.deliver_cancellation_request_response(@store_employee.e_mail,logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,family_pic,no_of_days,img_url)

      end
     render :action => 'cancel_sucess', :id=>params[:id]
 end

 def cancel_sucess

 end

  def familywebsite_option

  end



  def upgrade_payment_family_test
  require 'active_merchant'
    require "ArbApiLib"

     card_no=params[:card_no]
    cvv_no=params[:cardcvv_no]
    expiry_date="#{params[:exp_year]}-#{params[:exp_month]}"
    exp_month=params[:exp_month]
    exp_year=params[:exp_year]
    fname=params[:fname]
    lname=params[:lname]
    #amount=Integer(params[:amount])
    street_address = params[:street_address]
    #suburb = params[:suburb]
    postcode = params[:postcode]
    city = params[:city]
    state = params[:state]
    country = params[:country]
    telephone = params[:telephone]
    fax = params[:fax]
    months=params[:months]
    account_type=params[:account_type]
    email = params[:email]
     if(params[:subnumber]=='')
      invoicenumber = "HMM000HMM#{params[:hmm_id]}"
    else
      if(params[:subnumber]=='one time payment')
        invoicenumber = "HMMAP0HMM#{params[:hmm_id]}"
      end
    end
       subnumber = params[:subnumber]




    @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE('#{logged_in_hmm_user.account_expdate}',INTERVAL #{months} MONTH) as m")

    account_expdate= @hmm_user_max[0]['m']

    @uuid =  HmmUser.find_by_sql(" select UUID() as u")

    unid = "#{@uuid[0]['u']}000#{params[:hmm_id]}"
    if(account_type == "familyws_user")
      acctype="family_website"
      if(months == "1")
        amount = 4.95
        amttest=495
        amount1 = "$4.95"
      end
      if(months == "6")
        amount = 4.95
        amttest=2495
        amount1 = "$24.95"
      end
      if(months == "12")
        amount = 4.95
        amttest=4995
        amount1 = "$49.95"
      end
    else
      if(account_type == "platinum_user")
        acctype="platinum_account"
        if(months == "1")
         amount = 9.95
         amttest=995
         amount1 = "$9.95"
        end
        if(months == "6")
         amount = 9.95
         amttest=4995
         amount1 = "$49.95"
        end
        if(months == "12")
         amount = 9.95
         amttest=9995
         amount1 = "$99.95"
        end
      end
    end

    #number = '4007000000027'

     creditcard = ActiveMerchant::Billing::CreditCard.new( #:number => number, #Authorize.net test card, error-producing
     :number => card_no, #Authorize.net test card, non-error-producing
      :month => exp_month,                #for test cards, use any date in the future
      :year => exp_year,
      :first_name => fname,
      :last_name => lname,
      :verification_value => cvv_no
      #:cvv => cvv_no

                  #note that MasterCard is 'master'
    )

    if creditcard.valid?

     if(params[:account_type] = "platinum_user")
      if(account_type == "familyws_user")
        flag=1
      else
        flag=2
      end
    end


          #@creditcard = Creditcard.find(params[:id])
        gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(:test => true, :login => "8GxD65y84", :password=> "89j6d34cW8CKhp9S")
        amount_to_charge = Money.ca_dollar(amttest) #1000 = ten US dollars
        creditcard = ActiveMerchant::Billing::CreditCard.new( #:number => number, #Authorize.net test card, error-producing
     :number => card_no, #Authorize.net test card, non-error-producing
      :month => exp_month,                #for test cards, use any date in the future
      :year => exp_year,
      :first_name => fname,
      :last_name => lname,
      :verification_value => cvv_no
      #:cvv => cvv_no

                  #note that MasterCard is 'master'
    )

        options = {
          :address => {},
          :billing_address => {
          :name     => "#{fname} #{lname}",
          :address1 => street_address,
          :city     => city,
          :state    => state,
          :country  => country,
          :zip      => postcode,
          :phone    => telephone
        }
}
        response = gateway.authorize(amount_to_charge,creditcard,options)
        if response.success?
          #charge once
          gateway.capture(amount_to_charge, response.authorization)
          hmm_user_det=HmmUser.find(params[:hmm_id])
              hmm_user_det[:street_address]=params[:street_address]
              hmm_user_det[:suburb]=params[:suburb]
              hmm_user_det[:postcode]=params[:postcode]
              hmm_user_det[:city]=params[:city]
              hmm_user_det[:state]=params[:state]
              hmm_user_det[:country]=params[:country]
              hmm_user_det[:telephone]=params[:telephone]

              hmm_user_det[:account_type] = account_type

              hmm_user_det[:account_expdate] = account_expdate
              hmm_user_det[:cancel_status] = ''
              hmm_user_det[:canceled_by] = ''



              hmm_user_det[:invoicenumber] = invoicenumber
              hmm_user_det[:months] = months
              hmm_user_det[:amount] = amount1
              hmm_user_det[:unid] = unid
              hmm_user_det.save








          start_date = Time.now.strftime("%Y-%m-%d")
          @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE('#{logged_in_hmm_user.account_expdate}',INTERVAL #{months} MONTH) as m")
          account_expdate= @hmm_user_max[0]['m']

          # Write code for new subscription for  upgradation
          aReq = ArbApi.new
          if ARGV.length < 3
          puts "Usage: ArbApiSample.rb <url> <login> <txnkey> [<subscription name>]"
              #exit
            end
            ARGV[0]= "https://api.authorize.net/xml/v1/request.api"
            ARGV[1]= "8GxD65y84"
            ARGV[2]= "89j6d34cW8CKhp9S"
            #ARGV[1]= "cnpdev4289"
            #ARGV[2]= "SR2P8g4jdEn7vFLQ"
            #ARGV[3]= "644100"

            auth = MerchantAuthenticationType.new(ARGV[1], ARGV[2])
            subname = ARGV.length > 3? ARGV[3]: account_type
            interval = IntervalType.new(1, "months")
            schedule = PaymentScheduleType.new(interval, account_expdate, 9999, 0)
            cinfo = CreditCardType.new(card_no, expiry_date, cvv_no)
            binfo = NameAndAddressType.new(fname, lname,"Not added", street_address, city, state ,postcode, country,email,telephone )
            xmlout = aReq.CreateSubscription(auth,subname,schedule,amount, 0, cinfo,binfo,interval,invoicenumber)

            puts "Creating Subscription Name: #{subname}"
            puts "Submitting to URL: #{ARGV[0]}"
            xmlresp = HttpTransport.TransmitRequest(xmlout, ARGV[0])


            apiresp = aReq.ProcessResponse(xmlresp)

            if apiresp.success
              hmm_user_det=HmmUser.find(params[:hmm_id])
              hmm_user_det[:subscriptionnumber] = apiresp.subscriptionid

              hmm_user_det.save

              subscriptionid = apiresp.subscriptionid
              link = "/#{hmm_user_det.family_name}"
              pass_req = "#{hmm_user_det.password_required}"
              pass = "#{hmm_user_det.familywebsite_password}"
              #Postoffice.deliver_paymentsucess("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, params[:account_type], hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,apiresp.subscriptionid, hmm_user_det.v_user_name, hmm_user_det.v_password,link,pass_req,pass)

              flash[:sucess] =  "Subscription Created successfully"
              flash[:sucess_id] = "Your Subscription id is: #{apiresp.subscriptionid}"

                if(params[:account_type] == "free_user")
                flag=1
              else
                flag=2
              end


              if ARGV.length < 3
              end
              ARGV[0]= "https://api.authorize.net/xml/v1/request.api"
              ARGV[1]= "8GxD65y84"
              ARGV[2]= "89j6d34cW8CKhp9S"

              auth = MerchantAuthenticationType.new(ARGV[1], ARGV[2])
              subname = ARGV.length > 3? ARGV[3]: account_type

              if(flag==2)
               xmlout = aReq.CalcelSubscription(auth,subnumber)
               xmlresp1 = HttpTransport.TransmitRequest(xmlout, ARGV[0])
               apiresp = aReq.ProcessResponse1(xmlresp1)
               puts "Subscription Creation Failed"
               apiresp.messages.each { |message|
                puts "Error Code=#{message.code}"
                puts "Error Message = #{message.text }"
                @res =  message.text
               }
               else
                @res = "no subscription"
               end
                if(@res == "The subscription has already been canceled." || @res == "Successful." || @res == "no subscription")

                end
                begin
                postoffice.deliver_paymentsucessupdate("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, account_type, hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,subscriptionid, hmm_user_det.v_user_name, hmm_user_det.v_password,link,pass_req,pass)
                rescue
                logger.info("smtp error")
                end
                redirect_to "/manage_site/upgrade1/#{params[:id]}?atype=#{acctype}&sucess='Subscription Created successfully'&subscriptionnumber=#{subscriptionid}"

          else
            apiresp.messages.each { |message|
                puts "Error Code=#{message.code}"
                puts "Error Message =#{message.text } "
                 flash[:sucess] =  ""
                flash[:sucess_id] =  " Your Account has been upgraded successfully.<br>"
              }
                begin
                  Postoffice.deliver_paymentsucessupdate("#{hmm_user_det.v_fname} #{hmm_user_det.v_lname}" , hmm_user_det.v_e_mail , hmm_user_det.v_user_name, account_type, hmm_user_det.account_expdate,months,amount1,street_address, city, state ,postcode, country,telephone,invoicenumber,"One time payment", hmm_user_det.v_user_name, hmm_user_det.v_password,link,pass_req,pass)
                rescue
                  logger.info("smtp error")
                end
               redirect_to "/manage_site/upgrade1/#{params[:id]}?atype=#{acctype}&sucess='Your Account has been upgraded successfully.'&subscriptionnumber='one time payment'"

              hmm_user_det=HmmUser.find(params[:hmm_id])
              hmm_user_det[:subscriptionnumber] = "One time payment"

              hmm_user_det.save

            end

            puts "\nXML Dump:"
            @xmldet= xmlresp
        else

          flash[:error] ="Transaction has been declined please check your Credit card CVV number, Card Expiration date and try again"
          redirect_to "/manage_site/upgrade1/#{params[:id]}?atype=#{acctype}&error='Transaction has been declined please check your Credit card CVV number, Card Expiration date and try again'"
        end




    else


                flash[:error] =   "Error Message = This is a general error Entered Credit card number or CVV number is invalid"

               redirect_to "/manage_site/upgrade1/#{params[:id]}?atype=#{acctype}&error='This is a general error Entered Credit card number or CVV number is invalid'"
    end

  end

  def select_themes
    @familywebsite_themes = FamilywebsiteTheme.find(:all, :conditions => "status = 'active'", :order => "re_order")
    render :layout => true
  end

  def set_theme_worker
    @themes = FamilywebsiteTheme.find(:all, :conditions => "id = '#{params[:ckbox]}'")
    @hmm_user = HmmUser.find(:all, :conditions => "family_name = '#{params[:id]}'")
    @hmm_user_update = HmmUser.find(@hmm_user[0]['id'])
    @hmm_user_update['themes_id']=@themes[0]['id']
    @hmm_user_update['themes']=@themes[0]['theme_name']
    if @hmm_user_update.save
      flash[:notice_chg_theme] = 'Family Website Theme was successfully saved to your family website.'
    end
    #redirect_to :controller => "my_familywebsite", :action => "home", :id => params[:id]
    redirect_to "#{request_content_url}/familywebsite_setup/theme_header_update/#{@hmm_user[0]['id']}"
  end

 def destroying

    JournalsPhoto.find(params[:id]).destroy
    flash[:notice2] = 'Journal Entry Deleted!'
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details', :id => params[:familyname]

end

def destroying_subchap_journal
    SubChapJournal.find(params[:id]).destroy
      flash[:notice2] = 'Journal Entry Deleted!'
      redirect_to :controller => 'manage_site', :action => 'manage_journals_details', :id => params[:familyname]
end


def destroying_gallery_journal

    GalleryJournal.find(params[:id]).destroy
        flash[:notice2] = 'Journal Entry Deleted!'
        redirect_to :controller => 'manage_site', :action => 'manage_journals_details', :id => params[:familyname]

end

def destroying_chap_journal
    ChapterJournal.find(params[:id]).destroy
    flash[:notice2] = 'Journal Entry Deleted!'
    redirect_to :controller => 'manage_site', :action => 'manage_journals_details', :id => params[:familyname]

end

end