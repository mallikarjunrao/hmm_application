class NotificationWorker < BackgrounDRb::MetaWorker
  
  set_worker_name :notification_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
    add_periodic_timer(60) { send_notification }
  end

  def send_notification
 notifications = APN::Notification.all(:conditions => "(sent_at is NULL and send_at is NOT NULL and CONVERT_TZ(send_at,'SYSTEM','+00:00')<=CONVERT_TZ(CURRENT_TIMESTAMP(),'SYSTEM','+00:00'))
OR ((sent_at is NULL OR DATE_FORMAT(CONVERT_TZ(sent_at,'SYSTEM','+00:00'),'%Y-%m-%d')<DATE_FORMAT(CONVERT_TZ(CURRENT_TIMESTAMP(),'SYSTEM','+00:00'),'%Y-%m-%d'))
AND DATE_FORMAT(CONVERT_TZ(repeat_time,'SYSTEM','+00:00'),'%h:%i:%s')<=DATE_FORMAT(CONVERT_TZ(CURTIME(),'SYSTEM','+00:00'),'%h:%i:%s') AND
(repeat_on=DATE_FORMAT(CONVERT_TZ(CURRENT_TIMESTAMP(),'SYSTEM','+00:00'),'%w') OR repeat_on=7))")
      APN::Notification.send_notifications(notifications)
  end
end

