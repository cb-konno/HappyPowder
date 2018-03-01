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

  #現在ログイン中のユーザーを取得する
  def current_user
    if @current_user.nil?
      @current_user = User.find_by(id: session[:user_id])
    else
      @current_user
    end
  end

  #ログイン中判定メソッド
  def logged_in
    !current_user.nil?
  end
end
