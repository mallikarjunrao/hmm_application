class CuponsController < ApplicationController
  layout "admin"
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  before_filter :authenticate_admin, :only => [ :new, :edit, :preview]

  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "https://www.holdmymemories.com/account/login"
    return false
    end
  end

  def list
    @cupon_pages, @cupons = paginate :cupons, :per_page => 10
  end

  def show
    @cupon = Cupon.find(params[:id])
  end

  def new
    @cupon = Cupon.new
  end

  def create
     @cupon_max =  Cupon.find_by_sql("select max(id) as n from cupons")
     for cupon_max in @cupon_max
      cupon_max_id = "#{cupon_max.n}"
     end
     if(cupon_max_id == '')
      cupon_max_id = '0'
    end
    @cupon_id= Integer(cupon_max_id) + 1
    cupon_next_id= Integer(cupon_max_id) + 1
    couponuuid=Cupon.find_by_sql("select uuid() as id")
    @unid=String(couponuuid.id)+"_"+"#{cupon_next_id}"
    
    @cupon = Cupon.new(params[:cupon])
     @cupon['unid'] = @unid
     @cupon['valid_period'] = params[:cupon][:valid_period]
    if @cupon.save
      flash[:notice] = 'Cupon was successfully created.'
      redirect_to :action => 'preview', :id => @cupon_id
    else
      render :action => 'new'
    end
  end

  def edit
    @cupon = Cupon.find(params[:id])
  end

  def update
    @cupon = Cupon.find(params[:id])
    if @cupon.update_attributes(params[:cupon])
      flash[:notice] = 'Cupon was successfully updated.'
      redirect_to :action => 'preview', :id => @cupon
    else
      render :action => 'edit'
    end
  end

  def destroy
    Cupon.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def preview
     @cupon = Cupon.find(params[:id])
  end
 
  
#  def savecupon
#    @cupon = Cupon.new
#    @cupon['unid']=params[:cuponno]
#    @cupon['valid_period']=params[:valid_period]
#    @cupon['start_date']=params[:startdate]
#    @cupon['expire_date']=params[:expiredate]
#    @cupon['cupon_type']=params[:cupontype]
#    if @cupon.save
#      flash[:notice] = 'Cupon was successfully created.'
#      redirect_to :action => 'list'
#    else
#      render :action => 'print'
#    end
#  
#  end
  
#  def print
#     @cupon_max =  Cupon.find_by_sql("select max(id) as n from cupons")
#     for cupon_max in @cupon_max
#      cupon_max_id = "#{cupon_max.n}"
#     end
#     if(cupon_max_id == '')
#      cupon_max_id = '0'
#    end
#    cupon_next_id= Integer(cupon_max_id) + 1
#    couponuuid=Cupon.find_by_sql("select uuid() as uid")
#    @unid=couponuuid[0].uid+""+"#{cupon_next_id}"
#    
#      @to_yr=params[:cupon]['expire_date(1i)']
#      @to_mon=params[:cupon]['expire_date(2i)']
#      @to_date=params[:cupon]['expire_date(3i)']
#    
#      @startto_yr=params[:cupon]['start_date(1i)']
#      @startto_mon=params[:cupon]['start_date(2i)']
#      @startto_date=params[:cupon]['start_date(3i)'] 
##       @back_issue = params[:expire_date].to_date  
#  end
#  
end
