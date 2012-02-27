class HomeController < ApplicationController
  layout "iphone_application"
  def studio_info
    if true
      respond_to do |format|
        format.iphone do  # action.iphone.erb
        end
      end
    end
  end

  def about_us
    if true
      respond_to do |format|
        format.iphone do  # action.iphone.erb
        end
      end
    end
  end

  def user_info
    @user=HmmUser.find(:first,:conditions=>"id=#{params[:user_id]}")
    if true
      respond_to do |format|
        format.iphone do  # action.iphone.erb
        end
      end
    end
  end
end
