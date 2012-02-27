class VersionDetailsController < ApplicationController

  def form
    @versions=VersionDetail.find(:all)

  end
   def update_values
  VersionDetail.update(params[:id], :major=>"#{params[:major]}",:minor=>"#{params[:minor]}")
   redirect_to '/version_details/form'
   end
end
