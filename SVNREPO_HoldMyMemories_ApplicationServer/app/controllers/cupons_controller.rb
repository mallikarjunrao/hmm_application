class CuponsController < ApplicationController
  layout "admin"

  helper :sort
  include SortHelper
  require 'will_paginate'

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  before_filter :authenticate_admin, :only => [ :new, :edit, :preview,:list_coupons,:view_studios,:delete_coupon,:new_ecommerce_coupon,:ecommerce_coupon_report,:coupon_used_details]

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

  def create_new_coupons

    # case1

#    i=10001
#    while i<=19000
#      @coupon=Cupon.new()
#      @coupon['unid'] ="sp#{i}"
#      @coupon['valid_period']="12"
#      @coupon['start_date']="2010-01-07 00:00:00"
#      @coupon['expire_date']="2010-01-31 00:00:00"
#      @coupon['cupon_type']="family_website"
#      @coupon.save
#      i=i+1
#    end


    #case2

#    i=19001
#    while i<=28000
#      @coupon=Cupon.new()
#      @coupon['unid'] ="sp#{i}"
#      @coupon['valid_period']="12"
#      @coupon['start_date']="2010-01-07 00:00:00"
#      @coupon['expire_date']="2010-03-31 00:00:00"
#      @coupon['cupon_type']="family_website"
#      @coupon.save
#      i=i+1
#    end

    #case3

#    i=28001
#    while i<=30000
#      @coupon=Cupon.new()
#      @coupon['unid'] ="sp#{i}"
#      @coupon['valid_period']="12"
#      @coupon['start_date']="2010-01-07 00:00:00"
#      @coupon['expire_date']="2099-12-31 00:00:00"
#      @coupon['cupon_type']="family_website"
#      @coupon.save
#      i=i+1
#    end

    #testing case

    i=30001
    while i<=30100
      @coupon=Cupon.new()
      @coupon['unid'] ="sp#{i}"
      @coupon['valid_period']="12"
      @coupon['start_date']="2010-01-07 00:00:00"
      @coupon['expire_date']="2010-03-03 00:00:00"
      @coupon['cupon_type']="family_website"
      @coupon.save
      i=i+1
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

  #Ecommerce Coupons Section
  def new_ecommerce_coupon
    @ecoupon=EcommerceCoupon.new()
    @studiogroups=HmmStudiogroup.find(:all)
    if(params[:id]!='' && params[:id]=nil)
      @studios=HmmStudio.find(:all,:conditions=>"id=#{params[:id]}")
    end
  end


  def get_studios

    @hmmstudiocnt=HmmStudio.count(:all,:conditions=>"studio_groupid='#{params[:owner_id]}'")

    @hmmstudios=HmmStudio.find(:all,:conditions=>"studio_groupid='#{params[:owner_id]}'")

    if(@hmmstudiocnt>0)
      res=""

      for k in @hmmstudios

        res=res.concat("<input type='checkbox' name='studios[]' value='#{k.id}'>&nbsp;&nbsp;#{k.studio_name}<br>")

      end
    else
      res="No Studios Found"
    end

    render :text => res
  end



def create_ecommerce_coupons

    #couponuuid=EcommerceCoupon.find_by_sql("select uuid() as id")
    #@unid=String(couponuuid.id)
    cpncnt=EcommerceCoupon.count(:all,:conditions=>"coupon_id='#{params[:coupon_id]}'")
    if(cpncnt==0)

      @cupon = EcommerceCoupon.new(params[:ecommerce_coupon])
      @cupon['coupon_id'] = params[:coupon_id]
      @cupon['discount_type']=params[:ecommerce_coupon][:discount_type]
      @cupon['discount_amount']=params[:ecommerce_coupon][:discount_amount]
      @cupon['discount_percentage']=params[:ecommerce_coupon][:discount_percentage]
      @cupon['free_shipping']=params[:free_shipping]
      if(session[:franchise]!='' && session[:franchise]!=nil)
        @cupon['studio_owner_id']=session[:franchise]
      else
        @cupon['studio_owner_id']=0
      end

      if @cupon.save

        if(params[:studios].length>0)
          for m in params[:studios]
            @scupon = EcommerceCouponsStudio.new()
            @scupon['ecommerce_coupon_id'] = @cupon.id
            @scupon['studio_id']=m
            @scupon.save
          end

          #HMM ORDER coupon
          if(params[:studio_group] == "1" || session[:franchise] == "1")
            @ncupon = EcommerceCouponsStudio.new()
            @ncupon['ecommerce_coupon_id'] = @cupon.id
            @ncupon['studio_id']=0
            @ncupon.save
          end

        end

        flash[:notice] = 'Ecommerce Coupon was successfully created.'
        if(session[:franchise])
          redirect_to :action => 'list_studiocoupons', :id => @cupon_id
        else
          redirect_to :action => 'list_coupons', :id => @cupon_id
        end
      end
    else
      flash[:notice] = 'Ecommerce Coupon Already exists'
      if(session[:franchise])
        redirect_to :action => 'new_ecommerce_studiocoupon'
      else
        redirect_to :action => 'new_ecommerce_coupon'
      end
    end
  end


 def list_coupons
    sort_init 'id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "id desc"
      else
        sort = "id desc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end

    if params[:coupon_id] && params[:coupon_id]!=''
      cond="and coupon_id LIKE '%#{params[:coupon_id]}%'"
    else
      cond=''
    end

    if params[:discount_type] && params[:discount_type]!=''
      params[:discount_type]== 'percentage' ? @percentage="selected" : @dollar="selected"
      cond1="and discount_type = '#{params[:discount_type]}'"
    else
      cond1=''
    end

    if params[:free_shipping] && params[:free_shipping]!=''
      params[:free_shipping]=='true' ? @yes="selected" : @no="selected"
      cond2="and free_shipping = '#{params[:free_shipping]}'"
    else
      cond2=''
    end

    @search_condition = ""

    if(params[:start_date]!=nil && params[:start_date]!='' &&  params[:end_date]!=nil && params[:end_date]!='')
      @starts_date=params[:start_date]
      @ends_date=params[:end_date]
      from_date_ary = params[:start_date].split("/")
      @start_date1= "#{from_date_ary[2]}-#{from_date_ary[0]}-#{from_date_ary[1]}"
      end_date_ary = params[:end_date].split("/")
      @end_date1= "#{end_date_ary[2]}-#{end_date_ary[0]}-#{end_date_ary[1]}"
      @search_condition = "and start_date >= '#{@start_date1}' and end_date <= '#{@end_date1}'"
    end

    @cpcnt=EcommerceCoupon.count(:all, :conditions=> "status='active'")
    @cp_details = EcommerceCoupon.paginate :per_page => 10, :page => params[:page], :order =>sort, :conditions=>"status='active' #{cond} #{cond1} #{cond2} #{@search_condition}"
  end

  def list_studiocoupons
    sort_init 'id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "id desc"
      else
        sort = "id desc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end


    @cpcnt=EcommerceCoupon.count(:all,:conditions=>"status='active' and studio_owner_id=#{session[:franchise]}")

    @cp_details = EcommerceCoupon.paginate :per_page => 10, :page => params[:page],:order =>sort,:conditions=>" status='active' and studio_owner_id=#{session[:franchise]}"
  end




  def view_studios
    @studiocnt=EcommerceCouponsStudio.count(:all,:conditions=>"ecommerce_coupon_id=#{params[:id]}")
    if(@studiocnt>0)
      @studios=EcommerceCouponsStudio.find(:all,:joins=>"as a , hmm_studios as b",:select=>"a.*,b.*",:conditions=>"a.ecommerce_coupon_id=#{params[:id]} and a.studio_id=b.id")
    end

  end


  def ecommerce_coupon_report
    @reports=Order.paginate :per_page => 10, :page => params[:page] ,:select=>"count(a.id) as no_of_users,DATE_FORMAT(b.start_date,'%m/%d/%Y') as started_date,DATE_FORMAT(b.end_date,'%m/%d/%Y') as ended_date ,a.*,b.*",:joins=>"as a , ecommerce_coupons as b " ,:conditions=>"a.ecommerce_coupon_id!=0 and b.id=a.ecommerce_coupon_id ",:group =>"a.ecommerce_coupon_id"
  end

  def studio_ecommerce_coupon_report
    @reports=Order.paginate :per_page => 10, :page => params[:page] ,:select=>"count(a.id) as no_of_users,DATE_FORMAT(b.start_date,'%m/%d/%Y') as started_date,DATE_FORMAT(b.end_date,'%m/%d/%Y') as ended_date ,a.*,b.*",:joins=>"as a , ecommerce_coupons as b " ,:conditions=>"a.ecommerce_coupon_id!=0 and b.id=a.ecommerce_coupon_id and b.studio_owner_id=#{session[:franchise]}",:group =>"a.ecommerce_coupon_id"
  end


  def coupon_used_details
    if(params[:id]!='' && params[:id]!=nil)
    @reports=Order.find(:all,:select=>"DATE_FORMAT(a.created_at,'%m/%d/%Y') as used_date,a.*,b.*,c.*",:joins=>"as a , ecommerce_coupons as b , ecommerce_coupons_studios as c" ,:conditions=>" a.ecommerce_coupon_id=#{params[:id]} and a.ecommerce_coupon_id!=0 and a.ecommerce_coupon_id=b.id and b.id=c.ecommerce_coupon_id",:group =>"a.order_number")
    @cpnno=EcommerceCoupon.find(params[:id])
    end
  end

  def studio_coupon_used_details
    if(params[:id]!='' && params[:id]!=nil)
    @reports=Order.find(:all,:select=>"DATE_FORMAT(a.created_at,'%m/%d/%Y') as used_date,a.*,b.*,c.*",:joins=>"as a , ecommerce_coupons as b , ecommerce_coupons_studios as c" ,:conditions=>" a.ecommerce_coupon_id=#{params[:id]} and a.ecommerce_coupon_id!=0 and a.ecommerce_coupon_id=b.id and b.id=c.ecommerce_coupon_id",:group =>"a.order_number")
    @cpnno=EcommerceCoupon.find(params[:id])
    end
  end

  #studio owner studios
  def new_ecommerce_studiocoupon
    @ecoupon=EcommerceCoupon.new()
    #if(session[:franchise]!='' && session[:franchise]=nil)
      @studios=HmmStudio.find(:all,:conditions=>"studio_groupid=#{session[:franchise]}")
    #end
  end

  def  delete_coupon
    if(params[:id]!='' && params[:id]!=nil)
      @ecoupon=EcommerceCoupon.find(params[:id])
      @ecoupon['status']='inactive'
      if(@ecoupon.save)
        flash[:notice] = 'Ecommerce Coupon was successfully deleted.'
        if(session[:franchise])
        redirect_to :action => 'list_studiocoupons'
        else
        redirect_to :action => 'list_coupons'
      end
    end
  end
  end

  def validate_coupon
    color = 'red'
   cpnnum = params[:coupon_id]
   user = EcommerceCoupon.count(:all, :conditions => "coupon_id='#{cpnnum}'")
   if user > 0
     message = 'Coupon Number Is Already Exists'
     @valid_username = false
   else
     message = 'Coupon Number Is Available'
     color = 'green'
     @valid_username=true
   end
   @message = "<b style='color:#{color}'>#{message}</b>"
    render :partial=>'message' , :layout => false
  end



end