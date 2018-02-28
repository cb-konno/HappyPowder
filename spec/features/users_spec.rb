require 'rails_helper'

RSpec.feature '画面表示テスト', type: :feature do
  background do
    User.create!(id: 1, name: 'ウマ面のプリンセス', mail: 'horse@face.com', password: 'hihiiiiin')
  end

  it 'ユーザー一覧画面を表示する' do
    visit users_path
    click_link t('title_index', title: User.model_name.human)
    expect(find('header')).to have_content t('title_index', title: User.model_name.human)

  end
  it 'ユーザー新規画面を表示する' do
    user = User.new
    visit new_user_path(user)
    header = find('header')
    expect(find('header')).to have_content t('title_new', title: User.model_name.human)

  end
  it 'ユーザー詳細画面を表示する' do
    user = User.find(1)
    visit user_path(user)
    expect(find('header')).to have_content t('title_show', title: User.model_name.human)
    expect(find('div#display')).to have_content user.id
    expect(find('div#display')).to have_content user.name
    expect(find('div#display')).to have_content user.mail

  end
  it 'ユーザー更新画面を表示する' do
    user = User.find(1)
    visit edit_user_path(user)
    expect(find('header')).to have_content t('title_edit', title: User.model_name.human)
    expect(find('input#user_id').value).to eq '1'
    expect(find('input#user_name').value).to eq user.name
    expect(find('input#user_mail').value).to eq user.mail
    expect(find('input#user_password').value).to eq ''
    expect(find('input#user_password_confirmation').value).to eq ''

  end
end

RSpec.feature '新規作成・更新・削除テスト', type: :feature do
  it 'ユーザー新規作成テスト' do
    user = User.new
    visit new_user_path(user)
    fill_in 'user[name]', with: '大西ライオン'
    fill_in 'user[mail]', with: 'do-not-worry@lion.com'
    fill_in 'user_password', with: 'sinpainaisa-'
    fill_in 'user_password_confirmation', with: 'sinpainaisa-'
    click_button t('submit.new')
    expect(page).to have_content t('flash.create_success', target: User.model_name.human)
    expect(find('header')).to have_content t('title_index', title: User.model_name.human)
    expect(find('table#index')).to have_content '大西ライオン'
    expect(find('table#index')).to have_content 'do-not-worry@lion.com'
  end

  it 'ユーザー更新テスト' do
    User.create!(id: 5, name: 'ゴリラ顔のマドンナ', mail: 'gorira@face.com', password: 'uhouhouho')
    user = User.find(5)
    visit edit_user_path(user)
    expect(find('input#user_id').value).to eq '5'
    expect(find('input#user_name').value).to eq user.name
    expect(find('input#user_mail').value).to eq user.mail
    expect(find('input#user_password').value).to eq ''
    expect(find('input#user_password_confirmation').value).to eq ''
    fill_in 'user[name]', with: '大西ライオン'
    fill_in 'user[mail]', with: 'do-not-worry@lion.com'
    fill_in 'user[password]', with: 'sinpainaisa-'
    fill_in 'user[password_confirmation]', with: 'sinpainaisa-'
    click_button t('submit.edit')
    expect(page).to have_content t('flash.update_success', target: User.model_name.human)
    expect(find('header')).to have_content t('title_index', title: User.model_name.human)
  end

  it 'ユーザー削除テスト' do
    User.create!(id: 5, name: 'ゴリラ顔のマドンナ', mail: 'gorira@face.com', password: 'uhouhouho')
    user = User.find(5)
    visit user_path(user)
    expect(find('header')).to have_content t('title_show', title: User.model_name.human)
    expect(find('div#display')).to have_content 'ゴリラ顔のマドンナ'
    expect(find('div#display')).to have_content 'gorira@face.com'
    accept_confirm { click_link t('link_to_delete') }
    expect(page).to have_content t('flash.destroy_success', target: User.model_name.human)
    expect(find('header')).to have_content t('title_index', title: User.model_name.human)
  end
end


RSpec.feature 'バリデーションテスト', type: :feature do

  describe 'ユーザー名のバリデーションテスト' do
    background do
      visit new_user_path
      fill_in 'user[mail]', with: 'mail@address.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
    end

    it '入力必須テスト' do
      fill_in 'user[name]', with: ''
      click_button t('submit.new')
      expect(find('header')).to have_content t('title_new', title: User.model_name.human)
      within('.errors') do
        expect(find('h3')).to have_content t('errors.messages.count', count: 1)
        expect(page.find('.messages').find('ul').all('li').map { |li| li.text }).to have_content [
          'ユーザー名  を入力してください'
        ]
      end
    end

    it '50文字以内テスト' do
      fill_in 'user[name]', with: '字' * 51
      click_button t('submit.new')
      expect(find('header')).to have_content t('title_new', title: User.model_name.human)
      within('.errors') do
        expect(find('h3')).to have_content t('errors.messages.count', count: 1)
        expect(page.find('.messages').find('ul').all('li').map { |li| li.text }).to have_content [
          'ユーザー名 は50文字以内で入力してください'
        ]
      end
    end
  end

  describe 'メールアドレスのバリデーション' do
    background do
      visit new_user_path
      fill_in 'user[name]', with: 'サンドバックマン'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
    end

    it '入力必須テスト' do
      fill_in 'user[mail]', with: ''
      click_button t('submit.new')
      expect(find('header')).to have_content t('title_new', title: User.model_name.human)
      within('.errors') do
        expect(find('h3')).to have_content t('errors.messages.count', count: 1)
        expect(page.find('.messages').find('ul').all('li').map { |li| li.text }).to have_content [
          'メールアドレス を正しい形式で入力してください'
        ]
      end
    end

    it '重複チェックテスト' do
      User.create(name: '重複太郎', mail: 'exist@address.com', password: 'password')
      fill_in 'user[mail]', with: 'exist@address.com'
      click_button t('submit.new')
      expect(find('header')).to have_content t('title_new', title: User.model_name.human)
      within('.errors') do
        expect(find('h3')).to have_content t('errors.messages.count', count: 1)
        expect(page.find('.messages').find('ul').all('li').map { |li| li.text }).to have_content [
          'メールアドレス は既に登録済みです'
        ]
      end
    end

    it '100文字以内テスト' do
      fill_in 'user[mail]', with: '字' * 101
      click_button t('submit.new')
      expect(find('header')).to have_content t('title_new', title: User.model_name.human)
      within('.errors') do
        expect(find('h3')).to have_content t('errors.messages.count', count: 2)
        expect(page.find('.messages').find('ul').all('li').map { |li| li.text }).to have_content [
          'メールアドレス は100文字以内で入力してください',
          'メールアドレス を正しい形式で入力してください'
        ]
      end
    end

    it 'メールアドレス形式確認テスト' do
      fill_in 'user[mail]', with: 'no-atto-mark.com'
      click_button t('submit.new')
      expect(find('header')).to have_content t('title_new', title: User.model_name.human)
      within('.errors') do
        expect(find('h3')).to have_content t('errors.messages.count', count: 1)
        expect(page.find('.messages').find('ul').all('li').map { |li| li.text }).to have_content [
          'メールアドレス を正しい形式で入力してください'
        ]
      end

      fill_in 'user[mail]', with: 'no-dotto-mark@com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_button t('submit.new')
      expect(find('header')).to have_content t('title_new', title: User.model_name.human)
      within('.errors') do
        expect(find('h3')).to have_content t('errors.messages.count', count: 1)
        expect(page.find('.messages').find('ul').all('li').map { |li| li.text }).to have_content [
          'メールアドレス を正しい形式で入力してください'
        ]
      end
    end
  end

  describe 'パスワード' do
    background do
      visit new_user_path
      fill_in 'user[name]', with: 'サンドバックマン'
      fill_in 'user[mail]', with: 'yes@takasu.clinic'
      fill_in 'user[password_confirmation]', with: 'password'
    end

    it '入力必須テスト' do
      fill_in 'user[password]', with: ''
      click_button t('submit.new')
      expect(find('header')).to have_content t('title_new', title: User.model_name.human)
      within('.errors') do
        expect(find('h3')).to have_content t('errors.messages.count', count: 1)
        expect(page.find('.messages').find('ul').all('li').map { |li| li.text }).to have_content [
          'パスワード を入力してください'
        ]
      end
    end

    it '16文字以内テスト' do
      fill_in 'user[password]', with: '12345678901234567'
      click_button t('submit.new')
      expect(find('header')).to have_content t('title_new', title: User.model_name.human)
      within('.errors') do
        expect(find('h3')).to have_content t('errors.messages.count', count: 2)
        expect(page.find('.messages').find('ul').all('li').map { |li| li.text }).to have_content [
          'パスワード（確認用） とパスワードの入力が一致しません',
          'パスワード は16文字以内で入力してください'
        ]
      end
    end

    it 'パスワード（確認用）一致テスト' do
      fill_in 'user[password]', with: 'p@ssword'
      click_button t('submit.new')
      expect(find('header')).to have_content t('title_new', title: User.model_name.human)
      within('.errors') do
        expect(find('h3')).to have_content t('errors.messages.count', count: 1)
        expect(page.find('.messages').find('ul').all('li').map { |li| li.text }).to have_content [
          'パスワード（確認用） とパスワードの入力が一致しません'
        ]
      end

    end
  end
end
