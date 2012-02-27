class FamilyMembersController < ApplicationController
  layout "standard"
  
  
  before_filter :authenticate, :only => [ :show, :new, :create, :edit, :edit_fn, :update, :edit_familymember, :update_familymember, :familypage_step1, :familypage_step2, :familypage_step3]       
  
  def index
    list
    render :action => 'list'
  end
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
  
  def authenticate
      unless session[:hmm_user]
           flash[:notice] = 'Please Login to Access your Account'
           redirect_to :controller => "user_account" , :action => 'login'
      return false
      end
    end
  

  def list
 #   @family_members1 = FamilyMember.find(:all, :conditions => "uid=#{logged_in_hmm_user.id}")
#    @family_member_pages, @family_members = paginate :family_members, :per_page => 10
    if params[:sucess].nil? 
    else
      flash[:notice] = 'Family Information was successfully updated.'
      flash[:notice_website] = 'Congratulation your Family Website was successfully created.'
    end
  end

  def up
    previousid=params[:prev]
    currentid=params[:id]
    famax =  FamilyMember.find_by_sql("select max(id) as m from family_members")
    if(famax[0]['m']=='')
      fa_next_id=1
    else
      famax=famax[0]['m']
      fa_next_id= Integer(famax) + 1
    end
    
     sql = ActiveRecord::Base.connection();
     sql.update "UPDATE family_members SET id = #{fa_next_id}  WHERE id =#{currentid}";
     
     sql.update "UPDATE family_members SET id = #{currentid}  WHERE id =#{previousid}";
      
     sql.update "UPDATE family_members SET id = #{previousid}  WHERE id =#{fa_next_id}";
    redirect_to :action => 'list'
  
end

def down
    nextid=params[:nextid]
    currentid=params[:id]
    famax =  FamilyMember.find_by_sql("select max(id) as m from family_members")
    if(famax[0]['m']=='')
      fa_next_id=1
    else
      famax=famax[0]['m']
      fa_next_id= Integer(famax) + 1
    end
    
     sql = ActiveRecord::Base.connection();
     sql.update "UPDATE family_members SET id = #{fa_next_id}  WHERE id =#{currentid}";
     
     sql.update "UPDATE family_members SET id = #{currentid}  WHERE id =#{nextid}";
      
     sql.update "UPDATE family_members SET id = #{nextid}  WHERE id =#{fa_next_id}";
    redirect_to :action => 'list'
  
  end
  

  def show
    @family_members = FamilyMember.find(:all, :conditions => "id=#{params[:id]}")
    @uid=logged_in_hmm_user.id
    @family_member = FamilyMember.find(params[:id])
  end

  def new
    @family_member = FamilyMember.new
  end

  def create
    @family_member = FamilyMember.new(params[:family_member])
    @family_member['uid']=logged_in_hmm_user.id
#    @family_member['relation']=params[:relation]
##    
#    work from here for creating chapters
          @tag_max =  Tag.find_by_sql("select max(id) as m from tags")
           for tag_max in @tag_max
           tag_max_id = "#{tag_max.m}"
       end
       tag_max_id=Integer(tag_max_id) + 1
       @family_member['chap_id']=tag_max_id
       @family_member['member_image']=tag_max_id.to_s+"_"+params[:family_member][:img]
#       
        if(params["relation"]=="father")
           family = { :family_member => { :relation => ["father"], :Subchapters => ["Wedding", "Fathers Day","Anniversary","Birthdays"]}}
           createchapter(params["family_member"]["familymember_name"],family,params["family_member"]["member_image"],params["family_member"]["biographie"],params["relation"])

       end
        if(params["relation"]=="mother")
          family = { :family_member => { :relation => ["mother"], :Subchapters => ["Bridal or Wedding", "Mothers Day","Anniversary","Birthdays"]}}
         createchapter(params["family_member"]["familymember_name"],family,params["family_member"]["member_image"],params["family_member"]["biographie"],params["relation"])
      
       end

       
        if(params["relation"]=="brother")
          family = { :family_member => { :relation => ["brother"], :Subchapters => ["Birthdays", "Achievements","Art Work","Baby Pictures","Graduation"]}}
         createchapter(params["family_member"]["familymember_name"],family,params["family_member"]["member_image"],params["family_member"]["biographie"],params["relation"])
        
       end
       

       if(params["relation"]=="sister")
          family = { :family_member => { :relation => ["sister"], :Subchapters => ["Birthdays", "Achievements","Art Work","Baby Pictures","Graduation"]}}
         createchapter(params["family_member"]["familymember_name"],family,params["family_member"]["member_image"],params["family_member"]["biographie"],params["relation"])
         
       end 
       
        if(params["relation"]=="husband")
          family = { :family_member => { :relation => ["husband"], :Subchapters => ["wedding","Honey Moon","Anniversary","Fathers Day","Birthdays"]}}
         createchapter(params["family_member"]["familymember_name"],family,params["family_member"]["member_image"],params["family_member"]["biographie"],params["relation"])
        
       end 
       
       if(params["relation"]=="wife")
          family = { :family_member => { :relation => ["wife"], :Subchapters => ["wedding","Honey Moon","Anniversary","Mothers Day","Birthdays"]}}
         createchapter(params["family_member"]["familymember_name"],family,params["family_member"]["member_image"],params["family_member"]["biographie"],params["relation"])
        
       end
       
       if(params["relation"]=="son")
            family = { :family_member => { :relation => ["son"], :Subchapters => ["Baby Pictures","Birthdays","Achievements","Art Work","School events","Sports"]}}
         createchapter(params["family_member"]["familymember_name"],family,params["family_member"]["member_image"],params["family_member"]["biographie"],params["relation"])
         
       end
       
       if(params["relation"]=="daughter")
          family = { :family_member => { :relation => ["daughter"], :Subchapters => ["Birthdays","Achievements","Art Work","Baby Pictures","Graduation"]}}
         createchapter(params["family_member"]["familymember_name"],family,params["family_member"]["member_image"],params["family_member"]["biographie"],params["relation"])
        
       end

    
   
       
  #    redirect_to :controller => 'family_member', :action => 'list', :id => logged_in_hmm_user.id

 @family_member.save
      flash[:notice] = 'FamilyMember was successfully created.'
  redirect_to :action => 'list'
end


 def createchapter (familymember_name,family,image,biographie,relation)
    #puts family[:father][:father]
      @tag_max =  Tag.find_by_sql("select max(id) as m from tags")
    for tag_max in @tag_max
     tag_max_id = "#{tag_max.m}"
    end
    
   if(tag_max_id == '')
     tag_max_id = '0'
   end
    tag_next_id= Integer(tag_max_id) + 1
    t = Time.now
    
    #puts image
   if(image==nil or image=="" )
     image_name="blank.jpg"
   else
      
      image_name=image.original_filename
   end
   
     image_name = image_name.downcase
     image_name = image_name.gsub(" ", "_")
     image_name = image_name.gsub("(","")
     image_name = image_name.gsub(")","")
     image_name = image_name.gsub(".avi", "")
   image_name = image_name.gsub(".flv", "")
   image_name = image_name.gsub(".wmv", "")
   image_name = image_name.gsub(".mpeg", "")
   image_name = image_name.gsub(".mpg", "")
   image_name = image_name.gsub(".mov", "")
   
   
    #@tag['v_chapimage']="folder_img.png"
    #@tag.save
    
    if((relation=="father") || (relation=="mother") || (relation=="brother") || (relation=="sister") || (relation=="husband") || (relation=="wife") || (relation=="son") || (relation=="daughter"))
         @family_details = FamilyMember.new()
            @family_details['uid']=logged_in_hmm_user.id
            @family_details['chap_id']=tag_next_id
            @family_details['familymember_name']=familymember_name
            @family_details['relation']=relation
            @family_details['biographie']=biographie
            @family_details['member_image']=tag_next_id.to_s+"_"+image_name
            @family_details.save
            
       end
    
    tag_next_id.to_s+"_"+image_name
   
    @tag = Tag.new()
    @tag['id'] = tag_next_id
    @tag['v_tagname']=relation
    @tag['uid']=logged_in_hmm_user.id
    #@tag['default_tag']="no"
    @tag.e_access = 'private'
    @tag.e_visible = 'yes'
    @tag['d_updateddate']=Time.now
    @tag['d_createddate']=Time.now
    @tag['v_chapimage']=tag_next_id.to_s+"_"+image_name
   
    family[:family_member][:Subchapters].each {
    |key, value| 
    #puts "#{key} is #{value}" 
    
    @sub_chapter = SubChapter.new
    
    @sub_chapter['uid']=logged_in_hmm_user.id
    @sub_chapter['tagid']=tag_next_id
    @sub_chapter['sub_chapname']=key
    @sub_chapter['v_image']="folder_img.png"
    @sub_chapter['d_updated_on'] = t
    @sub_chapter['d_created_on'] = t
    @sub_chapter.save
    
    
     @galleries_photo = Galleries.new()
   
    
    @galleries_photo['v_gallery_name']="Photo Gallery"
    @galleries_photo['e_gallery_type']="image"
    @galleries_photo['d_gallery_date']=Time.now
    @galleries_photo['e_gallery_acess']="private"
    @galleries_photo['v_gallery_image']="picture.png"
    @galleries_photo['subchapter_id']=@sub_chapter.id
    @galleries_photo.save
    
     @galleries_audio = Galleries.new()
   
    
    @galleries_audio['v_gallery_name']="Audio Gallery"
    @galleries_audio['e_gallery_type']="audio"
    @galleries_audio['d_gallery_date']=Time.now
    @galleries_audio['e_gallery_acess']="private"
    @galleries_audio['v_gallery_image']="audio.png"
    @galleries_audio['subchapter_id']=@sub_chapter.id
    @galleries_audio.save
    
    @galleries_video = Galleries.new()
    @galleries_video['v_gallery_name']="Video Gallery"
    @galleries_video['e_gallery_type']="video"
    @galleries_video['d_gallery_date']=Time.now
    @galleries_video['e_gallery_acess']="private"
    @galleries_video['v_gallery_image']="video.png"
    @galleries_video['subchapter_id']=@sub_chapter.id
    @galleries_video.save
    }
   
    
    #@result = image_name
    
    
     if (image==nil  or image=="")
       if((relation=="father") || (relation=="brother") || (relation=="husband") || (relation=="son") )
        img1 = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/photos/blank.jpg").first
       else if ( (relation=="mother") || (relation=="sister") || (relation=="wife") || (relation=="daughter")) 
        img1 = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/photos/default_female.jpg").first
      end
      end
#        actual_height=img1.rows
#          actual_width=img1.columns
#        imgorginal = resize(img1, actual_height, actual_width,"#{RAILS_ROOT}/public/user_content/photos/#{@tag['v_chapimage']}")
#          
     else   
        FamilyMember.save1(image,tag_next_id,image_name)
        @filename =image_name
        #prepare for creating a thumbnail
        img1 = Magick::Image.read("#{RAILS_ROOT}/public/user_content/photos/#{@tag['v_chapimage']}").first
        #img1.write("#{RAILS_ROOT}/public/user_content/photos/#{hmm_user_next_id}" + "_" + "#{@filename}")
     
       
     end
  
           actual_height=img1.rows
          actual_width=img1.columns
          imageName1 = "#{@tag['v_chapimage']}"
          imageName1.slice!(-4..-1)
          @newchapterIconcoverflow = "#{imageName1}.jpg"
          @tag['v_chapimage'] = @newchapterIconcoverflow
          flexIcon = resizeWithoutBorder(img1, 320, 240, "")
          flexIcon.write("#{RAILS_ROOT}/public/user_content/photos/flex_icon/#{@newchapterIconcoverflow}")
      
          img2 = resize(img1, 72, 72,"#{RAILS_ROOT}/public/user_content/photos/big_thumb/#{@tag['v_chapimage']}")
          #img = Magick::Image.read("#{RAILS_ROOT}/public/user_content/photos/cropthumb/#{content[0].v_filename}").first
          folderImage = Magick::Image.read("#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/folder_img.png").first
          imageName = "#{@tag['v_chapimage']}"
          imageName.slice!(-4..-1)
          finalImage = folderImage.composite(img2, 4, 9, CopyCompositeOp)
          @newchapterIcon = "#{imageName}.png"
          
          
          @tag['v_chapimage'] = @newchapterIcon
          
         @tag.save
          finalImage.write("#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/#{@newchapterIcon}")
          #img2 = resize(img1, 163, 163,"#{RAILS_ROOT}/public/hmmuser/family_members/thumbs/#{@tag['v_chapimage']}")
         familymemberimage = resizeWithoutBorder(img1, 163, 163, "")
         
         familymemberimage.write("#{RAILS_ROOT}/public/hmmuser/family_members/thumbs/#{@family_details['member_image']}")
      
         
    
end  

  def edit
    @hmm_user = HmmUser.find(params[:id])
    @family_member = FamilyMember.find(:all, :conditions => "uid=#{logged_in_hmm_user.id}")
  end

  def edit_fn
    @hmm_user = HmmUser.find(params[:id])
  end
  
  def update
#    require 'pp'
    @hmm_user = HmmUser.find(params[:id])
    #code to accept family website password
    if params[:familypassword]=="no"
        params[:hmm_user][:password_required]="no"
        #params[:hmm_user][:familypassword]="NULL"
        params[:hmm_user][:familywebsite_password]=""
    else
     
        params[:hmm_user][:password_required]="yes"
    end
#  
    #code ends here for family website password
    if (params[:hmm_user][:family_pic]!='')
      @filename = params[:hmm_user][:family_pic].original_filename
      @filename = @filename.downcase
      FamilyMember.savefamily(params[:hmm_user],params[:id],"/hmmuser/familyphotos",@filename)
      img = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/familyphotos/#{params[:id]}" + "_" + "#{@filename}").first
      #r=resize(img,175,232,"#{RAILS_ROOT}/public/hmmuser/familyphotos/thumbs/#{params[:id]}" + "_" + "#{@filename}")
      #r.write("#{RAILS_ROOT}/public/hmmuser/familyphotos/thumbs/#{params[:id]}" + "_" + "#{@filename}")
      @hmm_user['family_pic']="#{params[:id]}"+"_"+"#{@filename}"
      big_thumb = resizeWithoutBorder(img,232,175,"nil")
      big_thumb.write("#{RAILS_ROOT}/public/hmmuser/familyphotos/thumbs/#{params[:id]}" + "_" + "#{@filename}")
    end
    
    params[:hmm_user][:family_pic]=@hmm_user['family_pic']
    @naming_family='"The '+"#{logged_in_hmm_user.v_lname.capitalize}"+'\'s"'
    params[:hmm_user][:familypage_image]="#{logged_in_hmm_user.id}title.png"
    #cmd to make family header image
    system("convert  -gravity north   -fill '#454545' -background transparent -font #{RAILS_ROOT}/public/Bickham2.otf  -pointsize 72 label:#{@naming_family} #{RAILS_ROOT}/public/familytitleImages/#{logged_in_hmm_user.id}title.png")
    
    if @hmm_user.update_attributes(params[:hmm_user])
      #  flash[:notice] = 'Family Information was successfully updated.'
      redirect_to :action => 'familypage_member', :id => @hmm_user
    else
      render :action => 'done', :id => params[:hmm_user][:family_name]
    end
  end
  def done
    
  end
   def validate_familyname
      color = 'red'
      familyname = params[:familyname]
        
      family = HmmUser.find(:all, :conditions => " id!='#{logged_in_hmm_user.id}' and family_name='#{params[:familyname].gsub(/('|"|\0)/, "\\\\\\1")}'")      
      if family.size > 0        
        message_family = 'Family Name already exist'
        @valid = false
      else
        message_family = 'Family Name Is Available'
        color = 'green'
       @valid=true
      end
      @message_family = "<b style='color:#{color}'>#{message_family}</b>"
    
      render :partial=>'message_family'
  end
  
  def familyimage_preview
    @hmm_user=HmmUsers.find(session[:hmm_user])
    render :layout => false
  end

  def destroying
    FamilyMember.find(params[:id]).destroy
     #FamilyMember.find_by_sql("delete from family_members where id=#{params[:id]}")
    redirect_to :action => 'list'
  end
  
  def edit_familymember
    @family_member = FamilyMember.find(params[:id])
  end
  
  
  
  def edit_familypassword
      @hmm_user = HmmUser.find(params[:id])
    render :layout => false
  end
  
  def nofamily_password
    render :layout => false
  end
  
  def addslashes(str)
  str.gsub(/['"\\\x0]/,'\\\\\0')
end

def stripslashes(str)
  str.gsub(/\\(.)/,'\1')
end

  
  def ajax_tooltip
    render :layout => false
  end
  def familypage_step1
    @hmm_user = HmmUser.find(logged_in_hmm_user.id)
    @check_familyname = HmmUser.count(:all, :conditions => "id=#{logged_in_hmm_user.id} and family_name != ''")
  end
  
  def step1_update
    #require 'pp'
    sql = ActiveRecord::Base.connection();
    @hmm_user = HmmUser.find(params[:id])
    
    if params[:familypassword]=="no"
        params[:hmm_user][:password_required]="no"
        #params[:hmm_user][:familypassword]="NULL"
        params[:hmm_user][:familywebsite_password]=""
    else
        params[:hmm_user][:password_required]="yes"
    end
   
    #puts @hmm_user
     #family website header image creation
     @naming_family='"The '+"#{logged_in_hmm_user.v_lname}"+'\'s"'
     params[:hmm_user][:familypage_image]="#{logged_in_hmm_user.id}title.png"
     #system("convert  -gravity north   -fill '#454545' -background transparent -font #{RAILS_ROOT}/public/Bickham2.otf  -pointsize 72 label:#{@naming_family} #{RAILS_ROOT}/public/familytitleImages/#{logged_in_hmm_user.id}title.png")
     #pp  params[:hmm_user]
      @check_familyname = HmmUser.count(:all, :conditions => "id=#{logged_in_hmm_user.id} and family_name != ''")
     if @check_familyname > 0
       @message = "You have made change's to your HoldMyMemories.com Family website"
     else
       @message = "Congratulations, you have set up your Family website at HoldMyMemories.com!" 
     end
#     if params[:hmm_user][:password_required]=="yes"
#       updatecheck = sql.update "UPDATE hmm_users SET password_required='#{params[:hmm_user][:password_required]}', family_name='#{params[:hmm_user][:family_name].gsub(/('|"|\0)/, "\\\\\\1")}', familywebsite_password='#{params[:hmm_user][:familywebsite_password]}', familypage_image='#{params[:hmm_user][:familypage_image]}' WHERE id = '#{logged_in_hmm_user.id}'";
#     else
#       updatecheck = sql.update "UPDATE hmm_users SET password_required='#{params[:hmm_user][:password_required]}', family_name='#{params[:hmm_user][:family_name].gsub(/('|"|\0)/, "\\\\\\1")}', familypage_image='#{params[:hmm_user][:familypage_image]}' WHERE id = '#{logged_in_hmm_user.id}'";
#     end
     link= params[:hmm_user][:family_name].capitalize
     pass_req=params[:hmm_user][:password_required]
     pass=params[:hmm_user][:familywebsite_password]
     recipent = @hmm_user.v_e_mail
     
    if @hmm_user.update_attributes(params[:hmm_user])
       Postoffice.deliver_send_sitedetails(link,pass_req,pass,recipent,@message)
       flash[:notice_step1succes] = 'Family Information was successfully updated..'
       redirect_to :action => 'familypage_step2'#, :id => logged_in_hmm_user.id
    else
      flash[:notice_step1fail] = 'Family Information was not updated..'
      redirect_to :action => 'familypage_step1'#, :id => logged_in_hmm_user.id
    end
  end
  
  def familypage_step2
    @hmm_user = HmmUser.find(logged_in_hmm_user.id)
  end
  
  
  
  def familypage_step3
     @hmm_user = HmmUser.find(logged_in_hmm_user.id)
    @count12 = params[:count]
    @chapter_count= Tag.count(:all, :conditions => "uid=#{logged_in_hmm_user.id}")
  end
  
  def familypage_members
    if params[:sucess].nil? 
      flash[:notice_step2fail] = 'Family Information was not updated..'      
    else
      flash[:notice_step2succes] = 'Family Information was successfully updated..'

    end
  end
  
    
  
  
    def choose_chapter
      @chap= Tag.find(:all, :conditions => "uid=#{logged_in_hmm_user.id} and status='active' and default_tag='yes'")
      @chap_count= Tag.count(:all, :conditions => "uid=#{logged_in_hmm_user.id} and status='active' and default_tag='yes'")
      render :layout => false
    end
  
    def choose_image
      render :layout => false
    end
    
    def chooseimage_edit
       render :layout => false
    end
    
    def choosechapter_edit
       @chap= Tag.find(:all, :conditions => "uid=#{logged_in_hmm_user.id} and status='active' and default_tag='yes'")
      @chap_count= Tag.count(:all, :conditions => "uid=#{logged_in_hmm_user.id} and status='active' and default_tag='yes'")
       render :layout => false
    end
    
    def no_chapters
      render :layout => false
    end
  
    def upload_images
     
      @user_content = UserContent.find(:all, :conditions => "uid=#{logged_in_hmm_user.id} and e_filetype='image'")
       @user_content_pages, @user_content = paginate :user_contents, :conditions => "uid=#{logged_in_hmm_user.id} and e_filetype='image'", :order =>'id desc', :per_page => 1
      render :layout => false
  end
  
  def share_familywebsite
    
  end
  
  def nonhmm_friendslist
    @status = params[:id]
    @temp = @status.split(" ")
    render :layout => false
  end
  
  def shareWorker

    if params[:message]
      @message = params[:message]
    end
    #@jtype = params[:id]
    #@temp = @jtype.split("&")
    @hmm_pass = HmmUser.find(:all, :conditions => "id=#{logged_in_hmm_user.id}")
    
    for l in @hmm_pass
      if l.password_required = 'yes'
        @password = l.familywebsite_password
      else
        @password = "no"
      end
    end
#   INSERTING HMM USERS IN SHARE'S TABLE    
    if params[:user]
      @hmmusers = params[:user]
      hmmids = @hmmusers.join(",")
      @hmmusers = HmmUsers.find(:all, :conditions => "id in (#{hmmids})") 
      for i in @hmmusers
        @share_link = "http://www.holdmymemories.com/"+logged_in_hmm_user.family_name
        @share_to= i.v_e_mail
       
        Postoffice.deliver_shareFamilywebsite(@share_to,@message,@share_link,logged_in_hmm_user.v_fname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.v_myimage,@password)
      end
    end
        
#   INSERTING NON-HMM USERS IN SHARE'S TABLE
    if params[:nhmmuser]
      @nonhmmusers = params[:nhmmuser]
      nonhmmids = @nonhmmusers.join(",")
      @nonhmm = NonhmmUser.find(:all, :conditions => "id in (#{nonhmmids})") 
      for j in @nonhmm
         @share_link = "http://www.holdmymemories.com/"+logged_in_hmm_user.family_name
        @share_to= j.v_email
        Postoffice.deliver_shareFamilywebsite(@share_to,@message,@share_link,logged_in_hmm_user.v_fname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.v_myimage,@password)
      end
  end
  
#   INSERTING E-MAIL ID'S
    if params[:email]
      @frdEmail = params[:email]
      frindsEmail=@frdEmail.split(',')
      for k in frindsEmail
        @share_link = "http://www.holdmymemories.com/"+logged_in_hmm_user.family_name
        @share_to= k
        
        Postoffice.deliver_shareFamilywebsite(@share_to,@message,@share_link,logged_in_hmm_user.v_fname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.v_myimage,@password)
      end
    end

   $share_familywebsite
   flash[:share_familywebsite] = 'Family Website was successfully Shared!!'
   redirect_to :controller => 'family_members', :action => 'list'
  end
  
end

