class ChapterCommentController < ApplicationController
 layout "standard"

 before_filter :authenticate, :only => [:allcmt_list]#, :edit, :deleteSelection, :deleteSelection1, :update]


    #protected
    def authenticate
      unless session[:hmm_user]
        flash[:notice] = 'Please Login to Access your Account'
        redirect_to :controller => "user_account" , :action => 'login'
        return false
      end
    end

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @chapter_comment_pages, @chapter_comments = paginate :chapter_comments, :per_page => 10
  end

  def show
    @chapter_comment = ChapterComment.find(params[:id])
  end

  def new
    @chapter_comment = ChapterComment.new
    render :layout => false
  end

  def new_jcmt
    @chapter_comment = ChapterComment.new
    render :layout => false
  end

  def create
    type = 'Chapter'
    @chapter_comment = ChapterComment.new(params[:chapter_comment])
    @chapter_comment['uid']="#{logged_in_hmm_user.id}"
    @chapter_comment['tag_id']= params[:tag_id]
    if(params[:tag_j_id]=='')
    params[:tag_j_id]=0
    journal= 'Journal'

  end

    @chapter_comment['tag_jid']= params[:tag_j_id]
    @chapter_comment['d_created_on']=Time.now
    $tag = params[:tag_id]
    if @chapter_comment.save
     @commentedTo_detailschap = Tag.find(params[:tag_id])
    @commentedTo_details=HmmUser.find(@commentedTo_detailschap.uid)

   # Postoffice.deliver_friend(@friend_details.id,@friend_details.v_fname,@friend_details.v_e_mail,@friend_details.v_user_name,@friend_details[:v_password],@my_details.id,@my_details.v_fname,@my_details.v_e_mail,@my_details.v_myimage)
    Postoffice.deliver_comment(params[:chapter_comment][:v_comment],journal,type,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_e_mail,@commentedTo_details.v_fname,@commentedTo_details.v_e_mail,logged_in_hmm_user.v_myimage,logged_in_hmm_user.img_url)

      $notice_cc
      flash[:notice_cc] = 'Thank-you for adding your comment.'
      if(session['redirect']=='2')
        redirect_to :controller => 'tags', :action => 'subchap_coverflow', :id => params[:tag_id]
      else
        redirect_to :controller => 'customers', :action => 'chapter_next', :id => params[:tag_id]
      end
    else
      render :action => 'new', :layout => false
    end

    #@commentedTo_detailschap = Tag.find(params[:tag_id])
   # @commentedTo_details=HmmUser.find(@commentedTo_detailschap.uid)

   # Postoffice.deliver_friend(@friend_details.id,@friend_details.v_fname,@friend_details.v_e_mail,@friend_details.v_user_name,@friend_details[:v_password],@my_details.id,@my_details.v_fname,@my_details.v_e_mail,@my_details.v_myimage)
    #Postoffice.deliver_comment(@chapter_comment.v_comment,journal,type,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_e_mail,@commentedTo_details.v_fname,@commentedTo_details.v_e_mail)
  end

  def create_cmt
    type = 'Chapter'
    @chapter_comment = ChapterComment.new(params[:chapter_comment])
    @chapter_comment['uid']="#{logged_in_hmm_user.id}"
    @chapter_comment['tag_id']= params[:tag_id]
    if(params[:tag_j_id]=='')
      params[:tag_j_id]=0
      journal= 'Journal'
    end

    @chapter_comment['tag_jid']= params[:tag_j_id]
    @chapter_comment['d_created_on']=Time.now
    $tag = params[:tag_id]
    if @chapter_comment.save
      @commentedTo_detailschap = Tag.find(params[:tag_id])
      @commentedTo_details=HmmUser.find(@commentedTo_detailschap.uid)

    # Postoffice.deliver_friend(@friend_details.id,@friend_details.v_fname,@friend_details.v_e_mail,@friend_details.v_user_name,@friend_details[:v_password],@my_details.id,@my_details.v_fname,@my_details.v_e_mail,@my_details.v_myimage)
#      Postoffice.deliver_comment(params[:chapter_comment][:v_comment],journal,type,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_e_mail,@commentedTo_details.v_fname,@commentedTo_details.v_e_mail,logged_in_hmm_user.v_myimage)

      $notice_cc
      flash[:notice_cc] = 'Thank-you for adding your comment.'
      if(session['redirect']=='2')
        redirect_to :controller => 'tags', :action => 'subchap_coverflow', :id => params[:tag_id]
      elsif(session['redirect'] = '10')
        redirect_to params[:re_send]
      else
        redirect_to :controller => 'customers', :action => 'chapter_next', :id => params[:tag_id]
      end
    else
      render :action => 'new', :layout => false
    end

    #@commentedTo_detailschap = Tag.find(params[:tag_id])
   # @commentedTo_details=HmmUser.find(@commentedTo_detailschap.uid)

   # Postoffice.deliver_friend(@friend_details.id,@friend_details.v_fname,@friend_details.v_e_mail,@friend_details.v_user_name,@friend_details[:v_password],@my_details.id,@my_details.v_fname,@my_details.v_e_mail,@my_details.v_myimage)
    #Postoffice.deliver_comment(@chapter_comment.v_comment,journal,type,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_e_mail,@commentedTo_details.v_fname,@commentedTo_details.v_e_mail)
  end



  def create_jcmt
    @chapter_comment = ChapterComment.new(params[:chapter_comment])
    @chapter_comment['uid']="#{logged_in_hmm_user.id}"
    @chapter_comment['tag_id']= params[:tag_id]
    if(params[:tag_j_id]=='')
    params[:tag_j_id]=0
    end
    @chapter_comment['tag_jid']= params[:tag_j_id]
    @chapter_comment['d_created_on']=Time.now
    $tag = params[:tag_id]
    if @chapter_comment.save
      $notice_cc_jlist
      flash[:notice_cc_jlist] = 'Thank-you for adding your comment.'
      $notice_share_jlist
      flash[:notice_share_jlist] = 'Thank-you for adding your comment'
      if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
         else  if(session['redirect']=='11')
        redirect_to :controller => 'share_journals', :action => 'shareJournal_view', :id => session['shareid']
      end
    end
    end
    else
      render :action => 'new', :layout => false
    end
  end


  def edit
    @chapter_comment = ChapterComment.find(params[:id])
  end

  def update
    @chapter_comment = ChapterComment.find(params[:id])
    if @chapter_comment.update_attributes(params[:chapter_comment])
      flash[:notice] = 'ChapterComment was successfully updated.'
      redirect_to :action => 'show', :id => @chapter_comment
    else
      render :action => 'edit'
    end
  end

  def destroy_jcmt
    @chapter_comment =ChapterComment.find(params[:id])
    @chapter_comment.destroy
    $notice_scd_jlist
      flash[:notice_scd_jlist] = 'Chapter Comment Was Successfully Deleted!!'
 if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
      end
      end
        end

  def destroy
    ChapterComment.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def comnt_list
    @hmm_user=HmmUser.find(session[:hmm_user])


     if session[:friend]!=''
      e_approval=" and e_approval = 'approve'"
     end

     if(request.request_uri == "/chapter_comment/comnt_list/")
         @tag_c = ChapterComment.find_by_sql("select a.*,b.*,a.id as cid from chapter_comments as a , hmm_users as b where a.uid=b.id ORDER BY a.id DESC ")
     else
      if(params[:id]=='0' || params[:id]==0 )
          @update="me"
         @tag_c = ChapterComment.find_by_sql("select a.*,b.*,a.id as cid from chapter_comments as a , hmm_users as b where tag_id=#{params[:tag_id]} and tag_jid=''  and a.uid=b.id #{e_approval} ORDER BY a.id DESC")
      else
        @update="me2"
         @tag_c = ChapterComment.find_by_sql("select a.*,b.*,a.id as cid from chapter_comments as a , hmm_users as b where tag_jid=#{params[:id]} and a.uid=b.id #{e_approval} ORDER BY a.id DESC ")
      end
    end

    @tagid=params[:tag_id]
    @id=params[:id]
    i=0

    for cn in @tag_c
      i=i+1
    end
  @total=i

  @numberofpagesres=@total/3

  @numberofpages=@numberofpagesres.round()

  if(params[:page]==nil)
  x=0
  y=3
  @page=0
  @nextpage=@page+1
  if(@total<=3)
  @nonext=1
  end
  else
    x=3*Integer(params[:page])
    y=3
    @page=Integer(params[:page])
    @nextpage=@page+1
    @previouspage=@page-1
    if(@page==@numberofpages)
      @nonext=1
    end
    if(@total<=3)
  @nonext=1
  end
  end

     if(request.request_uri == "/chapter_comment/comnt_list/")
         @tag_c = ChapterComment.find_by_sql("select a.*,b.*,a.id as cid from chapter_comments as a , hmm_users as b where a.uid=b.id ORDER BY a.id DESC limit  #{x},#{y}")
     else
      if(params[:id]=='0' || params[:id]==0)
         @tag_c = ChapterComment.find_by_sql("select a.*,b.*,a.id as cid from chapter_comments as a , hmm_users as b where tag_id=#{params[:tag_id]} and tag_jid=''  and a.uid=b.id #{e_approval} ORDER BY a.id DESC limit #{x},#{y}")
      else
         @tag_c = ChapterComment.find_by_sql("select a.*,b.*,a.id as cid from chapter_comments as a , hmm_users as b where tag_jid=#{params[:id]} and a.uid=b.id #{e_approval} ORDER BY a.id DESC limit #{x},#{y}")
      end
    end

    #@tag_comment = ChapterComment.find(:all, :conditions => "tag_id=#{params[:id]} && uid=#{logged_in_hmm_user.id}")
    render :layout => false
  end

  def jcomment_list
  	@mode=params[:mode]
    #@tag_comment = ChapterComment.find(:all, :conditions => "tag_id=#{params[:id]} && uid=#{logged_in_hmm_user.id}")

     if(params[:familyname])
	 	   @hmm_user=HmmUser.find(:all, :conditions => "family_name = '#{params[:familyname]}' ")
		   @hmm_user=@hmm_user[0]
		   e_approved="and e_approval='approve'"
		   e_approved1="and e_approved='approve'"
	     approved="and status='accepted'"
		   uid1=@hmm_user.id
	 else
	   if session[:friend] == ''
      @hmm_user=HmmUser.find(session[:hmm_user])
	 	  uid1=logged_in_hmm_user.id
	 	else
      uid1=session[:friend]
    end
   end
    sharejournalcnt = ShareJournal.find_by_sql("
  select
    count(*) as cnt
    from
    share_journalcomments as d,
    share_journals as u
    where
    d.shareid = u.id and  u.presenter_id=#{uid1}
    ")

    tagcout = Tag.find_by_sql(" select
         count(*) as cnt
         from chapter_comments  as a,tags as t
         where
         a.tag_id=t.id
         and
         t.uid=#{uid1} ")


	guestcout = GuestComment.count(:all, :conditions => "journal_id=#{params[:id_journal]} and journal_type='#{@mode}'" )


   usercontentcnt=Integer(tagcout[0].cnt)

   sharejournalcnt=Integer(sharejournalcnt[0].cnt)

   @total=usercontentcnt+sharejournalcnt+guestcout

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

    if(@mode=='chapter')

		sql_query="(select
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
			 and
			 a.tag_jid=#{params[:id_journal]}

		 	) "

			@table=Tag
			@path_controller="chapter_comment"
			@path_share="/share_journals/shareJournal_view/"
	 else
	 	if(@mode=='sub-chapter')
	 		sql_query="(select
			 a.id as id,
			 a.subchap_id as master_id,
			 a.v_comments as comment,
			 a.reply as reply,
			 a.e_approval as e_approval,
			 a.ctype as ctype,
			 h.v_fname as name,
			 a.uid as user_id,
			 a.d_created_on as d_created_at
			 from subchap_comments as a, hmm_users as h
			 where
			 a.subchap_jid=#{params[:id_journal]}
			 and
			 h.id=a.uid

			  #{e_approved}
		 	)"
			@path_controller="subchap_comment"
			@path_share="share_journals"
			@table=SubChapter
	 	else
	 		if(@mode=='gallery')
				sql_query="(select
				 a.id as id,
				 a.gallery_id as master_id,
				 a.v_comment as comment,
				 a.reply as reply,
				 a.e_approval as e_approval,
				 a.ctype as ctype,
				 h.v_fname as name,
				 a.uid as user_id,
				 a.d_created_on as d_created_at
				 from gallery_comments as a, hmm_users as h
				 where
				 a.gallery_jid=#{params[:id_journal]}
				 and
				 h.id=a.uid

				  #{e_approved}
				)"
				@path_controller="gallery_comment"
				@path_share="/share_journals/shareJournal_view/"
				@table=Galleries
	 		else
	 			if(@mode=='photo')
					sql_query="(select
					 a.id as id,
					 a.user_content_id as master_id,
					 a.v_comment as comment,
					 a.reply as reply,
					 a.e_approved as e_approval,
					 a.ctype as ctype,
					 h.v_fname as name,
					 a.uid as user_id,
					 a.d_add_date as d_created_at
					 from photo_comments as a, hmm_users as h
					 where
					 a.journal_id=#{params[:id_journal]}
					 and
					 h.id=a.uid

					  #{e_approved1}
					)"
					@path_controller="photo_comments"
			    	@path_share="/share_journals/shareJournal_view/"
					@table=UserContent
	 	    end
	    end
	end
	 end


	 sql_share_union="
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
        and
        r.journal_id=#{params[:id_journal]}
        and
        r.journal_type='#{@mode}'
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
        g.id as user_id,
        g.comment_date as d_add_date
        from
        guest_comments as g

        where
        g.journal_id=#{params[:id_journal]}
        and
        g.journal_type='#{@mode}'

     )order by d_created_at desc limit #{x}, #{y}"


	 @tagid=ChapterComment.find_by_sql("#{sql_query} #{sql_share_union}")

    #@tagid=ChapterComment.find_by_sql("
   #(select

    #     a.id as id,
     #    a.tag_id as master_id,
      #   a.v_comment as comment,
       #  a.reply as reply,
        # a.e_approval as e_approval,
         #a.ctype as ctype,
         #a.v_name as name,
         #a.uid as user_id,
         #a.d_created_on as d_created_at
         #from chapter_comments as a,tags as t
         #where
         #a.tag_id=t.id
         #and

         #t.uid=#{uid1}
         #and
        #a.tag_jid=#{params[:id_journal]}
     #)
     #union
    #(select
    #    r.id as id,
     #   r.shareid as master_id,
     #   r.comment as comment,
     #   r.reply as reply,
     #   r.status as e_approval,
     #   r.ctype as ctype,
     #   r.name as name,
     #   r.id as user_id,
     #   r.comment_date as d_add_date
     #   from
     #   share_journalcomments as r,
     #   share_journals as z
     #   where
     #   r.shareid=z.id
     #   and
     #   z.presenter_id=#{uid1}
     #   and
     #   r.journal_id=#{params[:id_journal]}
     #   and
      #  r.journal_type='chapter'

    # )

	# union
    #(select
    #    g.id as id,
    #    g.journal_typeid as master_id,
    #    g.comment as comment,
    #    g.ctype as reply,
    #    g.status as e_approval,
    #    g.ctype as ctype,
    #    g.name as name,
    #    g.id as user_id,
    #    g.comment_date as d_add_date
    #    from
    #    guest_comments as g,
    #    chapter_journals as j
    #    where
    #    g.journal_id=#{params[:id_journal]}
    #    and
    #    g.journal_type='chapter'

    # )order by d_created_at desc limit #{x}, #{y} ")





    render(:layout => false)




  end

  def allcmt_list

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
        b.subchap_jid as name,
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

   def allcmt_list1
    @hmm_user=HmmUser.find(session[:hmm_user])
      items_per_page = 10
   #@condition = ChapterComment.find_by_sql("select a.*,b.*,a.id as cid from chapter_comments as a, hmm_users as b where b.id=#{logged_in_hmm_user.id} and a.uid=b.id ORDER BY a.id DESC")

   @share_comment_pages, @share_comment = paginate :share, :per_page => items_per_page, :joins =>"as a, share_comments as b ", :conditions=> " a.id=b.share_id and a.presenter_id=#{logged_in_hmm_user.id}", :order => 'b.id desc'
    #@share_comment = ShareComment.find(:all, :conditions => "share_id=#{params[:id]} && uid=#{logged_in_hmm_user.id}")
   render :layout => true
  end

  def add_comment
     @hmm_user=HmmUser.find(session[:hmm_user])
     @chapter_comment =ChapterComment.find(params[:cid])
     @chapter_comment['e_approval'] = 'approve'
     @chapter_comment.save
     $notice_cca
     flash[:notice_cca] = 'Chapter Comment  Approved successfully!!'
     #@tag = ChapterComment.find_by_sql(:all, :conditions => 'id=#{params[:id]}')
     #@tag = ChapterComment.find_by_sql("select tag_id from chapter_comments where id=#{params[:id]} ")
#     if(request.request_uri == "/chapter_comment/comnt_list/" )
#        redirect_to :controller => 'chapter_comment', :action => 'comnt_list'
#     else
     #redirect_to session[:redirect]
      if(session['redirect']=='2')
        redirect_to :controller => 'chapter_comment', :action => 'comnt_list', :tag_id => session[:tag_id], :page=>params[:page], :id => params[:id]
      else if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
      else
      redirect_to :controller => 'chapter_comment', :action => 'comnt_list', :tag_id => session[:tag_id], :page=>params[:page], :id => params[:id]
       end

  end
    end
  end

  def approve_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @chapter_comment =ChapterComment.find(params[:id])
     @chapter_comment['e_approval'] = 'approve'
     @chapter_comment.save
      $notice_cca_list
     flash[:notice] = 'Chapter Comment was Approved!!'
     #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
     redirect_to :controller => 'my_familywebsite', :action => 'comments_list'

  end

  def approve_jcmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @chapter_comment =ChapterComment.find(params[:id])
     @chapter_comment['e_approval'] = 'approve'
     @chapter_comment.save
      $notice_cca_jlist
     flash[:notice_cca_jlist] = 'Chapter Comment was Approved!!'
      if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
      else
      redirect_to :controller => 'chapter_comment', :action => 'comnt_list', :tag_id => session[:tag_id], :page=>params[:page], :id => params[:id]
    end
    end
  end

   def reject_comment
     @hmm_user=HmmUser.find(session[:hmm_user])
     @chapter_comment =ChapterComment.find(params[:cid])
     @chapter_comment.destroy
    $notice_ccr
     flash[:notice_ccr] = 'Chapter Comment  Rejected'
     if(session['redirect']=='2')
       # redirect_to :controller => 'tags', :action => 'subchap_coverflow', :id => session[:tag_id]
          redirect_to :controller => 'chapter_comment', :action => 'comnt_list', :tag_id => session[:tag_id], :page=>params[:page], :id => params[:id]

      else if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
      else
      redirect_to :controller => 'chapter_comment', :action => 'comnt_list', :tag_id => session[:tag_id], :page=>params[:page], :id => params[:id]
   end
    end
    end
   end

  def reject_cmt
     @hmm_user=HmmUser.find(session[:hmm_user])
     @chapter_comment =ChapterComment.find(params[:id])
      @chapter_comment.destroy
     # @chapter_comment['e_approval'] = 'reject'
      #@tag_cid = ChapterComment.find(:all, :conditions => "tag_jid=#{params[:id]} " , :order => "id DESC")
    #@chapter_comment.save
    $notice_ccr_list
     flash[:notice] = 'Chapter Comment Rejected'
     #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
     redirect_to :controller => 'my_familywebsite', :action => 'comments_list'

   end

  def reject_jcmt

    @chapter_comment =ChapterComment.find(params[:id])
    @chapter_comment.destroy
    $notice_ccd_jlist
     flash[:notice_ccd_jlist] = 'Chapter Comment was Deleted!!'
     if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
    else
    redirect_to :controller => 'chapter_journal', :action => 'journals'
    end


   end

  def comt_destroy
    @chapter_comment =ChapterComment.find(params[:cid])
    @chapter_comment.destroy
    $notice_ccd
     flash[:notice_ccd] = 'Chapter Comment Deleted successfully!!'
    if(session['redirect']=='2')
        #redirect_to :controller => 'tags', :action => 'subchap_coverflow', :id => session[:tag_id]
        redirect_to :controller => 'chapter_comment', :action => 'comnt_list', :tag_id => session[:tag_id], :page=>params[:page], :id => params[:id]
      else if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        else  if(session['redirect']=='5')
        redirect_to :controller => 'chapter_journal', :action => 'journals'
      else
    redirect_to :controller => 'chapter_comment', :action => 'comnt_list', :tag_id => session[:tag_id], :page=>params[:page], :id => params[:id]
      end
  end
  end
  end

  def destroy_cmt
    @chapter_comment =ChapterComment.find(params[:id])
    @chapter_comment.destroy
    $notice_ccd_list
     flash[:notice] = 'Chapter Comment was Deleted!!'
    #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
    redirect_to :controller => 'my_familywebsite', :action => 'comments_list'
  end

   def destroy_jcmt
    @chapter_comment =ChapterComment.find(params[:id])
    @chapter_comment.destroy
    $notice_ccd_jlist
     flash[:notice_ccd_jlist] = 'Chapter Comment was Deleted!!'
     if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
    else
    redirect_to :controller => 'chapter_journal', :action => 'journals'
    end
  end

  def reply_comnt
  render :layout => false

  end


  def reply_comment
    puts session[:redirect]
     @hmm_user=HmmUser.find(session[:hmm_user])
     if(params[:table]=='chapter_comments')
      @chapter_comment =ChapterComment.find(params[:cid])
    else
       if(params[:table]=='subchap_comments')
      @chapter_comment =SubchapComment.find(params[:cid])
    else
        if(params[:table]=='gallery_comments')
         @chapter_comment =GalleryComment.find(params[:cid])
    else
        if(params[:table]=='photo_comments')
         @chapter_comment =PhotoComment.find(params[:cid])
    else
        if(params[:table]=='share_journalcomments')
         @chapter_comment =ShareJournalcomment.find(params[:cid])
    else
        if(params[:table]=='share_comments')
          @chapter_comment =ShareComments.find(params[:cid])
        end
    end
    end
  end
end
end

     @chapter_comment.reply = params[:reply]
     @chapter_comment.save
     $notice_cca
     flash[:notice_cca] = 'Reply added successfully!!'
     #@tag = ChapterComment.find_by_sql(:all, :conditions => 'id=#{params[:id]}')
     #@tag = ChapterComment.find_by_sql("select tag_id from chapter_comments where id=#{params[:id]} ")
#     if(request.request_uri == "/chapter_comment/comnt_list/" )
#        redirect_to :controller => 'chapter_comment', :action => 'comnt_list'
#     else
     #redirect_to session[:redirect]
      if(params['redirect']=='111' && session['redirect']!='7')
         redirect_to :controller => 'tags', :action => 'memories', :id => @chapter_comment[:share_id]
      else
       if(session['redirect']=='2' && params[:table]=='chapter_comments' && session['redirect']!='5' && session['redirect_mange']!='1' && session['redirect']!='7')
        redirect_to :controller => 'tags', :action => 'subchap_coverflow', :id => params[:tag_id]
      else
        if( params[:table]=='chapter_comments' && session['redirect']!='3' && session['redirect']!='5' && session['redirect_mange']!='1' && session['redirect']!='7')
        redirect_to :controller => 'customers', :action => 'chapter_next', :id => params[:tag_id]
      else
        if(session['redirect']=='2' && params[:table]=='subchap_comments' && session['redirect']!='5' && session['redirect_mange']!='1' && session['redirect']!='7')
         redirect_to :controller => 'galleries', :action => 'gallery_coverflow', :id => params[:tag_id]
        else
        if( params[:table]=='subchap_comments' && session['redirect']!='3' && session['redirect']!='5' && session['redirect_mange']!='1' && session['redirect']!='7')
          redirect_to :controller => 'customers', :action => 'sub_chapter_gallery', :id =>  params[:tag_id]

        else
        if(session['redirect']=='2' && params[:table]=='gallery_comments' && session['redirect']!='3' && session['redirect_mange']!='1' && session['redirect']!='7')
         redirect_to :controller => 'galleries', :action => 'gallery_fisheye', :id => params[:tag_id]
        else
        if( params[:table]=='gallery_comments' && session['redirect']!='3' && session['redirect']!='5' && session['redirect_mange']!='1' && session['redirect']!='7')
          redirect_to :controller => 'customers', :action => 'chapter_gallery', :id =>  params[:tag_id]
         else
        if(session['redirect']=='2' && params[:table]=='photo_comments' && session['redirect']!='5' && session['redirect_mange']!='1' && session['redirect']!='7')
      redirect_to :controller => 'myphotos', :action => 'photo_journal' , :id => params[:tag_id]
       else
        if( params[:table]=='photo_comments' && session['redirect']!='3' && session['redirect']!='5' && session['redirect_mange']!='1' && session['redirect']!='7')
          redirect_to :controller => 'myphotos', :action => 'photo_journal' , :id =>params[:tag_id]
        else
          if( session['redirect']=='7' )
          redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
        else
             if( session['redirect']=='5' && session['redirect_mange']!='1'  && session['redirect']!='7')
          redirect_to :controller => 'chapter_journal', :action => 'journals', :page => params[:page]
          else     if( session['redirect_mange']=='1' && session['redirect']=='' && session['redirect']!='7' )
          redirect_to :controller => 'customers', :action => 'manage', :page => params[:page]

        end

        end
        end
        end
        end
        end
        end
        end
      end
      end
    end
    end
  end

end