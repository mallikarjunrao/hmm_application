class GiftCertificatesController < ApplicationController
  layout "admin"
  helper :sort
  include SortHelper
  require 'will_paginate'
  include ApplicationHelper
  include UserSessionHelper

  #ssl_required :all


  before_filter :authenticate_common_admin_emp, :only => [ :new_gift_certificate, :generate_certificate, :get_studios, :manage_gift_certificates,:view_studios, :view_redemption, :remove_certificate ,  :studio_certificates_details,  :redeem_certificate, :view_certificates_details, :excel_studio_certificates_details]

  def authenticate_emp
    unless session[:employe]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "https://holdmymemories.com/account/employe_login"
      return false
    end
  end

  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to :action => 'login'
      return false
    end
  end

  def authenticate_common_admin_emp
    unless  session[:user] || session[:employe]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to "https://holdmymemories.com/account/login"
      return false
    end
  end


  def new_gift_certificate
    @membership_terms=MembershipTerm.find(:all,:conditions=>"status='active'")
    if session[:store_id]
      studio=HmmStudio.find(:first,:conditions=>"id=#{session[:store_id]}")
      @studiogroups=HmmStudiogroup.find(:all,:conditions=>"status='active' and id=#{studio.studio_groupid}")
    else
      @studiogroups=HmmStudiogroup.find(:all,:conditions=>"status='active'")
    end

    if params[:Submit]=="Submit"
      certificate=GiftCertificate.new
      certificate.certificate_id=params[:certificate_id]
      certificate.membership_term_id=params[:membership_term_id]
      certificate.certificate_price=params[:certificate_price]
      certificate.certificate_name=params[:certificate_name]
      if params[:membership_option]=="yes"
        membership_fee=MembershipTerm.find(:first,:conditions=>"status='active' and id=#{params[:membership_term_id]}")
        total_fee=membership_fee.charge.to_f + params[:certificate_price].to_f
      else
        total_fee= params[:certificate_price].to_f
      end
      certificate.total_price=total_fee
      certificate.disclaimer_notes=params[:disclaimer_notes]
      certificate.studiogroup_id=params[:studiogroup_id]
      certificate.membership_option=params[:membership_option]
      if session[:employe]
        certificate.created_by="Employee"
        certificate.created_studio=session[:store_id]
        certificate.employee_name=session[:employe_name]
      else
        certificate.created_by="Admin"
        certificate.created_studio=0
        certificate.employee_name="Admin"
      end
      certificate.save

      for i in 0..params[:description].length-1
        desc=GiftCertificateDescription.new
        desc.gift_certificates_id=certificate.id
        desc.description=params[:description][i]
        desc.save
      end

      for i in 0..params[:studio_id].length-1
        stud=GiftCertificateStudio.new
        stud.gift_certificates_id=certificate.id
        stud.studio_id=params[:studio_id][i]
        stud.save
      end
      redirect_to "/gift_certificates/manage_gift_certificates"
    end
  end

  #  def update_price
  #    membership_terms=MembershipTerm.find(:first,:conditions=>"status='active' and id=#{params[:mem_id]}")
  #    res=""
  #    value=membership_terms.charge + 1
  #    res=res.concat("<input type='checkbox' name='studio_id[]' value='#{k.id}' checked='yes' >&nbsp;&nbsp;#{k.studio_name}<br>")
  #    render :text => res
  #  end


  def generate_certificate
    @certificate_id=self.genpass()
    #@certificates=GiftCertificate.find(:first,:conditions=>"studio_id=8")
    @disclaimer_notes=params[:disclaimer_notes]
    @studiogroup_id=params[:studiogroup_id]
    if params[:membership_option]=="yes"
      membership_fee=MembershipTerm.find(:first,:conditions=>"status='active' and id=#{params[:membership_term_id]}")
      @total_fee=membership_fee.charge.to_f + params[:certificate_price].to_f
    else
      @total_fee=params[:certificate_price].to_f
    end
    @studs=Array.new
    for i in 0..params[:studio_id].length-1
      @studs.push(params[:studio_id][i])
    end
    @studs=@studs.join(",")
    @studios=HmmStudio.find(:all,:conditions=>"id in(#{@studs})")
  end

  def genpass
    list=("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    genpass = ""
    1.upto(10) { |i| genpass << list[rand(list.size-1)] }
    return genpass

  end

  def get_studios
    if !params[:owner_id].blank?
      owner_ids = params[:owner_id].split(",")
      owner_ids = owner_ids.join(",")
      @hmmstudiocnt=HmmStudio.count(:all,:conditions=>"studio_groupid in (#{owner_ids})")
      if session[:store_id]
        #for employee
        @hmmstudios=HmmStudio.find(:all,:conditions=>"id='#{session[:store_id]}'", :order => "studio_groupid ASC")
      else
        @hmmstudios=HmmStudio.find(:all,:conditions=>"studio_groupid in (#{owner_ids})", :order => "studio_groupid ASC")
      end
    else
      @hmmstudios = 0
    end

    if(!@hmmstudiocnt.nil? && @hmmstudiocnt > 0)
      res=""
      if params[:studio_id] && params[:studio_id]!=""
        stud=params[:studio_id].split(",")
      end
      logger.info("stud.inspect")
      logger.info(stud.inspect)
      studio_first = @hmmstudios[0].studio_groupid
      for k in @hmmstudios
        if studio_first != k.studio_groupid
          studio_first = k.studio_groupid
          res=res.concat("------------<br>")
        end
        if stud!=nil
          if stud.include?(k.id.to_s)
            res=res.concat("<input type='checkbox' name='studio_id[]' value='#{k.id}' checked='yes' >&nbsp;&nbsp;#{k.studio_name}<br>")
          else
            res=res.concat("<input type='checkbox' name='studio_id[]' value='#{k.id}'>&nbsp;&nbsp;#{k.studio_name}<br>")
          end
        else
          res=res.concat("<input type='checkbox' name='studio_id[]' value='#{k.id}'>&nbsp;&nbsp;#{k.studio_name}<br>")
        end

      end
      res=res.concat("<a href='javascript:select(1)'>Check all</a> |<a href='javascript:select(0)'>Uncheck all</a><br>")

    else
      res="No Studios Found"
    end

    render :text => res
  end


  def manage_gift_certificates
    sort_init 'id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order1]==nil)
        sort = "a.id desc"
        sort1= "id desc"
      else
        sort = "#{session[:srk1]}  #{params[:sort_order]}"
      end
    else
      session[:sort_order1]=params[:sort_order]
      session[:srk1]=params[:sort_key]
      sort = "#{session[:srk1]}  #{params[:sort_order]}"
    end

    if params[:certificate_id] && params[:certificate_id]!=''
      cond1 ="and certificate_id LIKE '%#{params[:certificate_id]}%'"
    else
      cond1 =''
    end

    if session[:store_id]
      @certificates= GiftCertificate.paginate :per_page => 20, :page => params[:page],:select=>"a.*",:conditions=>"a.status='active'  and a.id=c.gift_certificates_id and c.studio_id=#{session[:store_id]} #{cond1}",:joins=>"as a,gift_certificate_studios as c",:order => sort
    else
      @certificates= GiftCertificate.paginate :per_page => 20, :page => params[:page],:conditions=>"status='active'  #{cond1}",:order => sort1
    end
  end

  def view_studios
    @studios=GiftCertificateStudio.find(:all,:conditions=>"gift_certificates_id=#{params[:id]}")
  end

  def view_redemption
    sort_init 'id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order2]==nil)
        sort = "a.id desc"
      else
        sort = "#{session[:srk2]}  #{params[:sort_order]}"
      end
    else
      session[:sort_order2]=params[:sort_order]
      session[:srk2]=params[:sort_key]
      sort = "#{session[:srk2]}  #{params[:sort_order]}"
    end
    @customers=CustomerOrderCertificate.find(:all,:select=>"a.*,b.certificate_id as cid,b.certificate_price,c.studio_name",:conditions=>"b.id=#{params[:id]} and a.certificate_id=b.id and a.status='redeemed' and c.id=a.studio_id",:joins=>"as a,gift_certificates as b,hmm_studios as c",:order=>sort)
  end

  def remove_certificate
    studios=GiftCertificate.find(:first,:conditions=>"id=#{params[:id]}")
    studios.status="inactive"
    studios.save
    redirect_to "/gift_certificates/manage_gift_certificates"
  end

  def studio_certificates_details
    if params[:t] == "1"
      session[:search_cond]=""
    end
    sort_init 'id'
    sort_update
 
    if( params[:sort_key] ==nil )
      session[:key1] = "id"
      session[:sort_order]="desc"
      sort = "#{session[:key1]}  #{params[:sort_order]} "
    else
      session[:sort_order]=params[:sort_order]
      session[:key1]=params[:sort_key]
      sort = "#{session[:key1]}  #{params[:sort_order]} "
    end

    @certificate_names=GiftCertificate.find(:all,:conditions=>"status='active' and certificate_name is not null and certificate_name!=''")
  
    cond0="1=1"

    if params[:certificate_id] && params[:certificate_id]!=''
      cond2="and b.certificate_id='#{params[:certificate_id]}'"
    else
      cond2=''
    end

    if session[:store_id]
      cond1="and c.studio_id=#{session[:store_id]}"
    else
      cond1=''
    end
    if params[:first_name] && params[:first_name]!=''
      cond3="and a.first_name like '#{params[:first_name]}%'"
    else
      cond3=''
    end
    if params[:last_name] && params[:last_name]!=''

      cond4="and a.last_name like '#{params[:last_name]}%'"
    else
      cond4=''
    end
    if params[:email] && params[:email]!=''

      cond5="and a.email like '#{params[:email]}%'"
    else
      cond5=''
    end
    if params[:order_no] && params[:order_no]!=''

      cond6="and a.order_no = '#{params[:order_no]}'"
    else
      cond6=''
    end
    if params[:status] && params[:status]!=''
      cond7="and a.status = '#{params[:status]}'"
    else
      cond7=''
    end
    if params[:certifiate_id] && params[:certifiate_id]!=''
      cond8="and b.id = '#{params[:certifiate_id]}'"
    else
      cond8=''
    end
    session[:sort]=sort

    if(params[:status] == nil && params[:order_no]== nil &&  params[:email]== nil && params[:last_name]== nil &&  params[:first_name] == nil && params[:certificate_id]== nil)
      if params[:t] == 1
        session[:search_cond]="a.certificate_id=b.id and b.id=c.gift_certificates_id"
      end
    else
      session[:search_cond]="#{cond0} #{cond1} #{cond2} #{cond3} #{cond4} #{cond5}  #{cond6} #{cond7} #{cond8} and a.certificate_id=b.id and b.id=c.gift_certificates_id"
    end
    @customers=CustomerOrderCertificate.paginate :per_page => 25, :page => params[:page],:joins=>"as a,gift_certificates as b,gift_certificate_studios as c",:select=>"a.*,b.certificate_id as cid,b.certificate_price,b.certificate_name",
      :conditions =>"#{session[:search_cond]}",:group=>"a.id", :order => sort 
    render :layout => true
  end


  def redeem_certificate
    cert=CustomerOrderCertificate.find(:first,:conditions=>"id=#{params[:id]}")
    cert.status="redeemed"
    if session[:store_id]
      cert.redeemed_studio=session[:store_id]
      cert.employee_name=session[:employe_name]
    else
      #Admin
      cert.redeemed_studio=0
      cert.employee_name="Admin"
    end
    cert.redeemed_date=Date.today
    cert.save
    redirect_to "/gift_certificates/studio_certificates_details"
  end

  def view_certificates_details
    @customer=CustomerOrderCertificate.find(:first,:joins=>"as a,gift_certificates as b",:select=>"a.*,b.certificate_id as cid",:conditions=>"a.id=#{params[:id]} and a.certificate_id=b.id")
  end

  def excel_studio_certificates_details
    begin
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="Gift_certificate.xls"'
      headers['Cache-Control'] = ''
    rescue
      logger.info("unable to create excel sheet for these records")
    end
    @customers=CustomerOrderCertificate.find(:all,:joins=>"as a,gift_certificates as b,gift_certificate_studios as c",:select=>"a.*,b.certificate_id as cid,b.certificate_price",
      :conditions=>"#{session[:search_cond]}",:group=>"a.id",:order => session[:sort])
    render :layout=>false
  end
  protected
  def ssl_required?
    true
  end

end