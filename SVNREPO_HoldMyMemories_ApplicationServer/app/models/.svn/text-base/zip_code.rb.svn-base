class ZipCode < ActiveRecord::Base
  
  # ----------------------------------------------------------------------
  # returns a collection of zip codes that are within the specified
  # radius (in miles) of the given search zip code
  # ----------------------------------------------------------------------
  
  def self.zip_code_perimeter_search(zip, radius)
    #make sure we have valid parameters
    unless zip.blank? && radius.blank?
      #look up search zip_code in database
      zip_code = ZipCode.find_by_zip_code(zip)
      #make sure we found the zip code in the database first
      unless zip_code.nil?
        radius = radius.to_f  #convert radius to float
        latitude_miles = 69.172  #this is constant
        #longitude miles varies based on latitude, that is calculated here
        longitude_miles = (latitude_miles * 
                             Math.cos(zip_code.latitude * (Math::PI/180))).abs
        latitude_degrees = radius/latitude_miles  #radius in degrees latitude
        longitude_degrees = radius/longitude_miles  #radius in degrees longitude

        #now set min and max lat and long accordingly
        min_latitude = zip_code.latitude - latitude_degrees
        max_latitude = zip_code.latitude + latitude_degrees
        min_longitude = zip_code.longitude - longitude_degrees
        max_longitude = zip_code.longitude + longitude_degrees
        
        #now find all zip codes that are within 
        #these min/max lat/long bounds and return them
        #weed out any zip codes that fall outside of the search radius
        return ZipCode.find(:all,
              :select => "id, 
                          zip_code, 
                          latitude, 
                          longitude,
                          sqrt( pow(#{latitude_miles} *
                                  (latitude-#{zip_code.latitude}),2) + 
                                pow(#{longitude_miles} * 
                                  (longitude-#{zip_code.longitude}),2)) 
                                as distance",
              :conditions => "(latitude BETWEEN #{min_latitude} 
                                AND #{max_latitude}) 
                              AND (longitude BETWEEN #{min_longitude} 
                                AND #{max_longitude}) 
                              AND sqrt(pow(#{latitude_miles} * 
                                (latitude-#{zip_code.latitude}),2) + 
                                pow(#{longitude_miles} * 
                                  (longitude-#{zip_code.longitude}),2)) 
                                <= #{radius}",
              :order => "distance")
      else
        return nil
      end
    else
      return nill
    end
  end
  
end
