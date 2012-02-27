class OrderRequestController < ApplicationController

  def process_request
    ids=params[:id].split("_")
    @order_request_status = OrderRequestStatus.find(ids[0])
    @order = OrderRequest.find(@order_request_status.visitor_id)
    @owner = HmmUser.find(@order.owner_id)
  end

  def approve_status
    #ids=params[:id].split("_")
    @order_request_status = OrderRequestStatus.find(params[:id])
    @order = OrderRequest.find(@order_request_status.visitor_id)
    #owner = HmmUser.find(@order.owner_id)
    code = nil
    code = set_code(@order_request_status.id)
    code = code.downcase
    @path = ContentPath.find(:all)
    @order_request_status.update_attributes(:status=>params[:selected_value])
    #if @order.request_code == nil
    @order.update_attributes(:request_code=>code)
    #end
    if @order_request_status.status == "approved"
      owner = HmmUser.find(@order_request_status.owner_id)
      Postoffice.deliver_request_approval(@order.email_address,@path[0].proxyname,code,@order.requested_by,owner.family_name)
    else
      Postoffice.deliver_request_approval_rejected(@order.email_address,@order.requested_by)
    end
    flash[:notice] = "Your approval is successfully updated"
    redirect_to :action=>"process_request",:id=>params[:id]
  end

  def set_code(id)
    randomstr = nil
    randomstr = id.to_s + "OR" + gen_random
    return randomstr
  end

  def gen_random(size=6)
    chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'
    shorturl = ''
    srand
    size.times do
      pos = rand(chars.length)
      shorturl += chars[pos..pos]
    end
    return shorturl
  end

  def visitor_login

  end

  def login
    #@path = ContentPath.find(:first, :conditions => "status='inactive'")
    unless params[:username] == "" or params[:password] == ""
      #if params[:sub_bt]
      username=params[:username]
      password=params[:password]
      #visitor_record=OrderRequest.find(:first,:conditions=>"email_address='#{username}' and request_code='#{password}'") rescue nil
      visitor_record = OrderRequest.find_by_email_address_and_request_code(username,password) rescue nil
      logger.info "+++++++++++++++++++++++++++++"
      logger.info visitor_record.inspect
      logger.info "+++++++++++++++++++++++++++++"
      unless visitor_record.nil?
        if visitor_record.email_address == username and visitor_record.request_code == password
          logger.info "8888888888888888888888888888888888888888"
          visitor_accounts = OrderRequestStatus.find_all_by_visitor_id(visitor_record.id)
          logger.info "00000000000000000000000000000000000000"
          logger.info visitor_accounts.inspect
          logger.info "00000000000000000000000000000000000000"
          if visitor_accounts.size > 1
            hmmuser=HmmUser.find(:first,:conditions=>"id=#{visitor_record.owner_id}")
            session[:vistor_id]=visitor_record.id
            redirect_to :action => "visitor_accounts", :id => session[:vistor_id]
          else
            hmmuser=HmmUser.find(:first,:conditions=>"id=#{visitor_record.owner_id}")
            if hmmuser.studio_id!=0
              ver=HmmStudio.find(hmmuser.studio_id)
              if ver.family_website_version==3
                session[:visitor_id]=visitor_record.id
                redirect_to "/studio_session_orders/print_orders/#{hmmuser.family_name}"
              elsif ver.family_website_version==4
              #  @paths = ContentPath.find(:first,:conditions=>"status='active'")
                @contents = UserContent.find(:first, :conditions => "e_filetype= 'image' and status='active' and e_access='public' and uid=#{hmmuser.id}",:group => "id", :order=>"sub_chapid desc")
                redirect_to "/family_memory/order_prints/#{hmmuser.family_name}?moment_id=#{@contents.id}"
              end
            end
            logger.info hmmuser.inspect
             
            #redirect_to "/carts/cart_list/#{hmmuser.family_name}"
          end
        end
      else
        logger.info "+++++++++++++visitor login page++++++++++++++++"
        redirect_to :action => "visitor_login"
        flash[:notice] = "Wrong Username or Password"
      end
      #end
    else
      redirect_to :action => "visitor_login"
      flash[:notice] = "Wrong Username or Password"
    end
  end

  def visitor_accounts
    if session[:visitor_id] or params[:id]
      @path = ContentPath.find(:first, :conditions => "status='active'")
      @visitor = OrderRequest.find(params[:id])
      @visitor_accounts = OrderRequestStatus.find_all_by_visitor_id(@visitor.id)
    else
      redirect_to :action=>"visitor_login"
    end
  end

end