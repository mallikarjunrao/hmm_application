class Owner < ActiveRecord::Base


  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :username
  validates_presence_of :password
  #validates_presence_of :email
  validates_presence_of :access_level

  def self.login(name, password)
  find(:first, :conditions => ["username = ? and password = ?", name, password])
  end

  def try_to_login
    Owner.login(self.username, self.password)
  end
  
end
