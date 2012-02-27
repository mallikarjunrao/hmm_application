class JournalsPhotosController < ApplicationController
layout "standard" 

#before_filter :only => [:index, :destroy, :enable_toggle]
#before_filter :login_required || :login_required1, :only => [:new, :list, :create, :index, :search, :edit, :deleteSelection, :deleteSelection1, :update]
 
  
  def index
    list
    render :action => 'list', :layout => false
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @journals_photo_pages, @journals_photos = paginate :journals_photos, :per_page => 10
  end

  def show
    @journals_photo = JournalsPhoto.find(params[:id])
  end

  def new
   @journals_photo = JournalsPhoto.new
   render :action => 'new', :layout => false
  end

  def create
    params[:journals_photo][:date_added]=Time.now
     params[:journals_photo][:updated_date]=Time.now
    @journals_photo = JournalsPhoto.new(params[:journals_photo])
    if @journals_photo.save
      flash[:notice] = 'JournalsPhoto was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @journals_photoall = JournalsPhoto.find(:all, :conditions => "user_content_id= '#{params[:id]}'")
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
    @ucontent_id=params[:id]
    for j in @journals_photoall
      params[:id]=j.id
      @journals_photo=JournalsPhoto.find(params[:id])
    end
    
  end

  def update
    @journals_photo = JournalsPhoto.find(params[:id])
    params['journals_photo']['date_added']=Time.now
    #params['journals_photo']['updated_date']=Time.now
    if @journals_photo.update_attributes(params[:journals_photo])
      flash[:notice] = 'Journal updated!'
       if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
       else if(session['redirect']=='5')
      
       redirect_to :controller => 'chapter_journal', :action => 'journals'
      
      else
      redirect_to :controller => 'myphotos', :action => 'photo_journal', :id => params[:ucontent_id]
    end
    end
    else
      render :action => 'edit'
    end
  end

  def destroying
    
    JournalsPhoto.find(params[:id]).destroy
     flash[:notice2] = 'Moment Journal Deleted!!'
     session[:notice_pcc] = 'Moment journal updated!'
     if(session['redirect']=='5')
      
       redirect_to :controller => 'chapter_journal', :action => 'journals'
     else if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
    
     else
       
    redirect_to :controller => 'myphotos', :action => 'photo_journal', :id =>session[:usercontent_id], :page => params[:page]
  end
  end
  end
end
