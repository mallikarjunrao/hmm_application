module UserLoginSystem
  protected
  
  def is_userlogged_in?
    @logged_in_hmm_user = HmmUser.find(session[:hmm_user]) if session[:hmm_user]
    @hmm_user=@logged_in_hmm_user
  end
  
  def logged_in_hmm_user
    return @logged_in_hmm_user if is_userlogged_in?
  end
  
#  def logged_out_hmm_user
#    return @logged_in_hmm_user if is_userlogged_in?
#  end
  
  def logged_in_hmm_user=(hmm_user)
    if !hmm_user.nil?
      session[:hmm_user] = hmm_user.id
      @logged_in_hmm_user = hmm_user
    end
  end
  
  def self.included(base)
    base.send :helper_method, :is_userlogged_in?, :logged_in_hmm_user
  end

  def login_required1
    unless is_userlogged_in?
      flash[:error] = "You must be logged in to do that."
      redirect_to :controller => 'user_account', :action => 'login'
    end
  end
  
end