class FaceBookConnectController < ApplicationController
 

  #layout false
#  layout "facebook_connect"
  #layout 'familywebsite_facebook'
  #require 'pp'
  #require 'rfacebook'
  #before_filter  :check_account
  
  before_filter :set_facebook_session
  helper_method :facebook_session


 

  def signup

  end

  def face_book_logged_in
    if facebook_session
       @fuser=facebook_session.user.pic_big
       @other=facebook_session.user.name
       @sex=facebook_session.user.sex
       @aboutme=facebook_session.user.about_me
       @emailid=facebook_session.user.email
       @user = HmmUser.new()
       @user.v_fname=facebook_session.user.first_name
       @user.v_lname=facebook_session.user.last_name
       @user.e_sex=facebook_session.user.sex
       @user.v_user_name=facebook_session.user.email
       @user.v_password="test"
       @user.v_country="USA"
       @user.v_zip="111111"
       @user.v_e_mail=facebook_session.user.email
       @user.d_created_date=Time.now
       @user.d_updated_date=Time.now
       @user.d_bdate="2000-01-01"
       @user.v_security_q="what?"
       @user.v_security_a="Answer"
       @user.v_abt_me=facebook_session.user.about_me
       max = UserContent.find(:first,:order=>"id desc",:select=>"id")
       max=max.id+1
       filename = "#{max}.jpg"
       @user.family_pic=filename
       #To find the maximum user id
       @hmm_user_max =  HmmUser.find_by_sql("select max(id) as n from hmm_users")
      for hmm_user_max in @hmm_user_max
         hmm_user_max_id = "#{hmm_user_max.n}"
      end
     if(hmm_user_max_id == '')
         hmm_user_max_id = '0'
     end
     hmm_user_next_id= Integer(hmm_user_max_id) + 1
       @uuid =  HmmUser.find_by_sql(" select UUID() as u")
       unnid = @uuid[0]['u']
       @user.family_name="#{hmm_user_next_id}#{unnid}un#{hmm_user_next_id}"
       @user.id=hmm_user_next_id
       paths=ContentPath.find(:first,:conditions=>"status='active'")
       @user.save
       redirect_to  "#{paths.content_path}/face_book_connect_content/insert_image?image=#{facebook_session.user.pic_big}&&id=#{@user.id}&&fam_name=#{@user.family_name}"
    
    else
      @fuser = ""
      redirect_to :controller => "face_book_connect", :action => 'signup'
    end
  end

def genpass
    list=("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    genpass = ""
     1.upto(10) { |i| genpass << list[rand(list.size-1)] }
     logger.info("hai")
    logger.info(genpass)
    return genpass

end
   

end