-- ========================================================
-- Database Schema for Online Quiz Application
-- Database: online_quiz
-- ========================================================

CREATE DATABASE IF NOT EXISTS online_quiz;
USE online_quiz;

-- 1. Table: questions
DROP TABLE IF EXISTS questions;
CREATE TABLE questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question TEXT NOT NULL,
    option1 VARCHAR(255) NOT NULL,
    option2 VARCHAR(255) NOT NULL,
    option3 VARCHAR(255) NOT NULL,
    option4 VARCHAR(255) NOT NULL,
    answer INT NOT NULL -- stores 1, 2, 3, or 4
);

-- 2. Table: results
DROP TABLE IF EXISTS results;
CREATE TABLE results (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    score INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Table: quiz_settings
DROP TABLE IF EXISTS quiz_settings;
CREATE TABLE quiz_settings (
    id INT PRIMARY KEY,
    joining_password VARCHAR(255) DEFAULT '',
    is_published BOOLEAN DEFAULT FALSE
);

-- Insert default single record for quiz settings (id = 1)
INSERT INTO quiz_settings (id, joining_password, is_published)
VALUES (1, '', FALSE)
ON DUPLICATE KEY UPDATE id=1;

-- Optional sample questions for initial testing
INSERT INTO questions (question, option1, option2, option3, option4, answer) VALUES
('Which data type is used to create a variable that should store text in Java?', 'myString', 'string', 'String', 'Txt', 3),
('What is the default value of a boolean variable in Java?', 'true', 'false', 'null', '0', 2),
('Which keyword is used to inherit a class in Java?', 'implements', 'inherits', 'extends', 'instanceof', 3);
