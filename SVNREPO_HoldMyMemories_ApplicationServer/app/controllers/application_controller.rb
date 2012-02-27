class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  #include SimpleCaptcha::ControllerHelpers
  include SimpleCaptcha::ControllerHelpers
  session :session_key => '_railscoders_session_id'
  include UserLoginSystem
  include LoginSystem
  helper :user_account
  include UserAccountHelper
  include UserSessionHelper

#  include SslRequirement
#  #oink memory leak checker added
#  include Oink::MemoryUsageLogger

  # filter out password parameters from log files
  filter_parameter_logging :card_no


 # before_filter :session_expiry,:sanitize_params
  def logincheck
    if(logged_in_hmm_user.id==nil or logged_in_hmm_user.id=="")
      redirect :controller => :user_account, :action => :login
    end
  end

#  rescue_from ActionController::RoutingError, :with => :render_404
#  rescue_from ActionController::UnknownAction, :with => :render_404
#  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
#   rescue_from ActiveRecord::StatementInvalid, :with => :render_404

  private
  def render_404(exception = nil)
    if exception
      logger.info "Rendering 404: #{exception.message}"
    end
    redirect_to "/contests/error_page/"
  end


  #include ExceptionNotifiable


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

  #def removeSymbols(name)
  #	re = Array.new
  #	re[0]="!"	# Single Character 1
  #	re[1]="@"	# Single Character 2
  #	re[2]="#"	# Single Character 3
  #	re[3]="$"	# Single Character 4
  #	re[4]="%"	# Single Character 5
  #	re[5]="^"	# Single Character 6
  #	re[6]="&"	# Single Character 7
  #	re[7]="*"	# Single Character 8
  #	re[8]="("	# Single Character 9
  #	re[9]=")"	# Single Character 10
  #	re[10]="-"	# Single Character 11
  #	re[11]="+"	# Single Character 12
  #	re[12]="="	# Single Character 13
  #	re[13]="{"	# Single Character 14
  #	re[14]="}"	# Single Character 15
  #	re[15]="["	# Single Character 16
  #	re[16]="]"	# Single Character 17
  #	re[17]="|"	# Single Character 18
  #	re[18]="\\"	# Single Character 19
  #	re[19]=":"	# Single Character 20
  #	re[20]=";"	# Single Character 21
  #	re[21]="\""	# Single Character 22
  #	re[22]="'"	# Single Character 23
  #	re[23]="<"	# Single Character 24
  #	re[24]=">"	# Single Character 25
  #	re[25]="?"	# Single Character 26
  #	re[26]="/"	# Single Character 27
  #	re[27]=","	# Single Character 28
  #	#re[28]="."	# Single Character 29
  #
  #
  #	filename = name
  #	for expression in re
  #		#reg = Regexp.new(exp, Regexp::IGNORECASE)
  #		filename = filename.delete(expression)
  #	end
  #	filename = filename.downcase
  #	filename = filename.gsub( /[ ]/, "")
  #	return filename
  #end



  def removeSymbols(name)
    name = name.gsub "!", ''
    name = name.gsub "@", ''
    name = name.gsub "#", ''
    name = name.gsub "$", ''
    name = name.gsub "%", ''
    name = name.gsub "^", ''
    name = name.gsub "&", ''
    name = name.gsub "*", ''
    name = name.gsub "(", ''
    name = name.gsub ")", ''
    name = name.gsub "-", ''
    name = name.gsub "+", ''
    name = name.gsub "=", ''
    name = name.gsub "{", ''
    name = name.gsub "}", ''
    name = name.gsub "[", ''
    name = name.gsub "]", ''
    name = name.gsub "|", ''
    name = name.gsub "\\", ''
    name = name.gsub ":", ''
    name = name.gsub ";", ''
    name = name.gsub "/\/", ''
    name = name.gsub "'", ''
    name = name.gsub ">", ''
    name = name.gsub ">", ''
    name = name.gsub "?", ''
    name = name.gsub "/", ''
    name = name.gsub ",", ''
    name = name.gsub "~", ''
    name = name.gsub "`", ''
    filename=name
    filename = filename.downcase
    filename = filename.gsub( /[ ]/, "")
    return filename
  end

  def removefamilySymbols(name)
    name = name.gsub "!", ''
    name = name.gsub "@", ''
    name = name.gsub "#", ''
    name = name.gsub "$", ''
    name = name.gsub "%", ''
    name = name.gsub "^", ''
    name = name.gsub "&", ''
    name = name.gsub "*", ''
    name = name.gsub "(", ''
    name = name.gsub ")", ''
    name = name.gsub "-", ''
    name = name.gsub "+", ''
    name = name.gsub "=", ''
    name = name.gsub "{", ''
    name = name.gsub "}", ''
    name = name.gsub "[", ''
    name = name.gsub "]", ''
    name = name.gsub "|", ''
    name = name.gsub "\\", ''
    name = name.gsub ":", ''
    name = name.gsub ";", ''
    name = name.gsub "/\/", ''
    name = name.gsub "'", ''
    name = name.gsub ">", ''
    name = name.gsub ">", ''
    name = name.gsub "?", ''
    name = name.gsub "/", ''
    name = name.gsub ",", ''
    name = name.gsub "~", ''
    name = name.gsub "`", ''
    name = name.gsub ".", ''
    filename=name
    filename = filename.downcase
    filename = filename.gsub( /[ ]/, "")
    return filename
  end

  def session_expiry
    logger.info(session[:expires_at])
    if session[:user] || session[:employe] || session[:manager] || session[:franchise] || session[:cemploye_name] || session[:manager] ||  session[:business_manager] || session[:sales_person]
      @time_left = (session[:expires_at] - Time.now).to_i
      unless @time_left > 0
        flash[:error] = 'Session Expired Please Login now.'
        if session[:employe]
          reset_session
          #redirect_to :controller => 'account', :action => 'employe_login'
        elsif session[:franchise]
          reset_session
          redirect_to :controller => 'account', :action => 'franchise_login'
        elsif session[:cemploye_name]
          reset_session
          redirect_to :controller => 'account', :action => 'commission_login'
        elsif session[:manager]
          reset_session
          redirect_to :controller => 'account', :action => 'market_manager_login'
        elsif session[:business_manager]
          reset_session
          redirect_to :controller => 'account', :action => 'business_manager_login'
        elsif session[:sales_person]
          reset_session
          redirect_to :controller => 'account', :action => 'sales_person_login'
        else
          reset_session
          redirect_to :controller => 'account', :action => 'login'
        end
      end
    end
  end
end