# == Schema Information
#
# Table name: tasks
#
#  id           :integer    not null, primary key
#  name         :string     not null
#  description  :string
#  priority     :enum
#  status       :enum
#  start_on     :date
#  ended_on     :datet
#  created_at   :datetime   not null
#  updated_at   :datetime   not null
#
#
# Indexes:
#   tasks_pkey PRIMARY KEY, btree (id)
#   index_tasks_on_name   btree (name)
#   index_tasks_on_priority btree (priority)
#   index_tasks_on_status btree (status)
#
require 'rails_helper'

RSpec.describe Task, type: :model do

  it 'Task生成テスト' do
    task = Task.create(
      id: 1,
      name: 'タスク名',
      description: 'タスク説明',
      status: 'done',
      priority: 'low',
      started_on: '1999-12-31',
      ended_on: '2000-01-01',
      user_id: 1
    )
    expect(task.id).to eq 1
    expect(task.name).to eq 'タスク名'
    expect(task.description).to eq 'タスク説明'
    expect(task.status).to eq 'done'
    expect(task.priority).to eq 'low'
    expect(task.started_on).to eq DateTime.strptime('1999-12-31', "%Y-%m-%d")
    expect(task.ended_on).to eq DateTime.strptime('2000-01-01', "%Y-%m-%d")
  end

  describe 'バリデーションテスト' do
    describe '必須項目テスト' do
      it 'タスク名が必須項目であること' do
        task = Task.new(name: '', priority: 'high', status: 'created')
        expect(task).not_to be_valid
      end

      it '優先度が必須項目であること' do
        task = Task.new(name: 'This is Task Name', priority: '', status: 'created')
        expect(task).not_to be_valid
      end

      it 'ステータスが必須項目であること' do
        task = Task.new(name: 'This is Task Name', priority: 'high', status: '')
        expect(task).not_to be_valid
      end

      describe '入力制限テスト' do
        before do
          User.create!(id: 1, name: 'ウマ面のプリンセス', mail: 'horse@face.com', password: 'hihiiiiin')
        end
        it 'タスク名は50文字以内であること' do
          task = Task.new(name: 'じ' * 50, priority: 'high', status: 'created', user_id: 1)
          expect(task).to be_valid
          task = Task.new(name: '字' * 51, priority: 'high', status: 'created', user_id: 1)
          expect(task).not_to be_valid
        end
        it '説明は2000文字以内であること' do
          task = Task.new(name: 'something task title', description: 'じ' * 2000, priority: 'high', status: 'created', user_id: 1)
          expect(task).to be_valid
          task = Task.new(name: 'something task title', description: '字' * 2001, priority: 'high', status: 'created', user_id: 1)
          expect(task).not_to be_valid
        end
      end
    end
  end

  describe 'ransack_with_check_paramsメソッドのテスト' do
    before do
      @task1 = Task.create(
        id: 1,
        name: '明治のタスク',
        description: '最古のタスク',
        status: 'done',
        priority: 'low',
        ended_on: '2000-01-01',
        created_at: '1900-01-01 00:51:00',
        updated_at: '2017-11-01 03:34:50'
      )
      @task2 = Task.create(
        id: 2,
        name: '昭和のタスク',
        description: '中間のタスク',
        status: 'created',
        priority: 'high',
        ended_on: '2017-10-18',
        created_at: '1982-06-09 12:00:00',
        updated_at: '2016-12-01 09:21:45'
      )
      @task3 = Task.create(
        id: 3,
        name: '平成のタスク',
        description: '最新のタスク',
        status: 'doing',
        priority: 'middle',
        ended_on: '2013-04-24',
        created_at: '2010-12-12 00:15:33',
        updated_at: '2018-02-01 23:43:20')
    end

    it '引数にparams[:q][:s]形式の値がセットされているとき、引数で指定した並びに順になっていること' do
      tasks = [@task2, @task3, @task1]

      sorted_tasks = Task.ransack_with_check_params(q: { s: 'ended_on desc' }).result
      sorted_tasks.each_with_index { |sorted_task, i|
        expect(sorted_task[:name]).to eq tasks[i][:name]
        expect(sorted_task[:description]).to eq tasks[i][:description]
        expect(sorted_task[:status]).to eq tasks[i][:status]
        expect(sorted_task[:priority]).to eq tasks[i][:priority]
        expect(sorted_task[:ended_on]).to eq tasks[i][:ended_on]
        expect(sorted_task[:created_at]).to eq tasks[i][:created_at]
        expect(sorted_task[:updated_at]).to eq tasks[i][:updated_at]
      }
    end

    it '引数にparams[:q][:s]形式の値がセットされているとき、作成日時の降順であること' do
      tasks = [@task3, @task2, @task1]

      sorted_tasks = Task.ransack_with_check_params(q: {}).result
      sorted_tasks.each_with_index { |sorted_task, i|
        expect(sorted_task[:name]).to eq tasks[i][:name]
        expect(sorted_task[:description]).to eq tasks[i][:description]
        expect(sorted_task[:status]).to eq tasks[i][:status]
        expect(sorted_task[:priority]).to eq tasks[i][:priority]
        expect(sorted_task[:ended_on]).to eq tasks[i][:ended_on]
        expect(sorted_task[:created_at]).to eq tasks[i][:created_at]
        expect(sorted_task[:updated_at]).to eq tasks[i][:updated_at]
      }
    end

    it '引数なしで呼び出された場合、作成日時の降順であること' do
      tasks = [@task3, @task2, @task1]

      sorted_tasks = Task.ransack_with_check_params().result
      sorted_tasks.each_with_index { |sorted_task, i|
        expect(sorted_task[:name]).to eq tasks[i][:name]
        expect(sorted_task[:description]).to eq tasks[i][:description]
        expect(sorted_task[:status]).to eq tasks[i][:status]
        expect(sorted_task[:priority]).to eq tasks[i][:priority]
        expect(sorted_task[:ended_on]).to eq tasks[i][:ended_on]
        expect(sorted_task[:created_at]).to eq tasks[i][:created_at]
        expect(sorted_task[:updated_at]).to eq tasks[i][:updated_at]
      }
    end

  end

end
