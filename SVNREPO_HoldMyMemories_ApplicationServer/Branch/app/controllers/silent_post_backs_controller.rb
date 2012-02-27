
class SilentPostBacksController < ApplicationController
  # http://www.mydomain.com/silent_post_back
  def create
    # Don't process postbacks that aren't for arb subscriptions
     return render(:text => 'hi') if params[:x_subscription_id].nil?

     case params[:x_response_code].to_i
       when ActiveMerchant::Billing::AuthorizeNetGateway::APPROVED
         handleApprovedPayment(params)
       when ActiveMerchant::Billing::AuthorizeNetGateway::DECLINED
         handleDeclinedPayment(params)
       when ActiveMerchant::Billing::AuthorizeNetGateway::ERROR
         handlePaymentError(params)
       when ActiveMerchant::Billing::AuthorizeNetGateway::FRAUD_REVIEW
         handleFraudReviewPayment(params)
     end
  end
  
  private
  
  def handleApprovedPayment(params)
   puts "Send email to customer and notify them sucessful payment received."
      hmm_user = HmmUser.find(:all, :conditions => "subscriptionnumber='#{params[:x_subscription_id]}'")
      hmmuser=HmmUser.find(hmm_user[0]['id'])
      acctype = hmmuser.account_type
      hmmuser.account_type="platinum_user"
      @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL 1 MONTH) as m")
      account_expdate= @hmm_user_max[0]['m']
      hmmuser.account_expdate = account_expdate
      count=Integer(hmm_user[0]['payments_recieved'])
      hmmuser.payments_recieved= count + 1
      hmmuser.save
      if(hmmuser.save)
        #Postoffice.deliver_paymentdeclained("#{hmmuser.v_fname}  #{hmmuser.v_lname}" , "#{hmmuser.v_e_mail}" , hmmuser.v_user_name, hmmuser.invoicenumber, acctype,hmmuser.months,hmmuser.amount, "#{params[:x_subscription_id]}","Payment Declined")
      end
  end
  
  def handleDeclinedPayment(params)
    #save_arb_report(params, "Payment Declined")
    
    puts "Send email to customer and notify them to update the credit card."
      hmm_user = HmmUser.find(:all, :conditions => "subscriptionnumber='#{params[:x_subscription_id]}'")
      hmmuser=HmmUser.find(hmm_user[0]['id'])
      acctype = hmmuser.account_type
      hmmuser.account_type="platinum_user"
      @hmm_user_max =  HmmUser.find_by_sql(" select CURDATE() as m")
      account_expdate= @hmm_user_max[0]['m']
      hmmuser.account_expdate = account_expdate
      hmmuser.substatus = 'suspended'
      hmmuser.cancel_status = 'approved'
      hmmuser.canceled_by = '-2'
      hmmuser.suspended_date = Time.now
      hmmuser.save
      if(hmmuser.save)
        Postoffice.deliver_paymentdeclained("#{hmmuser.v_fname}  #{hmmuser.v_lname}" , "#{hmmuser.v_e_mail}" , hmmuser.v_user_name, hmmuser.invoicenumber, acctype,hmmuser.months,hmmuser.amount, "#{params[:x_subscription_id]}","Payment Declined")
      end
    
  end
  
  def handlePaymentError(params)
    #save_arb_report(params, "Payment Error")
  end
  
  def handleFraudReviewPayment(params)
    #save_arb_report(params, "Fraud Review Required")
    puts "Send email to admin for fraud review"
  end
  
#  def save_arb_report(params, status)
#    ArbStatus.create(:x_subscription_paynum => params[:x_subscription_paynum], 
#                     :x_subscription_id => params[:x_subscription_id],
#                     :status => status)
#                   
#  end
end


