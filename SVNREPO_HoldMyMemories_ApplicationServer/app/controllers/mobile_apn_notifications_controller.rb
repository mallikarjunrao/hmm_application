class MobileApnNotificationsController < ApplicationController
  require 'json/pure'
  before_filter :response_header # add json header to the output
  layout false

  def response_header
    response.headers['Pragma' ] = 'no-cache'
    response.headers['Cache-Control' ] = 'no-store, no-cache, max-age=0, must-revalidate'
    response.headers['Content-Type' ] = 'text/x-json'
  end

  #input:device_token,message,reminder date,reminder time,repeat_on
  
  def add_reminder
    @retval = Hash.new()    
    if !params[:device_token].blank? && !params[:message].blank? && !params[:user_id].blank?
      device = MobileApnDevice.find(:first,:conditions=>"token='#{params[:device_token]}'")
      unless(device)
        @device = MobileApnDevice.new()
        @device.token = params[:device_token]
        @device.save()
        device_id = @device.id
      else
        device_id = device.id
      end
      @reminder = MobileApnNotification.new
      @reminder.device_id = device_id      
      @reminder.alert = params[:message]
      @reminder.user_id = params[:user_id]
      @reminder.sound = params[:sound]
      if !params[:reminder_date].blank?
        @reminder.send_at = params[:reminder_date]
        # @reminder.send_at = Time.p(params[:reminder_date])
      else
        @reminder.repeat_on = params[:repeat_on]
        @reminder.repeat_time = params[:repeat_time]
      end
      if @reminder.save()        
        if !params[:updated_date].blank?
          @retval['body'] = self.synchronize_reminders(params)
          @retval['status'] = true
        else
          @retval['message'] = 'Reminder added successfully!'
          @retval['status'] = false
        end
        
      else
        @retval['message'] = 'Reminder addition failed!'
        @retval['status'] = false
      end
      
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    render :text => @retval.to_json # render output
  end

  def update_reminder
    @retval = Hash.new()
    if !params[:device_token].blank? && !params[:message].blank? && !params[:user_id].blank? && !params[:reminder_id].blank? && !params[:updated_date].blank?
      device = MobileApnDevice.find(:first,:conditions=>"token='#{params[:device_token]}'")
      unless(device)
        @device = MobileApnDevice.new()
        @device.token = params[:device_token]
        @device.save()
        device_id = @device.id
      else
        device_id = device.id
      end
      @reminder = Hash.new
      @reminder[:device_id] = device_id
      @reminder[:alert] = params[:message]
      @reminder[:user_id] = params[:user_id]
      @reminder[:sound] = params[:sound]
      if !params[:reminder_date].blank?
        @reminder[:send_at] = params[:reminder_date]
        # @reminder.send_at = Time.p(params[:reminder_date])
      else
        @reminder[:repeat_on] = params[:repeat_on]
        @reminder[:repeat_time] = params[:repeat_time]
      end
      if MobileApnNotification.update(params[:reminder_id],@reminder)
        @retval['message'] = 'Reminder updated successfully!'
        @retval['body'] = self.synchronize_reminders(params)
        @retval['status'] = true
      else
        @retval['message'] = 'Reminder updation failed!'
        @retval['status'] = false
      end

    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    render :text => @retval.to_json # render output
  end


  


  def get_reminders
    @retval = Hash.new()
    if !params[:device_token].blank? && !params[:user_id].blank?
      reminders = MobileApnNotification.find(:all,:joins=>"INNER JOIN apn_devices on apn_notifications.device_id = apn_devices.id",:conditions=>"apn_devices.token='#{params[:device_token]}' and apn_notifications.user_id = #{params[:user_id]}",:select =>"apn_notifications.id as reminder_id,alert as label,DATE_FORMAT(apn_notifications.created_at,'%c/%e/%Y %T') as created_date,DATE_FORMAT(send_at,'%c/%e/%Y') as reminder_date,DATE_FORMAT(send_at,'%T') as reminder_time,DATE_FORMAT(repeat_time,'%T') as reminder_repeat_time,repeat_on")
      @retval['body'] = reminders
      @retval['count'] = reminders.length
      @retval['status'] = true     
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    @retval['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    @retval['type'] = params[:type]
    render :text => @retval.to_json # render output
  end

  def delete_reminders
    @retval = Hash.new()
    if !params[:selected_ids].blank? && !params[:updated_date].blank? && !params[:user_id].blank? && !params[:device_token].blank?
      ids = JSON.parse(params[:selected_ids])
      delete_ids = Array.new
      for id in ids
        temp = Hash.new()
        temp[:reminder_id] = id
        delete_ids.push(temp)
      end
      reminder_ids = ids.join(',')      
      if MobileApnNotification.delete_all("id in (#{reminder_ids})")
        reminders = self.synchronize_reminders(params)
        reminders[:deleted_records] = delete_ids
        @retval['body'] = reminders
        @retval['status'] = true
        @retval['type'] = params[:type]
      else
        @retval['message'] = 'Reminders deletion failed!'
        @retval['status'] = false
      end
    else
      @retval['message'] = 'Incomplete details provided!'
      @retval['status'] = false
    end
    render :text => @retval.to_json # render output
  end

  def synchronize_reminders(params)
    if !params[:user_id].blank? && !params[:device_token].blank? && !params[:updated_date].blank?
      reminders = Hash.new()
      @new = MobileApnNotification.return_new_reminders(params)
      if @new != nil
        reminders['new_records'] = @new
      end
      @updated = MobileApnNotification.return_updated_reminders(params)
      if @updated != nil
        reminders['updated_records'] = @updated
      end      
      reminders['updated_time'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      return reminders
    else
      return false
    end
  end
  
end