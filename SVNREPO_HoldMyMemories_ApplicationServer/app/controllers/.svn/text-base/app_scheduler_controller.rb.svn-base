class AppSchedulerController < ApplicationController

   def authenticate_employee
     retval = Hash.new()
    logged_in_employe = EmployeAccount.find_by_employe_username_and_password(params[:username],
      params[:password], :conditions => "status='unblock'")
    if logged_in_employe
      emp={}
      emp={:employee_id=>logged_in_employe.id}
      retval={:data=>emp,:status=>true,:error=>""}
    else
      retval={:data=>'',:status=>true,:error=>"Wrong Username or Password"}
    end
    render :text=>retval.to_json
  end
end
