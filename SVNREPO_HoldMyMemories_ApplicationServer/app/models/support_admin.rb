class SupportAdmin < ActiveRecord::Base
  validates_presence_of :username
  validates_presence_of :email
  validates_presence_of :password
  validates_presence_of :password_confirmation
  validates_confirmation_of :password
  validates_uniqueness_of :username, :case_sensitive => false
  validates_uniqueness_of :email, :case_sensitive => false
  validates_length_of :username, :within => 3..64
  validates_length_of :email, :within => 5..128
end
