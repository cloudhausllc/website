class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      if log_in(user)
        flash.now[:success] = 'Login successful.'
        redirect_to root_path
      else
        flash.now[:warning] = 'User account has not yet been activated.'
        redirect_to login_path
      end
    else
      flash.now[:danger] = 'Invalid username/password combination.'
      render 'new'
    end

  end

  def destroy
    log_out
    redirect_to root_path
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def session_params
    params.require(:session).permit(:email, :password)
  end
end
