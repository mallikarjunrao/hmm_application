class JournalsController < ApplicationController

#before_filter :only => [:index, :destroy, :enable_toggle]
#before_filter :login_required || :login_required1, :except => [:login]


  def initialize
    super
#    @hmm_users = [Item.new('item1'), Item.new('item2'), Item.new('item3'), Item.new('item4'), Item.new('item5')]
    @journals = Journal.find(:all)
#    add these variable for excluding field, including field, sortable field, filterable field
#    @excludefield = []
#    @includefield = ['bi_locn_code','bi_locn_name','bi_dist_name'] 
#    @sortable = ['bi_locn_code']
#    @filterable = ['bi_locn_code','bi_locn_name']
#    initialize_movtable
  end
  
  def index
    list
    render :action => 'list', :layout => false
  end

  #before_filter :only => [:index, :destroy, :enable_toggle]


  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @journal_pages, @journals = paginate :journals ,:conditions=>"uid!='logged_in_hmm_user.id'", :per_page => 10
  end

  def show
    @journal = Journal.find(params[:id])
    #@journal = @journals_photo['v_image_filename']
  end

  def new
    @journal = Journal.new
    #@journals_photo = JournalsPhoto.new
  end

  def create
    #code to upload photos
    @filename = @params[:journals_photo][:v_image_filename].original_filename
    @journal = Journal.new(params[:journal])
    @journals_photo = JournalsPhoto.new(params[:journals_photo])
    post = Journal.save(@params['journals_photo'])
    @journals_photo['v_image_filename']=@filename
     
    #code to upload video files 
    @filename1 = @params[:journals_video][:v_video_filename].original_filename
    @journals_video = JournalsVideo.new(params[:journals_video])
    post = Journal.save1(@params['journals_video'])
    @journals_video['v_video_filename']=@filename1
    
    #code to upload audio files
    @filename2 = @params[:journals_audio][:v_audio_filename].original_filename
    @journals_audio = JournalsAudio.new(params[:journals_audio])
    post = Journal.save2(@params['journals_audio'])
    @journals_audio['v_audio_filename']=@filename2
    
    #code to upload paperwork files
    @filename3 = @params[:journals_paperwork][:v_paper_filename].original_filename
    @journals_paperwork = JournalsPaperwork.new(params[:journals_paperwork])
    post = Journal.save3(@params['journals_paperwork'])
    @journals_paperwork['v_paper_filename']=@filename3
    
    @journal.uid = @Logged_in_hmm_user;
    
    if @journal.save && @journals_photo.save && @journals_video.save && @journals_audio.save && @journals_paperwork.save 
       flash[:notice] = 'Journal was successfully created.'
       redirect_to :action => 'list'
    else
       render :action => 'new'
    end
  end

  def edit
    @journal = Journal.find(params[:id])
  end

  def update
    @journal = Journal.find(params[:id])
    if @journal.update_attributes(params[:journal])
      flash[:notice] = 'Journal was successfully updated.'
      redirect_to :action => 'show', :id => @journal
    else
      render :action => 'edit'
    end
  end

  def destroy
    Journal.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def deleteSelection
    i = 0
      colmns = @journals.clone
      colmns.each { |colmn|
        i = i + 1
        
      if (@params['colmn_'+i.to_s] != nil) then
          
        checked = @params['colmn_'+i.to_s]
        if (checked != nil && checked.length > 0) then
              
           # @journals['v_journal_status']='blocked'
           # @journal.save
            
            Journal.find(checked).destroy
            #@hmm_users.delete(item)
            #redirect_to :action => :list 
         # else
        end
      end  
    }
      redirect_to :action => :list
 end
 
  
 
end
