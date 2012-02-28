class MiniCupcakesDay < ActiveRecord::Base
  belongs_to :day
  belongs_to :mini_cupcake
end
