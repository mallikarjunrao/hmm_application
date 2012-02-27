class PaymentCountsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @payment_count_pages, @payment_counts = paginate :payment_counts, :per_page => 10
  end

  def show
    @payment_count = PaymentCount.find(params[:id])
  end

  def new
    @payment_count = PaymentCount.new
  end

  def create
    @payment_count = PaymentCount.new(params[:payment_count])
    if @payment_count.save
      flash[:notice] = 'PaymentCount was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @payment_count = PaymentCount.find(params[:id])
  end

  def update
    @payment_count = PaymentCount.find(params[:id])
    if @payment_count.update_attributes(params[:payment_count])
      flash[:notice] = 'PaymentCount was successfully updated.'
      redirect_to :action => 'show', :id => @payment_count
    else
      render :action => 'edit'
    end
  end

  def destroy
    PaymentCount.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
#  def paymentupdate
#    hmm_users = HmmUser.find(:all, :conditions => "(account_type='platinum_user' or account_type='familyws_user') and amount!=''");
#    for hmm_user in hmm_users
#        payments_received = Integer(hmm_user.payments_recieved)
#        amount = "#{hmm_user.amount}"
#        if(amount=='' or amount==nil)
#          amount = "unknown error"
#        end
#        emp_id = "#{hmm_user.emp_id}"
#        account_expdate = hmm_user.account_expdate
#        i=0
#        if(hmm_user.months == '6' || hmm_user.months == '12' )
#         payments_received = Integer(hmm_user.months)
#        end 
#        payments_received.times do
#          i=i+1
#          @payment_count = PaymentCount.new
#          @payment_count.uid = hmm_user.id
#          @payment_count.amount = amount
#          if(account_expdate==nil or account_expdate=='')
#            @hmm_user_date_of_payment_received =  HmmUser.find_by_sql(" select ADDDATE(d_created_date,INTERVAL -#{i} MONTH) as m from hmm_users where id='#{hmm_user.id}'")
#          else
#            @hmm_user_date_of_payment_received =  HmmUser.find_by_sql(" select ADDDATE(account_expdate,INTERVAL -#{i} MONTH) as m from hmm_users where id='#{hmm_user.id}'")
#          end  
#          @payment_count.recieved_on = @hmm_user_date_of_payment_received[0]['m']
#          @payment_count.account_type = hmm_user.account_type
#          @payment_count.emp_id = emp_id
#          @payment_count.save
#        end
#      end
#  end


  def payment_monthly
      mon=Time.now.strftime("%m")
      yr=Time.now.strftime("%Y")

      @moncount=Array.new
      hmm_users = HmmUser.find(:all, :conditions => "(account_type='platinum_user' or account_type='familyws_user') and amount!=''  and account_expdate > '2010-01-01' and months=6 and comission_month!='49'  ", :limit => '0,100');
      @payments_date=Array.new
      i=0
      #sql = ActiveRecord::Base.connection();
      #sql.update "delete from payment_counts where month='#{mon}'";
      for @hmm_user in hmm_users
        dt= @hmm_user.account_expdate.strftime("%d")
        hmm=HmmUser.find(@hmm_user.id)
        hmm.comission_month='49'
        hmm.save
        expperiod= @hmm_user.account_expdate.strftime("%Y%m")
        pending_count=HmmUser.find_by_sql("SELECT PERIOD_DIFF('#{expperiod}','200912') as monthcount")
        @moncount[i]="#{pending_count[0].monthcount} => #{@hmm_user.d_created_date} => #{expperiod} => 200912"
        i=i+1
        j=1
        while j <=  Integer(pending_count[0].monthcount)
              paymentcountcheck=PaymentCount.count(:all,:conditions => "uid=#{@hmm_user.id} and recieved_on='2010-#{j}-#{dt}'")
              if(paymentcountcheck == 0)
                payment_count = PaymentCount.new
                payment_count.uid = @hmm_user.id
                payment_count.amount = @hmm_user.amount
                payment_count.recieved_on = "2010-#{j}-#{dt}"
                payment_count.account_type = @hmm_user.account_type
                payment_count.emp_id = "#{@hmm_user.emp_id}"
                payment_count.month = "49"
                payment_count.save
              end
              j=j+1
        end
      end
      
      
    
    
    render :layout => false 
  end
  
end
