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

INSERT INTO "staff" VALUES(1,'一野','F','pt','2026-02-19 10:51:37');
INSERT INTO "staff" VALUES(2,'二村','M','pt','2026-02-19 10:51:37');
INSERT INTO "staff" VALUES(3,'三見','M','ot','2026-02-19 10:51:37');
INSERT INTO "staff" VALUES(4,'四賀','M','pt','2026-02-19 10:51:37');
INSERT INTO "staff" VALUES(5,'五松','F','ot','2026-02-20 10:50:29');
INSERT INTO "staff" VALUES(6,'六井','F','pt','2026-02-20 10:50:29');
INSERT INTO "staff" VALUES(7,'七川','M','pt','2026-02-20 10:50:29');

INSERT INTO staff_unavailable(staff_id,date,time,reason)
VALUES
(1,'2026-03-06','09:00','meeting'),
(2,'2026-03-06','09:00','meeting'),
(3,'2026-03-06','09:00','meeting'),
(4,'2026-03-06','09:00','meeting'),
(5,'2026-03-06','09:00','meeting'),
(6,'2026-03-06','09:00','meeting'),
(7,'2026-03-06','09:00','meeting'),
(1,'2026-03-04','15:00','meeting'),
(1,'2026-03-04','16:00','meeting'),
(4,'2026-03-04','09:00','meeting'),
(5,'2026-03-04','09:00','meeting');

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
INSERT INTO "users" VALUES(101,'田口101',1,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(102,'中西102',1,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(103,'山口103',1,'female_only','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(104,'川上104',1,'male_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(105,'今井105',2,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(106,'小池106',2,'female_only','pt_only','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(107,'関107',2,'male_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(108,'藤本108',2,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(109,'北村109',3,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(110,'河野110',3,'female_only','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(111,'田辺111',3,'male_only','ot_only','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(112,'久米112',3,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(113,'奥田113',4,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(114,'高野114',4,'female_only','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(115,'西田115',4,'male_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(116,'浜田116',4,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(117,'土屋117',5,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(118,'坂井118',5,'female_only','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(119,'安田119',5,'male_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(120,'松崎120',5,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(121,'永井121',6,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(122,'栗原122',6,'female_only','pt_only','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(123,'黒木123',6,'male_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(124,'宮川124',6,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(125,'白石125',7,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(126,'石黒126',7,'female_only','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(127,'岡崎127',7,'male_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(128,'水野128',7,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(129,'服部129',8,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(130,'小坂130',8,'female_only','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(131,'青山131',8,'male_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(132,'大石132',8,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(133,'杉本133',9,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(134,'成田134',9,'female_only','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(135,'津田135',9,'male_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(136,'野沢136',9,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(137,'内藤137',10,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(138,'平山138',10,'female_only','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(139,'松浦139',10,'male_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(140,'古賀140',10,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(141,'武田141',11,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(142,'溝口142',11,'female_only','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(143,'竹田143',11,'male_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(144,'秋山144',11,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(145,'神谷145',12,'any','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(146,'堤146',12,'female_only','any','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(147,'浜崎147',12,'male_only','any','today_required','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(148,'小山148',12,'any','any','tomorrow_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(149,'浅田149',12,'female_only','pt_only','week_ok','2026-02-20 12:40:54');
INSERT INTO "users" VALUES(150,'横尾150',12,'male_only','any','today_required','2026-02-20 12:40:54');

INSERT INTO user_ng_staff(user_id,staff_id,reason)
VALUES
(69,1,'ng'),
(15,2,'ng'),
(55,3,'ng'),
(68,4,'ng'),
(87,5,'ng'),
(119,6,'ng'),
(79,7,'ng');

-- 一野（4件）
INSERT INTO visits (staff_id,user_id,visit_date,visit_time) VALUES (1,12,'2026-03-02','10:00');
INSERT INTO visits (staff_id,user_id,visit_date,visit_time) VALUES (1,25,'2026-03-02','11:00');
INSERT INTO visits (staff_id,user_id,visit_date,visit_time) VALUES (1,1,'2026-03-02','15:00');
INSERT INTO visits (staff_id,user_id,visit_date,visit_time) VALUES (1,22,'2026-03-02','16:00');

-- 二村（7件）
INSERT INTO visits VALUES (NULL,2,63,'2026-03-02','09:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,64,'2026-03-02','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,65,'2026-03-02','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,79,'2026-03-02','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,10,'2026-03-02','15:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,80,'2026-03-02','16:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,113,'2026-03-02','17:00','planned',datetime('now'));

-- 三見（6件）
INSERT INTO visits VALUES (NULL,3,17,'2026-03-02','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,18,'2026-03-02','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,29,'2026-03-02','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,30,'2026-03-02','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,31,'2026-03-02','15:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,32,'2026-03-02','16:00','planned',datetime('now'));

-- 四賀（6件）
INSERT INTO visits VALUES (NULL,4,39,'2026-03-02','09:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,40,'2026-03-02','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,41,'2026-03-02','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,42,'2026-03-02','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,43,'2026-03-02','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,44,'2026-03-02','16:00','planned',datetime('now'));

-- 五松（6件）
INSERT INTO visits VALUES (NULL,5,50,'2026-03-02','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,51,'2026-03-02','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,52,'2026-03-02','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,150,'2026-03-02','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,54,'2026-03-02','15:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,55,'2026-03-02','17:00','planned',datetime('now'));

-- 六井（6件）
INSERT INTO visits VALUES (NULL,6,67,'2026-03-02','09:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,68,'2026-03-02','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,69,'2026-03-02','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,70,'2026-03-02','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,71,'2026-03-02','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,72,'2026-03-02','15:00','planned',datetime('now'));

-- 七川（5件）
INSERT INTO visits VALUES (NULL,7,83,'2026-03-02','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,84,'2026-03-02','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,85,'2026-03-02','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,86,'2026-03-02','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,87,'2026-03-02','16:00','planned',datetime('now'));

-- 一野（5件）
INSERT INTO visits (staff_id,user_id,visit_date,visit_time) VALUES (1,118,'2026-03-03','10:00');
INSERT INTO visits (staff_id,user_id,visit_date,visit_time) VALUES (1,132,'2026-03-03','11:00');
INSERT INTO visits (staff_id,user_id,visit_date,visit_time) VALUES (1,147,'2026-03-03','13:00');
INSERT INTO visits (staff_id,user_id,visit_date,visit_time) VALUES (1,23,'2026-03-03','14:00');
INSERT INTO visits (staff_id,user_id,visit_date,visit_time) VALUES (1,76,'2026-03-03','15:00');

-- 二村（6件）
INSERT INTO visits VALUES (NULL,2,119,'2026-03-03','09:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,120,'2026-03-03','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,121,'2026-03-03','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,24,'2026-03-03','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,6,'2026-03-03','15:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,26,'2026-03-03','16:00','planned',datetime('now'));

-- 三見（6件）
INSERT INTO visits VALUES (NULL,3,140,'2026-03-03','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,141,'2026-03-03','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,33,'2026-03-03','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,34,'2026-03-03','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,35,'2026-03-03','15:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,36,'2026-03-03','16:00','planned',datetime('now'));

-- 四賀（6件）
INSERT INTO visits VALUES (NULL,4,52,'2026-03-03','09:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,53,'2026-03-03','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,54,'2026-03-03','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,55,'2026-03-03','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,56,'2026-03-03','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,57,'2026-03-03','16:00','planned',datetime('now'));

-- 五松（6件）
INSERT INTO visits VALUES (NULL,5,68,'2026-03-03','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,69,'2026-03-03','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,70,'2026-03-03','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,71,'2026-03-03','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,7,'2026-03-03','16:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,73,'2026-03-03','17:00','planned',datetime('now'));

-- 六井（6件）
INSERT INTO visits VALUES (NULL,6,81,'2026-03-03','09:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,82,'2026-03-03','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,83,'2026-03-03','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,2,'2026-03-03','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,107,'2026-03-03','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,9,'2026-03-03','16:00','planned',datetime('now'));

-- 七川（6件）
INSERT INTO visits VALUES (NULL,7,90,'2026-03-03','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,91,'2026-03-03','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,92,'2026-03-03','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,93,'2026-03-03','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,94,'2026-03-03','16:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,11,'2026-03-03','17:00','planned',datetime('now'));

-- 一野（4件）
INSERT INTO visits VALUES (NULL,1,117,'2026-03-04','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,1,140,'2026-03-04','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,1,142,'2026-03-04','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,1,30,'2026-03-04','14:00','planned',datetime('now'));

-- 二村（6件）
INSERT INTO visits VALUES (NULL,2,111,'2026-03-04','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,143,'2026-03-04','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,44,'2026-03-04','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,45,'2026-03-04','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,46,'2026-03-04','15:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,47,'2026-03-04','16:00','planned',datetime('now'));

-- 三見（6件）
INSERT INTO visits VALUES (NULL,3,20,'2026-03-04','09:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,16,'2026-03-04','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,48,'2026-03-04','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,49,'2026-03-04','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,50,'2026-03-04','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,8,'2026-03-04','16:00','planned',datetime('now'));

-- 四賀（6件）
INSERT INTO visits VALUES (NULL,4,21,'2026-03-04','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,144,'2026-03-04','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,60,'2026-03-04','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,61,'2026-03-04','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,62,'2026-03-04','15:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,63,'2026-03-04','17:00','planned',datetime('now'));

-- 五松（6件）
INSERT INTO visits VALUES (NULL,5,4,'2026-03-04','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,145,'2026-03-04','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,74,'2026-03-04','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,75,'2026-03-04','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,76,'2026-03-04','15:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,77,'2026-03-04','16:00','planned',datetime('now'));

-- 六井（5件）
INSERT INTO visits VALUES (NULL,6,122,'2026-03-04','09:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,146,'2026-03-04','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,86,'2026-03-04','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,87,'2026-03-04','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,88,'2026-03-04','14:00','planned',datetime('now'));

-- 七川（6件）
INSERT INTO visits VALUES (NULL,7,123,'2026-03-04','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,147,'2026-03-04','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,95,'2026-03-04','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,96,'2026-03-04','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,97,'2026-03-04','15:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,98,'2026-03-04','16:00','planned',datetime('now'));

-- 一野（5件）
INSERT INTO visits VALUES (NULL,1,119,'2026-03-05','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,1,134,'2026-03-05','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,1,148,'2026-03-05','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,1,31,'2026-03-05','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,1,78,'2026-03-05','15:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,1,135,'2026-03-05','17:00','planned',datetime('now'));

-- 二村（6件）
INSERT INTO visits VALUES (NULL,2,118,'2026-03-05','09:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,120,'2026-03-05','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,90,'2026-03-05','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,32,'2026-03-05','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,33,'2026-03-05','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,13,'2026-03-05','15:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,34,'2026-03-05','16:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,58,'2026-03-05','17:00','planned',datetime('now'));

-- 三見（6件）
INSERT INTO visits VALUES (NULL,3,15,'2026-03-05','09:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,121,'2026-03-05','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,138,'2026-03-05','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,35,'2026-03-05','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,36,'2026-03-05','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,37,'2026-03-05','15:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,38,'2026-03-05','17:00','planned',datetime('now'));

-- 四賀（6件）
INSERT INTO visits VALUES (NULL,4,110,'2026-03-05','09:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,124,'2026-03-05','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,109,'2026-03-05','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,64,'2026-03-05','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,65,'2026-03-05','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,66,'2026-03-05','15:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,67,'2026-03-05','16:00','planned',datetime('now'));

-- 五松（6件）
INSERT INTO visits VALUES (NULL,5,126,'2026-03-05','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,127,'2026-03-05','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,79,'2026-03-05','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,80,'2026-03-05','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,81,'2026-03-05','15:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,82,'2026-03-05','16:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,14,'2026-03-05','17:00','planned',datetime('now'));

-- 六井（5件）
INSERT INTO visits VALUES (NULL,6,128,'2026-03-05','09:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,129,'2026-03-05','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,19,'2026-03-05','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,84,'2026-03-05','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,85,'2026-03-05','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,138,'2026-03-05','15:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,114,'2026-03-05','16:00','planned',datetime('now'));

-- 七川（5件）
INSERT INTO visits VALUES (NULL,7,27,'2026-03-05','09:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,130,'2026-03-05','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,131,'2026-03-05','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,99,'2026-03-05','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,100,'2026-03-05','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,149,'2026-03-05','15:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,101,'2026-03-05','16:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,137,'2026-03-05','17:00','planned',datetime('now'));

-- 一野（5件）
INSERT INTO visits VALUES (NULL,1,119,'2026-03-06','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,1,140,'2026-03-06','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,1,145,'2026-03-06','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,1,41,'2026-03-06','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,1,102,'2026-03-06','15:00','planned',datetime('now'));

-- 二村（6件）
INSERT INTO visits VALUES (NULL,2,141,'2026-03-06','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,42,'2026-03-06','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,43,'2026-03-06','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,115,'2026-03-06','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,53,'2026-03-06','16:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,2,133,'2026-03-06','17:00','planned',datetime('now'));

-- 三見（6件）
INSERT INTO visits VALUES (NULL,3,121,'2026-03-06','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,142,'2026-03-06','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,54,'2026-03-06','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,55,'2026-03-06','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,56,'2026-03-06','15:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,3,57,'2026-03-06','17:00','planned',datetime('now'));

-- 四賀（6件）
INSERT INTO visits VALUES (NULL,4,122,'2026-03-06','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,143,'2026-03-06','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,68,'2026-03-06','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,69,'2026-03-06','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,70,'2026-03-06','15:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,4,71,'2026-03-06','16:00','planned',datetime('now'));

-- 五松（6件）
INSERT INTO visits VALUES (NULL,5,123,'2026-03-06','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,144,'2026-03-06','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,83,'2026-03-06','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,84,'2026-03-06','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,3,'2026-03-06','15:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,5,86,'2026-03-06','16:00','planned',datetime('now'));

-- 六井（5件）
INSERT INTO visits VALUES (NULL,6,146,'2026-03-06','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,87,'2026-03-06','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,88,'2026-03-06','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,89,'2026-03-06','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,6,5,'2026-03-06','16:00','planned',datetime('now'));

-- 七川（6件）
INSERT INTO visits VALUES (NULL,7,125,'2026-03-06','10:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,147,'2026-03-06','11:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,103,'2026-03-06','13:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,104,'2026-03-06','14:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,105,'2026-03-06','15:00','planned',datetime('now'));
INSERT INTO visits VALUES (NULL,7,106,'2026-03-06','16:00','planned',datetime('now'));

CREATE UNIQUE INDEX idx_visit_unique 
ON visits(staff_id, visit_date, visit_time);
