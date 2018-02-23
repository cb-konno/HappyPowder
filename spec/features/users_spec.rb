require 'rails_helper'

RSpec.feature 'Users', type: :feature do

  describe 'ユーザー一覧画面のテスト' do
    describe '画面遷移のテスト' do
      describe 'ユーザー一覧画面から各画面へ遷移' do
        background do
          User.create!(id: 1, name: 'ウマ面のプリンセス', mail: 'horse@face.com', password: 'hihiiiiin')
        end

        it 'ユーザー一覧画面からタスク一覧画面へ遷移すること' do
          visit users_path
          click_link t('title_index', title: User.model_name.human)
          expect(find('header')).to have_content t('title_index', title: User.model_name.human)
        end

        it 'ユーザー一覧画面からユーザー詳細画面へ遷移すること' do
          user = User.find(1)
          visit user_path(user)
          expect(find('header')).to have_content t('title_show', title: User.model_name.human)
          expect(find('div#display')).to have_content user.id
          expect(find('div#display')).to have_content user.name
          expect(find('div#display')).to have_content user.mail
          expect(find('div#display')).to have_content user.password
        end

        it 'ユーザー一覧画面からユーザー編集画面へ遷移すること' do
          user = User.find(1)
          visit edit_user_path(user)
          expect(find('header')).to have_content t('title_edit', title: User.model_name.human)
          expect(find('input#user_id').value).to eq '1'
          expect(find('input#user_name').value).to eq user.name
          expect(find('input#user_mail').value).to eq user.mail
          expect(find('input#user_password').value).to eq user.password
        end

        it 'ユーザー一覧画面からユーザー新規作成画面へ遷移すること' do
          user = User.find(1)
          visit edit_user_path(user)
          expect(find('header')).to have_content t('title_edit', title: User.model_name.human)
          expect(find('input#user_id').value).to eq '1'
          expect(find('input#user_name').value).to eq user.name
          expect(find('input#user_mail').value).to eq user.mail
          expect(find('input#user_password').value).to eq user.password
        end

        it 'ユーザー一覧画面からユーザーの新規作成画面へ遷移すること' do
          user = User.new
          visit new_user_path(user)
          header = find('header')
          expect(find('header')).to have_content t('title_new', title: User.model_name.human)
        end
      end
    end

  end
end
