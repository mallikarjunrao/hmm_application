require 'builder'

class MyvideosController < ApplicationController
layout "standard"
#before_filter :only => [:index, :destroy, :enable_toggle]
#before_filter :login_required || :login_required1, :only => [:new, :list, :create, :index, :search, :edit, :deleteSelection, :deleteSelection1, :update]
 before_filter :authenticate
 
  def authenticate
      unless session[:hmm_user]
           flash[:notice] = 'Please Login to Access your Account'
           redirect_to :controller => "user_account" , :action => 'login'
      return false
      else
        if (session[:flag] == 1 && request.request_uri != "/customers/upgrade/platinum_account")
          flash[:error] = "Your credit card payment to your HoldMyMemories.com has been declined by your credit card company. This could be for a number of reasons, including an expired card. <br><br><br>Please re-enter your credit card information, or use a different card for the renewal of your account."
          redirect_to "https://www.holdmymemories.com/customers/upgrade/platinum_account"
        end 
      end
    end
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @user_content_pages, @user_contents = paginate :user_contents,:conditions => "e_filetype='video'", :per_page => 10
  end

  def show
    @user_content = UserContent.find(params[:id])
  end

  def new
    @user_content = UserContent.new
  end

  def create
    @filename = params[:user_content][:v_filename].original_filename
    @user_content = UserContent.new(params[:user_content])
  post = UserContent.save2(params['user_content'])
     @user_content['v_filename']=@filename
    if @user_content.save
      flash[:notice] = 'UserContent was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @user_content = UserContent.find(params[:id])
  end

  def update
    @user_content = UserContent.find(params[:id])
    if @user_content.update_attributes(params[:user_content])
      flash[:notice] = 'UserContent was successfully updated.'
      redirect_to :action => 'show', :id => @user_content
    else
      render :action => 'edit'
    end
  end

  def destroy
	  UserContent.find(params[:id]).destroy
	  redirect_to :action => 'list'
  end
  
  def videoCoverflow
      @gallery_belongs_to=Galleries.find_by_sql("select a.*,b.* from galleries as a, sub_chapters as b, hmm_users as c where a.id=#{params[:id]} and a.subchapter_id=b.id and b.uid=c.id")
    @gallery_belongs_to[0]['uid']
    if(@gallery_belongs_to[0]['uid']!="#{logged_in_hmm_user.id}")
      session[:friend]=@gallery_belongs_to[0]['uid']
      @total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid and a.fid=#{session[:friend]} and a.status='accepted'",:order =>'a.id desc')
      if(@total>0)
        session[:semiprivate]="activate"
      else
        session[:semiprivate]=""
      end  
    end
    
    
    if(session[:friend]!='')
      e_access="and e_access='public'"
      if(session[:semiprivate]=="activate")
        e_access=" and (e_access='public' or e_access='semiprivate')"
      end
    end
    
	  @contents = UserContent.find(:all, :conditions => "gallery_id=#{params[:id]} #{e_access} and status='active'", :order => 'id desc')
	  render :layout => false
  end
  
  def getVideoData
	  hmm_user=HmmUsers.find(session[:hmm_user])
	  @contents = UserContent.find(:all, :conditions => "uid=#{hmm_user.id} and e_filetype='image'", :order => 'id desc')
	  render :layout => false
  end
  
  def createSlideShow
	  
	  render :layout => true
  end
	  
  
  
  
  def resize(img, destinationH, destinationW,path)
	  # maxU = destinationH/img.rows
	  # maxV = destinationW/img.columns
	  
	  finalImage =  Image.new(destinationW,destinationH) { self.background_color = "black" }
	  if(img.rows > img.columns)
		  w = destinationH*img.columns/img.rows
		  puts w
		  h = destinationH
		  x = (destinationW - w)/2
		  y = 0
		  img.scale!(w, h)
		  finalImage = finalImage.composite(img,x,y,CopyCompositeOp) 
	  else
		  puts "width: "+"#{img.rows}"
		  puts "height : "+"#{img.columns}"
		  w = destinationW
		  h = destinationW*img.rows/img.columns
		  
		  puts h
		  puts w
		  y = (destinationH - h)/2
		  x = 0
		  puts x
		  puts y
		  img.scale!(w, h)
		  
		  finalImage = finalImage.composite(img,x,y,CopyCompositeOp) 
		  
	  end
	  finalImage.write(path)
	end
  
  def playvideo
    
  end
  
  def template1
    render :layout => true
  end
  
  def flipbook
    
  end
  
end
