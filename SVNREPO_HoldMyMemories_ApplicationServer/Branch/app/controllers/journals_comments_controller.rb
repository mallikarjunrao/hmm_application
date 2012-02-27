class JournalsCommentsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @journals_comment_pages, @journals_comments = paginate :journals_comments, :per_page => 10
  end

  def show
    @journals_comment = JournalsComment.find(params[:id])
  end

  def new
    @journals_comment = JournalsComment.new
  end

  def create
    @journals_comment = JournalsComment.new(params[:journals_comment])
    if @journals_comment.save
      flash[:notice] = 'JournalsComment was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @journals_comment = JournalsComment.find(params[:id])
  end

  def update
    @journals_comment = JournalsComment.find(params[:id])
    if @journals_comment.update_attributes(params[:journals_comment])
      flash[:notice] = 'JournalsComment was successfully updated.'
      redirect_to :action => 'show', :id => @journals_comment
    else
      render :action => 'edit'
    end
  end

  def destroy
    JournalsComment.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
