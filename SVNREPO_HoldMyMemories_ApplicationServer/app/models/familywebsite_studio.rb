class FamilywebsiteStudio < ActiveRecord::Base
  def self.getinfo(subchapids,type)
    subchap = Array.new
    for subchapid in subchapids
      subchap.push(subchapid.id)
    end
    galleries = Galleries.find(:all,:select =>"id",:conditions=>"	subchapter_id in (#{subchap.join(',')}) and	e_gallery_acess='public'  and status='active' and	e_gallery_type ='#{type}'",:order=>"id desc")
    for gallery in galleries
      @userimages=UserContent.find(:all,:select =>"id,img_url,v_filename,sub_chapid",:conditions=>"gallery_id=#{gallery.id} and status='active' and e_access='public'",:order=>"id desc")
      if @userimages.length > 0
        break
      end
    end
    return @userimages
  end

  def self.elligible_size_images(imgid,studio_id)
    @userimages1 = Array.new
    @userimage = Hash.new
    @get_content_url=ContentPath.find(:first, :conditions => "status='inactive'")
    content_path = @get_content_url['content_path']
    sizes = Hash.new
    img = UserContent.find(imgid)
    #image = "#{img.img_url}/user_content/photos/#{img.v_filename}"
    if(img.img_url == content_path)
      system("scp contentserver@stagingcontent1.holdmymemories.com:#{RAILS_ROOT}/public/user_content/photos/#{img.v_filename} #{RAILS_ROOT}/tmp/user_content/photos/#{img.v_filename}")
      logger.info("scp contentserver@stagingcontent1.holdmymemories.com:#{RAILS_ROOT}/public/user_content/photos/#{img.v_filename} #{RAILS_ROOT}/tmp/user_content/photos/#{img.v_filename}")
    else
      system("cp #{RAILS_ROOT}/public/user_content/photos/#{img.v_filename} #{RAILS_ROOT}/tmp/user_content/photos/#{img.v_filename}")
    end
    #system("scp contentserver@stagingcontent1.holdmymemories.com:#{RAILS_ROOT}/public/user_content/photos/#{img.v_filename} #{RAILS_ROOT}/tmp/user_content/photos/#{img.v_filename}")
    #system("scp content_path:#{RAILS_ROOT}/user_content/photos/#{img.v_filename} #{RAILS_ROOT}/tmp/user_content/photos/#{img.v_filename}")
    original_size = MiniExiftool.new "#{RAILS_ROOT}/tmp/user_content/photos/#{img.v_filename}"
    image_height = original_size.imageheight
    image_width = original_size.imagewidth
    gcdresult = gcd_of_2_numbers(image_height,image_width)
    studio = HmmStudio.find(studio_id)
    printsizeprices = PrintSizePrice.find_all_by_studio_id(studio.id)
    printsizeprices.each do |printsizeprice|
      if gcdresult && printsizeprice.aspect_ratio == "yes"
        printsize = PrintSize.find(printsizeprice.print_size_id)
        sizes = {:id=>printsize.id,:label=>printsize.label,:width=>printsize.width,:height=>printsize.height}
      else
        printsize = PrintSize.find(printsizeprice.print_size_id)
        sizes = {:id=>printsize.id,:label=>printsize.label,:width=>printsize.width,:height=>printsize.height}
      end
    end
    img1 = "#{img.img_url}/user_content/photos/#{img.v_filename}"
    @userimage = {:id=>img.id,:img_url=>img1,:file_name=>img.v_filename,:type=>"print_orders",:sizes => sizes}
    @userimages1 << @userimage
    return @userimages1
  end

  def gcd_of_2_numbers(no1,no2)
    if (no2 == 0)
      return no1
    end
    return gcd_of_2_numbers(no2,no1%no2)
  end

  def self.get_all_images(subchapids)

  end

  def self.getvideoinfo(subchapids,type)
    for subchapid in subchapids
      galleries = Galleries.find(:all,:select =>"id",:conditions=>"	subchapter_id =#{subchapid.id} and	status='active' and e_gallery_acess='public' and e_gallery_type ='#{type}'",:order=>"id desc")
      for gallery in galleries
        @userimages=UserContent.find(:first,:select =>"id,img_url,v_filename",:conditions=>"gallery_id=#{gallery.id} and	status='active'	and e_access='public'",:order=>"id desc")
        if @userimages
          break
        end
      end
      if galleries.length > 0 && @userimages
        break
      end
    end
    return @userimages
  end

end
