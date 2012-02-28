class DeliveryFee < ActiveRecord::Base
    validates_presence_of :store_id,
                          :zip
    validates_uniqueness_of :zip, :scope => [:store_id, :zip]

    validates_numericality_of :delivery_fee
end
