class Card < ActiveRecord::Base
  has_one :card_price
  has_one :card_cart
end
