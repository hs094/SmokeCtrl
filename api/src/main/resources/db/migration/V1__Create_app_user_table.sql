CREATE TABLE app_user (
    userid VARCHAR(255) NOT NULL PRIMARY KEY,
    loginid VARCHAR(255) NOT NULL,
    pwd VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    age INTEGER NOT NULL,
    sex VARCHAR(10) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    designation VARCHAR(255) NOT NULL,
    qualification VARCHAR(255) NOT NULL,
    user_type VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL
);