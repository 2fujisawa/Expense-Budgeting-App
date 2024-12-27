USE ExpenseBudgetingSystem;

-- User Table
CREATE TABLE User (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Age INT,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(100) NOT NULL
);

-- Budget Table
CREATE TABLE Budget (
    BudgetID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    StartDate DATE,
    EndDate DATE,
    MonthlyLimit DECIMAL(8, 2), -- The maximum monthly budget is going to be 999,999.99
    Status VARCHAR(50),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

-- Category Table
CREATE TABLE Category (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Description VARCHAR(255)
);

-- Transaction Table
CREATE TABLE Transaction (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    Amount DECIMAL(8, 2) NOT NULL, -- The maximum Transaction is going to be 999,999.99
    TransactionDate DATE NOT NULL,
    CategoryID INT NOT NULL,
    Description VARCHAR(255),
    Type VARCHAR(50),
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

-- Alert Table
CREATE TABLE Alert (
    AlertID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    Message VARCHAR(255),
    AlertDate DATE NOT NULL,
    Status VARCHAR(50),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

-- Alter Transaction table to add BudgetID and restore foreign key constraint
ALTER TABLE Transaction
ADD COLUMN BudgetID INT DEFAULT NULL AFTER UserID,
ADD CONSTRAINT FK_Transaction_Budget FOREIGN KEY (BudgetID) REFERENCES Budget(BudgetID) ON DELETE SET NULL ON UPDATE CASCADE;

-- Alter Alert table to add BudgetID and restore foreign key constraint
ALTER TABLE Alert
ADD COLUMN BudgetID INT DEFAULT NULL AFTER UserID,
ADD CONSTRAINT FK_Alert_Budget FOREIGN KEY (BudgetID) REFERENCES Budget(BudgetID) ON DELETE SET NULL ON UPDATE CASCADE;

-- Add default values for status in Budget and Alert
ALTER TABLE Budget
MODIFY COLUMN Status VARCHAR(50) DEFAULT 'Active';

ALTER TABLE Alert
MODIFY COLUMN Status VARCHAR(50) DEFAULT 'Unread';

