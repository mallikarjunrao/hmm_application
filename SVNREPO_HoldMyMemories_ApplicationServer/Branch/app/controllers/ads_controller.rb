class AdsController < ApplicationController
  before_filter :only => [:index, :destroy, :enable_toggle]
  before_filter :login_required, :only => [:new, :list, :create, :index, :search, :edit, :deleteSelection, :deleteSelection1, :update]
  def initialize
    super
     # @hmm_users = [Item.new('item1'), Item.new('item2'), Item.new('item3'), Item.new('item4'), Item.new('item5')]
    @advertisement_details = AdvertisementDetail.find(:all)
  end
  
  def index
    list
    render :action => 'list' , :layout => false
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
   items_per_page = 5

    sort = case params['sort']
           when "v_adtitle"  then "v_adtitle"
           when "v_filename"   then "v_filename"
           when "v_adtitle_reverse"  then "v_adtitle DESC"
           when "v_filename_reverse"   then "v_filename DESC"
           end

    conditions = ["v_adtitle LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?

    @total = AdvertisementDetail.count(:conditions => conditions)
    @advertisement_detail_pages, @advertisement_details = paginate :advertisement_details, :order => sort, :conditions => conditions, :per_page => items_per_page

    if request.xml_http_request?
      render :partial => "ads_list", :layout => false
    end
  
end

  def show
    @advertisement_detail = AdvertisementDetail.find(params[:id])
  end

  def new
       @advertisement_detail = AdvertisementDetail.new
   # @advertisement_details = AdvertisementDetail.find(:all)
     @advertiser_details = AdvertiserDetail.find(:all)
     render(:layout => false)
  end

  def create
    @advertisement_detail = AdvertisementDetail.new(params[:advertisement_detail])
    
    if @advertisement_detail.save
    post = AdvertisementDetail.save(@params["advertisement_detail"])
      flash[:notice] = 'Advertisement Detail was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @advertisement_detail = AdvertisementDetail.find(params[:id])
    @advertiser_details = AdvertiserDetail.find(:all)
  end
  def say_hello
render(:layout => false)
  end

  def update
    @advertisement_detail = AdvertisementDetail.find(params[:id])
    if @advertisement_detail.update_attributes(params[:advertisement_detail])
      flash[:notice] = 'Advertisement Detail was successfully updated.'
      redirect_to :action => 'show', :id => @advertisement_detail
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    AdvertisementDetail.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
#WORDLIST = %w(Rails is a full-stack, open-source web framework in Ruby)

#def search
#@phrase = request.raw_post || request.query_string
#matcher = Regexp.new(@phrase)
#@results = WORDLIST.find_all { |word| word =~ matcher }
#render(:layout => false)
#end

  def search
    @results = AdvertisementDetail.find(:all) #, :conditions => [ "v_fname LIKE ?", @searchphrase])
    render(:layout => false)
  end

  def live_search
     
    @phrase = request.raw_post.chop || request.query_string
    a1 = "%"
    a2 = "%"
    @searchphrase = a1 + @phrase + a2
    #@results = <b>YOURMODEL</b>.find(:all, :conditions => [ "<b>YOURTABLE</b> LIKE ?", @searchphrase])
    @results = AdvertisementDetail.find(:all, :conditions => [ "v_adtitle LIKE ?", @searchphrase])
    
    @number_match = @results.length
   
    render(:layout => false)
  end  
  
  def deleteSelection
  i = 0
      colmns = @advertisement_details.clone
      colmns.each { |colmn|
        i = i + 1
        
      if (@params['colmn_'+i.to_s] != nil) then
          
        checked = @params['colmn_'+i.to_s]
        if (checked != nil && checked.length > 0) then
             
            AdvertisementDetail.find(checked).destroy
            #@hmm_users.delete(item)
            #redirect_to :action => :list 
         # else
            end
      end  
    }
      redirect_to :action => :list
 end
  
  def deleteSelection1
  i = 0
      colmns = @advertisement_details.clone
      colmns.each { |colmn|
      i = i + 1
        
      if (@params['colmn_'+i.to_s] != nil) then
          
        checked = @params['colmn_'+i.to_s]
        if (checked != nil && checked.length > 0) then
            AdvertisementDetail.find(checked).destroy
        end
      end  
    }
     render :action => 'search'
 end

end


