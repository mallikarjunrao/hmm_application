class Configuration < ActiveRecord::Base
  
		validates_presence_of :name, 
                          :description
                         
    validate :validate_value
    #validate :validate_tray
    #validate :validate_mini_tray

    def validate_value
      if name != 'delivery_order_notice' && value.strip == ""
          errors.add_to_base("Please enter a value.")
      end
    end

    
		  
		
end
