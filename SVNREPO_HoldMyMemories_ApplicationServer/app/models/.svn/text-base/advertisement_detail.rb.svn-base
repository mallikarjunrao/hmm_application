class AdvertisementDetail < ActiveRecord::Base
 def self.save(advertisement_detail)
    name =  advertisement_detail['v_filename'].original_filename
    directory = "public/data"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(advertisement_detail['v_filename'].read) }
  end
end
