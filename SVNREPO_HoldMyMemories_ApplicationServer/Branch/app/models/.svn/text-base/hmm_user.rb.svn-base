#require 'digest/sha2'

class HmmUser < ActiveRecord::Base
 # file_column :v_myimage, :magick => {:versions => { "thumb" => "1000x1000", "medium" => "640x480>" }}
#      :versions => { "thumb" => "50x50", "medium" => "640x480>" }
# file_column :image, :magick => { :geometry => "78*79>" }
#validates_presence_of :email
#validates_presence_of :v_password, :if => :password_required?
#validates_presence_of :confirm_password#, :if => :password_required?
#validates_confirmation_of :v_password#, :if => :password_required?

#validates_length_of :username, :within => 3..64
#validates_length_of :email, :within => 5..128
#validates_length_of :password, :within => 4..20, :if => :password_required?
#validates_length_of :profile, :maximum => 1000
#def before_save
#self.hashed_password = User.encrypt(password) if !self.password.blank?
#end
#def password_required?
#self.hashed_password.blank? || !self.password.blank?
#end

 attr_protected :v_password, :enabled
  attr_accessor :v_password
  validates_uniqueness_of :v_user_name, :default => "has already been taken"
  validates_uniqueness_of :v_e_mail, :message => "Already Registered"
 # validates_uniqueness_of :family_name, :header_message => "Please Try Again!", :message => "has already been taken"
#  def check_users
#    attr_protected :v_password, :enabled
#    attr_accessor :v_password
#    
#    validates_presence_of :v_user_name
#    if(validates_uniqueness_of :v_user_name, :case_sensitive => false)
#      return false
#    else
#      if (validates_uniqueness_of :v_e_mail, :case_sensitive => false)
#       return false
#      else
#       return true
#     end
#   end
# end
  
  def self.authenticate(username, password)
    find_by_v_user_name_and_v_password(username,password)
  end


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
  
  def self.save_mesgboard_img(obj,id,name)
    name =  "#{id}_#{name}"
   
    #v_filename = user_content['v_filename[]'].original_filename
    #self.content_type= advertisement_detail['v_filename'].original_filename
    directory = "public/hmmuser/message_board"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(obj.read) }
    return "true"
  end
  
  def self.savefm(obj,id,name)
    name =  "#{id}_#{name}"
   
    #v_filename = user_content['v_filename[]'].original_filename
    #self.content_type= advertisement_detail['v_filename'].original_filename
    directory = "public/user_content/photos/journal_thumb"
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