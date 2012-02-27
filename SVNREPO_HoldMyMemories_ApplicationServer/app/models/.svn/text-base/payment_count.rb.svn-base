class PaymentCount < ActiveRecord::Base

#  def after_save
#    @studio_percentage=HmmUser.find(:first,:select => "a.*,b.*,c.*" ,:joins=>"as a,employe_accounts as b,hmm_studios as c",:conditions=>"a.emp_id=b.id and b.store_id=c.id and a.id=#{self.uid}" )
#    if(@studio_percentage.credit_option=="yes" && @studio_percentage.credit_percentage!=nil)
#      total_amount = 0
#      total_credits = 0
#      if(self.account_type=='familyws_user')
#        @pay_count=PaymentCount.count(:all,:conditions=>"uid=#{self.uid} and amount='#{self.amount}' and account_type='familyws_user' and credit_status='active'")
#        @pay_count1=PaymentCount.count(:all,:conditions=>"uid=#{self.uid} and amount='#{self.amount}' and account_type='familyws_user'")
#        if self.amount =="$4.95"
#          amt = 4.95
#          month = 1
#          subscriptions = 1
#        elsif self.amount == "$24.95"
#          month = 6
#          amt = 24.95
#          if @pay_count1==5 && @pay_count>0
#            subscriptions=1
#          else
#            cycle = @pay_count.to_f/month.to_f # getting number of 6 months subscriptions
#            subscriptions = cycle.floor
#          end
#        elsif self.amount == "$49.95"
#          month = 12
#          amt = 49.95
#          if @pay_count1==11 && @pay_count>0
#            subscriptions=1
#          else
#            cycle = @pay_count.to_f/month.to_f # getting number of 6 months subscriptions
#            subscriptions = cycle.floor
#          end
#        end
#        credits = subscriptions * amt
#        total_credits += credits
#        subs = @pay_count.to_f/month.to_f
#        total_amount += subs.ceil * amt
#      else
#
#        @pay_count=PaymentCount.count(:all,:conditions=>"uid=#{self.uid} and amount='#{self.amount}' and account_type='platinum_user' and credit_status='active'")
#        @pay_count2=PaymentCount.count(:all,:conditions=>"uid=#{self.uid} and amount='#{self.amount}' and account_type='platinum_user'")
#        if self.amount == "$9.95"
#          amt = 9.95
#          month = 1
#          subscriptions = 1
#        elsif self.amount == "$49.95"
#          month = 6
#          amt = 49.95
#          if @pay_count2==5 && @pay_count>0
#            subscriptions=1
#          else
#            cycle = @pay_count.to_f/month.to_f # getting number of 6 months subscriptions
#            subscriptions = cycle.floor
#          end
#        elsif self.amount == "$99.95"
#          month = 12
#          amt = 99.95
#          if @pay_count2==11 && @pay_count>0
#            subscriptions=1
#          else
#            cycle = @pay_count.to_f/month.to_f # getting number of 6 months subscriptions
#            subscriptions = cycle.floor
#          end
#        end
#        credits = subscriptions * amt
#        total_credits += credits
#        subs = @pay_count.to_f/month.to_f
#        total_amount += subs.ceil * amt
#      end
#      if subscriptions==1
#        PaymentCount.update_all("credit_status='inactive'", "uid=#{self.uid}")
#
#
#        @credit_points = CreditPoint.find(:first,:conditions=>"user_id=#{self.uid}",:select=>"id,available_credits,total_amount")
#        if @credit_points
#          total_credits += @credit_points.available_credits
#          total_amount += @credit_points.total_amount
#          total_subscription +=@credit_points.total_subscription
#          total_credits_percentage = ((@studio_percentage.credit_percentage.to_f/100)*total_credits.to_f)
#          CreditPoint.update(@credit_points.id, :available_credits => total_credits_percentage, :total_amount => total_amount , :total_subscription => total_subscription)
#        else
#          total_credits_percentage = ((@studio_percentage.credit_percentage.to_f/100)*total_credits.to_f)
#          @addcredits=CreditPoint.new
#          @addcredits['user_id']=self.uid
#          @addcredits['total_amount']=total_amount
#          @addcredits['available_credits']=total_credits_percentage
#          @addcredits['total_subscription']=subscriptions
#          @addcredits.save
#        end
#      end
#
#    end
#  end
end
