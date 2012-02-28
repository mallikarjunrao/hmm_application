class BlockedTime < ActiveRecord::Base
  
    def self.process_date( _date, order_times, isadmin, store_id )
        blocks = BlockedTime.find( :all, :conditions => {:block_on => _date, :store_id => store_id} )
        custom_errors = ''
        for block in blocks
            if isadmin=='no'
                order_times = order_times - HALF_HOUR_TIMES[ block.start_time .. block.end_time ]
            end
            custom_errors += "<p>#{ block.error_message }</p>"
        end
        return order_times, custom_errors
    end

    def self.get_time_slot_by_time(order_time, store_id)

        if order_time >= 17 && order_time <= 20
            time_slot = 1
        elsif order_time >= 21 && order_time <= 24
            time_slot = 2
        elsif order_time >= 25 && order_time <= 28
            time_slot = 3
        elsif order_time >= 29 && order_time <= 32
            time_slot = 4
        elsif order_time >= 33 && order_time <= 36
            time_slot = 5
        elsif order_time >= 37 && order_time <= 41
            time_slot = 6
        end

        return (store_id == 1)? time_slot : (time_slot + 6)
    end

    def self.process_max_order_new( _date, order_day, isadmin, order_time, store_id )

        blocks = OrderCount.find( :all, :select=>"SUM(no_of_orders) as total", :conditions => ["store_id = ? AND date = ? AND prod_win_id = ? ", store_id, _date, BlockedTime.get_time_slot_by_time(order_time.to_i, store_id)] )

        maximun_orders = 0
        
        special_orders = TimeslotWindow.find(:first, :conditions => ["id=? ", BlockedTime.get_time_slot_by_time(order_time.to_i, store_id)])

        if order_day == 'Monday'
            maximun_orders = special_orders.mon
        elsif order_day == 'Tuesday'
            maximun_orders = special_orders.tue
        elsif order_day == 'Wednesday'
            maximun_orders = special_orders.wed
        elsif order_day == 'Thursday'
            maximun_orders = special_orders.thu
        elsif order_day == 'Friday'
            maximun_orders = special_orders.fri
        elsif order_day == 'Saturday'
            maximun_orders = special_orders.sat
        elsif order_day == 'Sunday'
            maximun_orders = special_orders.sun
        end
        
        remaincake =  maximun_orders.to_i - blocks[0].total.to_i

        status = 0
                
        if remaincake < 12
          status = 1
        else
          status = 0
        end
        
        return status, remaincake, isadmin

    end

    

    def self.process_max_order( _date, order_times, order_day, isadmin, store_id )

        remove_time = Array.new

        loop_start = (store_id == 1)? 1 : 7
       
        #for ti in (1..12)
        for ti in (loop_start..(loop_start+5))

            blocks = OrderCount.find( :all, :select=>"SUM(no_of_orders) as total", :conditions => ["store_id = ? AND date = ? AND prod_win_id = ? ", store_id, _date, ti] )
            
            maximun_orders=0
            #special_orders = SpecialProdWindow.find(:first, :conditions => ["day=? and prod_win_id=? ", order_day, ti])
            #if special_orders!=nil
            # maximun_orders = special_orders.max_orders
            # else
            special_orders = TimeslotWindow.find(:first, :conditions => ["id=? ", ti])

            if order_day == 'Monday'
                maximun_orders = special_orders.mon
            elsif order_day == 'Tuesday'
                maximun_orders = special_orders.tue
            elsif order_day == 'Wednesday'
                maximun_orders = special_orders.wed
            elsif order_day == 'Thursday'
                maximun_orders = special_orders.thu
            elsif order_day == 'Friday'
                maximun_orders = special_orders.fri
            elsif order_day == 'Saturday'
                maximun_orders = special_orders.sat
            elsif order_day == 'Sunday'
                maximun_orders = special_orders.sun
            end
            #end
            remaincake =  maximun_orders.to_i - blocks[0].total.to_i
            if remaincake <= 12

                if ti==1 || ti==7
                    a=17
                    b=20
                elsif ti==2 || ti==8
                    a=21
                    b=24
                elsif ti==3 || ti==9
                    a=25
                    b=28
                elsif ti==4 || ti==10
                    a=29
                    b=32
                elsif ti==5 || ti==11
                    a=33
                    b=36
                elsif ti==6 || ti==12
                    a=37
                    b=41
                end

                if isadmin=='no'
                    #order_times = order_times - HALF_HOUR_TIMES[a .. b]
                end
                remove_time += HALF_HOUR_TIMES[a .. b]
            end

        end
        return order_times , remove_time

    end

end
