class MobileApnNotification < ActiveRecord::Base
  def
    self.table_name() "apn_notifications"
  end


  def self.return_new_reminders(params)
    reminders = MobileApnNotification.find(:all,:joins=>"INNER JOIN apn_devices on apn_notifications.device_id = apn_devices.id",:conditions=>"apn_devices.token='#{params[:device_token]}' and apn_notifications.user_id = #{params[:user_id]} and apn_notifications.created_at > '#{params[:updated_date]}'",:select =>"apn_notifications.id as reminder_id,alert as label,DATE_FORMAT(apn_notifications.created_at,'%c/%e/%Y %T') as created_date,DATE_FORMAT(send_at,'%c/%e/%Y') as reminder_date,DATE_FORMAT(send_at,'%T') as reminder_time,repeat_on,DATE_FORMAT(repeat_time,'%T') as reminder_repeat_time")
    if reminders.length > 0
      return reminders
    else
      return nil
    end
  end

  def self.return_updated_reminders(params)
    reminders = MobileApnNotification.find(:all,:joins=>"INNER JOIN apn_devices on apn_notifications.device_id = apn_devices.id",:conditions=>"apn_devices.token='#{params[:device_token]}' and apn_notifications.user_id = #{params[:user_id]} and apn_notifications.updated_at > '#{params[:updated_date]}' AND apn_notifications.created_at <= '#{params[:updated_date]}'",:select =>"apn_notifications.id as reminder_id,alert as label,DATE_FORMAT(apn_notifications.created_at,'%c/%e/%Y %T') as created_date,DATE_FORMAT(send_at,'%c/%e/%Y') as reminder_date,DATE_FORMAT(send_at,'%T') as reminder_time,DATE_FORMAT(repeat_time,'%T') as reminder_repeat_time,repeat_on")
    if reminders.length > 0
      return reminders
    else
      return nil
    end
  end

end