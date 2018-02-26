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
    expect(find('input#user_password').value).to eq user.password

  end
end

RSpec.feature '新規作成・更新・削除テスト', type: :feature do
  it 'ユーザー新規作成テスト' do
    user = User.new
    visit new_user_path(user)
    fill_in 'user[name]', with: '大西ライオン'
    fill_in 'user[mail]', with: 'do-not-worry@lion.com'
    fill_in 'user[password]', with: 'sinpainaisa-'
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
    expect(find('input#user_password').value).to eq user.password
    fill_in 'user[name]', with: '大西ライオン'
    fill_in 'user[mail]', with: 'do-not-worry@lion.com'
    fill_in 'user[password]', with: 'sinpainaisa-'
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

  it '必須項目テスト' do
    visit new_user_path
    fill_in 'user[name]', with: ''
    fill_in 'user[mail]', with: ''
    fill_in 'user[password]', with: ''
    click_button t('submit.new')

    expect(find('header')).to have_content t('title_new', title: User.model_name.human)
    within('.errors') do
      expect(find('h3')).to have_content t('errors.messages.count', count: 3)
      expect(page.find('.messages').find('ul').all('li').map { |li| li.text }).to have_content [
        'メールアドレス  を正しい形式で入力してください',
        'パスワード を入力してください',
        'ユーザー名  を入力してください'
      ]
    end
  end

  it '最大文字数のテスト' do
    visit new_user_path
    fill_in 'user[name]', with: 'も' * 51
    fill_in 'user[mail]', with: '字' * 101
    fill_in 'user[password]', with: 's' * 17
    click_button t('submit.new')
    expect(find('header')).to have_content t('title_new', title: User.model_name.human)
    within('.errors') do
      expect(find('h3')).to have_content t('errors.messages.count', count: 4)
      expect(page.find('.messages').find('ul').all('li').map { |li| li.text }).to have_content [
        'メールアドレス  は100文字以内で入力してください',
        'メールアドレス  を正しい形式で入力してください',
        'パスワード は16文字以内で入力してください',
        'ユーザー名 は50文字以内で入力してください'
      ]
    end
  end
end
