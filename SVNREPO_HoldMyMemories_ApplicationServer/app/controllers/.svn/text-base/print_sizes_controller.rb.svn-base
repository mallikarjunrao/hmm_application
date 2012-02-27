class PrintSizesController < ApplicationController
  layout "admin"
  before_filter :authenticate_admin, :only => [:list_sizes, :add_size, :edit_size, :delete_size]

  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to :controller => 'account', :action => 'login'
      return false
    end
  end

  def list_sizes
    @sizes = PrintSize.find(:all)
  end

  def add_size
    unless params[:print_size].blank?
      @size = PrintSize.new(params[:print_size])
      if @size.valid?
        @size.save
        flash[:notice] = "Successfully added the size"
        redirect_to :action => "list_sizes"
      end
    end
  end

  def edit_size
    unless params[:id].blank?
      @size = PrintSize.find(params[:id])
      unless params[:print_size].blank?
        @size.update_attributes(params[:print_size])
        if @size.valid?
          @size.save
          flash[:notice] = "Successfully updated the size"
          redirect_to :action => "list_sizes"
        end
      end
    else
      redirect_to :action => "list_sizes"
    end
  end

  def delete_size
    unless params[:id].blank?
      if (PrintSize.delete(params[:id]))
        flash[:notice] = "Successfully deleted the size"
        redirect_to :action => "list_sizes"
      else
      end
    else
      redirect_to :action => "list_sizes"
    end
  end

end