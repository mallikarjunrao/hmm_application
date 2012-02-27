class SocialNetworkingsController < ApplicationController
  layout "admin"
   require 'will_paginate'
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @social_networking_pages, @social_networkings = paginate :social_networkings, :per_page => 10
  end

  def show
    @social_networking = SocialNetworking.find(params[:id])
  end

  def new
    @social_networking = SocialNetworking.new
  end

  def create
    @websitename = HmmUser.find(:all, :conditions => "id='#{params[:id]}'")
    @countsocial_networking = SocialNetworking.count(:all, :conditions => "uid='#{params[:id]}'")
    puts params[:type]
    if @countsocial_networking > 0
      @findsocial_networking = SocialNetworking.find(:all, :conditions => "uid='#{params[:id]}'")
      @social_networking = SocialNetworking.find(@findsocial_networking[0]['id'])
      @social_networking['uid']=params[:id]
      @social_networking['family_website']=@websitename[0]['family_name']
      if params[:type]=="facebook"
        if (@findsocial_networking[0]['facebook_count'] == '' || @findsocial_networking[0]['facebook_count'] == nil)
          count = 1
        else
          count = @findsocial_networking[0]['facebook_count'] + 1
        end
        @social_networking['facebook_count']= count
      end
      if params[:type]=='myspace'
        if (@findsocial_networking[0]['myspace_count'] == '' || @findsocial_networking[0]['myspace_count'] == nil)
          count = 1
        else
          count = @findsocial_networking[0]['myspace_count'] + 1
        end
        @social_networking['myspace_count']=count
      end
      
      if params[:type]=='twitter'
         if (@findsocial_networking[0]['twitter_count'] == '' || @findsocial_networking[0]['twitter_count'] == nil)
          count = 1
        else
          count = @findsocial_networking[0]['twitter_count'] + 1
        end
        @social_networking['twitter_count']=count
      end
      if params[:type]=='other'
         if (@findsocial_networking[0]['other_count'] == '' || @findsocial_networking[0]['other_count'] == nil)
          count = 1
        else
          count = @findsocial_networking[0]['other_count'] + 1
        end
        @social_networking['other_count']=count
      end
      @social_networking['linked_date']=Time.now
      @social_networking.save
    else
      @social_networking = SocialNetworking.new()
      @social_networking['uid']=params[:id]
      @social_networking['family_website']=@websitename[0]['family_name']
      
      if params[:type]=="facebook"
        @social_networking['facebook_count']=1
      end
      if params[:type]=='myspace'
        @social_networking['myspace_count']=1
      end
      if params[:type]=='twitter'
        @social_networking['twitter_count']=1
      end
      if params[:type]=='other'
        @social_networking['other_count']=1
      end
      @social_networking['linked_date']=Time.now
      @social_networking.save
    end
    
    render :text => "true", :layout=>false
    return true
  end


  def create_sharecount
    @websitename = HmmUser.find(:all, :conditions => "id='#{params[:id]}'")
    @countsocial_networking = SocialNetwork.count(:all, :conditions => "uid='#{params[:id]}' and share_type='#{params[:type]}' and date_format(created_at,'%Y-%m-%d')=CURDATE() ")
    logger.info("share count :#{@countsocial_networking}")
    if(@countsocial_networking>0)
      @det=SocialNetwork.find(:first,:conditions=>"uid='#{params[:id]}' and share_type='#{params[:type]}' and date_format(created_at,'%Y-%m-%d')=CURDATE()")
      @det['share_counts']=@det['share_counts']+1
      @det.save
    else
      @det=SocialNetwork.new()
      @det['uid']=params[:id]
      @det['share_type']=params[:type]
      @det['share_counts']=1
      @det.save
    end

    render :text => "true", :layout=>false
    return true
  end

  def edit
    @social_networking = SocialNetworking.find(params[:id])
  end

  def update
    @social_networking = SocialNetworking.find(params[:id])
    if @social_networking.update_attributes(params[:social_networking])
      flash[:notice] = 'SocialNetworking was successfully updated.'
      redirect_to :action => 'show', :id => @social_networking
    else
      render :action => 'edit'
    end
  end

  def destroy
    SocialNetworking.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def display_counts

    @facebook=SocialNetworking.sum(:facebook_count)

    @myspace=SocialNetworking.sum(:myspace_count)

    @twitter=SocialNetworking.sum(:twitter_count)

    @other=SocialNetworking.sum(:other_count)


  end


   def share_counts_list

    @facebook=SocialNetwork.sum(:share_counts,:conditions=>"share_type='facebook'")

    @myspace=SocialNetwork.sum(:share_counts,:conditions=>"share_type='myspace'")

    @twitter=SocialNetwork.sum(:share_counts,:conditions=>"share_type='twitter'")

    @other=SocialNetwork.sum(:share_counts,:conditions=>"share_type='other'")

   if (params[:fyy]!=nil && params[:fmm] !=nil && params[:fdd] !=nil && params[:tyy] !=nil && params[:tmm] !=nil && params[:tdd] !=nil && params[:fyy]!='' && params[:fmm] !='' && params[:fdd] !='' && params[:tyy] !='' && params[:tmm] !='' && params[:tdd] !=''
       )

     
     from_yr=params[:fyy]
     from_mon=params[:fmm]
     from_date=params[:fdd]

      fromdate="#{from_yr}-#{from_mon}-#{from_date}"

      to_yr=params[:tyy]
      to_mon=params[:tmm]
      to_date=params[:tdd]


      todate="#{to_yr}-#{to_mon}-#{to_date}"

      session[:condition1]= "and created_at  between '#{fromdate} 00:00:00' and '#{todate} 23:59:59' "
    end
    
    if(params[:share_type]!='' && params[:share_type]!=nil)
       session[:condition2]=" and share_type='#{params[:share_type]}'"
     
    else
      session[:condition2]=""
    end
    
    unless params[:cpg].blank?
       
       session[:condition]=""
      session[:condition1]=""
      session[:condition2]=""
    else
       session[:condition]="#{session[:condition1]} #{session[:condition2]}"
   
    end
     logger.info("search :#{session[:condition]}")

   @cnts = SocialNetwork.count(:all,:conditions => " 1=1 #{session[:condition]} ")

   @dets = SocialNetwork.paginate :per_page => 50, :page => params[:page], :conditions => " 1=1 #{session[:condition]} ", :order => "id desc"


  end


end
