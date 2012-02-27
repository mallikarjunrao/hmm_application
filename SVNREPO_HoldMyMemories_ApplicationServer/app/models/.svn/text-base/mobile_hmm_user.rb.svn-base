class MobileHmmUser < ActiveRecord::Base

	def 
    self.table_name() "hmm_users"
  end

  def to_json
    self.attributes.to_json
  end

  def after_save
    #create default holding folder fopr the new user
    #MobileTag.save_chapter("HOLDING FOLDER", self.id,'Enter description here')
    #create studio sessions chapter for the new user
    MobileTag.save_studio_sessions_chapter(self.id)
    #create default event chapter for the new user
    MobileTag.save_mobile_uploads_chapter(self.id)
    #create default diary chapter for the new user
    #MobileTag.save_master_journal(self.id)
    
#    sql = ActiveRecord::Base.connection();
#    sql.update "insert into hmm_forum_users (user_id,user_type,group_id,user_permissions,user_perm_from,user_ip,user_regdate,username,username_clean,user_password,user_email,user_birthday,user_lastpage,user_last_confirm_key,user_lang,user_colour,user_avatar,user_sig_bbcode_uid,user_sig_bbcode_bitfield,user_from,user_icq,user_aim,user_yim,user_msnm,user_jabber,user_website,user_actkey,user_newpasswd,user_form_salt) values('#{self.id}','0','2','','','122.172.86.227','#{self.d_created_date}','#{self.v_user_name}',LOWER('#{self.v_user_name}'),MD5('#{self.v_password}'),'#{self.v_e_mail}','','','','EN','','','','','','','','','','','','','','')";
#    sql.update "insert into hmm_forum_user_group (group_id, user_id, group_leader, user_pending) values('2','#{self.id}','0','0')";

  end
end