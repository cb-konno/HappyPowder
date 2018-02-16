# == Schema Information
#
# Table name: messages
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
#   index_tasks_on_status btree (status)
#
require 'rails_helper'

describe Task do
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
        it 'タスク名は50文字以内であること' do
          task = Task.new(name: 'じ' * 50, priority: 'high', status: 'created')
          expect(task).to be_valid
          task = Task.new(name: '字' * 51, priority: 'high', status: 'created')
          expect(task).not_to be_valid
        end
        it '説明は2000文字以内であること' do
          task = Task.new(name: 'something task title', description: 'じ' * 2000, priority: 'high', status: 'created')
          expect(task).to be_valid
          task = Task.new(name: 'something task title', description: '字' * 2001, priority: 'high', status: 'created')
          expect(task).not_to be_valid
        end
      end
    end
  end
end
