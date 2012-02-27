class AccountController < ApplicationController
#  include ExceptionNotifiable
  layout "admin"
  helper :sort
  include SortHelper
  
  before_filter :authenticate_emp, :only => [  :premium_show, :premium_usersearch, :my_customers, :premium_users, :mycustomer_search, :emp_home, :customer_list, :cancelled_list_search, :cancelled_list, :pending_requests, :pending_request_search, :cancelled_list_search_failed, :cancelled_list_failed]
  
  before_filter :authenticate_admin, :only => [ :cutekid_contetslist, :review_cutekid, :cutekid_moment_view ,:studio_customers,  :commissionReport, :list, :list1, :login_report, :guestReport, :statReport, :chapReport, :commentReport, :sessionReport, :fnf_index, :index1, :customer_list, :link_customer, :link_list, :link_list1, :platinum_user_excel, :gotskils_moment_view, :gotskils_contetslist, :review_gotskils, :pending_requests_admin, :pending_request_search_admin, :cancelled_list_search_admin, :cancelled_list_admin]
  
  before_filter :authenticate_manager, :only => [:manager_home] 
  
  def index1
    @hmm_user_requests= HmmUser.count(:all, :conditions => "cancel_status='pending'")
    @gotskils_contest_pending = Contest.count(:all, :conditions => "moment_type = 'video' and status='pending'")
    @cutekid_contest_pending = Contest.count(:all, :conditions => "moment_type = 'image' and status='pending'")
    @hmm_user_requests1= HmmUser.count(:all, :conditions => "cancel_status='approved' and canceled_by='-2'")
  end
  
  def emp_home
    @hmm_user_requests= HmmUser.count(:all, :conditions => "cancel_status='pending' and emp_id='#{session[:employe]}'")
    @hmm_user_requests1= HmmUser.count(:all, :conditions => "cancel_status='approved' and canceled_by='-2' and emp_id='#{session[:employe]}'")
  end
  
  def authenticate
    self.logged_in_user = User.authenticate(params[:user][:username],
    params[:user][:hashed_password ])
    if is_logged_in?
         redirect_to  :action => 'index1'
   else
      flash[:error] = "I'm sorry; either your username or password was incorrect."
      redirect_to :action => 'login' 
    end
  end
  
    def authenticate_emp
      unless session[:employe]
           flash[:notice] = 'Please Login to Access your Account'
           redirect_to "https://www.holdmymemories.com/account/employe_login"
      return false
      end
    end
  
  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "https://www.holdmymemories.com/account/login"
    return false
    end
  end
  
  def authenticate_manager
    unless session[:manager]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "https://www.holdmymemories.com/account/market_manager_login"
    return false
    end
  end
  
  def authenticate_employe
    logged_in_employe = EmployeAccount.find_by_employe_username_and_password(params[:employe_account][:employe_username],
    params[:employe_account][:password ], :conditions => "status='unblock'")
    #puts logged_in_employe.id
    if logged_in_employe
      session[:employe_name]=logged_in_employe.employe_name
      session[:employe]=logged_in_employe.id
      #puts session[:employe]
         redirect_to  :action => 'emp_home'
   else
      flash[:error] = "I'm sorry; either your username or password was incorrect."
      redirect_to :action => 'employe_login' 
    end
  end
  
  def authenticate_market_manager
    logged_in_marketmanager = MarketManager.find_by_manager_username_and_password(params[:market_manager][:manager_username],
    params[:market_manager][:password ], :conditions => "status='unblock'")
    #puts logged_in_employe.id
    if logged_in_marketmanager
      session[:manager_name]=logged_in_marketmanager.manager_name
      session[:manager]=logged_in_marketmanager.id
      #puts session[:employe]
         redirect_to  :action => 'manager_home'
   else
      flash[:error] = "I'm sorry; either your username or password was incorrect."
      redirect_to :action => 'market_manager_login' 
    end
  end

  def emp_logout
    reset_session
    flash[:notice] = "You Have Successfully Logged Out."
    redirect_to :action => 'employe_login'
  end
  
  def manager_logout
    reset_session
    flash[:notice_managerlogout] = "You Have Successfully Logged Out."
    redirect_to :action => 'market_manager_login'
  end
  
# def list
#   @pages = Page.find(:all)
#   render(:layout => false)
# end
  
  def create
    @page = Page.new(params[:page])
    @page.save!
    flash[:notice] = 'Page saved'
    redirect_to :action => 'index' 
    rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

  def edit
    @page = Page.find(params[:ID].to_i)
    render(:layout => false)
  end

  def update
      @page = Page.find(params[:page])
      @page.attributes = params[:page]
      @page.update_attributes(params[:page])
      #flash[:notice] = "Page updated"
      redirect_to :action => 'index'
      #rescue
      #render :action => 'edit'
  end

  def destroy
    Page.find(params[:ID]).destroy
     redirect_to :controller => 'account', :action => 'list'
  end
  
  def logout
    if request.post?
      reset_session
      flash[:notice] = "You Have Successfully Logged Out."
    end
    redirect_to :action => 'login'
  end
 
  def list
     sort_init 'id'
     sort_update
     if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "id desc"
      else
        
       sort = "#{session[:srk]}  #{params[:sort_order]}"
      end 
      else
       session[:sort_order]=params[:sort_order]
       session[:srk]=params[:sort_key] 
       sort = "#{session[:srk]}  #{params[:sort_order]}"
     end
      @hmmuser_blockcnt = HmmUsers.count(:all, :conditions => "e_user_status='blocked'")
      @hmmuser_unblockcnt = HmmUsers.count(:all, :conditions => "e_user_status='unblocked'")
      @hmm_user_pages, @hmm_users = (paginate :hmm_users, :per_page => 10, :order => sort)
     
    render :layout => true
   end
  
  def customer_list
     sort_init 'id'
     sort_update
    
    
     if( params[:sort_key] ==nil )
      session[:sort_order]="desc"
       session[:srk]="id"
       sort="#{session[:srk]}  #{params[:sort_order]}"
     else
       session[:sort_order]=params[:sort_order]
       session[:srk]=params[:sort_key] 
       sort="#{session[:srk]}  #{params[:sort_order]}"
       
     end
      @hmmuser_blockcnt = HmmUsers.count(:all, :conditions => "e_user_status='blocked'")
      @hmmuser_unblockcnt = HmmUsers.count(:all, :conditions => "e_user_status='unblocked'")
      @hmm_user_pages, @hmm_users = (paginate :hmm_users, :per_page => 10, :order => sort)
     
    render :layout => true
   end
  
   def list1
      sort_init 'id'
      sort_update
     
      @hmmuser_blockcnt = HmmUsers.count(:all, :conditions => "e_user_status='blocked'")
      @hmmuser_unblockcnt = HmmUsers.count(:all, :conditions => "e_user_status='unblocked'")
       
       
     if(@params[:username]==nil && @params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
      
     else
       @uname=@params[:username]
      if(@uname!="" && @params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%'"
      end 
      
      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}'"
      end 
     
      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && @params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%'"
      end 
      
      @country=params[:v_country]
      @zip=params[:zip]
      
      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%'"
        end
      end
     
      end
    if( params[:sort_key] ==nil )
      session[:sort_order]="desc"
       session[:srk]="id"
       @srk = "#{session[:srk]}  #{params[:sort_order]}"
     else
       session[:sort_order]=params[:sort_order]
       session[:srk]=params[:sort_key] 
       @srk = "#{session[:srk]}  #{params[:sort_order]}"
       
     end
    
   if(@params[:username]==nil && @params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
      #session[:search_cond]="#{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}"
   else
     session[:search_cond]="#{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}"
   end 
     @hmm_user_pages, @hmm_users = (paginate :hmm_users, :conditions =>"id!='' #{session[:search_cond]}", :per_page => 10, :order =>  @srk )
     
   render :layout => true
   end
    
   def customer_list1
      sort_init 'id'
      sort_update
     
      @hmmuser_blockcnt = HmmUsers.count(:all, :conditions => "e_user_status='blocked'")
      @hmmuser_unblockcnt = HmmUsers.count(:all, :conditions => "e_user_status='unblocked'")
       
       if(@params[:username]==nil && @params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
       else
       @uname=@params[:username]
      if(@uname!="" && @params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%'"
      end 
      
      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}'"
      end 
     
      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && @params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%'"
      end 
      
      @country=params[:v_country]
      @zip=params[:zip]
      
      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%'"
        end
      end
     
      end
  
    if params[:sort_key]==nil && params[:sort_order]==nil 
      @srk="id  desc"
    else
    
    @sort_key=params[:sort_key]
   
       
     
     @order=params[:sort_order]
    end 
      puts @sort_key
      puts @order
     @srk="#{@sort_key}"+" "+"#{@order}"
     if( @srk==nil || @srk=="" )
     @srk="id  desc"
   end
   
   puts @srk
   
     @hmm_user_pages, @hmm_users = (paginate :hmm_users, :conditions =>"id!='' #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}", :per_page => 10, :order =>  @srk )
     
   render :layout => true
   end 
    
   def show
     @hmm_user = HmmUser.find(params[:id])
    
   end
   
   def edit
    @hmm_user = HmmUser.find(params[:id])
    
  end
  
  def update
    @hmm_user = HmmUser.find(params[:id])
      if @hmm_user.update_attributes(params[:hmm_user])
      flash[:notice] = 'HmmUser was successfully updated.'
      render :action => 'show', :id => @hmm_user
    else
      render :action => 'edit'
    end
  end
  
  def blockUblock
    @hmm_user = HmmUser.find(params[:id])
    sql = ActiveRecord::Base.connection();
    if @hmm_user.e_user_status=='unblocked'
       sql.update "UPDATE hmm_users SET e_user_status='blocked' WHERE id=#{params[:id]}"; 
      # @hmm_user.save
       redirect_to :action => 'list'
    else 
      sql.update "UPDATE hmm_users SET e_user_status='unblocked' WHERE id=#{params[:id]}"; 
     # @hmm_user.save
      redirect_to :action => 'list'
    end
  end
  
  def customerReport
    @hmmuser_blockcnt = HmmUsers.count(:all, :conditions => "e_user_status='blocked'")
      @hmmuser_unblockcnt = HmmUsers.count(:all, :conditions => "e_user_status='unblocked'")
    #@hmm_user_pages, @hmm_user = paginate :hmm_users , :order => sort, :per_page => items_per_page, :conditions => "subchapter_id  =#{params[:id]} and status='active' #{e_access}" ,:order => sort
   
 end
 
  def customerReport_exe
   # @hmm_user=HmmUser.count_by_sql("select * from hmm_users where v_user_name='#{params[:user][:username]}' and v_fname='#{params[:user][:firstname]}'  ");
    @hmmuser_count=HmmUser.count(:all, :conditions => "v_user_name='#{params[:user][:username]}' and v_fname='#{params[:user][:firstname]}' and v_zip='#{params[:user][:zip]}' " )
    @hmm_users=HmmUser.find(:all, :conditions => "v_user_name='#{params[:user][:username]}' and v_fname='#{params[:user][:firstname]}' and v_zip='#{params[:user][:zip]}' " )
  
  end
 
 def guestReport
   @share= Share.count
   puts params[:from_bdate]
   
   if (params[:from_bdate]!=nil && params[:to_bdate] !=nil)
      
      from_yr=params[:from_bdate]['ordermonthdayyearstart_year1909(1i)']
      from_mon=params[:from_bdate]['ordermonthdayyearstart_year1909(2i)']
      from_date=params[:from_bdate]['ordermonthdayyearstart_year1909(3i)']
      
      fromdate=from_yr+'-'+from_mon+'-'+from_date
      #fromdate.strftime("%b #{fromdate} %Y   %I:%M %p")
      to_yr=params[:to_bdate]['ordermonthdayyearstart_year1909(1i)']
      to_mon=params[:to_bdate]['ordermonthdayyearstart_year1909(2i)']
      to_date=params[:to_bdate]['ordermonthdayyearstart_year1909(3i)']
      todate=to_yr+'-'+to_mon+'-'+to_date
      params[:from_bdate]['start_year1908ordermonthdayyear(1i)']
      condition= "and created_date between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
      # condit= "and d_created_on and e_approval='approve' between '#{fromdate}' and '#{todate}' "
      cond= "and Visited_date between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
    cond_exp= "and Visited_date between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
    end
   @guest_visited = Share.count(:all, :conditions => "id!='' #{cond}")
    @guest_create = Share.count(:all, :conditions => "id!='' #{condition}")
   @guest_expire = Share.count(:all, :conditions => "id!='' #{cond_exp}")
    if request.xml_http_request?
        render :partial => "guest", :layout => false
     end
 end
 
 def guestSearch
   @share_count = Share.count(:all, :conditions => "email_list ='#{params[:guest][:email]}' and guest_name ='#{params[:guest][:name]}'")
   @share = Share.find(:all, :conditions => "email_list ='#{params[:guest][:email]}' and guest_name ='#{params[:guest][:name]}'")
 end
 
 def showGuest
   @share = Share.find(params[:id])
     render(:layout => false)
 end
 
 def editGuest
   @guest = Share.find(params[:id])
    render(:layout => false)
 end
 
 def updateGuest
   @guest = Share.find(params[:id])
      if @guest.update_attributes(params[:shares ])
      flash[:notice] = 'HmmUser was successfully updated!!'
      render :action => 'show', :id => @hmm_user
    else
      render :action => 'edit'
    end
 end
 
 def statReport
   @stat_imag = UserContent.count(:all, :conditions => "e_filetype='image'")
   @stat_video = UserContent.count(:all, :conditions => "e_filetype='VIDEO'")
   @stat_audio = UserContent.count(:all, :conditions => "e_filetype='AUDIO'")
   #@hmmuser_stat = HmmUser.find(:joins=>"as b , user_contents as a ", :conditions => "b.id=a.uid and a.e_filetype='image'")
    if (params[:from_bdate]!=nil && params[:to_bdate] !=nil)
      
      from_yr=params[:from_bdate]['ordermonthdayyearstart_year1909(1i)']
      from_mon=params[:from_bdate]['ordermonthdayyearstart_year1909(2i)']
      from_date=params[:from_bdate]['ordermonthdayyearstart_year1909(3i)']
                                     
      fromdate="#{from_yr}-#{from_mon}-#{from_date}"
      
      to_yr=params[:to_bdate]['ordermonthdayyearstart_year1909(1i)']
      to_mon=params[:to_bdate]['ordermonthdayyearstart_year1909(2i)']
      to_date=params[:to_bdate]['ordermonthdayyearstart_year1909(3i)']
      todate=to_yr+'-'+to_mon+'-'+to_date
      params[:from_bdate]['ordermonthdayyearstart_year1909(1i)']
      condition= "and d_createddate between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
      # condit= "and d_created_on and e_approval='approve' between '#{fromdate}' and '#{todate}' "
      cond= "and d_createddate between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
    
    end
  #@photo_cnt = ChapterComment.count(:conditions => "id!='' #{condition}")
  @photo_cnt = UserContent.count(:all, :conditions => "e_filetype='image'  and id!='' #{cond}")
  @video_cnt = UserContent.count(:all, :conditions => "e_filetype='VIDEO' and id!='' #{condition}")
  @audio_cnt = UserContent.count(:all, :conditions => "e_filetype='AUDIO' and id!='' #{condition}")
   if request.xml_http_request?
        render :partial => "statrep", :layout => false
     end
 end
 
 def chapstatReport
   @chap_stat = Tag.count
   @sub_stat = SubChapter.count
   @gal_stat = Galleries.count
   @total_stat = (@chap_stat + @sub_stat + @gal_stat)
    if (params[:from_bdate]!=nil && params[:to_bdate] !=nil)
      
      from_yr=params[:from_bdate]['ordermonthdayyearstart_year1909(1i)']
      from_mon=params[:from_bdate]['ordermonthdayyearstart_year1909(2i)']
      from_date=params[:from_bdate]['ordermonthdayyearstart_year1909(3i)']
      
     fromdate=from_yr+'-'+from_mon+'-'+from_date
      
     to_yr=params[:to_bdate]['ordermonthdayyearstart_year1909(1i)']
     to_mon=params[:to_bdate]['ordermonthdayyearstart_year1909(2i)']
     to_date=params[:to_bdate]['ordermonthdayyearstart_year1909(3i)']
     todate=to_yr+'-'+to_mon+'-'+to_date
      params[:from_bdate]['ordermonthdayyearstart_year1909(1i)']
      #condition= "and d_created_on  between '#{fromdate}' and '#{todate}' "
      # condit= "and d_created_on and e_approval='approve' between '#{fromdate}' and '#{todate}' "
      cond= "and d_createddate  between '#{fromdate}' and '#{todate}' "
    
      #(:all, :conditions => " id!='' #{cond} ")
     #@tags_pages, @tags = paginate :tags, :per_page => 10, :joins => "as a," :conditions => " id!='' #{cond} ", :order => " d_date_time  desc "
  end
   @tags_pages, @tags = paginate :tags,  :per_page => 10, :conditions => " id!='' #{cond} ", :order => " d_createddate  desc "
 end
 
 def chapReport
   @chap_stat = Tag.count
   @sub_stat = SubChapter.count
   @gal_stat = Galleries.count
    if (params[:from_bdate]!=nil && params[:to_bdate] !=nil)
      
      from_yr=params[:from_bdate]['ordermonthdayyearstart_year1909(1i)']
      from_mon=params[:from_bdate]['ordermonthdayyearstart_year1909(2i)']
      from_date=params[:from_bdate]['ordermonthdayyearstart_year1909(3i)']
              
     fromdate="#{from_yr}-#{from_mon}-#{from_date}"
      
     to_yr=params[:to_bdate]['ordermonthdayyearstart_year1909(1i)']
     to_mon=params[:to_bdate]['ordermonthdayyearstart_year1909(2i)']
     to_date=params[:to_bdate]['ordermonthdayyearstart_year1909(3i)']
     todate=to_yr+'-'+to_mon+'-'+to_date
      params[:from_bdate]['ordermonthdayyearstart_year1909(1i)']
      condition= "and d_createddate  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
      # condit= "and d_created_on and e_approval='approve' between '#{fromdate}' and '#{todate}' "
      cond= "and d_created_on  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
      cond1= "and d_gallery_date  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
    
  end
  @cond_chap = Tag.count(:conditions => " id!='' #{condition} ")
 # @chap_condit = ChapterComment.count(:conditions => " id!='' #{condit} ")
  
  @cond_sub = SubChapter.count(:conditions => " id!='' #{cond} ")
  @cond_gal = Galleries.count(:conditions => " id!='' #{cond1} ")
  
  
  @allcomment_count = (@cond_chap + @cond_sub + @cond_gal )
  #@allcomment_count = ChapterComment.count(:joins => "as a, subchap_comments as b, gallery_comments as c, photo_comments as d")
  #@chapter_comments_pages, @chapter_commentss = paginate :chapter_commentss,  :per_page => 10, :conditions => " id!='' #{condition} ", :order => " d_date_time  desc "
   if request.xml_http_request?
        render :partial => "statchap", :layout => false
     end
 end
 
 def commentReport
   @chapcomment_count = ChapterComment.count
        @chapcomment_count_rej = ChapterComment.count(:all, :conditions => "e_approval='pending'")
        @chapcomment_count_app = ChapterComment.count(:all, :conditions => "e_approval='approve'")
        @chapcomment_count_pen = ChapterComment.count(:all, :conditions => "e_approval='reject'")
   @subComment_count = SubchapComment.count
        @subcomment_count_rej = SubchapComment.count(:all, :conditions => "e_approval='pending'")
        @subcomment_count_app = SubchapComment.count(:all, :conditions => "e_approval='approve'")
        @subcomment_count_pen = SubchapComment.count(:all, :conditions => "e_approval='reject'")
   @galComment_count = GalleryComment.count
        @galcomment_count_rej = GalleryComment.count(:all, :conditions => "e_approval='pending'")
        @galcomment_count_app = GalleryComment.count(:all, :conditions => "e_approval='approve'")
        @galcomment_count_pen = GalleryComment.count(:all, :conditions => "e_approval='reject'")
   @momComment_count = PhotoComment.count
        @momcomment_count_rej = PhotoComment.count(:all, :conditions => "e_approved='pending'")
        @momcomment_count_app = PhotoComment.count(:all, :conditions => "e_approved='approve'")
        @momcomment_count_pen = PhotoComment.count(:all, :conditions => "e_approved='reject'")
        
    if (params[:from_bdate]!=nil && params[:to_bdate] !=nil)
      
      from_yr=params[:from_bdate]['ordermonthdayyearstart_year1909(1i)']
      from_mon=params[:from_bdate]['ordermonthdayyearstart_year1909(2i)']
      from_date=params[:from_bdate]['ordermonthdayyearstart_year1909(3i)']
      
     fromdate="#{from_yr}-#{from_mon}-#{from_date}"
      
     to_yr=params[:to_bdate]['ordermonthdayyearstart_year1909(1i)']
     to_mon=params[:to_bdate]['ordermonthdayyearstart_year1909(2i)']
     to_date=params[:to_bdate]['ordermonthdayyearstart_year1909(3i)']
     todate=to_yr+'-'+to_mon+'-'+to_date
      params[:from_bdate]['ordermonthdayyearstart_year1909(1i)']
      condition= "and d_created_on  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
      # condit= "and d_created_on and e_approval='approve' between '#{fromdate}' and '#{todate}' "
      cond= "and d_add_date  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59 '  "
    
  end
  @cond_chap = ChapterComment.count(:conditions => " id!='' #{condition} ")
 # @chap_condit = ChapterComment.count(:conditions => " id!='' #{condit} ")
    @cond_chap_app = ChapterComment.count(:conditions => "e_approval='approve' and id!='' #{condition} ")
    @cond_chap_rej = ChapterComment.count(:conditions => "e_approval='reject' and id!='' #{condition} ")
    @cond_chap_pen = ChapterComment.count(:conditions => "e_approval='pending' and id!='' #{condition} ")
  @cond_sub = SubchapComment.count(:conditions => " id!='' #{condition} ")
    @cond_sub_app = SubchapComment.count(:conditions => "e_approval='approve' and id!='' #{condition} ")
    @cond_sub_rej = SubchapComment.count(:conditions => "e_approval='reject' and id!='' #{condition} ")
    @cond_sub_pen = SubchapComment.count(:conditions => "e_approval='pending' and id!='' #{condition} ")
  @cond_gal = GalleryComment.count(:conditions => " id!='' #{condition} ")
    @cond_gal_app = GalleryComment.count(:conditions => "e_approval='approve' and id!='' #{condition} ")
    @cond_gal_rej = GalleryComment.count(:conditions => "e_approval='reject' and id!='' #{condition} ")
    @cond_gal_pen = GalleryComment.count(:conditions => "e_approval='pending' and id!='' #{condition} ")
  @cond_moment = PhotoComment.count(:conditions => " id!='' #{cond} ")
    @cond_mom_app = PhotoComment.count(:conditions => "e_approved='approve' and id!='' #{cond} ")
    @cond_mom_rej = PhotoComment.count(:conditions => "e_approved='reject' and id!='' #{cond} ")
    @cond_mom_pen = PhotoComment.count(:conditions => "e_approved='pending' and id!='' #{cond} ")
  
  @allcomment_count = (@chapcomment_count + @subComment_count + @galComment_count + @momComment_count)
  #@allcomment_count = ChapterComment.count(:joins => "as a, subchap_comments as b, gallery_comments as c, photo_comments as d")
  #@chapter_comments_pages, @chapter_commentss = paginate :chapter_commentss,  :per_page => 10, :conditions => " id!='' #{condition} ", :order => " d_date_time  desc "
   if request.xml_http_request?
        render :partial => "comntrep", :layout => false
     end
 end
 
 def change_password
   
 end
 
 def chg_password_execute
  sql = ActiveRecord::Base.connection();
    if(params[:pass][:old]!='')
    self.encrypt('#{params[:pass][:old]}')
     chk = User.count(:all, :conditions => "id=#{logged_in_user.id} and hashed_password='#{params[:pass][:old]}'")
     if(chk > 0)
      sql.update "UPDATE users SET hashed_password='#{params[:pass][:confirm]}' WHERE id=#{logged_in_user.id}";
      flash[:notice] = "Your password has been changed sucessfully."
      render :action => 'change_password'
      
     else
      flash[:notice] = "Invalid Current password. Please try again"
      render :action => 'change_password'
     end
 end
 
end

  def sessionReport
     @orginal_fdate=params[:from_bdate]
       @orginal_tdate=params[:to_bdate]
    if (params[:from_bdate]!=nil && params[:to_bdate] !=nil)
      
      
      @from_yr=params[:from_bdate]['ordermonthdayyearstart_year1909(1i)']
      @from_mon=params[:from_bdate]['ordermonthdayyearstart_year1909(2i)']
      @from_date=params[:from_bdate]['ordermonthdayyearstart_year1909(3i)']
      
     @fromdate=@from_yr+'-'+@from_mon+'-'+@from_date
     
     @to_yr=params[:to_bdate]['ordermonthdayyearstart_year1909(1i)']
     @to_mon=params[:to_bdate]['ordermonthdayyearstart_year1909(2i)']
     @to_date=params[:to_bdate]['ordermonthdayyearstart_year1909(3i)']
     @todate=@to_yr+'-'+@to_mon+'-'+@to_date
     params[:from_bdate]['ordermonthdayyearstart_year1909(1i)']
     condition= "and b.d_date_time between '#{@fromdate} 00:00:00' and '#{@todate} 23:59:59' "
  end
    #@sessions = UserSessions.count(:joins => " as a, LEFT JOIN hmm_users b", :conditions => "id!='' #{condition}" )
   @count1 = UserSessions.count(:all,:joins => 'as b' ,:conditions => "b.id!='' #{condition}")
   @site_result=HmmUser.find_by_sql("select ((count(*)/#{@count1})*100) as total  from hmm_users " )
    @query = "SELECT a.id as id1,a.v_user_name, count( * ) AS cnt, (count(b.uid)/#{@count1}*100) as avga, b.v_user_name AS un
                FROM hmm_users a
                LEFT JOIN user_sessions b ON a.v_user_name = b.v_user_name #{condition} GROUP BY b.uid  order by avga desc"
   
    mynum = @params[:page] || 0
    items_per_page = 5
    @count_query = HmmUsers.count
    @page = @count_query/items_per_page
    
    @next = Integer(mynum)+1
    @prev = Integer(mynum)-1
    num= Integer(mynum)
    number =num*items_per_page
   @query+=" LIMIT "+String(number)+","+String(items_per_page)
                
    @session = HmmUser.find_by_sql(@query)    
    #@session = HmmUsers.find(:all, :join => "as a, user_sessions as b", :select => "a.v_user_name, count (*) as b.cnt")
    #@sessions = HmmUser.find(:all, :joins => " as a, LEFT JOIN user_sessions b", :select => "a.v_user_name, count(*) as cnt, b.v_user_name as un", :conditions => "a.v_user_name = b.v_user_name", :group => 'a.v_user_name' )
   #@user_sessions_pages, @user_sessionss = paginate :user_sessionss,  :per_page => 5, :conditions => " id!='' #{condition} ", :order => " d_date_time  desc "
  end


      
     

  def login_report
    
     sort_init 'id'
     sort_update
     srk=params[:sort_key] 
     sort="#{srk}  #{params[:sort_order]}"
    
     if( srk==nil)
      sort="id  desc"
     end
    
    if (params[:from_bdate]!=nil && params[:to_bdate] !=nil)
      
      from_yr=params[:from_bdate]['ordermonthdayyearstart_year1909(1i)']
      from_mon=params[:from_bdate]['ordermonthdayyearstart_year1909(2i)']
      from_date=params[:from_bdate]['ordermonthdayyearstart_year1909(3i)']
      
     fromdate=from_yr+'-'+from_mon+'-'+from_date
      
     to_yr=params[:to_bdate]['ordermonthdayyearstart_year1909(1i)']
     to_mon=params[:to_bdate]['ordermonthdayyearstart_year1909(2i)']
     to_date=params[:to_bdate]['ordermonthdayyearstart_year1909(3i)']
     
     todate=to_yr+'-'+to_mon+'-'+to_date
     
      params[:from_bdate]['ordermonthdayyearstart_year1909(1i)']
      condition= "and d_date_time  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
    end
    @user_sessions_pages, @user_sessionss = paginate :user_sessionss,  :per_page => 50, :conditions => " id!='' #{condition} ", :order => sort
 #  @sub_chapters_pages, @sub_chapters = paginate :sub_chapters ,  :per_page => items_per_page, :conditions => "tagid=#{@params[:id]} and status='active' #{e_access}", :order => sort #:order => " #{@sort.to_s} #{@order.to_s} "
 
  end

    def faq
       @faq_pages, @faqs = paginate :faqs, :per_page => 10
    end
    
    def tipsManage
      
  end
  
  def feedback
      Postoffice.deliver_feedback(params[:urname], params[:uremail] , @params[:urcomment])
      Postoffice.deliver_thankyou(params[:urname], params[:uremail] , @params[:urcomment])
      render :action => 'thankyou', :layout => false 
  end
  
  def thankyou
     render(:layout => false)
 end
 
 
 def statistic_report
  if(session[:friend]!='')
  uid=session[:friend]
  else
  uid=logged_in_hmm_user.id
  end
     items_per_page = 1
     sort = case params['sort']
              when "username"  then "v_fname"
              when "username_reverse"  then "v_fname DESC"
          end
     if (params[:query].nil?)
        params[:query]=""
     else
        conditions = "b.v_fname LIKE '%#{params[:query]}%'"
     end
      if (params[:query1].nil?)   
        params[:query1]=""  
     else
        conditions =" b.v_fname LIKE '#{params[:query1]}%'"
     end
     
      if (params[:query_hmm_user]!=nil && params[:query_hmm_user1] !=nil)
      puts "fewfwefew"
      from_yr=params[:query_hmm_user]['ordermonthdayyearstart_year1909(1i)']
      from_mon=params[:query_hmm_user]['ordermonthdayyearstart_year1909(2i)']
      from_date=params[:query_hmm_user]['ordermonthdayyearstart_year1909(3i)']
     
     fromdate=from_yr+"-"+""+from_mon+"-"+from_date
      
    frm=fromdate.split("(1i)")
    if(frm[0]=="ordermonthdayyearstart_year1909")
      fromdate=session['fromdate']
    else
     session['fromdate']=fromdate
    end 
     to_yr=params[:query_hmm_user1]['ordermonthdayyearstart_year1909(1i)']
     to_mon=params[:query_hmm_user1]['ordermonthdayyearstart_year1909(2i)']
     to_date=params[:query_hmm_user1]['ordermonthdayyearstart_year1909(3i)']
     
     todate=to_yr+"-"+to_mon+"-"+to_date
     
      tdt=todate.split("(1i)")
    if(tdt[0]=="ordermonthdayyearstart_year1909")
      todate=session['todate']
    else
      session['fromdate']=todate
    end 
     
     

    
     
else
  
 
  end
   
       

   
     
     if (params[:query_hmm_user].nil?)   
        params[:query_hmm_user]=""  
     else
        conditions = "id!=0 and d_created_date between '#{fromdate}' and '#{todate}' "
        @total = HmmUser.count(:conditions =>conditions)
        @hmm_users_pages, @hmm_users = paginate :hmm_users , :select => "*",  :order => sort, :per_page => items_per_page,
        :conditions => conditions
        
     end
     
     if( params[:query]=="" && params[:query1]=="" && params[:query_hmm_user] =="" )
        @total = HmmUser.count(:joins=>"as b  ", :conditions =>  "b.id!=0 " )
        @hmm_users_pages, @hmm_users = paginate :hmm_users ,:joins=>"as b  ", :order => sort, :per_page => items_per_page,
        :conditions => "b.id!=0"
     else
        flag=1
#        @total = HmmUser.count(:conditions => conditions )
#        @hmm_users_pages, @hmm_users = paginate :hmm_users , :select => "id as fid, v_myimage, v_fname",  :order => sort, :per_page => items_per_page,
#        #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && b.v_fname LIKE '%#{params[:query]}%'"
#        :conditions => conditions
        if(params[:query_hmm_user]!="")
        else
        @total = HmmUser.count(:joins=>"as b  ", :conditions =>  " LIKE '%#{params[:query]}%'")
        @hmm_users_pages, @hmm_users = paginate :hmm_users ,:joins=>"as b ", :order => sort, :per_page => items_per_page,
        #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && a.status='accepted'"
         #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && b.v_fnameq LIKE '%#{params[:query]}%'"
        :conditions => conditions
     end
     end
     @fnf_groups_index = FnfGroups.find(:all,:conditions=>"uid=1",:order=>"id DESC")

     if request.xml_http_request?
        render :partial => "statistic_list", :layout => false
     end
  end
  
  def nice_date(date)
    h date.strftime("%Y-%m-%d")
  end
  
  
   def fnf_index
  if(session[:friend]!='')
  uid=1
  else
  uid=1
  end
     items_per_page = 12
     sort = case params['sort']
              when "username"  then "v_fname"
              when "username_reverse"  then "v_fname DESC"
          end
          
         if (params[:query_hmm_user]!=nil && params[:query_hmm_user1] !=nil && params[:page]==nil || params[:page]=='nil')
      
      from_yr=params[:query_hmm_user]['ordermonthdayyearstart_year1909(1i)']
      from_mon=params[:query_hmm_user]['ordermonthdayyearstart_year1909(2i)']
      from_date=params[:query_hmm_user]['ordermonthdayyearstart_year1909(3i)']
     
     fromdate=from_yr+"-"+""+from_mon+"-"+from_date
      
    frm=fromdate.split("(1i)")
    if(frm[0]=="ordermonthdayyearstart_year1909")
      fromdate=session['fromdate']
    else
     session['fromdate']=fromdate
    end 
     to_yr=params[:query_hmm_user1]['ordermonthdayyearstart_year1909(1i)']
     to_mon=params[:query_hmm_user1]['ordermonthdayyearstart_year1909(2i)']
     to_date=params[:query_hmm_user1]['ordermonthdayyearstart_year1909(3i)']
     
     todate=to_yr+"-"+to_mon+"-"+to_date
     
      tdt=todate.split("(1i)")
    if(tdt[0]=="ordermonthdayyearstart_year1909")
      todate=session['todate']
    else
      session['todate']=todate
    end 
  else
    fromdate=session['fromdate']
    todate=session['todate']
   end  
    
     if (params[:query_hmm_user]==nil && params[:query_hmm_user1] ==nil )
         session['fromdate']=''
         session['todate']=''
     end    
     if (params[:query].nil?)
        params[:query]=""
     else
        conditions = "a.uid=1 && b.id=a.fid && a.block_status='unblock' && a.status='accepted' && b.v_fname LIKE '%#{params[:query]}%'"
     end
      if (params[:query1].nil?)   
        params[:query1]=""  
     else
        conditions ="a.uid=1 && b.id=a.fid && a.block_status='unblock' && a.status='accepted' && b.v_fname LIKE '#{params[:query1]}%'"
     end
     
        
     if (params[:query_hmm_user].nil?)   
        params[:query_hmm_user]=""  
     else
        conditions = "id!=0 and d_created_date between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
        @total = HmmUser.count(:conditions =>conditions)
        @hmm_users_pages, @hmm_users = paginate :hmm_users , :select => "*",  :order => 'id desc', :per_page => items_per_page,
        :conditions => conditions
        
     end
     
     if( params[:query]=="" && params[:query1]=="" && params[:query_hmm_user] =="" )
        @total = HmmUser.count(:joins=>"as b  ", :conditions =>  "b.id!=0 " )
        @hmm_users_pages, @hmm_users = paginate :hmm_users ,:joins=>"as b  ", :order => 'id desc', :per_page => items_per_page,
        :conditions => "b.id!=0"
     else
        flag=1
#        @total = HmmUser.count(:conditions => conditions )
#        @hmm_users_pages, @hmm_users = paginate :hmm_users , :select => "id as fid, v_myimage, v_fname",  :order => sort, :per_page => items_per_page,
#        #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && b.v_fname LIKE '%#{params[:query]}%'"
#        :conditions => conditions
        if(params[:query_hmm_user]!="")
        else
        @total = HmmUser.count(:joins=>"as b  ", :conditions =>  " LIKE '%#{params[:query]}%'")
        @hmm_users_pages, @hmm_users = paginate :hmm_users ,:joins=>"as b ", :order => sort, :per_page => items_per_page,
        #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && a.status='accepted'"
         #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && b.v_fnameq LIKE '%#{params[:query]}%'"
        :conditions => conditions
     end
     end
     @fnf_groups_index = FnfGroups.find(:all,:conditions=>"uid=1",:order=>"id DESC")

     if request.xml_http_request?
        render :partial => "fnf_list", :layout => false
     end
 end
 
 
 def fnf_index1
   
  begin
  headers['Content-Type'] = "application/vnd.ms-excel"
  headers['Content-Disposition'] = 'attachment; filename="statisticalreport.xls"'
  headers['Cache-Control'] = ''
  rescue
    logger.info("unable to create excel sheet for these records")
  end 
  if(session[:friend]!='')
  
  uid=1
  else
  uid=1
  end
     items_per_page = 10
     sort = case params['sort']
              when "username"  then "v_fname"
              when "username_reverse"  then "v_fname DESC"
          end
          

     
        
     if (params[:frmdate].nil? && params[:todate].nil?)  
        @frmdate=''
      @todate=''
    items_per_page = HmmUser.count(:all , :conditions => " id !=0")
           @hmm_users_pages, @hmm_users = paginate :hmm_users , :select => "*",  :order => 'id desc', :per_page => items_per_page
    
      else
      @frmdate=params[:frmdate]
      @todate=params[:todate]
      items_per_page = HmmUser.count(:all, :conditions => " id!=0 and d_created_date between '#{@frmdate} 00:00:00' and '#{@todate} 23:59:59'")
        conditions = "id!=0 and d_created_date between '#{@frmdate} 00:00:00' and '#{@todate} 23:59:59' " 
        @total = HmmUser.count(:conditions =>conditions)
       begin   
      @hmm_users_pages, @hmm_users = paginate :hmm_users , :select => "*",  :order => 'id desc', :per_page => items_per_page,
        :conditions => conditions
       rescue
          logger.info("un able to fetch records")
        end
     end
     
     if( params[:query]=="" && params[:query1]=="" && params[:query_hmm_user] =="" )
        begin
          @hmm_users_pages, @hmm_users = paginate :hmm_users ,:joins=>"as b  ", :order => 'id desc', :per_page => items_per_page,
          :conditions => "b.id!=0"
        rescue
          logger.info("unable to fetch all records from table")
        end  
     else
        flag=1
#        @total = HmmUser.count(:conditions => conditions )
#        @hmm_users_pages, @hmm_users = paginate :hmm_users , :select => "id as fid, v_myimage, v_fname",  :order => sort, :per_page => items_per_page,
#        #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && b.v_fname LIKE '%#{params[:query]}%'"
#        :conditions => conditions
       
     end
     @fnf_groups_index = FnfGroups.find(:all,:conditions=>"uid=1",:order=>"id DESC")

     if request.xml_http_request?
        render :partial => "fnf_list", :layout => false
    end
   render :layout => false 

   #!/usr/bin/env ruby



#require File.dirname(__FILE__) + '/../config/environment'
#require "spreadsheet/excel" 
#
#
#
#  file = "ewfwewe_sales_leads.xls" 
#  workbook = Spreadsheet::Excel.new("#{RAILS_ROOT}/public/#{file}")
#
#  worksheet = workbook.add_worksheet("Sales Leads")
#  worksheet.write(0, 0, "Customer name")
#  worksheet.write(0, 1, "Email")
#  
#@orders = HmmUser.find(:all)
#  row = 1
#  @orders.each do |order|
#    worksheet.write(row, 0, "#{order.v_fname} #{order.v_lname}")
#    worksheet.write(row, 1, "#{order.v_e_mail}")
#   
#    row += 1
#  end
#
#  workbook.close

  #OrderMailer.deliver_sales_leads(operator.report_email_address_to, operator.report_email_address_cc, operator.site, operator.city)


   
   
 end
 
 
 def my_customers
   @hmmuser_blockcnt = HmmUsers.count(:all, :conditions => "e_user_status='blocked' and emp_id=#{session[:employe]}")
      @hmmuser_unblockcnt = HmmUsers.count(:all, :conditions => "e_user_status='unblocked' and emp_id=#{session[:employe]}")
   sort_init 'id'
     sort_update
     srk=params[:sort_key] 
     sort="#{srk}  #{params[:sort_order]}"
    
     if( srk==nil)
      sort="id  desc"
     end
    
      @hmm_user_pages, @hmm_users = (paginate :hmm_users, :select => "*", :conditions => "emp_id=#{session[:employe]}", :per_page => 10)
     
    render :layout => true
 end

    def mycustomer_search
      sort_init 'id'
      sort_update
     
      @hmmuser_blockcnt = HmmUsers.count(:all, :conditions => "e_user_status='blocked' and emp_id=#{session[:employe]} ")
      @hmmuser_unblockcnt = HmmUsers.count(:all, :conditions => "e_user_status='unblocked' and emp_id=#{session[:employe]}")
       
       if(@params[:username]==nil && @params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
       else
       @uname=@params[:username]
      if(@uname!="" && @params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%' "
      end 
      
      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end 
     
      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && @params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%' "
      end 
      
      @country=params[:v_country]
      @zip=params[:zip]
      
      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end
     
      end
  
    if params[:sort_key]==nil && params[:sort_order]==nil 
      @srk="id  desc"
    else
    
    @sort_key=params[:sort_key]
   
       
     
     @order=params[:sort_order]
    end 
      puts @sort_key
      puts @order
     @srk="#{@sort_key}"+" "+"#{@order}"
      if( @srk==nil || @srk=="" )
        @srk="id  desc"
      end
      puts @srk
   
     @hmm_user_pages, @hmm_users = (paginate :hmm_users, :conditions =>"id!='' and emp_id=#{session[:employe]} #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}", :per_page => 10, :order =>  @srk )
     
   render :layout => true
end

    def premium_users
      @hmmuser_blockcnt = HmmUsers.count(:all, :conditions => "e_user_status='blocked' and emp_id=#{session[:employe]} and account_type='platinum_user'")
      @hmmuser_unblockcnt = HmmUsers.count(:all, :conditions => "e_user_status='unblocked' and emp_id=#{session[:employe]} and account_type='platinum_user'")
      sort_init 'id'
      sort_update
      if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "id desc"
      else
        
       sort = "#{session[:srk]}  #{params[:sort_order]}"
      end 
      else
       session[:sort_order]=params[:sort_order]
       session[:srk]=params[:sort_key] 
       sort = "#{session[:srk]}  #{params[:sort_order]}"
     end
     
      @hmm_user_pages, @hmm_users = (paginate :hmm_users, :select => "*", :conditions => "emp_id=#{session[:employe]} and account_type='platinum_user'", :per_page => 10, :order => sort)
     
      render :layout => true
    end
    
    def my_customers
   @hmmuser_blockcnt = HmmUsers.count(:all, :conditions => "e_user_status='blocked' and emp_id=#{session[:employe]} and account_type='platinum_user'")
      @hmmuser_unblockcnt = HmmUsers.count(:all, :conditions => "e_user_status='unblocked' and emp_id=#{session[:employe]} and account_type='platinum_user'")
   sort_init 'id'
     sort_update
     srk=params[:sort_key] 
     sort="#{srk}  #{params[:sort_order]}"
    
     if( srk==nil)
      sort="id  desc"
     end
    
      @hmm_user_pages, @hmm_users = (paginate :hmm_users, :select => "*", :conditions => "emp_id=#{session[:employe]}", :per_page => 10, :order => sort)
     
    render :layout => true
 end

    def premium_usersearch
      sort_init 'id'
      sort_update
     
      @hmmuser_blockcnt = HmmUsers.count(:all, :conditions => "e_user_status='blocked' and emp_id=#{session[:employe]} and account_type='platinum_user'")
      @hmmuser_unblockcnt = HmmUsers.count(:all, :conditions => "e_user_status='unblocked' and emp_id=#{session[:employe]} and account_type='platinum_user'")
       
       if(@params[:username]==nil && @params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
       else
       @uname=@params[:username]
      if(@uname!="" && @params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%' "
      end 
      
      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end 
     
      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && @params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%' "
      end 
      
      @country=params[:v_country]
      @zip=params[:zip]
      
      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end
     
      end
  
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "id desc"
      else
        
       sort = "#{session[:srk]}  #{params[:sort_order]}"
      end 
      else
       session[:sort_order]=params[:sort_order]
       session[:srk]=params[:sort_key] 
       sort = "#{session[:srk]}  #{params[:sort_order]}"
     end
   if(@params[:username]==nil && @params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
      #session[:search_cond]="#{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}"
   else
     session[:search_cond]="#{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}"
   end 
     @hmm_user_pages, @hmm_users = (paginate :hmm_users, :conditions =>"id!='' and emp_id=#{session[:employe]} and account_type='platinum_user' #{session[:search_cond]} ", :per_page => 10, :order =>  sort )
     
   render :layout => true
end

    
    
    def premium_show
      @hmm_user = HmmUser.find(params[:id])
    end
    
    def contestReport
      sort_init 'id'
        sort_update
        srk=params[:sort_key] 
        sort="#{srk}  #{params[:sort_order]}"
    
        if( srk==nil)
          sort="id  desc"
          @hmm_user_pages, @hmm_users = (paginate :contests, :joins=>"as a, hmm_users as b", :conditions => "a.uid=b.id", :per_page => 10,  :order => 'v_fname')
        end
    end
  
  def contests_list
    @contest_pages, @contests = paginate :contests, :per_page => 10
  end
  
  def review_gotskils
    @contest_pages, @contests = paginate :contests, :conditions => "moment_type='video' and status='pending'", :per_page => 10, :order => 'id desc'
    session[:redirect] = nil
  end
  
  def review_cutekid
    @contest_pages, @contests = paginate :contests, :conditions => "moment_type='image' and status='pending'", :per_page => 10, :order => 'id desc'
    session[:redirect] = nil
  end
  
  def gotskils_contetslist
    @contest_pages, @contests = paginate :contests, :conditions => "moment_type='video'", :per_page => 10, :order => 'id desc'
  end
  
  def cutekid_contetslist
    @contest_pages, @contests = paginate :contests, :conditions => "moment_type='image'", :per_page => 10, :order => 'id desc'
  end
  
  def gotskils_moment_view
    @moment_details = UserContent.find(:all, :conditions => "id='#{params[:id]}'") 
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:id]}'")
    @journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{params[:id]} ")
  end
  
  def cutekid_moment_view
    @moment_details = UserContent.find(:all, :conditions => "id='#{params[:id]}'") 
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:id]}'")
    @journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{params[:id]} ")
  end
  
  def contest_approve
    @contest = Contest.find(params[:id])
    sql = ActiveRecord::Base.connection();
    
    
      sql.update "UPDATE contests SET status='active' WHERE id=#{params[:id]}"; 
     # @hmm_user.save
     $contest_approve
     flash[:contest_approve] = 'contest entry has been succefully approved'
      if(session['redirect']=='101')
        redirect_to :action => 'review_gotskils'
      else if(session['redirect']=='102')
        redirect_to :action => 'gotskils_contetslist'
      else if(session['redirect']=='111')
        redirect_to :action => 'review_cutekid'  
      else
        redirect_to :action => 'cutekid_contetslist'
      end  
      end
      end
  end
  
  def contest_reject
    @contest = Contest.find(params[:id])
    sql = ActiveRecord::Base.connection();
    
       sql.update "UPDATE contests SET status='inactive' WHERE id=#{params[:id]}"; 
      # @hmm_user.save
      $contest_rej
        flash[:contest_rej] = 'contest entry has been rejected!'
      if(session['redirect']=='101')
        redirect_to :action => 'review_gotskils'
      else if(session['redirect']=='102')
        redirect_to :action => 'gotskils_contetslist'
      else if(session['redirect']=='111')
        redirect_to :action => 'review_cutekid'  
      else
        redirect_to :action => 'cutekid_contetslist'
      end  
      end
      end
  end
  
  def contest_delete
    @contest = Contest.find(params[:id])
    sql = ActiveRecord::Base.connection();
    
       sql.update "DELETE from contests  WHERE id=#{params[:id]}"; 
      # @hmm_user.save
      $contest_rej
        flash[:contest_rej] = 'contest entry has been removed!'
      if(session['redirect']=='101')
        redirect_to :action => 'review_gotskils'
      else if(session['redirect']=='102')
        redirect_to :action => 'gotskils_contetslist'
      else if(session['redirect']=='111')
        redirect_to :action => 'review_cutekid'  
      else
        redirect_to :action => 'cutekid_contetslist'
      end  
      end
      end
  end
  
  def verify_cuponID
    
  end
  
  def search_cuponID
    @cupon_result = Cupon.count(:all, :conditions => "unid='#{params[:cupon_no]}'")
    @cupon_res = Cupon.find(:all, :conditions => "unid='#{params[:cupon_no]}'")
    for i in @cupon_res
      cuponid = i.id
    end
    if @cupon_result > 0
      flash[:unid_succes] = 'Cupon Authenticated!! Please create account for the customer.'
      redirect_to :action => 'preview_cupon', :id => cuponid
    else
      flash[:unid_failed] = 'Cupon Id is not valid'
      redirect_to :action => 'verify_cuponID'
    end
  end
  
  def preview_cupon
     @cupon = Cupon.find(params[:id])
     @cupon_res = Cupon.count(:all, :conditions => "id='#{params[:id]}' and DATE_FORMAT(expire_date,'%Y-%m-%d') >= curdate() ")
     @cupon_res_start = Cupon.count(:all, :conditions => "id='#{params[:id]}' and DATE_FORMAT(start_date,'%Y-%m-%d') <= curdate() ")
  end
  
  def verify_emp
    if session[:employe]
      redirect_to :controller => 'customers', :action => 'authorise_verify'
    else
      flash[:notice_emp] = 'Please login to create customers account'
      redirect_to "https://www.holdmymemories.com/account/employe_login"
    end
  end
  
   def link_list
     sort_init 'id'
     sort_update
     srk=params[:sort_key] 
     sort="#{srk}  #{params[:sort_order]}"
    
     if( srk==nil)
      sort="id  desc"
     end
      @hmmuser_blockcnt = HmmUsers.count(:all, :conditions => "account_type='platinum_user' ")
      @hmmuser_unblockcnt = HmmUsers.count(:all, :conditions => "account_type='platinum_user' and emp_id!='' ")
      @hmmuser_cnt = (@hmmuser_blockcnt - @hmmuser_unblockcnt)
      @hmmuser_premcnt= HmmUsers.count(:all, :conditions => "account_type='platinum_user' and  e_user_status='unblocked'")
      @hmm_user_pages, @hmm_users = (paginate :hmm_users, :conditions => "account_type='platinum_user'", :per_page => 10, :order => sort)
     
    render :layout => true
   end
  
   def link_list1
      sort_init 'id'
      sort_update
     
      @hmmuser_blockcnt = HmmUsers.count(:all, :conditions => "e_user_status='blocked'")
      @hmmuser_unblockcnt = HmmUsers.count(:all, :conditions => "e_user_status='unblocked'")
       
       if(@params[:username]==nil && @params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
       else
       @uname=@params[:username]
      if(@uname!="" && @params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%'"
      end 
      
      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}'"
      end 
     
      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && @params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%'"
      end 
      
      @country=params[:v_country]
      @zip=params[:zip]
      
      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%'"
        end
      end
     
      end
  
    if params[:sort_key]==nil && params[:sort_order]==nil 
      @srk="id  desc"
    else
    
    @sort_key=params[:sort_key]
   
       
     
     @order=params[:sort_order]
    end 
      puts @sort_key
      puts @order
     @srk="#{@sort_key}"+" "+"#{@order}"
     if( @srk==nil || @srk=="" )
     @srk="id  desc"
   end
   
   puts @srk
                                                                                                                                        
     @hmm_user_pages, @hmm_users = (paginate :hmm_users, :conditions =>"id!='' and account_type='platinum_user' #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}", :per_page => 10, :order =>  @srk )
     
   render :layout => true
   end  
  
   def link_customer
     if params[:branch]
        @linkemp = EmployeAccount.find(:all, :conditions => "branch='#{params[:branch]}'")
     else
      flash[:unid_failed] = 'Please Select the branch for respectively customer'
        redirect_to :action => 'link_list'
     end
   end
   
    def update_cus_emp
      @hmmuser = HmmUser.find(params[:id])
      @hmmuser['emp_id']=params[:emp_name]
      @hmmuser.save
      
      $link_success
      flash[:link_success] = 'Customer Linked to Studio121 sucessfully'
      redirect_to :action => 'link_list'
   end
   
   def pending_requests
     sort_init 'id'
     sort_update
     srk=params[:sort_key] 
     sort="#{srk}  #{params[:sort_order]}"
    
     if( srk==nil)
      sort="cancellation_request_date desc"
     end
     @hmm_user_pages, @hmm_users = (paginate :hmm_users, :conditions =>"cancel_status='pending' and emp_id='#{session[:employe]}'", :per_page => 10, :order => sort )
   end
   
   def pending_request_search
      sort_init 'id'
      sort_update
     
      @hmmuser_blockcnt = HmmUsers.count(:all, :conditions => "e_user_status='blocked' and emp_id=#{session[:employe]}")
      @hmmuser_unblockcnt = HmmUsers.count(:all, :conditions => "e_user_status='unblocked' and emp_id=#{session[:employe]}")
       
       if(@params[:username]==nil && @params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
       else
       @uname=@params[:username]
      if(@uname!="" && @params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%' "
      end 
      
      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end 
     
      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && @params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%' "
      end 
      
      @country=params[:v_country]
      @zip=params[:zip]
      
      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end
     
      end
  
    if params[:sort_key]==nil && params[:sort_order]==nil 
      @srk="id  desc"
    else
    
    @sort_key=params[:sort_key]
   
       
     
     @order=params[:sort_order]
    end 
      puts @sort_key
      puts @order
     @srk="#{@sort_key}"+" "+"#{@order}"
      if( @srk==nil || @srk=="" )
        @srk="id  desc"
      end
      puts @srk
   
     @hmm_user_pages, @hmm_users = (paginate :hmm_users, :conditions =>"cancel_status='pending' and emp_id=#{session[:employe]} #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}", :per_page => 10, :order =>  @srk )
     
   render :layout => true
   end
   
   
   def platinum_user_excel
    if(session[:friend]!='')
      uid=1
    else
      uid=1
    end
     items_per_page = 12
     sort = case params['sort']
              when "username"  then "v_fname"
              when "username_reverse"  then "v_fname DESC"
          end
          
         if (params[:query_hmm_user]!=nil && params[:query_hmm_user1] !=nil && params[:page]==nil || params[:page]=='nil')
      
      from_yr=params[:query_hmm_user]['ordermonthdayyearstart_year1909(1i)']
      from_mon=params[:query_hmm_user]['ordermonthdayyearstart_year1909(2i)']
      from_date=params[:query_hmm_user]['ordermonthdayyearstart_year1909(3i)']
     
     fromdate=from_yr+"-"+""+from_mon+"-"+from_date
      
    frm=fromdate.split("(1i)")
    if(frm[0]=="ordermonthdayyearstart_year1909")
      fromdate=session['fromdate']
    else
     session['fromdate']=fromdate
    end 
     to_yr=params[:query_hmm_user1]['ordermonthdayyearstart_year1909(1i)']
     to_mon=params[:query_hmm_user1]['ordermonthdayyearstart_year1909(2i)']
     to_date=params[:query_hmm_user1]['ordermonthdayyearstart_year1909(3i)']
     
     todate=to_yr+"-"+to_mon+"-"+to_date
     
      tdt=todate.split("(1i)")
    if(tdt[0]=="ordermonthdayyearstart_year1909")
      todate=session['todate']
    else
      session['todate']=todate
      
    end 
  else
    fromdate=session['fromdate']
    todate=session['todate']
    
   end  
    
     if (params[:query_hmm_user]==nil && params[:query_hmm_user1] ==nil )
         session['fromdate']=''
         session['todate']=''
     end    
     if (params[:query].nil?)
        params[:query]=""
     else
        conditions = "a.uid=1 && v_e_mail!='Please update email' && b.id=a.fid && a.block_status='unblock' && a.status='accepted' && b.v_fname LIKE '%#{params[:query]}%'"
     end
      if (params[:query1].nil?)   
        params[:query1]=""  
     else
        conditions ="a.uid=1 && v_e_mail!='Please update email' && b.id=a.fid && a.block_status='unblock' && a.status='accepted' && b.v_fname LIKE '#{params[:query1]}%'"
     end
     
     if(params[:query_hmm_user2]=="All")
       accounttype = ""
      session['usertype']=""
     else
      accounttype =" and account_type='#{params[:query_hmm_user2]}'"
      session['usertype']=params[:query_hmm_user2]
     end
     if (params[:query_hmm_user].nil?)   
        params[:query_hmm_user]=""  
     else
        conditions = "id!=0  and v_e_mail!='Please update email' and d_created_date between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' #{accounttype} "
        @total = HmmUser.count(:conditions =>conditions)
        @hmm_users_pages, @hmm_users = paginate :hmm_users , :select => "*",  :order => 'id desc', :per_page => items_per_page,
        :conditions => conditions
        
     end
     
     if( params[:query]=="" && params[:query1]=="" && params[:query_hmm_user] =="" && params[:query_hmm_user2]=="" )
        @total = HmmUser.count(:joins=>"as b  ", :conditions =>  "b.id!=0 and b.v_e_mail!='Please update email' " )
        @hmm_users_pages, @hmm_users = paginate :hmm_users ,:joins=>"as b  ", :order => 'id desc', :per_page => items_per_page,
        :conditions => "b.id!=0 and b.v_e_mail!='Please update email'"
     else
        flag=1
#        @total = HmmUser.count(:conditions => conditions )
#        @hmm_users_pages, @hmm_users = paginate :hmm_users , :select => "id as fid, v_myimage, v_fname",  :order => sort, :per_page => items_per_page,
#        #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && b.v_fname LIKE '%#{params[:query]}%'"
#        :conditions => conditions
        if(params[:query_hmm_user]!="")
        else
        
        @hmm_users_pages, @hmm_users = paginate :hmm_users ,:joins=>"as b ", :conditions => "b.id!=0 and b.v_e_mail!='Please update email'", :order => sort, :per_page => items_per_page,
        #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && a.status='accepted'"
         #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && b.v_fnameq LIKE '%#{params[:query]}%'"
        :conditions => conditions
     end
     end
     @fnf_groups_index = FnfGroups.find(:all,:conditions=>"uid=1",:order=>"id DESC")

     if request.xml_http_request?
        render :partial => "excel_report", :layout => false
     end
 end
 
 def platinum_user_excel1
   begin
  headers['Content-Type'] = "application/vnd.ms-excel"
  headers['Content-Disposition'] = 'attachment; filename="statisticalreport.xls"'
  headers['Cache-Control'] = ''
  rescue
    logger.info("unable to create excel sheet for these records")
  end 
  if(session[:friend]!='')
  
  uid=1
  else
  uid=1
  end
    
          

     
        
     if (params[:frmdate].nil? && params[:todate].nil?)  
        @frmdate=''
      @todate=''
      @usertype=''
      items_per_page = HmmUser.count(:all , :conditions => " id !=0 and v_e_mail!='Please update email'")
           @hmm_users_pages, @hmm_users = paginate :hmm_users , :select => "*",  :order => 'id desc', :per_page => items_per_page
    
      else
      @frmdate=params[:frmdate]
      @todate=params[:todate]
      if(params[:usertype]== "")
       @usertype=""
      else
        if(params[:usertype]=='familyws_user')
          @usertype1="Family Website Users report from: #{params[:frmdate]} to: #{params[:todate]} "
        else
          if(params[:usertype]=='free_user')
            @usertype1="Free user accounts report from: #{params[:frmdate]} to: #{params[:todate]}"
          else
            @usertype1="Premium Users report from: #{params[:frmdate]} to: #{params[:todate]}"
          end        
        end
        
        @usertype="and account_type='#{params[:usertype]}'"
      end
      items_per_page = HmmUser.count(:all, :conditions => " id!=0 and v_e_mail!='Please update email' and d_created_date between '#{@frmdate} 00:00:00' and '#{@todate} 23:59:59' #{@usertype}")
        conditions = "id!=0 and v_e_mail!='Please update email' and d_created_date between '#{@frmdate} 00:00:00' and '#{@todate} 23:59:59' #{@usertype} " 
        @total = HmmUser.count(:conditions =>conditions)
       begin   
      @hmm_users_pages, @hmm_users = paginate :hmm_users , :select => "*",  :order => 'id desc', :per_page => items_per_page,
        :conditions => conditions
       rescue
          logger.info("un able to fetch records")
        end
     end
     
     if( params[:frmdate]=="" && params[:todate]==""   )
        begin
          @hmm_users_pages, @hmm_users = paginate :hmm_users ,:joins=>"as b  ", :order => 'id desc', :per_page => items_per_page,
          :conditions => "b.id!=0 and b.v_e_mail!='Please update email'"
        rescue
          logger.info("unable to fetch all records from table")
        end 
          @usertype1="All Users report"
     else
        flag=1
#        @total = HmmUser.count(:conditions => conditions )
#        @hmm_users_pages, @hmm_users = paginate :hmm_users , :select => "id as fid, v_myimage, v_fname",  :order => sort, :per_page => items_per_page,
#        #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && b.v_fname LIKE '%#{params[:query]}%'"
#        :conditions => conditions
       
     end
     @fnf_groups_index = FnfGroups.find(:all,:conditions=>"uid=1",:order=>"id DESC")

     if request.xml_http_request?
        render :partial => "excel_report1", :layout => false
    end
   render :layout => false 
 end
 
 def cancel_sub
             #if(logged_in_hmm_user.emp_id==nil || logged_in_hmm_user.emp_id=='' )
              require "ArbApiLib"
              aReq = ArbApi.new
              hmm_user = HmmUser.find(params[:id])
              subnumber = hmm_user.subscriptionnumber
              if ARGV.length < 3
              end
              ARGV[0]= "https://api.authorize.net/xml/v1/request.api"
              ARGV[1]= "8GxD65y84"
              ARGV[2]= "89j6d34cW8CKhp9S"
              auth = MerchantAuthenticationType.new(ARGV[1], ARGV[2])
              subname = ARGV.length > 3? ARGV[3]: hmm_user.account_type
              xmlout = aReq.CalcelSubscription(auth,subnumber)
              xmlresp1 = HttpTransport.TransmitRequest(xmlout, ARGV[0])
              apiresp = aReq.ProcessResponse1(xmlresp1)
              puts "Subscription Creation Failed"
              
              apiresp.messages.each { |message| 
               puts "Error Code=" + message.code
               puts "Error Message = " + message.text 
               @res =  message.text
              }
               
                #if(@res == "The subscription has already been cancelled." || @res == "Successful." || @res == "no subscription") 
                  hmm_user1 = HmmUser.find(hmm_user.id)
                  #hmm_user.account_type="free_user"
                  #hmm_user1.account_expdate=account_expdate
                  hmm_user1.cancel_status = 'approved'
                  if(session[:employe])
                   hmm_user1.canceled_by = "#{session[:employe]}"
                  else
                  hmm_user1.canceled_by = "0"
                  end  
                  hmm_user1.save
                  
                  if(@res == "Successful.")
                    
                   flash[:sucess_id] = "Subscription has been canceled sucessfully."
                   #Postoffice.deliver_cancellation_approved("Admin","admin@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,logged_in_hmm_user.street_address,logged_in_hmm_user.postcode,logged_in_hmm_user.city,logged_in_hmm_user.state,logged_in_hmm_user.country,logged_in_hmm_user.telephone, reason)
                   Postoffice.deliver_cancellation_request_complete("admin@holdmymemories.com",hmm_user1.v_fname,hmm_user1.v_lname,hmm_user1.v_e_mail,hmm_user1.account_type,hmm_user1.amount,hmm_user1.subscriptionnumber,hmm_user1.invoicenumber, hmm_user1['v_password'], hmm_user1.v_user_name)
                   
                  else
                   flash[:sucess_id] = "Subscription status is: " + @res
                    
                  end 
                  
                  
                #end
                redirect_to "https://www.holdmymemories.com/account/cancel_sucess/"
           # end  
  end
 
 def cancel_sucess
   
 end
 
def cancelled_list
     sort_init 'id'
     sort_update
     srk=params[:sort_key] 
     sort="#{srk}  #{params[:sort_order]}"
    
     if( srk==nil)
      sort="cancellation_request_date desc"
     end
     @hmm_user_pages, @hmm_users = (paginate :hmm_users, :conditions =>"cancel_status='approved' and emp_id='#{session[:employe]}'", :per_page => 10, :order => sort )
   end
   
   def cancelled_list_search
      sort_init 'id'
      sort_update
     
      @hmmuser_blockcnt = HmmUsers.count(:all, :conditions => "e_user_status='blocked' and emp_id=#{session[:employe]}")
      @hmmuser_unblockcnt = HmmUsers.count(:all, :conditions => "e_user_status='unblocked' and emp_id=#{session[:employe]}")
       
       if(@params[:username]==nil && @params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
       else
       @uname=@params[:username]
      if(@uname!="" && @params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%' "
      end 
      
      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end 
     
      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && @params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%' "
      end 
      
      @country=params[:v_country]
      @zip=params[:zip]
      
      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end
     
      end
  
    if params[:sort_key]==nil && params[:sort_order]==nil 
      @srk="id  desc"
    else
    
    @sort_key=params[:sort_key]
   
       
     
     @order=params[:sort_order]
    end 
      puts @sort_key
      puts @order
     @srk="#{@sort_key}"+" "+"#{@order}"
      if( @srk==nil || @srk=="" )
        @srk="id  desc"
      end
      puts @srk
   
     @hmm_user_pages, @hmm_users = (paginate :hmm_users, :conditions =>"cancel_status='approved' and emp_id=#{session[:employe]} #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}", :per_page => 10, :order =>  @srk )
     
   render :layout => true
   end
   
   def cancelled_list_admin
     sort_init 'id'
     sort_update
     srk=params[:sort_key] 
     sort="#{srk}  #{params[:sort_order]}"
    
     if( srk==nil)
      sort="cancellation_request_date desc"
     end
     @hmm_user_pages, @hmm_users = (paginate :hmm_users, :conditions =>"cancel_status='approved'", :per_page => 10, :order => sort )
   end
   
   def cancelled_list_search_admin
      sort_init 'id'
      sort_update
     
      @hmmuser_blockcnt = HmmUsers.count(:all, :conditions => "e_user_status='blocked' ")
      @hmmuser_unblockcnt = HmmUsers.count(:all, :conditions => "e_user_status='unblocked' ")
       
       if(@params[:username]==nil && @params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
       else
       @uname=@params[:username]
      if(@uname!="" && @params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%' "
      end 
      
      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end 
     
      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && @params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%' "
      end 
      
      @country=params[:v_country]
      @zip=params[:zip]
      
      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end
     
      end
  
    if params[:sort_key]==nil && params[:sort_order]==nil 
      @srk="id  desc"
    else
    
    @sort_key=params[:sort_key]
   
       
     
     @order=params[:sort_order]
    end 
      puts @sort_key
      puts @order
     @srk="#{@sort_key}"+" "+"#{@order}"
      if( @srk==nil || @srk=="" )
        @srk="id  desc"
      end
      puts @srk
   
     @hmm_user_pages, @hmm_users = (paginate :hmm_users, :conditions =>"cancel_status='approved'  #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}", :per_page => 10, :order =>  @srk )
     
   render :layout => true
   end
   
   
   def pending_requests_admin
     sort_init 'id'
     sort_update
     srk=params[:sort_key] 
     sort="#{srk}  #{params[:sort_order]}"
    
     if( srk==nil)
      sort="cancellation_request_date desc"
     end
     @hmm_user_pages, @hmm_users = (paginate :hmm_users, :conditions =>"cancel_status='pending' ", :per_page => 10, :order => sort )
   end
   
   def pending_request_search_admin
      sort_init 'id'
      sort_update
     
      @hmmuser_blockcnt = HmmUsers.count(:all, :conditions => "e_user_status='blocked'")
      @hmmuser_unblockcnt = HmmUsers.count(:all, :conditions => "e_user_status='unblocked'")
       
       if(@params[:username]==nil && @params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
       else
       @uname=@params[:username]
      if(@uname!="" && @params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%' "
      end 
      
      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end 
     
      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && @params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%' "
      end 
      
      @country=params[:v_country]
      @zip=params[:zip]
      
      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end
     
      end
  
    if params[:sort_key]==nil && params[:sort_order]==nil 
      @srk="id  desc"
    else
    
    @sort_key=params[:sort_key]
   
       
     
     @order=params[:sort_order]
    end 
      puts @sort_key
      puts @order
     @srk="#{@sort_key}"+" "+"#{@order}"
      if( @srk==nil || @srk=="" )
        @srk="id  desc"
      end
      puts @srk
   
     @hmm_user_pages, @hmm_users = (paginate :hmm_users, :conditions =>"cancel_status='pending'  #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}", :per_page => 10, :order =>  @srk )
     
   render :layout => true
   end

  def commissionReport
    
    @hmm_studios = HmmStudio.find(:all)
    @manager_commission = EmployeAccount.find(:all, :conditions => "emp_type='store_manager'")
    @marketmanager_commission = MarketManager.find(:all)
  end
  
  def studio_customers
    if params[:date] == nil || params[:date] == ''
    else
      session[:dat] = params[:date]
    end
    
    sort_init 'a.id'
     sort_update
     if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "a.id desc"
      else
        
       sort = "#{session[:srk]}  #{params[:sort_order]}"
      end 
      else
       session[:sort_order]=params[:sort_order]
       session[:srk]=params[:sort_key] 
       sort = "#{session[:srk]}  #{params[:sort_order]}"
     end
    @customers_pages, @customers = (paginate :hmm_users, :joins => "as a, employe_accounts as b", :conditions => "b.store_id='#{params[:id]}' and  a.emp_id=b.id and account_type='platinum_user'  and DATE_FORMAT(a.d_created_date, '%Y-%m') <= '#{session[:dat]}'", :per_page => 25, :order => sort)
   # @customers = HmmUser.find(:all,
    @customer_count = HmmUser.count(:all, :joins => "as a, employe_accounts as b", :conditions => "b.store_id='#{params[:id]}' and  a.emp_id=b.id and account_type='platinum_user'  and DATE_FORMAT(a.d_created_date, '%Y-%m') <= '#{session[:dat]}'")
  end
  
  def commissionReport_search
    
    @hmm_studios = HmmStudio.find(:all)
    @manager_commission = EmployeAccount.find(:all, :conditions => "emp_type='store_manager'")
    @marketmanager_commission = MarketManager.find(:all)
  end
  
  def manager_home
    
  end
  
  def cancelled_list_failed
     sort_init 'id'
     sort_update
     srk=params[:sort_key] 
     sort="#{srk}  #{params[:sort_order]}"
    
     if( srk==nil)
      sort="cancellation_request_date desc"
     end
     @hmm_user_pages, @hmm_users = (paginate :hmm_users, :conditions =>"cancel_status='approved' and emp_id='#{session[:employe]}' and canceled_by='-2'", :per_page => 10, :order => sort )
   end
   
   def cancelled_list_search_failed
      sort_init 'id'
      sort_update
     
      @hmmuser_blockcnt = HmmUsers.count(:all, :conditions => "e_user_status='blocked' and emp_id=#{session[:employe]}")
      @hmmuser_unblockcnt = HmmUsers.count(:all, :conditions => "e_user_status='unblocked' and emp_id=#{session[:employe]}")
       
       if(@params[:username]==nil && @params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
       else
       @uname=@params[:username]
      if(@uname!="" && @params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%' "
      end 
      
      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end 
     
      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && @params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%' "
      end 
      
      @country=params[:v_country]
      @zip=params[:zip]
      
      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end
     
      end
  
    if params[:sort_key]==nil && params[:sort_order]==nil 
      @srk="id  desc"
    else
    
    @sort_key=params[:sort_key]
   
       
     
     @order=params[:sort_order]
    end 
      puts @sort_key
      puts @order
     @srk="#{@sort_key}"+" "+"#{@order}"
      if( @srk==nil || @srk=="" )
        @srk="id  desc"
      end
      puts @srk
   
     @hmm_user_pages, @hmm_users = (paginate :hmm_users, :conditions =>"cancel_status='approved' and canceled_by='-2' and emp_id=#{session[:employe]} #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}", :per_page => 10, :order =>  @srk )
     
   render :layout => true
   end
  
   def cancelled_list_failed_admin
     sort_init 'id'
     sort_update
     srk=params[:sort_key] 
     sort="#{srk}  #{params[:sort_order]}"
    
     if( srk==nil)
      sort="cancellation_request_date desc"
     end
     @hmm_user_pages, @hmm_users = (paginate :hmm_users, :conditions =>"cancel_status='approved'  and canceled_by='-2'", :per_page => 10, :order => sort )
   end
   
   def cancelled_list_search_failed_admin
      sort_init 'id'
      sort_update
     
      @hmmuser_blockcnt = HmmUsers.count(:all, :conditions => "e_user_status='blocked' ")
      @hmmuser_unblockcnt = HmmUsers.count(:all, :conditions => "e_user_status='unblocked' ")
       
       if(@params[:username]==nil && @params[:lastname]==nil && params[:firstname]==nil && params[:v_country]==nil &&  params[:zip]==nil && params[:account_type]==nil )
       else
       @uname=@params[:username]
      if(@uname!="" && @params[:username]!=nil)
        usernamecondition="and v_user_name like '#{@uname}%' "
      end 
      
      @acc_type=params[:account_type]
      if(@acc_type!="" && params[:account_type]!=nil && params[:account_type]!='Select' )
        acc_typecondition="and account_type='#{@acc_type}' "
      end 
     
      @fname=params[:firstname]
      if(@fname!="" && params[:firstname]!=nil)
        firstnamenamecondition="and v_fname like '#{@fname}%' "
      end
      @lname=params[:lastname]
      if(@lname!="" && @params[:lastname]!=nil)
        lastnamecondition="and v_lname like '#{@lname}%' "
      end 
      
      @country=params[:v_country]
      @zip=params[:zip]
      
      if(@country=='USA' && params[:v_country]!=nil)
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_zip='#{@zip}'"
        end
      else
        if( @zip!="" && params[:zip]!=nil)
          countrycond="and v_city like '#{@zip}%' "
        end
      end
     
      end
  
    if params[:sort_key]==nil && params[:sort_order]==nil 
      @srk="id  desc"
    else
    
    @sort_key=params[:sort_key]
   
       
     
     @order=params[:sort_order]
    end 
      puts @sort_key
      puts @order
     @srk="#{@sort_key}"+" "+"#{@order}"
      if( @srk==nil || @srk=="" )
        @srk="id  desc"
      end
      puts @srk
   
     @hmm_user_pages, @hmm_users = (paginate :hmm_users, :conditions =>"cancel_status='approved' and canceled_by='-2'  #{usernamecondition} #{lastnamecondition} #{firstnamenamecondition} #{countrycond} #{acc_typecondition}", :per_page => 10, :order =>  @srk )
     
   render :layout => true
   end
end