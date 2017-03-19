DROP TABLE users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	username VARCHAR(50) UNIQUE NOT NULL,
	password TEXT NOT NULL,
	email VARCHAR(100) UNIQUE NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	created_on TIMESTAMP NOT NULL
);
ALTER TABLE users ALTER created_on SET DEFAULT now();

CREATE EXTENSION postgis;

DROP TABLE poi;
CREATE TABLE poi (
	id SERIAL PRIMARY KEY,
	owner_id SERIAL NOT NULL,
	label TEXT NOT NULL,
	description TEXT NOT NULL,
	location GEOGRAPHY(POINT, 4326) NOT NULL,
	created_on TIMESTAMP NOT NULL
);
ALTER TABLE poi ALTER created_on SET DEFAULT now();

DROP TABLE posts;
CREATE TABLE posts (
	id SERIAL PRIMARY KEY,
	owner_id SERIAL NOT NULL,
	title TEXT NOT NULL,
	content TEXT NOT NULL,
	created_on TIMESTAMP NOT NULL
);
ALTER TABLE posts ALTER created_on SET DEFAULT now();

ALTER ROLE postgres PASSWORD 'abc123';
CREATE ROLE bwackwat WITH LOGIN;
ALTER ROLE bwackwat PASSWORD 'abc123';
GRANT SELECT, INSERT, UPDATE ON users TO bwackwat;
GRANT SELECT, INSERT, UPDATE ON poi TO bwackwat;
GRANT SELECT, INSERT, UPDATE ON posts TO bwackwat;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO bwackwat;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO bwackwat;
