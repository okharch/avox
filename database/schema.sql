--
-- Data domains
--
DROP DOMAIN IF EXISTS login_t CASCADE;
CREATE DOMAIN login_t AS char(32) NOT NULL CHECK (VALUE <> '');

--
-- Users
--

DROP TABLE IF EXISTS clerks_log;
DROP TABLE IF EXISTS clerks CASCADE;
DROP TABLE IF EXISTS clerk_type;
DROP TABLE IF EXISTS clerk_status;

CREATE TABLE clerk_type (
  id serial NOT NULL PRIMARY KEY,

  name char(256),
  short_name char(128) NOT NULL UNIQUE
);

INSERT INTO clerk_type (id,name,short_name) VALUES (1,'система','система');
INSERT INTO clerk_type (id,name,short_name) VALUES (2,'администратор','администратор');
INSERT INTO clerk_type (id,name,short_name) VALUES (3,'кассир','кассир');
INSERT INTO clerk_type (id,name,short_name) VALUES (4,'прокат','прокат');

CREATE TABLE clerk_status (
  id serial NOT NULL PRIMARY KEY,

  name char(256),
  short_name char(128) NOT NULL UNIQUE
);

INSERT INTO clerk_status (id,name,short_name) VALUES (1,'введен','введен');
INSERT INTO clerk_status (id,name,short_name) VALUES (2,'активный','активный');
INSERT INTO clerk_status (id,name,short_name) VALUES (3,'заблокирован','заблокирован');
INSERT INTO clerk_status (id,name,short_name) VALUES (4,'закрыт','закрыт');

CREATE TABLE clerks (
  id serial NOT NULL PRIMARY KEY,

  clerk_type_id integer NOT NULL REFERENCES clerk_type(id),
  clerk_status_id integer NOT NULL REFERENCES clerk_status(id),

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  name char(128), -- ?
  first_name char(128),
  last_name char(128),
  phones char(128),
  mails char(64),
  address char(128),

--  login char(32) NOT NULL UNIQUE,
  login login_t UNIQUE,
  passwd char(32) NOT NULL
);

CREATE TABLE clerks_log (
  id serial NOT NULL PRIMARY KEY,
  clerk_id integer NOT NULL REFERENCES clerks(id) ON DELETE CASCADE,

  clerk_type_id integer NOT NULL REFERENCES clerk_type(id),
  clerk_status_id integer NOT NULL REFERENCES clerk_status(id),

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  name char(128), -- ?
  first_name char(128),
  last_name char(128),
  phones char(128),
  mails char(64),
  address char(128),

--  login char(32) NOT NULL,
  login login_t, -- !UNIQUE
  passwd char(32) NOT NULL
);

--
-- Clients
--
DROP TABLE IF EXISTS clients_log;
DROP TABLE IF EXISTS clients CASCADE;
DROP TABLE IF EXISTS client_type;
DROP TABLE IF EXISTS client_status;

CREATE TABLE client_type (
  id serial NOT NULL PRIMARY KEY,

  name char(256),
  short_name char(128) NOT NULL UNIQUE
);

INSERT INTO client_type (id,name,short_name) VALUES (1,'карточка','карточка');
INSERT INTO client_type (id,name,short_name) VALUES (2,'сотрудник','сотрудник');
INSERT INTO client_type (id,name,short_name) VALUES (3,'инструктор','инструктор');
INSERT INTO client_type (id,name,short_name) VALUES (4,'клиент','клиент');

CREATE TABLE client_status (
  id serial NOT NULL PRIMARY KEY,

  name char(256),
  short_name char(128) NOT NULL UNIQUE
);

INSERT INTO client_status (id,name,short_name) VALUES (1,'введен','введен');
INSERT INTO client_status (id,name,short_name) VALUES (2,'активный','активный');
INSERT INTO client_status (id,name,short_name) VALUES (3,'заблокирован','заблокирован');
INSERT INTO client_status (id,name,short_name) VALUES (4,'закрыт','закрыт');

CREATE TABLE clients (
  id serial NOT NULL PRIMARY KEY,

  client_type_id integer NOT NULL REFERENCES client_type(id),
  client_status_id integer NOT NULL REFERENCES client_status(id),

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  name char(128),
  phones char(128),
  mails char(64),
  address char(128),

  login char(32) NOT NULL UNIQUE,
  passwd char(32) NOT NULL,

  date_begin date NOT NULL DEFAULT current_date,
  date_end date
);

CREATE TABLE clients_log (
  id serial NOT NULL PRIMARY KEY,
  client_id integer NOT NULL REFERENCES clients(id) ON DELETE CASCADE,

  client_type_id integer NOT NULL REFERENCES client_type(id),
  client_status_id integer NOT NULL REFERENCES client_status(id),

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  name char(128),
  phones char(128),
  mails char(64),
  address char(128),

  login char(32),
  passwd char(32)
);

--
-- services/services_log/service_type/service_status
--
DROP TABLE IF EXISTS services_log;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS service_type CASCADE;
DROP TABLE IF EXISTS service_status;

CREATE TABLE service_type (
  id serial NOT NULL PRIMARY KEY,

  name char(256),
  short_name char(128) NOT NULL UNIQUE
);

INSERT INTO service_type (id,name,short_name) VALUES (1,'абонплата','абонплата');
INSERT INTO service_type (id,name,short_name) VALUES (2,'on line','on line');
INSERT INTO service_type (id,name,short_name) VALUES (3,'off line','off line');
INSERT INTO service_type (id,name,short_name) VALUES (4,'без тарификации','шара');

CREATE TABLE service_status (
  id serial NOT NULL PRIMARY KEY,

  name char(256),
  short_name char(128) NOT NULL UNIQUE
);

INSERT INTO service_status (id,name,short_name) VALUES (1,'введена','введена');
INSERT INTO service_status (id,name,short_name) VALUES (2,'активна','активна');
INSERT INTO service_status (id,name,short_name) VALUES (3,'заблокирована','заблокирована');
INSERT INTO service_status (id,name,short_name) VALUES (4,'закрыта','закрыта');

CREATE TABLE services (
  id serial NOT NULL PRIMARY KEY,

  service_type_id integer NOT NULL REFERENCES service_type(id),
  service_status_id integer NOT NULL REFERENCES service_status(id),

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  name char(128) NOT NULL,

  date_begin date NOT NULL DEFAULT current_date,
  date_end date,

  discount money -- 2.2 %%
);

CREATE TABLE services_log (
  id serial NOT NULL PRIMARY KEY,
  service_id integer NOT NULL REFERENCES services(id),

  service_type_id integer NOT NULL REFERENCES service_type(id),
  service_status_id integer NOT NULL REFERENCES service_status(id),

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  name char(128) NOT NULL,

  date_begin date NOT NULL DEFAULT current_date,
  date_end date,

  discount money -- 2.2 %%
);

--
-- tariff_plan/tariff_plan_log
--
DROP TABLE IF EXISTS tariff_plan_log;
DROP TABLE IF EXISTS tariff_plan CASCADE;

CREATE TABLE tariff_plan (
  id serial NOT NULL PRIMARY KEY,

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  name char(128) NOT NULL,

  date_begin date NOT NULL,
  date_end date
);

CREATE TABLE tariff_plan_log (
  id serial NOT NULL PRIMARY KEY,
  tariff_plan_id integer NOT NULL REFERENCES tariff_plan(id) ON DELETE CASCADE,

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  name char(128) NOT NULL,

  date_begin date NOT NULL DEFAULT current_date,
  date_end date
);

--
-- tariff_day/tariff_day_log
--
DROP TABLE IF EXISTS tariff_day_log;
DROP TABLE IF EXISTS tariff_day CASCADE;

CREATE TABLE tariff_day (
  id serial NOT NULL PRIMARY KEY,
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
  id serial NOT NULL PRIMARY KEY,
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
  sun boolean
);

--
-- tariff_time/tariff_time_log
--
DROP TABLE IF EXISTS tariff_time_log;
DROP TABLE IF EXISTS tariff_time CASCADE;

CREATE TABLE tariff_time (
  id serial NOT NULL PRIMARY KEY,
  tariff_day_id integer NOT NULL REFERENCES tariff_day(id) ON DELETE CASCADE,

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  time_begin time NOT NULL,
  time_end time
);

CREATE TABLE tariff_time_log (
  id serial NOT NULL PRIMARY KEY,
  tariff_time_id integer NOT NULL REFERENCES tariff_time(id) ON DELETE CASCADE,

  tariff_day_id integer NOT NULL REFERENCES tariff_day(id) ON DELETE CASCADE,

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  time_begin time NOT NULL,
  time_end time
);

--
-- Currency
--
DROP TABLE IF EXISTS currency_rate;
DROP TABLE IF EXISTS currency_type CASCADE;

CREATE TABLE currency_type (
  id serial NOT NULL PRIMARY KEY,

  name char(256),
  short_name char(128) NOT NULL UNIQUE
);

INSERT INTO currency_type (id,name,short_name) VALUES (1,'Украинская гривна','UAH');
INSERT INTO currency_type (id,name,short_name) VALUES (2,'Американский доллар','USD');
INSERT INTO currency_type (id,name,short_name) VALUES (3,'Евро','EUR');

CREATE TABLE currency_rate (
  id serial NOT NULL PRIMARY KEY,

  curr_id1 integer NOT NULL REFERENCES currency_type(id),
  curr_id2 integer NOT NULL REFERENCES currency_type(id),

  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  updated date NOT NULL DEFAULT current_date,
  rate money NOT NULL, -- 10.5

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

  name char(256),
  short_name char(128) NOT NULL UNIQUE
);

INSERT INTO tariff_type (id,name,short_name) VALUES (1,'посекундная тарификация','секунда');
INSERT INTO tariff_type (id,name,short_name) VALUES (2,'поминутная тарификация','минута');
INSERT INTO tariff_type (id,name,short_name) VALUES (3,'почасовая тарификация','час');

CREATE TABLE tariff (
  id serial NOT NULL PRIMARY KEY,

  tariff_type_id integer NOT NULL REFERENCES tariff_type(id) ON DELETE CASCADE,
  tariff_time_id integer NOT NULL REFERENCES tariff_time(id) ON DELETE CASCADE,

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  curr_id integer NOT NULL REFERENCES currency_type(id),

  amount money NOT NULL -- 10.2
);

--
-- services_tariff/services_tariff_log
--
DROP TABLE IF EXISTS services_tariff_log;
DROP TABLE IF EXISTS services_tariff;

CREATE TABLE services_tariff (
  id serial NOT NULL PRIMARY KEY,

  service_type_id integer NOT NULL REFERENCES service_type(id),
  tariff_plan_id integer NOT NULL REFERENCES tariff_plan(id),

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  name char(128) NOT NULL,

  date_begin date NOT NULL DEFAULT current_date,
  date_end date
);

CREATE TABLE services_tariff_log (
  id serial NOT NULL PRIMARY KEY,
  services_tariff_id integer NOT NULL REFERENCES services_tariff(id) ON DELETE CASCADE,

  service_type_id integer NOT NULL REFERENCES service_type(id),
  tariff_plan_id integer NOT NULL REFERENCES tariff_plan(id),

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  name char(128) NOT NULL,

  date_begin date NOT NULL DEFAULT current_date,
  date_end date
);

--
-- Accounts
--
DROP TABLE IF EXISTS accounts CASCADE;
DROP TABLE IF EXISTS accounts_log;

CREATE TABLE accounts (
  id serial NOT NULL PRIMARY KEY,

  client_id integer NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
  curr_id integer NOT NULL REFERENCES currency_type(id),

  balance money NOT NULL DEFAULT 0, -- 10.2
  amount_reserv money NOT NULL DEFAULT 0, -- 10.2
  amount_trust money NOT NULL DEFAULT 0 -- 10.2
);

-- TODO: .obj_id
--
CREATE TABLE accounts_log (
  id serial NOT NULL PRIMARY KEY,

  account_id integer NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,

  service_type_id integer NOT NULL REFERENCES service_type(id),
  obj_id integer NOT NULL, -- основание для снятия

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  amount money NOT NULL, -- 10.2 сумма проводки
  balance money NOT NULL -- 10.2 остаток на счете
);

--
-- contracts/contracts_log/contracts_status
--
DROP TABLE IF EXISTS contracts;
DROP TABLE IF EXISTS contracts_log;
DROP TABLE IF EXISTS contract_status;

CREATE TABLE contract_status (
  id serial NOT NULL PRIMARY KEY,

  name char(256),
  short_name char(128) NOT NULL UNIQUE
);

INSERT INTO contract_status (id,name,short_name) VALUES (1,'введен','введен');
INSERT INTO contract_status (id,name,short_name) VALUES (2,'активный','активный');
INSERT INTO contract_status (id,name,short_name) VALUES (3,'заблокирован','заблокирован');
INSERT INTO contract_status (id,name,short_name) VALUES (4,'закрыт','закрыт');

CREATE TABLE contracts (
  id serial NOT NULL PRIMARY KEY,

  contract_status_id integer NOT NULL REFERENCES contract_status(id) ON DELETE CASCADE,
  client_id integer NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
  service_id integer NOT NULL REFERENCES services(id) ON DELETE CASCADE,

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  name char(128) NOT NULL,

  date_begin date NOT NULL DEFAULT current_date,
  date_end date,

  login login_t UNIQUE,
  passwd char(32),

  percent_limit money, -- 2.2 максимальный процент от суммы клиента для услуг
  amount_limit money, -- 10.2 максимальная сумма для услуг

  discount money, -- 10.2 сумма скидки
  percent_discount money -- 2.2 %% скидки
);

CREATE TABLE contracts_log (
  id serial NOT NULL PRIMARY KEY,
  contract_id integer NOT NULL REFERENCES contracts(id) ON DELETE CASCADE,

  contract_status_id integer NOT NULL REFERENCES contract_status(id) ON DELETE CASCADE,
  client_id integer NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
  service_id integer NOT NULL REFERENCES services(id) ON DELETE CASCADE,

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  name char(128) NOT NULL,

  date_begin date NOT NULL DEFAULT current_date,
  date_end date,

  login login_t,
  passwd char(32),

  percent_limit money, -- 2.2 максимальный процент от суммы клиента для услуг
  amount_limit money, -- 10.2 максимальная сумма для услуг

  discount money, -- 10.2 сумма скидки
  percent_discount money -- 2.2 %% скидки
);

--
-- messages/problem
--
DROP TABLE IF EXISTS msg_type;

CREATE TABLE msg_type (
  id serial NOT NULL PRIMARY KEY,

  name char(256),
  short_name char(128) NOT NULL UNIQUE
);

INSERT INTO msg_type (id,name,short_name) VALUES (0,'Успешное завершение','OK');
INSERT INTO msg_type (id,name,short_name) VALUES (1,'Ошибка SQL','SQL Error');

--
-- problem/problem_log/problem_type/problem_status
--
DROP TABLE IF EXISTS problem_type;
DROP TABLE IF EXISTS problem_status;
DROP TABLE IF EXISTS problems_log;
DROP TABLE IF EXISTS problems;

CREATE TABLE problem_type (
  id serial NOT NULL PRIMARY KEY,

  name char(256),
  short_name char(128) NOT NULL UNIQUE
);

INSERT INTO problem_type (id,name,short_name) VALUES (1,'Предупреждение','Предупреждение');
INSERT INTO problem_type (id,name,short_name) VALUES (2,'Серьезная','Серьезная');
INSERT INTO problem_type (id,name,short_name) VALUES (3,'Фатальная','Фатальная');

CREATE TABLE problem_status (
  id serial NOT NULL PRIMARY KEY,

  name char(256),
  short_name char(128) NOT NULL UNIQUE
);

INSERT INTO problem_status (id,name,short_name) VALUES (1,'Активирована','Активирована');
INSERT INTO problem_status (id,name,short_name) VALUES (2,'На обработке','На обработке');
INSERT INTO problem_status (id,name,short_name) VALUES (3,'Решена','Решена');

CREATE TABLE problems (
  id serial NOT NULL PRIMARY KEY,

  problem_type_id integer NOT NULL REFERENCES problem_type(id),
  problem_status_id integer NOT NULL REFERENCES problem_status(id),

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  client_id integer REFERENCES clients(id) ON DELETE CASCADE,
  clerk_id integer REFERENCES clerks(id) ON DELETE CASCADE,
  tariff_plan_id integer REFERENCES tariff_plan(id) ON DELETE CASCADE,
  -- clerk_type_id ?
  contract_id integer REFERENCES contracts(id) ON DELETE CASCADE, 
  service_id integer REFERENCES services(id) ON DELETE CASCADE, 

  description varchar(4096)
);

CREATE TABLE problems_log (
  id serial NOT NULL PRIMARY KEY,
  problem_id integer NOT NULL REFERENCES problems(id),

  problem_type_id integer NOT NULL REFERENCES problem_type(id),
  problem_status_id integer NOT NULL REFERENCES problem_status(id),

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  client_id integer REFERENCES clients(id) ON DELETE CASCADE,
  clerk_id integer REFERENCES clerks(id) ON DELETE CASCADE,
  tariff_plan_id integer REFERENCES tariff_plan(id) ON DELETE CASCADE,
  -- clerk_type_id ?
  contract_id integer REFERENCES contracts(id) ON DELETE CASCADE, 
  service_id integer REFERENCES services(id) ON DELETE CASCADE, 

  description varchar(4096)
);

--
-- sysmsg/sysmsg_type
--
DROP TABLE IF EXISTS sysmsg_type;

CREATE TABLE sysmsg_type (
  id serial NOT NULL PRIMARY KEY,

  name char(256),
  short_name char(128) NOT NULL UNIQUE
);

INSERT INTO sysmsg_type (id,name,short_name) VALUES (1,'Info','Info');
INSERT INTO sysmsg_type (id,name,short_name) VALUES (2,'Warning','Warning');
INSERT INTO sysmsg_type (id,name,short_name) VALUES (3,'Error','Error');
INSERT INTO sysmsg_type (id,name,short_name) VALUES (4,'Fatal Error','Fatal Error');

CREATE TABLE sysmsg (
  id serial NOT NULL PRIMARY KEY,

  sysmsg_type_id integer NOT NULL REFERENCES sysmsg_type(id),
  
  ts timestamp NOT NULL DEFAULT current_timestamp,
  event_src char(32) NOT NULL,

  description varchar(4096)
);
