class ApplicationController < ActionController::Base
# Pick a unique cookie name to distinguish our session data from others'
#include SimpleCaptcha::ControllerHelpers
session :session_key => '_railscoders_session_id'
include UserLoginSystem
include LoginSystem
helper :user_account
include UserAccountHelper

#  before_filter :set_facebook_session
#  helper_method :facebook_session



def logincheck
  if(logged_in_hmm_user.id==nil or logged_in_hmm_user.id=="")
    redirect :controller => :user_account, :action => :login
  end
end




#include ExceptionNotifiable 


#def resize(img, destinationH, destinationW,path)
## maxU = destinationH/img.rows
## maxV = destinationW/img.columns
#
# finalImage =  Image.new(destinationW,destinationH) { self.background_color = "black" }
# if(img.rows > img.columns)
#  w = destinationH*img.columns/img.rows
#  puts w
#  h = destinationH
#  x = (destinationW - w)/2
#  y = 0
#  img.scale!(w, h)
#  finalImage = finalImage.composite(img,x,y,CopyCompositeOp) 
# else
#  w = destinationW
#  h = destinationW*img.rows/img.columns
#  
#  puts h
#  puts w
#  y = (destinationH - h)/2
#  x = 0
#  puts x
#  puts y
#  img.scale!(w, h)
#
#  finalImage = finalImage.composite(img,x,y,CopyCompositeOp) 
#
# end
# #finalImage.write("output.jpg")
# finalImage.write("#{path}")
#end

def resize(img, destinationH, destinationW,path)
# maxU = destinationH/img.rows
# maxV = destinationW/img.columns

 finalImage =  Image.new(destinationW,destinationH) { self.background_color = "black" }
 if(img.rows > img.columns)
   w = destinationH*img.columns/img.rows
   puts w
   h = destinationH
   x = (destinationW - w)/2
   y = 0
   temp_img = img.scale(w, h)
   finalImage = finalImage.composite(temp_img,x,y,CopyCompositeOp) 
 else
   w = destinationW
   h = destinationW*img.rows/img.columns
   
  
   y = (destinationH - h)/2
   x = 0
  
   temp_img = img.scale(w, h)
   
   finalImage = finalImage.composite(temp_img,x,y,CopyCompositeOp) 
   
 end
 return finalImage
 #finalImage.write("output.jpg")
 #finalImage.write("#{path}")
end




# def paginate_by_sql(model, sql, per_page, options={})
#       if options[:count]
#           if options[:count].is_a? Integer
#               total = options[:count]
#           else
#               total = model.count_by_sql(options[:count])
#           end
#       else
#           total = model.count_by_sql_wrapping_select_query(sql)
#       end
#
#       object_pages = Paginator.new self, total, per_page,
#            params['page']
#       objects = model.find_by_sql_with_limit(sql,
#            object_pages.current.to_sql[1], per_page)
#       return [object_pages, objects]
#   end
#   
#    def paginate_from_sql(model, sql, count_sql, per_page)
#      plural_model_name = "@#{model.name.underscore.pluralize}".to_sym
#      paginator_name = "@#{model.name.underscore}_pages".to_sym
#      self.instance_variable_set(paginator_name, Paginator.new(self,
#model.count_by_sql(count_sql), per_page, params['page']))
#      self.instance_variable_set(plural_model_name,
#model.find_by_sql(  "#{sql} LIMIT 0,10"))
#    end


 def self.find_by_sql_with_limit(sql, offset, limit)
            sql = sanitize_sql(sql)
            add_limit!(sql, {:limit => limit, :offset => offset})
            find_by_sql(sql)
        end


 def resizeWithoutBorder(img, destinationW, destinationH,path)
	 # maxU = destinationH/img.rows
	 # maxV = destinationW/img.columns
	 
	 temp_image = nil
	 if(img.rows > img.columns)
		 w = destinationH*img.columns/img.rows
		 puts w
		 h = destinationH
		 x = (destinationW - w)/2
		 y = 0
		 temp_img = img.scale(w, h)
		 
	 else
		 w = destinationW
		 h = destinationW*img.rows/img.columns
		 
		# puts h
		 #puts w
		 y = (destinationH - h)/2
		 x = 0
		# puts x
		# puts y
		 temp_img = img.scale(w, h)
		 
		 
		 
	 end
	 return temp_img
	 #finalImage.write("output.jpg")
	 #finalImage.write("#{path}")
 end		
		
def removeSymbols(name)
	re = Array.new
	re[0]="!"	# Single Character 1
	re[1]="@"	# Single Character 2
	re[2]="#"	# Single Character 3
	re[3]="$"	# Single Character 4
	re[4]="%"	# Single Character 5
	re[5]="^"	# Single Character 6
	re[6]="&"	# Single Character 7
	re[7]="*"	# Single Character 8
	re[8]="("	# Single Character 9
	re[9]=")"	# Single Character 10
	re[10]="-"	# Single Character 11
	re[11]="+"	# Single Character 12
	re[12]="="	# Single Character 13
	re[13]="{"	# Single Character 14
	re[14]="}"	# Single Character 15
	re[15]="["	# Single Character 16
	re[16]="]"	# Single Character 17
	re[17]="|"	# Single Character 18
	re[18]="\\"	# Single Character 19
	re[19]=":"	# Single Character 20
	re[20]=";"	# Single Character 21
	re[21]="\""	# Single Character 22
	re[22]="'"	# Single Character 23
	re[23]="<"	# Single Character 24
	re[24]=">"	# Single Character 25
	re[25]="?"	# Single Character 26
	re[26]="/"	# Single Character 27
	re[27]=","	# Single Character 28
	#re[28]="."	# Single Character 29
	
	
	filename = name
	for expression in re
		#reg = Regexp.new(exp, Regexp::IGNORECASE)
		filename = filename.delete(expression)
	end
	filename = filename.downcase
	filename = filename.gsub( /[ ]/, "")
	return filename
end

  rescue_from Facebooker::Session::SessionExpired do |exception|
clear_facebook_session_information
clear_fb_cookies!
reset_session # i.e. logout the user
flash[:notice] = "You have been disconnected from Facebook."
redirect_to root_url
end

rescue_from Facebooker::Session::SessionExpired, :with => :facebook_session_expired
  def facebook_session_expired
    clear_fb_cookies!
    clear_facebook_session_information
    reset_session # remove your cookies!
    
  end



end

