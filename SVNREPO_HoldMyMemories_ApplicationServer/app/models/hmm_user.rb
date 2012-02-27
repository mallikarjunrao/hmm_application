#require 'digest/sha2'
 
class HmmUser < ActiveRecord::Base
  has_many :upload_import_counts
  has_many :order_requests
  
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

 #attr_protected :v_password, :enabled
  #attr_accessor :v_password
  

#  validates_uniqueness_of :v_user_name, :default => "has already been taken"
  validates_uniqueness_of :v_e_mail, :message => "Already Registered"
  
  #validates_uniqueness_of :family_name, :message => "Family Name Already Registered"
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

   def self.search_hmm_users(uid,query_hmm_user,page,sort,items_per_page)
        search_array=query_hmm_user.split(' ')
        conditions = "id!=#{uid} and ((v_fname LIKE '#{query_hmm_user}%' or v_lname LIKE '#{query_hmm_user}%' or v_user_name Like '#{query_hmm_user}%')"
        for i in search_array
            conditions = conditions + " or (v_fname LIKE '#{i}%' or v_lname LIKE '#{i}%' or v_user_name Like '#{i}%')"
        end
        conditions=conditions+ ")"
        #conditions = "id!=#{logged_in_hmm_user.id} and v_fname LIKE '%#{params[:query_hmm_user]}%' or v_lname LIKE '%#{params[:query_hmm_user]}%'"
        total = HmmUser.count(:conditions =>conditions)
        result = paginate :select => "id as fid, v_myimage, v_fname, img_url",  :order => sort, :per_page => items_per_page,:page => page,
        :conditions => conditions
        searchresults=Hash.new
        searchresults[:result]= result
        searchresults[:total]=  total
        return searchresults
   end

   def self.search(search, page)
    paginate :per_page => 5, :page => page,
           :conditions => ['v_fname like ?', "%#{search}%"],
           :order => 'v_fname'
   end

  def self.hmm_friends_list(uid,page,sort,items_per_page)
        total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "a.uid=#{uid} && b.id=a.fid and a.status='accepted' && a.block_status='unblock' " )
        result =paginate :select => "b.*,a.*", :joins=>"as b , family_friends  as a ", :order => sort, :per_page => items_per_page, :page => page,
        :conditions => "a.uid=#{uid} && b.id=a.fid && a.status='accepted' and a.block_status='unblock'"
        searchresults=Hash.new
        searchresults[:result]= result
        searchresults[:total]=  total
        return searchresults
  end

  def self.search_hmm_friends(uid,query,page,sort,items_per_page)
    search_array=query.split(' ')
    conditions = "a.uid=#{uid} && b.id=a.fid && b.id!=#{uid} and ((b.v_fname LIKE '#{query}%' or b.v_lname LIKE '#{query}%' or b.v_user_name LIKE '#{query}%')"
    for i in search_array
      conditions = conditions + " or (b.v_fname LIKE '#{i}%' or b.v_lname LIKE '#{i}%' or b.v_user_name LIKE '#{i}%')"
    end
    conditions=conditions+ ")"
    total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "#{conditions}")
    result = HmmUsers.paginate :select => "b.*,b.id as fid", :joins=>"as b , family_friends as a ", :order => sort, :per_page => items_per_page,:page => page, :conditions => conditions
    searchresults=Hash.new
        searchresults[:result]= result
        searchresults[:total]=  total
        return searchresults
  end


end