class SubChapJournalController < ApplicationController
  layout "standard" 
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @sub_chap_journal_pages, @sub_chap_journals = paginate :sub_chap_journals, :per_page => 10
  end

  def show
    @sub_chap_journal = SubChapJournal.find(params[:id])
  end

  def new
    @sub_chap_journal = SubChapJournal.new
    @subchap_j = SubChapter.find(:all, :conditions => "id=#{params[:id]}")
      @sub_chap_journal_count = SubChapJournal.count(:all,:conditions => "sub_chap_id='#{params[:id]}'")
    if (@sub_chap_journal_count>0)
        @sub_chap_journal = SubChapJournal.find(:all,:conditions => "sub_chap_id='#{params[:id]}'")
        redirect_to :controller => 'sub_chap_journal', :action => 'edit', :id => @sub_chap_journal[0]['id'] 
    end
  end

  def create
    @sub_chap_journal = SubChapJournal.new(params[:sub_chap_journal])
    @sub_chap_journal['sub_chap_id']=params[:subchap_id]
    if @sub_chap_journal.save
      $notice_sjc
      flash[:notice] = 'Sub-Chapter Journal Created!'
        if(session['redirect']=='2')
        redirect_to :controller => 'galleries', :action => 'gallery_coverflow', :id => params[:subchap_id]
      else
        redirect_to :controller => 'customers', :action => 'sub_chapter_gallery', :id => params[:subchap_id]
      end  
    else
      render :action => 'new'
    end
  end

  def edit
    @sub_chap_journal = SubChapJournal.find(params[:id])
    @subchap_j = SubChapJournal.find(:all, :joins => "as a , sub_chapters as b", :conditions => "a.sub_chap_id=b.id and a.id=#{params[:id]}")  
  end

  def update
    @sub_chap_journal = SubChapJournal.find(params[:id])
    @sub_chap_journal['d_updated_on']=Time.now
    @sub_chap_journal['created_on']=Time.now
    if @sub_chap_journal.update_attributes(params[:sub_chap_journal])
      
      
      $notice_sce
      flash[:notice_sce] = 'Sub-Chapter Journal Updated!'
      flash[:notice] = 'Sub-Chapter Journal Updated!'
  if(session['redirect']=='2')
        redirect_to :controller => 'galleries', :action => 'gallery_coverflow', :id => session[:sub_id]
      else if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
      else if(session['redirect']=='5')
      
       redirect_to :controller => 'chapter_journal', :action => 'journals'
      
      else
        redirect_to :controller => 'customers', :action => 'sub_chapter_gallery', :id => session[:sub_id]
      end 
    end
    end
      
      else
      render :action => 'edit'
    end
  end

  def destroying
    SubChapJournal.find(params[:id]).destroy
      flash[:notice2] = 'Sub Chapter Journal Was Successfully Deleted!!'
     if(session['redirect']=='2')
        redirect_to :controller => 'galleries', :action => 'gallery_coverflow', :id =>  session[:sub_id]
      else if(session['redirect']=='5')
      
       redirect_to :controller => 'chapter_journal', :action => 'journals'
     else if(session['redirect']=='3')
        redirect_to :controller => 'customers', :action => 'manage'
    
      else
        redirect_to :controller => 'customers', :action => 'sub_chapter_gallery', :id =>  session[:sub_id]
 end 
 end
 end     
  
  end
end
