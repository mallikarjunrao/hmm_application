class ShareJournalsController < ApplicationController
  layout "standard"
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @share_journal_pages, @share_journals = paginate :share_journals, :per_page => 10
  end

  def show
    @share_journal = ShareJournal.find(params[:id])
  end

  def new
    @share_journal = ShareJournal.new
  end

  def create
    @share_journal = ShareJournal.new(params[:share_journal])
    if @share_journal.save
      flash[:notice] = 'Journal was successfully chared.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @share_journal = ShareJournal.find(params[:id])
  end

  def update
    @share_journal = ShareJournal.find(params[:id])
    if @share_journal.update_attributes(params[:share_journal])
      flash[:notice] = 'ShareJournal was successfully updated.'
      redirect_to :action => 'show', :id => @share_journal
    else
      render :action => 'edit'
    end
  end

  def shareJournal_view
    sql = ActiveRecord::Base.connection();
    sql.update "UPDATE share_journals SET shown='true' WHERE id = '#{params[:id]}'";
    @shareid = params[:id]
    @share_journal = ShareJournal.find(:all, :conditions => "id=#{params[:id]}")
    @user_contentID = ShareJournal.find(:all, :select =>"a.*", :joins => "as a, journals_photos as b" , :conditions => "a.id=#{params[:id]} and a.jid=b.id")
    for i in @share_journal
      params[:id] = i.jid
      @journalid = params[:id]  
      params[:id] = i.jtype
      @journaltype = params[:id]
      @presenter_id = i.presenter_id
      @presenter_name = HmmUser.find(:all, :conditions => "id='#{@presenter_id}'")
      @name = @presenter_name[0]['v_fname']
    end
    
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
    
    render :layout => true
  end

 def shareJournal_momentview
      
    end
  
  def destroy
    ShareJournal.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
