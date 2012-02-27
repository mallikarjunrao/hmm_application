class CardPrice < ActiveRecord::Base
  belongs_to :studio_detail
  belongs_to :card
end
