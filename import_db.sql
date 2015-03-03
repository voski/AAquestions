DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(100) NOT NULL,
  lname VARCHAR(100) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER REFERENCES users(id) NOT NULL
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  question_id INTEGER REFERENCES questions(id) NOT NULL,
  follower_id INTEGER REFERENCES users(id) NOT NULL
);

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  question_id INTEGER REFERENCES questions(id) NOT NULL,
  parent_id INTEGER REFERENCES replies(id),
  author_id INTEGER REFERENCES user(id) NOT NULL,
  body TEXT NOT NULL
);

CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  question_id INTEGER REFERENCES questions(id) NOT NULL,
  user_id INTEGER REFERENCES users(id) NOT NULL
);

INSERT INTO users (fname, lname)
VALUES ('Tomas','Batalla'), ('Narbe','Voskanian');

INSERT INTO questions (title, body, author_id)
VALUES ('What is the meaning of life?', 'Seriously', 1), ('What time is it?',
  'I cant be late', 2);

INSERT INTO question_follows(question_id, follower_id)
VALUES (1,2) , (2,1), (1,1), (2,2);

INSERT INTO replies (question_id, parent_id, author_id, body)
VALUES (2, null, 1, '10:45 am') , (2, 1, 2, 'Thanks!');

INSERT INTO question_likes (question_id, user_id)
VALUES (1,2) , (2,1), (1,1), (2,2);
