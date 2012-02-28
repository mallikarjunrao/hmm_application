class SpecialDecoration < ActiveRecord::Base
  	validates_presence_of :name, :message => 'can\'t be blank.'                   
    #validate :validate_mini
    validate :validate_group
    

    def validate_group
      if group == 'Select'
          errors.add_to_base("Please select a group")
      end
    end     

    def validate_mini
      if mini == true && colors == true
          errors.add_to_base("Special decorations that require two colors cannot be enabled for mini cupcakes")
      end
    end     
    
end
