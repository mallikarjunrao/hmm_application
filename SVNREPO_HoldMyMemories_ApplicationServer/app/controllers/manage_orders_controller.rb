class ManageOrdersController < ApplicationController

  require 'money'
  layout "admin"
  helper :sort
  include SortHelper
  require 'will_paginate'


  before_filter :authenticate_admin, :only => [:details,:view,:update_status,:delete,:orders_report,:orders_report_excel]
  before_filter :authenticate_emp, :only => [:studio_orders_details,:studio_order_view,:update_studio_order_status,:delete_studio_order,:market_orders_report,:order_report_excel,:market_orders_report_excel]

  def authenticate_emp
    if(session[:employe]==nil && session[:manager]==nil)
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "/account/employe_login"
      return false
    end
  end

  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to :action => '/account/login'
      return false
    end
  end

 def details
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

   if(params[:store_id]!=nil && params[:store_id]!='')
     storecond=params[:store_id]
   else
     storecond=0
   end

    if(params[:order_number]!=nil && params[:order_number]!='')
      ordcond=" and order_number='#{params[:order_number]}'"
    end

    if(params[:status]!=nil && params[:status]!='')
      statuscond=" and orders_status='#{params[:status]}'"
    end

    if(params[:order_number]== nil && params[:status]== nil)
      #session[:search_cond]=""
    else
      searchcond="#{ordcond} #{statuscond}"
    end


    @ordcnt=Order.count(:all,:conditions=>"status='active' and process_studio_id=#{storecond} #{searchcond}")

    @order_details = Order.paginate :per_page => 10, :page => params[:page],:order =>sort,:conditions=>"status='active' and process_studio_id=#{storecond} #{searchcond}"
  end

  def studio_orders_details
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


    if(params[:order_number]!=nil && params[:order_number]!='')
      ordcond=" and order_number='#{params[:order_number]}'"
    end

    if(params[:status]!=nil  && params[:status]!='')
      statuscond=" and orders_status='#{params[:status]}'"
    end

    if(params[:order_number]== nil && params[:status]== nil)
      #session[:search_cond]=""
    else
      searchcond="#{ordcond} #{statuscond}"
    end

    @ordcnt=Order.count(:all,:conditions=>"status='active' and process_studio_id=#{session[:store_id]} #{searchcond}")

    @order_details = Order.paginate :per_page => 10,:page => params[:page],:order =>sort, :conditions=>"status='active' and process_studio_id=#{session[:store_id]} #{searchcond}"
  end

  def studio_orders_report
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


    if(params[:order_number]!=nil && params[:order_number]!='')
      ordcond=" and order_number='#{params[:order_number]}'"
    end

    if(params[:status]!=nil  && params[:status]!='')
      statuscond=" and orders_status='#{params[:status]}'"
    end

    if(params[:order_number]== nil && params[:status]== nil)
      #session[:search_cond]=""
    else
      searchcond="#{ordcond} #{statuscond}"
    end

    @ordcnt=Order.count(:all, :joins => "as a, hmm_studiogroups as b, hmm_studios as c", :conditions=>"a.status='active' and b.id=c.studio_groupid and b.id='#{session[:franchise]}' and a.studio_id=c.id #{searchcond}")

    @order_details = Order.paginate :select => "a.*", :joins => "as a, hmm_studiogroups as b, hmm_studios as c", :per_page => 10,:page => params[:page],:order =>sort, :conditions=>" b.id=c.studio_groupid and b.id='#{session[:franchise]}' and a.studio_id=c.id  #{searchcond}"
  end

  def view
    @get_content_url=ContentPath.find(:first, :conditions => "status='active'")
    @proxyurl=@get_content_url['content_path']
    @order_details=Order.find(params[:id])
    @order_products = OrderProduct.find(:all,:conditions=>"order_id='#{params[:id]}'",:order => "order_num asc")
    if(@order_details.studio_id!=0)
      @studio_details=HmmStudio.find(@order_details.studio_id)
    end
  end

  def print_view
    @get_content_url=ContentPath.find(:first, :conditions => "status='active'")
    @proxyurl=@get_content_url['content_path']
    @order_details=Order.find(params[:id])
    @order_products = OrderProduct.find(:all,:conditions=>"order_id='#{params[:id]}'",:order => "order_num asc")
    if(@order_details.studio_id!=0)
      @studio_details=HmmStudio.find(@order_details.studio_id)
    end
    render(:layout => false)
  end

  def studio_order_view
    @get_content_url=ContentPath.find(:first, :conditions => "status='inactive'")
    @proxyurl=@get_content_url['content_path']
    @order_details=Order.find(params[:id])
    @order_products = OrderProduct.find(:all,:conditions=>"order_id='#{params[:id]}'",:order => "order_num asc")
    if(@order_details.studio_id!=0)
      @studio_details=HmmStudio.find(@order_details.studio_id)
    end
  end

  def print_studio_order_view
    @get_content_url=ContentPath.find(:first, :conditions => "status='active'")
    @proxyurl=@get_content_url['content_path']
    @order_details=Order.find(params[:id])
    @order_products = OrderProduct.find(:all,:conditions=>"order_id='#{params[:id]}'",:order => "order_num asc")
    if(@order_details.studio_id!=0)
      @studio_details=HmmStudio.find(@order_details.studio_id)
    end
    render(:layout => false)
  end

  def update_status
    @order_details=Order.find(params[:id])
    @order_details.orders_status=params[:order_status]
    @order_details.save
    flash[:notice] = 'Order Status was successfully updated.'
    redirect_to :action => 'view' , :id => params[:id]
  end

  def update_studio_order_status
    @order_details=Order.find(params[:id])
    @order_details.orders_status=params[:order_status]
    @order_details.save
    flash[:notice] = 'Order Status was successfully updated.'
    redirect_to :action => 'studio_order_view' , :id => params[:id]
  end

  def delete

    #Order.find(params[:id]).destroy
    #@ordprods=OrderProduct.find(:all,:conditions=>"order_id='#{params[:id]}'")
    #for k in @ordprods
      #OrderProduct.find(k.id).destroy
    #end
    @ord=Order.find(params[:id])
    @ord['status']='inactive'
    @ord.save
    flash[:notice] = 'Order was successfully deleted.'
    redirect_to :action => 'details'
  end

  def delete_studio_order
    #Order.find(params[:id]).destroy
    #@ordprods=OrderProduct.find(:all,:conditions=>"order_id='#{params[:id]}'")
    #for k in @ordprods
     # OrderProduct.find(k.id).destroy
    #end
    @ord=Order.find(params[:id])
    @ord['status']='inactive'
    @ord.save
    flash[:notice] = 'Order was successfully deleted.'
    if(session[:franchise])
      redirect_to :action => 'studio_orders_report'
    else
      redirect_to :action => 'studio_orders_details'
    end

  end

#  def orders_report
#
#    sort_init 'id'
#    sort_update
#    srk=params[:sort_key]
#    sort="#{srk}  #{params[:sort_order]}"
#
#    if( srk==nil)
#      sort="id  desc"
#    end
#
#    if (params[:from_bdate]!=nil && params[:to_bdate] !=nil)
#
#      from_yr=params[:from_bdate]['start_year1909ordermonthdayyear(1i)']
#      from_mon=params[:from_bdate]['start_year1909ordermonthdayyear(2i)']
#      from_date=params[:from_bdate]['start_year1909ordermonthdayyear(3i)']
#
#      fromdate=from_yr+'-'+from_mon+'-'+from_date
#
#      to_yr=params[:to_bdate]['start_year1909ordermonthdayyear(1i)']
#      to_mon=params[:to_bdate]['start_year1909ordermonthdayyear(2i)']
#      to_date=params[:to_bdate]['start_year1909ordermonthdayyear(3i)']
#
#      todate=to_yr+'-'+to_mon+'-'+to_date
#
#      params[:from_bdate]['start_year1909ordermonthdayyear(1i)']
#      condition= "and created_at between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
#    end
#
#    @ordcnt=Order.count(:all,:conditions => "status='active' and process_studio_id=0 #{condition}")
#
#    @order_details = Order.paginate :per_page => 25, :page => params[:page], :conditions => "status='active' and process_studio_id=0 #{condition} ", :order => sort
#
#  end


  #Split ORDErs report
  def orders_report

    sort_init 'id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    unless params[:c].blank?
      session[:condition1]=''
    end


    if( srk==nil)
      sort="id  desc"
    end



    if (params[:fyy]!=nil && params[:fmm] !=nil && params[:fdd] !=nil && params[:tyy] !=nil && params[:tmm] !=nil && params[:tdd] !=nil)


     from_yr=params[:fyy]
     from_mon=params[:fmm]
     from_date=params[:fdd]

      fromdate="#{from_yr}-#{from_mon}-#{from_date}"

      to_yr=params[:tyy]
      to_mon=params[:tmm]
      to_date=params[:tdd]


      todate="#{to_yr}-#{to_mon}-#{to_date}"

      session[:condition1]= "and created_at  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "

    end

    @ordcnt=Order.count(:all,:conditions => "status='active' #{session[:condition1]}")

    @order_details = Order.paginate :per_page => 25, :page => params[:page], :conditions => "status='active' #{session[:condition1]} ", :order => sort

  end

  def orders_report_excel

    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="orders_report.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end

    sort_init 'id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="id  desc"
    end



    if (params[:fyy]!=nil && params[:fmm] !=nil && params[:fdd] !=nil && params[:tyy] !=nil && params[:tmm] !=nil && params[:tdd] !=nil)


     from_yr=params[:fyy]
     from_mon=params[:fmm]
     from_date=params[:fdd]

      fromdate="#{from_yr}-#{from_mon}-#{from_date}"

      to_yr=params[:tyy]
      to_mon=params[:tmm]
      to_date=params[:tdd]


      todate="#{to_yr}-#{to_mon}-#{to_date}"

      session[:condition1]= "and created_at  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
    end

    @ordcnt=Order.count(:all,:conditions => "status='active' #{session[:condition1]}")

    @order_details = Order.paginate :per_page => 25, :page => params[:page], :conditions => "status='active' #{session[:condition1]} ", :order => sort

    render :layout => false
  end














  def orders_report_all

    sort_init 'id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="id  desc"
    end

#    if (params[:from_bdate]!=nil && params[:to_bdate] !=nil)
#
#      from_yr=params[:from_bdate]['start_year1909ordermonthdayyear(1i)']
#      from_mon=params[:from_bdate]['start_year1909ordermonthdayyear(2i)']
#      from_date=params[:from_bdate]['start_year1909ordermonthdayyear(3i)']
#
#      fromdate=from_yr+'-'+from_mon+'-'+from_date
#
#      to_yr=params[:to_bdate]['start_year1909ordermonthdayyear(1i)']
#      to_mon=params[:to_bdate]['start_year1909ordermonthdayyear(2i)']
#      to_date=params[:to_bdate]['start_year1909ordermonthdayyear(3i)']
#
#      todate=to_yr+'-'+to_mon+'-'+to_date
#
#      params[:from_bdate]['start_year1909ordermonthdayyear(1i)']
#      condition= "and created_at between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
#    end

    condition=" and 1=1"

    @ordcnt=Order.count(:all,:conditions => "status='active' #{condition}")

    @order_details = Order.paginate :per_page => 25, :page => params[:page], :conditions => "status='active' #{condition} ", :order => sort  ,:group =>"order_group_id"

  end

  def view_order
    @get_content_url=ContentPath.find(:first, :conditions => "status='active'")
    @proxyurl=@get_content_url['content_path']

    #HMM ORDER
    @order_details_count=Order.count(:all,:conditions=>"order_group_id=#{params[:gid]} and process_studio_id=0")
    if(@order_details_count>0)
    @order_details=Order.find(:first,:conditions=>"order_group_id=#{params[:gid]} and process_studio_id=0")
    #@order_products = OrderProduct.find(:all,:conditions=>"order_id='#{@order_details.id}'",:order => "order_num asc")

    @list_studios_count=OrderProduct.count(:all,:joins=>"LEFT JOIN user_contents on (order_products.user_content_id=user_contents.id)
    LEFT JOIN galleries on (user_contents.gallery_id=galleries.id)
    LEFT JOIN sub_chapters on (galleries.subchapter_id=sub_chapters.id and sub_chapters.store_id is NULL)
    ",
    :conditions=>"order_products.order_id='#{@order_details.id}'")

    if(@list_studios_count>0)
    @list_studios=OrderProduct.find(:all,:joins=>"LEFT JOIN user_contents on (order_products.user_content_id=user_contents.id)
    LEFT JOIN galleries on (user_contents.gallery_id=galleries.id)
    LEFT JOIN sub_chapters on (galleries.subchapter_id=sub_chapters.id and sub_chapters.store_id is NULL)
    ",:select=>"order_products.id as order_product_id",
    :conditions=>"order_products.order_id='#{@order_details.id}'")
    end

#    @list_studios3_count=OrderProduct.count(:all,:joins=>"LEFT JOIN user_contents on (order_products.user_content_id=user_contents.id)
#    LEFT JOIN galleries on (user_contents.gallery_id=galleries.id)
#    LEFT JOIN sub_chapters on (galleries.subchapter_id=sub_chapters.id)
#    LEFT JOIN hmm_studios  on (sub_chapters.store_id=hmm_studios.id and sub_chapters.store_id!='')
#    ",
#    :conditions=>"order_products.order_id='#{@order_details.id}'",
#    :group=>"hmm_studios.id")
#
#    if(@list_studios3_count>0)
    @list_studios3=OrderProduct.find(:all,:joins=>"LEFT JOIN user_contents on (order_products.user_content_id=user_contents.id)
    LEFT JOIN galleries on (user_contents.gallery_id=galleries.id)
    LEFT JOIN sub_chapters on (galleries.subchapter_id=sub_chapters.id)
    INNER JOIN hmm_studios  on (sub_chapters.store_id=hmm_studios.id)
    ",:select=>"hmm_studios.*",
    :conditions=>"order_products.order_id='#{@order_details.id}'",
    :group=>"hmm_studios.id")
#    end


    if(@order_details.studio_id!=0)
      @studio_details=HmmStudio.find(@order_details.studio_id)
    end


    #STUDIO ORDER
    @order_details_count2=Order.count(:all,:conditions=>"order_group_id=#{params[:gid]} and process_studio_id!=0")
    if(@order_details_count2>0)
    @order_details2=Order.find(:first,:conditions=>"order_group_id=#{params[:gid]} and process_studio_id!=0")
   # @order_products2 = OrderProduct.find(:all,:conditions=>"order_id='#{@order_details2.id}'",:order => "order_num asc")

   @list_studios2=OrderProduct.find(:all,:joins=>"LEFT JOIN user_contents on (order_products.user_content_id=user_contents.id)
    LEFT JOIN galleries on (user_contents.gallery_id=galleries.id)
    LEFT JOIN sub_chapters on (galleries.subchapter_id=sub_chapters.id)
    LEFT JOIN hmm_studios  on (sub_chapters.store_id=hmm_studios.id)
    ",:select=>"hmm_studios.*",
    :conditions=>"order_products.order_id='#{@order_details2.id}'",:group=>"hmm_studios.id"
    )

    if(@order_details2.studio_id!=0)
      @studio_details2=HmmStudio.find(@order_details.studio_id)
    end

    end
    end


  end


#market manger login order reports
  def market_orders_report

    sort_init 'id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    unless params[:c].blank?
      session[:condition1]=''
    end


    if( srk==nil)
      sort="id  desc"
    end



    if (params[:fyy]!=nil && params[:fmm] !=nil && params[:fdd] !=nil && params[:tyy] !=nil && params[:tmm] !=nil && params[:tdd] !=nil)


     from_yr=params[:fyy]
     from_mon=params[:fmm]
     from_date=params[:fdd]

      fromdate="#{from_yr}-#{from_mon}-#{from_date}"

      to_yr=params[:tyy]
      to_mon=params[:tmm]
      to_date=params[:tdd]


      todate="#{to_yr}-#{to_mon}-#{to_date}"

      conditions= "and created_at  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "

    end

    @market_managers=MarketManager.find(:all,:select=>"b.branch_id", :joins=>"as a , manager_branches as b ", :conditions=>"a.id=#{session[:manager]} and a.id=b.manager_id")

    if(@market_managers.length>0)
       a = Array.new

      for @studio in @market_managers
        a.push(@studio.branch_id)
      end

      @list_studios=a.join(",")

    else
      @list_studios=99999
    end

    @ordcnt=Order.count(:all,:conditions => " process_studio_id IN (#{@list_studios}) and status='active' #{conditions}")

    @order_details = Order.paginate :per_page => 25, :page => params[:page], :conditions => " process_studio_id IN (#{@list_studios}) and status='active' #{conditions} ", :order => sort

  end

  def market_orders_report_excel

    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="orders_report.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end

    sort_init 'id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="id  desc"
    end



   if (params[:fdt]!="--" && params[:tdt] !="--")
      conditions= "and created_at  between '#{params[:fdt]} 00:00:00' and '#{params[:tdt]} 23:59:59' "
    end

    @market_managers=MarketManager.find(:all,:select=>"b.branch_id", :joins=>"as a , manager_branches as b ", :conditions=>"a.id=#{session[:manager]} and a.id=b.manager_id")

    if(@market_managers.length>0)
       a = Array.new

      for @studio in @market_managers
        a.push(@studio.branch_id)
      end

      @list_studios=a.join(",")

    else
      @list_studios=99999
    end

    @ordcnt=Order.count(:all,:conditions => " process_studio_id IN (#{@list_studios}) and status='active' #{conditions}")

    @order_details = Order.paginate :per_page => 10000, :page => params[:page], :conditions => " process_studio_id IN (#{@list_studios}) and status='active' #{conditions} ", :order => sort

    render :layout => false
  end



end