class EmployeAccount < ActiveRecord::Base
  
  def self.authenticate_employe(employe_username, password)
    find_by_employe_username_and_password(employe_username,password)
  end
end
