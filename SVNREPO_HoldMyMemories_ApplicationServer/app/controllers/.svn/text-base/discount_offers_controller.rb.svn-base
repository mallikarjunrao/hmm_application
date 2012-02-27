class DiscountOffersController < ApplicationController
layout 'contest'
  def add
  end


  def create
    @discount=DiscountOffer.new
    @discount['email_address']=params[:email_address]
    @discount['first_name']=params[:first_name]
    @discount['last_name']=params[:last_name]
    @discount['contact_no']=params[:contact]
    @discount['codes']= self.genpass()
    @discount.save
    redirect_to  "/discount_offers/coupon?id=#{@discount.id}"
  end
  
  def coupon
    @special = DiscountOffer.find(:first,:conditions =>"id=#{params[:id]}")
    render :layout =>false
  end
  
  def genpass
    list=("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    genpass = ""
    1.upto(10) { |i| genpass << list[rand(list.size-1)] }
    return genpass

  end

end
