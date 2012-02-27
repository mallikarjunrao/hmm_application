class FamilyMember < ActiveRecord::Base
  
   def self.save(hmm_user,max_id,dir,filename)
    name =  "#{max_id}"+"_"+filename

     
    #v_filename = hmm_user['v_myimage'].original_filename
    #self.content_type= advertisement_detail['v_filename'].original_filename
    directory = "public"+dir
    # create the file path
    path = File.join(directory, name)
   # hmm_user['v_myimage'].original_filename.thumbnail(200, 200)
    # write the file
    File.open(path, "wb") { |f| f.write(hmm_user['v_myimage'].read) }
    
  end
  
   def self.savefamily(hmm_user,max_id,dir,filename)
    name =  "#{max_id}"+"_"+filename

     
    #v_filename = hmm_user['v_myimage'].original_filename
    #self.content_type= advertisement_detail['v_filename'].original_filename
    directory = "public"+dir
    # create the file path
    path = File.join(directory, name)
   # hmm_user['v_myimage'].original_filename.thumbnail(200, 200)
    # write the file
    File.open(path, "wb") { |f| f.write(hmm_user['family_pic'].read) }
    
  end

def self.savemember(hmm_user,max_id,dir,filename)
    name =  "#{max_id}"+"_"+filename

     
    #v_filename = hmm_user['v_myimage'].original_filename
    #self.content_type= advertisement_detail['v_filename'].original_filename
    directory = "public"+dir
    # create the file path
    path = File.join(directory, name)
   # hmm_user['v_myimage'].original_filename.thumbnail(200, 200)
    # write the file
    File.open(path, "wb") { |f| f.write(hmm_user['member_image'].read) }
    
  end
  
  def self.save1(obj,id,name)
    name =  "#{id}_#{name}"
   
    #v_filename = user_content['v_filename[]'].original_filename
    #self.content_type= advertisement_detail['v_filename'].original_filename
    directory = "public/user_content/photos"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(obj.read) }
    return "true"
  end
  
   def self.decode(json)
        YAML.load(convert_json_to_yaml(json))
      rescue ArgumentError => e
        raise ParseError, "Invalid JSON string"
      end
end
