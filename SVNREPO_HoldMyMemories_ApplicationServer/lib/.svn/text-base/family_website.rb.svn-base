module FamilyWebsite

  protected
  def fw_biography(family_website_owner)
    biographies = FamilyMember.find(:all, :conditions => "uid='#{family_website_owner.id}'", :order => 'id')
    return biographies
  end

#  def display_comments(family_website_owner)
#    comments = GuestComment.find(:all, :conditions => "uid='#{family_website_owner.id}'", :order => 'id')
#    return biographies
#  endfamily_website_owner

  def fw_display_comments(facebook_profile_id)


    if(params[:facebook]=='true')
      session[:family]=params[:id]
    end

    if facebook_profile_id == "nil"
      @userid = HmmUser.find(:all, :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')")
    else
      @userid = HmmUser.find(:all, :conditions => "(facebook_profile_id='#{facebook_profile_id}')")
    end


    @uid = @userid[0]['id']
    @hmmuserid = HmmUser.find(:all, :conditions => "id='#{@uid}'")

    @message_board_count = MessageBoard.count(:all, :conditions => "uid=#{@uid}")
    @familyname=params[:id]

    uid1=@uid

    tagcout = Tag.find_by_sql(" select
         count(*) as cnt
         from chapter_comments as a,tags as t
         where
         a.tag_id=t.id
         and
         t.uid=#{uid1}
         and a.e_approval = 'approve'")
    subcount = SubChapter.find_by_sql("
       select
        count(*) as cnt
        from
        subchap_comments as b,
        sub_chapters as s
        where
        s.uid=#{uid1}
        and
        b.subchap_id=s.id
        and b.e_approval='approve'")
    galcount = Galleries.find_by_sql("select
        count(*) as cnt
        from
        gallery_comments as c,
        galleries as g,
        sub_chapters as s1
        where
        s1.uid=#{uid1}
        and
        c.gallery_id=g.id
        and g.subchapter_id=s1.id
        and c.e_approval='approve'")

    usercontentcount = UserContent.find_by_sql("
  select
       count(*) as cnt
        from
        photo_comments as d,
        user_contents as u
        where
        d.user_content_id=u.id and u.uid=#{uid1}
        and d.e_approved='approve'
      ")
    sharecount = Share.find_by_sql("
  select
       count(*) as cnt
        from
        share_comments    as d,
        shares as u
        where
        d.share_id =u.id and u.presenter_id=#{uid1}
        and d.e_approved='approved'

      ")
    sharejournalcnt = ShareJournal.find_by_sql("
  select
    count(*) as cnt
    from
    share_journalcomments as d,
    share_journals as u
    where
    d.shareid = u.id and u.presenter_id=#{uid1}
    and d.status='accepted'
      ")


    guestmessagecount = MessageBoard.count(:all, :conditions => "uid=#{uid1}")

    guestcommentcount = GuestComment.find_by_sql("
    select
    count(*) as cnt
    from
    guest_comments
    where
    uid=#{uid1}
    and status='approve'
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

    #@tagid= ChapterComment.paginate(:all, :select=>"h.id as id,h.v_fname as v_fname,h.v_lname as v_lname,h.family_name as family_name", :joins => "as t, hmm_users as h", :conditions => ["t.uid = h.id and t.import_type != 'default' and t.status = 'active' and " +"h.v_fname LIKE ? and h.v_lname LIKE ? and h.family_name LIKE ?", "#{@firstname}%","#{@lastname}%", "#{@familyname}%"], :page => params[:page] ,:per_page => 10, :group => "h.id" ,:order =>  sort)


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
         a.e_approval = 'approve'
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
        b.subchap_jid as name,
        b.uid as user_id,
        b.d_created_on as d_created_at
        from
        subchap_comments as b,
        sub_chapters as s
        where
        s.uid=#{uid1}
        and
        b.subchap_id=s.id
        and
        b.e_approval='approve'
     )
     union
     (select
        c.id as id,
        c.gallery_id as master_id,
        c.v_comment as comment,
        c.reply as reply,
        c.e_approval as e_approval,
        c.ctype as ctype,
        c.gallery_jid as name,
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
        and g.subchapter_id=s1.id
        and c.e_approval='approve'
        )

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
        and d.e_approved='approve'
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
        d.d_add_date as d_created_at
        from
        share_comments as d,
        shares as s
        where
        d.share_id=s.id
        and
        s.presenter_id=#{uid1}
        and d.e_approved='approved'
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
        p.added_date as d_created_at
        from
        share_momentcomments as p,
        share_moments as q
        where
        p.share_id=q.id
        and
        q.presenter_id=#{uid1}
        and p.e_approved='approved'
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
        r.comment_date as d_created_at
        from
        share_journalcomments as r,
        share_journals as z
        where
        r.shareid=z.id
        and
        z.presenter_id=#{uid1}
        and r.status='accepted'
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
        g.comment_date as d_created_at
        from
        guest_comments as g
        where
        g.uid=#{uid1}
        and g.status='approve'
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
        and h.status='accept'
     )
     order by d_created_at desc limit #{x}, #{y} ")

    puts x
    puts y

    if(session[:journal]=='journal')
      render :layout => true
      session[:journal] = nil
    else if(params[:page]==nil)

      else
        render :layout => false
      end
    end

  end


    def fw_emailus()
     
      
        @result = HmmUser.find(:first,:select => "hmm_users.v_user_name,hmm_users.v_fname,hmm_users.v_lname,hmm_studios.studio_name,studio_id", :joins =>" LEFT JOIN hmm_studios
          ON hmm_users.studio_id=hmm_studios.id", :conditions => "hmm_users.id=#{@family_website_owner.id}")
     

      @current_page = 'emailus'
        unless params[:email].blank? && params[:email].blank? && params[:email].blank?
          #if simple_captcha_valid?
          @contactus = ContactU.new()
          #@contactus = ContactU.new
          @contactus.first_name =params[:name]
          @contactus.subject = "HoldMyMemories.com - #{params[:name]} has sent you an email from HoldMyMemories.com... "
          @contactus.message =params[:message]
          @contactus.email =params[:email]

           users_studio_id = @result.studio_id
  

          if @contactus.save
            Postoffice.deliver_contactUsreportmysite(@contactus.first_name,@contactus.subject,@contactus.message,@contactus.country,@contactus.email,@family_website_owner.v_e_mail)
            flash[:message] = "Thank You, Your Email has Been Sent to #{@family_website_owner.v_fname} #{@family_website_owner.v_lname}."
          end
    #      @error1="test"
    #            else
    #              flash[:msg] = "Please enter the correct code!"
    #              @error1="Please enter the correct code!"
    #            end
        end
        logger.info("params for contact_ujin FW")
        logger.info(params[:contact_u]).inspect
        logger.info("checked contact_u  params in FWebsite")
        if(params[:contact_u])

          @contact_u = ContactU.new
          #if simple_captcha_valid?
            @result = HmmUser.find(:first,:select => "hmm_users.v_user_name,hmm_studios.studio_name,studio_id,hmm_users.v_fname,hmm_users.v_lname", :joins =>" LEFT JOIN hmm_studios
            ON hmm_users.studio_id=hmm_studios.id", :conditions => "hmm_users.id=#{@family_website_owner.id}")

              @managers1 = MarketManager.count(:first,:select => "a.e_mail", :joins=>" as a,manager_branches as b",
                :conditions => "a.id=b.manager_id and b.branch_id=#{@result.studio_id}")
            if(@managers1 > 0)

                @managers = MarketManager.find(:first,:select => "a.e_mail", :joins=>" as a,manager_branches as b",
                  :conditions => "a.id=b.manager_id and b.branch_id=#{@result.studio_id}")
                @manager_email= @managers.e_mail
               else
              @manager_email=''
            end

            if @result.studio_id != 0
                @studios = HmmStudio.find(:first,:select => "studio_name,contact_email,studio_groupid",:conditions => "id=#{@result.studio_id}")
            end

            @contact_u = ContactU.new(params[:contact_u])
            @hmm_user_belongs_to = HmmUser.count(:all,:conditions => "v_e_mail='#{@contact_u.email}'")
           # studio_group_id = @studios.studio_groupid

            if(@hmm_user_belongs_to > 0)
              @hmm_user_belongs_to_det = HmmUser.find(:all,:conditions => "v_e_mail='#{@contact_u.email}'")
              emp_id= @hmm_user_belongs_to_det[0]['emp_id']
              customer_name="#{@hmm_user_belongs_to_det[0]['v_fname']} #{@hmm_user_belongs_to_det[0]['v_lname']}"
              acc_type=@hmm_user_belongs_to_det[0]['account_type']
              if(acc_type=="free_user")
                customer_account="Free User Account"
              else
                if(acc_type=="platinum_user")
                  customer_account="Premium User Account"
                else
                  customer_account="Family Website User Account"
                end
              end


              if(emp_id=='' || emp_id==nil )
                studio_group_id = "nil"
                @contact_u.subject = "HoldMyMemories Contact Us Information..."
                #,studio_group_id
                if @studios != "nil"
                      Postoffice.deliver_contactUsreport_email1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,"Direct User","No employee involved",customer_name,customer_account,@studios.contact_email,@manager_email)
                else
                      Postoffice.deliver_contactUsreport_email1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,"Direct User","No employee involved",customer_name,customer_account,"kmehdi85@gmail.com",@manager_email)
                end
              #Postoffice.deliver_contactUsreport_email1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,"Direct User","No employee involved",customer_name,customer_account,@studios.contact_email,"khizer@hysistechnologies.com,khizermehdida1@yopmail.com")

              else
                @employee_details = EmployeAccount.find(emp_id)
                branch = @employee_details.branch
                e_mail = @employee_details.e_mail
                emp_name = @employee_details.employe_name
                @contact_u.subject = "HoldMyMemories Contact Us Information..."


                #           click_studio_id = 3
                #emp_store_id = @employee_details.store_id
                #   studio_group_id = @studios.studio_groupid
                #
                #,emp_store_id
                #            if(@studios.studio_groupid == click_studio_id && @studios.id == emp_store_id)
                #              @manager_email = ,+"seth.johnson@holdmymemories.com,angie@holdmymemories.com"
                #            end ,studio_group_id
                #  Postoffice.deliver_contactUsreport_email1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,@studios.studio_name,emp_name,customer_name,customer_account,@studios.contact_email,@manager_email,emp_store_id,studio_group_id)
                studio_group_id = @studios.studio_groupid
                if @result.studio_id != 0
                    Postoffice.deliver_contactUsreport_email1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,@studios.studio_name,emp_name,customer_name,customer_account,@studios.contact_email,@manager_email)

                else
                   Postoffice.deliver_contactUsreport_email1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,"@studios.studio_name",emp_name,customer_name,customer_account,"kmehdi85@gmail.com",@manager_email)
                end
              end
            else
              #,studio_group_id
              studio_group_id = "nil"
              @contact_u.subject = "HoldMyMemories Contact Us Information..."
              if @studios != "nil"
                  Postoffice.deliver_contactUsreport_email(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,@contact_u.zip,@contact_u.phone_no,@contact_u.mobile_no,@studios.contact_email,@manager_email)
              else
                  Postoffice.deliver_contactUsreport_email(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,@contact_u.zip,@contact_u.phone_no,@contact_u.mobile_no,"kmehdi85@gmail.com,khizermehdida1@yopmail.com",@manager_email)
              end
            end
            @contact_u.subject = "HoldMyMemories Contact Us Information..."
            if @contact_u.save
              #,studio_group_id
              #Postoffice.deliver_contactUsreport(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email)
             if @studios != "nil"
                  @flash[:notice_contact] = "Thank You, Your Email has Been Sent to #{@studios.studio_name}"
             else
                  flash[:notice_contact] = "Thank You, Your Email has Been Sent to Hold My memories.com"
             end
            else
              redirect_to :action => 'emailus'
            end
            @error2='test'
    #              else
    #                flash[:error] = 'Please enter the correct image code!'
    #                @error2='Please enter the correct image code!'
    #              end
         end

    end


    def fw_contact_new
    @contact_u = ContactU.new
    if(params[:contact_u])
     # if simple_captcha_valid?
        @contact_u = ContactU.new(params[:contact_u])
    @hmm_user_belongs_to = HmmUser.count(:all,:conditions => "v_e_mail='#{@contact_u.email}'")
    if(@hmm_user_belongs_to > 0)
      @hmm_user_belongs_to_det = HmmUser.find(:all,:conditions => "v_e_mail='#{@contact_u.email}'")
      emp_id= @hmm_user_belongs_to_det[0]['emp_id']
      customer_name="#{@hmm_user_belongs_to_det[0]['v_fname']} #{@hmm_user_belongs_to_det[0]['v_lname']}"
      acc_type=@hmm_user_belongs_to_det[0]['account_type']
      if(acc_type=="free_user")
        customer_account="Free User Account"
      else
        if(acc_type=="platinum_user")
          customer_account="Premium User Account"
        else
          customer_account="Family Website User Account"
        end
      end

      if(emp_id=='' || emp_id==nil )
        @contact_u.subject = "HoldMyMemories Contact Us Information..."
        Postoffice.deliver_contactUsreport1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,"Direct User","No employee involved",customer_name,customer_account)

      else
        @employee_details = EmployeAccount.find(emp_id)
        branch = @employee_details.branch
        e_mail = @employee_details.e_mail
        emp_name = @employee_details.employe_name
        @contact_u.subject = "HoldMyMemories Contact Us Information..."
        Postoffice.deliver_contactUsreport1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,branch,emp_name,customer_name,customer_account)
      end
    else
      @contact_u.subject = "HoldMyMemories Contact Us Information..."
      Postoffice.deliver_contactUsreport("Bob.Eveleth@S121.com,Rachel.Allen@S121.com,customerservice@holdmymemories.com,Dan.Quinlan@holdmymemories.com",@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,@contact_u.zip,@contact_u.phone_no,@contact_u.mobile_no)

    end
    @contact_u.subject = "HoldMyMemories Contact Us Information..."
    if @contact_u.save
       #Postoffice.deliver_contactUsreport(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email)

      flash[:notice_contact] = 'Thank You for submitting the details'
      #redirect_to :action => 'new'
    else
      flash[:notice_contact] = 'Sorry your details  not Saved'
      #redirect_to :action => 'new'
    end
#      else
#        flash[:error] = 'Please enter the correct code!'
#      end
    end
  end






    def fw_mw_home(logged_in_hmm_user)
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


    def fw_intro
    @current_page = 'contest'
    #redirect_to "/familywebsite_contest/previous_contest/#{params[:id]}"
    @topentries_photo = Contest.find(:all,:select => "a.*, b.*, a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b",
     :conditions => "a.moment_id = b.id and a.moment_type = 'image' and a.contest_phase='#{contest_phase}'and a.status = 'active'", :order => "a.votes desc", :limit =>"10")

    @topentries_video = Contest.find(:all,:select => "a.*, b.*, a.id as contest_id, a.first_name as contest_fname" ,:joins=>"as a, user_contents as b",
     :conditions => "a.moment_id = b.id and a.moment_type = 'video' and a.contest_phase='#{contest_phase}'and a.status = 'active'", :order => "a.votes desc", :limit =>"10")
  end


end



