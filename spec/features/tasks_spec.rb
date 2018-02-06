require 'rails_helper'

RSpec.feature 'リンクのテスト', type: :feature do

  it 'トップページから新規作成ページに遷移する' do
    visit root_path
    click_link t('link_to_new')
    header = find('header')
    expect(header).to have_content t('title_new', title: Task.model_name.human)
  end

  it '新規作成ページからトップページに遷移する' do
    visit new_task_path
    click_link t('link_to_index')
    header = find('header')
    expect(header).to have_content t('title_index', title: Task.model_name.human)
  end

end

RSpec.feature 'タスクの新規作成テスト', type: :feature do

  it 'タスクの登録をテストします' do
    visit new_task_path
    fill_in 'task[name]', with: 'テストで追加する課題の名前'
    fill_in 'task[description]', with: '課題の説明文を長々と…'
    select t('task.status.created'), from: 'task[status]'
    select t('task.priority.middle'), from: 'task[priority]'
    fill_in 'task[started_at]', with: '2018-02-01'
    fill_in 'task[ended_at]', with: '2018-02-28'
    click_button t('submit.new')
    expect(page).to have_content t('flash.create_success', target: Task.model_name.human)
    header = find('header')
    expect(header).to have_content t('title_index', title: Task.model_name.human)
    table = find('table#index')
    expect(table).to have_content 'テストで追加する課題の名前'
    expect(table).to have_content '課題の説明文を長々と…'

  end

end

RSpec.feature 'タスクの詳細画面表示テスト', type: :feature do
  background do
    Task.create!(id: 1, name: 'パン工場に行く', description: 'アンパンマンの顔を焼く', status: 'created', priority: 'high')
  end
  scenario 'タスク詳細画面を表示する' do
    task = Task.find(1)
    visit task_path(task)

    header = find('header')
    expect(header).to have_content t('title_show', title: Task.model_name.human)
    table = find('table#disp')
    expect(table).to have_content task.id
    expect(table).to have_content task.name
    expect(table).to have_content task.description
    expect(table).to have_content task.status
    expect(table).to have_content task.priority
  end

end

RSpec.feature 'タスクを更新するテスト', type: :feature do

  background do
    Task.create!(id: 1, name: '更新前のタスク名', description: '更新する前のタスクの説明文', status: 'created', priority: 'middle')
  end

  scenario 'タスクの更新画面を表示する' do
    task = Task.find(1)
    visit edit_task_path(task)

    header = find('header')
    expect(header).to have_content t('title_edit', title: Task.model_name.human)
    form = find('table#form')
    expect(form).to have_content 1
    input = find('input#task_name')
    expect(input.value).to eq task.name
    textarea = find('textarea#task_description')
    expect(textarea.value).to eq task.description
    select = find('select#task_status')
    expect(select.value).to eq task.status
    select = find('select#task_priority')
    expect(select.value).to eq task.priority
  end

  scenario '更新画面からタスクを更新する' do
    task = Task.find(1)
    visit edit_task_path(task)

    fill_in 'task[name]', with: '更新後のタスク'
    fill_in 'task[description]', with: '更新した後のタスクの説明文'
    select t('task.status.doing'), from: 'task[status]'
    select t('task.priority.low'), from: 'task[priority]'
    fill_in 'task[started_at]', with: '2018-02-01'
    fill_in 'task[ended_at]', with: '2018-02-28'
    click_button t('submit.edit')

    expect(page).to have_content t('flash.update_success', target: Task.model_name.human)

    header = find('header')
    expect(header).to have_content t('title_show', title: Task.model_name.human)
    table = find('table#disp')
    expect(table).to have_content '更新後のタスク'
    expect(table).to have_content '更新した後のタスクの説明文'
    expect(table).to have_content 'doing'
    expect(table).to have_content 'low'

  end

end


RSpec.feature 'タスクを削除するテスト', type: :feature, js: true do
  background do
    Task.create!(id: 1, name: '削除するタスク名', description: '削除するタスクの説明文', status: 'created', priority: 'middle')
    task = Task.find(1)
    visit task_path(task)

  end

  it 'タスクを削除する' do
    header = find('header')
    expect(header).to have_content t('title_show', title: Task.model_name.human)
    table = find('table#disp')
    expect(table).to have_content '削除するタスク名'
    expect(table).to have_content '削除するタスクの説明文'

    accept_confirm { click_link t('link_to_delete') }
    header = find('header')
    expect(header).to have_content t('title_index', title: Task.model_name.human)
    table = find('table#index')
    expect(table).not_to have_content '削除するタスク名'
    expect(table).not_to have_content '削除するタスクの説明文'
  end

end
