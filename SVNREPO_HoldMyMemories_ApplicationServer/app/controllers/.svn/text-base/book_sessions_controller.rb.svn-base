class BookSessionsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @book_sessions = BookSessions.paginate( :book_sessions, :per_page => 10, :page => params[:page])
  end

  def show
    @book_session = BookSession.find(params[:id])
  end

  def new
    @book_session = BookSession.new
  end

  def create_booksession
    @book_session = BookSession.new()
    @book_session['website_name']=params[:id]
    @book_session['click_date']=Time.now
    if @book_session.save
      flash[:notice] = 'BookSession was successfully created.'
      redirect_to 'http://s121.com/bookonline.asp'
    else
      render :action => 'new'
    end
  end

  def edit
    @book_session = BookSession.find(params[:id])
  end

  def update
    @book_session = BookSession.find(params[:id])
    if @book_session.update_attributes(params[:book_session])
      flash[:notice] = 'BookSession was successfully updated.'
      redirect_to :action => 'show', :id => @book_session
    else
      render :action => 'edit'
    end
  end

  def destroy
    BookSession.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
