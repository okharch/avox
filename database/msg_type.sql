SET client_min_messages TO WARNING;
--
-- messages/problem
--
DROP TABLE IF EXISTS msg_type;

CREATE TABLE msg_type (
  id serial NOT NULL PRIMARY KEY,

  name char(256),
  short_name char(128) NOT NULL UNIQUE
);

INSERT INTO msg_type (id,name,short_name) VALUES (0,'Successful','OK');
INSERT INTO msg_type (id,name,short_name) VALUES (1,'SQL Error','SQL Error');

--
-- sysmsg/sysmsg_type
--
DROP TABLE IF EXISTS sysmsg;
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
