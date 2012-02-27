class FlexFeedbackController < ApplicationController
    require 'json/pure'
  def fx_save_user_interaction
          @allcomments = FlexComment.new
          @allcomments['component_name']=  params[:component_name]
          @allcomments['type']=  params[:type]
          @allcomments['comments']=params[:data]
          @allcomments.save
    end

    def fx_get_user_interaction
      if params[:update]
        if params[:id]
          FlexComment.update(params[:id],:component_name=>"#{params[:component_name]}",:type=>"#{params[:type]}",:comment=>"#{params[:data]}")
        else
          @allcomments['component_name']=  params[:component_name]
          @allcomments['type']=  params[:type]
          @allcomments['comments']=params[:data]
          @allcomments.save
    end
      else
        @comments= FlexComment.find(:all,:select=>"component_name,type,comment",:conditions =>"component_name='#{params[:component_name]}'")
        @comments.to_json
      end
    end
end
