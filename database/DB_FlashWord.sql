USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name='Flashcard_B3')
BEGIN
	-- Close existing connection before drop
	ALTER DATABASE Flashcard_B3 SET single_user WITH rollback immediate
	-- Drop existing database 
	DROP DATABASE Flashcard_B3
END
GO
CREATE DATABASE Flashcard_B3
GO
USE Flashcard_B3
GO


-- Create Tables

CREATE TABLE Users
(
  user_id INT IDENTITY(1,1) NOT NULL,
  email NVARCHAR(50) UNIQUE NOT NULL,
  name NVARCHAR(50) NOT NULL,
  password NVARCHAR(50) NOT NULL,
  avatar NVARCHAR(400),
  created_at DATETIME2 NOT NULL,
  PRIMARY KEY (user_id)
);

CREATE TABLE Decks
(
  deck_id INT IDENTITY(1,1) NOT NULL,
  name NVARCHAR(40) NOT NULL,
  description NVARCHAR(200),
  private INT NOT NULL,
  created_at DATETIME2 NOT NULL,
  updated_at DATETIME2 NOT NULL,
  owner_id INT,
  PRIMARY KEY (deck_id),
  FOREIGN KEY (owner_id) REFERENCES Users(user_id) ON DELETE SET NULL
);

-- If Deck get deleted then Cards' records will also be deleted
CREATE TABLE Cards
(
  card_id INT IDENTITY(1,1) NOT NULL,
  front NVARCHAR(100) NOT NULL,
  back NVARCHAR(100) NOT NULL,
  tags NVARCHAR(200),
  deck_id INT NOT NULL,
  PRIMARY KEY (card_id),
  FOREIGN KEY (deck_id) REFERENCES Decks(deck_id) ON DELETE CASCADE
);

CREATE TABLE Admins
(
  admin_id INT IDENTITY(1,1) NOT NULL,
  email NVARCHAR(50) UNIQUE NOT NULL,
  name NVARCHAR(50) NOT NULL,
  password NVARCHAR(50) NOT NULL,
  PRIMARY KEY (admin_id)
);

-- Column user_read only have 2 values: UNREAD, READ
CREATE TABLE DeckShares
(
  dshare_id INT IDENTITY(1,1) NOT NULL,
  user_read NVARCHAR(10) NOT NULL,
  date_shared DATETIME2 NOT NULL,
  user_id INT,
  deck_id INT NOT NULL,
  PRIMARY KEY (dshare_id),
  FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL,
  FOREIGN KEY (deck_id) REFERENCES Decks(deck_id) ON DELETE CASCADE
);

CREATE TABLE DeckHistories
(
  deck_his_id INT IDENTITY(1,1) NOT NULL,
  date DATE NOT NULL,
  latest_update DATETIME2 NOT NULL,
  study_count INT NOT NULL,
  deck_id INT,
  user_id INT,
  PRIMARY KEY (deck_his_id),
  FOREIGN KEY (deck_id) REFERENCES Decks(deck_id) ON DELETE SET NULL,
  FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL
);

-- Column status only have 3 values: PENDING, RESOLVED, CLOSED
-- Column user_read only have 2 values: UNREAD, READ
CREATE TABLE SupportTickets
(
  ticket_id INT IDENTITY(1,1) NOT NULL,
  message NVARCHAR(400) NOT NULL,
  sender_email NVARCHAR(50) NOT NULL,
  sender_name NVARCHAR(50) NOT NULL,
  created_at DATETIME2 NOT NULL,
  status NVARCHAR(10) NOT NULL,
  response_mes NVARCHAR(400),
  responsed_at DATETIME2,
  user_read NVARCHAR(10) NOT NULL,
  user_id INT ,
  admin_id INT, 
  PRIMARY KEY (ticket_id),
  FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (admin_id) REFERENCES Admins(admin_id) ON DELETE SET NULL
);

insert into Users(email, name, password, avatar, created_at) values ('user1@gmail.com', 'Gherardo Tarplee', '123456', 'https://api.dicebear.com/5.x/adventurer/svg?seed=user1', '12/22/2022');
insert into Users (email, name, password, avatar, created_at) values ('user2@gmail.com', 'Betti Noice', '123456', 'https://api.dicebear.com/5.x/adventurer/svg?seed=user2', '9/21/2022');
insert into Users (email, name, password, avatar, created_at) values ('user3@gmail.com', 'Celka Cussins', '123456', 'https://api.dicebear.com/5.x/adventurer/svg?seed=user3', '2/3/2023');
insert into Users (email, name, password, avatar, created_at) values ('user4@gmail.com', 'Elvis Redmain', '123456', 'https://api.dicebear.com/5.x/adventurer/svg?seed=user4', '5/31/2022');
insert into Users (email, name, password, avatar, created_at) values ('user43@gmail.com', 'Olag Riolfo', '123456', 'https://api.dicebear.com/5.x/adventurer/svg?seed=user5', '11/9/2022');
insert into Users (email, name, password, avatar, created_at) values ('user23@gmail.com', 'Nathanial Farrens', '123456', 'https://api.dicebear.com/5.x/adventurer/svg?seed=user6', '12/22/2022');
insert into Users (email, name, password, avatar, created_at) values ('user87@gmail.com', 'Carlene Vakhonin', '123456', 'https://api.dicebear.com/5.x/adventurer/svg?seed=user7', '12/12/2022');
insert into Users (email, name, password, avatar, created_at) values ('user67@gmail.com', 'Enid Golightly', '123456', 'https://api.dicebear.com/5.x/adventurer/svg?seed=user8', '3/23/2022');
insert into Users (email, name, password, avatar, created_at) values ('user54@gmail.com', 'Stacey Murthwaite', '123456', 'https://api.dicebear.com/5.x/adventurer/svg?seed=user9', '3/23/2022');
insert into Users (email, name, password, avatar, created_at) values ('user14@gmail.com', 'Tedda Blitzer', '123456', 'https://api.dicebear.com/5.x/adventurer/svg?seed=user10', '3/23/2022');

insert into Decks (name, description, private , created_at, updated_at, owner_id) values ('Tok Pisin', 'Pathological fracture, left tibia, subs for fx w malunion', '0', '12/22/2022', '1/13/2023', 1);
insert into Decks (name, description, private , created_at, updated_at, owner_id) values ('Malay', 'Jump/div into swimming pool strk wall causing drown, subs', '0', '9/21/2022', '9/21/2022', 2);
insert into Decks (name, description, private , created_at, updated_at, owner_id) values ('Tajik', 'Unsp injury of left external jugular vein, subs encntr', '0', '2/3/2023', '2/3/2023', 3);
insert into Decks (name, description, private , created_at, updated_at, owner_id) values ('Romanian', 'Pedestrian on foot injured in collision w pedl cyc in traf', '0', '5/31/2022', '5/31/2022', 4);
insert into Decks (name, description, private , created_at, updated_at, owner_id) values ('Dzongkha', 'Maternal care for face, brow and chin presentation, fetus 4', '1', '11/9/2022', '11/9/2022', 5);
insert into Decks (name, description, private , created_at, updated_at, owner_id) values ('Tswana', 'Persons encountering health services in oth circumstances', '0', '1/13/2023', '1/13/2023', 6);
insert into Decks (name, description, private , created_at, updated_at, owner_id) values ('Aymara', 'Insect bite (nonvenomous) of unspecified hand, subs encntr', '1', '12/12/2022', '12/12/2022', 7);
insert into Decks (name, description, private , created_at, updated_at, owner_id) values ('Afrikaans', 'Oth disp fx of lower end of left humerus, init for clos fx', '0', '3/23/2022', '3/23/2022', 8);
insert into Decks (name, description, private , created_at, updated_at, owner_id) values ('Northern Sotho', 'Disp fx of body of hamate bone, l wrs, 7thG', '1', '3/23/2022', '3/23/2022', 9);
insert into Decks (name, description, private , created_at, updated_at, owner_id) values ('Kashmiri', 'Injury of median nerve at wrs/hnd lv of left arm, sequela', '0', '3/24/2022', '3/24/2022', 10);
INSERT [dbo].[Decks] ([name], [description], [private], [created_at], [updated_at], [owner_id]) VALUES (N'JPD', N'Hết thứ 5 là khỏe rồi. Cố lên.', 0, '12/25/2022', '12/25/2022', 1)

insert into Cards (front , back, tags, deck_id) values ('Focused', 'Face to face directional artificial intelligence', 'benchmark scalable platforms', 1);
insert into Cards (front , back, tags, deck_id) values ('Realigned', 'Inverse fault-tolerant emulation', 'streamline wireless portals', 1);
insert into Cards (front , back, tags, deck_id) values ('Multi-tiered', 'Reverse-engineered systematic project', 'drive clicks-and-mortar users', 1);
insert into Cards (front , back, tags, deck_id) values ('Reactive', 'Re-engineered zero administration hierarchy', 'optimize transparent systems', 1);
insert into Cards (front , back, tags, deck_id) values ('Persevering', 'Fully-configurable holistic access', 'exploit innovative paradigms', 1);
insert into Cards (front , back, tags, deck_id) values ('Advanced', 'Vision-oriented foreground info-mediaries', 'seize visionary supply-chains', 2);
insert into Cards (front , back, tags, deck_id) values ('Secured', 'Profound fresh-thinking intranet', 'reintermediate real-time ROI', 5);
insert into Cards (front , back, tags, deck_id) values ('Enhanced', 'Configurable human-resource frame', 'redefine plug-and-play applications', 5);
insert into Cards (front , back, tags, deck_id) values ('system engine', 'Operative upward-trending benchmark', 'deploy interactive infrastructures', 5);
insert into Cards (front , back, tags, deck_id) values ('success', 'Synchronised full-range database', 'maximize wireless niches', 2);
insert into Cards (front , back, tags, deck_id) values ('Advanced', 'Profound full-range toolset', 'exploit B2C interfaces', 2);
insert into Cards (front , back, tags, deck_id) values ('Reverse-engineered', 'Networked scalable hardware', 'monetize holistic paradigms', 2);
insert into Cards (front , back, tags, deck_id) values ('Integrated', 'Progressive transitional help-desk', 'implement scalable paradigms', 3);
insert into Cards (front , back, tags, deck_id) values ('human-resource', 'Inverse transitional capability', 'mesh web-enabled metrics', 4);
insert into Cards (front , back, tags, deck_id) values ('Innovative', 'Mandatory global help-desk', 'extend customized e-business', 5);
insert into Cards (front , back, tags, deck_id) values ('standardization', 'Operative demand-driven secured line', 'expedite out-of-the-box experiences', 4);
insert into Cards (front , back, tags, deck_id) values ('alliance', 'Enhanced interactive encryption', 'synthesize mission-critical architectures', 3);
insert into Cards (front , back, tags, deck_id) values ('Reduced', 'Synergistic optimal ability', 'syndicate global metrics', 5);
insert into Cards (front , back, tags, deck_id) values ('zero tolerance', 'Total human-resource adapter', 'incubate extensible systems', 1);
insert into Cards (front , back, tags, deck_id) values ('Ameliorated', 'Function-based client-driven open system', 'visualize proactive platforms', 2);
insert into Cards (front , back, tags, deck_id) values ('groupware', 'Triple-buffered bandwidth-monitored project', 'unleash B2B deliverables', 1);
insert into Cards (front , back, tags, deck_id) values ('regional', 'Cross-group heuristic parallelism', 'benchmark synergistic convergence', 2);
insert into Cards (front , back, tags, deck_id) values ('attitude-oriented', 'Team-oriented real-time customer loyalty', 'scale wireless metrics', 3);
insert into Cards (front , back, tags, deck_id) values ('Fundamental', 'Universal real-time task-force', 'integrate open-source e-tailers', 2);
insert into Cards (front , back, tags, deck_id) values ('data-warehouse', 'Implemented client-server workforce', 'seize global e-business', 2);

insert into Admins (email, name, password) values ('admin1@gmail.com', 'Kerr Taile', '123456');
insert into Admins (email, name, password) values ('admin12@gmail.com', 'Maurizia Hawk', '123456');
insert into Admins (email, name, password) values ('admin13@gmail.com', 'Torin Corp', '123456');
insert into Admins (email, name, password) values ('admin14@gmail.com', 'Charmian Frounks', '123456');
insert into Admins (email, name, password) values ('admin15@gmail.com', 'Angelique Kornacki', '123456');
insert into Admins (email, name, password) values ('admin16@gmail.com', 'Vernen Hurne', '123456');
insert into Admins (email, name, password) values ('admin17@gmail.com', 'Ralph Spira', '123456');
insert into Admins (email, name, password) values ('admin18@gmail.com', 'Iain Plowes', '123456');
insert into Admins (email, name, password) values ('admin19@gmail.com', 'Nichols Galletley', '123456');
insert into Admins (email, name, password) values ('admin11@gmail.com', 'Shaylynn Massy', '123456');

insert into DeckShares(user_read, user_id, deck_id, date_shared) VALUES ('READ', 2, 1, '7/29/2022');
insert into DeckShares(user_read, user_id, deck_id, date_shared) VALUES ('UNREAD', 3, 1, '3/20/2022');
insert into DeckShares(user_read, user_id, deck_id, date_shared) VALUES ('UNREAD', 5, 2, '3/20/2022');
insert into DeckShares(user_read, user_id, deck_id, date_shared) VALUES ('READ', 4, 2, '3/20/2022');
insert into DeckShares(user_read, user_id, deck_id, date_shared) VALUES ('UNREAD', 5, 3, '3/20/2022');
insert into DeckShares(user_read, user_id, deck_id, date_shared) VALUES ('READ', 5, 2, '3/20/2022');
insert into DeckShares(user_read, user_id, deck_id, date_shared) VALUES ('UNREAD', 2, 4, '3/20/2022');
insert into DeckShares(user_read, user_id, deck_id, date_shared) VALUES ('READ', 6, 2, '3/20/2022');
insert into DeckShares(user_read, user_id, deck_id, date_shared) VALUES ('UNREAD', 4, 5, '3/20/2022');
insert into DeckShares(user_read, user_id, deck_id, date_shared) VALUES ('READ', 6, 7, '3/20/2022');
insert into DeckShares(user_read, user_id, deck_id, date_shared) VALUES ('READ', 8, 6, '3/20/2022');
insert into DeckShares(user_read, user_id, deck_id, date_shared) VALUES ('UNREAD', 2, 6, '3/20/2022');
insert into DeckShares(user_read, user_id, deck_id, date_shared) VALUES ('READ', 1, 7, '3/20/2022');

insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('12/22/2022', 4, 1, 1, '12/22/2022');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('12/27/2022', 8, 1, 1, '12/27/2022');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('1/5/2023', 1, 1, 1, '1/5/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('1/20/2023', 4, 1, 1, '1/20/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('3/20/2023', 3, 1, 1, '3/20/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('9/21/2022', 4, 2, 2, '9/21/2022');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('12/27/2022', 8, 2, 2, '12/27/2022');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('1/5/2023', 1, 2, 2, '1/5/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('1/20/2023', 4, 2, 2, '1/20/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('3/20/2023', 3, 11, 2, '3/20/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('2/3/2023', 4, 3, 3, '2/3/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('2/12/2023', 8, 3, 3, '2/12/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/5/2023', 1, 11, 3, '4/5/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/20/2023', 4, 3, 3, '4/20/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/23/2023', 3, 11, 3, '4/23/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('5/31/2022', 5, 4, 4, '5/31/2022');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('2/12/2023', 8, 4, 4, '2/12/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/5/2023', 7, 11, 4, '4/5/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/20/2023', 4, 4, 4, '4/20/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/23/2023', 3, 11, 4, '4/23/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('11/9/2022', 5, 5, 5, '11/9/2022');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('2/12/2023', 8, 5, 5, '2/12/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/5/2023', 7, 11, 5, '4/5/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/20/2023', 4, 5, 5, '4/20/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/23/2023', 3, 11, 5, '4/23/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('1/13/2023', 10, 6, 6, '1/13/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('2/12/2023', 8, 6, 6, '2/12/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/5/2023', 7, 11, 6, '4/5/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/20/2023', 4, 6, 6, '4/20/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/23/2023', 3, 11, 6, '4/23/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('12/12/2022', 3, 7, 7, '12/12/2022');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('2/12/2023', 8, 7, 7, '2/12/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/5/2023', 7, 11, 7, '4/5/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/20/2023', 4, 7, 7, '4/20/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/23/2023', 3, 11, 7, '4/23/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('3/23/2022', 3, 8, 8, '3/23/2022');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('2/12/2023', 2, 8, 8, '2/12/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/5/2023', 7, 11, 8, '4/5/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/20/2023', 4, 8, 8, '4/20/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/23/2023', 3, 11, 8, '4/23/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('3/23/2022', 1, 9, 9, '3/23/2022');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('2/12/2023', 2, 9, 9, '2/12/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/5/2023', 7, 11, 9, '4/5/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/20/2023', 4, 9, 9, '4/20/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/23/2023', 3, 11, 9, '4/23/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('3/23/2022', 1, 10, 10, '3/23/2022');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('2/12/2023', 2, 10, 10, '2/12/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/5/2023', 7, 11, 10, '4/5/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/20/2023', 4, 10, 10, '4/20/2023');
insert into DeckHistories (date, study_count, deck_id, user_id, latest_update) values ('4/23/2023', 3, 11, 10, '4/23/2023');

insert into SupportTickets (message, sender_email, sender_name, created_at, Status, response_mes, responsed_at, user_read, user_id, admin_id) values ('Customizable reciprocal time-frame', 'jnewlove0@naver.com', 'Newlove', '12/26/2022', 'PENDING', null, null, 'READ', null, null);
insert into SupportTickets (message, sender_email, sender_name, created_at, Status, response_mes, responsed_at, user_read, user_id, admin_id) values ('User-friendly high-level encoding', 'fbielfelt1@sbwire.com', 'Bielfelt', '4/9/2022', 'RESOLVED', null, null,'UNREAD', null, null);
insert into SupportTickets (message, sender_email, sender_name, created_at, Status, response_mes, responsed_at, user_read, user_id, admin_id) values ('Persevering static middleware', 'ehorlick2@noaa.gov', 'Horlick', '6/17/2022', 'CLOSED', null, null,'READ', null, null);
insert into SupportTickets (message, sender_email, sender_name, created_at, Status, response_mes, responsed_at, user_read, user_id, admin_id) values ('Cloned asymmetric encoding', 'ttesimon3@microsoft.com', 'Tesimon', '12/27/2022', 'CLOSED', null, null, 'UNREAD', null, null);
insert into SupportTickets (message, sender_email, sender_name, created_at, Status, response_mes, responsed_at, user_read, user_id, admin_id) values ('Fundamental zero administration support', 'singall4@last.fm', 'Ingall', '6/20/2022', 'RESOLVED', null, null,'READ', null, null);
insert into SupportTickets (message, sender_email, sender_name, created_at, Status, response_mes, responsed_at, user_read, user_id, admin_id) values ('Ameliorated multi-tasking model', 'tshouler5@quantcast.com', 'Shouler', '3/26/2022','RESOLVED', null, null, 'READ', null, null);
insert into SupportTickets (message, sender_email, sender_name, created_at, Status, response_mes, responsed_at, user_read, user_id, admin_id) values ('Virtual 6th generation analyzer', 'ktichelaar6@posterous.com', 'Tichelaar', '2/12/2023', 'RESOLVED', null, null,'READ', null, null);
insert into SupportTickets (message, sender_email, sender_name, created_at, Status, response_mes, responsed_at, user_read, user_id, admin_id) values ('Integrated optimizing synergy', 'cdummett7@java.com', 'Dummett', '11/29/2022', 'CLOSED', 'PENDING', null, 'UNREAD', null, null);
insert into SupportTickets (message, sender_email, sender_name, created_at, Status, response_mes, responsed_at, user_read, user_id, admin_id) values ('Re-engineered intangible capability', 'lmorrall8@prnewswire.com', 'Morrall', '8/24/2022', 'CLOSED', null, null,'READ', null, null);
insert into SupportTickets (message, sender_email, sender_name, created_at, Status, response_mes, responsed_at, user_read, user_id, admin_id) values ('Cloned asynchronous focus group', 'ktwinning9@va.gov', 'Twinning', '8/18/2022','PENDING', null, null, 'UNREAD', null, null);

INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'くるま', N'Xe hơi', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'しんかんせん', N'Bullet train', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'でんしゃ', N'Xe lửa', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ひこうき', N'Máy bay', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'えき', N'Nhà ga', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'やま', N'Núi', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'まち', N'Thị trấn / Thành phố', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'かわ', N'Sông', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ひがし', N'Hướng đông', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'にし', N'Hướng tây', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'みなみ', N'Hướng nam', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'きた', N'Hướng bắc', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'まんなか', N'Chính giữa, miên trung', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'名前', N'Tên', N'kanji', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'前', N'Tiền (trước)', N'kanji', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'東京', N'Đông kinh (tokyo)', N'kanji', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'おんせん', N'Suối nước nóng', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'きょうかい', N'Nhà thờ', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'しろ', N'Lâu đài', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'じんじゃ', N'Đền', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'てら', N'Chùa', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ビル', N'Tòa nhà', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ひ', N'Ánh mặt trời', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'あめ', N'Mưa', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ゆき', N'Tuyết', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'てんき', N'Thời tiết', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'かばん', N'Cặp (bag)', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'メロン', N'Dưa lưới', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'きせつ', N'Mùa (season)', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'しゅうまつ', N'Lễ hội mùa hè', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'どこも', N'Anywhere', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'いえ', N'Căn nhà', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'へや', N'Phòng', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'デパート', N'Cửa hàng bách hóa', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'びじゅつかん', N'Triễn lãm / bảo tàng', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'かぞく', N'Gia đình', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'こいびと', N'Người yêu', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ともだち', N'Bạn bè', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ゲーム', N'Game', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ルームメイト', N'Roommate', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'きょう', N'Hôm nay', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'あした', N'Ngày mai', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'きのう', N'Hôm qua', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'あさって', N'Ngày mốt', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'おととい', N'Hôm kia', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'らいしゅう', N'Tuần sau', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'せんしゅう', N'Tuần trước', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'きょねん', N'Năm ngoái', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'らいねん', N'Năm sau', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ことし', N'Năm nay', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'せんげつ', N'Tháng trước', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'らいげつ', N'Tháng sau', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'けさ', N'Sáng nay', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'こんや ', N'Tối hôm nay', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'きのうばん ', N'Tối hôm qua', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'むかし', N'Thời xưa, ngày xưa', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'しゅうまつ　「週末」', N'Weekend (SAT, SUN)', N'kanji', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'かぜです。/ かぜをひきます', N'Cảm lạnh', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ふく ', N'Quần áo', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'アニメ', N'Hoạt hình nhật bản', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'え', N'Tranh ảnh', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'けしき', N'Phong cảnh', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'じてんしゃ', N'Xe đạp', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'しゃしん', N'Bức hình', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'(お)かね', N'Tiền', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ひとり', N'Một mình', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'どの くらい かかりますか。', N'Mất bao lâu', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'たくさん', N'Nhiều, một số lượng lớn', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'それから', N'Và sau đó', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'カラオケ', N'Karaoke', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'コンサート', N'Concert (buổi hòa nhạc)', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'しあい', N'Trận đấu, thi đấu', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'セール', N'Giảm giá (sale)', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'チケット', N'Ticket (vé)', N'', 11)
GO
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ちず', N'Bản đồ', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ドライブ', N'Lái xe', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'みずぎ', N'Đồ bơi', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'やきゅう', N'Bóng chày', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'やくそく', N'Hứa hẹn (promise)', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'たべもの', N'Đồ ăn', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'のみもの', N'Đồ uống', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'のりもの', N'Phương tiện giao thông', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'やきにく', N'Thịt nướng', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ラーメン', N'Mì nhật', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'たべほうだい', N'Buffet', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'いざかや', N'Quán rượu', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'えいがかん', N'Rạp chiếu phim', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ちかてつ', N'Tàu điện ngầm', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'かしゅ', N'Ca sĩ', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'はる', N'Mùa xuân', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'なつ', N'Mùa hạ', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'あき', N'Mùa thu', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ふゆ', N'Mùa đông', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'コメデイー', N'Hài kịch (comedy)', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ジャズ', N'Nhạc jazz', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ツアー', N'Tour', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'おこのみやき', N'Bánh xèo nhật', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'すきやき', N'Lẩu', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'かいさつ', N'Cổng soát vé', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'き', N'Cây', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'こうばん', N'Đồn cảnh sát', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'じどうはんばいき', N'Máy bán tự động', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'バスてい', N'Trạm xe bus', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ポスト', N'Hộp thư/thùng thư', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'はな', N'Hoa', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'いぬ', N'Chó', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'うえ', N'Phía trên', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'した', N'Phía dưới', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'うしろ', N'Phía sau', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'まえ', N'Phía trước', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'なか', N'Bên trong', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'そと', N'Bên ngoài', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'となり', N'Bên cạnh', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'あいだ', N'Ở giữa', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ちかく', N'Ở gần', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ひだり', N'Bên trái', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'みぎ', N'Bên phải', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'いす', N'Ghế', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'テーブル', N'Bàn', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'でんしレンジ', N'Máy hâm đồ ăn', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'れいぞうこ', N'Tủ lạnh', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'さとう', N'Đường (sugar)', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'しお', N'Muối', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'しょうゆ', N'Xì dầu (nước tương)', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'コップ', N'Cup, ly', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'（お）さら', N'Dĩa', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'はし', N'Đũa', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'フォーク', N'Nĩa (fork)', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ナイフ', N'Dao', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'スプーン', N'Muỗng (spoon)', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'て', N'Bóc tay', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'だいどころ', N'Nhà bếp', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ピザ', N'Bánh pizza', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'うた', N'Bài hát', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'たばこ', N'Thuốc lá', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ギター', N'Ghi-ta', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ピアノ', N'Piano', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'まど', N'Cửa sổ', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'でんわ', N'Điện thoại', N'', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'あたらしい', N'Mới (new)', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ふるい ', N'Cũ (old)', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'いい　（よい）', N'Tốt (good)', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'わるい', N'Tệ, xấu', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ひとがおおい', N'Nhiều người', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ひとがすくない', N'Ít người', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'おおきい', N'Lớn (big)', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ちいさい', N'Nhỏ (small)', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'たかい', N'Cao / expensive', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'やすい', N'Rẻ', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ひくい', N'Thấp', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'きれい', N'Đẹp', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'しずか', N'Tĩnh lặng', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'にぎやか', N'Náo nhiệt', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ゆうめい', N'Nổi tiếng / có danh', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'くもり', N'Nhiều mây', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'あたたかい', N'Ấm', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'すずしい', N'Mát (cool)', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'あつい', N'Nóng / đồ ăn nóng', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'さむい', N'Lạnh', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'つめたい', N'Đồ ăn lạnh', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'おいしい', N'Ngon', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'まずい', N'Dỡ, không ngon', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'あまい', N'Ngọt', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'からい', N'Cay', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'すっぱい', N'Chua', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'にがい', N'Đắng', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'てんきがいい', N'Thời tiết đẹp', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'てんきがわるい', N'Thời tiết xấu', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'いそがしい', N'Bận rộn', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ひま', N'Rãnh rỗi', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'おもしろい', N'Thú vị', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'つまらない', N'Boring', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'きもちがいい', N'Thoải mái', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'きもちがわるい', N'Không thoải mái', N'adj', 11)
GO
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'たのしい', N'Vui vẻ', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'むずかしい', N'Khó; khó tính; khó chịu', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'やさしい', N'Dễ; dễ tính', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ほしい | たい', N'Muốn sở hữu ~ ', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'すき', N'Thích', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'きらい', N'Ghét ', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'とおい', N'Xa', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ちかい', N'Gần', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'ひろい', N'Rộng', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'せまい', N'Hẹp', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'はやい', N'Sớm/nhanh', N'adj', 11)
INSERT [dbo].[Cards] ([front], [back], [tags], [deck_id]) VALUES (N'おそい', N'Muộn', N'adj', 11)

go