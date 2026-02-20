# Routes（MVP）

## GET /
- テンプレ：templates/index.html
- 概要：トップ画面

## GET /staff
- テンプレ：templates/staff.html
- 概要：スタッフ一覧（DB表示）

## GET /absent（Day2）
- テンプレ：templates/absent.html
- 概要：欠勤スタッフ選択

## GET /visits（Day2）
- テンプレ：templates/visits.html
- 必須パラメータ：
  - staff_id: int
  - date: YYYY-MM-DD
- 例：
  /visits?staff_id=1&date=2026-03-02

## GET /result（Day3）
- テンプレ：templates/result.html
- 概要：候補上位3名＋理由
