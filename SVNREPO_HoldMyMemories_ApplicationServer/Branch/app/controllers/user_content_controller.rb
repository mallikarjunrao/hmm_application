class UserContentController < ApplicationController
   def permissions
	   
#	   content = UserContent.find(params[:id])
#	   if(content != nil)
#		   content.e_access = params[:permission]
#		   @result = content.save
#	   end
      sql = ActiveRecord::Base.connection();
      @temp_access_arr = sql.execute("select tags.e_access,sub_chapters.e_access,galleries.e_gallery_acess from tags,sub_chapters,galleries,user_contents where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
      sql.commit_db_transaction;
      i =0
      for access in @temp_access_arr
         case(i)
         when 0:
           @access_arr = access;
         end
         i = i+ 1;
       end
       chap_access = @access_arr[0];
       sub_access = @access_arr[1];
       gall_access = @access_arr[2];
       access = params[:permission] 
       @result = "nothing"
      case(chap_access)
      when "private":
           case(sub_access)
           when "private":
               case(gall_access)
               when "private":
                   case(access)
                   when "private":
                       #change the permission of content only
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                   when "semiprivate":
                       #change the permission of chapter subchapter gallery and content 
                     sql = ActiveRecord::Base.connection();
                     sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                     sql.commit_db_transaction;
                     @result = "chapter$subchapter$gallery"
                   when "public":
                       #change the permission of chapter subchapter gallery and content  
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;          
                       @result = "chapter$subchapter$gallery"                        
                   end
               when "semiprivate":
                   case(access)
                   when "private":
                        #change the permission of content only
                        sql = ActiveRecord::Base.connection();
                        sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                        sql.commit_db_transaction;
                   when "semiprivate":
                        #change the permission of chapter subchapter and content
                        sql = ActiveRecord::Base.connection();
                        sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                        sql.commit_db_transaction;
                        @result = "chapter$subchapter"
                   when "public":
                        #change the permission of chapter subchapter gallery and contents
                        sql = ActiveRecord::Base.connection();
                        sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                        sql.commit_db_transaction; 
                        @result = "chapter$subchapter$gallery"                        
                   end                   
               when "public":
                   case(access)
                   when "private":
                        #change the permission of content only
                        sql = ActiveRecord::Base.connection();
                        sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                        sql.commit_db_transaction;
                   when "semiprivate":
                        #change the permission of chapter subchapter and content
                        sql = ActiveRecord::Base.connection();
                        sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                        sql.commit_db_transaction;
                        @result = "chapter$subchapter"
                   when "public":
                        #change the permission of chapter subchapter and content                       
                        sql = ActiveRecord::Base.connection();
                        sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                        sql.commit_db_transaction;
                        @result = "chapter$subchapter"
                   end                   
               end
           when "semiprivate":
               case(gall_access)
               when "private":
                   case(access)
                   when "private":
                        #change the permission of content
                        sql = ActiveRecord::Base.connection();
                        sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                        sql.commit_db_transaction;
                   when "semiprivate":
                        #change the permission of chapter gallery and content
                        sql = ActiveRecord::Base.connection();
                        sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                        sql.commit_db_transaction;
                        @result = "chapter$gallery"
                   when "public":
                        #change the permission of chapter subchapter gallerry and conent    
                        sql = ActiveRecord::Base.connection();
                        sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                        sql.commit_db_transaction;                       
                        @result = "chapter$subchapter$gallery"                        
                   end
               when "semiprivate":
                   case(access)
                   when "private":
                        #change the permission of content
                        sql = ActiveRecord::Base.connection();
                        sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                        sql.commit_db_transaction;
                   when "semiprivate":
                        #change the permission of chapter and content
                        sql = ActiveRecord::Base.connection();
                        sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                        sql.commit_db_transaction;
                        @result = "chapter";
                   when "public":
                        #change the permission of chapter subchapter gallery and content  
                        sql = ActiveRecord::Base.connection();
                        sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                        sql.commit_db_transaction;                      
                        @result = "chapter$subchapter$gallery"                        
                   end                   
               when "public":
                   case(access)
                   when "private":
                       #change the permission of content 
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                   when "semiprivate":
                       #change the permission of chapter and content
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                       @result = "chapter"
                   when "public":
                       #change the permission of chapter subchapter and content                       
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;                      
                       @result = "chapter$subchapter"
                   end                   
               end
           when "public":
               case(gall_access)
               when "private":
                   case(access)
                   when "private":
                       #change the permission of content
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                   when "semiprivate":
                       #change the permission of chapter gallery and content
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                       @result = "chapter$gallery"
                   when "public":
                       #change the permission of chapter gallery and content                       
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                       @result = "chapter$gallery"
                   end
               when "semiprivate":
                   case(access)
                   when "private":
                       #change the permission of content
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                   when "semiprivate":
                       #change the permission of chapter and content
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                       @result = "chapter"
                   when "public":
                       #change the permission of chapter gallery and content                       
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                       @result = "chapter$gallery"
                   end 
               when "public":
                   case(access)
                   when "private":
                       #change the permission of content
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                   when "semiprivate":
                       #change the permission of chapter and content
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                       @result = "chapter"
                   when "public":
                       #change the permission of chapter and content                       
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                       @result = "chapter"
                   end                   
               end               
           end
      when "semiprivate":
          case(sub_access)     
          when "private":
              case(gall_access)
              when "private":
                  case(access)
                  when "private":
                      #change the permission of content
                      sql = ActiveRecord::Base.connection();
                      sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                      sql.commit_db_transaction;
                  when "semiprivate":
                      #change the permission of subchapter gallery and content
                      sql = ActiveRecord::Base.connection();
                      sql.execute("update sub_chapters,galleries,user_contents set sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                      sql.commit_db_transaction; 
                      @result = "subchapter$gallery"
                  when "public":
                      #change the permission of chapter subchapter gallery and content                      
                      sql = ActiveRecord::Base.connection();
                      sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                      sql.commit_db_transaction; 
                      @result = "chapter$gallery"
                  end
              when "semiprivate":
                  case(access)
                  when "private":
                       #change the permission of content
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                  when "semiprivate":
                       #change the permission of subchapter and content
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update sub_chapters,galleries,user_contents set sub_chapters.e_access='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                       @result = "subchapter"                       
                  when "public":
                       #change the permission of chapter subchapter gallery and content                      
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction; 
                       @result = "chapter$subchapter$gallery"
                  end                  
              when "public":
                  case(access)
                  when "private":
                       #change the permission of content
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                  when "semiprivate":
                       #change the permission of subchapter and content
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update sub_chapters,galleries,user_contents set sub_chapters.e_access='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;           
                       @result = "subchapter"                       
                  when "public":
                       #change the permission of chapter subchapter and content                      
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction; 
                       @result = "chapter$subchapter"
                  end                  
              end
           when "semiprivate"
              case(gall_access)
              when "private":
                  case(access) 
                  when "private":
                       #change the permission of content
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                  when "semiprivate":
                       #change the permission of gallery and content
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update galleries,user_contents set galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction; 
                       @result = "gallery"
                  when "public":
                       #change the permission of chapter subchapter gallery and content
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction; 
                       @result = "chapter$subchapter$gallery"
                  end
              when "semiprivate":
                  case(access)
                  when "private":
                       #change the permission of content
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                  when "semiprivate":
                       #change the permission of content
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                  when "public":
                       #change the permission of chapter subchapter gallery and content
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction; 
                       @result = "chapter$subchapter$gallery"
                  end
              when "public":
                  case(access)
                  when "private":
                       #change the permission of content
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                  when "semiprivate":
                       #change the permission of content
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                  when "public":
                       #change the permission of chapter subchapter and content                      
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',sub_chapters.e_access='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction; 
                       @result = "chapter$subchapter"
                  end                  
              end
          when "public":
              case(gall_access)
              when "private":
                  case(access)
                  when "private":
                      #change the permission of content
                      sql = ActiveRecord::Base.connection();
                      sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                      sql.commit_db_transaction;
                  when "seemiprivate":
                      #change the permission of gallery and content
                      sql = ActiveRecord::Base.connection();
                      sql.execute("update galleries,user_contents set galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                      sql.commit_db_transaction; 
                      @result = "gallery"
                  when "public":
                      #change the permission of chapter gallery and content                      
                      sql = ActiveRecord::Base.connection();
                      sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                      sql.commit_db_transaction; 
                      @result = "chapter$gallery"
                  end
              when "semiprivate":
                  case(access)
                  when "private":
                      #change the permission of content
                      sql = ActiveRecord::Base.connection();
                      sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                      sql.commit_db_transaction;
                  when "semiprivate":
                      #change the permission of content
                      sql = ActiveRecord::Base.connection();
                      sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                      sql.commit_db_transaction;
                  when "public":
                      #change the permission of chapter gallery and content                      
                      sql = ActiveRecord::Base.connection();
                      sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                      sql.commit_db_transaction;
                      @result = "chapter$gallery"                      
                  end                  
              when "public":
                  case(access)
                  when "private":
                       #change the permission of content
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                  when "semiprivate":
                       #change the permission of content
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                  when "public":
                       #change the permission of chapter and content                      
                       sql = ActiveRecord::Base.connection();
                       sql.execute("update tags,sub_chapters,galleries,user_contents set tags.e_access='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where tags.id=sub_chapters.tagid and sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                       sql.commit_db_transaction;
                       @result = "chapter"
                  end                  
              end
          
          end 
      when "public":
              case(sub_access)
              when "private":
                  case(gall_access)
                  when "private":
                      case(access)
                      when "private":
                          #change the permission of content
                          sql = ActiveRecord::Base.connection();
                          sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                          sql.commit_db_transaction;
                      when "semiprivate":
                          #change the permission of subchapter gallery and content
                          sql = ActiveRecord::Base.connection();
                          sql.execute("update sub_chapters,galleries,user_contents set sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                          sql.commit_db_transaction; 
                          @result =  "subchapter$gallery"
                      when "public":
                          #change the permission of subchapter gallery and content                          
                          sql = ActiveRecord::Base.connection();
                          sql.execute("update sub_chapters,galleries,user_contents set sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                          sql.commit_db_transaction; 
                          @result = "subchapter$gallery"
                      end
                  when "semiprivate":
                      case(access)
                      when "private":
                          #change the permission of content
                          sql = ActiveRecord::Base.connection();
                          sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                          sql.commit_db_transaction;
                      when "semiprivate":
                          #change the permission of subchapter and content
                          sql = ActiveRecord::Base.connection();
                          sql.execute("update sub_chapters,galleries,user_contents set sub_chapters.e_access='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                          sql.commit_db_transaction; 
                          @result = "subchapter"
                      when "public":
                          #change the permission of subchapter gallery and content                          
                           sql = ActiveRecord::Base.connection();
                           sql.execute("update sub_chapters,galleries,user_contents set sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                           sql.commit_db_transaction;                         
                           @result = "subchapter$gallery"
                      end                      
                  when "public":
                      case(access)
                      when "private":
                          #change the permission of content
                          sql = ActiveRecord::Base.connection();
                          sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                          sql.commit_db_transaction;
                      when "semiprivate":
                          #change the permission of subchapter and content
                          sql = ActiveRecord::Base.connection();
                          sql.execute("update sub_chapters,galleries,user_contents set sub_chapters.e_access='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                          sql.commit_db_transaction; 
                          @result = "subchapter"
                      when "public":
                          #change the permission of subchapter and content                          
                          sql = ActiveRecord::Base.connection();
                          sql.execute("update sub_chapters,galleries,user_contents set sub_chapters.e_access='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                          sql.commit_db_transaction; 
                          @result = "subchapter"
                      end                      
                  end
              when "semiprivate":
                  case(gall_access)
                  when "private":
                      case(access)
                      when "private":
                           #change the permission of content
                           sql = ActiveRecord::Base.connection();
                           sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                           sql.commit_db_transaction;
                      when "semiprivate":
                           #change the permission of gallery and content
                           sql = ActiveRecord::Base.connection();
                           sql.execute("update galleries,user_contents set galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                           sql.commit_db_transaction; 
                           @resullt = "gallery"
                      when "public":
                           #change the permission of subchapter gallery and content                          
                           sql = ActiveRecord::Base.connection();
                           sql.execute("update sub_chapters,galleries,user_contents set sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                           sql.commit_db_transaction;                         
                           @result = "subchapter$gallery"
                      end
                  when "semiprivate":
                      case(access)
                      when "private":
                          #change the permission of content
                          sql = ActiveRecord::Base.connection();
                          sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                          sql.commit_db_transaction;
                      when "semiprivate":
                          #change the permission of content
                          sql = ActiveRecord::Base.connection();
                          sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                          sql.commit_db_transaction;
                      when "public":
                          #change the permission of subchapter gallery and content                          
                           sql = ActiveRecord::Base.connection();
                           sql.execute("update sub_chapters,galleries,user_contents set sub_chapters.e_access='#{params[:permission]}',galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                           sql.commit_db_transaction;   
                           @result = "subchapter$gallery"                           
                      end                      
                  when "public":
                      case(access)
                      when "private":
                          #change the permission of content
                          sql = ActiveRecord::Base.connection();
                          sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                          sql.commit_db_transaction;
                      when "semiprivate":
                          #change the permission of content
                          sql = ActiveRecord::Base.connection();
                          sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                          sql.commit_db_transaction;
                      when "public":
                          #change the permission of subchapter and content                          
                          sql = ActiveRecord::Base.connection();
                          sql.execute("update sub_chapters,galleries,user_contents set sub_chapters.e_access='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where sub_chapters.id=galleries.subchapter_id and galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                          sql.commit_db_transaction; 
                          @result = "subchapter"
                      end                      
                  end   
              when "public":
              case(gall_access)
              when "private":
                  case(access)
                  when "private":
                      #change the permission of content
                      sql = ActiveRecord::Base.connection();
                      sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                      sql.commit_db_transaction;
                  when "semiprivate":
                      #change the permission of gallery and content
                      sql = ActiveRecord::Base.connection();
                      sql.execute("update galleries,user_contents set galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                      sql.commit_db_transaction;
                      @result = "gallery"                      
                  when "public":
                      #change the permission of gallery and content                      
                      sql = ActiveRecord::Base.connection();
                      sql.execute("update galleries,user_contents set galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                      sql.commit_db_transaction; 
                      @result = "gallery"
                  end
              when "semiprivate":
                  case(access)
                  when "private":
                      #change the permission of content
                      sql = ActiveRecord::Base.connection();
                      sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                      sql.commit_db_transaction;
                  when "semiprivate":
                      #change the permission of content
                      sql = ActiveRecord::Base.connection();
                      sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                      sql.commit_db_transaction;
                  when "public":
                      #change the permission of gallery and content                      
                      sql = ActiveRecord::Base.connection();
                      sql.execute("update galleries,user_contents set galleries.e_gallery_acess='#{params[:permission]}',user_contents.e_access='#{params[:permission]}'  where galleries.id=user_contents.gallery_id and user_contents.id=#{params[:id]}") ;
                      sql.commit_db_transaction; 
                      @result = "gallery"
                  end                  
              when "public":
                  #change the permission of content
                  sql = ActiveRecord::Base.connection();
                  sql.execute("update user_contents set user_contents.e_access='#{params[:permission]}'  where  user_contents.id=#{params[:id]}") ;
                  sql.commit_db_transaction;
              end            
          end  
      end      

     render :layout => false
	   
   end
   
  def hide
   @user_content = UserContent.find(params[:id])
   @user_content.e_access = "private"
   if(@user_content.save)
    @retval = "success"
  else
    @retval = "failed"
  end
  render :layout => false
 end
 
  def unhide
	  @user_content = UserContent.find(params[:id])
	  @user_content.e_access = "public"
	  if(@user_content.save)
		  @retval = "success"
	  else
		  @retval = "failed"
	  end
	  render :layout => false
  end

  def updateUserContent
	  @content = UserContent.find(params[:id])
	  @content.id = params[:id]
	  @content.v_tagphoto  = params[:name]

	  @content.d_momentdate  = Time.parse(params[:creationDate])
	  @content.v_tagname = params[:tags]
	  @content.v_desc = params[:description]
	  @content.save
	  render(:layout => false)
  end
  

  def delete
    @user_content = UserContent.find(params[:id])
    @user_content.status = "inactive"
    if(@user_content.save)
      @result = "success"
    else
      @result = "failed"
    end
    render(:layout => false)
  end
  
  def cancelUpload
    #@user_content = UserContent.find(params[:id])
    @idstring = params[:idString]
    
    #if(@idstring.search(","))
    if(@idstring)
       @idArray = @idstring.split(',')  
      #end
      for @recordid in @idArray
        @user_content = UserContent.find(@recordid)
        if @user_content != nil
          @user_content.destroy
        end
      end
      end
  end
  
  def remove
   @ids = params[:id]
   @idarray = @ids.split('$')
   for id in @idarray
     @user_content = UserContent.find(id)
     @user_content.status = "inactive"
     @user_content.deleted_date = Time.now
     if(@user_content.save)
      @retval = "success"
     else
      @retval = "failed"
     end
   end
   render :layout => false
  end
 
  def restore
	  @user_content = UserContent.find(params[:id])
	  @user_content.status = "active"
    @user_content.deleted_date = nil
	  if(@user_content.save)
		  @retval = "success"
	  else
		  @retval = "failed"
	  end
	  render :layout => false
  end
  
  def getTimeSpan
	  @user_contents = UserContent.find(:all, :conditions => "uid=#{logged_in_hmm_user.id} and status='active'",:order => "d_momentdate ASC")
	  
	  render :layout => false
  end

 
end
