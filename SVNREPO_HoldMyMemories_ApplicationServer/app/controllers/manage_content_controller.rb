class ManageContentController < ApplicationController
  layout :theme_check
  
  before_filter :login_check, :except => [ :create_chapjournal,:update_chapjournal ]
  
  def theme_check
    @m=request.request_uri.split('/')
    @path=@m[2];
    if(@path.nil?)
    else  
      @path=@path.split('?')
      @path=@path[0]
    end
    #puts @path
#    if (@path !='moment_page' && @path !='gallery' && @path !='subchapters' && @path !='gallery_fisheye')
#      @family_name_tag = params[:id]
#    else 
      @family_name_tag = params[:familyname]
#    end
    puts @family_name_tag
    @theme_check = HmmUser.find(:all, :conditions => "family_name = '#{@family_name_tag}'")
    @theme_check[0]['themes']

  end
  
  def login_check #user login check for manage family website
    unless session[:hmm_user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to :action => 'mysite_login', :id => params[:id]
      return false
    else
      if (session[:flag] == 1 && request.request_uri != "/customers/upgrade/platinum_account")
        flash[:error] = "Your credit card payment to your HoldMyMemories.com has been declined by your credit card company. This could be for a number of reasons, including an expired card. <br><br><br>Please re-enter your credit card information, or use a different card for the renewal of your account."
        redirect_to "https://www.holdmymemories.com/customers/upgrade/platinum_account"
      end  
    end
  end
  
  def new_chapjournal
    @hmm_user=HmmUser.find(session[:hmm_user])
    @chapter_journal = ChapterJournal.new
    @chap = Tag.find(:all, :conditions => "id=#{params[:id]}")
     @chapter_journal_count = ChapterJournal.count(:all,:conditions => "tag_id='#{params[:id]}'")
    if (@chapter_journal_count>0)
        @chapter_journal = ChapterJournal.find(:all,:conditions => "tag_id='#{params[:id]}'")
              redirect_to :action => 'edit_chapjournal', :id => @chapter_journal[0]['id'], :familyname => params[:familyname], :view => params[:view]
  
    end
  end

  def create_chapjournal
    @chapter_journal = ChapterJournal.new(params[:chapter_journal])
    @chapter_journal['tag_id']=params[:tag_id]
   
     @chapter_journal['d_updated_at']=Time.now
     
    if @chapter_journal.save
     $notice_chapjournal
      flash[:notice_chapjournal] = 'Chapter Journal created!'
      if params[:view] == "grid"
        redirect_to :controller => 'my_familywebsite', :action => 'subchapter_grid_view', :id => params[:family_name],:chapter_id => @chapter_journal.tag_id
      else
        redirect_to :controller => 'my_familywebsite', :action => 'subchapters', :id => @chapter_journal.tag_id, :familyname => params[:family_name]
      end
    else
      render :action => 'new_chapjournal'
    end
  end

  def edit_chapjournal
    @chapter_journal = ChapterJournal.find(params[:id])
  
     @chap_j = ChapterJournal.find(:all,:select =>"a.*,b.*" ,:joins => "as a , tags as b", :conditions => "a.tag_id=b.id and a.id=#{params[:id]}")  
   end

  def update_chapjournal
    
    @chapter_journal = ChapterJournal.find(params[:id])
    @chapter_journal['d_updated_at']=Time.now
    @chapter_journal['d_created_at']=Time.now
     
    if @chapter_journal.update_attributes(params[:chapter_journal])
       $notice_chapjournal_update
      flash[:notice_chapjournal_update] = 'Chapter Journal Updated!'
      if params[:view] == "grid"
        redirect_to :controller => 'my_familywebsite', :action => 'subchapter_grid_view', :id => params[:family_name],:chapter_id => @chapter_journal.tag_id
      else
        redirect_to :controller => 'my_familywebsite', :action => 'subchapters', :id => @chapter_journal.tag_id, :familyname => params[:family_name]
      end
    else
      render :action => 'edit_chapjournal'
    end
  end
  
  
  #subchapter journals functionality
  
  def new_subchapjournal
    @sub_chap_journal = SubChapJournal.new
    @subchap_j = SubChapter.find(:all, :conditions => "id=#{params[:id]}")
      @sub_chap_journal_count = SubChapJournal.count(:all,:conditions => "sub_chap_id='#{params[:id]}'")
    if (@sub_chap_journal_count>0)
        @sub_chap_journal = SubChapJournal.find(:all,:conditions => "sub_chap_id='#{params[:id]}'")
         redirect_to :action => 'edit_subchapjournal', :id => @sub_chap_journal[0]['id'], :familyname => params[:familyname], :view => params[:view]
     end
  end

  def create_subchapjournal
    @sub_chap_journal = SubChapJournal.new(params[:sub_chap_journal])
    @sub_chap_journal['sub_chap_id']=params[:subchap_id]
    if @sub_chap_journal.save
      $notice_sjc
      flash[:notice_sjc] = 'Sub-Chapter Journal Created!'
      if params[:view] == "grid"
         redirect_to :controller => 'my_familywebsite', :action => 'gallery_grid_view', :id => params[:family_name],:subchapter_id => @sub_chap_journal.sub_chap_id
      else
         redirect_to :controller => 'my_familywebsite', :action => 'gallery', :id => @sub_chap_journal.sub_chap_id, :familyname => params[:family_name]
      end
    else
      render :action => 'new_subchapjournal'
    end
    
  end

  def edit_subchapjournal
    @sub_chap_journal = SubChapJournal.find(params[:id])
    @subchap_j = SubChapJournal.find(:all,:select =>"a.*,b.*", :joins => "as a , sub_chapters as b", :conditions => "a.sub_chap_id=b.id and a.id=#{params[:id]}")  
  end

  def update_subchapjournal
    @sub_chap_journal = SubChapJournal.find(params[:id])
    @sub_chap_journal['d_updated_on']=Time.now
    @sub_chap_journal['created_on']=Time.now
    if @sub_chap_journal.update_attributes(params[:sub_chap_journal])
      
      
      $notice_sce
      flash[:notice_sce] = 'Sub-Chapter Journal Updated!'
      flash[:notice] = 'Sub-Chapter Journal Updated!'
      if params[:view] == "grid"
         redirect_to :controller => 'my_familywebsite', :action => 'gallery_grid_view', :id => params[:family_name],:subchapter_id => @sub_chap_journal.sub_chap_id
      else
        redirect_to :controller => 'my_familywebsite', :action => 'gallery', :id => @sub_chap_journal.sub_chap_id, :familyname => params[:family_name]
      end
    else
      render :action => 'edit_subchapjournal'
    end
  end

  #Gallery Journal add and edit
  
  def new_galjournal
    @gallery_journal = GalleryJournal.new
    @gal = Galleries.find(:all, :conditions => "id=#{params[:id]}")
     
        @gallery_journal_count = GalleryJournal.count(:all,:conditions => "galerry_id='#{params[:id]}'")
    
     if (@gallery_journal_count>0)
        @gallery_journal = GalleryJournal.find(:all,:conditions => "galerry_id='#{params[:id]}'")
        
         redirect_to :action => 'edit_galjournal', :id => @gallery_journal[0]['id'], :familyname => params[:familyname], :view => params[:view]
        
    end
  end

  def create_galjournal
    @gallery_journal = GalleryJournal.new(params[:gallery_journal])
    @gallery_journal['uid']=logged_in_hmm_user.id
    @gallery_journal['galerry_id']=params[:galery_id]
    @gallery_journal['d_updated_on']=Time.now 
    if @gallery_journal.save
      $notice_gjc
      flash[:notice_gjc] = 'Gallery Journal Created!'
      if params[:view] == "grid"
         redirect_to :controller => 'my_familywebsite', :action => 'content_grid_view', :id => params[:family_name],:gallery_id => @gallery_journal.galerry_id
      else
         redirect_to :controller => 'my_familywebsite', :action => 'gallery_fisheye', :id => @gallery_journal.galerry_id, :familyname => params[:family_name]
      end
     else
      render :action => 'new_galjournal'
    end
  end

  def edit_galjournal
    @gallery_journal = GalleryJournal.find(params[:id])
     @gal_j = GalleryJournal.find(:all, :select => "a.*,b.*",:joins => "as a , galleries as b", :conditions => "a.galerry_id=b.id and a.id=#{params[:id]}")  
  end

  def update_galjournal
    @gallery_journal = GalleryJournal.find(params[:id])
    @gallery_journal['d_updated_on']=Time.now 
      @gallery_journal['d_created_on']=Time.now 
    if @gallery_journal.update_attributes(params[:gallery_journal])
       
      $notice_gju
      flash[:notice_gju] = 'Gallery Journal Updated!'
      if params[:view] == "grid"
         redirect_to :controller => 'my_familywebsite', :action => 'content_grid_view', :id => params[:family_name],:gallery_id => @gallery_journal.galerry_id
      else
         redirect_to :controller => 'my_familywebsite', :action => 'gallery_fisheye', :id => @gallery_journal.galerry_id, :familyname => params[:family_name]
      end
    else
      render :action => 'edit_galjournal'
    end
  end


#  moment Journal write and edit for family website
   def write_journal
     @hmm_user=HmmUser.find(session[:hmm_user])
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
     @hmm_user=HmmUser.find(session[:hmm_user])
     #params[:journal][:date_added]=Time.now
     params[:journal][:updated_date]=Time.now
     @journal = JournalsPhoto.new(params[:journal])
     
     @journal['user_content_id']= params[:id]
     @journal.save
   $notice_pjc
   flash[:notice_pjc] = 'Journal entry created successfully!'
         session[:notice_pcc] = 'Moment Journal created!'
     redirect_to :controller => :my_familywebsite, :action => :moment_page ,:id => params[:id], :familyname => params[:family_name]
   end
 
  def edit_journal
     @journals_photo = JournalsPhoto.find(params[:id])
     
     @usercontent = UserContent.find(@journals_photo.user_content_id)
     if(@usercontent.e_filetype=='video' || @usercontent.e_filetype=='swf')
       @imgpath="/user_content/videos/thumbnails/#{@usercontent.v_filename}"+".jpg"
     else
       if(@usercontent.e_filetype=='image')
       @imgpath="/user_content/photos/small_thumb/#{@usercontent.v_filename}"
     else
       @imgpath="/user_content/audios/speaker.jpg"
     end
     end
     # @subchap_j = JournalsPhoto.find(:all, :joins => "as a, user_contents as b", :conditions => "a.user_content_id=b.id and a.id=#{params[:id]}")  
  end
  
  def update_journal
      @journals_photo = JournalsPhoto.find(params[:id])
   if @journals_photo.update_attributes(params[:journals_photo])
      $notice_pjupdate
      flash[:notice_pjupdate] = 'Journal entry updated successfully!'
      session[:notice_pcc] = 'Moment journal updated!'
      redirect_to :controller => :my_familywebsite, :action => :moment_page ,:id => @journals_photo.user_content_id, :familyname => params[:family_name]
    else
      render :action => 'edit_journal'
    end
  end


  def new_textblog
    @family_name_tag = params[:familyname]
    @text_journal = TextJournal.new
    
    
    
  end

  def create_textblog

    @text_journal = TextJournal.new(params[:text_journal])
    @text_journal['uid']=logged_in_hmm_user.id
    
    @text_journal['d_updated_at']=Time.now

    if @text_journal.save
      
      flash[:notice] = 'Text Blog Entry added successfully!'
      
         redirect_to :controller => 'my_familywebsite', :action => 'journals', :id => params[:familyname]
      
    else
      render :action => 'new_textblog'
    end

  end


  
end
