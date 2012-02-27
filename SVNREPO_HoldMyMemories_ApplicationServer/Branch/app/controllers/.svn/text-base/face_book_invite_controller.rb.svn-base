class FaceBookInviteController < ApplicationController
 

  layout "standard"
  
  require 'pp'

  
    before_filter :require_facebook_install
  
  
  def index1
    
    #:requirefacebookinstall
    
    if fbsession.ready?
      friendUIDs = fbsession.friends_get.uid_list
      @friendNames = []
      @friendimages = []
      @uids = []
      friendsInfo = fbsession.users_getInfo(:uids => friendUIDs, :fields => ["first_name", "last_name","pic_square", "status"])
      i=0
      
      for userInfo in friendsInfo.user_list 
        @uids[i] = userInfo.uid
        @friendNames[i] = userInfo.first_name + " " + userInfo.last_name
        @friendimages[i] = userInfo.pic_square
        i=i+1
        pp userInfo
        pp session
        #puts friendsNames
        #fbsession.notifications_send(:to_ids => ['400156', '1906543'], :notification => message)
      end
    else
      :require_facebook_install
     end
     
  end  
  
  def index2
    if fbsession.ready?
      friendUIDs = fbsession.friends_get.uid_list
      @friendNames = []
      @friendimages = []
      friendsInfo = fbsession.users_getInfo(:uids => friendUIDs, :fields => ["first_name", "last_name","pic_square", "status"])
      i=0
      for userInfo in friendsInfo.user_list 
        @friendNames[i] = userInfo.first_name + " " + userInfo.last_name
        @friendimages[i] = userInfo.pic_square
        i=i+1
        pp userInfo
        pp session
        #puts friendsNames
      end
    else
      :require_facebook_install
     end
  end
  def facebook_logout
    if fbsession.ready?
       session[:__RFACEBOOK_fbsession_holder] = nil
        session[:__RFACEBOOK_fbparams] = nil
        @fbsession_holder = nil
        session[:_rfacebook_fbsession_holder] = nil
        session[:_rfacebook_fbparams] = nil
        @fbsession_holder = nil
        :log_out_of_facebook
    end
  end
  
  def notify_friend
    if fbsession.ready?
      message ="Hi friends, <br> Please vote for the contest entry in the below given link <br> #{session[:vote_url]}. <br> Thank you."
#      frnlist = ""
#     
#      for frndsid in params[:frnid]
#        frnlist = frnlist + "'#{frndsid}',"
#      end  
#        frnlist = frnlist + "0"
      fbsession.notifications_send(:to_ids => params[:frnid] , :notification => message)
      
    else
      :require_facebook_install
    end
  end
  
  def myspace_invite
    
  end
  
  def vote
    session[:vote_url] = params[:url]
    redirect_to :controller => "face_book_invite", :action => 'index1'
  end

end