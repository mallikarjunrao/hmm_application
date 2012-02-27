class StudioBenefitsController < ApplicationController
  layout 'admin'

  before_filter :authenticate_admin, :only => [:admin_list, :admin_add,:admin_edit, :admin_delete,:select_group]

 
  before_filter :login_common, :only => [:list, :add,:edit, :delete]


  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to :controller => 'account', :action => 'login'
      return false
    end
  end


   def login_franchise_check
      unless session[:franchise]
           flash[:notice] = 'Please Login to Access Franchise Admin Account'
           redirect_to :controller => 'account', :action => 'franchise_login'
      return false
      end
  end

   def login_common
      unless session[:franchise] ||  session[:manager]
           flash[:notice] = 'Please Login to Access Franchise Admin Account'
           redirect_to :controller => 'account', :action => 'franchise_login'
      return false
      end
  end
   def list
    if(params[:studio_id]=='' || params[:studio_id]==nil || params[:studio_id]=='0')
       @benefits = StudioBenefit.find(:all,:conditions => "(studio_id=0 and studio_group_id=#{session[:franchise]})",:select => "*")
    else
      @benefits = StudioBenefit.find(:all,:conditions => "(studio_id=#{params[:studio_id]} and studio_group_id=0)",:select => "*")
    end

  end

  def add

    @studios=HmmStudio.find(:all,:conditions=>"studio_groupid=#{session[:franchise]}")


     unless params[:benefits].blank?
        @benefit = StudioBenefit.new()

        if(params[:studio_id]=='0' || params[:studio_id]==0)
          @benefit['studio_id']=0
          @benefit['studio_group_id']=session[:franchise]
        else
          @benefit['studio_id']=params[:studio_id]
          @benefit['studio_group_id']=0
        end

        if(params[:benefits]=='other')
        @benefit['content']=params[:content]
        else
        @benefit['content']=params[:benefits]
        end
        @benefit.save
        flash[:notice] = "Studio Benefit added successfully"
        redirect_to :action => "list", :studio_id =>params[:studio_id]
     end
  end

  def edit

    @studios=HmmStudio.find(:all,:conditions=>"studio_groupid=#{session[:franchise]}")

    @benefit=StudioBenefit.find(params[:id])

    if(params[:content]!='' && params[:content]!=nil)
    if(params[:studio_id]=='0' || params[:studio_id]==0)
          @benefit['studio_id']=0
          @benefit['studio_group_id']=session[:franchise]
        else
          @benefit['studio_id']=params[:studio_id]
          @benefit['studio_group_id']=0
    end
    @benefit['content']=params[:content]
    @benefit.save
    flash[:notice] = "Studio Benefit successfully Updated"
    redirect_to :action => "list", :studio_id =>params[:studio_id]

    end

  end


  def delete
    @std=StudioBenefit.find(params[:id])
    StudioBenefit.delete(params[:id])
    flash[:notice] = "Studio Benefit successfully Deleted"
    redirect_to :action => 'list' ,:studio_id=>@std.studio_id
  end


  #Admin Section otpion
  def select_group
    @studio_groups=HmmStudiogroup.find(:all)
    unless params[:studio_group_id].blank?
      session[:group_id]=params[:studio_group_id]
      flash[:notice] = "Studio Group successfully Selected"
      redirect_to :action => 'admin_list'
    end
  end


  def admin_list
    @stdgrp=HmmStudiogroup.find(session[:group_id])
    if(params[:studio_id]=='' || params[:studio_id]==nil || params[:studio_id]=='0')
       @benefits = StudioBenefit.find(:all,:conditions => "(studio_id=0 and studio_group_id=#{session[:group_id]})",:select => "*")
    else
      @benefits = StudioBenefit.find(:all,:conditions => "(studio_id=#{params[:studio_id]} and studio_group_id=0)",:select => "*")
    end

  end

  def admin_add

    @studios=HmmStudio.find(:all,:conditions=>"studio_groupid=#{session[:group_id]}")
    @stdgrp=HmmStudiogroup.find(session[:group_id])

     unless params[:benefits].blank?
        @benefit = StudioBenefit.new()

        if(params[:studio_id]=='0' || params[:studio_id]==0)
          @benefit['studio_id']=0
          @benefit['studio_group_id']=session[:group_id]
        else
          @benefit['studio_id']=params[:studio_id]
          @benefit['studio_group_id']=0
        end

        if(params[:benefits]=='other')
        @benefit['content']=params[:content]
        else
        @benefit['content']=params[:benefits]
        end
        @benefit.save
        flash[:notice] = "Studio Benefit added successfully"
        redirect_to :action => "admin_list", :studio_id =>params[:studio_id]
     end
  end

  def admin_edit

    @studios=HmmStudio.find(:all,:conditions=>"studio_groupid=#{session[:group_id]}")
    @stdgrp=HmmStudiogroup.find(session[:group_id])
    @benefit=StudioBenefit.find(params[:id])

    if(params[:content]!='' && params[:content]!=nil)
    if(params[:studio_id]=='0' || params[:studio_id]==0)
          @benefit['studio_id']=0
          @benefit['studio_group_id']=session[:group_id]
        else
          @benefit['studio_id']=params[:studio_id]
          @benefit['studio_group_id']=0
    end
    @benefit['content']=params[:content]
    @benefit.save
    flash[:notice] = "Studio Benefit successfully Updated"
    redirect_to :action => "admin_list", :studio_id =>params[:studio_id]

    end

  end


  def admin_delete
    @std=StudioBenefit.find(params[:id])
    StudioBenefit.delete(params[:id])
    flash[:notice] = "Studio Benefit successfully Deleted"
    redirect_to :action => 'admin_list' ,:studio_id=>@std.studio_id
  end


end