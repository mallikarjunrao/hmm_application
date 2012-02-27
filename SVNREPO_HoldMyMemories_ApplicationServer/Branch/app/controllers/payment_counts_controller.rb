class PaymentCountsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @payment_count_pages, @payment_counts = paginate :payment_counts, :per_page => 10
  end

  def show
    @payment_count = PaymentCount.find(params[:id])
  end

  def new
    @payment_count = PaymentCount.new
  end

  def create
    @payment_count = PaymentCount.new(params[:payment_count])
    if @payment_count.save
      flash[:notice] = 'PaymentCount was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @payment_count = PaymentCount.find(params[:id])
  end

  def update
    @payment_count = PaymentCount.find(params[:id])
    if @payment_count.update_attributes(params[:payment_count])
      flash[:notice] = 'PaymentCount was successfully updated.'
      redirect_to :action => 'show', :id => @payment_count
    else
      render :action => 'edit'
    end
  end

  def destroy
    PaymentCount.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
