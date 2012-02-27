class OrderRequest < ActiveRecord::Base

  belongs_to :hmm_user

  validates_format_of     :email_address,      :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

end
