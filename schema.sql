DROP DATABASE IF EXISTS test WITH (FORCE);

CREATE DATABASE test;

\connect test;

CREATE TABLE test1 (
  id INTEGER,
  name VARCHAR(50)
)