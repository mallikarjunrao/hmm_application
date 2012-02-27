class MessageBoardsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @message_board_pages, @message_boards = paginate :message_boards, :per_page => 10
  end

  def show
    @message_board = MessageBoard.find(params[:id])
  end

  def new
    @message_board = MessageBoard.new
  end

  def create
    @message_board = MessageBoard.new(params[:message_board])
    if @message_board.save
      flash[:notice] = 'MessageBoard was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @message_board = MessageBoard.find(params[:id])
  end

  def update
    @message_board = MessageBoard.find(params[:id])
    if @message_board.update_attributes(params[:message_board])
      flash[:notice] = 'MessageBoard was successfully updated.'
      redirect_to :action => 'show', :id => @message_board
    else
      render :action => 'edit'
    end
  end

  def destroy
    MessageBoard.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def approve_cmt
    @hmm_user=HmmUsers.find(session[:hmm_user])
    @comment =MessageBoard.find(params[:id])
    @comment['status'] = 'accept'
    @comment.save
    $notice_mca_list
      flash[:notice_mca_list] = 'Guest comment was Successfully Approved!!'
     #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
     redirect_to :controller => 'my_familywebsite', :action => 'comments_list'
 end
 
 def destroy_cmt
    MessageBoard.find(params[:id]).destroy
    $notice_mcd_list
      flash[:notice_mcd_list] = 'Guest comment was deleted!!'
     #redirect_to :controller => 'chapter_comment', :action => 'allcmt_list'
     redirect_to :controller => 'my_familywebsite', :action => 'comments_list'
  end
  
end
