# To change this template, choose Tools | Templates
# and open the template in the editor.

class SlideshowController < ApplicationController
  def get_slideshow_moment_list
    @slideshowmoment = SlideshowDetail.find(:all, :conditions => " slideshow_moment_id=#{params[:id]}")
    render :layout => false
  end
end
