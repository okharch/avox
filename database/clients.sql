SET client_min_messages TO WARNING;
--
-- Clients
--
DROP TABLE IF EXISTS clients_log;
DROP TABLE IF EXISTS clients CASCADE;
DROP TABLE IF EXISTS client_type;
DROP TABLE IF EXISTS client_status;

CREATE TABLE client_type (
  id serial NOT NULL PRIMARY KEY,

  name lname,
  short_name sname NOT NULL UNIQUE
);

INSERT INTO client_type (id,name,short_name) VALUES (1,'mobile phone subscriber','subscriber');
INSERT INTO client_type (id,name,short_name) VALUES (2,'employee','employee');

CREATE TABLE client_status (
  id serial NOT NULL PRIMARY KEY,

  name long_name,
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
  id integer not null,
  date_change timestamp NOT NULL DEFAULT current_timestamp,
   PRIMARY KEY (id,date_change)
  client_id integer NOT NULL REFERENCES clients(id) ON DELETE CASCADE,

  client_type_id integer NOT NULL REFERENCES client_type(id),
  client_status_id integer NOT NULL REFERENCES client_status(id),

  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  name char(128),
  phones char(128),
  mails char(64),
  address char(128),

  login char(32),
  passwd char(32)
);
