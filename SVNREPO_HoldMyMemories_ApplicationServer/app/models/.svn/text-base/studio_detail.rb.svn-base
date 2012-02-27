class StudioDetail < ActiveRecord::Base
  has_one :card_price
  validates_presence_of :email
  validates_format_of       :email,
    :with =>  /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*([,;]\s*\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)*$/,
    :message => "Its not a valid format"
#  validates_format_of       :website,
#    :with =>  /^([a-z0-9_-]+\.)*[a-z0-9_-]+(\.[a-z]{2,6}){1,2}$/,
#    :message => "Its not a valid format"
end
