class OrderItem < ActiveRecord::Base
  #belongs_to :order

  validates_presence_of     :item_id,
                            :item_type
  validates_numericality_of :qty,
                            :price

end
