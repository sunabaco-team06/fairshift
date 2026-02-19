# FairShift UI Rules (MVP)

## 目的
急な欠勤時に、欠勤スタッフの訪問予定を確認し、振替候補（上位3名）を提示する。

## 画面遷移（固定）
/ (トップ)
  ↓
/absent (欠勤スタッフ選択)
  ↓
/visits (欠勤スタッフの当日訪問一覧)
  ↓
/result (振替候補 上位3名＋理由)

## ルート（URL）命名（固定）
- /            : トップ（開始ボタン）
- /absent      : 欠勤スタッフ選択フォーム
- /visits      : 訪問一覧（GETで staff_id と date を受け取る）
- /result      : 候補表示（Day3で実装）

## テンプレート命名（固定）
- templates/index.html
- templates/absent.html
- templates/visits.html
- templates/result.html

## /visits のGETパラメータ（固定）
- staff_id : 欠勤スタッフID（必須）
- date     : 対象日 YYYY-MM-DD（必須）

例：
/visits?staff_id=1&date=2026-03-02

## 表示項目（MVP必須）
- absent.html
  - 欠勤スタッフ（ラジオ or セレクト）
  - 日付（date input）
  - 送信ボタン（/visits に遷移）

- visits.html
  - 欠勤スタッフ名
  - 日付
  - 訪問一覧：時間 / 利用者名 / エリア名

- result.html（Day3）
  - 候補上位3名
  - 合計点
  - 理由（例：空きあり、NGなし、エリア◎○△ など）
