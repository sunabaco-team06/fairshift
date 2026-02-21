
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
INSERT INTO "area_edges" VALUES(331,1,3,1);
INSERT INTO "area_edges" VALUES(332,1,6,1);
INSERT INTO "area_edges" VALUES(333,1,10,1);
INSERT INTO "area_edges" VALUES(334,1,4,1);
INSERT INTO "area_edges" VALUES(335,1,12,1);
INSERT INTO "area_edges" VALUES(336,1,9,1);
INSERT INTO "area_edges" VALUES(337,1,2,1);
INSERT INTO "area_edges" VALUES(338,2,11,1);
INSERT INTO "area_edges" VALUES(339,2,3,1);
INSERT INTO "area_edges" VALUES(340,2,1,1);
INSERT INTO "area_edges" VALUES(341,2,9,1);
INSERT INTO "area_edges" VALUES(342,2,8,1);
INSERT INTO "area_edges" VALUES(343,3,6,1);
INSERT INTO "area_edges" VALUES(344,3,1,1);
INSERT INTO "area_edges" VALUES(345,3,2,1);
INSERT INTO "area_edges" VALUES(346,3,11,1);
INSERT INTO "area_edges" VALUES(347,4,10,1);
INSERT INTO "area_edges" VALUES(348,4,1,1);
INSERT INTO "area_edges" VALUES(349,5,8,1);
INSERT INTO "area_edges" VALUES(350,5,9,1);
INSERT INTO "area_edges" VALUES(351,5,12,1);
INSERT INTO "area_edges" VALUES(352,5,7,1);
INSERT INTO "area_edges" VALUES(353,6,10,1);
INSERT INTO "area_edges" VALUES(354,6,1,1);
INSERT INTO "area_edges" VALUES(355,6,3,1);
INSERT INTO "area_edges" VALUES(356,7,12,1);
INSERT INTO "area_edges" VALUES(357,7,5,1);
INSERT INTO "area_edges" VALUES(358,8,11,1);
INSERT INTO "area_edges" VALUES(359,8,2,1);
INSERT INTO "area_edges" VALUES(360,8,9,1);
INSERT INTO "area_edges" VALUES(361,8,5,1);
INSERT INTO "area_edges" VALUES(362,9,2,1);
INSERT INTO "area_edges" VALUES(363,9,1,1);
INSERT INTO "area_edges" VALUES(364,9,12,1);
INSERT INTO "area_edges" VALUES(365,9,5,1);
INSERT INTO "area_edges" VALUES(366,9,8,1);
INSERT INTO "area_edges" VALUES(367,10,4,1);
INSERT INTO "area_edges" VALUES(368,10,1,1);
INSERT INTO "area_edges" VALUES(369,10,6,1);
INSERT INTO "area_edges" VALUES(370,11,3,1);
INSERT INTO "area_edges" VALUES(371,11,2,1);
INSERT INTO "area_edges" VALUES(372,11,8,1);
INSERT INTO "area_edges" VALUES(373,12,1,1);
INSERT INTO "area_edges" VALUES(374,12,7,1);
INSERT INTO "area_edges" VALUES(375,12,5,1);
INSERT INTO "area_edges" VALUES(376,12,9,1);
CREATE TABLE areas (

  id INTEGER PRIMARY KEY AUTOINCREMENT,

  name TEXT NOT NULL UNIQUE

);
INSERT INTO "areas" VALUES(1,'第一');
INSERT INTO "areas" VALUES(2,'第二');
INSERT INTO "areas" VALUES(3,'第三');
INSERT INTO "areas" VALUES(4,'第四');
INSERT INTO "areas" VALUES(5,'第五');
INSERT INTO "areas" VALUES(6,'第六');
INSERT INTO "areas" VALUES(7,'第七');
INSERT INTO "areas" VALUES(8,'第八');
INSERT INTO "areas" VALUES(9,'第九');
INSERT INTO "areas" VALUES(10,'第十');
INSERT INTO "areas" VALUES(11,'友呂岐');
INSERT INTO "areas" VALUES(12,'中木田');
CREATE TABLE staff (

  id INTEGER PRIMARY KEY AUTOINCREMENT,

  name TEXT NOT NULL UNIQUE,

  gender TEXT NOT NULL CHECK (gender IN ('F','M','O')),

  role TEXT NOT NULL CHECK (role IN ('nurse','pt','ot')),

  created_at TEXT NOT NULL DEFAULT (datetime('now'))

);
INSERT INTO "staff" VALUES(1,'一野','F','pt','2026-02-19 10:51:37');
INSERT INTO "staff" VALUES(2,'二村','M','pt','2026-02-19 10:51:37');
INSERT INTO "staff" VALUES(3,'三見','M','ot','2026-02-19 10:51:37');
INSERT INTO "staff" VALUES(4,'四賀','M','pt','2026-02-19 10:51:37');
INSERT INTO "staff" VALUES(5,'五松','F','ot','2026-02-20 10:50:29');
CREATE TABLE staff_unavailable (

  id INTEGER PRIMARY KEY AUTOINCREMENT,

  staff_id INTEGER NOT NULL,

  date TEXT NOT NULL,               -- 'YYYY-MM-DD'

  time TEXT NOT NULL,               -- '09:00'

  reason TEXT,

  created_at TEXT NOT NULL DEFAULT (datetime('now')),

  FOREIGN KEY (staff_id) REFERENCES staff(id),

  UNIQUE (staff_id, date, time)

);
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
INSERT INTO "users" VALUES(1,'山田1',1,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(2,'佐藤2',1,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(3,'鈴木3',1,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(4,'高橋4',1,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(5,'伊藤5',1,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(6,'渡辺6',1,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(7,'中村7',1,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(8,'小林8',1,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(9,'加藤9',1,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(10,'吉田10',1,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(11,'山本11',1,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(12,'松本12',1,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(13,'井上13',1,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(14,'木村14',1,'female_only','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(15,'林15',1,'female_only','pt_only','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(16,'清水16',1,'male_only','ot_only','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(17,'森17',2,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(18,'池田18',2,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(19,'橋本19',2,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(20,'阿部20',2,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(21,'石川21',2,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(22,'山下22',2,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(23,'中島23',2,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(24,'前田24',2,'any','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(25,'藤田25',2,'female_only','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(26,'小川26',2,'female_only','pt_only','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(27,'岡田27',2,'male_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(28,'後藤28',3,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(29,'長谷川29',3,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(30,'村上30',3,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(31,'近藤31',3,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(32,'石井32',3,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(33,'坂本33',3,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(34,'遠藤34',3,'any','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(35,'青木35',3,'any','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(36,'藤井36',3,'female_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(37,'西村37',3,'female_only','ot_only','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(38,'福田38',3,'male_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(39,'太田39',4,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(40,'三浦40',4,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(41,'藤原41',4,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(42,'岡本42',4,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(43,'松田43',4,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(44,'中野44',4,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(45,'原45',4,'any','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(46,'小野46',4,'any','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(47,'田村47',4,'female_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(48,'竹内48',4,'female_only','pt_only','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(49,'金子49',4,'male_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(50,'和田50',5,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(51,'中川51',5,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(52,'石田52',5,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(53,'上田53',5,'any','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(54,'森田54',5,'female_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(55,'原田55',5,'female_only','ot_only','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(56,'酒井56',5,'male_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(57,'工藤57',6,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(58,'横山58',6,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(59,'宮崎59',6,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(60,'内田60',6,'any','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(61,'高木61',6,'female_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(62,'安藤62',6,'male_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(63,'島田63',7,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(64,'柴田64',7,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(65,'桜井65',7,'female_only','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(66,'大野66',7,'male_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(67,'久保67',8,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(68,'野口68',8,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(69,'松井69',8,'any','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(70,'菅原70',8,'female_only','pt_only','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(71,'佐々木71',8,'male_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(72,'新井72',9,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(73,'岩崎73',9,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(74,'宮本74',9,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(75,'谷口75',9,'any','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(76,'大西76',9,'female_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(77,'黒田77',9,'female_only','ot_only','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(78,'野村78',9,'male_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(79,'松尾79',10,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(80,'菊池80',10,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(81,'市川81',10,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(82,'古川82',10,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(83,'大塚83',10,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(84,'平野84',10,'any','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(85,'小島85',10,'any','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(86,'岩田86',10,'female_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(87,'中田87',10,'female_only','pt_only','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(88,'川口88',10,'male_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(89,'堀89',10,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(90,'石橋90',11,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(91,'浅野91',11,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(92,'片山92',11,'any','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(93,'吉岡93',11,'female_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(94,'本間94',11,'female_only','ot_only','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(95,'村田95',11,'male_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(96,'杉山96',11,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(97,'平田97',12,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(98,'荒木98',12,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(99,'大島99',12,'female_only','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(100,'川崎100',12,'male_only','any','today_required','2026-02-20 12:40:54');
CREATE TABLE visits (

  id INTEGER PRIMARY KEY AUTOINCREMENT,

  staff_id INTEGER NOT NULL,

  user_id INTEGER NOT NULL,

  visit_date TEXT NOT NULL,         -- 'YYYY-MM-DD'

  visit_time TEXT NOT NULL,         -- '09:00' 形式

  status TEXT NOT NULL DEFAULT 'planned' CHECK (status IN ('planned','reassigned')),

  created_at TEXT NOT NULL DEFAULT (datetime('now')),

  FOREIGN KEY (staff_id) REFERENCES staff(id),

  FOREIGN KEY (user_id) REFERENCES users(id),

  UNIQUE (staff_id, visit_date, visit_time)  -- 同一スタッフの同時間帯は1件に制限（MVP向け）

);
DELETE FROM "sqlite_sequence";
INSERT INTO "sqlite_sequence" VALUES('areas',12);
INSERT INTO "sqlite_sequence" VALUES('area_edges',376);
INSERT INTO "sqlite_sequence" VALUES('staff',5);
INSERT INTO "sqlite_sequence" VALUES('user_ng_staff',1);
INSERT INTO "sqlite_sequence" VALUES('users',100);

