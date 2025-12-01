-- Full SQL Assignment Script

CREATE DATABASE assignment_db;
USE assignment_db;

-- 1) Managers with >=5 reports
CREATE TABLE Employee1 (
    id INT,
    name VARCHAR(50),
    department VARCHAR(50),
    managerId INT
);

INSERT INTO Employee1 VALUES
(101, 'John', 'A', NULL),
(102, 'Dan', 'A', 101),
(103, 'James', 'A', 101),
(104, 'Amy', 'A', 101),
(105, 'Anne', 'A', 101),
(106, 'Ron', 'B', 101);

-- Query 1
SELECT e.name
FROM Employee1 e
JOIN Employee1 s ON e.id = s.managerId
GROUP BY e.id, e.name
HAVING COUNT(s.id) >= 5;

-- 2) Nth highest salary
CREATE TABLE Employee2 (
    id INT,
    salary INT
);

INSERT INTO Employee2 VALUES
(1,100),
(2,200),
(3,300);

-- Query 2
SELECT (
    SELECT DISTINCT salary
    FROM Employee2
    ORDER BY salary DESC
    LIMIT 1 OFFSET 1
) AS getNthHighestSalary;

-- 3) Person with most friends
CREATE TABLE RequestAccepted (
    requester_id INT,
    accepter_id INT,
    accept_date DATE,
    PRIMARY KEY (requester_id, accepter_id)
);

INSERT INTO RequestAccepted VALUES
(1,2,'2016-06-03'),
(1,3,'2016-06-08'),
(2,3,'2016-06-08'),
(3,4,'2016-06-09');

-- Query 3
SELECT id, COUNT(*) AS num
FROM (
    SELECT requester_id AS id, accepter_id FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS id, requester_id FROM RequestAccepted
) t
GROUP BY id
ORDER BY num DESC
LIMIT 1;

-- 4) Swap seats
CREATE TABLE Seat (
    id INT PRIMARY KEY,
    student VARCHAR(50)
);

INSERT INTO Seat VALUES
(1,'Abbot'),
(2,'Doris'),
(3,'Emerson'),
(4,'Green'),
(5,'Jeames');

-- Query 4
SELECT 
   CASE 
      WHEN id % 2 = 1 AND id + 1 <= (SELECT MAX(id) FROM Seat) THEN id + 1
      WHEN id % 2 = 0 THEN id - 1
      ELSE id
   END AS id,
   student
FROM Seat
ORDER BY id;

-- 5) Customers who bought all products
CREATE TABLE Product (
    product_key INT PRIMARY KEY
);

INSERT INTO Product VALUES (5),(6);

CREATE TABLE Customer (
    customer_id INT,
    product_key INT
);

INSERT INTO Customer VALUES
(1,5),(2,6),(3,5),(3,6),(1,6);

-- Query 5
SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(*) FROM Product);

-- 6) Join date + orders in 2019
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    join_date DATE,
    favorite_brand VARCHAR(50)
);

INSERT INTO Users VALUES
(1,'2018-01-01','Lenovo'),
(2,'2018-02-09','Samsung'),
(3,'2018-01-19','LG'),
(4,'2018-05-21','HP');

CREATE TABLE Items (
    item_id INT PRIMARY KEY,
    item_brand VARCHAR(50)
);

INSERT INTO Items VALUES
(1,'Samsung'),
(2,'Lenovo'),
(3,'LG'),
(4,'HP');

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    item_id INT,
    buyer_id INT,
    seller_id INT
);

INSERT INTO Orders VALUES
(1,'2019-08-01',4,1,2),
(2,'2018-08-02',2,1,3),
(3,'2019-08-03',3,2,3),
(4,'2018-08-04',1,4,2),
(5,'2018-08-04',1,3,4),
(6,'2019-08-05',2,2,4);

-- Query 6
SELECT 
    u.user_id AS buyer_id,
    u.join_date,
    COUNT(o.order_id) AS orders_in_2019
FROM Users u
LEFT JOIN Orders o
ON u.user_id = o.buyer_id 
   AND YEAR(o.order_date) = 2019
GROUP BY u.user_id, u.join_date;

-- 7) First login count (within 90 days)
CREATE TABLE Traffic (
    user_id INT,
    activity ENUM('login','logout','jobs','groups','homepage'),
    activity_date DATE
);

INSERT INTO Traffic VALUES
(1,'login','2019-05-01'),
(1,'homepage','2019-05-01'),
(1,'logout','2019-05-01'),
(2,'login','2019-06-21'),
(2,'logout','2019-06-21'),
(3,'login','2019-01-01'),
(3,'jobs','2019-01-01'),
(3,'logout','2019-01-01'),
(4,'login','2019-06-21'),
(4,'groups','2019-06-21'),
(4,'logout','2019-06-21'),
(5,'login','2019-03-01'),
(5,'logout','2019-03-01'),
(5,'login','2019-06-21'),
(5,'logout','2019-06-21');

-- Query 7
SELECT first_login AS login_date, COUNT(*) AS user_count
FROM (
    SELECT user_id, MIN(activity_date) AS first_login
    FROM Traffic
    WHERE activity = 'login'
    GROUP BY user_id
) t
WHERE first_login BETWEEN DATE_SUB('2019-06-30', INTERVAL 90 DAY) AND '2019-06-30'
GROUP BY first_login;

-- 8) Price on 2019-08-16
CREATE TABLE ProductsPrice (
    product_id INT,
    new_price INT,
    change_date DATE,
    PRIMARY KEY(product_id, change_date)
);

INSERT INTO ProductsPrice VALUES
(1,20,'2019-08-14'),
(2,50,'2019-08-14'),
(1,30,'2019-08-15'),
(1,35,'2019-08-16'),
(2,65,'2019-08-17'),
(3,20,'2019-08-18');

-- Query 8
SELECT product_id,
       COALESCE(
           (SELECT new_price
            FROM ProductsPrice p2
            WHERE p2.product_id = p1.product_id
              AND p2.change_date <= '2019-08-16'
            ORDER BY change_date DESC
            LIMIT 1),
           10
       ) AS price
FROM (SELECT DISTINCT product_id FROM ProductsPrice) p1;

-- 9) Monthly country stats
CREATE TABLE Transactions (
    id INT PRIMARY KEY,
    country VARCHAR(50),
    state ENUM('approved','declined'),
    amount INT,
    trans_date DATE
);

INSERT INTO Transactions VALUES
(101,'US','approved',1000,'2019-05-18'),
(102,'US','declined',2000,'2019-05-19'),
(103,'US','approved',3000,'2019-06-10'),
(104,'US','declined',4000,'2019-06-13'),
(105,'US','approved',5000,'2019-06-15');

CREATE TABLE Chargebacks (
    trans_id INT,
    trans_date DATE
);

INSERT INTO Chargebacks VALUES
(102,'2019-05-29'),
(101,'2019-06-30'),
(105,'2019-09-18');

-- Query 9
SELECT 
    DATE_FORMAT(t.trans_date,'%Y-%m') AS month,
    t.country,
    SUM(CASE WHEN state='approved' THEN 1 ELSE 0 END) AS approved_count,
    SUM(CASE WHEN state='approved' THEN amount ELSE 0 END) AS approved_amount,
    SUM(CASE WHEN c.trans_id IS NOT NULL THEN 1 ELSE 0 END) AS chargeback_count,
    SUM(CASE WHEN c.trans_id IS NOT NULL THEN amount ELSE 0 END) AS chargeback_amount
FROM Transactions t
LEFT JOIN Chargebacks c ON t.id = c.trans_id
GROUP BY month, country;

-- 10) Football point table
CREATE TABLE Teams (
    team_id INT PRIMARY KEY,
    team_name VARCHAR(50)
);

INSERT INTO Teams VALUES
(10,'Leetcode FC'),
(20,'NewYork FC'),
(30,'Atlanta FC'),
(40,'Chicago FC'),
(50,'Toronto FC');

CREATE TABLE Matches (
    match_id INT PRIMARY KEY,
    host_team INT,
    guest_team INT,
    host_goals INT,
    guest_goals INT
);

INSERT INTO Matches VALUES
(1,10,20,3,0),
(2,30,10,2,2),
(3,10,50,5,1),
(4,20,30,1,0),
(5,50,30,1,0);

-- Query 10
SELECT t.team_id, t.team_name, COALESCE(SUM(points),0) AS num_points
FROM Teams t
LEFT JOIN (
    SELECT 
       host_team AS team_id,
       CASE 
          WHEN host_goals > guest_goals THEN 3
          WHEN host_goals = guest_goals THEN 1
          ELSE 0
       END AS points
    FROM Matches
    UNION ALL
    SELECT 
       guest_team AS team_id,
       CASE 
          WHEN guest_goals > host_goals THEN 3
          WHEN guest_goals = host_goals THEN 1
          ELSE 0
       END AS points
    FROM Matches
) scores
ON t.team_id = scores.team_id
GROUP BY t.team_id, t.team_name
ORDER BY num_points DESC, team_id ASC;