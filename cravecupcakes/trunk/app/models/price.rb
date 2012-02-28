class Price < ActiveRecord::Base

		validates_presence_of :title
		validates_presence_of :price
end
