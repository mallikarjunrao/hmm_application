class MysiteSecurityController < ApplicationController
  layout "myfamilywebsite"
  
  before_filter :authenticate, :only => [ :change_admin_password, :change_website_password, :password_settings ]
  
  def authenticate
      if session[:hmm_user]
        if(logged_in_hmm_user.family_name.downcase != params[:id].downcase)
           redirect_to :controller => 'manage_site',:action=>'mysite_login',:id=>params[:id]
        end
      end
      unless session[:hmm_user]
           flash[:notice] = 'Please Login to Access your Account'
            redirect_to :controller => 'manage_site',:action => 'mysite_login', :id => params[:id]
      return false
      else
        if (session[:flag] == 1 && request.request_uri != "/customers/upgrade/platinum_account")
          flash[:error] = "Your credit card payment to your HoldMyMemories.com has been declined by your credit card company. This could be for a number of reasons, including an expired card. <br><br><br>Please re-enter your credit card information, or use a different card for the renewal of your account."
          redirect_to "https://www.holdmymemories.com/customers/upgrade/platinum_account"
        end  
      end
    end
  
  
  def change_admin_password
    @hmm_user=HmmUser.find(session[:hmm_user])
  end
  
  def chg_password_execute
    sql = ActiveRecord::Base.connection();
    if(params[:pass][:old]!='')
      chk = HmmUser.count(:all, :conditions => "id=#{logged_in_hmm_user.id} and v_password='#{params[:pass][:old]}'")
      if(chk > 0)
        sql.update "UPDATE hmm_users SET v_password='#{params[:pass][:confirm]}' WHERE id=#{logged_in_hmm_user.id}";
        flash[:notice] = "Your password has been changed successfully."
        redirect_to :action => 'change_admin_password', :id => params[:familyname]
      else
        flash[:notice] = "Invalid Current password. Please try again"
        redirect_to :action => 'change_admin_password', :id => params[:familyname]
      end
    end
  end  
  
  def change_website_password
    @rec = HmmUser.find(:all, :conditions => "id=#{logged_in_hmm_user.id}")
  end
  
  def edit_familypassword
    @hmm_user = HmmUser.find(params[:id])
    render :layout => false
  end
  
  def step1_update
    @hmm_user = HmmUser.find(params[:id])
    
    if params[:familypassword]=="no"
        @hmm_user['password_required']="no"
        @hmm_user['familywebsite_password']=""
    else
        params[:hmm_user][:password_required]="yes"
    end
    if @hmm_user.update_attributes(params[:hmm_user])
#      Postoffice.deliver_send_sitedetails(link,pass_req,pass,recipent,@message)
        if params[:familypassword]=="no"
          flash[:notice_step1succes] = 'Family Website password settings were successfully set..'
        else
          flash[:notice_step1succes] = 'Family password was successfully set..'
        end
       
       redirect_to :action => 'password_settings' , :id => params[:familyname]
    else
       flash[:notice_step1fail] = 'Family password was not saved please try again'
       redirect_to :action => 'password_settings' , :id => params[:familyname]
    end
     
    
  end
  
  def nofamily_password
    render :layout => false
  end
  
  def password_settings
    
  end

  def account_settings
    @credit_points_count=CreditPoint.count(:all,:conditions=>"user_id='#{logged_in_hmm_user.id}'")

    if(@credit_points_count>0)
    @studio_groups=HmmUser.find(:first,:select => "a.*,b.*,c.*,d.* ", :joins =>"as a ,employe_accounts as b,hmm_studios as c,hmm_studiogroups  as d ",:conditions => "a.id=#{logged_in_hmm_user.id} and b.id=a.emp_id and b.store_id=c.id and c.studio_groupid=d.id ")
    @credit_points=CreditPoint.find(:first,:conditions=>"user_id='#{logged_in_hmm_user.id}'")
    @creditvalue=1
    else
    @creditvalue=0
    end
  end
  
end
