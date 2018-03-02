require 'features_helper'

RSpec.feature 'リンクのテスト', type: :feature do
  background do
    login
  end

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
  background do
    login
  end

  it 'タスクの登録をテストします' do
    visit new_task_path
    fill_in 'task[name]', with: 'テストで追加する課題の名前'
    select 'ゴリラ顔のマドンナ', from: 'task[user_id]'
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

  end

end

RSpec.feature 'タスクの詳細画面表示テスト', type: :feature do
  background do
    login
    Task.create!(id: 1, name: 'パン工場に行く', description: 'アンパンマンの顔を焼く', status: 'created', priority: 'high', user_id: 5)
  end
  scenario 'タスク詳細画面を表示する' do
    task = Task.find(1)
    visit task_path(task)

    header = find('header')
    expect(header).to have_content t('title_show', title: Task.model_name.human)
    disp = find('div#display')
    expect(disp).to have_content task.id
    expect(disp).to have_content task.name
    expect(disp).to have_content task.user.name
    expect(disp).to have_content task.description
    expect(disp).to have_content t('task.status.created')
    expect(disp).to have_content t('task.priority.high')
  end

end

RSpec.feature 'タスクを更新するテスト', type: :feature do
  background do
    login
    Task.create!(id: 1, name: '更新前のタスク名', description: '更新する前のタスクの説明文', status: 'created', priority: 'middle', user_id: 5)
  end

  scenario 'タスクの更新画面を表示する' do
    task = Task.find(1)
    visit edit_task_path(task)
    header = find('header')
    expect(header).to have_content t('title_edit', title: Task.model_name.human)
    input = find('input#task_id')
    expect(input.value).to eq '1'
    input = find('input#task_name')
    expect(input.value).to eq task.name
    select = find('select#task_user_id')
    expect(select.value).to eq '5'
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
    select 'ゴリラ顔のマドンナ', from: 'task[user_id]'
    fill_in 'task[description]', with: '更新した後のタスクの説明文'
    select t('task.status.doing'), from: 'task[status]'
    select t('task.priority.low'), from: 'task[priority]'
    fill_in 'task[started_on]', with: '2018-02-01'
    fill_in 'task[ended_on]', with: '2018-02-28'
    click_button t('submit.edit')

    expect(page).to have_content t('flash.update_success', target: Task.model_name.human)

    header = find('header')
    expect(header).to have_content t('title_show', title: Task.model_name.human)
    disp = find('div#display')
    expect(disp).to have_content '1'
    expect(disp).to have_content 'ゴリラ顔のマドンナ'
    expect(disp).to have_content '更新後のタスク'
    expect(disp).to have_content '更新した後のタスクの説明文'
    expect(disp).to have_content t('task.status.doing')
    expect(disp).to have_content t('task.priority.low')
  end

end


RSpec.feature 'タスクを削除するテスト', type: :feature, js: true do
  background do
    login
    Task.create!(id: 1, name: '削除するタスク名', description: '削除するタスクの説明文', status: 'created', priority: 'middle', user_id: 5)
    task = Task.find(1)
    visit task_path(task)
  end

  it 'タスクを削除する' do
    header = find('header')
    expect(header).to have_content t('title_show', title: Task.model_name.human)
    table = find('div#display')
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
    login
    Task.create!(
      id: 1,
      name: '明治のタスク',
      description: '最古のタスク',
      status: 'done',
      priority: 'low',
      ended_on: '2000-01-01',
      created_at: '1900-01-01 00:51:00',
      updated_at: '2017-11-01 03:34:50',
      user_id: 5
    )
    Task.create!(
      id: 2,
      name: '昭和のタスク',
      description: '中間のタスク',
      status: 'created',
      priority: 'high',
      ended_on: '2017-10-18',
      created_at: '1982-06-09 12:00:00',
      updated_at: '2016-12-01 09:21:45',
      user_id: 5
    )
    Task.create!(
      id: 3,
      name: '平成のタスク',
      description: '最新のタスク',
      status: 'doing',
      priority: 'middle',
      ended_on: '2013-04-24',
      created_at: '2010-12-12 00:15:33',
      updated_at: '2018-02-01 23:43:20',
      user_id: 5)
  end

  describe '作成日時のソートテスト' do
    it '降順で表示する' do
      visit tasks_path('q[s]': 'created_at desc')

      header = find('header')
      expect(header).to have_content t('title_index', title: Task.model_name.human)
      data = parse_data

      expect(data.map { |e| [e[0], e[1], e[2], e[3], e[4]] }).to eq [
        ['3', '平成のタスク', t('task.status.doing'), t('task.priority.middle'), 'ゴリラ顔のマドンナ'],
        ['2', '昭和のタスク', t('task.status.created'), t('task.priority.high'), 'ゴリラ顔のマドンナ'],
        ['1', '明治のタスク', t('task.status.done'), t('task.priority.low'), 'ゴリラ顔のマドンナ']]
    end

    it '昇順で表示する' do
      visit tasks_path('q[s]': 'created_at asc')

      header = find('header')
      expect(header).to have_content t('title_index', title: Task.model_name.human)
      data = parse_data

      expect(data.map { |e| [e[0], e[1], e[2], e[3], e[4]] }).to eq [
        ['1', '明治のタスク', t('task.status.done'), t('task.priority.low'), 'ゴリラ顔のマドンナ'],
        ['2', '昭和のタスク', t('task.status.created'), t('task.priority.high'), 'ゴリラ顔のマドンナ'],
        ['3', '平成のタスク', t('task.status.doing'), t('task.priority.middle'), 'ゴリラ顔のマドンナ']]
    end
  end

  describe '終了日のソートテスト' do
    it '降順で表示する' do
      visit tasks_path('q[s]': 'ended_on desc')

      header = find('header')
      expect(header).to have_content t('title_index', title: Task.model_name.human)
      data = parse_data

      expect(data.map { |e| [e[0], e[1], e[2], e[3], e[4], e[6]] }).to eq [
        ['2', '昭和のタスク', t('task.status.created'), t('task.priority.high'), 'ゴリラ顔のマドンナ', '2017/10/18'],
        ['3', '平成のタスク', t('task.status.doing'), t('task.priority.middle'), 'ゴリラ顔のマドンナ', '2013/04/24'],
        ['1', '明治のタスク', t('task.status.done'), t('task.priority.low'), 'ゴリラ顔のマドンナ', '2000/01/01']]
    end

    it '昇順で表示する' do
      visit tasks_path('q[s]': 'ended_on asc')

      header = find('header')
      expect(header).to have_content t('title_index', title: Task.model_name.human)
      data = parse_data

      expect(data.map { |e| [e[0], e[1], e[2], e[3], e[4], e[6]] }).to eq [
        ['1', '明治のタスク', t('task.status.done'), t('task.priority.low'), 'ゴリラ顔のマドンナ', '2000/01/01'],
        ['3', '平成のタスク', t('task.status.doing'), t('task.priority.middle'), 'ゴリラ顔のマドンナ', '2013/04/24'],
        ['2', '昭和のタスク', t('task.status.created'), t('task.priority.high'), 'ゴリラ顔のマドンナ', '2017/10/18']]
    end
  end

  describe '優先度でソートするテスト' do
    it '降順でテストする' do
      visit tasks_path('q[s]': 'priority desc')

      header = find('header')
      expect(header).to have_content t('title_index', title: Task.model_name.human)
      data = parse_data
      expect(data.map { |e| [e[0], e[1], e[2], e[3], e[4], e[6]] }).to eq [
        ['1', '明治のタスク', t('task.status.done'), t('task.priority.low'), 'ゴリラ顔のマドンナ', '2000/01/01'],
        ['3', '平成のタスク', t('task.status.doing'), t('task.priority.middle'), 'ゴリラ顔のマドンナ', '2013/04/24'],
        ['2', '昭和のタスク', t('task.status.created'), t('task.priority.high'), 'ゴリラ顔のマドンナ', '2017/10/18']]
    end

    it '昇順でテストする' do
      visit tasks_path('q[s]': 'priority asc')

      header = find('header')
      expect(header).to have_content t('title_index', title: Task.model_name.human)
      data = parse_data
      expect(data.map { |e| [e[0], e[1], e[2], e[3], e[4], e[6]] }).to eq [
        ['2', '昭和のタスク', t('task.status.created'), t('task.priority.high'), 'ゴリラ顔のマドンナ', '2017/10/18'],
        ['3', '平成のタスク', t('task.status.doing'), t('task.priority.middle'), 'ゴリラ顔のマドンナ', '2013/04/24'],
        ['1', '明治のタスク', t('task.status.done'), t('task.priority.low'), 'ゴリラ顔のマドンナ', '2000/01/01']]
    end
  end

  describe '異常パラメータによるソートのテスト' do
    it '存在しないカラム名でソートする' do
      visit tasks_path('q[s]': 'not_existed desc')

      header = find('header')
      expect(header).to have_content t('title_index', title: Task.model_name.human)
      data = parse_data

      expect(data.map { |e| [e[0], e[1], e[2], e[3], e[4], e[6]] }).to eq [
        ['3', '平成のタスク', t('task.status.doing'), t('task.priority.middle'), 'ゴリラ顔のマドンナ', '2013/04/24'],
        ['2', '昭和のタスク', t('task.status.created'), t('task.priority.high'), 'ゴリラ顔のマドンナ', '2017/10/18'],
        ['1', '明治のタスク', t('task.status.done'), t('task.priority.low'), 'ゴリラ顔のマドンナ', '2000/01/01']]
    end

    it '存在しないオーダーでソートする' do
      visit tasks_path('q[s]': 'created_at not_existed_order')

      header = find('header')
      expect(header).to have_content t('title_index', title: Task.model_name.human)
      data = parse_data

      expect(data.map { |e| [e[0], e[1], e[2], e[3], e[4], e[6]] }).to eq [
        ['3', '平成のタスク', t('task.status.doing'), t('task.priority.middle'), 'ゴリラ顔のマドンナ', '2013/04/24'],
        ['2', '昭和のタスク', t('task.status.created'), t('task.priority.high'), 'ゴリラ顔のマドンナ', '2017/10/18'],
        ['1', '明治のタスク', t('task.status.done'), t('task.priority.low'), 'ゴリラ顔のマドンナ', '2000/01/01']]
    end
  end

end

RSpec.feature 'バリデーションのテスト', type: :feature do
  background do
    login
  end
  describe '新規作成時のバリデーション' do
    it '必須項目のテスト' do
      visit new_task_path
      fill_in 'task[name]', with: ''
      select t('select.default'), from: 'task[user_id]'
      select t('select.default'), from: 'task[status]'
      select t('select.default'), from: 'task[priority]'
      click_button t('submit.new')

      header = find('header')
      expect(header).to have_content t('title_new', title: Task.model_name.human)
      within('.errors') do
        expect(page.find('h3')).to have_content '4件のエラーがあります'
        expect(page.find('.messages').find('ul').all('li').map { |li| li.text }).to have_content [
          'タスク名 を入力してください',
          'ステータス を選択してください',
          '優先度 を選択してください',
          'ユーザー を選択してください']
      end
    end

    it '最大文字数のテスト' do
      visit new_task_path
      fill_in 'task[name]', with: 'a' * 51
      fill_in 'task[description]', with: 'あ' * 2001
      select 'ゴリラ顔のマドンナ', from: 'task[user_id]'
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
      Task.create!(id: 1, name: '更新前のタスク名', description: '更新する前のタスクの説明文', status: 'created', priority: 'middle', user_id: 5)
    end

    it '必須項目のテスト' do
      task = Task.find(1)
      visit edit_task_path(task)
      fill_in 'task[name]', with: ''
      select t('select.default'), from: 'task[user_id]'
      select t('select.default'), from: 'task[status]'
      select t('select.default'), from: 'task[priority]'
      click_button t('submit.edit')

      header = find('header')
      expect(header).to have_content t('title_edit', title: Task.model_name.human)
      within('.errors') do
        expect(page.find('h3')).to have_content '4件のエラーがあります'
        expect(page.find('.messages').find('ul').all('li').map { |li| li.text }).to have_content [
          'タスク名 を入力してください',
          'ステータス を選択してください',
          '優先度 を選択してください',
          'ユーザー を選択してください']
      end
    end

    it '最大文字数のテスト' do
      task = Task.find(1)
      visit edit_task_path(task)
      fill_in 'task[name]', with: 'a' * 51
      fill_in 'task[description]', with: 'あ' * 2001
      select 'ゴリラ顔のマドンナ', from: 'task[user_id]'
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

RSpec.feature '一覧のページャーのテスト', type: :feature do
  background do
    login
    55.times do |i|
      Task.create!(id: i,  name: 'タスク', status: 'created', priority: 'middle', created_at: Time.now, user_id: 5)
    end
  end

  it 'ページャーのテスト（番号）' do
    visit tasks_path
    header = find('header')
    expect(header).to have_content t('title_index', title: Task.model_name.human)
    data = parse_data
    expect(data.map { |e| [e[0], e[1], e[3], e[4]] }).to eq [
      ["54", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["53", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["52", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["51", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["50", "タスク", "中", "ゴリラ顔のマドンナ"]
    ]

    click_link 3
    expect(header).to have_content t('title_index', title: Task.model_name.human)
    data = parse_data
    expect(data.map { |e| [e[0], e[1], e[3], e[4]] }).to eq [
      ["44", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["43", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["42", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["41", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["40", "タスク", "中", "ゴリラ顔のマドンナ"]
    ]

    click_link 6
    expect(header).to have_content t('title_index', title: Task.model_name.human)
    data = parse_data
    expect(data.map { |e| [e[0], e[1], e[3], e[4]] }).to eq [
      ["29", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["28", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["27", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["26", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["25", "タスク", "中", "ゴリラ顔のマドンナ"]
    ]

    click_link 2
    expect(header).to have_content t('title_index', title: Task.model_name.human)
    data = parse_data
    expect(data.map { |e| [e[0], e[1], e[3], e[4]] }).to eq [
      ["49", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["48", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["47", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["46", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["45", "タスク", "中", "ゴリラ顔のマドンナ"]
    ]

    click_link t('pagination.next')
    expect(header).to have_content t('title_index', title: Task.model_name.human)
    data = parse_data
    expect(data.map { |e| [e[0], e[1], e[3], e[4]] }).to eq [
      ["44", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["43", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["42", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["41", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["40", "タスク", "中", "ゴリラ顔のマドンナ"]
    ]

    click_link t('pagination..previous')
    expect(header).to have_content t('title_index', title: Task.model_name.human)
    data = parse_data
    expect(data.map { |e| [e[0], e[1], e[3], e[4]] }).to eq [
      ["49", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["48", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["47", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["46", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["45", "タスク", "中", "ゴリラ顔のマドンナ"]
    ]

    click_link t('pagination.first')
    expect(header).to have_content t('title_index', title: Task.model_name.human)
    data = parse_data
    expect(data.map { |e| [e[0], e[1], e[3], e[4]] }).to eq [
      ["54", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["53", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["52", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["51", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["50", "タスク", "中", "ゴリラ顔のマドンナ"]
    ]

    click_link t('pagination.last')
    expect(header).to have_content t('title_index', title: Task.model_name.human)
    data = parse_data
    expect(data.map { |e| [e[0], e[1], e[3], e[4]] }).to eq [
      ["4", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["3", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["2", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["1", "タスク", "中", "ゴリラ顔のマドンナ"],
      ["0", "タスク", "中", "ゴリラ顔のマドンナ"]
    ]
  end
end
