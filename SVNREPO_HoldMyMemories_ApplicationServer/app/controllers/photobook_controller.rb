require 'builder'

#require 'xmlsimple'

class PhotobookController < ApplicationController
  require 'json/pure'
  layout "myfamilywebsite"

  def photobook
    params[:id]=logged_in_hmm_user.family_name
  end
  
  def savephotobook
    @xmldata = params[:photobookdata];
    filename = "flipbookxml.xml";
    fout = File.open("#{RAILS_ROOT}/public/#{filename}", "w")
    fout.puts @xmldata;
    fout.close
    xml = XmlSimple.xml_in("#{RAILS_ROOT}/public/#{filename}","keeproot" => false)
    XmlSimple.xml_out(xml, "outputfile" =>  "#{RAILS_ROOT}/public/#{filename}",
      "xmldeclaration" => "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
      "rootname" => "images",
      "anonymoustag" => "")
        
    render:layout => false
  end


  def show_flipbook
    @photobook=Photobook.find(params[:id])
    if(@photobook.photobook_audio_id!=nil && @photobook.photobook_audio_id!='')
      @photobook_audio=PhotobookAudio.find(@photobook.photobook_audio_id)
    else
      @photobook_audio=''
    end
    @backgrounds=PhotobookBackground.find(:all,:conditions=>"photobook_layouts_id=#{@photobook.type_id}",:order => 'id desc ')
    @stickers=PhotobookSticker.find(:all,:order => 'id desc ')
    @borders=PhotobookBorder.find(:all,:conditions=>"photobook_layouts_id=#{@photobook.type_id}",:order => 'id desc ')
    render:layout => false
  end
 
  def show_photobooks
    @photobook=Photobook.find(:all, :conditions => " uid='#{logged_in_hmm_user.id}'")
    render:layout => false
  end

  def show_photobook_templates
    @pbook_templates = PhotobookTemplate.find(:all,:conditions => "id != 7 and id != 14 ")
    render:text => @pbook_templates.to_json
  end

 
  def savepage
   
    #   directory = "public"+"/FlipBook"
    #    # create the file path
    #    filename = params[:file]
    #    path = File.join(directory,filename)
    #   # hmm_user['v_myimage'].original_filename.thumbnail(200, 200)
    #    # write the file
    #    base64 = Base64;
    #    begin
    #      data = base64.decode64(params[:imagesnapshot])
    #    rescue
    #      logger.info("Unable decode in save page");
    #    end
    #
    #   begin
    #     File.open(path, "wb"){ |f| f.write(data) }
    #   rescue
    #     logger.info("Unable to save decoded file in save page");
    #   end
    #    begin
    #      system("convert #{RAILS_ROOT}/public/FlipBook/#{params[:file]} #{RAILS_ROOT}/public/FlipBook/#{params[:file]}")
    #    rescue
    #      logger.info("Unable to rewrite saved file in save page");
    #    end
    #
    #    begin
    #       File.delete("#{RAILS_ROOT}/public/FlipBook/#{params[:oldphotoBookPage]}")
    #    rescue
    #       logger.info("Unable to delete old photobook page in save page");
    #    end
    filename = "#{RAILS_ROOT}/public/FlipBook/#{params[:file]}"
    @images = params[:images]
    @imagesarr = @images.split("&");
    i = 0;
    for image in @imagesarr
      @imagedata = image.split("$");
      if(i == 0)
        command = "convert "+"\\"+"\( " +"\\"+"\( #{RAILS_ROOT}/public" + @imagedata[1] +" -resize "+ @imagedata[2] + "x" + @imagedata[3]+" "+" -matte -virtual-pixel transparent  +distort ScaleRotateTranslate '0,0  1,1 "+@imagedata[4]  + " " + @imagedata[12] + "," + @imagedata[13]+"' -background transparent " + "\\"+"\)"+ " " + "\\"+"\)"+" +page -matte -background None #{RAILS_ROOT}/public#{params[:background]} -insert 0 -flatten "+filename;           
        #command = "convert "+"\\"+"\( " +"\\"+"\( #{RAILS_ROOT}/public" + @imagedata[1] +" -resize 1000x1000 -affine " + @imagedata[8] + "," + @imagedata[9] + "," + @imagedata[10] + "," + @imagedata[11] + ",0,0"  + " -transform -resize " + @imagedata[2] + "x" + @imagedata[3]+" " + "-affine 1,0,0,1," + @imagedata[12] + "," + @imagedata[13]+" -transform " + "\\"+"\)"+ " " + "\\"+"\)"+" +page -matte -background None #{RAILS_ROOT}/public#{params[:background]} -insert 0 -flatten "+filename;
      else
        command = "convert "+"\\"+"\( " +"\\"+"\( #{RAILS_ROOT}/public" + @imagedata[1] +" -resize "+ @imagedata[2] + "x" + @imagedata[3]+" "+" -matte -virtual-pixel transparent  +distort ScaleRotateTranslate '0,0  1,1 "+@imagedata[4]  + " " + @imagedata[12] + "," + @imagedata[13]+"' -background transparent " + "\\"+"\)"+ " " + "\\"+"\)"+" +page -matte -background None #{filename} -insert 0 -flatten "+filename;
        #command = "convert "+"\\"+"\( -resize "+ @imagedata[2] + "x" + @imagedata[3]+" " +"\\"+"\( #{RAILS_ROOT}/public" + @imagedata[1] +" -affine " + @imagedata[8] + "," + @imagedata[9] + "," + @imagedata[10] + "," + @imagedata[11] + "," + @imagedata[12] + "," + @imagedata[13] + " -transform" + " " + "\\"+"\)"+ " " + "\\"+"\)"+" +page -matte -background None "+filename+" -insert 0 -flatten "+filename;
      end
    
      begin
        system(command);
      rescue
        logger.log("Unable create image while saving page");
      end
    
      i = i + 1;
    end
    begin
      File.delete("#{RAILS_ROOT}/public/FlipBook/#{params[:oldphotoBookPage]}")
    rescue
      logger.info("Unable to delete old photobook page in save page");
    end
    @xmldata = params[:photobookdata];
    filename = "flipbookxml.xml";
    fout = File.open("#{RAILS_ROOT}/public/#{filename}", "w")
    fout.puts @xmldata;
    fout.close
    xml = XmlSimple.xml_in("#{RAILS_ROOT}/public/#{filename}","keeproot" => false)
    XmlSimple.xml_out(xml, "outputfile" =>  "#{RAILS_ROOT}/public/#{filename}",
      "xmldeclaration" => "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
      "rootname" => "images",
      "anonymoustag" => "")
    render:layout => false
  end


  def createphotobook
    filenames = Array.new;
    inputIds = params[:idList]
    idArray = inputIds.to_s.split(":")
    condition = idArray.join(",")
    @result = String.new
    images = UserContent.find(:all, :conditions => "id in (#{condition})", :order =>'id desc')
    imageMap = Hash.new
    for image in images
      imageMap[image.id.to_s] = image.v_filename
    end
    filename = "flipbookxml.xml"
    xmlBuilder = Builder::XmlMarkup.new(:target => @result, :indent => 1)
    xmlBuilder.instruct!
    i = 0
    for contentid in idArray
      contid = contentid.to_s
      image = imageMap[contid]
      filenames[i] = image;
      i = i + 1
    end
    i = 0;
    chars = ["A".."Z","a".."z","0".."9"].collect { |r| r.to_a }.join ;
    suffix = (1..8).collect { chars[rand(chars.size)] }.pack("C*")
    
    filename = suffix; 
    xmlBuilder.images {
                
      while(i < filenames.length)
        if(i + 2 < filenames.length)
          begin
            system("convert -resize 200x300 -border 4x4 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i+1]} #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}tiledimage.jpg");
            #system("convert -resize 400x400 -border 10x10 -background transparent -rotate 15 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i+1]} #{RAILS_ROOT}/public/FlipBook/#{filename}tiledimage.png");
            system("convert -resize 150x400 -border 4x4 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}untiltedimage.jpg")
            #system("convert -resize 400x800 -border 15x15 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} #{RAILS_ROOT}/public/FlipBook/#{filename}untiltedimage.jpg");
            system("convert #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} -resize 400x530^ -gravity center -extent 400x530 -colorspace gray #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}background.jpg");
            #system("convert #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} -resize 1000x800^ -gravity center -extent 1000x800 -colorspace gray #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}background.jpg");
            command = "convert -page +5+100 #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}untiltedimage.jpg -page +180+60 "+ "\\"+"\(" +" -rotate 15 -background transparent #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}tiledimage.jpg "+ "\\"+"\)" +" +page -matte -background None #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}background.jpg -insert 0 -flatten  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}templateone.jpg";
            logger.info(command);
            system(command);
            #system("convert -resize 400x530 #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}templateone.jpg #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}templateone.jpg");
          rescue
            logger.info("Error while creating template one");
          end
          xmlBuilder.img{
            # xmlBuilder.file("","file" => "/FlipBook/#{filename}#{i}templateone.jpg")
            xmlBuilder.childImage("","a" => 0, "b" => 0, "c" => 0, "d" => 0, "tx" => 0, "ty" => 0,"id" => idArray[i], "transformX" => 0, "transformY" => 0, "path" => "#{filenames[i]}","background" => "true", "rotation" => 0,"x" => 5, "y" => 100, "width" => 0, "height" => 0, "file" => "/FlipBook/#{filename}#{i}untiltedimage.jpg")
            xmlBuilder.childImage("","a" => 0, "b" => 0, "c" => 0, "d" => 0, "tx" => 0, "ty" => 0,"id" => idArray[i + 1], "transformX" => 0, "transformY" => 0,  "path" => "#{filenames[i+1]}", "background" => "false", "rotation" => 15,"x" => 180, "y" => 60, "width" => 0, "height" => 0, "file" => "/FlipBook/#{filename}#{i}tiledimage.jpg")
            xmlBuilder.backgroundImage("", "file" => "/FlipBook/#{filename}#{i}background.jpg")
            xmlBuilder.photobook("","file" => "/FlipBook/#{filename}#{i}templateone.jpg")
          }
                        
          i = i + 2;
        end
                     
                      
        if(i + 2 < filenames.length)
          begin
            system("convert -resize 200x300 -border 4x4 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i+1]} #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}tiltedimageright.jpg");
            #system("convert -resize 300x300 -border 10x10 -background transparent -rotate 20 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i+1]} #{RAILS_ROOT}/public/FlipBook/#{filename}tiltedimageright.png");
            system("convert -resize 150x400 -border 4x4 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}tiltedimageleft.jpg");
            #system("convert -resize 400x800 -border 15x15 -background transparent -rotate -15 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} #{RAILS_ROOT}/public/FlipBook/#{filename}tiltedimageleft.png");
            system("convert #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} -resize 400x530^ -gravity center -extent 400x530 -size 1x1 xc:'rgb(204,153,2)' -fx '1-(1-v.p{0,0})*(1-u)' #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}background.jpg");
            command = "convert -page +99+141 " + "\\"+"\("+ " -rotate 20 -background transparent #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}tiltedimageright.jpg " + "\\" +"\)" +" -page +121+288 "+"\\"+"\(" + " -rotate 345 -background transparent #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}tiltedimageleft.jpg "+ "\\" +"\)" +" +page -matte -background None  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}background.jpg -insert 0 -flatten #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}templatethree.jpg";
            system(command);
            #system("convert -resize 400x530 #{RAILS_ROOT}/public/FlipBook/#{filename}{i}templatethree.jpg  #{RAILS_ROOT}/public/FlipBook/#{filename}{i}templatetwo.jpg")
          rescue
            logger.info("Error while creating template three");
          end
                        
          xmlBuilder.img{
            #xmlBuilder.file("","file" => "#{RAILS_ROOT}/public/FlipBook/#{filename}{i}templatethree.jpg")
            xmlBuilder.childImage("","a" => 0, "b" => 0, "c" => 0, "d" => 0, "tx" => 0, "ty" => 0,"id" => idArray[i+1], "transformX" => 0, "transformY" => 0, "path" => "#{filenames[i+1]}", "background" => "false", "rotation" => 20, "x"  => 99, "y" => 141, "width" => 0, "height" => 0, "file" => "/FlipBook/#{filename}#{i}tiltedimageright.jpg")
            xmlBuilder.childImage("","a" => 0, "b" => 0, "c" => 0, "d" => 0, "tx" => 0, "ty" => 0,"id" => idArray[i], "transformX" => 0, "transformY" => 0, "path" => "#{filenames[i]}","background" => "true", "rotation" => 345, "x"  => 122, "y" => 288, "width" => 0, "height" => 0, "file" => "/FlipBook/#{filename}#{i}tiltedimageleft.jpg")
            xmlBuilder.backgroundImage("", "file" => "/FlipBook/#{filename}#{i}background.jpg")
            xmlBuilder.photobook("","file" => "/FlipBook/#{filename}#{i}templatethree.jpg")
          };
          i = i + 2;
        end
                      
        if(i+3 < filenames.length)
          begin
            #system("convert -resize 500x500 -border 10x10 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]}  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}tiltedimagecenter.jpg  &&  convert -resize 300x300 -border 10x10 -background transparent -rotate 20 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i+1]} #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}tiltedimageright.png &&  convert -resize 300x300 -border 10x10 -background transparent -rotate -6 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i+2]} #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}tiltedimageleft.png &&  convert #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} -resize 1000x800^ -gravity center -extent 1000x800 -colorspace gray  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}tiltedimagebackground.jpg && convert -page +320+100  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}tiltedimagecenter.jpg -page +30+100 #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}tiltedimageleft.png -page +600+380 #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}tiltedimageright.png  +page -matte -background None #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}tiltedimagebackground.jpg -insert 0 -flatten  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}templatefour.jpg && convert -resize 400x530 #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}templatefour.jpg #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}templatefour.jpg")
            system("convert -resize 250x300 -border 4x4 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]}  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}tiltedimagecenter.jpg");
            system("convert -resize 200x200 -border 4x4 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i+1]} #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}tiltedimageright.jpg");
            system("convert -resize 200x200 -border 4x4 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i+2]} #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}tiltedimageleft.jpg");
            system("convert #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} -resize 400x530^ -gravity center -extent 400x530 -colorspace gray  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}tiltedimagebackground.jpg");
            command = "convert -page +70+320  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}tiltedimagecenter.jpg -page +60+170 "+ "\\" + "\(" + " -rotate 20 -background transparent #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}tiltedimageright.jpg "+"\\"+"\)" +" -page +130+67 "+ "\\"+"\(" + " -rotate 354 -background transparent #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}tiltedimageleft.jpg "+"\\"+"\)"+" +page -matte -background None #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}tiltedimagebackground.jpg -insert 0 -flatten  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}templatefour.jpg"
            system(command);
            #system("convert -resize 400x530 #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}templatefour.jpg #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}templatefour.jpg")
          rescue
            logger.info("Error while creating template two");
          end
          xmlBuilder.img{
            xmlBuilder.childImage("","a" => 0, "b" => 0, "c" => 0, "d" => 0, "tx" => 0, "ty" => 0,"id" => idArray[i], "transformX" => 0, "transformY" => 0, "path" => "#{filenames[i]}", "background" => "true", "rotation" => 0, "x"  => 70, "y" => 320, "width" => 0, "height" => 0, "file" => "/FlipBook/#{filename}#{i}tiltedimagecenter.jpg")
            xmlBuilder.childImage("","a" => 0, "b" => 0, "c" => 0, "d" => 0, "tx" => 0, "ty" => 0,"id" => idArray[i+1], "transformX" => 0, "transformY" => 0, "path" => "#{filenames[i]}", "background" => "false", "rotation" => 20, "x"  => 60, "y" => 170, "width" => 0, "height" => 0, "file" => "/FlipBook/#{filename}#{i}tiltedimageright.jpg")
            xmlBuilder.childImage("","id" => idArray[i+2], "transformX" => 0, "transformY" => 0, "path" => "#{filenames[i+2]}","background" => "false", "rotation" => 354, "x"  => 130, "y" => 67, "width" => 0, "height" => 0, "file" => "/FlipBook/#{filename}#{i}tiltedimageleft.jpg")
            xmlBuilder.backgroundImage("", "file" => "/FlipBook/#{filename}#{i}tiltedimagebackground.jpg")
            xmlBuilder.photobook("","file" => "/FlipBook/#{filename}#{i}templatefour.jpg")
          };
          i = i + 3;
        end
                      
        if(i+3 < filenames.length)
          begin
            system("convert -resize 300x300 -border 4x4 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}borderone.jpg");
            system("convert -resize 150x150 -border 4x4 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i+1]} #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}bordertwo.jpg");
            system("convert -resize 300x300 -border 4x4 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i+2]} #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}borderthree.jpg");
            system("convert #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} -resize 400x530^ -gravity center -extent 400x530 -size 1x1 xc:'rgb(204,153,2)' -fx '1-(1-v.p{0,0})*(1-u)' #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}borderimagebackground.jpg");
            system("convert -page +35+370  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}borderone.jpg -page +219+1 #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}bordertwo.jpg -page +0+0  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}borderthree.jpg  +page -matte -background None #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}borderimagebackground.jpg -insert 0 -flatten  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}templatefive.jpg");
            #system("convert -resize 1200x1200 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} -size 1x2  gradient:gold-firebrick -fx 'v.p{0,0}*u+v.p{0,1}*(1-u)' #{RAILS_ROOT}/public/FlipBook/#{i}background.jpg")
            #system("composite -dissolve 180  -gravity NorthWest #{RAILS_ROOT}/public/FlipBook/#{filename}borderone.jpg  #{RAILS_ROOT}/public/FlipBook/#{i}background.jpg  -matte  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}desolve.jpg")
            #system("composite -dissolve 100  -gravity NorthEast #{RAILS_ROOT}/public/FlipBook/#{filename}bordertwo.jpg  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}desolve.jpg  -matte  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}desolve.jpg")
            #system("composite -dissolve 100  -gravity South #{RAILS_ROOT}/public/FlipBook/#{filename}borderthree.jpg  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}desolve.jpg  -matte  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}desolve.jpg")
            #system("convert -resize 400x530 #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}desolve.jpg #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}desolve.jpg");
          rescue
            logger.info("Error while creating template two");
          end
          xmlBuilder.img{
            xmlBuilder.childImage("","a" => 0, "b" => 0, "c" => 0, "d" => 0, "tx" => 0, "ty" => 0,"id" => idArray[i], "transformX" => 0, "transformY" => 0, "path" => "#{filenames[i]}", "background" => "true", "rotation" => 0, "x"  => 35, "y" => 370, "width" => 0, "height" => 0, "file" => "/FlipBook/#{filename}#{i}borderone.jpg")
            xmlBuilder.childImage("","a" => 0, "b" => 0, "c" => 0, "d" => 0, "tx" => 0, "ty" => 0,"id" => idArray[i+1], "transformX" => 0, "transformY" => 0, "path" => "#{filenames[i+1]}","background" => "false", "rotation" => 0, "x"  => 219, "y" => 1, "width" => 0, "height" => 0, "file" => "/FlipBook/#{filename}#{i}bordertwo.jpg")
            xmlBuilder.childImage("","a" => 0, "b" => 0, "c" => 0, "d" => 0, "tx" => 0, "ty" => 0,"id" => idArray[i+2], "transformX" => 0, "transformY" => 0, "path" => "#{filenames[i+2]}", "background" => "false", "rotation" => 0, "x"  => 0, "y" => 0, "width" => 0, "height" => 0, "file" => "/FlipBook/#{filename}#{i}borderthree.jpg")
            xmlBuilder.backgroundImage("", "file" => "/FlipBook/#{filename}#{i}borderimagebackground.jpg")
            xmlBuilder.photobook("","file" => "/FlipBook/#{filename}#{i}templatefive.jpg")
          };
          i = i + 3;
        end
                                         
        if(i < filenames.length)
          begin
            #system("convert -resize 500x500 -mattecolor white -frame 10x10 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} #{RAILS_ROOT}/public/FlipBook/#{i}framelevel.jpg && convert -resize 1000x1000  #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]}  +level 25%  #{RAILS_ROOT}/public/FlipBook/#{i}level.jpg && composite -dissolve 180  -gravity center #{RAILS_ROOT}/public/FlipBook/#{i}framelevel.jpg  #{RAILS_ROOT}/public/FlipBook/#{i}level.jpg  -matte  #{RAILS_ROOT}/public/FlipBook/#{i}framelevel.jpg && convert -resize 400x530 #{RAILS_ROOT}/public/FlipBook/#{i}framelevel.jpg #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}framelevel.jpg");
            system("convert -resize 300x400 -border 4x4 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} #{RAILS_ROOT}/public/FlipBook/#{i}singleimage.jpg");
            system("convert #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} -resize 400x530^ -gravity center -extent 400x530 +level 25% #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}singleimagebackground.jpg");
            system("convert -page +59+49  #{RAILS_ROOT}/public/FlipBook/#{i}singleimage.jpg +page -matte -background None  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}singleimagebackground.jpg -insert 0 -flatten #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}templatesix.jpg");
          rescue
            logger.info("Error while cratinf template two frame");
          end
          xmlBuilder.img{
            xmlBuilder.childImage("","a" => 0, "b" => 0, "c" => 0, "d" => 0, "tx" => 0, "ty" => 0,"id" => idArray[i], "transformX" => 0, "transformY" => 0, "path" => "#{filenames[i]}", "background" => "true", "rotation" => 0, "x"  => 59, "y" => 49, "width" => 0, "height" => 0, "file" => "/FlipBook/#{i}singleimage.jpg")
            xmlBuilder.backgroundImage("", "file" => "/FlipBook/#{filename}#{i}singleimagebackground.jpg")
            xmlBuilder.photobook("", "file" => "/FlipBook/#{filename}#{i}templatesix.jpg")
          };
          i = i + 1;
        end
                      
                      
                      
        if(i < filenames.length)
          begin
            system("convert -resize 300x400 -border 4x4 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} #{RAILS_ROOT}/public/FlipBook/#{i}singleimage.jpg");
            system("convert #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} -resize 400x530^ -gravity center -extent 400x530 -size 1x1 xc:'rgb(204,153,2)' -fx '1-(1-v.p{0,0})*(1-u)' #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}singleimagebackground.jpg");
            system("convert -page +59+49  #{RAILS_ROOT}/public/FlipBook/#{i}singleimage.jpg +page -matte -background None  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}singleimagebackground.jpg -insert 0 -flatten #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}templateseven.jpg");
          rescue
            logger.info("Error while creating template three");
          end
          xmlBuilder.img{
            xmlBuilder.childImage("","a" => 0, "b" => 0, "c" => 0, "d" => 0, "tx" => 0, "ty" => 0,"id" => idArray[i], "transformX" => 0, "transformY" => 0, "path" => "#{filenames[i]}", "background" => "true", "rotation" => 0, "x"  => 59, "y" => 49, "width" => 0, "height" => 0, "file" => "/FlipBook/#{i}singleimage.jpg")
            xmlBuilder.backgroundImage("", "file" => "/FlipBook/#{filename}#{i}singleimagebackground.jpg")
            xmlBuilder.photobook("", "file" => "/FlipBook/#{filename}#{i}templateseven.jpg")
          };
          i = i + 1;
        end
                      
        if(i < filenames.length)
          begin
            #system("convert -resize 500x500 -mattecolor white -frame 10x10 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} #{RAILS_ROOT}/public/FlipBook/#{i}framelevel.jpg && convert -resize 1000x1000 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} -size 1x1 xc:'rgb(204,153,51)' -fx '1-(1-v.p{0,0})*(1-u)' #{RAILS_ROOT}/public/FlipBook/#{i}level.jpg && composite -dissolve 180  -gravity center #{RAILS_ROOT}/public/FlipBook/#{i}framelevel.jpg  #{RAILS_ROOT}/public/FlipBook/#{i}level.jpg  -matte  #{RAILS_ROOT}/public/FlipBook/#{i}framelevel.jpg && convert -resize 400x530 #{RAILS_ROOT}/public/FlipBook/#{i}framelevel.jpg #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}framelevel.jpg");
            system("convert -resize 300x400 -border 4x4 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} #{RAILS_ROOT}/public/FlipBook/#{i}singleimage.jpg");
            system("convert #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} -resize 400x530^ -gravity center -extent 400x530 -size 1x1 xc:'rgb(204,153,51)' -fx '1-(1-v.p{0,0})*(1-u)' #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}singleimagebackground.jpg");
            system("convert -page +59+49  #{RAILS_ROOT}/public/FlipBook/#{i}singleimage.jpg +page -matte -background None  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}singleimagebackground.jpg -insert 0 -flatten #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}templateeight.jpg");
          rescue
            logger.info("Error while creating template three");
          end
          xmlBuilder.img{
            xmlBuilder.childImage("","a" => 0, "b" => 0, "c" => 0, "d" => 0, "tx" => 0, "ty" => 0,"id" => idArray[i], "transformX" => 0, "transformY" => 0, "path" => "#{filenames[i]}","background" => "true", "rotation" => 0, "x"  => 59, "y" => 49, "width" => 0, "height" => 0, "file" => "/FlipBook/#{i}singleimage.jpg")
            xmlBuilder.backgroundImage("", "file" => "/FlipBook/#{filename}#{i}singleimagebackground.jpg")
            xmlBuilder.photobook("", "file" => "/FlipBook/#{filename}#{i}templateeight.jpg")
          };
          i = i + 1;
        end
                      
        if(i < filenames.length)
          begin
            #system("convert -resize 500x500 -mattecolor white -frame 10x10 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} #{RAILS_ROOT}/public/FlipBook/#{i}framelevel.jpg && convert -resize 1000x1000 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} -size 1x1 xc:'rgb(238, 149, 114)' -fx '1-(1-v.p{0,0})*(1-u)' #{RAILS_ROOT}/public/FlipBook/#{i}level.jpg && composite -dissolve 180  -gravity center #{RAILS_ROOT}/public/FlipBook/#{i}framelevel.jpg  #{RAILS_ROOT}/public/FlipBook/#{i}level.jpg  -matte  #{RAILS_ROOT}/public/FlipBook/#{i}framelevel.jpg && convert -resize 400x530 #{RAILS_ROOT}/public/FlipBook/#{i}framelevel.jpg #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}framelevel.jpg");
            system("convert -resize 300x400 -border 4x4 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} #{RAILS_ROOT}/public/FlipBook/#{i}singleimage.jpg");
            system("convert #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} -resize 400x530^ -gravity center -extent 400x530 -size 1x1 xc:'rgb(238, 149, 114)' -fx '1-(1-v.p{0,0})*(1-u)' #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}singleimagebackground.jpg");
            system("convert -page +59+49  #{RAILS_ROOT}/public/FlipBook/#{i}singleimage.jpg +page -matte -background None  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}singleimagebackground.jpg -insert 0 -flatten #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}templatenine.jpg");
          rescue
            logger.info("Error while creating template three");
          end
          xmlBuilder.img{
            xmlBuilder.childImage("","a" => 0, "b" => 0, "c" => 0, "d" => 0, "tx" => 0, "ty" => 0,"id" => idArray[i], "transformX" => 0, "transformY" => 0, "path" => "#{filenames[i]}","background" => "true", "rotation" => 0, "x"  => 59, "y" => 49, "width" => 0, "height" => 0, "file" => "/FlipBook/#{i}singleimage.jpg")
            xmlBuilder.backgroundImage("", "file" => "/FlipBook/#{filename}#{i}singleimagebackground.jpg")
            xmlBuilder.photobook("", "file" => "/FlipBook/#{filename}#{i}templatenine.jpg")
          };
          i = i + 1;
        end
                      
        if(i < filenames.length)
          begin
            #system("convert -resize 500x500 -mattecolor white -frame 10x10 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} #{RAILS_ROOT}/public/FlipBook/#{i}framelevel.jpg && convert -resize 1000x1000 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} -size 1x1 xc:'rgb(105, 105, 105)' -fx '1-(1-v.p{0,0})*(1-u)' #{RAILS_ROOT}/public/FlipBook/#{i}level.jpg && composite -dissolve 180  -gravity center #{RAILS_ROOT}/public/FlipBook/#{i}framelevel.jpg  #{RAILS_ROOT}/public/FlipBook/#{i}level.jpg  -matte  #{RAILS_ROOT}/public/FlipBook/#{i}framelevel.jpg && convert -resize 400x530 #{RAILS_ROOT}/public/FlipBook/#{i}framelevel.jpg #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}framelevel.jpg");
            system("convert -resize 300x400 -border 4x4 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} #{RAILS_ROOT}/public/FlipBook/#{i}singleimage.jpg");
            system("convert #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} -resize 400x530^ -gravity center -extent 400x530 -size 1x1 xc:'rgb(105, 105, 105)' -fx '1-(1-v.p{0,0})*(1-u)' #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}singleimagebackground.jpg");
            system("convert -page +59+49  #{RAILS_ROOT}/public/FlipBook/#{i}singleimage.jpg +page -matte -background None  #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}singleimagebackground.jpg -insert 0 -flatten #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}templateten.jpg");
          rescue
            logger.info("Error while creating template three");
          end
          xmlBuilder.img{
            xmlBuilder.childImage("","a" => 0, "b" => 0, "c" => 0, "d" => 0, "tx" => 0, "ty" => 0,"id" => idArray[i], "transformX" => 0, "transformY" => 0, "path" => "#{filenames[i]}","background" => "true", "rotation" => 0, "x"  => 59, "y" => 49, "width" => 0, "height" => 0, "file" => "/FlipBook/#{i}singleimage.jpg")
            xmlBuilder.backgroundImage("", "file" => "/FlipBook/#{filename}#{i}singleimagebackground.jpg")
            xmlBuilder.photobook("", "file" => "/FlipBook/#{filename}#{i}templateten.jpg")
          };
          i = i + 1;
        end
      end
      xmlBuilder.title("","file"=>"/titleImages/myfamilyalbum.png");
    }
    filename = "flipbookxml.xml";
    fout = File.open("#{RAILS_ROOT}/public/#{filename}", "w")
    fout.puts @result
    fout.close
    xml = XmlSimple.xml_in("#{RAILS_ROOT}/public/#{filename}","keeproot" => false)
    XmlSimple.xml_out(xml, "outputfile" =>  "#{RAILS_ROOT}/public/#{filename}",
      "xmldeclaration" => "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
      "rootname" => "images",
      "anonymoustag" => "")

    render:layout => false
    
  end

  



  
  def addphotos
    inputIds = params[:idList]
    idArray = inputIds.to_s.split(":")
    condition = idArray.join(",")
    #@result = String.new
    images = UserContent.find(:all, :conditions => "id in (#{condition})", :order =>'id desc')
    imageMap = Hash.new
    for image in images
      imageMap[image.id.to_s] = image.v_filename
    end
    i = 0
    filenames = Array.new;
    for contentid in idArray
      contid = contentid.to_s
      image = imageMap[contid]
      filenames[i] = image;
      i = i + 1
    end
    i = 0
    chars = ["A".."Z","a".."z","0".."9"].collect { |r| r.to_a }.join ;
    filename = (1..8).collect { chars[rand(chars.size)] }.pack("C*")
    system("convert -resize 200x200 -border 4x4 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}singleimage.jpg");
    @result ="FlipBook/#{filename}#{i}singleimage.jpg&#{filenames[i]}";
    i = i + 1
    while(i < filenames.length)
      system("convert -resize 200x200 -border 4x4 #{RAILS_ROOT}/public/user_content/photos/#{filenames[i]} #{RAILS_ROOT}/public/FlipBook/#{filename}#{i}singleimage.jpg");
      @result = @result + "$" + "/FlipBook/#{filename}#{i}singleimage.jpg&#{filenames[i]}";
      i = i + 1
    end
    render:layout => false
  end
  
  #  def createbackgroundimage
  #    if(@@count < (@@filenames.length -1))
  #      system("montage -size 400x400 null: /user_content/photos/#{@@filenames[@@count]} /user_content/photos/#{@@filenames[@@count]} null: -thumbnail 200x200 -bordercolor white  +polaroid  -resize 30%  -background transparent  -geometry -10+2  -tile x1    /FlipBook/test.png")
  #    end
  #  end

  #save the bookname to photo book
  def add_bookname
    @bkname=Photobook.new()
    @bkname['book_name']=parms['photobook_name']
    @bkname['user_id']=session[:hmm_user]
    @bkname.save

    render :text => @bkname.id
  end


  
  def photobook_layouts
    path = ContentPath.find(:first, :conditions => "status='active'")
    layout_coll=Array.new()
    layouts=PhotobookLayout.find(:all)
    for p_layout in layouts
    p_layout.icon="#{path.proxyname}/images/1.jpg"
    layout=Hash.new()
    layout ={:id => p_layout.id,:type => p_layout.layout_type,:height => p_layout.height,:width =>  p_layout.width, :icon =>  p_layout.icon}
    layout_coll.push(layout)
    end
     render :text => layout_coll.to_json
  end

  def photobook_templates
    templates=PhotobookTemplate.find(:all,:order =>'id asc')
    templ_coll=Array.new()
    path = ContentPath.find(:first, :conditions => "status='active'")
    for template in templates
      templ=Hash.new()
      templ ={:id =>template.id,:name=> template.name,:template_image=>  template.image, :background_image => "#{path.content_path}/user_content/photobook_backgrounds/#{template.background_image}",:border_image => template.border_image,:width =>  template.width,:height =>  template.height,:type_id =>  template.type_id}
      @images=PhotobookTemplateImage.find(:all,:conditions =>"photobook_template_id=#{template.id}")
      image_array = Array.new()
      for image in @images
        templ_images=Hash.new()
        templ_images ={:id =>image.id,:index=>image.image_count,:desired_height=> image.desired_height, :desired_width =>  image.desired_width,:x_shift => image.x_shift,:y_shift => image.y_shift,:x_scale => image.x_scale,:y_scale =>  image.y_scale,:rotation =>image.rotation,:scale_to_fit =>image.scale_to_fit}
        image_array.push(templ_images)
        end
        templ['images'] = image_array
        templ_coll.push(templ)
    end
    render :text => templ_coll.to_json
  end

end
