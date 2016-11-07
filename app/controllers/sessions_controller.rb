class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      begin
        if log_in(user)
          flash[:success] = 'Login successful.'
          redirect_to root_path
        else
          flash[:warning] = 'User account has not yet been activated. Please contact info@cloudhaus.org for further assistance.'
          redirect_to login_path
        end
      rescue => e
        flash[:danger] = 'There was a problem logging into your account. Please contact info@cloudhaus.org for further assistance.'
        render 'new'
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
