--
-- Users
--

DROP TABLE IF EXISTS clerks_log;
DROP TABLE IF EXISTS clerks CASCADE;
DROP TABLE IF EXISTS clerk_type;
DROP TABLE IF EXISTS clerk_status;

CREATE TABLE clerk_type (
  id serial NOT NULL PRIMARY KEY,
  name lname,
  short_name sname NOT NULL UNIQUE
);

INSERT INTO clerk_type (id,name,short_name) VALUES (1,'system account','system');
INSERT INTO clerk_type (id,name,short_name) VALUES (2,'admin account','admin');
INSERT INTO clerk_type (id,name,short_name) VALUES (3,'office account','office');
INSERT INTO clerk_type (id,name,short_name) VALUES (4,'accountant account','accountant');

CREATE TABLE clerk_status (
  id serial NOT NULL PRIMARY KEY,
  name lname,
  short_name sname UNIQUE
);

INSERT INTO clerk_status (id,name,short_name) VALUES (1,'created','created');
INSERT INTO clerk_status (id,name,short_name) VALUES (2,'active','active');
INSERT INTO clerk_status (id,name,short_name) VALUES (3,'blocked','blocked');
INSERT INTO clerk_status (id,name,short_name) VALUES (4,'closed','closed');

DROP TABLE IF EXISTS clerks;

CREATE TABLE clerks (
  id serial NOT NULL PRIMARY KEY,

  clerk_type_id integer NOT NULL REFERENCES clerk_type(id),
  clerk_status_id integer NOT NULL REFERENCES clerk_status(id),

  date_change timestamp NOT NULL DEFAULT current_timestamp,
  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  name string, -- ?
  first_name sname,
  last_name sname,
  phones string,
  mails string,
  address string,

--  login char(32) NOT NULL UNIQUE,
  login login_t UNIQUE,
  passwd char(32) NOT NULL
);

CREATE TABLE clerks_log (
  id integer NOT NULL,
  date_change timestamp NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY(id, date_change),
  clerk_id integer NOT NULL REFERENCES clerks(id) ON DELETE CASCADE,

  clerk_type_id integer NOT NULL REFERENCES clerk_type(id),
  clerk_status_id integer NOT NULL REFERENCES clerk_status(id),

  clerk_id_change integer NOT NULL DEFAULT 1 REFERENCES clerks(id) ON DELETE SET DEFAULT, -- system

  name string, -- ?
  first_name sname,
  last_name sname,
  phones string,
  mails string,
  address string,

--  login char(32) NOT NULL,
  login login_t, -- !UNIQUE
  passwd char(32) NOT NULL
);
