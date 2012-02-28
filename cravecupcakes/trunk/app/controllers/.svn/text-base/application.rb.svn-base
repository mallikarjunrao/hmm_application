# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

 # ssl activate for order page
 include SslRequirement
  ssl_required :order
 def ssl_required?
  true
 end
 # SSL END

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_crave_session_id'
   #test
				
    # dropdowns for application.rhtml
  before_filter :meta_tags 

  def meta_tags
   # maybe use this for complicated actions: `path` varchar(255) NOT NULL,(( controller = ? AND action = ? ) OR
		  @seo_stuff = SeoSetting.find( :first, :conditions => [' path = ? ', request.path ] )
				if @seo_stuff
				  @page_title = @seo_stuff.page_title
				  @meta_keywords = @seo_stuff.meta_keywords
				  @meta_description = @seo_stuff.meta_description
				end
  end
  
		protected 
		
		def expire_path( _path )
		  begin
				  pg = File.join( RAILS_ROOT, "/public#{_path}.html" )
				  if File.exists?( pg )
        File.delete( pg )
      end
				rescue
				# do nothing
				end
		end
		
		def expire_directory( _path )
    FileUtils.rm_rf File.join( RAILS_ROOT, "/public#{_path}" )
		end
				
    #                           
    # cache expiration methods
    #                            
 
	 def expire_seo_setting( _path )
    expire_path( _path == '/' ? '/index' : _path )
  end
				
  def expire_dyno_pages
    for page in DynoType.find_by_slug( 'about' ).dyno_pages
      expire_path("/#{page.slug}")
    end
    expire_path('/news')
    expire_directory('/article')
  end
				
  def expire_cupcakes
    expire_fragment( :controller => '/cupcake', :action => 'today' )
    expire_directory( "/cupcake" )
    expire_path( "/cupcake" )
    expire_path( "/menu" )
  end
    
  def expire_faqs
    expire_path( "/answers" )
  end
    
  def expire_all_pages
    expire_faqs
    expire_dyno_pages
    expire_cupcakes
  end
  
end
