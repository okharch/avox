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

  name lname,
  short_name char(128) NOT NULL UNIQUE
);

INSERT INTO client_status (id,name,short_name) VALUES (1,'created','created');
INSERT INTO client_status (id,name,short_name) VALUES (2,'active','active');
INSERT INTO client_status (id,name,short_name) VALUES (3,'blocked','blocked');
INSERT INTO client_status (id,name,short_name) VALUES (4,'closed','closed');

CREATE TABLE clients (
  id serial NOT NULL PRIMARY KEY,

  client_type_id integer NOT NULL REFERENCES client_type(id),
  client_status_id integer NOT NULL REFERENCES client_status(id),

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  name lname,
  phones string,
  mails string,
  address string,

  login login_t,
  passwd char(32) not null,

  date_begin date NOT NULL DEFAULT current_date,
  date_end date
);

CREATE TABLE clients_log (
  id integer not null,

  client_type_id integer NOT NULL REFERENCES client_type(id),
  client_status_id integer NOT NULL REFERENCES client_status(id),

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  name lname,
  phones string,
  mails string,
  address string,

  login login_t,
  passwd char(32) not null,

  date_begin date NOT NULL DEFAULT current_date,
  date_end date,
  PRIMARY KEY (id,date_change)
);
