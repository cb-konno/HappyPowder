def t(key, options = {})
  I18n.t(key, options)
end

def login
  @user = create(:user)
  visit login_path
  fill_in 'sessions[mail]', with: 'mail@address.com'
  fill_in 'sessions[password]', with: 'password'
  click_button 'ログイン'
end
