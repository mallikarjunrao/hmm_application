class EditableText < ActiveRecord::Base
		validates_presence_of :title
		#validates_presence_of :html_body
		
		def self.display( slug )
		  text = find_by_title( slug )
				if text
				  text.html_body
				else
				  nil
				end
		end
		
		
end
