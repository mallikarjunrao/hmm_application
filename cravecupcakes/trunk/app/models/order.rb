class Order < ActiveRecord::Base
  #has_many :order_item

  validates_presence_of     :order_id,
                            :store_id,
                            :date_of_order,
                            :time_of_order,
                            :delivery_method,
                            #:has_giftbox,
                            #:has_ribbon,
                            #:how_to_boxed,
                            :first_name,
                            :last_name,
                            :primary_phone
if :admin_name == nil
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid Email" 
end
  validates_presence_of :shipto_is_business,
                        :shipto_business,
                        :shipto_first_name,
                        :shipto_last_name,
                        :shipto_address_1,
                        :shipto_zip
  
#  validates_presence_of :b_fname,
#                        :b_lname,
#                        :b_adrs,
#                        :b_city,
#                        :b_state,
#                        :b_zip,
#                        :b_phone
#
#  validates_format_of   :b_email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid Billing Email"


  validates_numericality_of :order_shipping,
                            :order_discount,
                            :sales_tax,
                            :order_total

end