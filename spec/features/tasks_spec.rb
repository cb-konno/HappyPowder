require 'rails_helper'

RSpec.feature 'リンクのテスト', type: :feature do

  it 'トップページから新規作成ページに遷移する' do
    visit root_path
    click_link '新規作成'
    expect(page).to have_content 'タスク新規作成'
  end

  it '新規作成ページからトップページに遷移する' do
    visit new_task_path
    click_link '一覧'
    expect(page).to have_content 'タスク一覧'
  end

end

RSpec.feature 'タスクの登録・更新・削除のテスト', type: :feature do

  it 'タスクの登録をテストします' do
    visit new_task_path
    fill_in 'task[name]', with: 'テストで追加する課題の名前'
    fill_in 'task[description]', with: '課題の説明文を長々と…'
    click_button 'Create Task'
    expect(page).to have_content 'New Task Created.'
  end

end
