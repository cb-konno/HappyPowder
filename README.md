# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
ruby 2.5.0

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


## テーブルスキーマ（モデル名・カラム名・データ型）
###### ユーザー(Users)
| カラム名 | データ型 |
|:-----------|------------:|
| ID       | Primary       |
| mail       | VARCHAR(255)       |
| password       | VARCHAR(255)       |
| name       | VARCHAR(255)       |
| ins_date       | timestamp      |
| up_date       | timestamp      |
| is_deleted       | boolean      |
