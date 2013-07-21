#--
#-- tariff_plan/tariff_plan_log
#--
DROP TABLE IF EXISTS tariff_plan_log;
DROP TABLE IF EXISTS tariff_plan CASCADE;

CREATE TABLE tariff_plan (
  id serial NOT NULL PRIMARY KEY,

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  name varchar(255) not null NOT NULL unique,

  date_begin date NOT NULL,
  date_end date
);

CREATE TABLE tariff_plan_log (
  id integer NOT NULL,
  tariff_plan_id integer NOT NULL REFERENCES tariff_plan(id) ON DELETE CASCADE,

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  name varchar(255) not null NOT NULL,

  date_begin date NOT NULL,
  date_end date,
  PRIMARY KEY(id,date_change)
);

--
-- tariff_day/tariff_day_log
--
DROP TABLE IF EXISTS tariff_day_log;
DROP TABLE IF EXISTS tariff_day CASCADE;

CREATE TABLE tariff_day (
  id integer NOT NULL PRIMARY KEY,
  tariff_plan_id integer NOT NULL REFERENCES tariff_plan(id) ON DELETE CASCADE,

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  mon boolean,
  tue boolean,
  wed boolean,
  thu boolean,
  fri boolean,
  dat boolean,
  sun boolean
);

CREATE TABLE tariff_day_log (
  id integer NOT NULL,
  tariff_day_id integer NOT NULL REFERENCES tariff_day(id) ON DELETE CASCADE,

  tariff_plan_id integer NOT NULL REFERENCES tariff_plan(id) ON DELETE CASCADE,

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  mon boolean,
  tue boolean,
  wed boolean,
  thu boolean,
  fri boolean,
  dat boolean,
  sun boolean,
  PRIMARY KEY(id,date_change)
);

--
-- tariff_time/tariff_time_log
--
DROP TABLE IF EXISTS tariff_time_log;
DROP TABLE IF EXISTS tariff_time CASCADE;

CREATE TABLE tariff_time (
  id serial NOT NULL primary key,
  tariff_day_id integer NOT NULL REFERENCES tariff_day(id) ON DELETE CASCADE,

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  time_begin time NOT NULL,
  time_end time
);

CREATE TABLE tariff_time_log (
  id integer NOT NULL ,

  tariff_day_id integer NOT NULL REFERENCES tariff_day(id) ON DELETE CASCADE,

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  time_begin time NOT NULL,
  time_end time,
  PRIMARY KEY(id,date_change)
);

--
-- Currency
--
DROP TABLE IF EXISTS currency_rate;
DROP TABLE IF EXISTS currency CASCADE;

CREATE TABLE currency (
  id serial NOT NULL PRIMARY KEY,
  name varchar(255) not null,
  short_name varchar(30) not null UNIQUE
);

INSERT INTO currency (id,name,short_name) VALUES (1,'Ukrainian hryvna','UAH');
INSERT INTO currency (id,name,short_name) VALUES (2,'American dollar','USD');
INSERT INTO currency (id,name,short_name) VALUES (3,'Euro','EUR');

CREATE TABLE currency_rate (
  id serial NOT NULL PRIMARY KEY,

  curr_id1 integer NOT NULL REFERENCES currency(id),
  curr_id2 integer NOT NULL REFERENCES currency(id),

  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  updated date NOT NULL,
  rate double(10,2) NOT NULL, -- 10.5

  CHECK (curr_id1 <> curr_id2)
);

--
-- tariff/tariff_log/tariff_type
--
DROP TABLE IF EXISTS tariff_log;
DROP TABLE IF EXISTS tariff;
DROP TABLE IF EXISTS tariff_type;

CREATE TABLE tariff_type (
  id serial NOT NULL PRIMARY KEY,

  name varchar(255) not null,
  short_name char(128) NOT NULL UNIQUE
);

INSERT INTO tariff_type (id,name,short_name) VALUES (1,'per second','per_second');
INSERT INTO tariff_type (id,name,short_name) VALUES (2,'per minute tarification','per_minute');
INSERT INTO tariff_type (id,name,short_name) VALUES (3,'per hour tarification','per_hour');

CREATE TABLE tariff (
  id serial NOT NULL PRIMARY KEY,

  tariff_type_id integer NOT NULL REFERENCES tariff_type(id) ON DELETE CASCADE,
  tariff_time_id integer NOT NULL REFERENCES tariff_time(id) ON DELETE CASCADE,

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  curr_id integer NOT NULL REFERENCES currency(id),

  amount double(10,2) NOT NULL -- 10.2
);

--
-- Accounts
--
DROP TABLE IF EXISTS accounts CASCADE;
DROP TABLE IF EXISTS accounts_log;

CREATE TABLE accounts (
  id serial NOT NULL PRIMARY KEY,

  client_id integer NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
  curr_id integer NOT NULL REFERENCES currency(id),

  balance double(10,2) NOT NULL DEFAULT 0, -- 10.2
  amount_reserv double(10,2) NOT NULL DEFAULT 0, -- 10.2
  amount_trust double(10,2) NOT NULL DEFAULT 0 -- 10.2
);

-- TODO: .obj_id
--
CREATE TABLE accounts_log (

  account_id integer NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,

  service_type_id integer NOT NULL REFERENCES service_type(id),
  obj_id integer NOT NULL, -- основание для снятия

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  amount double(10,2) NOT NULL, -- 10.2 сумма проводки
  balance double(10,2) NOT NULL, -- 10.2 остаток на счете
  PRIMARY KEY(account_id,date_change)

);

