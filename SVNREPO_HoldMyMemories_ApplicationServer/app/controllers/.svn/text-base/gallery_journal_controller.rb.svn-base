class GalleryJournalController < ApplicationController
   layout "standard"
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @gallery_journal_pages, @gallery_journals = paginate :gallery_journals, :per_page => 10
  end

  def show
    @gallery_journal = GalleryJournal.find(params[:id])
  end

  def new
    @gallery_journal = GalleryJournal.new
    @gal = Galleries.find(:all, :conditions => "id=#{params[:id]}")
     
        @gallery_journal_count = GalleryJournal.count(:all,:conditions => "galerry_id='#{params[:id]}'")
    
     if (@gallery_journal_count>0)
        @gallery_journal = GalleryJournal.find(:all,:conditions => "galerry_id='#{params[:id]}'")
        redirect_to :controller => 'gallery_journal', :action => 'edit', :id => @gallery_journal[0]['id'] 
    end
  end

  def create
    @gallery_journal = GalleryJournal.new(params[:gallery_journal])
    @gallery_journal['uid']=logged_in_hmm_user.id
    @gallery_journal['galerry_id']=params[:galery_id]
    @gallery_journal['d_updated_on']=Time.now 
    if @gallery_journal.save
      $notice_gjc
      flash[:notice] = 'Gallery Journal Created!'
       if(session['redirect']=='2')
      redirect_to :controller => 'galleries', :action => 'gallery_fisheye', :id => params[:galery_id]
    else
      redirect_to :controller => 'customers', :action => 'chapter_gallery', :id => params[:galery_id]
    end  

    else
      render :action => 'new'
    end
  end

  def edit
    @gallery_journal = GalleryJournal.find(params[:id])
     @gal_j = GalleryJournal.find(:all, :select => "a.*,b.*",:joins => "as a , galleries as b", :conditions => "a.galerry_id=b.id and a.id=#{params[:id]}")  
  end

  def update
    @gallery_journal = GalleryJournal.find(params[:id])
    @gallery_journal['d_updated_on']=Time.now 
      @gallery_journal['d_created_on']=Time.now 
    if @gallery_journal.update_attributes(params[:gallery_journal])
       
      $notice_gju
      flash[:notice] = 'Gallery Journal Updated!'
      if(session['redirect']=='2')
      redirect_to :controller => 'galleries', :action => 'gallery_fisheye', :id => session[:galery_id]
       else if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
     else if(session['redirect']=='5')
      
       redirect_to :controller => 'chapter_journal', :action => 'journals'
      
    else
      redirect_to :controller => 'customers', :action => 'chapter_gallery', :id => session[:galery_id]
    end 
    end
    end
    else
      render :action => 'edit'
    end
  end

  def destroying
    
    GalleryJournal.find(params[:id]).destroy
        flash[:notice] = 'Journal Entry Deleted!'
      if(session['redirect']=='2')
        redirect_to :controller => 'galleries', :action => 'gallery_fisheye', :id => session[:galery_id]
    
        else if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
    else
        if(session['redirect']=='5')
      
       redirect_to :controller => 'chapter_journal', :action => 'journals'
      
      else
        redirect_to :controller => 'customers', :action => 'chapter_gallery', :id => session[:galery_id]
    end
    end
    end   
  end
end
