#require 'rails_helper'
require 'features_helper'

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
    fill_in 'task[started_on]', with: '2018-02-01'
    fill_in 'task[ended_on]', with: '2018-02-28'
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
    expect(table).to have_content t('task.status.created')
    expect(table).to have_content t('task.priority.high')
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
    fill_in 'task[started_on]', with: '2018-02-01'
    fill_in 'task[ended_on]', with: '2018-02-28'
    click_button t('submit.edit')

    expect(page).to have_content t('flash.update_success', target: Task.model_name.human)

    header = find('header')
    expect(header).to have_content t('title_show', title: Task.model_name.human)
    table = find('table#disp')
    expect(table).to have_content '更新後のタスク'
    expect(table).to have_content '更新した後のタスクの説明文'
    expect(table).to have_content t('task.status.doing')
    expect(table).to have_content t('task.priority.low')

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

RSpec.feature 'タスク一覧のソートをテスト', type: :feature do
  background do
    Task.create!(
      id: 1,
      name: '明治のタスク',
      description: '最古のタスク',
      status: 'done',
      priority: 'low',
      ended_on: '2000-01-01',
      created_at: '1900-01-01 00:51:00',
      updated_at: '2017-11-01 03:34:50'
    )
    Task.create!(
      id: 2,
      name: '昭和のタスク',
      description: '中間のタスク',
      status: 'created',
      priority: 'high',
      ended_on: '2017-10-18',
      created_at: '1982-06-09 12:00:00',
      updated_at: '2016-12-01 09:21:45'
    )
    Task.create!(
      id: 3,
      name: '平成のタスク',
      description: '最新のタスク',
      status: 'doing',
      priority: 'middle',
      ended_on: '2013-04-24',
      created_at: '2010-12-12 00:15:33',
      updated_at: '2018-02-01 23:43:20')
  end

  describe '作成日時のソートテスト' do
    it '降順で表示する' do
      visit tasks_path('q[s]': 'created_at desc')

      header = find('header')
      expect(header).to have_content t('title_index', title: Task.model_name.human)
      data = parse_data

      expect(data.map { |e| [e[0], e[1], e[2], e[3], e[4]] }).to eq [
        ['3', '平成のタスク', '最新のタスク', t('task.status.doing'), t('task.priority.middle')],
        ['2', '昭和のタスク', '中間のタスク', t('task.status.created'), t('task.priority.high')],
        ['1', '明治のタスク', '最古のタスク', t('task.status.done'), t('task.priority.low')]]
    end

    it '昇順で表示する' do
      visit tasks_path('q[s]': 'created_at asc')

      header = find('header')
      expect(header).to have_content t('title_index', title: Task.model_name.human)
      data = parse_data

      expect(data.map { |e| [e[0], e[1], e[2], e[3], e[4]] }).to eq [
        ['1', '明治のタスク', '最古のタスク', t('task.status.done'), t('task.priority.low')],
        ['2', '昭和のタスク', '中間のタスク', t('task.status.created'), t('task.priority.high')],
        ['3', '平成のタスク', '最新のタスク', t('task.status.doing'), t('task.priority.middle')]]
    end
  end

  describe '終了日のソートテスト' do
    it '降順で表示する' do
      visit tasks_path('q[s]': 'ended_on desc')

      header = find('header')
      expect(header).to have_content t('title_index', title: Task.model_name.human)
      data = parse_data

      expect(data.map { |e| [e[0], e[1], e[2], e[3], e[4], e[6]] }).to eq [
        ['2', '昭和のタスク', '中間のタスク', t('task.status.created'), t('task.priority.high'), '2017/10/18'],
        ['3', '平成のタスク', '最新のタスク', t('task.status.doing'), t('task.priority.middle'), '2013/04/24'],
        ['1', '明治のタスク', '最古のタスク', t('task.status.done'), t('task.priority.low'), '2000/01/01']]
    end

    it '昇順で表示する' do
      visit tasks_path('q[s]': 'ended_on asc')

      header = find('header')
      expect(header).to have_content t('title_index', title: Task.model_name.human)
      data = parse_data

      expect(data.map { |e| [e[0], e[1], e[2], e[3], e[4], e[6]] }).to eq [
        ['1', '明治のタスク', '最古のタスク', t('task.status.done'), t('task.priority.low'), '2000/01/01'],
        ['3', '平成のタスク', '最新のタスク', t('task.status.doing'), t('task.priority.middle'), '2013/04/24'],
        ['2', '昭和のタスク', '中間のタスク', t('task.status.created'), t('task.priority.high'), '2017/10/18']]
    end
  end

  describe '異常パラメータによるソートのテスト' do
    it '存在しないカラム名でソートする' do
      visit tasks_path('q[s]': 'not_existed desc')

      header = find('header')
      expect(header).to have_content t('title_index', title: Task.model_name.human)
      data = parse_data

      expect(data.map { |e| [e[0], e[1], e[2], e[3], e[4], e[6]] }).to eq [
        ['3', '平成のタスク', '最新のタスク', t('task.status.doing'), t('task.priority.middle'), '2013/04/24'],
        ['2', '昭和のタスク', '中間のタスク', t('task.status.created'), t('task.priority.high'), '2017/10/18'],
        ['1', '明治のタスク', '最古のタスク', t('task.status.done'), t('task.priority.low'), '2000/01/01']]
    end

    it '存在しないオーダーでソートする' do
      visit tasks_path('q[s]': 'created_at not_existed_order')

      header = find('header')
      expect(header).to have_content t('title_index', title: Task.model_name.human)
      data = parse_data

      expect(data.map { |e| [e[0], e[1], e[2], e[3], e[4], e[6]] }).to eq [
        ['1', '明治のタスク', '最古のタスク', t('task.status.done'), t('task.priority.low'), '2000/01/01'],
        ['2', '昭和のタスク', '中間のタスク', t('task.status.created'), t('task.priority.high'), '2017/10/18'],
        ['3', '平成のタスク', '最新のタスク', t('task.status.doing'), t('task.priority.middle'), '2013/04/24']]
    end
  end

end

RSpec.feature 'バリデーションのテスト', type: :feature do
  describe '新規作成時のバリデーション' do
    it '必須項目のテスト' do
      visit new_task_path
      fill_in 'task[name]', with: ''
      select t('select.default'), from: 'task[status]'
      select t('select.default'), from: 'task[priority]'
      click_button t('submit.new')

      header = find('header')
      expect(header).to have_content t('title_new', title: Task.model_name.human)
      within('.errors') do
        expect(page.find('h3')).to have_content '3件のエラーがあります'
        expect(page.find('.messages').find('ul').all('li').map { |li| li.text }).to have_content [
          'タスク名 を入力してください',
          'ステータス を選択してください',
          '優先度 を選択してください',]
      end
    end

    it '最大文字数のテスト' do
      visit new_task_path
      fill_in 'task[name]', with: 'a' * 51
      fill_in 'task[description]', with: 'あ' * 2001
      select t('task.status.doing'), from: 'task[status]'
      select t('task.priority.low'), from: 'task[priority]'
      click_button t('submit.new')

      header = find('header')
      expect(header).to have_content t('title_new', title: Task.model_name.human)
      within('.errors') do
        expect(page.find('h3')).to have_content '2件のエラーがあります'
        expect(page.find('.messages').find('ul').all('li').map { |li| li.text }).to have_content [
          'タスク名 は50文字以内で入力してください',
          '説明 は2000文字以内で入力してください',]
      end
    end
  end

  describe '更新時のバリデーション' do
    background do
      Task.create!(id: 1, name: '更新前のタスク名', description: '更新する前のタスクの説明文', status: 'created', priority: 'middle')
    end

    it '必須項目のテスト' do
      task = Task.find(1)
      visit edit_task_path(task)
      fill_in 'task[name]', with: ''
      select t('select.default'), from: 'task[status]'
      select t('select.default'), from: 'task[priority]'
      click_button t('submit.edit')

      header = find('header')
      expect(header).to have_content t('title_edit', title: Task.model_name.human)
      within('.errors') do
        expect(page.find('h3')).to have_content '3件のエラーがあります'
        expect(page.find('.messages').find('ul').all('li').map { |li| li.text }).to have_content [
          'タスク名 を入力してください',
          'ステータス を選択してください',
          '優先度 を選択してください',]
      end
    end

    it '最大文字数のテスト' do
      task = Task.find(1)
      visit edit_task_path(task)
      fill_in 'task[name]', with: 'a' * 51
      fill_in 'task[description]', with: 'あ' * 2001
      select t('task.status.doing'), from: 'task[status]'
      select t('task.priority.low'), from: 'task[priority]'
      click_button t('submit.edit')

      header = find('header')
      expect(header).to have_content t('title_edit', title: Task.model_name.human)
      within('.errors') do
        expect(page.find('h3')).to have_content '2件のエラーがあります'
        expect(page.find('.messages').find('ul').all('li').map { |li| li.text }).to have_content [
          'タスク名 は50文字以内で入力してください',
          '説明 は2000文字以内で入力してください',]
      end
    end

  end

end
