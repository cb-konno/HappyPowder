class SessionsController < ApplicationController
  def new
  end

  def create
    mail = params[:sessions][:mail]
    password = params[:sessions][:password]

    user = User.find_by(mail: mail)
    if user && user.authenticate(password)
      login user
      flash[:success] = 'Welcome ' + user.name
      redirect_to user
    else
      flash[:failed] = 'メールアドレスとパスワードを確認してください。'
      render 'new'
    end
  end

  def destroy
    logout
    redirect_to login_path
  end
end
