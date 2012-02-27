class AdvertisersController < ApplicationController
  helper :user_account
  include UserAccountHelper

before_filter :only => [:index, :destroy, :enable_toggle]
before_filter :login_required, :only => [:new, :list, :create, :index, :search, :edit, :deleteSelection, :deleteSelection1, :update]
  def initialize
    super
     # @hmm_users = [Item.new('item1'), Item.new('item2'), Item.new('item3'), Item.new('item4'), Item.new('item5')]
    @advertiser_details = AdvertiserDetails.find(:all)
  end
  
  def index
    list
    render :action => 'list' , :layout => false
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @advertiser_details_pages, @advertiser_details = paginate :advertiser_details, :per_page => 10
    
  end

  def show
    @advertiser_details = AdvertiserDetails.find(params[:id])
  end

  def new
    @advertiser_details = AdvertiserDetails.new
    render(:layout => false)
  end

  def create
    @advertiser_details = AdvertiserDetails.new(params[:advertiser_details])
    if @advertiser_details.save
      flash[:notice] = 'AdvertiserDetails was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @advertiser_details = AdvertiserDetails.find(params[:id])
    render(:layout => false)
  end

  def update
    @advertiser_details = AdvertiserDetails.find(params[:id])
    if @advertiser_details.update_attributes(params[:advertiser_details])
      flash[:notice] = 'AdvertiserDetails was successfully updated.'
      redirect_to :action => 'show', :id => @advertiser_details
    else
      render :action => 'edit'
    end
  end

  def destroy
    AdvertiserDetails.find(params[:id]).destroy
    redirect_to :controller =>'advertisers' , :action => ''
  end
  
  def deleteSelection
  i = 0
      colmns = @advertiser_details.clone
      colmns.each { |colmn|
        i = i + 1
        
      if (params['colmn_'+i.to_s] != nil) then
          
        checked = params['colmn_'+i.to_s]
        if (checked != nil && checked.length > 0) then
             
            AdvertiserDetails.find(checked).destroy
            #@hmm_users.delete(item)
            #redirect_to :action => :list 
         # else
            
         
        end
      end  
    }
      redirect_to :action => :list
 
  
end

def live_search
     
    @phrase = request.raw_post.chop || request.query_string
    a1 = "%"
    a2 = "%"
    @searchphrase = a1 + @phrase + a2
    
    @results = AdvertiserDetails.find(:all, :conditions => [ "v_firstname LIKE ?", @searchphrase])
    
    @number_match = @results.length
   
    render(:layout => false)
end

def search
   @results = AdvertiserDetails.find(:all) #, :conditions => [ "v_fname LIKE ?", @searchphrase])
   
  render(:layout => false)
  
end



def get_studio_direct

    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="orders_report.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end


@order_details = HmmUser.find(:all,:joins=>"as a , tags as b",:select=>" a.id,a.v_fname ,a.v_lname,a.v_user_name,a.v_e_mail " ,:conditions=>"a.id=b.uid and (b.v_tagname LIKE 'studio%' || b.v_tagname LIKE 'session%' || b.v_tagname LIKE
'studio sessions%') and a.studio_id=0 " ,:group=>"a.id")

    render :layout => false
end




end
