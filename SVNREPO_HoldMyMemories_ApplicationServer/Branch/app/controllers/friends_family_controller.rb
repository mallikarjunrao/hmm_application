class FriendsFamilyController < ApplicationController
	
	def getFriendsList

		@nonHmmFriends = NonhmmUser.find(:all, :conditions => "uid=#{logged_in_hmm_user.id}")
                @groupsrecord = FnfGroups.find(:all,:conditions => "uid=#{logged_in_hmm_user.id}") 
                
		render :layout => false
  end

  def new_requests
    @hmm_user=HmmUsers.find(session[:hmm_user])
    @fnf_req = FamilyFriend.find_by_sql("SELECT b.*,a.uid as frid , a.id as frnid, a.* FROM family_friends  as a ,hmm_users as b  WHERE (a.fid=#{logged_in_hmm_user.id} and a.uid=b.id and a.status='pending')")
    @fnf_groups_pages, @fnf_groups = paginate :fnf_groupss, :conditions => " uid=#{logged_in_hmm_user.id} ", :per_page => 10
    flash[:notice_fnf] = 'is your friend now!!'
    render :layout => false 
  end
  
  def blocked_friends
      @hmm_user=HmmUsers.find(session[:hmm_user])
      @fnf_blocked = FamilyFriend.find_by_sql("SELECT b.*,a.fid as frid , a.id as frnid, a.* FROM family_friends  as a ,hmm_users as b  WHERE (a.uid=#{logged_in_hmm_user.id} and a.fid=b.id and a.block_status='block')")
      @fnf_blocked_count = FamilyFriend.find_by_sql("SELECT count(*) as cnt FROM family_friends  as a ,hmm_users as b  WHERE (a.uid=#{logged_in_hmm_user.id} and a.fid=b.id and a.block_status='block')")
    
      render :layout => false 
  end
  
  def change_group
    
    
    params[:chk].each {
    |key, value| 
      @fnf_groups2 = FnfGroups.find(:all,:conditions=>"uid=#{logged_in_hmm_user.id}",:order=>"id DESC")
      @friends_family = FamilyFriend.find(value)
      if(params[:fnf_category_other]=='' || params[:fnf_category_other]=='New Category')
         @friends_family['fnf_category']=params[:fnf_category]
      else
         @fnf_group = FnfGroups.new()
         @fnf_group['fnf_category']=params[:fnf_category_other]
         @fnf_group['uid']=logged_in_hmm_user.id
         #@fnf_groups['fnf_category']="#{params[:fnf_groups][:fnf_category]}"
         @fnf_group.save
         @friends_family['fnf_category']=@fnf_group.id
      end  
      
      @friends_family.save
    }
      redirect_to :controller => 'customers' , :action => 'fnf_show' , :id=> @friends_family['fnf_category']
    
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
        @hmm_users_pages, @hmm_users = paginate :hmm_users , :select => "id as fid, v_myimage, v_fname",  :order => sort, :per_page => items_per_page,
        :conditions => conditions12
        
     end
     
     if( params[:query]=="" && params[:query1]=="" && params[:query_hmm_user] =="" )
        @total = HmmUser.count(:joins=>"as b , family_friends as a ", :conditions =>  "a.uid=#{uid} && b.id=a.fid and a.status='accepted' && a.block_status='unblock' " )
        @hmm_users_pages, @hmm_users = paginate :hmm_users ,:joins=>"as b , family_friends  as a ", :order => sort, :per_page => items_per_page,
        :conditions => "a.uid=#{uid} && b.id=a.fid && a.status='accepted' and a.block_status='unblock'"
     else
        flag=1
#        @total = HmmUser.count(:conditions => conditions )
#        @hmm_users_pages, @hmm_users = paginate :hmm_users , :select => "id as fid, v_myimage, v_fname",  :order => sort, :per_page => items_per_page,
#        #:conditions => "a.uid=#{logged_in_hmm_user.id} && b.id=a.fid && b.v_fname LIKE '%#{params[:query]}%'"
#        :conditions => conditions
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
  


end


