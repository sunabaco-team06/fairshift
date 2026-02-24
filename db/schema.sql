PRAGMA foreign_keys = ON;

-- =========================
-- DROP（作り直し用）
-- =========================
DROP TABLE IF EXISTS reassignments;
DROP TABLE IF EXISTS user_ng_staff;
DROP TABLE IF EXISTS staff_unavailable;
DROP TABLE IF EXISTS visits;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS area_edges;
DROP TABLE IF EXISTS areas;

-- =========================
-- areas（エリア）
-- =========================
CREATE TABLE areas (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE
);

-- area_edges（隣接関係）
CREATE TABLE area_edges (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  area_id INTEGER NOT NULL,
  neighbor_area_id INTEGER NOT NULL,
  cost INTEGER NOT NULL DEFAULT 1,
  FOREIGN KEY (area_id) REFERENCES areas(id) ON DELETE CASCADE,
  FOREIGN KEY (neighbor_area_id) REFERENCES areas(id) ON DELETE CASCADE,
  CHECK (area_id <> neighbor_area_id),
  UNIQUE (area_id, neighbor_area_id)
);

-- staff（スタッフ）
CREATE TABLE staff (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  gender TEXT NOT NULL CHECK (gender IN ('F','M','O')),
  role TEXT NOT NULL CHECK (role IN ('nurse','pt','ot')),
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- users（利用者）
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  area_id INTEGER NOT NULL,
  gender_preference TEXT NOT NULL CHECK (gender_preference IN ('any','female_only','male_only')),
  role_required TEXT NOT NULL CHECK (role_required IN ('any','nurse_only','pt_only','ot_only')),
  priority TEXT NOT NULL CHECK (priority IN ('today_required','tomorrow_ok','week_ok')),
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (area_id) REFERENCES areas(id)
);

-- visits（訪問予定）
CREATE TABLE visits (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  staff_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  visit_date TEXT NOT NULL,
  visit_time TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'planned' CHECK (status IN ('planned','reassigned')),
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (staff_id) REFERENCES staff(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  UNIQUE (staff_id, visit_date, visit_time)
);

-- staff_unavailable
CREATE TABLE staff_unavailable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  staff_id INTEGER NOT NULL,
  date TEXT NOT NULL,
  time TEXT NOT NULL,
  reason TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (staff_id) REFERENCES staff(id),
  UNIQUE (staff_id, date, time)
);

-- user_ng_staff
CREATE TABLE user_ng_staff (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  staff_id INTEGER NOT NULL,
  reason TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (staff_id) REFERENCES staff(id) ON DELETE CASCADE,
  UNIQUE (user_id, staff_id)
);

-- reassignments（振替履歴）
CREATE TABLE reassignments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  original_visit_id INTEGER NOT NULL,
  new_visit_id INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active','canceled')),
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (original_visit_id) REFERENCES visits(id) ON DELETE CASCADE,
  FOREIGN KEY (new_visit_id) REFERENCES visits(id) ON DELETE CASCADE,
  UNIQUE (original_visit_id, new_visit_id)
);