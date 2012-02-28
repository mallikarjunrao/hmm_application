class TimeslotWindow < ActiveRecord::Base
 
		validates_presence_of :timeslot
		#validates_presence_of :no_of_orders
    
				
  def self.select_options
    [['Select', 0]].concat(find(:all, :order => "id").map{|x| [x.timeslot, x.id]})
  end
		
end
