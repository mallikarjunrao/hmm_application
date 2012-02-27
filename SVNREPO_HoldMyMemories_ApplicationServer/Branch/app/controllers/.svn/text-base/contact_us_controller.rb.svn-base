class ContactUsController < ApplicationController
  layout "standard"
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    #@contact_u_pages, @contact_us = paginate :contact_us, :per_page => 10
  end

  def show
    #@contact_u = ContactU.find(params[:id])
  end

  def new
    @contact_u = ContactU.new
  end

  def create123
    @contact_u = ContactU.new(params[:contact_u])
    @hmm_user_belongs_to = HmmUser.count(:all,:conditions => "v_e_mail='#{@contact_u.email}'")
    if(@hmm_user_belongs_to > 0)
      @hmm_user_belongs_to_det = HmmUser.find(:all,:conditions => "v_e_mail='#{@contact_u.email}'")
      emp_id= @hmm_user_belongs_to_det[0]['emp_id']
      customer_name="#{@hmm_user_belongs_to_det[0]['v_fname']} #{@hmm_user_belongs_to_det[0]['v_lname']}"
      acc_type=@hmm_user_belongs_to_det[0]['account_type']
      if(acc_type=="free_user")
        customer_account="Free User Account"
      else
        if(acc_type=="platinum_user")
          customer_account="Premium User Account"
        else
          customer_account="Family Website User Account"
        end
      end
      
      if(emp_id=='' || emp_id==nil )
        @contact_u.subject = "HoldMyMemories Contact Us Information..."
        Postoffice.deliver_contactUsreport1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,"Direct User","No employee involved",customer_name,customer_account)
      
      else  
        @employee_details = EmployeAccount.find(emp_id)
        branch = @employee_details.branch
        e_mail = @employee_details.e_mail
        emp_name = @employee_details.employe_name
        @contact_u.subject = "HoldMyMemories Contact Us Information..."
        Postoffice.deliver_contactUsreport1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,branch,emp_name,customer_name,customer_account)
      end
    else
      @contact_u.subject = "HoldMyMemories Contact Us Information..."
      Postoffice.deliver_contactUsreport(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email)
      
    end
    @contact_u.subject = "HoldMyMemories Contact Us Information..."
    if @contact_u.save
       #Postoffice.deliver_contactUsreport(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email)
      $notice_contact
      flash[:notice_contact] = 'The Contact Us Informantion was successfully Sent... Thank You!!'
      redirect_to :action => 'new'
    else
      redirect_to :action => 'new'
    end
  end

  def edit
    @contact_u = ContactU.find(params[:id])
  end

  def update
    @contact_u = ContactU.find(params[:id])
    if @contact_u.update_attributes(params[:contact_u])
      flash[:notice] = 'ContactU was successfully updated.'
      redirect_to :action => 'show', :id => @contact_u
    else
      render :action => 'edit'
    end
  end

  def destroy
    ContactU.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
