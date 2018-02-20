# README
## Introduction.
This is a project for training.



## アプリケーションのURL
https://happy-powder.herokuapp.com/



## デプロイ方法

##### デプロイ
~~~
$ git push heroku master
~~~

##### マイグレーション
~~~
$ heroku run rake db:migrate
~~~



## 環境
* ruby 2.5.0p0
* Rails 5.1.4
* postgres (PostgreSQL) 10.1



## テーブルスキーマ（モデル名・カラム名・データ型）
###### ユーザー(Users)
| カラム名 | データ型 | 備考 |
|:-----------|:------------|:------------|
| ID         | Primary     | 主キー       |
| mail       | string(100) |             |
| password   | string(16)  |             |
| name       | string(50)  |             |
| created_at | timestamp   |             |
| updated_at | timestamp   |             |
| is_deleted | boolean     | 1:削除済     |

###### タスク(Tasks)
| カラム名 | データ型 | 備考 |
|:-----------|:------------|:------------|
| ID         | Primary     | 主キー       |
| name       | string(50)  |             |
| description| string(2000)|             |
| priority   | ENUM        | high:高、middle：中、low：低          |
| status     | ENUM        | created：未着手、doing：着手、done：完了|
| started_on | date        |             |
| ended_on   | date        |             |
| created_at | timestamp   |             |
| updated_at | timestamp   |             |

###### ラベルマスタ(Mst_Label)
| カラム名 | データ型 | 備考 |
|:-----------|:------------|:------------|
| ID         | Primary     | 主キー       |
| name       | string(20)  |             |
| is_deleted | boolean     | 1:削除済     |

###### （中間テーブル）タスクラベル(Task_Label)
| カラム名 | データ型 | 備考 |
|:-----------|:------------|:------------|
| ID         | Primary     | 主キー       |
| task_id    | integer     | 外部キー     |
| label_id   | integer     | 外部キー     |
