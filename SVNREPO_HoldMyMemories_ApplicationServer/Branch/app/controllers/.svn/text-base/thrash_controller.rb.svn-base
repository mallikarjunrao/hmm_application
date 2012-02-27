class ThrashController < ApplicationController
	
        @deletetype
        @deleteid
        
	def getThrashContents
		
		@hmm_user=HmmUsers.find(session[:hmm_user])
		@chapters = Tag.find(:all, :conditions => "uid=#{logged_in_hmm_user.id} and status='inactive'" , :order => "id ASC" )
		@userid="#{logged_in_hmm_user.id}"
		render :layout => false
		
	end
	
	def restoreItem
		if(params[:type] == "webFileVO")
			content = UserContent.find(:all, :conditions =>"id=#{params[:id]}")
			if(content[0] != nil)
				content[0].status = 'active'
				content[0].save()
			end
		elsif(params[:type] == "galleryVO")
			gallery = Galleries.find(:all, :conditions => "id=#{params[:id]}")
			contents = UserContent.find(:all, :conditions => "gallery_id=#{gallery[0].id}")
			for content in contents
				content.status = 'active'
				content.save()
			end
			gallery[0].status = 'active'
			gallery[0].save
		elsif(params[:type] == "subChapterVO")
			subchapter = SubChapter.find(:all, :conditions => "id=#{params[:id]}")
			galleries = Galleries.find(:all, :conditions => "subchapter_id=#{params[:id]}")
			for gallery in galleries
				contents = UserContent.find(:all, :conditions => "gallery_id=#{gallery.id}")
				for content in contents
					content.status = 'active'
					content.save()
				end
				gallery.status = 'active'
				gallery.save	
			end
			subchapter[0].status = 'active'
			subchapter[0].save
		elsif(params[:type] == "chapterVO")
			chapter = Tag.find(:all, :conditions => "id=#{params[:id]}")
			
			subchapters = SubChapter.find(:all, :conditions => "tagid=#{params[:id]}")
			for subchapter in subchapters
				galleries = Galleries.find(:all, :conditions => "subchapter_id=#{subchapter.id}")
				for gallery in galleries
					contents = UserContent.find(:all, :conditions => "gallery_id=#{gallery.id}")
					for content in contents
						content.status = 'active'
						content.save()
					end
					gallery.status = 'active'
					gallery.save	
				end
				subchapter.status = 'active'
				subchapter.save
			end
			chapter[0].status = 'active'
			chapter[0].save()
		end
		
		render :layout => false
	end
        
        
        def deletesubchapter
          
        end
        
        def deletegallery
          if(@deletetype == "subchapter")
            params[:id] = @deleteid
           gallery = Galleries.find(:all, :conditions => "id=#{params[:id]}")
            @deleteid = "";
            @deletetype = "";
          else
            @usercontent = UserContent.find(:all, :conditions =>"id=#{params[:id]}")
          end
          #@usercontent = UserContent.find(:all, :conditions =>"id=#{params[:id]}")
          if(@usercontent != nil)
            @usercontent.destroy
          end
          @result = "File deleted successfully"
          
        end
        
        
		

	
end
