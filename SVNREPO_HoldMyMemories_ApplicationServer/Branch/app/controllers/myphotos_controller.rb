class MyphotosController < ApplicationController
layout "standard"

before_filter :authenticate
  

#   protected
    def authenticate
      unless session[:hmm_user]
           flash[:notice] = 'Please Login to Access your Account'
           redirect_to :controller => "user_account" , :action => 'login'
      return false
      else
        if (session[:flag] == 1 && request.request_uri != "/customers/upgrade/platinum_account")
          flash[:error] = "Your credit card payment to you HoldMyMemories.com has been declined by your credit card company. This could be for a number of reasons, including an expired card. <br><br><br>Please re-enter your credit card information, or use a different card for the renewal of your account."
          redirect_to "https://www.holdmymemories.com/customers/upgrade/platinum_account"
        end 
      end
    end

    

def initialize
   super
   @hmm_users = HmmUsers.find(:all)
end

  def index
    list
    render :action => 'list'
  end
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
 # verify :method => :post, :only => [ :destroy, :create, :update ],
  #       :redirect_to => { :action => :list }

  def list
    @tags = Tag.find(:all , :conditions =>"uid=#{logged_in_hmm_user.id}")
    if params[:id] 
      @user_content_pages, @user_contents = paginate :user_contents, :conditions => "e_filetype='PHOTO' and tagid=#{params[:id]} and uid=#{logged_in_hmm_user.id}", :order_by => 'id ' , :per_page =>3
    else
      flash[:notice] = 'Please Select a Tag '
      @user_content_pages, @user_contents = paginate :user_contents, :conditions => "e_filetype='PHOTO' and uid=#{logged_in_hmm_user.id}", :order_by => 'id' , :per_page =>3
    end
  end

  def show
    @user_content = UserContent.find(params[:id])
  end

  def new
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

  def update_positions
    params[:sortable_list].each_index do |i|
      @user_contents = UserContent.find(params[:sortable_list][i])
      @user_contents.position = i
      @user_contents.save
    end
    #@user_contents = UserContent.find(:all, :order => 'position')    
    @list = List.find(:all, :order => 'position')    
    render :layout => false, :action => :list
  end


def create
  #@user_content = UserContent.new(params[:user_content])
  @params[:user_content][:v_filename][0]="null";
  if (@params[:chap][:sel] == "yes")
      
      if (@params[:rdo][:ext] == "new" && @params[:rdo][:ext] != "null")
      # @firstname = @params[:user_content][:v_filename][1].original_filename
      @firstname="#{logged_in_hmm_user.id}_#{@params[:user_content][:v_filename][1].original_filename}"    
      #chapter
      @chapter = Tag.new(params[:tag])
      @chapter['uid']=logged_in_hmm_user.id
      @chapter['v_chapimage']=@firstname
    
     
          if (@params[:subrdo][:subext] == "new" && @params[:subrdo][:subext] != "null")
          #sub_chapter
          @sub_chapter = SubChapter.new(params[:sub_chapter])
          @sub_chapter['uid']=logged_in_hmm_user.id
     
              if (@params[:rdo][:ext] == "new" && @params[:rdo][:ext] != "null")
                @sub_chapter['tagid']=@chapter.id
              end
     
          @sub_chapter.save
          @chapter['sub_chapid']=@sub_chapter.id
          @chapter.save
          end
    
      else
      @chapter = Tag.new(params[:tag])
      @chapter['id']=0
      @chapter['uid']=logged_in_hmm_user.id
      @chapter['v_chapimage']=@firstname
      @chapter.save
      end

    else
    @tag_default =  Tag.find(:all, :conditions=> "default_tag='no' and uid=#{logged_in_hmm_user.id}")  
       for tag_val in @tag_default
         @val123= tag_val.id
       end
     end

   
      i=0
       for obj in @params[:user_content][:v_filename]
        @user_content = UserContent.new(params[:user_content])
        if(@params[:user_content][:v_filename][i]=="null")
        i=i+1
        else
        @filename = obj.original_filename
        id=logged_in_hmm_user.id
        post = UserContent.save1(obj,id)
        @user_content['v_filename']="#{logged_in_hmm_user.id}_#{@filename}"
        #@user_content['v_filename']=@filename
        @user_content['uid']=logged_in_hmm_user.id
        if (@params[:chap][:sel] == "yes")
        @user_content['sub_chapid']=@sub_chapter.id
        @user_content['tagid']=@chapter.id
      else
         
         @user_content['sub_chapid']='0'
        #@user_content['tagid']='0'
        @user_content['tagid']=@val123

        end
        @user_content.save
        
        #Creating Thumbnails
        img = Image.read("#{RAILS_ROOT}/public/user_content/photos/#{logged_in_hmm_user.id}_#{@filename}").first
      
        actual_height=img.rows
        actual_width=img.columns
      
         # image scaling calculation for the images on chapter index page
        maxt_w = 73
        maxt_h = 55
        
        if actual_width <= maxt_w && actual_height <= maxt_h
          calt_w = actual_width
          calt_h = actual_height
        else if actual_width > actual_height
          bigt_w = actual_width/maxt_w
          calt_h = actual_height/bigt_w
          calt_w = maxt_w
        else
          bigt_h = actual_height/maxt_h
          calt_w = actual_width/bigt_h
          calt_h = maxt_h
        end
        end
         # image scaling calculation for the images gallery in chapters
        max_w = 193
        max_h = 193
        
        if actual_width <= max_w && actual_height <= max_h
          cal_w = actual_width
          cal_h = actual_height
        else if actual_width > actual_height
          big_w = actual_width/max_w
          cal_h = actual_height/big_w
          cal_w = max_w
        else
          big_h = actual_height/max_h
          cal_w = actual_width/big_h
          cal_h = max_h
        end
      end

        @thumbnail = img.scale(calt_w, calt_h)
        @gallery = img.scale(cal_w, cal_h)
            
        @thumbnail.write("#{RAILS_ROOT}/public/user_content/photos/small_thumb/#{logged_in_hmm_user.id}_#{@filename}")
        @gallery.write("#{RAILS_ROOT}/public/user_content/photos/big_thumb/#{logged_in_hmm_user.id}_#{@filename}")
  end 
end
    
    
    flash[:notice] = 'New Photo Album Created successfully '
    redirect_to :action => 'new'
 
end

 def edit
    @user_content = UserContent.find(params[:id])
 end
 
  def update
    @user_content = UserContent.find(params[:id])
    if @user_content.update_attributes(params[:user_content])
      $notice_pje
	  flash[:notice_pje] = 'UserContent was successfully updated.'
      redirect_to :action => 'photo_journal', :id => @user_content
    else
      render :action => 'edit'
    end
  end

  def destroy
    UserContent.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  
  def slideshow
      @user_content_pages, @user_contents = paginate :user_contents, :conditions => "e_filetype='PHOTO'", :order_by => 'id DESC' , :per_page => 500
  end
  
  def slideshow2
      @user_content_pages, @user_contents = paginate :user_contents, :conditions => "e_filetype='PHOTO'", :order_by => 'id DESC' , :per_page => 500
  end

  def images
    # @user_content_pages, @user_contents = paginate :user_contents, :conditions => "e_filetype='PHOTO'", :order_by => 'id DESC' , :per_page =>3
    @user_contents = UserContent.find(:all, :conditions => "uid=#{logged_in_hmm_user.id}" , :order => "id ASC" )
    render :layout => false
  end
  
  def addPhoto
    @val  = UserContent.new()
    @val['v_filename'] = params[:v_filename]
    @val['e_filetype'] = params[:e_filetype]
    splitresult=params[:v_filename].split('.')
    @val['v_tagphoto'] =splitresult[0]
    @val['sub_chapid'] = params[:sub_chapid]
    @val['uid'] = params[:userId]
    @val['e_access'] = params[:e_access]#'semiprivate'
    @val['tagid'] = params[:tagid]
	  @val['d_createddate'] = Time.now
    @val['img_url'] = "http://content.holdmymemories.com"
	  @val['d_momentdate'] = Time.parse(params[:createddate])
    @val['gallery_id'] = params[:gallery_id]
    @val['v_desc'] = 'Enter description here.'
    @val.save
    @results =  Tag.find(:all, :conditions=> "default_tag='no' and uid=#{logged_in_hmm_user.id}")
    for res in @results
      @imgval=UserContent.find(:all, :conditions=> "tagid ='#{res.id}' and v_filename='#{params[:v_filename]}'")
      for img in @imgval
        params[:id]=img.id
        UserContent.find(params[:id]).destroy
      end
    end
    params[:id]=@val.id
    render :layout => false 
  end

  def addallphoto
    files = params[:photolist]
    @idstring = "";
    filesarray = files.split('#')
    for file in filesarray
      filedata = file.split('$')
      @val  = UserContent.new()
      @val['v_filename'] = filedata[0]#file['v_filename'];#@params[:v_filename]
      logger.info("file name : - "+filedata[0])
      @val['e_filetype'] = params[:filetype]#file['e_filetype'];#params[:e_filetype]
      logger.info("File type :- "+params[:filetype])
      filename = filedata[0];
      logger.info("filename :- "+filename)
      splitresult= filename.split('.');#@params[:v_filename].split('.')
      @val['v_tagphoto'] =splitresult[0]
      @val['sub_chapid'] = params[:sub_chapid]#file['sub_chapid']; #@params[:sub_chapid]
      @val['uid'] = params[:userId]
      @val['e_access'] = params[:permission]#'semiprivate'
      @val['tagid'] = params[:tagid]
      @val['d_createddate'] = Time.now
      @val['d_momentdate'] = Time.parse(filedata[1])
      @val['gallery_id'] = params[:gallery_id]
      @val['v_desc'] = 'Enter description here.'
      @val.save
      @results =  Tag.find(:all, :conditions=> "default_tag='no' and uid=#{logged_in_hmm_user.id}")
      for res in @results
        @imgval=UserContent.find(:all, :conditions=> "tagid ='#{res.id}' and v_filename='#{filedata[0]}'")
        for img in @imgval
          params[:id]=img.id
          UserContent.find(params[:id]).destroy
        end
      end
      if(@idstring == "")
        @idstring = String(@val.id);
      else
        @idstring = @idstring+'$'+String(@val.id)
      end
    end
     render :layout => false
  end
  
  
  def photo_journal
    sql = ActiveRecord::Base.connection();
   if(session[:hmm_user]!='')
    if(session[:share]!="check" && session[:share_with_hmm]=="check")
       @hmm_user=HmmUsers.find(session[:hmm_user])
	 else
		@share = true
    
   end
  end
 
 if( params[:galleryid]!=nil)
   session[:galleryid]=params[:galleryid]
  end
  if(params[:Id])
    if(session[:share]==nil || session[:share]=='')
    @moment_belongs_to=Tag.find_by_sql("select a.*,b.* from user_contents as a,  hmm_users as b where a.id=#{params[:Id]} and  a.uid=b.id")
    if(@moment_belongs_to[0]['uid']!=logged_in_hmm_user.id)
      session[:friend]=@moment_belongs_to[0]['uid']
       @total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid and a.fid=#{session[:friend]}")
       if(@total>0)
         session[:semiprivate]="activate"
       else
         session[:semiprivate]=""
      end  
    end
   end 
   session[:usercontent_id]=params[:Id]
   @usercontent = UserContent.find(params[:Id])
   # code to show the videos
   
   params[:Id]=@usercontent.sub_chapid
   @sub_chapter = SubChapter.find(params[:Id])
   params[:Id]=@usercontent.id
   @journals_photo = JournalsPhoto.find(:all,:conditions=>"user_content_id=#{params[:Id]}",:order=>"id DESC" )
 else
    if(session[:share]==nil || session[:share]=='')
    @moment_belongs_to=Tag.find_by_sql("select a.*,b.* from user_contents as a,  hmm_users as b where a.id=#{params[:id]} and  a.uid=b.id")
    if(@moment_belongs_to[0]['uid']!=logged_in_hmm_user.id)
      session[:friend]=@moment_belongs_to[0]['uid']
       @total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid and a.fid=#{session[:friend]}")
       if(@total>0)
         session[:semiprivate]="activate"
       else
         session[:semiprivate]=""
      end  
    end
   end 
   session[:usercontent_id]=params[:id]
   @usercontent = UserContent.find(params[:id])
   if(@usercontent.e_filetype == "swf")
     @sshowSwf = "slideShow"
     #@videoXmlFile = @usercontent.img_url+"/user_content/videos/"+@usercontent.v_filename;
     @videoXmlFile = "/slideshow/get_slideshow_moment_list/#{params[:id]}"
   end
   # Bread crumb sessions
        params[:id]=@usercontent['gallery_id']
        
        @galleries = Galleries.find(params[:id])
          session[:gal]=params[:id]
          session[:gallery_name]=@galleries['v_gallery_name']
          params[:id]=@galleries['subchapter_id']
        @sub_chapter = SubChapter.find(params[:id])
          session[:subchap_id]=params[:id]
          session[:sub_chapname]=@sub_chapter['sub_chapname']
          params[:id]=@sub_chapter['tagid']
        @tag = Tag.find(params[:id])
          session[:chap_id]=params[:id]
          session[:chap_name]=@tag['v_tagname']
   
   
  
   params[:id]=@usercontent.sub_chapid
   @sub_chapter = SubChapter.find(params[:id])
   params[:id]=@usercontent.id
  end
   @journal_cnt = JournalsPhoto.count(:all, :conditions =>"user_content_id=#{params[:id]}")
   @type = params[:hmmtype]
   idarr="0"
   if(session[:friend]=="")
       
   else
     if(session[:semiprivate]=="activate")
      eacess=" and (e_access='public' or e_access='semiprivate')"
     else
      eacess=" and e_access='public'"
     end  
   end
   if(session[:share_with_hmm]!=nil)
    eacess=""
    session[:shid]
    share  = Share.find(session[:shid])
    @message = share.message
    sharedmoments=SharedMomentId.find(:all, :conditions => "share_id=#{share.id}")
    idarr=""
    for moment in sharedmoments
      idarr= idarr + "#{moment.moment_id}" + ","
    end
    idarr = idarr + "0"
    email_list=share.email_list
    email_array=email_list.split(',')
    for email in email_array
      #check for if email id exists in hmm database
      
     
      hmm_userscount = HmmUsers.count(:all, :conditions => "id='#{logged_in_hmm_user.id}' and v_e_mail='#{email}'")
      if(hmm_userscount>0)
        flag=1
      end  
    end
    
    if(flag==1)
      @user_content_pages, @user_content = paginate :user_contents, :conditions => " id in (#{idarr})  " ,:order =>'id asc', :per_page => 1
      if(params[:page]==nil)
      @counts =  UserContent.count(:all, :conditions => " id in (#{idarr}) ",:order =>'id asc')
      @allrecords =  UserContent.find(:all, :conditions => " id in (#{idarr}) ", :order =>'id asc')
      page=0
        for check in @allrecords
         page=page+1
         if(check.id==params[:id])
          @nextpage=page
          redirect_to :action => :photo_journal, :galleryid => params[:galleryid], :id=> params[:id], :page =>@nextpage
         end
          
        end
      else
       @user_content_pages, @user_content = paginate :user_contents, :conditions => " id in (#{idarr}) " , :order =>"id  asc", :per_page => 1
     end
     @norecords=""
   else
     @norecords="No records found"
   end
 else
 if(session[:share]=="check" )
  
    eacess=""
    session[:shid]
    share = Share.find(session[:shid])
    filename=share.xml_name
    share  = Share.find(session[:shid])
    @message = share.message
    sharedmoments=SharedMomentId.find(:all, :conditions => "share_id=#{share.id}")
    idarr=""
    for moment in sharedmoments
      idarr= idarr + "#{moment.moment_id}" + ","
    end
    idarr = idarr + "0"
    if(params[:page]==nil)
      @counts =  UserContent.count(:all, :conditions => " id in (#{idarr}) ")
      @allrecords =  UserContent.find(:all, :conditions => " id in (#{idarr}) ")
      page=0
      for check in @allrecords
        page=page+1
        if(check.id==params[:id])
         @nextpage=page
         redirect_to :action => :photo_journal,  :id=> params[:id], :page =>@nextpage
        end
      end
     else
       @user_content_pages, @user_content = paginate :user_contents, :conditions => " id in (#{idarr}) ", :per_page => 1
     end
     @norecords=""
   else
    if(params[:page]==nil)
    
      @counts =  UserContent.count(:all, :conditions => " gallery_id='#{@usercontent.gallery_id}' and status='active' #{eacess}",:order =>'id desc')
      @allrecords =  UserContent.find(:all, :conditions => " gallery_id='#{@usercontent.gallery_id}' and status='active' #{eacess}" ,:order =>'id desc')
      page=0
      for check in @allrecords
        page=page+1
        if(check.id==params[:id])
         @nextpage=page
         redirect_to :action => :photo_journal, :galleryid => params[:galleryid], :id=> params[:id], :page =>@nextpage
        end
      end
     else
     @user_content_pages, @user_content = paginate :user_contents, :conditions => "gallery_id='#{@usercontent.gallery_id}' and status='active'  #{eacess} ",:order =>'id desc', :per_page => 1
   end
   @norecords=""
  end
end
end


  def write_journal
     @hmm_user=HmmUsers.find(session[:hmm_user])
     @usercontent = UserContent.find(params[:id])
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
     params[:id]=@usercontent.sub_chapid
     @sub_chapter = SubChapter.find(params[:id])
     params[:id]=@usercontent.id
     #@journal = Journal.new
     @journals_photo =JournalsPhoto.new
  end
  
    
   def create_journal
     @hmm_user=HmmUsers.find(session[:hmm_user])
     #params[:journal][:date_added]=Time.now
     params[:journal][:updated_date]=Time.now
     @journal = JournalsPhoto.new(params[:journal])
     
     @journal['user_content_id']= params[:id]
     @journal.save
	 $notice_pjc
	 flash[:notice_pjc] = 'Moment Journal created!'
         session[:notice_pcc] = 'Moment Journal created!'
     redirect_to :action => :photo_journal ,:id => params[:id]
   end
 
 def photo_comnt
   @hmm_user=HmmUsers.find(session[:hmm_user])
   render(:layout => false)
 end
 

  
  def edit_journal
     @user_content = UserContent.find(params[:id])
     # @subchap_j = JournalsPhoto.find(:all, :joins => "as a, user_contents as b", :conditions => "a.user_content_id=b.id and a.id=#{params[:id]}")  
  end
  
  def update_journal
      @user_content = UserContent.find(params[:id])
   if @user_content.update_attributes(params[:j_id])
     
      flash[:notice] = 'Moment journal updated!'
      session[:notice_pcc] = 'Moment journal updated!'
      redirect_to :action => 'photo_journal', :id => @user_content
    else
      render :action => 'edit'
    end
  end
  
  def test
	  name =  "#{params[:Filename]}"
	  directory = "#{RAILS_ROOT}/tmp/"
	  # create the file path
	  path = File.join(directory, name)
	  # write the file
	  File.open(path, "wb") { |f| f.write(params[:Filedata]) }
	  @res = path
	  render :layout => false
	end
 
 def shareMoment
    @jtype = params[:id]
    @temp= @jtype.split("&")
#    @image = params[:id]
#     @img = @image.split("&")
  end
 
  def friendsList_moment
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
 
 def sharemomentWorker

    if params[:message]
      @message = params[:message]
    end
    @moment_type = params[:id]
    @temp = @moment_type.split("&")
    
    #   INSERTING HMM USERS IN SHARE'S TABLE    
    if params[:user]
      @hmmusers = params[:user]
      hmmids = @hmmusers.join(",")
      @hmmusers = HmmUsers.find(:all, :conditions => "id in (#{hmmids})") 
      for i in @hmmusers
        @share_moment = ShareMoment.new
        @share_moment['presenter_id']=logged_in_hmm_user.id
        @share_moment['usercontent_id']=params[:id]
        @share_moment['moment_type']=params[:moment_type]
        @share_moment['email']= i.v_e_mail
        @share_moment['created_date']=Time.now
        @share_moment['expiry_date']=Time.now.advance(:months => 1, :years => 0)
        @share_moment['message']=@message
        @share_moment['unid']=0
        @share_moment.save
        Postoffice.deliver_shareMomenthmm(@share_moment['email'],@message,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.v_myimage)
      end
    end
     
    #   INSERTING NON-HMM USERS IN SHARE'S TABLE
    if params[:nhmmuser]
      @nonhmmusers = params[:nhmmuser]
      nonhmmids = @nonhmmusers.join(",")
      @nonhmm = NonhmmUser.find(:all, :conditions => "id in (#{nonhmmids})") 
      for j in @nonhmm
        @share_max =  ShareMoment.find_by_sql("select max(id) as n from share_moments")
     for share_max in @share_max
      share_max_id = "#{share_max.n}"
     end
     if(share_max_id == '')
      share_max_id = '0'
     end
     share_next_id= Integer(share_max_id) + 1
        @share_moment = ShareMoment.new
        @share_moment['presenter_id']=logged_in_hmm_user.id
        @share_moment['usercontent_id']=params[:id]
        @share_moment['moment_type']=params[:moment_type]
        @share_moment['email']= j.v_email
        @share_moment['created_date']=Time.now
        @share_moment['expiry_date']=Time.now.advance(:months => 1, :years => 0)
        @share_moment['message']=@message
        shareuuid=Share.find_by_sql("select uuid() as uid")
        unid=shareuuid[0].uid+""+"#{share_next_id}"
        @share_moment['unid']=unid
        @share_moment.save
       Postoffice.deliver_shareMoment(@share_moment['email'],@message,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.v_myimage,@share_moment.id,@share_moment.unid)
      end
  end 
     
     #   INSERTING E-MAIL ID'S
    if params[:email]
      @frdEmail = params[:email]
      frindsEmail=@frdEmail.split(',')
      for k in frindsEmail
         @share_max =  ShareMoment.find_by_sql("select max(id) as n from share_moments")
     for share_max in @share_max
      share_max_id = "#{share_max.n}"
     end
     if(share_max_id == '')
      share_max_id = '0'
     end
        @check_hmmusers = HmmUsers.count(:all, :conditions => "v_e_mail='#{k}'") 
        if(@check_hmmusers > 0)
          @check_hmmusers = HmmUsers.find(:all, :conditions => "v_e_mail='#{k}'") 
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
            share_next_id= Integer(share_max_id) + 1
            @share_moment = ShareMoment.new
            @share_moment['presenter_id']=logged_in_hmm_user.id
            @share_moment['usercontent_id']=params[:id]
            @share_moment['moment_type']=params[:moment_type]
            @share_moment['email']= k
            @share_moment['created_date']=Time.now
            @share_moment['expiry_date']=Time.now.advance(:months => 1, :years => 0)
            @share_moment['message']=@message
            shareuuid=Share.find_by_sql("select uuid() as uid")
            unid=shareuuid[0].uid+""+"#{share_next_id}"
            @share_moment['unid']=unid
            @share_moment.save
            Postoffice.deliver_shareMoment(@share_moment['email'],@message,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.v_myimage,@share_moment.id,@share_moment.unid)
          end
      end
      
    end
     $share_moment123
   session[:notice_pcc] = 'Your share has been sent!'
     
    redirect_to :controller => 'myphotos', :action => 'photo_journal', :id => @temp[0]
  end
  
  
  def memory_count
   #code added to display the count of views in gallery
   id=params[:id]
   @usercontent=UserContent.find(:all,:conditions => "id='#{params[:id]}'" )
   sql = ActiveRecord::Base.connection()
   tm=Time.now
   tm=tm.strftime("%Y-%m-%d %I:%M:%S")
   puts tm
   for @i in @usercontent
    if(session[:friend]==nil || session[:friend]=='')   
    else
      sql.update "insert into memories_count (usercontent_id, content_type, user_id, view_type, view_date) values('#{@i.id}','#{@i.e_filetype}','#{session[:friend]}', 'friend', '#{tm}')"
    end
   
    if(session[:shid]==nil || session[:shid]=='')  
    else
      sql.update "insert into memories_count (usercontent_id, content_type, user_id, view_type, view_date) values('#{@i.id}','#{@i.e_filetype}','0','friend', '#{tm}')"
    end
    if((session[:friend]==nil || session[:friend]=='') && (session[:shid]==nil || session[:shid]==''))
      sql.update "insert into memories_count (usercontent_id, content_type, user_id, view_type, view_date) values('#{@i.id}','#{@i.e_filetype}','#{logged_in_hmm_user.id}', 'self', '#{tm}')"
    end
   end
  end
  
  def choose_upload
    @upload_type = HmmUser.count(:all, :conditions => "id=#{logged_in_hmm_user.id} and upload_type='basic'")
    if @upload_type > 0
    else
      redirect_to(:action => "new")
    end
  end
  
  def update_uploadtype
    sql = ActiveRecord::Base.connection()
    
      sql.update "UPDATE hmm_users SET upload_type='advance' WHERE id = '#{logged_in_hmm_user.id}'"
      redirect_to(:action => "new")
    
  end
  

end


