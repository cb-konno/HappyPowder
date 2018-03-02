class SessionsController < ApplicationController
  def new
  end

  def create
    mail = params[:sessions][:mail]
    password = params[:sessions][:password]

    user = User.find_by(mail: mail)
    if user && user.authenticate(password)
      login user
      remember user
      redirect_to user
    else
      flash[:failed] = t('login.failed')
      render 'new'
    end
  end

  def destroy
    logout if logged_in?
    redirect_to login_path
  end
end
