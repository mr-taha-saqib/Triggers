CREATE DATABASE db8
USE db8


--Q1
CREATE TABLE productssss
(
    id INT PRIMARY KEY,
    name NVARCHAR(100),
    price DECIMAL(10, 2),
    quantity INT
);


CREATE TRIGGER price_checkkkk
ON productssss
FOR INSERT
AS 
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE price < 0 OR price > 1000)
    BEGIN
        PRINT('The price value is not within the specified range (0 - 1000)');
        ROLLBACK TRANSACTION;
    END
END;
BEGIN TRANSACTION;

INSERT INTO productssss (id, name, price, quantity)
VALUES (1, 'Product1', 1000, 10);

INSERT INTO productssss (id, name, price, quantity)
VALUES (2, 'Product2', 1500, 15);

INSERT INTO productssss (id, name, price, quantity)
VALUES (3, 'Product3', 2000, 20);

COMMIT TRANSACTION;


--Q2
CREATE TABLE customerssss (
    iid INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE ordersss (
    iid INT PRIMARY KEY,
    customer_id INT,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customerssss(iid)
);

CREATE TRIGGER prevent_customer_deletesssss
ON customerssss
FOR DELETE
AS
BEGIN
    IF (SELECT COUNT(*) FROM ordersss WHERE customer_id IN (SELECT iid FROM deleted)) > 0 
	BEGIN
        ROLLBACK TRANSACTION;
        PRINT('Error: Cannot delete customer with orders.');
    END;
END;
INSERT INTO customersss (iid, name) VALUES (3, 'John Doe');
INSERT INTO ordersss (iid, customer_id, total_amount) VALUES (4, 1, 100.00);

DELETE FROM customersss WHERE iid = 3;

SELECT * FROM customersss; 
SELECT * FROM orderss;


--Q3

CREATE TABLE logssss (
    iiid INT,
    table_name VARCHAR(128),
    column_name VARCHAR(128),
    old_value VARCHAR(255),
    new_value VARCHAR(255),
    timestamp TIMESTAMP,
    PRIMARY KEY (iiid)
);
CREATE TRIGGER log_changessss
ON logssss
AFTER UPDATE
AS
BEGIN
    DECLARE @TableName NVARCHAR(128);
    DECLARE @ColumnName NVARCHAR(128);
    DECLARE @OldValue NVARCHAR(255);
    DECLARE @NewValue NVARCHAR(255);
    DECLARE @Timestamp DATETIME;

    SET @TableName = 'logssss';
    SET @ColumnName = EVENTDATA().value('(/EVENT_INSTANCE/Column)[1]', 'NVARCHAR(128)');
    SET @OldValue = EVENTDATA().value('(/EVENT_INSTANCE/@old)[1]', 'NVARCHAR(255)');
    SET @NewValue = EVENTDATA().value('(/EVENT_INSTANCE/@new)[1]', 'NVARCHAR(255)');
    SET @Timestamp = GETDATE();

    INSERT INTO logssss (table_name, column_name, old_value, new_value, timestamp)
    VALUES (@TableName, @ColumnName, @OldValue, @NewValue, @Timestamp);
END;
UPDATE employees SET position = 'Manager' WHERE iiid = 1;
SELECT * FROM logssss;


--Q4

CREATE TABLE ord (
    id INT PRIMARY KEY,
    customer_id INT,
    total DECIMAL(10, 2),
    discount DECIMAL(5, 2)
);
CREATE TRIGGER enforce_discount_rule
ON ord
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM INSERTED i
        INNER JOIN ord o ON i.id = o.id
        WHERE i.discount > o.total * 0.10
    )
    BEGIN
        PRINT('Discount cannot exceed 10% of the total');
    END
END;
INSERT INTO ord (id, customer_id, total, discount) VALUES (1, 101, 500.00, 60.00);

