# README
This is a project for training.

## テーブルスキーマ（モデル名・カラム名・データ型）
###### ユーザー(Users)
| カラム名 | データ型 | 備考 |
|:-----------|:------------|:------------|
| ID         | Primary       | 主キー     |
| mail       | VARCHAR(255)  |           |
| password   | VARCHAR(255)  |           |
| name       | VARCHAR(255)  |           |
| created_at | timestamp     |           |
| updated_at | timestamp     |           |
| is_deleted | boolean       | 1：削除済  |

###### タスク(Tasks)
| カラム名 | データ型 | 備考 |
|:-----------|:------------|:------------|
| ID         | Primary     | 主キー       |
| name       | VARCHAR(255)|             |
| description| text        |             |
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
| name       | VARCHAR(255)|             |
| is_deleted | boolean     | 1:削除済     |

###### （中間テーブル）タスクラベル(Task_Label)
| カラム名 | データ型 | 備考 |
|:-----------|:------------|:------------|
| ID         | Primary     | 主キー       |
| task_id    | integer     | 外部キー     |
| label_id   | integer     | 外部キー     |
