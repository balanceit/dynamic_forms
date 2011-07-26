

CREATE TABLE projects (
  id int(11) NOT NULL,
  name varchar(255),
  PRIMARY KEY  (id)
);

CREATE TABLE goals (
  id int(11) NOT NULL,
  project_id int(11) NOT NULL,
  name varchar(255),
  PRIMARY KEY  (id)
);

