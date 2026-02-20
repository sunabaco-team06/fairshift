PRAGMA foreign_keys = ON;

-- =========================
-- サンプルデータ投入
-- =========================

-- エリア
INSERT INTO areas (name) VALUES
  ('第一'), ('第二'), ('第三'), ('第四'), ('第五');

-- 隣接
INSERT INTO area_edges (area_id, neighbor_area_id) VALUES
  (1,2), (2,1),
  (2,3), (3,2),
  (3,4), (4,3),
  (2,5), (5,2);

-- スタッフ
INSERT INTO staff (name, gender, role) VALUES
  ('A', 'F', 'nurse'),
  ('B', 'M', 'pt'),
  ('C', 'F', 'ot'),
  ('D', 'M', 'nurse');

-- 利用者
INSERT INTO users (name, area_id, gender_preference, role_required, priority) VALUES
  ('ア', 1, 'any',        'any',       'today_required'),
  ('イ', 2, 'female_only','any',       'today_required'),
  ('ウ', 1, 'any',        'pt_only',   'tomorrow_ok'),
  ('エ', 3, 'any',        'nurse_only','week_ok'),
  ('オ', 4, 'male_only',  'any',       'today_required');

-- 訪問予定
INSERT INTO visits (staff_id, user_id, visit_date, visit_time) VALUES
  (1, 1, '2026-03-02', '09:00'),
  (1, 2, '2026-03-02', '10:00'),
  (1, 3, '2026-03-02', '11:00'),
  (2, 4, '2026-03-02', '10:00'),
  (3, 5, '2026-03-02', '11:00');

-- スタッフ対応不可
INSERT INTO staff_unavailable (staff_id, date, time, reason) VALUES
  (2, '2026-03-02', '11:00', '私用'),
  (4, '2026-03-02', '10:00', '会議');

-- NG関係
INSERT INTO user_ng_staff (user_id, staff_id, reason) VALUES
  (2, 4, '相性');
