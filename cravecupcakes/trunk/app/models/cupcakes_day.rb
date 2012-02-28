class CupcakesDay < ActiveRecord::Base
  belongs_to :day
  belongs_to :cupcake
end
