class PaymentDetailsController < ApplicationController
layout "admin"
require 'rubygems'
require 'net/ftp'
require 'fileutils'
  require 'will_paginate'
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @payment_details = PaymentDetail.paginate :per_page => 10, :page => params[:page]
  end

  def show
    @payment_detail = PaymentDetail.find(params[:id])
  end

  def new
    @payment_detail = PaymentDetail.new
  end

  def create
    @payment_detail = PaymentDetail.new(params[:payment_detail])
    if @payment_detail.save
      flash[:notice] = 'PaymentDetail was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @payment_detail = PaymentDetail.find(params[:id])
  end

  def update
    @payment_detail = PaymentDetail.find(params[:id])
    if @payment_detail.update_attributes(params[:payment_detail])
      flash[:notice] = 'PaymentDetail was successfully updated.'
      redirect_to :action => 'show', :id => @payment_detail
    else
      render :action => 'edit'
    end
  end

  def destroy
    PaymentDetail.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def process_orders
    @pending_orders_count = PaymentDetail.count(:all, :conditions => "order_process_status='pending'")
    @pending_orders = PaymentDetail.find(:all, :conditions => "order_process_status='pending'")
  end
  
  def process_prints 
    @print = PaymentDetail.find(:all, :conditions => "id='#{params[:id]}'")
    
    
    
@user_contentids = []
for i in @print
  @order_id =i.order_id
  @order = OrderDetail.find(:all, :conditions => "order_unid='#{i.order_id}'")
  for j in @order
    if j.moment_type=='chap'
      @print_moments = UserContent.find(:all, :conditions => "tagid='#{j.moment_id}' and e_filetype='image'" ,:order =>'id asc')
      for k in @print_moments
      @user_contentids.push(k.v_filename)
      end
    elsif j.moment_type=='subchapter'
      @print_moments = UserContent.find(:all, :conditions => "sub_chapid='#{j.moment_id}' and e_filetype='image'" ,:order =>'id asc')
      for l in @print_moments
        @user_contentids.push(l.v_filename)
      end
    elsif j.moment_type=='gallery'
      @print_moments = UserContent.find(:all, :conditions => "gallery_id='#{j.moment_id}' and e_filetype='image'",:order =>'id asc')
      for m in @print_moments
        @user_contentids.push(m.v_filename)
      end
    elsif j.moment_type=='moment'
      @print_moments = UserContent.find(:all, :conditions => "id='#{j.moment_id}'")
      @user_contentids.push(@print_moments[0]['v_filename'])
    end
  end
end
  @filenames = @user_contentids.join(' ')
 
 @filenames = system("tar -cvf "+@order_id+".tar "+@filenames)
  
    
    
#    @URL = '12.156.60.97'
#    username = 'farooq'
#    passwd = "farooqkuntoji"
#    filename = "54_image001.jpg"
#    directory = '/home/web/content.holdmymemories.com/user_content/photos/journal_thumb/'
#    localfile = 'C:\\Documents and Settings\\User1\\Desktop\\54_image001.jpg'
#    ftp=Net::FTP.new
#    ftp.connect(@URL,22)
#    ftp.login(username,passwd)
#    ftp.chdir(directory)
#    ftp.getbinaryfile(filename,localfile)
#    ftp.close
  end
  
  def process_shipment
    
  end
  



  
end
