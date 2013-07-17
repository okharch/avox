SET client_min_messages TO WARNING;
--
-- problem/problem_log/problem_type/problem_status
--
DROP TABLE IF EXISTS problems_log;
DROP TABLE IF EXISTS problems;
DROP TABLE IF EXISTS problem_type;
DROP TABLE IF EXISTS problem_status;

--
-- services_tariff/services_tariff_log
--
DROP TABLE IF EXISTS services_tariff_log;
DROP TABLE IF EXISTS services_tariff;

-- contracts
DROP TABLE IF EXISTS contracts_log;
DROP TABLE IF EXISTS contracts;
DROP TABLE IF EXISTS contract_status;

--
-- services/services_log/service_type/service_status
--
DROP TABLE IF EXISTS services_log;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS service_type CASCADE;
DROP TABLE IF EXISTS service_status;

CREATE TABLE service_type (
  id serial NOT NULL PRIMARY KEY,

  name lname,
  short_name sname NOT NULL UNIQUE
);

INSERT INTO service_type (id,name,short_name) VALUES (1,'per period payment','subscription');
INSERT INTO service_type (id,name,short_name) VALUES (2,'on line','on line');
INSERT INTO service_type (id,name,short_name) VALUES (3,'off line','off line');
INSERT INTO service_type (id,name,short_name) VALUES (4,'for free','free');

CREATE TABLE service_status (
  id serial NOT NULL PRIMARY KEY,
  name lname,
  short_name sname UNIQUE
);

INSERT INTO service_status (id,name,short_name) VALUES (1,'created','created');
INSERT INTO service_status (id,name,short_name) VALUES (2,'active','active');
INSERT INTO service_status (id,name,short_name) VALUES (3,'temporarily deactivated','blocked');
INSERT INTO service_status (id,name,short_name) VALUES (4,'service is closed','closed');

CREATE TABLE services (
  id serial NOT NULL PRIMARY KEY,

  service_type_id integer NOT NULL REFERENCES service_type(id),
  service_status_id integer NOT NULL REFERENCES service_status(id),

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  name lname,

  date_begin date NOT NULL DEFAULT current_date,
  date_end date,

  discount money -- 2.2 %%
);

CREATE TABLE services_log (
  id integer NOT NULL,

  service_type_id integer NOT NULL REFERENCES service_type(id),
  service_status_id integer NOT NULL REFERENCES service_status(id),

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  name lname NOT NULL,

  date_begin date NOT NULL DEFAULT current_date,
  date_end date,

  discount money, -- 2.2 %%
  PRIMARY KEY(id,date_change)
);

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
  id integer NOT NULL PRIMARY KEY,
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
-- contracts/contracts_log/contracts_status
--
CREATE TABLE contract_status (
  id serial NOT NULL PRIMARY KEY,

  name char(256),
  short_name char(128) NOT NULL UNIQUE
);

INSERT INTO contract_status (id,name,short_name) VALUES (1,'created','created');
INSERT INTO contract_status (id,name,short_name) VALUES (2,'active','active');
INSERT INTO contract_status (id,name,short_name) VALUES (3,'temporarily deactivated','blocked');
INSERT INTO contract_status (id,name,short_name) VALUES (4,'service is closed','closed');

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
  id integer NOT NULL,

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
  percent_discount money, -- 2.2 %% скидки
  PRIMARY KEY(id,date_change)
);

--
-- problem/problem_log/problem_type/problem_status
--

CREATE TABLE problem_type (
  id serial NOT NULL PRIMARY KEY,

  name char(256),
  short_name char(128) NOT NULL UNIQUE
);

INSERT INTO problem_type (id,name,short_name) VALUES (1,'Warning','Warning');
INSERT INTO problem_type (id,name,short_name) VALUES (2,'Serious','Critical');
INSERT INTO problem_type (id,name,short_name) VALUES (3,'Fatal','Fatal');

CREATE TABLE problem_status (
  id serial NOT NULL PRIMARY KEY,

  name char(256),
  short_name char(128) NOT NULL UNIQUE
);

INSERT INTO problem_status (id,name,short_name) VALUES (1,'activated','activated');
INSERT INTO problem_status (id,name,short_name) VALUES (2,'is processed','processed');
INSERT INTO problem_status (id,name,short_name) VALUES (3,'is solved','solved');

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
  id serial NOT NULL ,
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
  PRIMARY KEY(id,date_change),
  description varchar(4096)
);

