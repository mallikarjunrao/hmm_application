class MobileContestsController < ApplicationController
  require 'will_paginate'

  def contest_list
    today=Date.today
    contest_lists=ContestDetail.find(:all,:conditions=>"start_date<'#{today}' and end_date>'#{today}'")
    contest_list=Hash.new
    all_contests = Array.new
    if  contest_lists
      for contests in contest_lists
        contest = Hash.new
        contest ={:id => contests.id,:contest_phase =>contests.contest_phase,:logo=>contests.logo,:photo_logo=>contests.photo_logo,:video_logo=>contests.video_logo}
        all_contests.push(contest)
      end
      contest_list['contests'] =all_contests
      contest_list['status'] = "success"
    else
      contest_list['status'] = "failure"
    end
    render :text => contest_list.to_json
  end

  def contest_entries
    items_per_page = 12
    phase=params[:contest_phase]
    moment_type=params[:moment_type]
    entries=Contest.paginate :per_page => items_per_page, :page => params[:page], :select => "a.*,b.*,c.*,a.id as contest_id" ,:joins=>"as a, user_contents as b,blogs as c",
      :conditions => "a.moment_id=b.id and c.blog_type_id=b.id and c.status='active' and	contest_phase='#{phase}' and moment_type='#{moment_type}'",:group =>"a.id", :order => "a.votes desc"
    contests=Hash.new
    contest_entries= Array.new
    if  entries
      for entry in entries
        contest = Hash.new
        if entry.contest_entry_date.nil?
          enter_date=Time.now.strftime("Submitted : %m/%d/%Y")
        else
          enter_date=entry.contest_entry_date.strftime("%m/%d/%Y")
        end
        if moment_type=='image'
          small_thumb="#{entry.img_url}/user_content/photos/small_thumb/#{entry.v_filename}"
          big_thumb= "#{entry.img_url}/user_content/photos/big_thumb/#{entry.v_filename}"
        elsif moment_type=='video'
          small_thumb="#{entry.img_url}/user_content/videos/thumbnails/#{entry.v_filename}.jpg"
          big_thumb= "#{entry.img_url}/user_content/videos/iphone/#{entry.v_filename}.mp4"
        end
        contest ={:id=>entry.contest_id,:small_thumb => small_thumb,:big_thumb => big_thumb,:votes=>entry.votes,:contestant_name=>entry.first_name,:entry_date=>enter_date,:description=>entry.description}
        contest_entries.push(contest)
      end
      contests['contests'] =contest_entries
      contests['status'] = "success"
      logger.info(contests.inspect)
    else
      contests['status'] = "failure"
    end
    render :text => contest.to_json
  end

  def

  end

  
  
end
