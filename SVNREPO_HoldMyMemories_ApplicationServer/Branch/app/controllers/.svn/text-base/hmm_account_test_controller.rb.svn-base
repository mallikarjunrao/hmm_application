class HmmAccountTestController < ApplicationController
  
  layout "standard"
  
  require 'rubygems'
  

  
  include SortHelper
  helper :sort
  include SortHelper
  helper :customers
  include CustomersHelper
  #require 'VO/Content'
 
  def index1
  end
  

def create
     t = Time.now
     content_path = params[:content_path]
     #get the hmm_user next id to be inserted
     @hmm_user_max =  HmmUser.find_by_sql("select max(id) as n from hmm_users")
     for hmm_user_max in @hmm_user_max
      hmm_user_max_id = "#{hmm_user_max.n}"
     end
     if(hmm_user_max_id == '')
      hmm_user_max_id = '0'
     end
     hmm_user_next_id= Integer(hmm_user_max_id) + 1

    #get the next id of tag to be inserted
    @tag_max =  Tag.find_by_sql("select max(id) as m from tags")
    for tag_max in @tag_max
     tag_max_id = "#{tag_max.m}"
    end
    if(tag_max_id == '')
     tag_max_id = '0'
    end
    tag_next_id= Integer(tag_max_id) + 1

    # get next id of subchapter to be inserted
    @subchapter_max =  SubChapter.find_by_sql("select max(id) as n from sub_chapters")
    for subchapter_max in @subchapter_max
      subchapter_max_id = "#{subchapter_max.n}"
    end
    if(subchapter_max_id == '')
      subchapter_max_id = '0'
    end
    subchapter_next_id= Integer(subchapter_max_id) + 1

    #get the next id of tag to be inserted
    @galleries_max =  Galleries.find_by_sql("select max(id) as m from galleries")
    for galleries_max in @galleries_max
     galleries_max_id = "#{galleries_max.m}"
    end
    if(galleries_max_id == '')
     galleries_max_id = '0'
    end
    galleries_next_id= Integer(galleries_max_id) + 1

    #get the next id of user content to be inserted
    @usercontents_max =  UserContent.find_by_sql("select max(id) as m from user_contents")
    for usercontents_max in @usercontents_max
     usercontents_max_id = "#{usercontents_max.m}"
    end
    if(usercontents_max_id == '')
     usercontents_max_id = '0'
    end
    usercontents_next_id= Integer(usercontents_max_id) + 1
    
    #get the next id for fnf_groups
    @fnfGroup_max =  FnfGroups.find_by_sql("select max(id) as m from fnf_groups")
    for fnfGroup_max in @fnfGroup_max
     fnfGroup_max_id = "#{fnfGroup_max.m}"
    end
    if(fnfGroup_max_id == '')
     fnfGroup_max_id = '0'
    end
    fnfGroup_next_id= Integer(fnfGroup_max_id) + 1
    
    #get the next id for friends and family
    @fnf_max =  FamilyFriend.find_by_sql("select max(id) as m from family_friends")
    for fnf_max in @fnf_max
     fnf_max_id = "#{fnf_max.m}"
    end
    if(fnf_max_id == '')
     fnf_max_id = '0'
    end
    fnf_next_id= Integer(fnf_max_id) + 1
    
    #get the next id for friends and family
    @fnf_max1 =  FamilyFriend.find_by_sql("select max(id) as n from family_friends")
    for fnf_max1 in @fnf_max1
     fnf_max_sawp_id = "#{fnf_max1.n}"
    end
    if(fnf_max_sawp_id == '')
     fnf_max_sawp_id = '0'
    end
    fnf_sawp_next_id= Integer(fnf_max_sawp_id) + 2
    

    #Start preparing for creating the user from here
    @hmm_user = HmmUser.new(params[:hmm_user])
    @hmm_user['id']=hmm_user_next_id
    @hmm_user['v_password']=params[:hmm_user][:v_password]
    kwn=''
    
   #code for "How Did you know about hmm?"
   if params[:fnfhmm]
     kwn=kwn+params[:fnfhmm]
      @hmm_user['refral']=params[:hmm_user][:refral]
      end
   if params[:google]
      kwn=kwn+","+params[:google]
       end
    if params[:s121]
       kwn=kwn+","+params[:s121]
      end 
    if params[:add]
       kwn=kwn+","+ params[:add]
     end
    if params[:others12]
       kwn=kwn+","+ params[:others12]
    end
   #code ends here for know hmm?
    
    #code to accept family website password
    if params[:familypassword]
        @hmm_user['familywebsite_password']=params[:hmm_user][:familywebsite_password]
        @hmm_user['password_required']='yes'
    else
      
    end
    #code ends here for family website password
  
    @hmm_user['knowhmm']=kwn
    img_type=params[:hmm_user][:v_myimage]
    if (params[:hmm_user][:v_myimage]!='')
   
     @filename = removeSymbols(params[:hmm_user][:v_myimage].original_filename)
     @filename = @filename.downcase
     
     @hmm_user['v_myimage']="#{hmm_user_next_id}"+"_"+"#{@filename}"
    else if params[:e_sex]=='M'
      @filename = "blank.jpg"
      @hmm_user['v_myimage']="blank.jpg"
    else
      @filename = "default_female.jpg"
      @hmm_user['v_myimage']="default_female.jpg"

     end 
   end
   
   #starting to prepare family information
    @hmm_user['family_name']=params[:hmm_user][:family_name]
    
    if (params[:hmm_user][:family_pic]!='')
      @filename_family = removeSymbols(params[:hmm_user][:family_pic].original_filename)
      @filename_family = @filename_family.downcase
      @hmm_user['family_pic']="#{hmm_user_next_id}"+"_"+"#{@filename_family}"
    else
      @filename_family = "defaultfamily.jpg"
      @hmm_user['family_pic']="defaultfamily.jpg"
    end
      
    @hmm_user['about_family']=params[:hmm_user][:about_family]
    @hmm_user['family_history']=params[:hmm_user][:family_history]
    
    
    # Start preparing for a new tag to be created
    @tag = Tag.new()
    @tag['id'] = tag_next_id
    @tag['v_tagname']="Un-Categorized"
    @tag['uid']=@hmm_user.id
    @tag['default_tag']="no"
    @tag.e_access = 'private'
    @tag.e_visible = 'yes'
    @tag['d_updateddate']=t
    @tag['d_createddate' ]=t
    @tag['img_url']=content_path
    #@tag['v_chapimage']=@hmm_user['v_myimage']
    if @tag['v_tagname'] == 'Un-Categorized'
      @tag['v_chapimage'] = "#{tag_next_id}"+"_"+"#{@hmm_user['v_myimage']}"
      
    end
    #@tag.save

    # Start preparing for a new sub chapter to be created
    @sub_chapter = SubChapter.new
    @sub_chapter['id'] = subchapter_next_id
    @sub_chapter['uid']=@hmm_user.id
    @sub_chapter['tagid']=@tag.id
    @sub_chapter['sub_chapname']="Sub chapter"
    @sub_chapter['v_image']="folder_img.png"
    @sub_chapter['d_updated_on'] = t
    @sub_chapter['d_created_on'] = t
    @sub_chapter['img_url']=content_path
    #@sub_chapter.save

    # Start preparing for a new gallery to be created
    @galleries1 = Galleries.new()
    @galleries1['id'] = galleries_next_id
    img_gal=@galleries1['id']
    @galleries1['v_gallery_name']="Default Image Gallery"
    @galleries1['e_gallery_type']="image"
    @galleries1['d_gallery_date']=Time.now
    @galleries1['e_gallery_acess']="private"
    @galleries1['v_gallery_image']="picture.png"
    @galleries1['subchapter_id']=@sub_chapter.id
    @galleries1['img_url']=content_path
    #@galleries1.save
    
    # Start preparing for a new gallery to be created
    @galleries2 = Galleries.new()
    @galleries2['id'] = galleries_next_id + 1
    @galleries2['v_gallery_name']="Default Audio Gallery"
    @galleries2['e_gallery_type']="audio"
    @galleries2['d_gallery_date']=Time.now
    @galleries2['e_gallery_acess']="private"
    @galleries2['v_gallery_image']="audio.png"
    @galleries2['subchapter_id']=@sub_chapter.id
    @galleries2['img_url']=content_path
    #@galleries2.save
    
    # Start preparing for a new gallery to be created
    @galleries3 = Galleries.new()
    @galleries3['id'] = galleries_next_id + 2
    @galleries3['v_gallery_name']="Default Video Gallery"
    @galleries3['e_gallery_type']="video"
    @galleries3['d_gallery_date']=Time.now
    @galleries3['e_gallery_acess']="private"
    @galleries3['v_gallery_image']="video.png"
    @galleries3['subchapter_id']=@sub_chapter.id
    @galleries3['img_url']=content_path
    
   # @galleries3.save


    # Start preparing for a new usercontent to be created
    @user_content = UserContent.new()
    @user_content['id'] = usercontents_next_id 
    @user_content['e_access'] = "private"
    @user_content['e_filetype'] = "image"
    @user_content['v_tagname']="Un-Categorized"
    @user_content['v_tagphoto']="Un-Categorized"
    @user_content['uid']=@hmm_user.id
    @user_content['sub_chapid']=subchapter_next_id
    @user_content['gallery_id']= img_gal
    #@user_content['v_filename']="#{usercontents_next_id}"+"_"+"#{@hmm_user['v_myimage']}"
    @user_content['tagid']=@tag['id']
    @user_content['d_createddate'] = t #.strftime("%Y:%m:%d %H:%M:%S")
    @user_content['d_momentdate'] = t #.strftime("%Y:%m:%d %H:%M:%S")
    @user_content['img_url']=content_path
    
    #@user_content.save
    @hmm_user.d_updated_date = Time.now
    @hmm_user.d_created_date = Time.now
    @hmm_user['img_url']=content_path

    # Start Preparing Category for bob
#    @fnf_group = FnfGroups.new()
#    @fnf_group['id'] = fnfGroup_next_id
#    @fnf_group['fnf_category'] = 'manage'
#    @fnf_group['uid'] = @hmm_user.id

    #creating family image
    if (params[:hmm_user][:family_pic]!='')
      HmmUser.savefamily(params['hmm_user'],hmm_user_next_id,"/hmmuser/familyphotos", @filename_family)
       
#      HmmUser.save(params['hmm_user'],hmm_user_next_id,"/hmmuser/photos", @filename_family)
      img_family = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/familyphotos/#{hmm_user_next_id}" + "_" + "#{@filename_family}").first
     
#      originaldate_family = img_family.get_exif_by_entry('DateTimeOriginal')
      
#      if(originaldate_family[0][1] == nil || originaldate_family[0][1] == 'unknown')
#          t_family = Time.now
#      else
#         datetime_family = originaldate_family[0][1].split(" ")
#         if(datetime_family[1]==nil)
#            t_family=Time.now
#         else
#            date_family = datetime_family[0].split(":")
#            time_family = datetime_family[1].split(":")
#            t_family = Time.utc(date_family[0],date_family[1],date_family[2],time_family[0],time_family[1],time_family[2])
#          #t = Time.utc(2000,"jan",1,20,15,1)
#          #2007:02:16 13:18:05
#         end 
#      end
##     @user_content['d_createddate'] = t_family
#     
#   else
#     img_family = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/photos/thumb/defaultfamily.jpg").first
#   end 
   actual_height_family=img_family.rows
   actual_width_family=img_family.columns
   
#   origianl_family=resize(img_family,actual_height_family,actual_width_family,"#{RAILS_ROOT}/public/user_content/photos/#{hmm_user_next_id}" + "_" + "#{@filename_family}")
   
    @filename1_family=removeSymbols(@filename_family)
        
        @filename1 = @filename1_family.downcase
     @filename1_family = @filename1_family.gsub(" ", "_")
     @filename1_family = @filename1_family.gsub("(","")
     @filename1_family = @filename1_family.gsub(")","")
     @filename1_family = @filename1_family.gsub(".avi", "")
   @filename1_family = @filename1_family.gsub(".flv", "")
   @filename1_family = @filename1_family.gsub(".wmv", "")
   @filename1_family = @filename1_family.gsub(".mpeg", "")
   @filename1_family = @filename1_family.gsub(".mpg", "")
   @filename1_family = @filename1_family.gsub(".mov", "")
      
      if (params[:hmm_user][:family_pic]!='')
           img_family = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/familyphotos/#{hmm_user_next_id}" + "_" + "#{@filename_family}").first
         else
            img_family = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/familyphotos/thumbs/defaultfamily.jpg").first
          end
          hmm_familyimage=resize(img_family,232,175,"#{RAILS_ROOT}/public/hmmuser/familyphotos/thumbs/#{hmm_user_next_id}"+"_"+"#{@filename_family}")
          
          hmm_familyimage.write("#{RAILS_ROOT}/public/hmmuser/familyphotos/thumbs/#{hmm_user_next_id}" + "_" + "#{@filename1_family}")
          big_thumb = resizeWithoutBorder(img_family,175,232,"nil")
          big_thumb.write("#{RAILS_ROOT}/public/hmmuser/familyphotos/thumbs/#{hmm_user_next_id}" + "_" + "#{@filename1_family}")

     end     
     #end of creating family image 
    
     #Before inserting a user lets insert his image to the database
     if (params[:hmm_user][:v_myimage]!='')
       HmmUser.save(params['hmm_user'],hmm_user_next_id,"/hmmuser/photos", @filename)
       #HmmUser.save(params['hmm_user'],hmm_user_next_id,"/user_content/photos")
     #@filename = params[:hmm_user][:v_myimage].original_filename
     #prepare for creating a thumbnail
     img1 = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/photos/#{hmm_user_next_id}" + "_" + "#{@filename}").first
     img1.write("#{RAILS_ROOT}/public/user_content/photos/#{hmm_user_next_id}" + "_" + "#{@filename}")
     originaldate = img1.get_exif_by_entry('DateTimeOriginal')
     
     if(originaldate[0][1] == nil || originaldate[0][1] == 'unknown')
       t = Time.now
     
     else
       datetime = originaldate[0][1].split(" ")
       if(datetime[1]==nil)
       t=Time.now
       else
        date = datetime[0].split(":")
        time = datetime[1].split(":")
        
        t = Time.utc(date[0],date[1],date[2],time[0],time[1],time[2])
       #t = Time.utc(2000,"jan",1,20,15,1)
       #2007:02:16 13:18:05
      end 
     end
     @user_content['d_createddate'] = t
     # @user_content.save
   else
     img1 = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/photos/thumb/blank.jpg").first
   end
   
   
   actual_height=img1.rows
   actual_width=img1.columns
   
   origianl=resize(img1,actual_height,actual_width,"#{RAILS_ROOT}/public/user_content/photos/#{hmm_user_next_id}" + "_" + "#{@filename}")
   
     
        @filename1=removeSymbols(@filename)
        
        @filename1 = @filename1.downcase
     @filename1 = @filename1.gsub(" ", "_")
     @filename1 = @filename1.gsub("(","")
     @filename1 = @filename1.gsub(")","")
     @filename1 = @filename1.gsub(".avi", "")
   @filename1 = @filename1.gsub(".flv", "")
   @filename1 = @filename1.gsub(".wmv", "")
   @filename1 = @filename1.gsub(".mpeg", "")
   @filename1 = @filename1.gsub(".mpg", "")
   @filename1 = @filename1.gsub(".mov", "")
        
         
          if (params[:hmm_user][:v_myimage]!='')
           img1 = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/photos/#{hmm_user_next_id}" + "_" + "#{@filename}").first
         else
            img1 = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/photos/thumb/blank.jpg").first
          end
          hmm_userimage=resize(img1,78,77,"#{RAILS_ROOT}/public/hmmuser/photos/thumb/#{hmm_user_next_id}"+"_"+"#{@filename}")
          
          hmm_userimage.write("#{RAILS_ROOT}/public/hmmuser/photos/thumb/#{hmm_user_next_id}" + "_" + "#{@filename1}")
          
          #resize(img,73,75,"#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/#{@tag['v_chapimage']}")
        
          #resize(img,72,72,"#{RAILS_ROOT}/public/img/photos400/#{@tag['v_chapimage']}")
          
          #resize(img,760,481,"#{RAILS_ROOT}/public/user_content/photos/#{@user_content['v_filename']}")
          
          if (params[:hmm_user][:v_myimage]!='')
        img1 = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/photos/#{hmm_user_next_id}" + "_" + "#{@filename}").first
          else
        img1 = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/photos/thumb/blank.jpg").first
      end
      #flexIcon = resizeWithoutBorder(img1, 320, 240) 
      flexIcon = resizeWithoutBorder(img1, 320, 240, "")
      flexIcon.write("#{RAILS_ROOT}/public/user_content/photos/flex_icon/#{@tag['v_chapimage']}")
      
          img2 = resize(img1, 72, 72,"#{RAILS_ROOT}/public/user_content/photos/big_thumb/#{@tag['v_chapimage']}")
          #img = Magick::Image.read("#{RAILS_ROOT}/public/user_content/photos/cropthumb/#{content[0].v_filename}").first
          folderImage = Magick::Image.read("#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/folder_img.png").first
          imageName = @tag['v_chapimage']
          imageName.slice!(-4..-1)
          finalImage = folderImage.composite(img2, 4, 9, CopyCompositeOp)
          @newchapterIcon = "#{imageName}.png"
          @usercontentIcon="#{imageName}.jpg"
          @user_content['v_filename']=@usercontentIcon
          @tag['v_chapimage'] = @newchapterIcon
      
          #PLEASE DONT FUCK AROUND WITH THIS LINE OF CODE. 
      origianl.write("#{RAILS_ROOT}/public/user_content/photos/#{@usercontentIcon}")
         
          finalImage.write("#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/#{@newchapterIcon}")
          
          if (params[:hmm_user][:v_myimage]!='')
            img1 = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/photos/#{hmm_user_next_id}" + "_" + "#{@filename}").first
          else
           img1 = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/photos/thumb/blank.jpg").first
          end
        
          phto_icon=resize(img1,192,192,"#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/#{@usercontentIcon}")
          phto_icon.write("#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/#{@usercontentIcon}")
         
         if (params[:hmm_user][:v_myimage]!='')
          img1 = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/photos/#{hmm_user_next_id}" + "_" + "#{@filename}").first
         else
           img1 = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/photos/thumb/blank.jpg").first
         end
          #resize(img,254,360,"#{RAILS_ROOT}/public/user_content/photos/icon_thumbnails/#{@user_content['v_filename']}")
          big_photo_image=resize(img1,508,720,"#{RAILS_ROOT}/public/user_content/photos/journal_thumb/#{@usercontentIcon}")
          big_photo_image.write("#{RAILS_ROOT}/public/user_content/photos/journal_thumb/#{@usercontentIcon}")
          
          if (params[:hmm_user][:v_myimage]!='')
            img1 = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/photos/#{hmm_user_next_id}" + "_" + "#{@filename}").first
          else
            img1 = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/photos/thumb/blank.jpg").first
          end
          
          big_photo_thumnail=resize(img1,192,192,"#{RAILS_ROOT}/public/user_content/photos/big_thumb/#{@usercontentIcon}")
          big_photo_thumnail.write("#{RAILS_ROOT}/public/user_content/photos/big_thumb/#{@usercontentIcon}")
       
        #@hmm_users = HmmUsers.find(:all, :conditions => "v_user_name = 'Bob' and id='4'")
       # @bobManage_group = FnfGroups.find(:all, :joins => 'as a, hmm_users as b', :conditions => "b.v_user_name = 'Bob' and a.uid=b.id and a.fnf_category='Manage'")
##         if @bob_id.id==''
#           @bob_id.id='0'
#         end
#         if @bobManage_group.id==''
#           @bobManage_group.id='0'
#         end
        
          @friends_grp = FnfGroups.new
      @friends_grp['fnf_category']="Friends"
      @friends_grp['uid']=hmm_user_next_id
      @friends_grp.save
      
      @friends_grp1 = FnfGroups.new
      @friends_grp1['fnf_category']="Family"
      @friends_grp1['uid']=hmm_user_next_id
      @friends_grp1.save
          
      @friends_grp2 = FnfGroups.new
      @friends_grp2['fnf_category']="Manage"
      @friends_grp2['uid']=hmm_user_next_id
      @friends_grp2.save

      # Start preparing a new friend to bob
      @fnf = FamilyFriend.new()
      @fnf['id'] = fnf_next_id 
      @fnf['uid'] = @hmm_user.id
      @fnf['fid'] = '4'
      @fnf['fnf_category'] = fnfGroup_next_id
      @fnf['status'] = 'accepted'
      @fnf['block_status'] = 'unblock'
      @fnf['shown'] = 'true'
    
      #Start preparing a new friend for bob
      @fnf_swap = FamilyFriend.new()
      @fnf_swap['id'] = fnf_sawp_next_id 
      @fnf_swap['uid'] = '4'
      @fnf_swap['fid'] = @hmm_user.id
      @fnf_swap['fnf_category'] = '265'
      @fnf_swap['status'] = 'accepted'
      @fnf_swap['block_status'] = 'unblock'
      @fnf_swap['shown'] = 'true'
    
    #creating family name image
      @naming_family='"The '+"#{params[:hmm_user][:v_lname].capitalize}"+'\'s"'
      @hmm_user.familypage_image="#{hmm_user_next_id}title.png"
      system("convert  -gravity north   -fill '#454545' -background transparent -font #{RAILS_ROOT}/public/Bickham2.otf  -pointsize 72 label:#{@naming_family} #{RAILS_ROOT}/public/familytitleImages/#{hmm_user_next_id}title.png")
    
    if @hmm_user.save
    
      
      
     #save the tag
     if @tag.save
       if @sub_chapter.save
          @galleries1.save
          @galleries2.save
          @galleries3.save
             if @user_content.save
               
               if @fnf.save  
               if  @fnf_swap.save
               f="done"
             else
               params[:id]=hmm_user_next_id
               HmmUser.find(params[:id]).destroy
               params[:id]=galleries_next_id
               Galleries.find(params[:id]).destroy
               params[:id]=subchapter_next_id
               Subchapter.find(params[:id]).destroy
               params[:id]=tag_next_id
               Tag.find(params[:id]).destroy
               
               params[:id]=fnfGroup_next_id
               FnfGroups.find(params[:id]).destroy
               params[:id]=fnf_next_id
               FamilyFriend.find(params[:id]).destroy
               params[:id]=fnf_sawp_next_id
               FamilyFriend.find(params[:id]).destroy
             end
           end
          end
       else
          params[:id]=hmm_user_next_id
          HmmUser.find(params[:id]).destroy
          params[:id]=tag_next_id
          Tag.find(params[:id]).destroy
       end
     else
          params[:id]=hmm_user_next_id
          HmmUser.find(params[:id]).destroy
     end
      session[:createdid]=@hmm_user.id
     
     #variables bellow declared to assign the family website info to e-mail
     link= "http://www.holdmymemories.com/"+params[:hmm_user][:family_name]
     pass_req=params[:hmm_user][:password_required]
     pass=params[:hmm_user][:familywebsite_password]
     
       Postoffice.deliver_welcome(@params[:hmm_user][:v_fname] +' '+ @params[:hmm_user][:v_lname] , @params[:hmm_user][:v_e_mail] , @params[:hmm_user][:v_user_name], @params[:hmm_user][:v_password],link,pass_req,pass)
       #flash[:notice] = 'Your Account has been successfully created !!!<br><center>Please LogIn <center>'
        # redirect_to :controller => 'customers', :action => 'authorise_payment', :id =>@hmm_user.id
       
       if(params[:payment_type]=='family_website')
         redirect_to :controller => 'customers', :action => 'authorise_payment', :id =>@hmm_user.id, :type => params[:payment_type]
       else
        if(params[:payment_type]=='platinum_account')
         redirect_to :controller => 'customers', :action => 'authorise_payment', :id =>@hmm_user.id, :type => params[:payment_type]
        else
         #redirect_to :controller => 'customers', :action => 'authorise_payment', :id =>@hmm_user.id
           redirect_to :controller => 'customers', :action => 'other_details', :id =>@hmm_user.id
        end  
       end
       

    else
        render :action => 'new'
    end
  end
  
def index1
end
  
  def pictureScaling(maxW,maxH,actualW,actualH)
      if actualW <= maxW && actualH <= maxH
          @calf_w = actualW
          @calf_h = actualH

      else if actualW == actualH
          @calf_w = maxW
          @calf_h = maxH

        else if actualW < actualH

          big_h = Float(actualH/maxH)
          @calf_w = Integer(actualW/big_h)
          @calf_h = maxH

        else if actualW > actualH
          big_w = Float(actualW/maxW)
          @calf_h = Integer(actualH/big_w)
          @calf_w = maxW
          end
        end
       end
      end
   end
   
  
  def add_other_details
     
     @hmm_userid=session[:createdid]
     @count=params[:count]
    
   # if((params["relation#{i}"]=="father") || (params["relation#{i}"]=="mother") || (params["relation#{i}"]=="brother") || (params["relation#{i}"]=="sister") || (params["relation#{i}"]=="husband") || (params["relation#{i}"]=="wife") || (params["relation#{i}"]=="son") || (params["relation#{i}"]=="daughter"))
     @tag_max =  Tag.find_by_sql("select max(id) as m from tags")
           for tag_max in @tag_max
           tag_max_id = "#{tag_max.m}"
       end
       tag_max_id=Integer(tag_max_id) - 1
    i=0
      until i == 15 
    i=i+1
        if(params["relation#{i}"]=="father")
           family = { :family => { :relation => ["father"], :Subchapters => ["Wedding", "Fathers Day","Anniversary","Birthdays"]}}
         createchapter(params["family#{i}"],family,params["img#{i}"],params["bio#{i}"],params["relation#{i}"],params["family_members#{i}"])

       end
        if(params["relation#{i}"]=="mother")
          family = { :family => { :relation => ["mother"], :Subchapters => ["Bridal or Wedding", "Mothers Day","Anniversary","Birthdays"]}}
         createchapter(params["family#{i}"],family,params["img#{i}"],params["bio#{i}"],params["relation#{i}"],params["family_members#{i}"])
      
       end

       
        if(params["relation#{i}"]=="brother")
          family = { :family => { :relation => ["brother"], :Subchapters => ["Birthdays", "Achievements","Art Work","Baby Pictures","Graduation"]}}
         createchapter(params["family#{i}"],family,params["img#{i}"],params["bio#{i}"],params["relation#{i}"],params["family_members#{i}"])
        
       end
       

       if(params["relation#{i}"]=="sister")
          family = { :family => { :relation => ["sister"], :Subchapters => ["Birthdays", "Achievements","Art Work","Baby Pictures","Graduation"]}}
         createchapter(params["family#{i}"],family,params["img#{i}"],params["bio#{i}"],params["relation#{i}"],params["family_members#{i}"])
         
       end 
       
        if(params["relation#{i}"]=="husband")
          family = { :family => { :relation => ["husband"], :Subchapters => ["wedding","Honey Moon","Anniversary","Fathers Day","Birthdays"]}}
         createchapter(params["family#{i}"],family,params["img#{i}"],params["bio#{i}"],params["relation#{i}"],params["family_members#{i}"])
        
       end 
       
       if(params["relation#{i}"]=="wife")
          family = { :family => { :relation => ["wife"], :Subchapters => ["wedding","Honey Moon","Anniversary","Mothers Day","Birthdays"]}}
         createchapter(params["family#{i}"],family,params["img#{i}"],params["bio#{i}"],params["relation#{i}"],params["family_members#{i}"])
        
       end
       
       if(params["relation#{i}"]=="son")
            family = { :family => { :relation => ["son"], :Subchapters => ["Baby Pictures","Birthdays","Achievements","Art Work","School events","Sports"]}}
         createchapter(params["family#{i}"],family,params["img#{i}"],params["bio#{i}"],params["relation#{i}"],params["family_members#{i}"])
         
       end
       
       if(params["relation#{i}"]=="daughter")
          family = { :family => { :relation => ["daughter"], :Subchapters => ["Birthdays","Achievements","Art Work","Baby Pictures","Graduation"]}}
         createchapter(params["family#{i}"],family,params["img#{i}"],params["bio#{i}"],params["relation#{i}"],params["family_members#{i}"])
        
      end
      
      if(params["relation#{i}"]=="pet")
         family = { :family => { :relation => ["pet"], :Subchapters => ["pet Pictures","Birthdays","Pet Fest","Pet Grooming","Pets Club"]}}
         createchapter(params["family#{i}"],family,params["img#{i}"],params["bio#{i}"],params["relation#{i}"],params["family_members#{i}"])
      end
       
     end
     
     
     if(params[:vocation]=="1")
     
           createeventchapter("Family Vacations")
           createeventsubchapter("Family Vacations","Vacations")
     end 
     
     if(params[:holidays]=="1")
     
           createeventchapter("Family Holidays")
      if(params[:newyear]=="1")
          createeventsubchapter("Family Holidays","New Year")
      end
      
      if(params[:cristmas]=="1")
          createeventsubchapter("Family Holidays","Christmas")
      end
      
      if(params[:hanukah]=="1")
          createeventsubchapter("Family Holidays","Hanukah")
      end
      
      if(params[:thanksgiving]=="1")
          createeventsubchapter("Family Holidays","Thanksgiving")
      end
      
      if(params[:easter]=="1")
          createeventsubchapter("Family Holidays","Easter")
      end
      
      if(params[:eid]=="1")
          createeventsubchapter("Family Holidays","Eid")
      end
    end
    
    if(params[:events]=="1")
     
           createeventchapter("Family Events")
      if(params[:birthday]=="1")
          createeventsubchapter("Family Events","Birthday Parties")
      end
      
      if(params[:gettogether]=="1")
          createeventsubchapter("Family Events","Get Togethers")
      end
    
  end
   flash[:notice] = 'Your Account and chapters have been successfully created !!!<br><center>Please LogIn <center>'
       redirect_to :controller => 'user_account', :action => 'login'

end

def createeventchapter(name)
    t = Time.now
    @tag = Tag.new()
    #@tag['id'] = tag_next_id
    @tag['v_tagname']=name
    @tag['uid']=@hmm_userid
   # @tag['default_tag']="yes"
    @tag.e_access = 'semiprivate'
    @tag.e_visible = 'yes'
    @tag['d_updateddate']=Time.now
    @tag['d_createddate']=Time.now
    #@tag['v_chapimage']=tag_next_id.to_s+"_"+image_name
    @tag['v_chapimage']="folder_img.png"
    @tag.save
    
    
end

  
  def createeventsubchapter(chapname,subchapname)
    t = Time.now
    @tagval = Tag.find(:all, :conditions => "uid=#{@hmm_userid} and v_tagname='#{chapname}'")
    puts @tagval[0]['id']
    @sub_chapter = SubChapter.new
    
    @sub_chapter['uid']=@hmm_userid
    @sub_chapter['tagid']=@tagval[0]['id']
    @sub_chapter['sub_chapname']=subchapname
    @sub_chapter['v_image']="folder_img.png"
    @sub_chapter['d_updated_on'] = t
    @sub_chapter['d_created_on'] = t
    @sub_chapter.save
    
    @galleries_photo = Galleries.new()
   
    
    @galleries_photo['v_gallery_name']="Photo Gallery"
    @galleries_photo['e_gallery_type']="image"
    @galleries_photo['d_gallery_date']=Time.now
    @galleries_photo['e_gallery_acess']="semiprivate"
    @galleries_photo['v_gallery_image']="picture.png"
    @galleries_photo['subchapter_id']=@sub_chapter.id
    @galleries_photo.save
    
     @galleries_audio = Galleries.new()
   
    
    @galleries_audio['v_gallery_name']="Audio Gallery"
    @galleries_audio['e_gallery_type']="audio"
    @galleries_audio['d_gallery_date']=Time.now
    @galleries_audio['e_gallery_acess']="semiprivate"
    @galleries_audio['v_gallery_image']="audio.png"
    @galleries_audio['subchapter_id']=@sub_chapter.id
    @galleries_audio.save
    
    @galleries_video = Galleries.new()
    @galleries_video['v_gallery_name']="Video Gallery"
    @galleries_video['e_gallery_type']="video"
    @galleries_video['d_gallery_date']=Time.now
    @galleries_video['e_gallery_acess']="semiprivate"
    @galleries_video['v_gallery_image']="video.png"
    @galleries_video['subchapter_id']=@sub_chapter.id
    @galleries_video.save
    
  end

  
     
   
  
  def createchapter (relation,family,image,bio,relationship_name,bdate)
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
   
    @tag = Tag.new()
    @tag['id'] = tag_next_id
    @tag['v_tagname']=relation
    @tag['uid']=@hmm_userid
    #@tag['default_tag']="no"
    @tag.e_access = 'private'
    @tag.e_visible = 'yes'
    @tag['d_updateddate']=Time.now
    @tag['d_createddate']=Time.now
    @tag['v_chapimage']=tag_next_id.to_s+"_"+image_name
    #@tag['v_chapimage']="folder_img.png"
    #@tag.save
    
    if((relationship_name=="father") || (relationship_name=="mother") || (relationship_name=="brother") || (relationship_name=="sister") || (relationship_name=="husband") || (relationship_name=="wife") || (relationship_name=="son") || (relationship_name=="daughter") || (relationship_name=="pet"))
         @family_details = FamilyMember.new()
            @family_details['uid']=@hmm_userid
            @family_details['chap_id']=tag_next_id
            @family_details['familymember_name']=relation
            @family_details['relation']=relationship_name
             @family_details['bdate']="#{bdate['bdate(1i)']}-#{bdate['bdate(2i)']}-#{bdate['bdate(3i)']}"
            @family_details['biographie']=bio
            @family_details['member_image']=tag_next_id.to_s+"_"+image_name
            @family_details.save
            
       end
    
    tag_next_id.to_s+"_"+image_name
   
    family[:family][:Subchapters].each {
    |key, value| 
    #puts "#{key} is #{value}" 
    
    @sub_chapter = SubChapter.new
    
    @sub_chapter['uid']=@hmm_userid
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
       if((relationship_name=="father") || (relationship_name=="brother") || (relationship_name=="husband") || (relationship_name=="son") )
        img1 = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/photos/blank.jpg").first
       else if ( (relationship_name=="mother") || (relationship_name=="sister") || (relationship_name=="wife") || (relationship_name=="daughter")) 
        img1 = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/photos/default_female.jpg").first
      end
      end
        actual_height=img1.rows
          actual_width=img1.columns
        imgorginal = resize(img1, actual_height, actual_width,"#{RAILS_ROOT}/public/user_content/photos/#{@tag['v_chapimage']}")
          
     else   
        HmmUser.save1(image,tag_next_id,image_name)
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

  
  def update_profile
    @hmm_user = HmmUser.find(params[:id])
    #@hmm_user = HmmUser.new(params[:hmm_user])
    
    if (params[:hmm_user][:v_myimage]!='')
      @filename = params[:hmm_user][:v_myimage].original_filename
       @filename = @filename.downcase
      HmmUser.save(params[:hmm_user],params[:id],"/hmmuser/photos",@filename)
      img = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/photos/#{params[:id]}" + "_" + "#{@filename}").first
      r=resize(img,78,77,"#{RAILS_ROOT}/public/hmmuser/photos/thumb/#{params[:id]}" + "_" + "#{@filename}")
      r.write("#{RAILS_ROOT}/public/hmmuser/photos/thumb/#{params[:id]}" + "_" + "#{@filename}")
      @hmm_user['v_myimage']="#{params[:id]}"+"_"+"#{@filename}"
    end
    params[:hmm_user][:v_myimage]=@hmm_user['v_myimage']
    
    #@hmm_user.save
    if @hmm_user.update_attributes(params[:hmm_user])
      flash[:notice] = 'Your Profile information has been Successfully Updated.'
      redirect_to :action => 'edit_profile', :id => @hmm_user
    else
      flash[:notice] = 'HmmUser update Failed due to technical problem.'
      
      redirect_to :action => 'edit_profile', :id => @hmm_user
    end
  end
  
  def profile1
    
  end
  
end  