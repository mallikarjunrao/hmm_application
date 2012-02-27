class CustomersController < ApplicationController
  layout "standard"
  include SortHelper
  helper :sort
  include SortHelper
  helper :customers
  include CustomersHelper
  #require 'VO/Content'
  before_filter :only => [:index, :chapterindex, :destroy, :enable_toggle]
  #before_filter :login_required || :login_required1, :only => [:new, :list, :create, :index, :search, :edit, :deleteSelection, :deleteSelection1, :update,:chapterindex]
  before_filter :authenticate, :only => [ :chapterindex, :list, :edit, :deleteSelection, :deleteSelection1, :update,:chapter_gallery,:sub_chapter_gallery,:chapter_next,:fnf_index,:profile,:manage,:list_share ,:edit_profile,:FnF_Request,:comment_index,:tipsUnder_development,:create_underdevelop,:upgrade_select, :upgrade, :upgarde_sucess ]
  

#   protected
    def authenticate
      unless session[:hmm_user]
           flash[:notice] = 'Please Login to Access your Account'
           redirect_to "https://www.holdmymemories.com/user_account/login"
      return false
      else
        if (session[:flag] == 1 && request.request_uri != "/customers/upgrade/platinum_account")
          flash[:error] = "Your credit card payment to you HoldMyMemories.com has been declined by your credit card company. This could be for a number of reasons, including an expired card. <br><br><br>Please re-enter your credit card information, or use a different card for the renewal of your account."
          redirect_to "https://www.holdmymemories.com/customers/upgrade/platinum_account"
        end  
      end
    end
    
    

   def initialize
     super
        @hmm_users = HmmUsers.find(:all)
   end

#   def index
#     if(session[:hmm_user])
#      @hmm_user=HmmUsers.find(session[:hmm_user])
#     else
#       redirect_to :controller => 'user_account', :action => 'login'
#     end
#     render :action => 'list' , :layout => false
#   end

   # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
   verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
#   def list
#     @hmm_user_pages, @hmm_users = paginate :hmm_users,:conditions=>"id=#{logged_in_hmm_user.id}",  :per_page => 10
#   end
   
#   def show
#     @hmm_user = HmmUser.find(params[:id])
#     render(:layout => false)
#   end

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

   
   def new
     if(session[:hmm_user].nil?)
     else
      redirect_to "https://www.holdmymemories.com/user_account/login/?msg=1"
      
     end
     @hmm_user = HmmUser.new
   end
   
   
   def other_details
     
     
     
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
    @user_content['tagid']=@tag['id']
    @user_content['d_createddate'] = t #.strftime("%Y:%m:%d %H:%M:%S")
    @user_content['d_momentdate'] = t #.strftime("%Y:%m:%d %H:%M:%S")
    @user_content['img_url']=content_path

    @hmm_user.d_updated_date = Time.now
    @hmm_user.d_created_date = Time.now
    @hmm_user['img_url']=content_path
    if (params[:hmm_user][:family_pic]!='')
      HmmUser.savefamily(params['hmm_user'],hmm_user_next_id,"/hmmuser/familyphotos", @filename_family)
       
      img_family = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/familyphotos/#{hmm_user_next_id}" + "_" + "#{@filename_family}").first
   actual_height_family=img_family.rows
   actual_width_family=img_family.columns
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
   

   def create_backup 
     t = Time.now
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
    #@user_content.save
    @hmm_user.d_updated_date = Time.now
    @hmm_user.d_created_date = Time.now

    #creating family image
    if (params[:hmm_user][:family_pic]!='')
      HmmUser.savefamily(params['hmm_user'],hmm_user_next_id,"/hmmuser/familyphotos", @filename_family)
       
#      HmmUser.save(params['hmm_user'],hmm_user_next_id,"/hmmuser/photos", @filename_family)
      img_family = Magick::Image.read("#{RAILS_ROOT}/public/hmmuser/familyphotos/#{hmm_user_next_id}" + "_" + "#{@filename_family}").first
     
   actual_height_family=img_family.rows
   actual_width_family=img_family.columns
   
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
    
    #code to save employee id if employe registers a customer 
    if session[:employe]
      @hmm_user.emp_id = session[:employe]
    end
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


  def validate
    color = 'red'
   username = params[:username]
   user = HmmUser.find_all_by_v_user_name(username)      
   if user.size > 0        
     message = 'User Name Is Already Registered'
     @valid_username = false
   else
     message = 'User Name Is Available'
     color = 'green'
     @valid_username=true
   end
   @message = "<b style='color:#{color}'>#{message}</b>"
    render :partial=>'message'
  end
  
   def validate_familyname
      color = 'red'
      familyname = params[:familyname]

      family = HmmUser.find_all_by_family_name(familyname)      
      if family.size > 0        
        message_family = 'Family Name already exist'
        @valid = false
      else
        message_family = 'Family Name Is Available'
        color = 'green'
         @valid = true
      end
      @message_family = "<b style='color:#{color}'>#{message_family}</b>"
    
      render :partial=>'message_family'
  end
  
  def validate_email
    color = 'red'
    email = params[:email]
    mail = HmmUser.find_all_by_v_e_mail(email) 
    if mail.size > 0        
        message_email = 'Email Is Already Registered'  
       @valid_email = false
     
   end
   @message_email = "<b style='color:#{color}'>#{message_email}</b>"
    render :partial=>'message_email'
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
       redirect_to "https://www.holdmymemories.com/user_account/login"

end

def createeventchapter(name)
    t = Time.now
    @tag = Tag.new()
    @tag['v_tagname']=name
    @tag['uid']=@hmm_userid
    @tag.e_access = 'semiprivate'
    @tag.e_visible = 'yes'
    @tag['d_updateddate']=Time.now
    @tag['d_createddate']=Time.now
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

  def testEx
    begin
      deb = 2/0

    rescue Exception => exc
      STDERR.puts "this doesnt work"

    else
      STDERR.puts "this works"
    ensure
      STDERR.puts "This has to execute"
    end
  end


  def edit
    @hmm_user = HmmUser.find(params[:id])
    render(:layout => false)
  end

  def update
    @hmm_user = HmmUser.find(params[:id])
      if @hmm_user.update_attributes(params[:hmm_user])
      flash[:notice] = 'HmmUser was successfully updated.'
      render :action => 'show', :id => @hmm_user
    else
      render :action => 'edit'
    end
  end

  def destroy
    HmmUser.find(params[:id]).destroy
    redirect_to :controller =>'customers' , :action => ''
  end


  def deleteSelection
    i = 0
      colmns = @hmm_users.clone
      colmns.each { |colmn|
        i = i + 1
          if (@params['colmn_'+i.to_s] != nil) then
            checked = @params['colmn_'+i.to_s]
              if (checked != nil && checked.length > 0) then
                HmmUser.find(checked).destroy
                #@hmm_users.delete(item)
                #redirect_to :action => :list
                # else
              end
          end
      }
      redirect_to :action => :list
  end

  def deleteSelection1
    i = 0
      colmns = @hmm_users.clone
      colmns.each { |colmn|
      i = i + 1
      if (@params['colmn_'+i.to_s] != nil) then
        checked = @params['colmn_'+i.to_s]
          if (checked != nil && checked.length > 0) then
            HmmUser.find(checked).destroy
          end
      end
     }
     render :action => 'search'
  end

  def homenew
     @hmm_user=HmmUsers.find(session[:hmm_user])
  end

 #Chapter Display In The Chapter Index Page
  def chapterindex
     @hmm_user=HmmUsers.find(session[:hmm_user])
    items_per_page = 9
    
    sort_init 'd_updateddate'
     sort_update
          if(session[:friend]!='')
          @total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "a.uid=#{logged_in_hmm_user.id} and b.id=a.fid and a.fid=#{session[:friend]} and a.status='accepted'")
            if(@total>0)
              session[:semiprivate]="activate"
            else
              session[:semiprivate]=""
            end  
            
             @friend=HmmUsers.find(session[:friend])
             e_access="and e_access='public'"
             if(session[:semiprivate]=="activate")
             e_access=" and (e_access='public' or e_access='semiprivate') and default_tag='yes'"
             end
             uid=@friend.id
          else
            @friend=HmmUsers.find(logged_in_hmm_user.id)
             uid=@friend.id
            uid=logged_in_hmm_user.id
          end  
         srk=params[:sort_key]
         
        sort="#{srk}  #{params[:sort_order]}"
       
         if(srk==nil)
     sort="id  asc"
   end
    
   
        @tags_pages, @tags = paginate :tags , :per_page => items_per_page, :order => sort, :conditions => "uid='#{uid}' and status='active' #{e_access}" # ,:order => " #{@sort.to_s} #{@order.to_s} "
          @countcheck=Tag.count(:all,:conditions => "uid=#{uid} #{e_access} and status='active'")
           # @tags = Tag.find_by_sql("SELECT a.*,b.* FROM user_contents as a,tags as b where a.uid='logged_in_hmm_user.id' and a.uid=b.uid")
           if request.xml_http_request?
              render :partial => "chapters_list", :layout => false
           end
  end
  

 def chapter_next
  sort_init 'd_updated_on'
  sort_update
  if(!@params[:id].nil?)
    session[:tag_id]=@params[:id]
  end
   
    @chapter_belongs_to=Tag.find_by_sql("select a.*,b.* from tags as a,  hmm_users as b where a.id=#{params[:id]} and  a.uid=b.id")
    puts @chapter_belongs_to[0]['uid']
    puts logged_in_hmm_user.id
    if(@chapter_belongs_to[0]['uid']==logged_in_hmm_user.id)
    else
      session[:friend]=@chapter_belongs_to[0]['uid']
       @total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid and a.fid=#{session[:friend]} and a.status='accepted'")
       if(@total>0)
         session[:semiprivate]="activate"
       else
         session[:semiprivate]=""
      end  
    end
  @hmm_user=HmmUsers.find(session[:hmm_user])
  items_per_page = 9
  conditions = ["v_tagname LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?
  if(session[:friend]!='')
    e_access="and e_access='public' "
    uid=session[:friend]
    if(session[:semiprivate]=="activate")
     e_access=" and (e_access='public'  or e_access='semiprivate')"
    end
  else
    uid=logged_in_hmm_user.id
  end
  srk=params[:sort_key] 
  sort="#{srk}  #{params[:sort_order]}"
    
  if( srk==nil)
     sort="id  desc"
   end
  @sub_chapters_pages, @sub_chapters = paginate :sub_chapters ,  :per_page => items_per_page, :conditions => "tagid=#{@params[:id]} and status='active'    #{e_access}" , :order => sort #:order => " #{@sort.to_s} #{@order.to_s} "
   @countcheck=SubChapter.count(:all,:conditions => "tagid=#{@params[:id]} #{e_access} and status='active'")
         
  @chapter_journal = ChapterJournal.find(:all, :conditions => "tag_id=#{params[:id]}", :order=>"id DESC")
  @tagid = ChapterJournal.find(:all, :conditions => "tag_id=#{params[:id]}")
  @chap_cnt = ChapterJournal.count(:all, :conditions => "tag_id=#{params[:id]}")
  @tag = Tag.find(params[:id])
  session[:chap_id]=params[:id]
  session[:chap_name]=@tag['v_tagname']
  if request.xml_http_request?
      render :partial => "chapter_next", :layout => false
  end
  
   if(@countcheck==1)
             gallery = Galleries.find(:all,:conditions=>"subchapter_id='#{@sub_chapters[0]['id']}'")
            redirect_to :controller => "customers" , :action => 'sub_chapter_gallery', :id => @sub_chapters[0]['id']
   
    end
 end


  
  def chapters_display
    contentservers = ContentPath.find(:all)
    @proxyurls = nil
    for server in contentservers
      if(@proxyurls == nil)
        @proxyurls = server['content_path']
      else
        @proxyurls = @proxyurls +','+server['content_path']
      end
    end
     if(session[:friend]!='')
          @total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "a.uid=#{logged_in_hmm_user.id} and b.id=a.fid and a.fid=#{session[:friend]} and a.status='accepted'")
            if(@total>0)
              session[:semiprivate]="activate"
            else
              session[:semiprivate]=""
            end  
            
             @friend=HmmUsers.find(session[:friend])
             e_access="and e_access='public'"
             if(session[:semiprivate]=="activate")
             e_access=" and (e_access='public' or e_access='semiprivate')"
             end
             uid=@friend.id
          else
            @friend=HmmUsers.find(logged_in_hmm_user.id)
             uid=@friend.id
            uid=logged_in_hmm_user.id
          end  
    
    if(session[:friend]=="" || session[:friend]==nil)
      uid=logged_in_hmm_user.id
    else
      uid=session[:friend]
    end  
    
    @results = Tag.find(:all, :conditions => "uid=#{uid} and status='active'  and default_tag='yes' #{e_access}" , :order => "id ASC" )
  #@results = Tag.find(:all)
   
    render :layout => false
  #render :amf => @results
  end

  def chapters_list
    @hmm_user=HmmUsers.find(session[:hmm_user])
 if(session[:friend]=="" || session[:friend]==nil)
      uid=logged_in_hmm_user.id
    else
      uid=session[:friend]
    end  
    @results = Tag.find(:all, :conditions => "uid=#{uid} and status='active'" , :order => "id ASC" )
    @userid="#{uid}"
    render :layout => false
  end

  
  
 def chapters_json_list
    @hmm_user=HmmUsers.find(session[:hmm_user])
    @results = Tag.find(:all, :conditions => "uid=#{logged_in_hmm_user.id}" , :order => "id ASC" )
    @userid="#{logged_in_hmm_user.id}"
    chapters = Array.new
    for chapter in @results
      subchapters = SubChapter.find(:all, :conditions =>" tagid = #{chapter.id} and status='active'")
      for subchapter in subchapters
        galleries = Galleries.find(:all ,:conditions =>"subchapter_id = #{subchapter.id} and status='active'", :order =>'e_gallery_type')
        for gallery in galleries
          files = UserContent.find(:all, :conditions => "gallery_id = #{gallery.id} and status='active' " , :order => 'id' )
          for file in files

          end
        end
      end
    end
    @useridjson = @userid.to_json
    @resultsjson = @results.to_json
    render :layout => false
 end

  #Displays The Chapter Journals
  def chapter_journal
    @hmm_user=HmmUsers.find(session[:hmm_user])
    @chapters = Tag.find(params[:id])
    @journals =Journal.find(:all,:conditions=>"uid=#{logged_in_hmm_user.id}",:order=>"id DESC" )
  end

  #Slide Box Function For Adding Comments In Chapter Journal
  def frame
     @hmm_user=HmmUsers.find(session[:hmm_user])
     render(:layout => false)
  end

  #Slide Box Function For Adding Comments In Chapter Journal
  def frame1
    @comment=Comments.new(params[:commentss])

    @comment['jid'] ="#{params[:id]}"
    if is_userlogged_in?
      @comment['uid'] = logged_in_hmm_user.id
    else
      @comment['uid'] = ''
    end
    @comment.save
    render(:layout => false)
  end

  #Display All The Comments For The User Logged In
  def guest_comment
     @hmm_user=HmmUsers.find(session[:hmm_user])
     @comment =Comments.find(:all, :conditions => "uid=#{logged_in_hmm_user.id}", :order => "id ASC")

  end

  def abuse_rept
    @hmm_user=HmmUsers.find(session[:hmm_user])
     @comment=Comments.find(params[:id])
     @abuse1 = Abuses.new()
    @abuse1['v_abused_by'] = @comment.v_name
    @abuse1['abused_user'] = @comment.uid
    @abuse1['v_comment'] = @comment.v_comment
    @abuse1.save
    redirect_to :action => :guest_comment
  end

  def comment_index
    @hmm_user=HmmUsers.find(session[:hmm_user])
  end

  #Display All The Comments For That Journal
  def view_comment
    @hmm_user=HmmUsers.find(session[:hmm_user])
    @comment = Comments.find(:all, :conditions => "jid=#{params[:id]} && uid=#{logged_in_hmm_user.id}")
    @cnt = Comments.count(:all, :conditions => "jid=#{params[:id]} && uid=#{logged_in_hmm_user.id}")
     flash[:notice] = 'There Are no Comments To This Journal!!!'
    render(:layout => false)
  end

  #Function To Approve Comments
  def add_comment
    @hmm_user=HmmUsers.find(session[:hmm_user])
    @comment =Comments.find(params[:id])
    @comment['e_aprove_comment'] = 'approve'
    @comment.save
    redirect_to :action => :guest_comment
    flash[:notice] = 'Comment Is Aproved!!!'
  end

  #Function To Reject Comments
  def reject_comment
    @hmm_user=HmmUsers.find(session[:hmm_user])
    @comment =Comments.find(params[:id])
    @comment['e_aprove_comment'] = 'Reject'
    @comment.save
    redirect_to :action => :guest_comment
    flash[:notice] = 'Comment Is Rejected!!!'
  end
  
   #Function For Displaying Chapter Gallery
   def chapter_gallery
     sql = ActiveRecord::Base.connection();
     session[:share_with_hmm]=nil
    session[:shid]=nil
    session[:share]=nil
    session[:redirect]=nil
     @gallery_belongs_to=Galleries.find_by_sql("select a.*,b.* from galleries as a, sub_chapters as b, hmm_users as c where a.id=#{params[:id]} and a.subchapter_id=b.id and b.uid=c.id")
     @gallery_belongs_to[0]['uid']
     if(@gallery_belongs_to[0]['uid']!="#{logged_in_hmm_user.id}")
      session[:friend]=@gallery_belongs_to[0]['uid']
       @total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid and a.fid=#{session[:friend]} and a.status='accepted'")
       if(@total>0)
         session[:semiprivate]="activate"
       else
         session[:semiprivate]=""
      end  
     end
     
     session[:galleryid]=''
     session[:share]=''
     sort_init 'd_updated_on'
     sort_update
     session[:galery_id]=params[:id]
     gal=params[:id]
     items_per_page = 9
     chapter_id=params[:id]
     @hmm_user=HmmUsers.find(session[:hmm_user])
     if(session[:friend]!='')
      e_access="and e_access='public'"
       if(session[:semiprivate]=="activate")
        e_access=" and (e_access='public' or e_access='semiprivate')"
       end
     end
    
     srk=params[:sort_key]
      puts srk
     sort="#{srk}  #{params[:sort_order]}"
     if(srk==nil)
      sort="id  desc"
    end
    puts sort

     @user_contents_pages, @user_content = paginate :user_contents, :per_page => items_per_page, :conditions=>"gallery_id=#{params[:id]}  and status='active'", :order => sort
     @gallery_journal = GalleryJournal.find(:all, :conditions => "galerry_id=#{params[:id]}", :order=>"id DESC")
     
     # Bread crumb sessions
        @galleries = Galleries.find(params[:id])
        @gal_name=@galleries['v_gallery_name']
          session[:gal]=params[:id]
          session[:gallery_name]=@galleries['v_gallery_name']
          params[:id]=@galleries['subchapter_id']
        @sub_chapter = SubChapter.find(params[:id])
          session[:subchap_id]=params[:id]
          session[:sub_chapname]=@sub_chapter['sub_chapname']
          params[:id]=@sub_chapter['tagid']
        @tag = Tag.find(params[:id])
          session[:chap_id]=params[:id]
          session[:chap_name]=@tag['v_tagname']
       
    params[:id]=gal
    @gal_cnt = GalleryJournal.count(:all, :conditions => "galerry_id=#{params[:id]}")
    if request.xml_http_request?
     render :partial => "chapgallery_list", :layout => false
   end
 end

   #function to Write A journal
   def write_journal
      @hmm_user=HmmUsers.find(session[:hmm_user])
      @chapters = Tag.find(params[:id])
      @journal = Journal.new
   end

  #function to Create A journal
  def create_journal
    @hmm_user=HmmUsers.find(session[:hmm_user])
     @journal = Journal.new(params[:journal])
     @journal['uid'] = logged_in_hmm_user.id
     @journal['chap_id']= params[:id]
     @journal.save
     redirect_to :action => :chapter_journal ,:id => params[:id]
  end

  #functions To Display F&F OF the Logged In User
  def fnf_index
  if(session[:friend]!='')
  uid=session[:friend]
  else
  uid=logged_in_hmm_user.id
  end
     items_per_page = 15
     sort = case params['sort']
              when "username"  then "v_fname"
              when "username_reverse"  then "v_fname DESC"
          end
     if (params[:query].nil?)
        params[:query]=""
     else
        conditions = "a.uid=#{uid} && b.id=a.fid && a.block_status='unblock' && a.status='accepted' && b.v_fname LIKE '%#{params[:query]}%'"
     end
      if (params[:query1].nil?)   
        params[:query1]=""
       # params[:query_hmm_user]=""  
     else
        conditions ="a.uid=#{uid} && b.id=a.fid && a.block_status='unblock' && a.status='accepted' && b.v_fname LIKE '#{params[:query1]}%'"
     end
     
     if (params[:query_hmm_user].nil?)   
        params[:query_hmm_user]=""  
     else
        search_array=params[:query_hmm_user].split(' ')
        if(session[:friend]==nil || session[:friend]=='')
          conditions12 = "id!=#{logged_in_hmm_user.id} and ((v_fname LIKE '#{params[:query_hmm_user]}%' or v_lname LIKE '#{params[:query_hmm_user]}%' or v_user_name Like '#{params[:query_hmm_user]}%')" 
        else
         conditions12 = "id!=#{session[:friend]} and ((v_fname LIKE '#{params[:query_hmm_user]}%' or v_lname LIKE '#{params[:query_hmm_user]}%' or v_user_name Like '#{params[:query_hmm_user]}%')" 
         
        end  
        for i in search_array
            conditions12 = conditions12 + " or (v_fname LIKE '#{i}%' or v_lname LIKE '#{i}%' or v_user_name Like '#{i}%')"
      
        end
        conditions12=conditions12+ ")"
        #conditions = "id!=#{logged_in_hmm_user.id} and v_fname LIKE '%#{params[:query_hmm_user]}%' or v_lname LIKE '%#{params[:query_hmm_user]}%'"
        @total = HmmUser.count(:conditions =>conditions12)
        @hmm_users_pages, @hmm_users = paginate :hmm_users , :select => "id as fid, v_myimage, v_fname, img_url",  :order => sort, :per_page => items_per_page,
        :conditions => conditions12
        
     end
     
     if( params[:query]=="" && params[:query1]=="" && params[:query_hmm_user] =="" )
        @total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "a.uid=#{uid} && b.id=a.fid and a.status='accepted' && a.block_status='unblock' " )
        @hmm_users_pages, @hmm_users = paginate :hmm_users ,:joins=>"as b , family_friends  as a ", :order => sort, :per_page => items_per_page,
        :conditions => "a.uid=#{uid} && b.id=a.fid && a.status='accepted' and a.block_status='unblock'"
     else
        flag=1
     if(params[:query_hmm_user]!="")
      else
             search_array=params[:query].split(' ')
          if(session[:friend]==nil || session[:friend]=='')
            conditions1 = "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && b.id!=#{logged_in_hmm_user.id} and ((b.v_fname LIKE '#{params[:query]}%' or b.v_lname LIKE '#{params[:query]}%' or b.v_user_name LIKE '#{params[:query]}%')" 
          else
            conditions1 = "a.uid=#{session[:friend]} && b.id=a.fid && b.id!=#{logged_in_hmm_user.id} and ((b.v_fname LIKE '#{params[:query]}%' or b.v_lname LIKE '#{params[:query]}%' or b.v_user_name LIKE '#{params[:query]}%')" 
          end
        for i in search_array
            conditions1 = conditions1 + " or (b.v_fname LIKE '#{i}%' or b.v_lname LIKE '#{i}%' or b.v_user_name LIKE '#{i}%')"
      
        end
        conditions1=conditions1+ ")"
        @total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "#{conditions1}")
        
        @hmm_users_pages, @hmm_users = paginate :hmm_users ,:joins=>"as b , family_friends as a ", :order => sort, :per_page => items_per_page,
        #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && a.status='accepted'"
         #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && b.v_fnameq LIKE '%#{params[:query]}%'"
        :conditions => conditions1
     end
     end
     @fnf_groups_index = FnfGroups.find(:all,:conditions=>"uid=#{logged_in_hmm_user.id}",:order=>"id DESC")

     if request.xml_http_request?
        render :partial => "fnf_list", :layout => false
     end
  end

  #Function To Display The Profile OF the user
  def profile
    contentservers = ContentPath.find(:all)
    @proxyurls = nil
    for server in contentservers
      if(@proxyurls == nil)
        @proxyurls = server['content_path']
      else
        @proxyurls = @proxyurls +','+server['content_path']
      end
    end
    @hmm_user1 = HmmUser.find(params[:id])
    @journals = Journal.find(:all,:conditions=>"uid=#{params[:id]}",:order =>"id DESC")
    @other_id= params[:id]
    @journal = Journal.find(:all,:conditions=>"uid=#{params[:id]}",:order=>"id DESC")
    @frn_tags = Tag.find(:all, :conditions => "uid=#{params[:id]} and status='active'" , :order => "id ASC")
    #hmm= HmmUser.find_by_sql("select count(*) as count  from family_friends  where fid=#{params[:id]} and uid=#{logged_in_hmm_user.id}")
    conditions = ["fid=#{params[:id]} and uid=#{logged_in_hmm_user.id} and status='pending' and block_status='unblock' "]
    @cnt=FamilyFriend.count(:conditions => conditions )
    cond = ["fid=#{params[:id]} and uid=#{logged_in_hmm_user.id} and status='accepted' and block_status='unblock'"]
    @block = FamilyFriend.count(:conditions => cond)
     @unblock = FamilyFriend.count(:conditions => "fid=#{params[:id]} and uid=#{logged_in_hmm_user.id} and status='accepted' and block_status='block' ")
     @imposed_block = FamilyFriend.count(:conditions => "fid=#{params[:id]} and uid=#{logged_in_hmm_user.id} and status='accepted' and block_status='imposed_block' ")
      @req_pending = FamilyFriend.count(:conditions => "fid=#{params[:id]} and uid=#{logged_in_hmm_user.id} and status='pending' and block_status='unblock' ")
      @req_reject = FamilyFriend.count(:conditions => "fid=#{params[:id]} and uid=#{logged_in_hmm_user.id} and status='rejected' and block_status='unblock' ")
      @fnf_req = FamilyFriend.count(:conditions => "fid=#{logged_in_hmm_user.id} and uid=#{params[:id]} and status='pending' ")
      @fnf_rejectId = FamilyFriend.find_by_sql("SELECT b.*, a.id as frnid, a.* FROM family_friends  as a ,hmm_users as b  WHERE (a.fid=#{logged_in_hmm_user.id} and a.uid=b.id and a.status='pending')")
  end


  #Function To Edit The Profile OF the user
  def edit_profile
   @hmm_user = HmmUser.find(params[:id])
   @fnf_groups2 = FnfGroups.find(:all,:conditions=>"uid=#{logged_in_hmm_user.id}",:order=>"id DESC")
   if params[:sucess].nil?
    
   else
     flash[:notice] = 'Your Profile information has been Successfully Updated.'
   end
   render(:layout => true)
  end


  
  def profile1
    
  end
  
  def Accept_fnf
     @hmm_user=HmmUsers.find(session[:hmm_user])
    back=params[:id]
    @fnf_req1 =FamilyFriend.find(:all, :conditions => "uid=#{params[:id]} and fid=#{logged_in_hmm_user.id} ")
    params[:id]=@fnf_req1[0]['id']
    @fnf_req =FamilyFriend.find(params[:id])
    @fnf_req['status'] = 'accepted'
    @fnf_req.save
    redirect_to :action => :FnF_Request
     $notice_reg
    flash[:notice_reg] = 'The Friends Request has been successfuly accepted'
  end

  def Reject_fnf
    @hmm_user=HmmUsers.find(session[:hmm_user])
   # back=params[:id]
    @fnf_req1 =FamilyFriend.find(:all, :conditions => "id=#{params[:id]} and fid=#{logged_in_hmm_user.id} ")
    #params[:id]=@fnf_req1[0]['id']
    @fnf_req =FamilyFriend.find(params[:id])
    @fnf_req['status'] = 'rejected'
    @fnf_req.save
    redirect_to :action => :FnF_Request
     $notice_reg
    flash[:notice_reg] = 'The Friends Request has been successfuly Rejected'
  end

    #Function To Send F&F Request
    def FnF_Request
     @hmm_user=HmmUsers.find(session[:hmm_user])
     @fnf_req = FamilyFriend.find_by_sql("SELECT b.*,a.uid as frid , a.id as frnid, a.* FROM family_friends  as a ,hmm_users as b  WHERE (a.fid=#{logged_in_hmm_user.id} and a.uid=b.id and a.status='pending')")
     
     @fnf_groups_pages, @fnf_groups = paginate :fnf_groupss, :conditions => " uid=#{logged_in_hmm_user.id} ", :per_page => 10
     flash[:notice_fnf] = 'is your friend now!!'
     
     @fnf_blocked = FamilyFriend.find_by_sql("SELECT b.*,a.uid as frid , a.id as frnid, a.* FROM family_friends  as a ,hmm_users as b  WHERE (a.fid=#{logged_in_hmm_user.id} and a.uid=b.id and a.block_status='block')")
    
    
    
    end

   #Function To Add F&F
   def add_fnf
       @friends_family = FamilyFriend.new()
       @fnf_groups2 = FnfGroups.find(:all,:conditions=>"uid=#{logged_in_hmm_user.id}",:order=>"id DESC")
     render :layout => false
   end

   def group_fnf
     @friends_family = FamilyFriend.new()
       @fnf_group = FnfGroups.find(:all,:conditions=>"uid=#{logged_in_hmm_user.id}",:order=>"id DESC")
       
     #@cnt = FnfGroups.count(:all,:conditions=>"uid=#{logged_in_hmm_user.id}",:order=>"id DESC")
     render :layout => false
   end

   def group_fnf2
      @friends_family = FamilyFriend.new()
      @friends_family['uid']=logged_in_hmm_user.id
      @friends_family['fid']=params[:id]
       @friends_family['status']='accepted'
      @fnf_groups2 = FnfGroups.find(:all,:conditions=>"uid=#{logged_in_hmm_user.id}",:order=>"id DESC")
      if(params[:fnf_category_other123]=='' && params[:fnf_category]=='default')
         flash[:notice] = ' cannot be added into your friends list, Please select user group and try again!!'
      else
      if(params[:fnf_category_other123]=='')
         @friends_family['fnf_category']=params[:fnf_category]
      else
         @fnf_group = FnfGroups.new()
         @fnf_group['fnf_category']=params[:fnf_category_other123]
         @fnf_group['uid']=logged_in_hmm_user.id
         #@fnf_groups['fnf_category']="#{params[:fnf_groups][:fnf_category]}"
         @fnf_group.save
         @friends_family['fnf_category']=@fnf_group.id
      end
       $notice_accept
      flash[:notice_accept] = 'The Friends Request has been successfuly Accepted !!!'
      @friends_family.save
     
      sql = ActiveRecord::Base.connection();
      sql.update "UPDATE family_friends SET status='accepted' WHERE uid=#{params[:id]} and fid=#{logged_in_hmm_user.id}";
      
      flash[:notice] = 'Friend Request Has Been Sent !!!'
      end
      @hmm_user=HmmUsers.find(params[:id])
      redirect_to :action => :FnF_Request
   end
   
   def block_fnf
       @hmm_user=HmmUsers.find(session[:hmm_user])
       sql = ActiveRecord::Base.connection();
       sql.update "UPDATE family_friends SET block_status='block' WHERE fid=#{params[:id]} and uid=#{logged_in_hmm_user.id}";
       sql.update "UPDATE family_friends SET block_status='imposed_block' WHERE fid=#{logged_in_hmm_user.id} and uid=#{params[:id]}";
       flash[:notice11] = 'Has Been Blocked !!!'
       redirect_to :action => :profile, :id => params[:id]
   end
   
   def unblockFnf
     @hmm_user=HmmUsers.find(session[:hmm_user])
       sql = ActiveRecord::Base.connection();
     sql.update "UPDATE family_friends SET block_status='unblock' WHERE fid=#{params[:id]} and uid=#{logged_in_hmm_user.id}";
     sql.update "UPDATE family_friends SET block_status='unblock' WHERE fid=#{logged_in_hmm_user.id} and uid=#{params[:id]}";
       flash[:notice11] = 'Has Been Succefully Un-Blocked !!!'
       redirect_to :action => :profile, :id => params[:id]
   end

   def add_fnf1
      @friends_family = FamilyFriend.new()
      @friends_family['uid']=logged_in_hmm_user.id
      @friends_family['fid']=params[:id]
      @fnf_groups2 = FnfGroups.find(:all,:conditions=>"uid=#{logged_in_hmm_user.id}",:order=>"id DESC")
      if(params[:fnf_category_other123]=='' && params[:fnf_category]=='default')
         flash[:notice] = ' cannot be added into your friends list, Please select user group and try again!!'
      else
      if (params[:fnf_category]=="Friends")
       
        fnf_group_count = FnfGroups.count(:all, :conditions => "fnf_category='Friends' and uid=#{logged_in_hmm_user.id}")
        if (fnf_group_count==0)
          @fnf_group = FnfGroups.new()
          @fnf_group['fnf_category']="Friends"
          @fnf_group['uid']=logged_in_hmm_user.id
          #@fnf_groups['fnf_category']="#{params[:fnf_groups][:fnf_category]}"
          @fnf_group.save
          @friends_family['fnf_category']=@fnf_group.id
        else
          fnf_group_default = FnfGroups.find(:all, :conditions => "fnf_category='Friends' and uid=#{logged_in_hmm_user.id}")
          @friends_family['fnf_category']=fnf_group_default[0].id
       end
      else
      if (params[:fnf_category]=="Family")
       
        fnf_group_count = FnfGroups.count(:all, :conditions => "fnf_category='Family' and uid=#{logged_in_hmm_user.id}")
        if (fnf_group_count==0)
          @fnf_group = FnfGroups.new()
          @fnf_group['fnf_category']="Family"
          @fnf_group['uid']=logged_in_hmm_user.id
          #@fnf_groups['fnf_category']="#{params[:fnf_groups][:fnf_category]}"
          @fnf_group.save
          @friends_family['fnf_category']=@fnf_group.id
        else
          fnf_group_default = FnfGroups.find(:all, :conditions => "fnf_category='Family' and uid=#{logged_in_hmm_user.id}")
          @friends_family['fnf_category']=fnf_group_default[0].id
       end
       else
      if(params[:fnf_category_other123]=='')
         @friends_family['fnf_category']=params[:fnf_category]
      else
         @fnf_group = FnfGroups.new()
         
         @fnf_group['fnf_category']=params[:fnf_category_other123]
         @fnf_group['uid']=logged_in_hmm_user.id
         #@fnf_groups['fnf_category']="#{params[:fnf_groups][:fnf_category]}"
         @fnf_group.save
         @friends_family['fnf_category']=@fnf_group.id
      end
    end
  end
      
      @check_request=FamilyFriend.count(:all,:conditions=>"uid=#{params[:id]} and fid=#{logged_in_hmm_user.id}",:order=>"id DESC")
      if(@check_request>0)
          @accept_request1=FamilyFriend.find(:all,:conditions=>"uid=#{params[:id]} and fid=#{logged_in_hmm_user.id}",:order=>"id DESC")
          params[:id]=@accept_request1[0]['id']
          @accept_request=FamilyFriend.find(params[:id])
          @accept_request.status="accepted"
          @accept_request.save
          accept=true
      end
      
      if(accept==true)
        @friends_family.status="accepted"
        flash[:notice] = 'Friend Request Has Been accepted !!!'
      else
        flash[:notice] = 'Friend Request Has Been Sent !!!'
      end  
      @friends_family.save
      
      params[:id]=@friends_family['fid']
      
      @friend_details=HmmUsers.find(params[:id])
      params[:id]=logged_in_hmm_user.id
      @my_details=HmmUsers.find(params[:id])
      params[:id]=@friend_details.id
      
      begin  
        Postoffice.deliver_friend(@friend_details.id,@friend_details.v_fname,@friend_details.v_e_mail,@friend_details.v_user_name,@friend_details[:v_password],@my_details.id,@my_details.v_fname,@my_details.v_e_mail,@my_details.v_myimage,@my_details.e_sex)
      rescue
       logger.info("email no found")
      end
      end
      @hmm_user=HmmUsers.find(params[:id])
      redirect_to :action => :profile, :id => params[:id]
   end

  def send_welcome_email
     Postoffice.deliver_welcome("farooq", "farooq@hysistechnologies.com,see.farooq@gmail.com" )
     flash[:notice] = "You've successfuly registered. Please check your email for a confirmation!"
     render :action => 'index'
   end

  def home
    @hmm_user=HmmUsers.find(session[:hmm_user])
  end

  def guest_book
    @hmm_user=HmmUsers.find(session[:hmm_user])
  end

  def timecapsle
    @hmm_user=HmmUsers.find(session[:hmm_user])
  end

  def help
    @hmm_user=HmmUsers.find(session[:hmm_user])
  end

  def manage
      @hmm_user=HmmUsers.find(session[:hmm_user])
   
if(session[:friend]!='')
  uid1=session[:friend]
else
  uid1=logged_in_hmm_user.id
end

 tagcout = Tag.find_by_sql(" select 
       count(*) as cnt
         from chapter_journals as a,tags as t 
         where 
         a.tag_id=t.id 
         and 
         t.uid=#{uid1} ")
 subcount = SubChapter.find_by_sql("
 select 
        count(*) as cnt
        from 
        sub_chap_journals  as b, 
        sub_chapters as s 
        where 
        s.uid=#{uid1} 
        and 
        b.sub_chap_id=s.id 
 "
 )
 galcount = Galleries.find_by_sql("select 
        count(*) as cnt
        from 
        gallery_journals   as c, 
        galleries as g, 
        sub_chapters as s1
        where 
        s1.uid=#{uid1} 
        and 
        c.galerry_id=g.id 
        and g.subchapter_id=s1.id ")
  
  usercontentcount = UserContent.find_by_sql("
  select 
       count(*) as cnt
        from 
        journals_photos   as d,
        user_contents as u
        where 
        d.user_content_id=u.id and u.uid=#{uid1}
  
  ")
  galcnt=Integer(galcount[0].cnt)
  tagcnt=Integer(tagcout[0].cnt)
   subcnt=Integer(subcount[0].cnt)
    usercontentcnt=Integer(usercontentcount[0].cnt)
  
  @total=tagcnt+subcnt+galcnt+usercontentcnt
  
  @numberofpagesres=@total/10
  
  @numberofpages=@numberofpagesres.round()

if(@params[:page]==nil)
x=0
y=10
@page=0
@nextpage=1
if(@total<10)

 @nonext=1
end
else
  x=10*Integer(@params[:page])
  y=x+10
  @page=Integer(@params[:page])
  @nextpage=@page+1
  @previouspage=@page-1
  if(@page==@numberofpages)
    @nonext=1
  end
  
end


   @tagid=ChapterJournal.find_by_sql("
   (select 
        t.uid as uid,
         a.id as id, 
         a.tag_id as master_id,
         a.v_tag_title as title,
         a.v_tag_journal as descr, 
         a.jtype as jtype, 
         a.d_created_at as d_created_at, 
         a.d_updated_at as d_updated_at 
         from chapter_journals as a,tags as t 
         where 
         a.tag_id=t.id 
         and 
         t.uid=#{uid1}
     ) 
     union 
     (select 
        s.uid as uid,
        b.id as id, 
        b.sub_chap_id as master_id, 
        b.journal_title as title, 
        b.subchap_journal as descr, 
        b.jtype as jtype, 
        b.created_on as d_created_at, 
        b.updated_on as d_updated_at 
        from 
        sub_chap_journals  as b, 
        sub_chapters as s 
        where 
        s.uid=#{uid1} 
        and 
        b.sub_chap_id=s.id 
     ) 
     union 
     (select 
        s1.uid as uid,
        c.id as id,
        c.galerry_id as master_id,
        c.v_title as title, 
        c.v_journal as descr, 
        c.jtype as jtype, 
        c.d_created_on as d_created_at, 
        c.d_updated_on as d_updated_on 
        from 
        gallery_journals   as c, 
        galleries as g, 
        sub_chapters as s1
        where 
        s1.uid=#{uid1} 
        and 
        c.galerry_id=g.id 
        and g.subchapter_id=s1.id) 
     union 
    (select 
        u.uid as uid,
        d.id as id,
        d.user_content_id as master_id,
        d.v_title as title, 
        d.v_image_comment as descr,
        d.jtype as jtype, 
        d.date_added as d_created_at, 
        d.date_added  as d_updated_on 
        from 
        journals_photos   as d,
        user_contents as u
        where 
        d.user_content_id=u.id and u.uid=#{uid1}
     )
     order by d_created_at desc limit #{x}, #{y} ")
  
  
  
  
  
  
  
  if(@params[:page]==nil)
  else
    render :layout => false
  end  
   


 

  end

def uncategorized
  @userid = @params[:id]
  @results =  Tag.find(:all, :conditions=> "default_tag='no' and uid=#{@userid}")
  render :layout => false
end


 def something
     #@hmm_user=HmmUsers.find(session[:hmm_user])
     #@val=JSON.parse(params[:data])
     @val = @params[:data]
     arr = Array.new
     arr = JSON.parse @val
     sql = ActiveRecord::Base.connection();
     puts JSON.pretty_generate(arr)
     #for chapters
     for chap in arr
       # @tag1 = Tag.new
        @tag1 = Tag.new
        @tag1['v_tagname']=chap['name']
        @tag1['uid']=logged_in_hmm_user.id
        chapter_id=chap['id']
        if(chapter_id!=0)
         sql.update "UPDATE tags SET v_tagname='#{chap['name']}' WHERE id=#{chap['id']}";
        else
         @tag1.save
        end
        #for sub chapters
        if(chap['subchapters'] != nil)
          for sub_chap in chap['subchapters']
           @sub_chapter1 = SubChapter.new
           sub_chap_id=sub_chap['id']
           @sub_chapter1.tagid=chapter_id
           @sub_chapter1.uid=logged_in_hmm_user.id
           @sub_chapter1.sub_chapname=sub_chap['name']
           if(sub_chap_id!=0)
            sql.update "UPDATE sub_chapters SET sub_chapname='#{sub_chap['name']}' WHERE id=#{sub_chap['id']}";
           else
             @sub_chapter1.save
           end
           #for user content ( images, videos, audios )

           if(sub_chap[:gallery] != nil)

      for gallery in sub_chap[:gallery]
        for user_cont in gallery[files]
               @user_content1 = UserContent.new
               if(chapter_id==0)
                @user_content1.e_filetype=@tag1.id
               else
                @user_content1.e_filetype=chapter_id
              end
              if (user_cont['type']=="Image")
                @user_content1.e_filetype="image"
              else
                if (user_cont['type']=="Audio")
                 @user_content1.e_filetype="audio"
                else
                  if (user_cont['type']=="video")
                    @user_content1.e_filetype="video"
                  end
                end
              end

               @user_content1.e_filetype=user_cont['type']
               if(sub_chap_id==0)
                @user_content1.sub_chapid=@sub_chapter1.id
               else
                @user_content1.sub_chapid=sub_chap['id']
               end
               @user_content1.uid=logged_in_hmm_user.id
               if(user_cont['id']!=0)
                sql.update "UPDATE user_contents SET v_tagphoto='#{user_cont['name']}' WHERE id=#{user_cont['id']}";
               else
                @user_content1.save
               end
            end
           end
         end
       end
      end
     end
     @ret = arr.to_json
     print @val
     render :layout => false

 end

  def images

  end

  def sub_chapter_gallery
    sort_init 'd_updated_on'
    sort_update
    session[:sub_id]=params[:id]
    
    @subchaapter_belongs_to=SubChapter.find_by_sql("select a.*,b.* from sub_chapters as a,  hmm_users as b where a.id=#{params[:id]} and  a.uid=b.id")
    if(@subchaapter_belongs_to[0]['uid']!=logged_in_hmm_user.id)
      session[:friend]=@subchaapter_belongs_to[0]['uid']
       @total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid and a.fid=#{session[:friend]} and a.status='accepted'")
       if(@total>0)
         session[:semiprivate]="activate"
       else
         session[:semiprivate]=""
      end  
    end
      
    @hmm_user=HmmUsers.find(session[:hmm_user])
    items_per_page = 9
    galery_id=params[:id]
    conditions = ["v_tagname LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?
    if(session[:friend]!='')
      e_access="and e_gallery_acess='public' "
      uid=session[:friend]
    if(session[:semiprivate]=="activate")
     e_access="and (e_gallery_acess='public'  or e_gallery_acess='semiprivate')"
    end
    else
    uid=logged_in_hmm_user.id
    end
    srk=params[:sort_key] 
    sort="#{srk}  #{params[:sort_order]}"
    if( srk==nil)
      sort="id  desc"
    end
    @sub_chapters_galleries_pages, @sub_chapters_gallerie = paginate :galleriess , :order => sort, :per_page => items_per_page, :conditions => "subchapter_id=#{params[:id]} and status='active'    #{e_access}" ,:order => sort
     @countcheck=Galleries.count(:all, :conditions => "subchapter_id=#{params[:id]} and status='active'    #{e_access}")
      for subchap in @sub_chapters_gallerie
      @sub_chapter_count=UserContent.count(:all, :conditions => " gallery_id=#{subchap.id} and status='active'") 
      if(@sub_chapter_count<=0)
        @countcheck=@countcheck-1
      else
        actualid=subchap.id
      
    end 
   end 
         #puts countcheck
    @sub_chapter_journal = SubChapJournal.find(:all, :conditions => "sub_chap_id=#{params[:id]}", :order=>"id DESC")
    #Bread crumb sessions
     @sub_chapter = SubChapter.find(params[:id])
         session[:subchap_id]=params[:id]
         session[:sub_chapname]=@sub_chapter['sub_chapname']
         params[:id]=@sub_chapter['tagid']
     @tag = Tag.find(params[:id])
         session[:chap_id]=params[:id]
         session[:chap_name]=@tag['v_tagname']  
     # Journals count
     params[:id]=galery_id
     @subchap_cnt = SubChapJournal.count(:all, :conditions => "sub_chap_id=#{params[:id]}")
     if request.xml_http_request?
      render :partial => "sub_chapter_gallery", :layout => false
  end
   if(@countcheck==1)
             redirect_to :controller => "customers" , :action => 'chapter_gallery', :id =>actualid
         else 
    render :layout => true
    end
 end

  def create_underdevelop
    @hmm_user=HmmUsers.find(session[:hmm_user])
  end
  
  def tips
     @hmm_user=HmmUsers.find(session[:hmm_user])
      @tip_pages, @tips = paginate :tips, :per_page => 10
  end

  def friends_chapters
  uid=params[:id]
     @total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid and a.fid=#{uid} and a.status='accepted'")
       if(@total>0)
         eacess="and (e_access='public' or e_access='semiprivate')"
       else
         eacess="and e_access='public'"
      end  
    @results = Tag.find(:all, :conditions => "uid=#{params[:id]} and default_tag='yes' and status='active' #{eacess}", :order => "id ASC" )
    render :layout => false
 
  end
   
   
  def chg_password
   @hmm_user=HmmUsers.find(session[:hmm_user])
  end

def chg_password_execute
  sql = ActiveRecord::Base.connection();
    if(params[:pass][:old]!='')
     chk = HmmUsers.count(:all, :conditions => "id=#{logged_in_hmm_user.id} and v_password='#{params[:pass][:old]}'")
     if(chk > 0)
      sql.update "UPDATE hmm_users SET v_password='#{params[:pass][:confirm]}' WHERE id=#{logged_in_hmm_user.id}";
      flash[:notice] = "Your password has been changed sucessfully."
      render :action => 'chg_password'
     else
      flash[:notice] = "Invalid Current password. Please try again"
      render :action => 'chg_password'
     end
   end
 end  
 
 def fnf_show
   items_per_page=20
   
   if (params[:query].nil? || params[:query]=='Search Friends'  )
    params[:query]=""
   else
    fnf_search=" and b.v_fname like '#{params[:query]}%' "  
   end
    
 # @fnf_reqa=FamilyFriend.find(:all, :joins => "as b, hmm_users as a", :conditions => " b.fnf_category=#{params[:id]} and b.status='accepted' and a.id=#{logged_in_hmm_user.id} and b.uid=a.id or b.fid=a.id")
    @fnf_reqa_pages, @fnf_reqa = paginate :hmm_users ,:joins=>"as b , family_friends  as a ", :conditions => "a.fnf_category =#{params[:id]} and a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && a.status='accepted' and a.block_status='unblock' #{fnf_search}", :per_page => items_per_page
    @hmm_user=HmmUsers.find(session[:hmm_user])
     @fnf_req = HmmUsers.find_by_sql("SELECT b.*, a.id as frnid, a.* FROM family_friends  as a ,hmm_users as b  WHERE (a.fid=#{logged_in_hmm_user.id} and a.uid=b.id and a.status='pending')")
     
     @fnf_groups_pages, @fnf_groups = paginate :fnf_groupss, :conditions => " uid=#{logged_in_hmm_user.id} ", :per_page => 10
    @fnfcount=HmmUser.count(:all, :joins=>"as b , family_friends  as a ", :conditions => "a.fnf_category =#{params[:id]} and a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && a.status='accepted' and a.block_status='unblock'")
    
     @fnf_groupsa = FnfGroups.find(params[:id])
    
    flash[:notice_fnf] = 'is your friend now!!'
    
     if request.xml_http_request?
        render :partial => "fnf_grouping", :layout => false
     end
end
 
def change_group
   @fnf_groups = FnfGroups.find(:all, :conditions=>"uid=#{logged_in_hmm_user.id}",:order=>"id DESC")
     render :layout => false
end

def change_group_value
  
  @friends_family = FamilyFriend.find(params[:id])
      
    
      @fnf_groups2 = FnfGroups.find(:all,:conditions=>"uid=#{logged_in_hmm_user.id}",:order=>"id DESC")
      if(params[:fnf_category_other123]=='' && params[:fnf_category]=='default')
         flash[:notice] = ' cannot be added into your friends list, Please select user group and try again!!'
      else
      if(params[:fnf_category_other123]=='')
         @friends_family['fnf_category']=params[:fnf_category]
      else
         @fnf_group = FnfGroups.new()
         @fnf_group['fnf_category']=params[:fnf_category_other123]
         @fnf_group['uid']=logged_in_hmm_user.id
         #@fnf_groups['fnf_category']="#{params[:fnf_groups][:fnf_category]}"
         @fnf_group.save
         @friends_family['fnf_category']=@fnf_group.id
      end
       
      @friends_family.save
      
    end
      flash[:notice_accept] = 'The group changed sucessfully !!!'
    
     # @hmm_user=HmmUsers.find(params[:id])
      redirect_to :action => :fnf_show, :id => @friends_family['fnf_category']
  
  
  
end

def shareJournal_list
 # SELECT * FROM share_journals as a, hmm_users as b WHERE b.id='1' and b.   v_e_mail=a.e_mail and a.expiry_date >= curdate()   DATE_FORMAT(b.expiry_date,'%Y-%m-%d') >= curdate()
  @share_list = ShareJournal.find(:all, :joins => "as a, hmm_users as b", :conditions => "b.id=#{logged_in_hmm_user.id} and b.v_e_mail=a.e_mail and  DATE_FORMAT(a.expiry_date,'%Y-%m-%d') >= curdate()")
   #@share_name = ShareJournal.find(:all, :joins => "as a, hmm_users as b", :conditions => "b.id=#{logged_in_hmm_user.id} )
    
    @fnf_req = FamilyFriend.find_by_sql("SELECT b.*, a.id as frnid, a.* FROM family_friends  as a ,hmm_users as b  WHERE (a.fid=#{logged_in_hmm_user.id} and a.uid=b.id and a.status='pending')")
     
    @fnf_groups_pages, @fnf_groups = paginate :fnf_groupss, :conditions => " uid=#{logged_in_hmm_user.id} ", :per_page => 10
    flash[:notice_fnf] = 'is your friend now!!'
  
end


def list_share
    @fnf_req = FamilyFriend.find_by_sql("SELECT b.*, a.id as frnid, a.* FROM family_friends  as a ,hmm_users as b  WHERE (a.fid=#{logged_in_hmm_user.id} and a.uid=b.id and a.status='pending')")
     
     @fnf_groups_pages, @fnf_groups = paginate :fnf_groupss, :conditions => " uid=#{logged_in_hmm_user.id} ", :per_page => 10
    flash[:notice_fnf] = 'is your friend now!!'
  
end

def list_export
    @fnf_req = FamilyFriend.find_by_sql("SELECT b.*, a.id as frnid, a.* FROM family_friends  as a ,hmm_users as b  WHERE (a.fid=#{logged_in_hmm_user.id} and a.uid=b.id and a.status='pending')")
     
     @fnf_groups_pages, @fnf_groups = paginate :fnf_groupss, :conditions => " uid=#{logged_in_hmm_user.id} ", :per_page => 10
    flash[:notice_fnf] = 'is your friend now!!'
 

end

def list_imports
    @fnf_req = FamilyFriend.find_by_sql("SELECT b.*, a.id as frnid, a.* FROM family_friends  as a ,hmm_users as b  WHERE (a.fid=#{logged_in_hmm_user.id} and a.uid=b.id and a.status='pending')")
     
     @fnf_groups_pages, @fnf_groups = paginate :fnf_groupss, :conditions => " uid=#{logged_in_hmm_user.id} ", :per_page => 10
    flash[:notice_fnf] = 'is your friend now!!'
 

end

def myimagePreview
  @hmm_user=HmmUsers.find(session[:hmm_user])
  render :layout => false
end
 
 
  def familywebsite_password
    render :layout => false
  end
 
 def knowhmm
   render :layout => false
 end
 
  def remove_dot
   sql = ActiveRecord::Base.connection()
   get_titles=UserContent.find_by_sql("select v_tagphoto,id from  user_contents")
   for i in get_titles
    res_str=i.v_tagphoto
    puts res_str
     if(res_str=='' || res_str=='NULL' || res_str==nil)
     else 
      count=res_str.scan(".").length
     end
     if(count>0)
       if(res_str=='' || res_str=='NULL' || res_str==nil)
       else 
       content=res_str.split('.')
       end
      if(content[1]=='jpg' || content[1]=='gif' || content[1]=='png' || content[1]=='avi' || content[1]=='mp3' || content[1]=='flv')
       #if(content[0]=='' || content[0]=='NULL' || content[0]==nil)
       #else
       content2=content[0].split('_')
       #end
       rest_res=content2[1]
       sql.update("update user_contents set v_tagphoto='#{rest_res}' where id='#{i.id}' ")
      end
    end
 end
end


def replace_dates
   sql = ActiveRecord::Base.connection()
    get_dates=UserContent.find_by_sql("select d_createddate,id,d_momentdate from  user_contents")
    for i in get_dates
      puts i.d_createddate
      
      if(i.d_momentdate=="0000-00-00 00:00:00" || i.d_momentdate=='Null' || i.d_momentdate=='' || i.d_momentdate==nil)
         if(i.d_createddate=="0000-00-00 00:00:00" || i.d_createddate=='Null' || i.d_createddate=='' || i.d_createddate==nil)
             sql.update("update user_contents set d_momentdate='2008-04-01', d_createddate='2008-04-01' where id='#{i.id}' ")
         tm=Time.now
tm=tm.strftime("%Y-%m-%d %I:%M:%S")
          else
            crdate=i.d_createddate
            createddate=crdate.strftime("%Y-%m-%d %I:%M:%S")
            sql.update("update user_contents set d_momentdate='#{createddate}' where id='#{i.id}' ")
            puts "do it"
         end 
      else
         if(i.d_createddate=="0000-00-00 00:00:00" || i.d_createddate=='Null' || i.d_createddate=='' || i.d_createddate==nil)
             sql.update("update user_contents set d_createddate='#{i.d_momentdate}' where id='#{i.id}' ")
         end
      end
    end
end

def friends_share

  @id=params[:id]
  
  @hmm_user=HmmUser.find(params[:id])
  
  render :layout => false
  
end 

def calendar
  
    

end
  
  def select_accountType
    
  end
  
  def authorise_payment
     @hmm_user=HmmUser.find(params[:id])
  end
  
  def authorise_verify
    if(session[:hmm_user].nil?)
     else
      redirect_to "https://www.holdmymemories.com/user_account/login/?msg=1"
      
     end
  end
  
  def upgrade
    session[:friend]=""
    @hmm_user=HmmUser.find(logged_in_hmm_user.id)
    
  end
 
  def generate_receipt
    @hmm_user_id=HmmUser.find(:all, :conditions => "unid = '#{params[:id]}'")
    @hmm_user=HmmUser.find(@hmm_user_id[0].id)
    render :layout => false
  end
  
  def upgrade_select
    session[:friend]=""
  end
  
  def upgarde_sucess
    
  end
  
  def terms_conditions
   render :layout => false
 end
 
 def cancel_subscription
   #if(logged_in_hmm_user.emp_id==nil || logged_in_hmm_user.emp_id=='')
    #redirect_to :controller => "payment_upgrade", :action => "cancel_subscript"
   #end
 end
 
 def cancel_sub
   reason = params[:reason]
   @hmm_user = HmmUser.find(logged_in_hmm_user.id)
   @hmm_user.cancel_reason=params[:reason]
   @hmm_user.cancel_status='pending'
   @hmm_user.cancellation_request_date = Time.now
   @hmm_user.save
   if(@hmm_user.emp_id == nil || @hmm_user.emp_id == "")
     flash[:notice] = 'Your Subscription Cancellation request has been sent sucessfully.'
     Postoffice.deliver_cancellation_request(@store_employee.employe_name,@store_employee.e_mail,logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,logged_in_hmm_user.street_address,logged_in_hmm_user.postcode,logged_in_hmm_user.city,logged_in_hmm_user.state,logged_in_hmm_user.country,logged_in_hmm_user.telephone, reason)
     Postoffice.deliver_cancellation_request_response(@store_employee.e_mail,logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber)
   else
     #@store_employee = EmployeAccount.find(@hmm_user.emp_id)
     flash[:notice] = 'Your Subscription Cancellation request has been sent sucessfully.'
     Postoffice.deliver_cancellation_request("Admin","admin@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber,logged_in_hmm_user.street_address,logged_in_hmm_user.postcode,logged_in_hmm_user.city,logged_in_hmm_user.state,logged_in_hmm_user.country,logged_in_hmm_user.telephone, reason)
     Postoffice.deliver_cancellation_request_response("admin@holdmymemories.com",logged_in_hmm_user.v_fname,logged_in_hmm_user.v_lname,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.account_type,logged_in_hmm_user.amount,logged_in_hmm_user.subscriptionnumber,logged_in_hmm_user.invoicenumber)
   end
     render :action => 'cancel_sucess'
 end
 
  def update_email
    session[:friend]=""
  end
  
  def email_save
     @hmmuser = HmmUser.find(params[:id])
     @hmmuser.v_e_mail=params[:hmm_user][:v_e_mail]
     @hmmuser.save
     redirect_to :controller => 'tags', :action => 'coverflow'
  end
  
  def uptodate_email
     render :layout => false
  end
  
  def email_uptodate
      hmm_user_count=HmmUser.count(:all,:conditions => "v_user_name='#{params[:uname]}' and v_e_mail like '%Please%' " )
      if(hmm_user_count == 1)
        hmm_user=HmmUser.find(:all,:conditions => "v_user_name='#{params[:uname]}' and v_e_mail like '%Please%' " )
        params[:id]=hmm_user[0]['id']
        @hmm=HmmUser.find(params[:id])
        @hmm.v_e_mail=params[:email]
        if(@hmm.save)
         flash[:notice]= "sucessfully updated"
        else
          flash[:notice]= "error in update"
        end
      else
        flash[:notice]= "no redcords found"
      end
      redirect_to :action => 'uptodate_email'
  end
  
  def silentposttest
#    puts "Send email to customer and notify them sucessful payment received."
#      hmm_user = HmmUser.find(:all, :conditions => "subscriptionnumber='#{params[:x_subscription_id]}'")
#      hmmuser=HmmUser.find(hmm_user[0]['id'])
#      acctype = hmmuser.account_type
#      hmmuser.account_type="platinum_user"
#      @hmm_user_max =  HmmUser.find_by_sql(" select ADDDATE(CURDATE(),INTERVAL 1 MONTH) as m")
#      account_expdate= @hmm_user_max[0]['m']
#      hmmuser.account_expdate = account_expdate
#      count=Integer(hmm_user[0]['payments_recieved'])
#      hmmuser.payments_recieved= count + 1
#      hmmuser.save
#      if(hmmuser.save)
#        #Postoffice.deliver_paymentdeclained("#{hmmuser.v_fname}  #{hmmuser.v_lname}" , "#{hmmuser.v_e_mail}" , hmmuser.v_user_name, hmmuser.invoicenumber, acctype,hmmuser.months,hmmuser.amount, "#{params[:x_subscription_id]}","Payment Declined")
#      end
    
    end
  
  def slient_sucess
    
    
  end
  
  def silent_fail
    
  end
  
  
end
