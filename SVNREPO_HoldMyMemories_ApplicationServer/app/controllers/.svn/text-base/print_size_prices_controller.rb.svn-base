class PrintSizePricesController < ApplicationController
  layout 'admin'
  helper :user_account
  include UserAccountHelper
  before_filter :authenticate_admin, :only => [:list, :add, :delete]
  before_filter :authenticate_emp, :only => [:studio_price_list,:studio_price_add,:studio_price_edit,:studio_price_delete,:studio_set_default_price]
  before_filter :login_franchise_check, :only => [:franchise_list, :franchise_add, :franchise_delete]


  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to :controller => 'account', :action => 'login'
      return false
    end
  end

  def login_franchise_check
    unless session[:franchise]
      flash[:notice] = 'Please Login to Access Franchise Admin Account'
      redirect_to :controller => 'account', :action => 'franchise_login'
      return false
    end
  end

  def authenticate_emp
    unless session[:employe]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to :controller => 'account', :action => 'employe_login'
      return false
    end
  end

  def list
    unless params[:id].blank?
      studio_id = params[:id]
    else
      studio_id = 0
    end
    @prices = PrintSizePrice.find(:all, :joins =>"INNER JOIN print_sizes ON print_size_prices.print_size_id = print_sizes.id LEFT JOIN hmm_studios on print_size_prices.process_studio_id = hmm_studios.id",
      :conditions => "print_size_prices.studio_id=#{studio_id}",:select => "print_size_prices.pricelt72,print_size_prices.quantity,print_size_prices.aspect_ratio,print_size_prices.price as amount,print_size_prices.id as price_id,print_sizes.label,print_sizes.width,print_sizes.height,hmm_studios.studio_branch as processing_studio,print_size_prices.default_size,print_sizes.id as size_id")
  end

  def add
    unless params[:id].blank?
      @studio_id = params[:id]
      @studio_type = 'others'
    else
      @studio_id = 0
      @studio_type = 'hmm'
    end

    unless params[:print_size_price].blank?
      @price = PrintSizePrice.new(params[:print_size_price])
      if @price.valid?
        @price.save
        flash[:notice] = "Successfully added the price"
        redirect_to :action => "list", :id =>params[:id]
      end
    end

    existing_sizes = PrintSizePrice.find(:all,:conditions => "studio_id=#{@studio_id}",:select => "print_size_id")
    temp = Array.new
    for exist in existing_sizes
      temp.push(exist.print_size_id)
    end
    @exclude_sizes = nil
    if temp.length > 0
      @exclude_sizes = temp.join(',')
      @exclude_sizes = "and id not in (#{@exclude_sizes})"
    end

  end

  def edit
    unless params[:studio_id].blank?
      @studio_id = params[:studio_id]
      @studio_type = 'others'
    else
      @studio_id = 0
      @studio_type = 'hmm'
    end

    @price=PrintSizePrice.find(params[:id])
    @size=PrintSize.find(@price.print_size_id)
    if(params[:price]!='' && params[:price]!=nil)
      @price['studio_id']=@studio_id
      @price['studio_type']=@studio_type
      @price['price']=params[:price]
      @price['quantity']=params[:print_size_price][:quantity]
      @price['aspect_ratio']=params[:print_size_price][:aspect_ratio]
      @price['pricelt72']= params[:print_size_price][:pricelt72]
      @price['process_studio_id']=params[:process_studio_id]
      @price.save
      flash[:notice] = "Successfully updated the price"
      redirect_to :action => "list", :id =>@studio_id

    end

  end


  def set_default_price
    if(params[:id])
      studio_id = params[:id]
    else
      studio_id = 0
    end

    PrintSizePrice.update_all("default_size='0'", "studio_id = #{studio_id}")
    PrintSizePrice.update(params[:price_id], :default_size => '1')
    flash[:notice] = 'Successfully updated the default price'
    redirect_to :action => 'list' ,:id=> studio_id
  end

  def delete

    PrintSizePrice.delete(params[:id])
    redirect_to :action => 'list'
  end


  #studios
  def studio_price_list
    unless session[:employe].blank?
      @studio =EmployeAccount.find(session[:employe])
      studio_id = @studio.store_id
    else
      studio_id = 0
    end
    @prices = PrintSizePrice.find(:all, :joins =>"INNER JOIN print_sizes ON print_size_prices.print_size_id = print_sizes.id LEFT JOIN hmm_studios on print_size_prices.process_studio_id = hmm_studios.id",
      :conditions => "print_size_prices.studio_id=#{studio_id}",:select => "print_size_prices.pricelt72,print_size_prices.quantity,print_size_prices.aspect_ratio,print_size_prices.price as amount,print_size_prices.id as price_id,print_sizes.label,print_sizes.width,print_sizes.height,hmm_studios.studio_branch as processing_studio,print_size_prices.default_size,print_sizes.id as size_id")
  end

  def studio_price_add
    unless session[:employe].blank?
      @studio =EmployeAccount.find(session[:employe])
      @studio_id = @studio.store_id
      #@studio_type = 'others'
    else
      @studio_id = 0
      #@studio_type = 'hmm'
    end




    unless params[:print_size_price].blank?
      @price = PrintSizePrice.new(params[:print_size_price])
      if @price.valid?

        logger.info("PRINT SIZE ID :#{params[:print_size_price]['print_size_id']}")
       

        #if(Integer(params[:print_size_price]['print_size_id'])==Integer(high_resolution) || Integer(params[:print_size_price]['print_size_id'])==Integer(low_resolution))
        # logger.info("Im IN")
        #@price['process_studio_id']=@studio_id

        #end

        if(params[:print_size_price][:process_studio_id].to_i!=0)
          @price['studio_type']='others'
        else
          @price['studio_type']='hmm'
        end


        @price.save
        flash[:notice] = "Successfully added the price"
        redirect_to :action => "studio_price_list", :id =>params[:id]
      end
    end

    existing_sizes = PrintSizePrice.find(:all,:conditions => "studio_id=#{@studio_id}",:select => "print_size_id")
    temp = Array.new
    for exist in existing_sizes
      temp.push(exist.print_size_id)
    end
    @exclude_sizes = nil
    if temp.length > 0
      @exclude_sizes = temp.join(',')
      @exclude_sizes = "and id not in (#{@exclude_sizes})"
    end

  end

  def studio_price_edit
    unless session[:employe].blank?
      @studio =EmployeAccount.find(session[:employe])
      @studio_id = @studio.store_id
      @studio_type = 'others'
    else
      @studio_id = 0
      @studio_type = 'hmm'
    end

    @price=PrintSizePrice.find(params[:id])
    @size=PrintSize.find(@price.print_size_id)
    if(params[:price]!='' && params[:price]!=nil )
      #@price['studio_id']=@studio_id
      #@price['studio_type']=@studio_type
      @price['price']=params[:price]
      @price['quantity']=params[:print_size_price][:quantity]
      @price['aspect_ratio']=params[:print_size_price][:aspect_ratio]
      @price['pricelt72']= params[:print_size_price][:pricelt72]
      #    if(@size.id==Integer(high_resolution) || @size.id==Integer(low_resolution))
      #       @price['process_studio_id']=@price.process_studio_id
      #    else
      #    @price['process_studio_id']=@studio_id
      #    end
      @price.save
      flash[:notice] = "Successfully updated the price"
      redirect_to :action => "studio_price_list", :id =>@studio_id

    end

  end


  def studio_set_default_price
    if(session[:store_id])
      studio_id = session[:store_id]
    else
      studio_id = 0
    end

    PrintSizePrice.update_all("default_size='0'", "studio_id = #{studio_id}")
    PrintSizePrice.update(params[:price_id], :default_size => '1')
    flash[:notice] = 'Successfully updated the default price'
    redirect_to :action => 'studio_price_list' ,:id=> studio_id
  end

  def studio_price_delete

    PrintSizePrice.delete(params[:id])
    redirect_to :action => 'studio_price_list'
  end

  #franchise
  def franchise_list
    unless params[:id].blank?
      studio_id = params[:id]
    else
      studio_id = 0
      @fstudio=HmmStudio.find(:first,:conditions=>"status='active' and studio_groupid=#{session[:franchise]}",:order=>"id asc")
      redirect_to :action => "franchise_list", :id =>@fstudio.id
    end

    @studios=HmmStudio.find(:all,:conditions=>"status='active' and studio_groupid=#{session[:franchise]}",:order=>"id asc")


    @prices = PrintSizePrice.find(:all, :joins =>"INNER JOIN print_sizes ON print_size_prices.print_size_id = print_sizes.id LEFT JOIN hmm_studios on print_size_prices.process_studio_id = hmm_studios.id",
      :conditions => "print_size_prices.studio_id=#{studio_id}",:select => "print_size_prices.pricelt72,print_size_prices.quantity,print_size_prices.aspect_ratio,print_size_prices.price as amount,print_size_prices.id as price_id,print_sizes.label,print_sizes.width,print_sizes.height,hmm_studios.studio_branch as processing_studio,print_size_prices.default_size,print_sizes.id as size_id")
  end

  def franchise_add
    unless params[:id].blank?
      @studio_id = params[:id]
      @studio_type = 'others'
    else
      @studio_id = 0
      @studio_type = 'hmm'
    end

    unless params[:print_size_price].blank?
      @price = PrintSizePrice.new(params[:print_size_price])
      if(params[:print_size_price][:process_studio_id].to_i!=0)
        @price['studio_type']='others'
      else
        @price['studio_type']='hmm'
      end
      if @price.valid?
        @price.save
        flash[:notice] = "Successfully added the price"
        redirect_to :action => "franchise_list", :id =>params[:id]
      end
    end

    existing_sizes = PrintSizePrice.find(:all,:conditions => "studio_id=#{@studio_id}",:select => "print_size_id")
    temp = Array.new
    for exist in existing_sizes
      temp.push(exist.print_size_id)
    end
    @exclude_sizes = nil
    if temp.length > 0
      @exclude_sizes = temp.join(',')
      @exclude_sizes = "and id not in (#{@exclude_sizes})"
    end

  end

  def franchise_edit
    unless params[:studio_id].blank?
      @studio_id = params[:studio_id]
      @studio_type = 'others'
    else
      @studio_id = 0
      @studio_type = 'hmm'
    end

    @price=PrintSizePrice.find(params[:id])
    @size=PrintSize.find(@price.print_size_id)
    if(params[:price]!='' && params[:price]!=nil)
      #@price['studio_id']=@studio_id
      #@price['studio_type']=@studio_type
      @price['price']=params[:price]
      @price['quantity']=params[:print_size_price][:quantity]
      @price['aspect_ratio']=params[:print_size_price][:aspect_ratio]
      @price['pricelt72']= params[:print_size_price][:pricelt72]
      #@price['process_studio_id']=params[:process_studio_id]
      @price.save
      flash[:notice] = "Successfully updated the price"
      redirect_to :action => "franchise_list", :id =>@studio_id

    end

  end


  def franchise_set_default_price
    if(params[:id])
      studio_id = params[:id]
    else
      studio_id = 0
    end

    PrintSizePrice.update_all("default_size='0'", "studio_id = #{studio_id}")
    PrintSizePrice.update(params[:price_id], :default_size => '1')
    flash[:notice] = 'Successfully updated the default price'
    redirect_to :action => 'franchise_list' ,:id=> studio_id
  end

  def franchise_delete
    PrintSizePrice.delete(params[:id])
    redirect_to :action => 'franchise_list' ,:id=> params[:studio_id]
  end

end