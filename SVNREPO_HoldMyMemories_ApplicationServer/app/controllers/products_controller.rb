class ProductsController < ApplicationController
  layout "admin"
  helper :sort
  include SortHelper
  require 'will_paginate'
  def index
    list
    render :action => 'list'
  end

  before_filter :authenticate_admin, :only => [:manage_studio_adminsalestax, :manage_hmm_adminsalestax,:default_shipping]
  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to '/account/login'
      return false
    end
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
    :redirect_to => { :action => :list }

  def list
    #@product_pages, @products = paginate :products, :per_page => 10
    if(params[:id])
      id=params[:id]
    else
      id=0
    end

    @ptotcount=Size.count(:all,:conditions=>"studio_id=#{id}")

    @pcount=Size.count(:all,:conditions=>"studio_id=#{id} and default_size='1'")

    if(@pcount==0)
      @pdetcount=Size.count(:all,:conditions=>"studio_id=#{id}")
      if(@pdetcount>0)
        @pdet=Size.find(:first,:conditions=>"studio_id=#{id}",:order=>"id asc")
        @products_update = Size.find(@pdet.id)
        @products_update.default_size=1
        @products_update.save
      end
    end

    @products=Size.find(:all,:conditions=>"studio_id=#{id}")
  end

  def pricelist_company
    #@product_pages, @products = paginate :products, :per_page => 10
    @pcount=Size.count(:all,:conditions=>"studio_type='company' and studio_id='#{session[:store_id]}' and default_size='1'")

    if(@pcount==0)
      @pdetcount=Size.count(:all,:conditions=>"studio_id=#{session[:store_id]}")
      if(@pdetcount>0)
        @pdet=Size.find(:first,:conditions=>"studio_type='company' and studio_id='#{session[:store_id]}'",:order=>"id asc")
        @products_update = Size.find(@pdet.id)
        @products_update.default_size=1
        @products_update.save
      end
    end

    @products=Size.find(:all,:conditions=>"studio_type='company' and studio_id='#{session[:store_id]}'")

  end

  def edit_hmm_price
    @hmmproduct=Size.find(:all,:conditions => "studio_type='hmm'")
  end

  def update_hmm_price

    @find_products = Size.find(:all, :conditions => "studio_type='#{params[:id]}'")
    i=0
    for m in @find_products
      @products_update = Size.find(params[:product_id][i])
      @products_update.price=params[:price][i]
      @products_update.save
      i=i+1
    end
    flash[:notice1] = 'Prices was successfully updated.'
    redirect_to :action => 'edit_hmm_price'
  end


  def edit_company_price
    @hmmproduct=Size.find(:all,:conditions => "studio_type='company' and store_id='#{session[:store_id]}'")
  end

  def update_company_price

    @find_products = Size.find(:all, :conditions => "studio_id='#{session[:store_id]}'")
    i=0
    for m in @find_products
      @products_update = Studio.find(params[:product_id][i])
      @products_update.price=params[:price][i]
      @products_update.save
      i=i+1
    end
    flash[:notice1] = 'Prices was successfully updated.'
    redirect_to :action => 'edit_company_price'
  end

  def show
    @product = Studio.find(params[:id])
  end

  def show_company
    @product = Studio.find(params[:id])
  end

  def new
    @product = Size.new
  end

  def create

    if(Float(params[:width])<=20 && Float(params[:width])<=20)

      @size = Size.new()
      @size['name']=params[:name]
      @size['width']=params[:width]
      @size['height']=params[:height]
      @size['dpi']=params[:dpi]
      @size['price']=params[:price]
      @size['studio_id']=params[:store_id]
      if(params[:store_id]=='0')
        ptype='hmm'
      else
        ptype='company'
      end

      @size.studio_type=ptype
      if @size.save
        flash[:notice] = 'New Size & Price was successfully created.'
        redirect_to :action => 'list',:id => params[:store_id]
      else
        render :action => 'new'
      end

    else
      flash[:notice] = 'Height & Width should be in inches and not more than 20'
      redirect_to :action => 'new'
    end


  end

  def new_company
    @product = Size.new
  end

  def create_company
    if(Float(params[:width])<=20 && Float(params[:width])<=20)
      @product = Size.new()
      @product.studio_type='company'
      @product.name=params[:name]
      @product.width=params[:width]
      @product.height=params[:height]
      @product.dpi=params[:dpi]
      @product.price=params[:price]
      @product.studio_id=session[:store_id]

      if @product.save
        flash[:notice] = 'Product was successfully created.'
        redirect_to :action => 'pricelist_company'
      else
        render :action => 'new_company'
      end

    else
      flash[:notice] = 'Height & Width should be in inches and not more than 20'
      redirect_to :action => 'new_company'
    end

  end

  def edit
    @product = Size.find(params[:id])
  end

  def edit_company
    @product = Size.find(params[:id])
  end

  def update_company
    if(Float(params[:width])<=20 && Float(params[:width])<=20)
      @product =Size.find(params[:id])
      @product.name=params[:name]
      @product.studio_type='company'
      @product.width=params[:width]
      @product.height=params[:height]
      @product.dpi=params[:dpi]
      @product.price=params[:price]
      @product.studio_id=session[:store_id]

      if @product.save
        flash[:notice] = 'Product was successfully updated.'
        redirect_to :action => 'pricelist_company'
      else
        render :action => 'edit_company'
      end
    else
      flash[:notice] = 'Height & Width should be in inches and not more than 20'
      redirect_to :action => 'edit_company'
    end
  end

  def update
    if(Float(params[:width])<=20 && Float(params[:width])<=20)
      @size = Size.find(params[:id])
      @size['name']=params[:name]
      @size['width']=params[:width]
      @size['height']=params[:height]
      @size['dpi']=params[:dpi]
      @size['price']=params[:price]
      @size['studio_id']=params[:store_id]
      if(params[:store_id]=='0')
        ptype='hmm'
      else
        ptype='company'
      end

      @size.studio_type=ptype
      if @size.save
        flash[:notice] = 'Size was successfully updated.'
        redirect_to :action => 'list' ,:id => params[:store_id]
      else
        render :action => 'edit'
      end
    else
      flash[:notice] = 'Height & Width should be in inches and not more than 20'
      redirect_to :action => 'edit'
    end
  end

  def destroy
    Size.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def destroy_company
    Size.find(params[:id]).destroy
    redirect_to :action => 'pricelist_company'
  end

  #Shipping Prices
  def shipping_price_list
    @shippingmethod=ShippingMethod.find(:all,:conditions=>"studio_id=0",:order=>"id desc")
  end

  def add_shipprice

    @shipmethod=ShippingMethod.new
    @shipmethod.method_name=params[:ship_method]
    @shipmethod.save

    @last_index= ShippingMethod.find(:first, :order => "id desc")

    j=0
    j=9
    i=0
    until i == Integer(j)
      i=i+1

      @shipprice = ShippingPrice.new
      @shipprice.start_price=params["start_value#{i}"]
      @shipprice.end_price=params["end_value#{i}"]
      @shipprice.ship_price=params["ship_price#{i}"]
      @shipprice.method_id=@last_index['id']
      @shipprice.save

    end

    flash[:notice] = 'Shipping Price was successfully added.'
    redirect_to :action => 'shipping_price_list'

  end

  def edit_shipprice
    @shipname=ShippingMethod.find(params[:id])

    @shipprice=ShippingPrice.find(:all,:conditions=>"method_id=#{params[:id]}")

  end



  def update_shipprice

    @shipname=ShippingMethod.find(params[:id])
    @shipname.method_name=params[:ship_method]
    @shipname.save

    j=0
    j=9
    i=0
    until i == Integer(j)
      i=i+1
      @shipprice=ShippingPrice.find(params["sid#{i}"])
      @shipprice.ship_price=params["ship_price#{i}"]
      @shipprice.save
    end
    flash[:notice] = 'Shipping Price was successfully updated.'
    redirect_to :action => 'shipping_price_list'

  end

  def destroy_shipprice

    ShippingMethod.find(params[:id]).destroy
    @ship=ShippingPrice.find(:all , :conditions=>"method_id=#{params[:id]}")
    for k in @ship
      ShippingPrice.find(k.id).destroy
    end

    flash[:notice] = 'Shipping Price was successfully deleted.'
    redirect_to :action => 'shipping_price_list'
  end

  # studio group shipping prices
  def shipping_price_list_group
    @shippingmethod=ShippingMethod.find(:all,:conditions=>"studio_id=#{session[:store_id]}",:order=>"id desc")
  end

  def add_shipprice_group

    @shipmethod=ShippingMethod.new
    @shipmethod.studio_id=session[:store_id]
    @shipmethod.method_name=params[:ship_method]
    @shipmethod.save

    @last_index= ShippingMethod.find(:first, :order => "id desc")

    j=0
    j=9
    i=0
    until i == Integer(j)
      i=i+1

      @shipprice = ShippingPrice.new
      @shipprice.start_price=params["start_value#{i}"]
      @shipprice.end_price=params["end_value#{i}"]
      @shipprice.ship_price=params["ship_price#{i}"]
      @shipprice.method_id=@last_index['id']
      @shipprice.save

    end

    flash[:notice] = 'Shipping Price was successfully added.'
    redirect_to :action => 'shipping_price_list_group'

  end

  def edit_shipprice_group
    @shipname=ShippingMethod.find(params[:id])

    @shipprice=ShippingPrice.find(:all,:conditions=>"method_id=#{params[:id]}")

  end



  def update_shipprice_group

    @shipname=ShippingMethod.find(params[:id])
    @shipname.method_name=params[:ship_method]
    @shipname.save

    j=0
    j=9
    i=0
    until i == Integer(j)
      i=i+1
      @shipprice=ShippingPrice.find(params["sid#{i}"])
      @shipprice.ship_price=params["ship_price#{i}"]
      @shipprice.save
    end
    flash[:notice] = 'Shipping Price was successfully updated.'
    redirect_to :action => 'shipping_price_list_group'

  end

  def destroy_shipprice_group

    ShippingMethod.find(params[:id]).destroy
    @ship=ShippingPrice.find(:all , :conditions=>"method_id=#{params[:id]}")
    for k in @ship
      ShippingPrice.find(k.id).destroy
    end

    flash[:notice] = 'Shipping Price was successfully deleted.'
    redirect_to :action => 'shipping_price_list_group'
  end




  def set_default

    if(params[:sid])
      studioid=params[:sid]
    else
      studioid=0
    end

    sql = ActiveRecord::Base.connection();
    @temp_access_arr = sql.execute("update sizes set default_size='0' where studio_id='#{studioid}'");
    @defsize = sql.execute("update sizes set default_size='1' where studio_id='#{studioid}' and id='#{params[:id]}'");
    sql.commit_db_transaction;
    flash[:notice] = 'Default Size & Price was successfully updated.'
    redirect_to :action => 'list' ,:id=> studioid
  end

  def set_default_studio

    if(params[:sid])
      studioid=params[:sid]
    else
      studioid=0
    end

    sql = ActiveRecord::Base.connection();
    @temp_access_arr = sql.execute("update sizes set default_size='0' where studio_id='#{studioid}'");
    @defsize = sql.execute("update sizes set default_size='1' where studio_id='#{studioid}' and id='#{params[:id]}'");
    sql.commit_db_transaction;
    flash[:notice] = 'Default Size & Price was successfully updated.'
    redirect_to :action => 'pricelist_company'
  end

  def manage_hmm_adminsalestax
    sort_init 'state'
    sort_update
    if( params[:sort_key] == nil )
      if(session[:sort_order]== nil)
        sort = "state desc"
      else
        sort = "state asc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end
    
    #@hmmstudios=HmmStudio.find(:first,:conditions=>"studio_groupid=1")
    @hmm_sales_tax = Configuration.find(:first,:conditions =>"configuration_option='HMM_SALES_TAX'")
    # @states= StateSalestax.paginate :page => params[:page], :per_page => "20"
    #@statessalestax=StateSalestax.find(:all, :order => 'state ASC' )
    if params[:state] && params[:state]!=''
      cond = "and states.state LIKE '%#{params[:state]}%'"
    else
      cond = ''
    end
    if params[:tax_applicable] && params[:tax_applicable]!=''
      params[:tax_applicable] == 'Yes' ? @yes = "selected" : @no = "selected"
      cond1 = "and state_salestaxes.tax_applicable = '#{params[:tax_applicable]}'"
    else
      cond1 = ''
    end
    @states =StateSalestax.paginate :select => "state_salestaxes.*,states.state",:per_page => 20, :page => params[:page],:conditions=>"order_from='hmm' #{cond} #{cond1}", :joins =>" LEFT JOIN states
ON state_salestaxes.state_id=states.id", :order => sort
  end

  def manage_studio_adminsalestax
    sort_init 'state'
    sort_update
    if( params[:sort_key] == nil )
      if(session[:sort_order]== nil)
        sort = "state desc"
      else
        sort = "state asc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end
    #@hmmstudios=HmmStudio.find(:first,:conditions=>"studio_groupid=1")
    @hmm_sales_tax = Configuration.find(:first,:conditions =>"configuration_option='HMM_SALES_TAX'")
    # @states= StateSalestax.paginate :page => params[:page], :per_page => "20"
    #@statessalestax=StateSalestax.find(:all, :order => 'state ASC' )
    if params[:state] && params[:state]!=''
      cond = "and states.state LIKE '%#{params[:state]}%'"
    else
      cond = ''
    end
    if params[:tax_applicable] && params[:tax_applicable]!=''
      params[:tax_applicable] == 'Yes' ? @yes = "selected" : @no = "selected"
      cond1 = "and state_salestaxes.tax_applicable = '#{params[:tax_applicable]}'"
    else
      cond1 = ''
    end
    @states =StateSalestax.paginate :select => "state_salestaxes.*,states.state",:per_page => 20, :page => params[:page],:conditions=> "order_from='others' #{cond} #{cond1}", :joins =>" LEFT JOIN states
ON state_salestaxes.state_id=states.id", :order => sort
  end

  def update_salestax
    if(params[:tax_applicable]=="Yes")
      StateSalestax.update(params[:id], :tax_rate=>"#{params[:tax_rate]}",:tax_applicable=>"#{params[:tax_applicable]}")
    else
      StateSalestax.update(params[:id], :tax_rate=>"0.00",:tax_applicable=>"#{params[:tax_applicable]}")
    end
    flash[:adminnotice]='Admin Sales Tax Updated'
    if(params[:order_from]=="hmm")
      redirect_to '/products/manage_hmm_adminsalestax'
    else
      redirect_to '/products/manage_studio_adminsalestax'
    end
  end

  def update_adminsalestax

    Configuration.update(params[:id], :configuration_value=>"#{params[:tax_rate]}")
    flash[:adminnotice]='Admin Sales Tax Updated'
    redirect_to '/products/manage_adminsalestax'

  end


  #Set Sales Tax for Studio
  def manage_studiosalestax
    @hmmstudios=HmmStudio.find(session[:store_id])
  end

  def update_studiosalestax
    @hmmstudio=HmmStudio.find(session[:store_id])
    @hmmstudio['tax_rate']=Float(params[:tax_rate]).round(2)
    @hmmstudio['print_order']=params[:print_order]
    @hmmstudio.save

    flash[:salesnotice]='Studio Sales Tax Updated'
    redirect_to '/products/manage_studiosalestax'


  end

  def default_shipping
    @config=Configuration.find(:first,:conditions=>"configuration_option='DEFAULT_SHIPPING'")
  end

  def update_default_shipping
    @config=Configuration.find(:first,:conditions=>"configuration_option='DEFAULT_SHIPPING'")
    @config['configuration_value']=params[:ship_price]
    if(@config.save)
      flash[:shipnotice]='Default Shipping Price Updated'
      redirect_to '/products/default_shipping'
    end
  end

end