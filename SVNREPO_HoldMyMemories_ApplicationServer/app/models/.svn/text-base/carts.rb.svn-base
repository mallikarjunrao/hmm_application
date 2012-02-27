class Carts < ActiveRecord::Base

  def self.get_digital_downloads
    sizes=PrintSize.find(:all,:select=>"id",:conditions=>"digital_download='yes'")
    size_arr=[]
    for size in sizes
      size_arr.push(size.id)
    end
    size_arr.collect! {|i| i.to_i}
    return size_arr
  end
  
end
