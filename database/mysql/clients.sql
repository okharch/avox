--
-- Clients
--
DROP TABLE IF EXISTS clients_log;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS client_type;
DROP TABLE IF EXISTS client_status;

CREATE TABLE client_type (
  id serial NOT NULL PRIMARY KEY,

  name varchar(255) not null,
  short_name varchar(30) not null NOT NULL UNIQUE
);

INSERT INTO client_type (id,name,short_name) VALUES (1,'mobile phone subscriber','subscriber');
INSERT INTO client_type (id,name,short_name) VALUES (2,'employee','employee');

CREATE TABLE client_status (
  id serial NOT NULL PRIMARY KEY,

  name varchar(255) not null,
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

  name varchar(255) not null,
  phones varchar(255),
  mails varchar(255),
  address varchar(255),

  login varchar(30) not null,
  passwd char(32) not null,

  date_begin timestamp NOT NULL DEFAULT current_timestamp,
  date_end timestamp null
);

CREATE TABLE clients_log (
  id integer not null,

  client_type_id integer NOT NULL REFERENCES client_type(id),
  client_status_id integer NOT NULL REFERENCES client_status(id),

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  name varchar(255) not null,
  phones varchar(255),
  mails varchar(255),
  address varchar(255),

  login varchar(30) not null,
  passwd char(32) not null,

  date_begin date NOT NULL,
  date_end date,
  PRIMARY KEY (id,date_change)
);
