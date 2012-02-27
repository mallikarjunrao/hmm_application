class Cart < ActiveRecord::Base
 def self.image_price(account_type,img_date,pricelt72,actual_price)
    if account_type =="platinum_user"
      logger.info(Time.parse(img_date))
      diff = Time.now.to_time - Time.parse(img_date)
        logger.info("diff")
       logger.info(diff)
      if ((diff.to_i/86400) < 3)
        if !pricelt72.nil?
          @price=pricelt72
        else
          @price=actual_price
        end
      else
        @price=actual_price
      end
    else
      @price=actual_price
    end
    return @price
  end
end