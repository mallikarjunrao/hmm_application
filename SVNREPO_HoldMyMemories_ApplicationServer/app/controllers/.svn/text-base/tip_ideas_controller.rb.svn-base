class TipIdeasController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @tip_idea_pages, @tip_ideas = paginate :tip_ideas, :per_page => 10
  end

  def show
    @tip_idea = TipIdea.find(params[:id])
  end

  def new
    @tip_idea = TipIdea.new
    render :layout => false
  end

  def create
    @tip_idea = TipIdea.new(params[:tip_idea])
    @tip_idea['uid'] = logged_in_hmm_user.id
    if @tip_idea.save
      Postoffice.deliver_tipsideas(@tip_idea.tip_title,@tip_idea.tip_desc,logged_in_hmm_user.v_user_name,logged_in_hmm_user.v_e_mail,logged_in_hmm_user.v_myimage)  
      $notice_tip
      flash[:notice_tip] = 'Tips was successfully sent.'
      redirect_to :controller => 'invite_friends', :action => 'tips_view'
    else
      render :action => 'new'
    end
  end

  def edit
    @tip_idea = TipIdea.find(params[:id])
  end

  def update
    @tip_idea = TipIdea.find(params[:id])
    if @tip_idea.update_attributes(params[:tip_idea])
      flash[:notice] = 'TipIdea was successfully updated.'
      redirect_to :action => 'show', :id => @tip_idea
    else
      render :action => 'edit'
    end
  end

  def destroy
    TipIdea.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
