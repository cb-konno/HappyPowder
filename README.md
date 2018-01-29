# README
This is a project for training.

## テーブルスキーマ（モデル名・カラム名・データ型）
###### ユーザー(Users)
| カラム名 | データ型 | 備考 |
|:-----------|:------------|:------------|
| ID       | Primary       |主キー|
| mail       | VARCHAR(255)       ||
| password       | VARCHAR(255)       ||
| name       | VARCHAR(255)       ||
| ins_date       | timestamp      ||
| up_date       | timestamp      ||
| is_deleted       | boolean      | 1：削除済|

###### タスク(Tasks)
| カラム名 | データ型 | 備考 |
|:-----------|:------------|:------------|
| ID       | Primary       |主キー|
| name       | VARCHAR(255)       ||
| description       | text       ||
| priority       | ENUM | 高:high、中：middle、低：low |
| status       | ENUM       | 未着手：created、着手：doing、完了：done|
| start_date       | timestamp      ||
| end_date       | timestamp      ||
| ins_date       | timestamp      ||
| up_date       | timestamp      ||

###### ラベルマスタ(Mst_Label)
| カラム名 | データ型 | 備考 |
|:-----------|:------------|:------------|
| ID       | Primary       |主キー|
| name       | VARCHAR(255)       ||
| is_deleted       | boolean      | 1:削除済|

######（中間テーブル）タスクラベル(Task_Label)
| カラム名 | データ型 | 備考 |
|:-----------|:------------|:------------|
| ID       | Primary       |主キー|
| task_id       | integer       |外部キー|
| label_id       | integer       |外部キー|
