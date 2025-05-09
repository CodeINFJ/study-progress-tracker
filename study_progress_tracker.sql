-- Study Progress Tracker DBMS Final Project
-- Author: Gloria Jemutai
-- Description: Tracks users, their study subjects, sessions, goals, and reflections.

-- Drop existing tables to avoid duplication errors on re-import
DROP TABLE IF EXISTS Reflections, Goals, StudySessions, Subjects, Users;

-- 1. Users table: stores basic user info
CREATE TABLE Users (
    userID INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

-- 2. Subjects table: what subjects the user is studying
CREATE TABLE Subjects (
    subjectID INT PRIMARY KEY AUTO_INCREMENT,
    userID INT NOT NULL,
    subjectName VARCHAR(100) NOT NULL,
    FOREIGN KEY (userID) REFERENCES Users(userID) ON DELETE CASCADE
);

-- 3. StudySessions table: tracks time spent on each subject
CREATE TABLE StudySessions (
    sessionID INT PRIMARY KEY AUTO_INCREMENT,
    subjectID INT NOT NULL,
    sessionDate DATE NOT NULL,
    duration INT NOT NULL CHECK (duration > 0), -- duration in minutes
    notes TEXT,
    FOREIGN KEY (subjectID) REFERENCES Subjects(subjectID) ON DELETE CASCADE
);

-- 4. Goals table: allows users to set learning goals
CREATE TABLE Goals (
    goalID INT PRIMARY KEY AUTO_INCREMENT,
    subjectID INT NOT NULL,
    description TEXT NOT NULL,
    targetDate DATE NOT NULL,
    status ENUM('Not Started', 'In Progress', 'Completed') DEFAULT 'Not Started',
    FOREIGN KEY (subjectID) REFERENCES Subjects(subjectID) ON DELETE CASCADE
);

-- 5. Reflections table: user thoughts on their progress
CREATE TABLE Reflections (
    reflectionID INT PRIMARY KEY AUTO_INCREMENT,
    userID INT NOT NULL,
    reflectionDate DATE DEFAULT CURRENT_DATE,
    content TEXT NOT NULL,
    FOREIGN KEY (userID) REFERENCES Users(userID) ON DELETE CASCADE
);

-- Sample Data Inserts
-- Insert Users
INSERT INTO Users (name, email) VALUES
('Alice M.', 'alice@example.com'),
('Brian T.', 'brian@example.com');

-- Insert Subjects
INSERT INTO Subjects (userID, subjectName) VALUES
(1, 'Networking Certification'),
(1, 'CCNP'),
(2, 'Data Analysis');

-- Insert StudySessions
INSERT INTO StudySessions (subjectID, sessionDate, duration, notes) VALUES
(1, '2025-05-01', 90, 'Subnetting practice'),
(2, '2025-05-02', 60, 'Routing protocols review'),
(3, '2025-05-03', 120, 'Explored data visualization in Python');

-- Insert Goals
INSERT INTO Goals (subjectID, description, targetDate, status) VALUES
(1, 'Understand all key concepts in Networking Cert.', '2025-06-01', 'In Progress'),
(2, 'Master CCNP switching topics', '2025-05-15', 'Not Started');

-- Insert Reflections
INSERT INTO Reflections (userID, reflectionDate, content) VALUES
(1, '2025-05-04', 'Subnetting is finally starting to click!'),
(2, '2025-05-04', 'Enjoyed playing with seaborn and pandas today.');

-- Test Queries

-- 1. List all users
SELECT * FROM Users;

-- 2. Show all subjects for Alice
SELECT s.subjectName FROM Subjects s
JOIN Users u ON s.userID = u.userID
WHERE u.name = 'Alice M.';

-- 3. Total study time per subject
SELECT sub.subjectName, SUM(sess.duration) AS total_minutes
FROM StudySessions sess
JOIN Subjects sub ON sess.subjectID = sub.subjectID
GROUP BY sub.subjectName;

-- 4. List goals with status and due date
SELECT g.description, g.status, g.targetDate, s.subjectName
FROM Goals g
JOIN Subjects s ON g.subjectID = s.subjectID;

-- 5. View reflections by user
SELECT u.name, r.reflectionDate, r.content
FROM Reflections r
JOIN Users u ON r.userID = u.userID
ORDER BY r.reflectionDate DESC;
