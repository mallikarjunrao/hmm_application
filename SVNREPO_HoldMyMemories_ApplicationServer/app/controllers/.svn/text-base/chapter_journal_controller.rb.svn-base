class ChapterJournalController < ApplicationController
  
  layout "myfamilywebsite"
  helper :user_account
  include UserAccountHelper

  
  before_filter :authenticate, :only => [ :journals]#, :edit, :deleteSelection, :deleteSelection1, :update]


    #protected
    def authenticate
      unless session[:hmm_user]
        flash[:notice] = 'Please Login to Access your Account'
        redirect_to :controller => "user_account" , :action => 'login'
        return false
        else
        if (session[:flag] == 1 && request.request_uri != "/customers/upgrade/platinum_account")
          flash[:error] = "Your credit card payment to HoldMyMemories.com has been declined by your credit card company. This could be for a number of reasons, including an expired card. <br><br><br>Please re-enter your credit card information, or use a different card for the renewal of your account."
          redirect_to "https://www.holdmymemories.com/customers/upgrade/platinum_account"
        end 
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
    @chapter_journal_pages, @chapter_journals = paginate :chapter_journals, :per_page => 10
  end

  def show
    @chapter_journal = ChapterJournal.find(params[:id])
  end

  def new
    @hmm_user=HmmUser.find(session[:hmm_user])
    @chapter_journal = ChapterJournal.new
    @chap = Tag.find(:all, :conditions => "id=#{params[:id]}")
     @chapter_journal_count = ChapterJournal.count(:all,:conditions => "tag_id='#{params[:id]}'")
    if (@chapter_journal_count>0)
        @chapter_journal = ChapterJournal.find(:all,:conditions => "tag_id='#{params[:id]}'")
              redirect_to :controller => 'chapter_journal', :action => 'edit', :id => @chapter_journal[0]['id'] 
  
    end
  end

  def create
    @chapter_journal = ChapterJournal.new(params[:chapter_journal])
    @chapter_journal['tag_id']=params[:tag_id]
   
     @chapter_journal['d_updated_at']=Time.now
     
    if @chapter_journal.save
     $notice1 
      flash[:notice] = 'Chapter Journal created!'
     if(session['redirect']=='2')
        redirect_to :controller => 'tags', :action => 'subchap_coverflow', :id => session[:tag_id] 
      else
        redirect_to :controller => 'customers', :action => 'chapter_next', :id => session[:tag_id] 
      end
     
    
    else
      render :action => 'new'
    end
  end

  def edit
    @chapter_journal = ChapterJournal.find(params[:id])
  
     @chap_j = ChapterJournal.find(:all, :joins => "as a , tags as b", :conditions => "a.tag_id=b.id and a.id=#{params[:id]}")  
   end

  def update
    
    @chapter_journal = ChapterJournal.find(params[:id])
    @chapter_journal['d_updated_at']=Time.now
    @chapter_journal['d_created_at']=Time.now
     
    if @chapter_journal.update_attributes(params[:chapter_journal])
      
       #@chapter_journal['d_created_at']=Time.now
       
        @chap_j = ChapterJournal.find(:all, :joins => "as a , tags as b", :conditions => "a.id=#{params[:id]} and a.tag_id=b.id")  
      $notice2
      flash[:notice] = 'Chapter Journal updated!'
     if(session['redirect']=='2')
        redirect_to :controller => 'tags', :action => 'subchap_coverflow', :id => session[:tag_id] 
      else if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
        
      else if(session['redirect']=='5')
      
       redirect_to :controller => 'chapter_journal', :action => 'journals'
      
      else
        redirect_to :controller => 'customers', :action => 'chapter_next', :id => session[:tag_id] 
      end
      end
     end
     
    else
      render :action => 'edit'
    end
  end

  def destroying
    ChapterJournal.find(params[:id]).destroy
      flash[:notice2] = 'Chapter Journal Deleted!'
    
    if(session['redirect']=='2')
        redirect_to :controller => 'tags', :action => 'subchap_coverflow', :id => session[:tag_id] 
      else if(session['redirect']=='5')
      
       redirect_to :controller => 'chapter_journal', :action => 'journals'
       else if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
    
      else
        redirect_to :controller => 'customers', :action => 'chapter_next', :id => session[:tag_id] 
    end
    end
    end
  end
  
  def destroying_journal
    ChapterJournal.find(params[:id]).destroy
      flash[:notice2] = 'Chapter Journal Deleted!'
    
    if(session['redirect']=='2')
        redirect_to :controller => 'manage_site', :action => 'manage_journal', :id => params[:family_name] 
      else if(session['redirect']=='5')
      
        redirect_to :controller => 'manage_site', :action => 'manage_journal', :id => params[:family_name] 
       else if(session['redirect']=='3')
          redirect_to :controller => 'manage_site', :action => 'manage_journal', :id => params[:family_name] 
    
      else
          redirect_to :controller => 'manage_site', :action => 'manage_journal', :id => params[:family_name] 
    end
    end
    end
  end
  
  
  
  def journals
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
  
if(session[:friend]!='')
  uid1=session[:friend]
else
  uid1=logged_in_hmm_user.id
end

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
  
  def manage_journals
    render :layout => false
  end
  
  def shareJournal
    @jtype = params[:id]
    @temp = @jtype.split("&")
#    @image = params[:id]
#     @img = @image.split("&")
  end
  
  def friendsList
    @status = params[:id]
    @temp = @status.split(" ")
    #SELECT * FROM family_friends as a, hmm_users as b WHERE a.fnf_category=261 and a.fid=b.id and a.status='accepted' and block_status='unblock'
      
    render :layout => false
  end
  
  def nonhmm_friendslist
    @status = params[:id]
    @temp = @status.split(" ")
    render :layout => false
    
  end
  
  def shareWorker

    if params[:message]
      @message = params[:message]
    end
    @jtype = params[:id]
    @temp = @jtype.split("&")
    journal = Journal
#   INSERTING HMM USERS IN SHARE'S TABLE    
    if params[:user]
      @hmmusers = params[:user]
      hmmids = @hmmusers.join(",")
      @hmmusers = HmmUser.find(:all, :conditions => "id in (#{hmmids})") 
      for i in @hmmusers
        @share = ShareJournal.new
        @share['presenter_id']=logged_in_hmm_user.id
        @share['jid']=params[:id]
        @share['jtype']=params[:jtype]
        @share['e_mail']= i.v_e_mail
        @share['created_date']=Time.now
        @share['expiry_date']=Time.now.advance(:months => 1, :years => 0)
        @share['message']=@message
        @share['unid']=0
        @share.save
        Postoffice.deliver_shareJournalhmm(@share['e_mail'],@message,journal,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.v_myimage)
      end
    end
        
#   INSERTING NON-HMM USERS IN SHARE'S TABLE
    if params[:nhmmuser]
      @nonhmmusers = params[:nhmmuser]
      nonhmmids = @nonhmmusers.join(",")
      @nonhmm = NonhmmUser.find(:all, :conditions => "id in (#{nonhmmids})",:group=>"v_email") 
      for j in @nonhmm
        @share_max =  ShareJournal.find_by_sql("select max(id) as n from share_journals")
     for share_max in @share_max
      share_max_id = "#{share_max.n}"
     end
     if(share_max_id == '')
      share_max_id = '0'
     end
     share_next_id= Integer(share_max_id) + 1
        @share = ShareJournal.new
        @share['presenter_id']=logged_in_hmm_user.id
        @share['jid']=params[:id]
        @share['jtype']=params[:jtype]
        @share['e_mail']= j.v_email
        @share['created_date']=Time.now
        @share['expiry_date']=Time.now.advance(:months => 1, :years => 0)
        @share['message']=@message
        shareuuid=Share.find_by_sql("select uuid() as uid")
        unid=shareuuid[0].uid+""+"#{share_next_id}"
        @share['unid']=unid
        @share.save
        Postoffice.deliver_shareJournal(@share['e_mail'],@message,journal,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.v_myimage,@share.id,@share.unid)
        $share_journalredirect
        flash[:share_journalredirect] = 'Journal was Successfully Shared!!'
      end
  end
  
#   INSERTING E-MAIL ID'S
    if params[:email]
      @frdEmail = params[:email]
      frindsEmail=@frdEmail.split(',')
      for k in frindsEmail
         @share_max =  ShareJournal.find_by_sql("select max(id) as n from share_journals")
     for share_max in @share_max
      share_max_id = "#{share_max.n}"
     end
     if(share_max_id == '')
      share_max_id = '0'
     end
     share_next_id= Integer(share_max_id) + 1
     @check_hmmusers = HmmUser.count(:all, :conditions => "v_e_mail='#{k}'") 
        if(@check_hmmusers > 0)
          @check_hmmusers = HmmUser.find(:all, :conditions => "v_e_mail='#{k}'") 
          @blocked_friend = FamilyFriend.count(:all,:conditions => "uid='#{@check_hmmusers[0]['id']}' and fid='#{logged_in_hmm_user.id}' and block_status='block'")
          if(@blocked_friend <= 0)
            @blocked_friend =  0
          else
            @blocked_friend = 1
          end
       else
          @blocked_friend = 0
       end  
            if(@blocked_friend <= 0)
                @share = ShareJournal.new
                @share['presenter_id']=logged_in_hmm_user.id
                @share['jid']=params[:id]
                @share['jtype']=params[:jtype]
                @share['e_mail']= k
                @share['created_date']=Time.now
                @share['expiry_date']=Time.now.advance(:months => 1, :years => 0)
                @share['message']=@message
                shareuuid=Share.find_by_sql("select uuid() as uid")
                unid=shareuuid[0].uid+""+"#{share_next_id}"
                @share['unid']=unid
                @share.save
                Postoffice.deliver_shareJournal(@share['e_mail'],@message,journal,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.v_myimage,@share.id,@share.unid)
            end
        end
    end

    $share_journal
    flash[:share_journal] = 'Journal was Successfully Shared!!'
    redirect_to :controller => 'chapter_journal', :action => 'add_nonhmm', :pa => params[:email] 
  end
  
  def add_nonhmm
    @count = 0
    @email = params[:id]
    if params[:pa]
      email = params[:pa]
      @frindsEmail=email.split(',')
      size = @frindsEmail.size
      for k in @frindsEmail
      #@friendscheck = NonhmmUser.count(:all, :conditions => "uid='#{logged_in_hmm_user.id}' and v_email='#{k}'")
      @friendscheck = NonhmmUser.count_by_sql("SELECT count(*) FROM nonhmm_users where  v_email='#{k}' and uid=#{logged_in_hmm_user.id} group by v_email")
      i=0
        until i == size 
        i=i+1
          if @friendscheck != 1
            @count = @count +1
          else
            
          end
        end
      end
      if @count == 0
        $share_journal_pass
        flash[:share_journal_pass] = 'Journal was Successfully Shared!!'
        redirect_to :controller => 'chapter_journal', :action => 'journals'
      end
    else
      $share_journal_pass
      flash[:share_journal_pass] = 'Journal was Successfully Shared!!'
      redirect_to :controller => 'chapter_journal', :action => 'journals'
    end
    
    
  end
  
  def add_nonhmmWorker
    if params[:nonhmm_email]
      @email = params[:nonhmm_email]
      @nonhmmemails = @email.join(",")
     
    
    if params[:nonhmm_name]
      @name = params[:nonhmm_name]
      @nonhmmnames = @name.join(",")
    end
    
    
    @frindsEmail=@nonhmmemails.split(',')
    @frindsName=@nonhmmnames.split(',')
    i=0
    
    #finding the size of an array
    @emailsize=@frindsEmail.size()
    @namesize=@frindsName.size()
   
    #loop to insert new nonHMM friends which are added through e-mail
    @emailsize.times {|i| 
       @addnonhmm = NonhmmUser.new()
       @addnonhmm['v_email'] = @frindsEmail[i]
       @addnonhmm['v_name'] = @frindsName[i]
       @addnonhmm['uid'] = logged_in_hmm_user.id
       @addnonhmm['v_city'] = 'edit city'
       @addnonhmm['v_country'] = 'edit country'
       @addnonhmm.save
    }
   $addnonhmm
   flash[:addnonhmm] = 'Non-HMM Users Were Successfully added!!'
   $share_journal_sc
   flash[:share_journal_sc] = 'Journal was Successfully Shared!!'
   end
   redirect_to :controller => 'chapter_journal', :action => 'journals'
    
  end
  
  
end
