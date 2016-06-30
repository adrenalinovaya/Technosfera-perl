CREATE TABLE IF NOT EXISTS users (
    id INTEGER NOT NULL AUTO_INCREMENT,
    nick VARCHAR(256) CHARACTER SET utf8 NOT NULL UNIQUE,
    karma VARCHAR(64),
    rating VARCHAR(64),
    href VARCHAR(1024) DEFAULT NULL UNIQUE,
    PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS data (
    id INTEGER NOT NULL AUTO_INCREMENT,
    user_id INTEGER NOT NULL,
    title VARCHAR(2048) CHARACTER SET utf8 NOT NULL,
    crating VARCHAR(64),
    views VARCHAR(16) NOT NULL,
    stars INTEGER NOT NULL,
    href VARCHAR(1024) NOT NULL UNIQUE,
    PRIMARY KEY(id),
    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS commenters (
    id INTEGER NOT NULL AUTO_INCREMENT,
    user_id INTEGER NOT NULL,
    post_id INTEGER NOT NULL,
    comment_count INTEGER NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(post_id) REFERENCES data(id)
);