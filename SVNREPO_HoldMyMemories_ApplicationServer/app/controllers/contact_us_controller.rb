class ContactUsController < ApplicationController
  layout "application"
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

#  def new
#    @contact_u = ContactU.new
#    if(params[:contact_u])
#      if simple_captcha_valid?
#        @contact_u = ContactU.new(params[:contact_u])
#    @hmm_user_belongs_to = HmmUser.count(:all,:conditions => "v_e_mail='#{@contact_u.email}'")
#    if(@hmm_user_belongs_to > 0)
#      @hmm_user_belongs_to_det = HmmUser.find(:all,:conditions => "v_e_mail='#{@contact_u.email}'")
#      emp_id= @hmm_user_belongs_to_det[0]['emp_id']
#      customer_name="#{@hmm_user_belongs_to_det[0]['v_fname']} #{@hmm_user_belongs_to_det[0]['v_lname']}"
#      acc_type=@hmm_user_belongs_to_det[0]['account_type']
#      if(acc_type=="free_user")
#        customer_account="Free User Account"
#      else
#        if(acc_type=="platinum_user")
#          customer_account="Premium User Account"
#        else
#          customer_account="Family Website User Account"
#        end
#      end
#
#      if(emp_id=='' || emp_id==nil )
#        @contact_u.subject = "HoldMyMemories Contact Us Information..."
#        Postoffice.deliver_contactUsreport1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,"Direct User","No employee involved",customer_name,customer_account)
#
#      else
#        @employee_details = EmployeAccount.find(emp_id)
#        branch = @employee_details.branch
#        e_mail = @employee_details.e_mail
#        emp_name = @employee_details.employe_name
#        @contact_u.subject = "HoldMyMemories Contact Us Information..."
#        Postoffice.deliver_contactUsreport1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,branch,emp_name,customer_name,customer_account)
#      end
#    else
#      @contact_u.subject = "HoldMyMemories Contact Us Information..."
#      Postoffice.deliver_contactUsreport("Bob.Eveleth@S121.com,Rachel.Allen@S121.com,customerservice@holdmymemories.com,Dan.Quinlan@holdmymemories.com",@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,@contact_u.zip,@contact_u.phone_no,@contact_u.mobile_no)
#
#    end
#    @contact_u.subject = "HoldMyMemories Contact Us Information..."
#    if @contact_u.save
#       #Postoffice.deliver_contactUsreport(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email)
#
#      flash[:notice_contact] = 'Thank You for submitting the details'
#      redirect_to :action => 'new'
#    else
#      redirect_to :action => 'new'
#    end
#      else
#        flash[:error] = 'Please enter the correct code!'
#      end
#    end
#  end


   def new
    @contact_u = ContactU.new
    if(params[:contact_u])
      if verify_recaptcha
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
            emp_studio_id = 0
            Postoffice.deliver_contactUsreport1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,"Direct User","No employee involved",customer_name,customer_account,emp_studio_id)

          else
            @employee_details = EmployeAccount.find(emp_id)
            branch = @employee_details.branch
            e_mail = @employee_details.e_mail
            emp_name = @employee_details.employe_name
            emp_studio_id = @employee_details.store_id
            @contact_u.subject = "HoldMyMemories Contact Us Information..."
            Postoffice.deliver_contactUsreport1(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,branch,emp_name,customer_name,customer_account,emp_studio_id)
          end
        else
          user_studio_id = 0
          @contact_u.subject = "HoldMyMemories Contact Us Information..."
          Postoffice.deliver_contactUsreport("customerservice@holdmymemories.com",@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email,@contact_u.zip,@contact_u.phone_no,@contact_u.mobile_no)

        end
        @contact_u.subject = "HoldMyMemories Contact Us Information..."
        if @contact_u.save
          #user_studio_id = @hmm_user_belongs_to_det[0]['studio_id']
          #Postoffice.deliver_contactUsreport(@contact_u.first_name,@contact_u.subject,@contact_u.message,@contact_u.country,@contact_u.email)

          flash[:notice_contact] = 'Thank You for submitting the details'
          redirect_to :action => 'new'
        else
          redirect_to :action => 'new'
        end
      else
        flash[:error] = 'Please enter the correct code!'
      end
    end
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

  def familywebsite_option

  end

  def studio_assign
    @hmm_users=HmmUser.find(:all, :select => "a.*, b.id as subchapid", :joins => "as a, sub_chapters as b", :conditions => "a.emp_id!='' and a.id=b.uid and b.sub_chapname like '%portrait%' and b.store_id is null")
    for hmmuser in @hmm_users
        sub_chapter=SubChapter.find(hmmuser.subchapid)
        empdet=EmployeAccount.find(hmmuser.emp_id)
        sub_chapter.store_id = empdet.store_id
        sub_chapter.save

    end
    render :layout => false
  end


  def email_us
    @contact_u = ContactU.new
    if(params[:contact_u])
      if verify_recaptcha
       @contact_u.subject = "HoldMyMemories Contact Us Information..."
      Postoffice.deliver_contactUsreport(params[:studio_email],params[:contact_u][:first_name],'HoldMyMemories Contact Us Information',params[:contact_u][:message],params[:contact_u][:country],params[:contact_u][:email],params[:contact_u][:zip],params[:contact_u][:phone_no],params[:contact_u][:mobile_no])
      flash[:notice_contact] = 'Thank You for submitting the details'
      redirect_to :action => 'email_us'

      else
        flash[:error] = 'Please enter the correct code!'
      end
    end
  end



end