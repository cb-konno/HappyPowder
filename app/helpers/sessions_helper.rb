module SessionsHelper
  #指定したユーザーでログインする
  def login(user)
    session[:user_id] = user.id
  end

  #ログアウトする
  def logout
    session[:user_id] = nil
    @current_user = nil
  end

  #ログイン中判定メソッド
  def logged_in
    !current_user.nil?
  end


  #現在ログイン中のユーザーを取得する
  #
  #   セッションにuser_idが存在したら、
  #   cookieにuser_idが存在したら
  #
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenicated?(cookies[:remember_token])
        login user
        @current_user = user
      end
    end
  end

  #cookiesにセッション情報を保存します
  #
  #   クッキーに暗号化したユーザーIDをセットする
  #   クッキーにremember_tokenをセットする
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
end
