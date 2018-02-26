require 'rails_helper'

RSpec.feature 'Users', type: :feature do

  describe '画面表示テスト' do
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
      expect(find('div#display')).to have_content user.password

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
end
