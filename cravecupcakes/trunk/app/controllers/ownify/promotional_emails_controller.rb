class Ownify::PromotionalEmailsController < LoginController
  def index  
    if get_access_level != 1
      access_denied
    else
      render :action => 'index'
    end    
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :index }

  
  def export
    if get_access_level != 1
      access_denied
    else
      if params[:date_1] != nil
        session[:date_1] = params[:date_1]
      end

      @pro_emails_page = PromotionalEmail.find(:all, :select => "email, fname, lname, submitted_on", :order => "submitted_on ASC", :page => { :size => 30, :current => params[:page] }, :conditions =>["submitted_on >= ? ", session[:date_1]])

      @pro_emails_exp = PromotionalEmail.find(:all, :select => "email, fname, lname, submitted_on", :order => "submitted_on ASC", :conditions =>["submitted_on >= ? ", session[:date_1]])
    
      if @pro_emails_exp.empty? == false
         render :action => 'export'
      else
        @msg = "No promotional emails stored for this date selection."
        render :action => "index"
      end
    end   

  end

  def get_file
      render :file => RAILS_ROOT + "/public/export.csv"
      return false
  end
  
end