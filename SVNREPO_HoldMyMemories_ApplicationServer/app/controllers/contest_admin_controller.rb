class ContestAdminController < ApplicationController
  layout "admin"
  helper :sort
  include SortHelper
  require 'will_paginate'
  include ApplicationHelper


  before_filter :authenticate_admin, :only => [ :contest_photolist, :contest_videolist,:contest_approve,:reject_email,:moment_view,:contest_reject,:contest_delete,:add_animoto_songs,:delete_animoto_songs,:show_order_zip, :contest_winners, :edit_winners, :show_winner]


  def authenticate_admin
    unless session[:user]
      flash[:notice] = 'Please Login to Access your Account'
      redirect_to :controller=>'account',:action => 'login'
      return false
    end
  end

  def contest_photolist
    sort_init 'id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "id desc"
      else
        sort = "id desc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end

    if params[:username] && params[:username]!=''
      user_ids = HmmUser.find(:all, :select => "id", :conditions => "v_user_name LIKE '%#{params[:username]}%'")
      if !user_ids.empty?
        cond = "and uid IN (#{user_ids.map{|key| key.id}.join(",")})"
      else
        cond = ''
      end
    else
      cond = ''
    end

    if params[:first_name] && params[:first_name]!=''
      cond1 = "and first_name LIKE '%#{params[:first_name]}%'"
    else
      cond1=''
    end

    if params[:studio_name] && params[:studio_name]!=''
      user_ids = HmmUser.find(:all, :select => "a.id", :conditions => "a.studio_id = b.id and b.studio_branch LIKE '%#{params[:studio_name]}%'", :joins => "as a, hmm_studios as b")
      if !user_ids.empty?
        cond2 = "and uid IN (#{user_ids.map{|key| key.id}.join(",")})"
      else
        cond2 = ''
      end
    else
      cond2 = ''
    end

    if params[:email] && params[:email]!=''
      user_ids = HmmUser.find(:all, :select => "id", :conditions => "v_e_mail LIKE '%#{params[:email]}%'")
      if !user_ids.empty?
        cond3 = "and uid IN (#{user_ids.map{|key| key.id}.join(",")})"
      else
        cond3 = ''
      end
    else
      cond3 = ''
    end

    @pg_limit = 1
    if params[:id]!='' and params[:id]
      session[:current_contest_id]=params[:id]
    end
    @contest_details=ContestDetail.find(:first,:conditions=>"id=#{session[:current_contest_id]}")
    if cond == '' && cond1 == '' && cond2 == '' && cond3 == ''
      @contests = Contest.paginate :per_page => 60, :page => params[:page], :joins=>"as a, hmm_users as b", :select => "a.*, b.v_fname, b.studio_id, b.v_password, b.v_lname, b.v_user_name, b.v_e_mail", :conditions => "moment_type='image' and b.id = a.uid and contest_phase='#{@contest_details.contest_phase}'", :order => sort
    else
      @contests = Contest.paginate :per_page => 60, :page => params[:page], :joins=>"as a, hmm_users as b", :select => "a.*, b.v_fname, b.studio_id, b.v_password, b.v_lname, b.v_user_name, b.v_e_mail", :conditions => "moment_type='image' and b.id = a.uid and contest_phase='#{@contest_details.contest_phase}' #{cond} #{cond1} #{cond2} #{cond3}", :order => sort
    end
  end

  def contest_videolist
    sort_init 'id'
    sort_update
    if( params[:sort_key] ==nil )
      if(session[:sort_order]==nil)
        sort = "id desc"
      else
        sort = "id desc"
      end
    else
      session[:sort_order]=params[:sort_order]
      session[:srk]=params[:sort_key]
      sort = "#{session[:srk]}  #{params[:sort_order]}"
    end

    if params[:username] && params[:username]!=''
      user_ids = HmmUser.find(:all, :select => "id", :conditions => "v_user_name LIKE '%#{params[:username]}%'")
      if !user_ids.empty?
        cond = "and uid IN (#{user_ids.map{|key| key.id}.join(",")})"
      else
        cond = ''
      end
    else
      cond = ''
    end

    if params[:first_name] && params[:first_name]!=''
      cond1 = "and first_name LIKE '%#{params[:first_name]}%'"
    else
      cond1=''
    end

    if params[:studio_name] && params[:studio_name]!=''
      user_ids = HmmUser.find(:all, :select => "a.id", :conditions => "a.studio_id = b.id and b.studio_branch LIKE '%#{params[:studio_name]}%'", :joins => "as a, hmm_studios as b")
      if !user_ids.empty?
        cond2 = "and uid IN (#{user_ids.map{|key| key.id}.join(",")})"
      else
        cond2 = ''
      end
    else
      cond2 = ''
    end

    if params[:email] && params[:email]!=''
      user_ids = HmmUser.find(:all, :select => "id", :conditions => "v_e_mail LIKE '%#{params[:email]}%'")
      if !user_ids.empty?
        cond3 = "and uid IN (#{user_ids.map{|key| key.id}.join(",")})"
      else
        cond3 = ''
      end
    else
      cond3 = ''
    end

    @pg_limit = 1
    if params[:id]!= '' and params[:id]
      session[:current_contest_id]=params[:id]
    end
    @contest_details=ContestDetail.find(:first,:conditions=>"id=#{session[:current_contest_id]}")
    if cond == '' && cond1 == '' && cond2 == '' && cond3 == ''
      @contests = Contest.paginate :per_page => 60, :page => params[:page], :joins=>"as a, hmm_users as b", :select => "a.*, b.v_fname, b.studio_id, b.v_password, b.v_lname, b.v_user_name, b.v_e_mail", :conditions => "moment_type='video' and b.id = a.uid and contest_phase='#{@contest_details.contest_phase}'", :order => sort
    else
      @contests = Contest.paginate :per_page => 60, :page => params[:page], :joins=>"as a, hmm_users as b", :select => "a.*, b.v_fname, b.studio_id, b.v_password, b.v_lname, b.v_user_name, b.v_e_mail", :conditions => "moment_type='video' and b.id = a.uid and contest_phase='#{@contest_details.contest_phase}' #{cond} #{cond1} #{cond2} #{cond3}", :order => sort
    end
  end



  def contest_approve
    @contest = Contest.find(params[:id])
    sql = ActiveRecord::Base.connection();
    paths=ContentPath.find(:first,:conditions=>"status='active'")
    @contest_details=ContestDetail.find(:first,:conditions=>"contest_phase='#{params[:phase]}'")
    sql.update "UPDATE contests SET status='active' WHERE id=#{params[:id]}";
    @contest_select = Contest.find(:all, :conditions => "id='#{params[:id]}'")
    for i in @contest_select
      userid = i.uid
      kidsname = i.first_name
      momentid = i.moment_id
      moment_type = i.moment_type
    end
    @content_url = UserContent.find(:all, :conditions => "id='#{momentid}'")
    @hmm_userdetails = HmmUser.find(:all, :conditions => "id='#{userid}'")
    for j in @hmm_userdetails
      fname = j.v_fname
      email = j.v_e_mail
    end
    Postoffice.deliver_contest_approve_email(fname,email,kidsname,momentid,moment_type,@content_url[0]['img_url'],@content_url[0]['v_filename'],paths.proxyname,params[:id],@contest_details.name,@contest_details.id)
    # @hmm_user.save
    $contest_approve
    flash[:contest_approve] = 'contest entry has been approved'

    if params[:type]=="image"
      redirect_to :action => 'contest_photolist' ,:id=> @contest_details.id
    else
      redirect_to :action => 'contest_videolist' ,:id=> @contest_details.id
    end
  end


  def reject_email
    @contest = Contest.find(:all, :conditions => "id='#{params[:id]}'")
    for i in @contest
      @content_url = UserContent.find(:all, :conditions => "id='#{i.moment_id}'")
    end
  end


  def moment_view
    #@moment_details = UserContent.find(:all, :conditions => "id='#{params[:id]}'")
    @phase=params[:phase]
    @contests_fname = Contest.find(:all, :conditions => "moment_id='#{params[:id]}' and contest_phase='#{params[:phase]}'")
    @contests = Contest.paginate :per_page => 1, :select =>"a.*,b.*, a.id as contestid, a.status as contest_status" , :page => params[:page],:joins=>" as a , user_contents as b ", :conditions => "a.moment_id=b.id and a.moment_type='image' and a.contest_phase='#{params[:phase]}'", :order => 'a.id desc'

    # @journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{@contests[0].moment_id} ")
    @journal = Blog.find(:all, :conditions => "blog_type_id = #{@contests[0].moment_id} and user_id=#{@contests[0].uid}")

  end

  def contest_reject
    @contest = Contest.find(params[:id])
    sql = ActiveRecord::Base.connection();

    sql.update "UPDATE contests SET status='inactive' WHERE id=#{params[:id]}";
    # @hmm_user.save

    @contest_select = Contest.find(:all, :conditions => "id='#{params[:id]}'")
    for i in @contest_select
      userid = i.uid
      kidsname = i.first_name
      momentid = i.moment_id
      moment_type = i.moment_type

    end
    @content_url = UserContent.find(:all, :conditions => "id='#{momentid}'")
    @contest_details=ContestDetail.find(:first,:conditions=>"contest_phase='#{params[:phase]}'")
    @hmm_userdetails = HmmUser.find(:all, :conditions => "id='#{userid}'")
    for j in @hmm_userdetails
      fname = j.v_fname
      email = j.v_e_mail
    end
    Postoffice.deliver_contest_reject_email(fname,email,kidsname,momentid,moment_type,params[:message],@content_url[0]['img_url'],@content_url[0]['v_filename'],@contest_details.name,@contest_details.id)
    $contest_rej
    flash[:contest_rej] = 'contest entry has been rejected!'
    if params[:type]=="image"
      redirect_to :action => 'contest_photolist' ,:id=> @contest_details.id
    else
      redirect_to :action => 'contest_videolist' ,:id=> @contest_details.id
    end
  end

  def contest_delete
    @contest = Contest.find(params[:id])
    @contest_details=ContestDetail.find(:first,:conditions=>"contest_phase='#{params[:phase]}'")
    sql = ActiveRecord::Base.connection();
    sql.update "DELETE from contests  WHERE id=#{params[:id]}";
    # @hmm_user.save
    $contest_rej
    flash[:contest_rej] = 'contest entry has been removed!'
    if params[:type]=="image"
      redirect_to :action => 'contest_photolist' ,:id=> @contest_details.id
    else
      redirect_to :action => 'contest_videolist' ,:id=> @contest_details.id
    end
  end


  def video_moment_view
    @contests = Contest.paginate :per_page => 1, :select =>"a.*,b.*, a.id as contestid, a.status as contest_status" , :page => params[:page],:joins=>" as a , user_contents as b ", :conditions => "a.moment_id=b.id and a.moment_type='video' and a.contest_phase='#{params[:phase]}'", :order => 'a.id desc'

    #@journal = JournalsPhoto.find(:all, :conditions => "user_content_id = #{@contests[0].moment_id} ")
    @journal = Blog.find(:all, :conditions => "blog_type_id = #{@contests[0].moment_id} and user_id=#{@contests[0].uid}")
  end

  def add_animoto_songs
    @songs=AnimotoSong.find(:all,:conditions=>"status='active'")
  end

  def delete_animoto_songs
    songs=AnimotoSong.find(:first,:conditions=>"id=#{params[:id]}")
    songs.status="inactive"
    songs.save
    redirect_to :action => 'add_animoto_songs'
  end

  def show_order_zip
    @galleries=GalleryZip.paginate :per_page => 30,:page => params[:page],:order=>"id desc"
  end

  def winner_names
    #render :text => params.inspect
    @username=[params[:username0],params[:username1],params[:username2],params[:username3]]
    @username0=params[:username0]
    @count=params[:no_of_winners]
    @cotest_type=params[:contest_type]
    # @user_details={}
    logger.info("@*************************************************")
    logger.info(@username)
    logger.info(@cotest_type)
    detail=[]
    for i in 0..@count.to_i-1
      detail = ContestDetail.find(:all,:joins=>"as a,contests as b",:conditions=>"a.name='#{params[:contest_phase]}' and b.moment_type='#{params[:contest_type]}' and b.first_name='#{@username0}' and b.contest_title='#{params[:contest_phase]}'",:select=>"a.*")
      logger.info("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
      logger.info(detail)
      if detail
        value = []
        value1=[]
        detail.each do |f|
          logger.info(f.photo_logo)


          value << f.photo_logo
          @user_photo_logo= value
          value1 << f.video_logo
          @user_video_logo=value1

          puts "-----------------------------------data found #{f.inspect} "
        end

      else
        puts "----------------------no data found-----------------------"
      end

      logger.info("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$##########}")
      #     @user_details.each do |f|
      #    logger.info(f.photo_logo)
      #     end

    end
    @detail = ContestDetail.find(:all,:joins=>"as a,contests as b",:conditions=>"a.name='#{params[:contest_phase]}' and b.moment_type='#{params[:contest_type]}' and b.first_name='#{@username0}' and b.contest_title='#{params[:contest_phase]}'",:select=>"a.*")
    session[:details] = @detail
    redirect_to :action=> 'contest_winners',:params => @detail, :username0=>params[:username0],:contest_type=>params[:contest_type],:user_photo_logo=>@user_photo_logo,:user_video_logo=>@user_video_logo,:no_of_winners=>params[:no_of_winners]
  end



  def contest_winners
    @username=[params[:username0],params[:username1],params[:username2],params[:username3]]
   # render :text => params.inspect
   @count=params[:count]

    logger.info("11111111111111111111111111111111111111111111111")
     logger.info(@count)
   
    @details = Contest.find(:all, :select=>"a.*, b.*", :joins=>"as a,hmm_users as b",:conditions=>"a.uid=b.id and a.moment_type='#{params[:contest_type]}' and b.v_user_name IN ('#{params[:username0]}', '#{params[:username1]}','#{params[:username2]}','#{params[:username3]}') and a.contest_phase = 'phase#{params[:contest_phase]}'")
    if  @count==0
      @c_d=1;
      logger.info(@c_d)
    end
      logger.info(@details.count)
     logger.info("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@22@c")
    #render :text => @details.inspect
    logger.info(@details)
    
@details.each do |f|
  logger.info("---------------------------data verfying----------------------------")
  logger.info(f.v_user_name)
end
    @no_of_winners=params[:no_of_winners]
    @contest_phase=params[:contest_phase]
    @contest_type=params[:contest_type]
    @username0=params[:username0]
 
    logger.info("2222222222222222222222222222222222222222222222222222222222222222222222222222222222222222")
    logger.info(@contest_phase)
 
    logger.info(@contest_type)
    logger.info(@no_of_winners)
    logger.info(@details.count)

    @winners = ContestWinner.find(:all, :order => "contest_phase desc")
    @contest_name = ContestDetail.find(:all, :select => "id, name", :order => "id desc")
  end

  def add_winners
    
    logger.info("1111111111111111111111111111111111111111111")
    logger.info(params[:type])
    if !params[:Submit].nil? && params[:Submit] != ""
      if request.post?

        if (@winner = ContestWinner.find_by_contest_phase(params[:contest_phase]))
        
          if params[:type] =='image'
         winners_count = params[:photo_winner_name].length
          logger.info("Winner length: #{winners_count}")

          for i in 0..winners_count - 1
            @winner.contest_phase = params[:contest_phase]
            if params[:photo_winner_name]["#{i}"][:name] != "" and  params[:photo_winner_name]["#{i}"][:name] != "hidden"
              if @winner.photo_winner_name.blank?
                @winner.photo_winner_name = [{"url" => params[:photo_winner_name]["#{i}"][:url], "name" => params[:photo_winner_name]["#{i}"][:name], "link" => params[:photo_winner_name]["#{i}"][:link]}]
                logger.info(@winner.photo_winner_name)
              else
                @winner.photo_winner_name << {"url" => params[:photo_winner_name]["#{i}"][:url], "name" => params[:photo_winner_name]["#{i}"][:name], "link" => params[:photo_winner_name]["#{i}"][:link]}
              end
            else
              @winner.photo_winner_name << ""
            end
          end
          end

          if params[:type]=='video'
           winners_count = params[:video_winner_name].length
          logger.info("Video Winner length: #{winners_count}")
           for i in 0..winners_count - 1
             @winner.contest_phase = params[:contest_phase]

          
          if params[:video_winner_name]["#{i}"][:name] != "" and  params[:video_winner_name]["#{i}"][:name] != "hidden"
            if @winner.video_winner_name.blank?
              @winner.video_winner_name = [{"url" => params[:video_winner_name]["#{i}"][:url], "name" => params[:video_winner_name]["#{i}"][:name], "link" => params[:video_winner_name]["#{i}"][:link]}]
            else
              @winner.video_winner_name << {"url" => params[:video_winner_name]["#{i}"][:url], "name" => params[:video_winner_name]["#{i}"][:name], "link" => params[:video_winner_name]["#{i}"][:link]}
            end
          else
            @winner.video_winner_name << ""
          end
          end
        end



          @winner.photo_winner_name = @winner.photo_winner_name.reject(&:blank?)
          @winner.video_winner_name = @winner.video_winner_name.reject(&:blank?)
          if @winner.save
            flash[:msg1] = "Winner entry added successfully!"
          else
            flash[:msg2] = "Winner entry failed!"
            redirect_to :controller=>'contest_admin',:action => 'contest_winners'
          end
        else
          @winner = ContestWinner.new
          @winner.contest_phase = params[:contest_phase]
          if params[:photo_winner_name][:name] != ""
            @winner.photo_winner_name = [{"url" => params[:photo_winner_name][:url], "name" => params[:photo_winner_name][:name], "link" => params[:photo_winner_name][:link]}]
          else
            @winner.photo_winner_name = ""
          end
          if params[:video_winner_name][:name] != ""
            @winner.video_winner_name = [{"url" => params[:video_winner_name][:url], "name" => params[:video_winner_name][:name], "link" => params[:video_winner_name][:link]}]
          else
            @winner.video_winner_name = ""
          end
          if @winner.save
            flash[:msg1] = "Winner entry added successfully!"
          else
            flash[:msg2] = "Winner entry failed!"
            redirect_to :controller=>'contest_admin',:action => 'contest_winners'
          end
        end
      end
    end
    redirect_to :controller=>'contest_admin',:action => 'contest_winners'
  end

  def delete_winners
    @winner = ContestWinner.find_by_contest_phase(params[:contest_phase])
    if params[:single]
      if params[:winner_type] && params[:winner_index]
        if params[:winner_type] == "photo"
          @winner.photo_winner_name.delete_at(params[:winner_index].to_i)
        elsif params[:winner_type] == "video"
          @winner.video_winner_name.delete_at(params[:winner_index].to_i)
        end
      end
      @winner.photo_winner_name = @winner.photo_winner_name.reject(&:blank?)
      @winner.video_winner_name = @winner.video_winner_name.reject(&:blank?)
      if @winner.save
        flash[:msg1] = "Successfully removed winner from the list"
        redirect_to :action => "contest_winners"
      else
        flash[:msg2] = "Deleting contest winner failed!"
        redirect_to :action => "contest_winners"
      end
    elsif params[:contest]
      @winner.destroy
      flash[:msg1] = "Successfully deleted winners from contest"
      redirect_to :action => "contest_winners"
    end
  end

  def edit_winners
    @contest_name = ContestDetail.find(params[:contest_phase])
    @winner = ContestWinner.find_by_contest_phase(params[:contest_phase])
  end

  def update_winners
    @winner = ContestWinner.first(:conditions => "contest_phase = #{params[:contest_phase]}")
    if @winner
      if (@winner.photo_winner_name.length > 0) && (params[:photo_winner_name].length > 0 )
        i = 0
        for photo_winner in @winner.photo_winner_name
          photo_winner["name"] = params[:photo_winner_name]["#{i}"][:name]
          photo_winner["link"] = params[:photo_winner_name]["#{i}"][:link]
          photo_winner["url"] = params[:photo_winner_name]["#{i}"][:url]
          i+=1
        end
      end
      if (@winner.video_winner_name.length > 0) && (params[:video_winner_name].length > 0)
        i = 0
        for video_winner in @winner.video_winner_name
          video_winner["name"] = params[:video_winner_name]["#{i}"][:name]
          video_winner["link"] = params[:video_winner_name]["#{i}"][:link]
          video_winner["url"] = params[:video_winner_name]["#{i}"][:url]
          i+=1
        end
      end
      @winner.photo_winner_name = @winner.photo_winner_name.reject(&:blank?)
      @winner.video_winner_name = @winner.video_winner_name.reject(&:blank?)
      @winner.save
      flash[:msg1] = "Successfully updated contest winners"
      redirect_to :action => "contest_winners"
    else
      flash[:msg1] = "Contest not found!"
      redirect_to :action => "edit_winners"
    end
  end


  def show_winner
    @contest_name = ContestDetail.find(params[:contest_phase])
    @winner = ContestWinner.find_by_contest_phase(params[:contest_phase])

  end

end