class ManageMobileStudiosController < ApplicationController
  layout "admin"
  include SortHelper
  include SortHelper
  helper :sort
  require 'will_paginate'


  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
    :redirect_to => { :action => :list }
  before_filter :authenticate_admin, :only => [ :show_studios_app,:reject_app,:live_app,:approve_app,:view_studio_sample_portfolios,:view_booking_info,:view_studio_specials,:view_aboutus,:show_app,:ml_app]
  before_filter :authenticate_emp, :only => [ :manage_aboutus,:manage_studio_logo,:manage_studio_specials,:add_studio_specials,:edit_studio_specials,:delete_studio_specials,:manage_studio_portfolios,:add_studio_portfolio,:edit_studio_portfolio,:delete_studio_portfolio,:view_studio_portfolio,:delete_portfolio_sample,:home,:manage_app_name,:manage_app_store_description]

  # before_filter :authenticate_admin, :only => [ :list, :new, :edit_admin]

  def authenticate_emp
    unless session[:employe]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "/account/employe_login"
      return false
    end
  end

  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "/account/login"
      return false
    end
  end

  def manage_aboutus
    @employee = EmployeAccount.find(session[:employe])
    @studio=IphoneAboutusStudioLogo.find_by_studio_id(@employee.store_id)
  end

  def manage_studio_logo
    @employee = EmployeAccount.find(session[:employe])
    @studio=IphoneAboutusStudioLogo.find_by_studio_id(@employee.store_id)
  end



  def manage_studio_specials
    @employee = EmployeAccount.find(session[:employe])
    @special_count=DiscountCoupon.count(:conditions=>"studio_id=#{session[:store_id]} and status='active'" )
    @specials=DiscountCoupon.find(:all,:select=>"coupon_title", :conditions=>"studio_id=#{session[:store_id]} and status='active'")
    @studio_specials=StudioSpecial.paginate :per_page => 10, :page => params[:page], :conditions => "studio_id=#{@employee.store_id}" , :order => "id desc"
  end

  def add_studio_specials

    if(params[:sub]!=nil && params[:sub]!='')
      @employee = EmployeAccount.find(session[:employe])
      @det=StudioSpecial.new()
      @det['studio_id']=@employee.store_id
      @det['title']=params[:title]
      description =params[:description]
      #description.gsub!(/\n/, '<br />')
      @det.description=description
      if(@det.save)
        flash[:notice]="Studio Specials Added Successfully"
        redirect_to "/manage_mobile_studios/manage_studio_specials"
      end

    end
  end

  def edit_studio_specials
    if(params[:id]!='' && params[:id]!=nil)
      @employee = EmployeAccount.find(session[:employe])
      @studio=StudioSpecial.find(params[:id])

      if(params[:sub]!=nil && params[:sub]!='')

        @det=StudioSpecial.find(params[:id])
        @det['studio_id']=@employee.store_id
        @det['title']=params[:title]
        description =params[:description]
        description.gsub!(/\n/, '<br />')
        @det['description']=description
        if(@det.save)
          flash[:notice]="Studio Specials Updated Successfully"
          redirect_to "/manage_mobile_studios/manage_studio_specials"
        end

      end
    end
  end

  def delete_studio_specials
    StudioSpecial.find(params[:id]).destroy
    flash[:notice]="Studio Specials Deleted Successfully"
    redirect_to "/manage_mobile_studios/manage_studio_specials"
  end

  def manage_studio_portfolios
    @employee = EmployeAccount.find(session[:employe])
    @studio_portfolios=StudioPortfolio.paginate :per_page => 9, :page => params[:page], :conditions => "studio_id=#{@employee.store_id}" ,:group =>"category_name", :order => "id desc"
  end

  def add_studio_portfolio
    @employee = EmployeAccount.find(session[:employe])
  end

  def edit_studio_portfolio
    if(params[:id]!='' && params[:id]!=nil)
      @employee = EmployeAccount.find(session[:employe])
      @studio=StudioPortfolio.find(params[:id])
    end
  end

  def delete_studio_portfolio
    portfolio_deletes=StudioPortfolio.find(:all,:select=>"id",:conditions=>"category_name='#{params[:name]}'")
    for portfolio_delete in portfolio_deletes
      StudioPortfolio.find(portfolio_delete.id).destroy
    end
    flash[:notice]="Studio Portfolio Deleted Successfully"
    redirect_to "/manage_mobile_studios/manage_studio_portfolios"
  end

  def view_studio_portfolio
    if(params[:id]!='' && params[:id]!=nil)
      @studio=PortfolioSample.paginate :per_page => 9, :page => params[:page], :conditions => "studio_portfolio_id=#{params[:id]}" , :order => "id desc"
    end
  end
  def view_studio_sample_portfolio
    if(params[:name]!='' && params[:name]!=nil)
      @studio=StudioPortfolio.paginate :per_page => 9, :page => params[:page], :conditions => "category_name='#{params[:name]}' and studio_id=#{params[:id]} " , :order => "category_name desc"
      if @studio==nil || @studio.length==0
        redirect_to "/manage_mobile_studios/manage_studio_portfolios"
      end
    end
  end

  def delete_portfolio_sample
    StudioPortfolio.find(params[:id]).destroy
    flash[:notice]="Portfolio Sample Deleted Successfully"
    redirect_to "/manage_mobile_studios/view_studio_sample_portfolio/#{session[:store_id]}?name=#{params[:name]}"
  end

  def manage_booking_info
    @employee = EmployeAccount.find(session[:employe])
    @info=BookingInfo.count(:conditions=>"studio_id=#{session[:store_id]}")
    if(@info==0)
      if params[:sub]
        @info = BookingInfo.new()
        @info['studio_id']=@employee.store_id
        @info['phone_no'] = params[:phone_no]
        @info['email'] = params[:email]
        @info['url'] = params[:url]
        flash[:notice]="Booking Info is saved successfully"
        @info.save
      end
    else
      if params[:sub]
        BookingInfo.update(params[:id], :phone_no=>"#{params[:phone_no]}",:url=>"#{params[:url]}",:email=>"#{params[:email]}")
        flash[:notice]="Booking Info is Updated successfully"
      end
    end
    @infos=BookingInfo.find(:first,:conditions=>"studio_id=#{session[:store_id]}")
  end

  def home

    @portfolios=StudioPortfolio.count(:conditions=>"studio_id=#{session[:store_id]}")
    @specials=StudioSpecial.count(:conditions=>"studio_id=#{session[:store_id]}")
    @bookings=BookingInfo.count(:conditions=>"studio_id=#{session[:store_id]}")
    @logos_count=IphoneAboutusStudioLogo.count(:conditions=>"studio_id=#{session[:store_id]} and mobile_studio_logo!='' and mobile_studio_logo!='NULL'")
    @aboutus_count=IphoneAboutusStudioLogo.count(:conditions=>"studio_id=#{session[:store_id]} and aboutus_image!='' and mobile_studio_logo!='NULL'")
    @app_store_description_count=HmmStudio.count(:conditions=>"id=#{session[:store_id]} and app_store_description!='' and app_store_description!='NULL'")
    @app_name_count=HmmStudio.count(:conditions=>"id=#{session[:store_id]} and iphone_app_name!='' and iphone_app_name!='NULL' and iphone_app_full_name!='' and iphone_app_full_name!='NULL'")
    @hmmstudios=HmmStudio.find(:first,:conditions=>"id=#{session[:store_id]}")
    logger.info(session[:store_id])
    logger.info(@logos_count)
    logger.info(@aboutus_count)
  end

  def manage_app_name
    if params[:sub]
      @studio=HmmStudio.find(:first,:conditions=>"id=#{params[:id]}")
      @studio.iphone_app_name=params[:app_name]
      @studio.iphone_app_full_name=params[:iphone_app_full_name]
      @studio.save
      @employee = EmployeAccount.find(session[:employe])
    else
      @employee = EmployeAccount.find(session[:employe])
      @studio=HmmStudio.find_by_id(@employee.store_id)
    end
  end

  def manage_app_store_description
    if params[:sub]
      @studio=HmmStudio.find(:first,:conditions=>"id=#{params[:id]}")
      @studio.app_store_description=params[:app_store_description]
      @studio.save
      @employee = EmployeAccount.find(session[:employe])
    else
      @employee = EmployeAccount.find(session[:employe])
      @studio=HmmStudio.find_by_id(@employee.store_id)
    end
  end

  def view_app_name
    @studio=HmmStudio.find(:first,:conditions=>"id=#{params[:id]}")
  end

  def show_studios_app
    @studios= HmmStudio.find(:all,:conditions=>"status='active'")
    @studioarr = Array.new

    @studioarr1= Array.new
    @registered_date=Array.new

    @stuidodid= Array.new
    @stuidoname= Array.new
    @studio_app_status= Array.new
    @studio_app_store_link= Array.new

    for studio in @studios
      logos=IphoneAboutusStudioLogo.find(:first,:conditions=>"studio_id=#{studio.id} and mobile_studio_logo!=''")
      aboutus=IphoneAboutusStudioLogo.find(:first,:conditions=>"studio_id=#{studio.id} and aboutus_image!=''")
      portfolio=StudioPortfolio.find(:first,:conditions=>"studio_id=#{studio.id}")
      booking=BookingInfo.find(:first,:conditions=>"studio_id=#{studio.id}")
      special=StudioSpecial.find(:first,:conditions=>"studio_id=#{studio.id}")
      app_store_description_count=HmmStudio.count(:conditions=>"id=#{studio.id} and app_store_description!='' and app_store_description!='NULL'")
      app_name_count=HmmStudio.count(:conditions=>"id=#{studio.id} and iphone_app_name!='' and iphone_app_name!='NULL' and iphone_app_full_name!='' and iphone_app_full_name!='NULL'")
      if logos && portfolio && special &&  booking && app_store_description_count > 0  && app_name_count > 0 && aboutus
        @studioarr.push(studio.id)
        registered_dates= [logos.created_at,portfolio.created_at,booking.created_at,special.created_at].max
        @registered_date.push(registered_dates)
      end

    end
    for studio in @studioarr
      @studioarr1= HmmStudio.find(:first,:conditions=>"id=#{studio} and status='active'")
      @stuidodid.push(@studioarr1.id)
      @stuidoname.push(@studioarr1.studio_name)
      @studio_app_store_link.push(@studioarr1.app_store_link)
      @studio_app_status.push(@studioarr1.iphone_app_status)
    end
    logger.info(@stuidodid.inspect)
    logger.info(@stuidoname.inspect)
    logger.info(@studio_app_store_link.inspect)
  end

  def approve_app
    @studio=HmmStudio.find(:first,:conditions=>"id=#{params[:id]}")
    @studio.iphone_app_status="Approved"
    if @studio.save
      Postoffice.deliver_iphone_app_status(@studio.contact_email)
    end
  end

  def reject_app
    @studio=HmmStudio.find(:first,:conditions=>"id=#{params[:id]}")
    if params[:submit]
      if params[:reject_reason]
        @studio.iphone_app_status="Rejected"
        @studio.reject_reason=params[:reject_reason]
        if @studio.save
          Postoffice.deliver_iphone_app_status_reject(@studio.contact_email,@studio.reject_reason)
        end
      end
      redirect_to :action => "show_studios_app"
    end
  end

  def live_app
    if params[:Submit]
      @studio=HmmStudio.find(:first,:conditions=>"id=#{params[:id]}")
      @studio.app_store_link=params[:iphone_live_url]
      @studio.iphone_app_status="Live"
      if @studio.save
        Postoffice.deliver_iphone_app_status_live(@studio.contact_email,@studio.app_store_link)
      end
    end
    redirect_to :action => "show_studios_app"
  end

  def show_app
    @portfolios=StudioPortfolio.count(:conditions=>"studio_id=#{params[:id]}")
    @specials=StudioSpecial.count(:conditions=>"studio_id=#{params[:id]}")
    @bookings=BookingInfo.count(:conditions=>"studio_id=#{params[:id]}")
    @logos_count=IphoneAboutusStudioLogo.count(:conditions=>"studio_id=#{params[:id]} and mobile_studio_logo!='' and mobile_studio_logo!='NULL'")
    @aboutus_count=IphoneAboutusStudioLogo.count(:conditions=>"studio_id=#{params[:id]} and aboutus_image!='' and mobile_studio_logo!='NULL'")
    @app_store_description_count=HmmStudio.count(:conditions=>"id=#{params[:id]} and app_store_description!='' and app_store_description!='NULL'")
    @app_name_count=HmmStudio.count(:conditions=>"id=#{params[:id]} and iphone_app_name!='' and iphone_app_name!='NULL' and iphone_app_full_name!='' and iphone_app_full_name!='NULL'")
    @hmmstudios=HmmStudio.find(:first,:conditions=>"id=#{params[:id]}")
  end
  def view_aboutus
    @studio=IphoneAboutusStudioLogo.find_by_studio_id(params[:id])
  end

  def view_studio_logo
    @studio=IphoneAboutusStudioLogo.find_by_studio_id(params[:id])
  end



  def view_studio_specials
    @special_count=DiscountCoupon.count(:conditions=>"studio_id=#{params[:id]} and status='active'" )
    @specials=DiscountCoupon.find(:all,:select=>"coupon_title", :conditions=>"studio_id=#{params[:id]} and status='active'")
    @studio_specials=StudioSpecial.paginate :per_page => 10, :page => params[:page], :conditions => "studio_id=#{params[:id]}" , :order => "id desc"
  end
  def view_booking_info
    @info=BookingInfo.count(:conditions=>"studio_id=#{params[:id]}")

    @infos=BookingInfo.find(:first,:conditions=>"studio_id=#{params[:id]}")
  end
  def view_studio_portfolios

    @studio_portfolios=StudioPortfolio.paginate :per_page => 9, :page => params[:page], :conditions => "studio_id=#{params[:id]}" ,:group =>"category_name", :order => "id desc"
  end

  def view_studio_sample_portfolios
    if(params[:name]!='' && params[:name]!=nil)
      @studio=StudioPortfolio.paginate :per_page => 9, :page => params[:page], :conditions => "category_name='#{params[:name]}' and studio_id=#{params[:id]} " , :order => "category_name desc"
      if @studio==nil || @studio.length==0
        redirect_to "/manage_mobile_studios/view_studio_portfolios"
      end
    end
  end
  def view_app_store_description
    @studio=HmmStudio.find(:first,:conditions=>"id=#{params[:id]}")
  end


  def ml_app
    sort_init 'a.id'
    sort_update
    srk=params[:sort_key]
    sort="#{srk}  #{params[:sort_order]}"

    if( srk==nil)
      sort="a.id desc"
    end
    if params[:submit]
      cond="and v_user_name like '%#{params[:username]}%'"
    else
      cond=""
    end
    @subs=SubChapter.paginate :per_page => 30, :page => params[:page],:select=>"b.v_user_name,b.v_fname,b.v_lname,b.v_e_mail,b.d_created_date",:joins=>"as a,hmm_users as b",:conditions=>"a.uid=b.id #{cond} and a.client='mliphoneapp'",:group=>"a.id",:order=>sort
  end


end