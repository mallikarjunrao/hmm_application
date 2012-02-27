class CurrentContestsController < ApplicationController
  #layout "application", :except => [:family_contest,:family_momentdetails]
  #layout "familywebsite"
  layout :apply_layout
  
    def check_account
    unless params[:id].blank?
      @family_website_owner = HmmUser.find(:first,:joins =>"INNER JOIN themes on hmm_users.theme_id=themes.id", :conditions => "(family_name='#{params[:id]}' || alt_family_name='#{params[:id]}')",:select => "hmm_users.*,themes.stylesheet as theme") #get the user details
      if @family_website_owner
        if(session[:employe]==nil && @family_website_owner.terms_checked == 'false' ) #if the logged in user is not employee and terms is not agreed
          flash[:terms] = 'terms'
          if(session[:hmm_user]) #f the user is logged in, takes to agree terms page
            redirect_to "/user_account/update_terms/"
          else #if the user is not logged in, takes to login page
            redirect_to "/familywebsite/login/#{params[:id]}" if params[:action]!='login'
          end
        elsif @family_website_owner.e_user_status=='blocked' #displays message, if the user is blocked
          render :text => "This Familywebsite has been Blocked. Please contact Website Administrator at <a href='mailto:admin@holdmymemories.com' >admin@HoldMyMemories.com</a>"
        elsif session[:visitor]==nil && session[:hmm_user]==nil && @family_website_owner.password_required == 'yes'
          #render :text =>"Password protected. Redirect to family website login page"
          if(params[:facebook]=='true')
            session[:visitor]=@family_website_owner.family_name
          else
            redirect_to :controller =>"familywebsite", :action => 'visitor_login', :id => params[:id], :redirect_url => request.url if (params[:action]!='login' && params[:action]!='visitor_login')
          end
        else
          @path = ContentPath.find(:first, :conditions => "status='active'")
          if(params[:id]=='bob')
            @content_server_url = "http://content.holdmymemories.com"
          else
            @content_server_url = @path.content_path
          end

          return true #returns true if all the conditions are cleared
        end
      else
        redirect_to '/'
      end
    end
  end
  

  def evaluate_terms
    if params[:agree] == 'agree'
      redirect_to :action => 'contest_login', :id => params[:id]
    else if params[:agree_down] == 'agree'
        redirect_to :action => 'contest_login', :id => params[:id]
      else
        redirect_to '/'
      end
    end
  end

   def family_contest
     check_account
     contest_code
  end

  def contest
    contest_code
  end
  def contest_code
    @contest = ContestDetail.find_by_name(params[:name])
    session[:contest]=@contest.id
  end

  def enter_contest
    @contest = ContestDetail.find(session[:contest])
    @logo_image = ContestLogoDetail.find_by_contest_details_id_and_contest_type(@contest.id,'image', :order => "created_at DESC")
    @logo_video = ContestLogoDetail.find_by_contest_details_id_and_contest_type(@contest.id,'video', :order => "created_at DESC")
    render :layout =>false
  end

  def family_terms_and_conditions
    check_account
    @contest = ContestDetail.find(session[:contest])
    @logo_image = ContestLogoDetail.find_by_contest_details_id_and_contest_type(@contest.id,'image', :order => "created_at DESC")
    @logo_video = ContestLogoDetail.find_by_contest_details_id_and_contest_type(@contest.id,'video', :order => "created_at DESC")
        @current_item = 'contest'
    if params[:contest] == "video"
      @type = params[:contest]
      session[:contests_type] = "video"
    else params[:contest] == "photo"
      @type = params[:contest]
      session[:contests_type] = "image"
    end
  end

  def terms_and_conditions
    @contest = ContestDetail.find(session[:contest])
    @logo_image = ContestLogoDetail.find_by_contest_details_id_and_contest_type(@contest.id,'image', :order => "created_at DESC")
    @logo_video = ContestLogoDetail.find_by_contest_details_id_and_contest_type(@contest.id,'video', :order => "created_at DESC")
  end
  
  def family_momentdetails
    check_account
    @current_page = 'contest'
    @contest = ContestDetail.find(session[:contest])
    @logo_image = ContestLogoDetail.find_by_contest_details_id_and_contest_type(@contest.id,'image', :order => "created_at DESC")
    @moment_details = UserContent.find(:all, :conditions => "id='#{params[:contest_id]}'")
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:contest_id]}'")
    #@journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{params[:id]} ")
    @journal = Blog.find(:all, :conditions => "blog_type_id = #{params[:contest_id]} and user_id=#{@moment_details[0].uid}")
  end

  def momentdetails
    momentdetails_code
  end
  
  def momentdetails_code
    @contest = ContestDetail.find(session[:contest])
    @logo_image = ContestLogoDetail.find_by_contest_details_id_and_contest_type(@contest.id,'image', :order => "created_at DESC")
    @moment_details = UserContent.find(:all, :conditions => "id='#{params[:id]}'")
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:id]}'")
    @journal = Blog.find(:all, :conditions => "blog_type_id = #{params[:id]} and user_id=#{@moment_details[0].uid}")
    @contest_image="#{@moment_details[0].img_url}/user_content/photos/journal_thumb/#{@moment_details[0].v_filename}"
    #entrants_name=@contests_fname[0].first_name
    #@contest_description =  "Hello Friends!\n\nI have entered in HoldMyMemories.com Home for The Holidays 2010 Photo and Video Contest. Please help #{entrants_name} to win by clicking on the above link and casting your vote!"
    #@contest_title="Home for The Holidays 2010 Photo and Video Contest.Brought to you by HoldMyMemories.com."



    if(params[:page]==nil || params[:page]=='' || params[:hmm] ==nil)
      @counts =  Contest.count(:all, :conditions => " moment_type='image' and status='active' and contest_phase='#{@contest.parse_id}' ",:order =>'contest_entry_date  desc')
      @allrecords =  Contest.find(:all, :conditions => " moment_type='image' and status='active' and contest_phase='#{@contest.parse_id}'" ,:order =>'contest_entry_date  desc')
      page=0


      for check in @allrecords
        page=page+1
        if("#{check.moment_id}" == "#{params[:id]}" )
          @nextpage=page
          redirect_to :action => :momentdetails, :id=> params[:id], :page =>@nextpage,:hmm=>"true"
          #redirect_to :action => :momentdetails, :id=> params[:id], :page =>@nextpage
        else
          puts "#{check.moment_id} == #{params[:id]}"
          puts "\n"
        end
      end
    else
      @contest_cutekid = Contest.paginate :per_page => 1, :page => params[:page], :conditions => " moment_type='image' and status='active' and contest_phase='phase'" ,:order =>'contest_entry_date  desc'
    end
  end



  
private
def apply_layout
  normal = ['contest','momentdetails','terms_and_conditions']
  if normal.include?(params[:action])
      return "application"
  else
     return "familywebsite"
  end
end
end
