# == Schema Information
#
# Table name: users
#
#  id           :integer    not null, primary key
#  mail         :string     not null
#  password     :string     not null
#  name         :string     not null
#  created_at   :datetime   not null
#  updated_at   :datetime   not null
#  deleted   :boolean
#
# Indexes:
#   tasks_pkey PRIMARY KEY, btree (id)
#   index_users_on_mail" btree (mail)
#   index_users_on_name" btree (name)
#
require 'rails_helper'

RSpec.describe User, type: :model do
  it 'Users生成テスト' do
    user = User.create!(id: 1, name: 'サカナ顔の王子', mail: 'fish@prince.jp', password: 'kaisendon')
    expect(user.id).to eq 1
    expect(user.name).to eq 'サカナ顔の王子'
    expect(user.mail).to eq 'fish@prince.jp'
    expect(user.password).to eq 'kaisendon'
  end

  describe 'バリデーションテスト' do
    describe '必須項目のテスト' do
      it 'ユーザー名が必須項目であること' do
        user = User.new(name: '', mail: 'fish@prince.jp', password: 'kaisendon')
        expect(user).not_to be_valid
      end

      it 'メールアドレスが必須項目であること' do
        user = User.new(name: 'サカナ顔の王子', mail: '', password: 'kaisendon')
        expect(user).not_to be_valid
      end

      it 'パスワードが必須項目であること' do
        user = User.new(name: 'サカナ顔の王子', mail: 'fish@prince.jp', password: '')
        expect(user).not_to be_valid
      end
    end

    describe '入力制限のテスト' do
      it 'ユーザー名は50文字以内であること' do
        user = User.new(name: '字' * 50, mail: 'fish@prince.jp', password: 'kaisendon')
        expect(user).to be_valid
        user = User.new(name: '字' * 51, mail: 'fish@prince.jp', password: 'kaisendon')
        expect(user).not_to be_valid
      end

      it 'メールアドレスは100文字以内であること' do
        user = User.new(name: 'サカナ顔の王子', mail: 'a' * 96 + '@a.a', password: 'kaisendon')
        expect(user).to be_valid
        user = User.new(name: 'サカナ顔の王子', mail: 'a' * 97 + '@a.a', password: 'kaisendon')
        expect(user).not_to be_valid
      end

      it 'パスワードは16文字以内であること' do
        user = User.new(name: 'サカナ顔の王子', mail: 'fish@prince.jp', password: 'a' * 16)
        expect(user).to be_valid
        user = User.new(name: 'サカナ顔の王子', mail: 'fish@prince.jp', password: 'a' * 17)
        expect(user).not_to be_valid
      end

      it 'メールアドレス形式であること' do
        user = User.new(name: 'サカナ顔の王子', mail: 'mail@adress.com', password: 'kaisendon')
        expect(user).to be_valid
        user = User.new(name: 'サカナ顔の王子', mail: 'not_a_mark.com', password: 'kaisendon')
        expect(user).not_to be_valid
        user = User.new(name: 'サカナ顔の王子', mail: 'no@priod', password: 'kaisendon')
        expect(user).not_to be_valid
      end
    end

    describe '重複メールアドレス確認のテスト' do
      before do
        User.create(name: 'サカナ顔の王子', mail: 'same-mail@adress.com', password: 'kaisendon')
      end

      it 'メールアドレスの重複で登録できないこと' do
        user = User.new(name: 'サカナ顔の王子', mail: 'same-mail@adress.com', password: 'kaisendon')
        expect(user).not_to be_valid
      end
    end
  end
end
