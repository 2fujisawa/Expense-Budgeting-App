-- MySQL dump 10.13  Distrib 9.0.1, for macos15.1 (arm64)
--
-- Host: localhost    Database: ExpenseBudgetingSystem
-- ------------------------------------------------------
-- Server version	9.1.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Alert`
--

DROP TABLE IF EXISTS `Alert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Alert` (
  `AlertID` int NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  `Message` varchar(255) DEFAULT NULL,
  `AlertDate` date NOT NULL,
  `Status` varchar(50) DEFAULT NULL,
  `BudgetID` int DEFAULT NULL,
  PRIMARY KEY (`AlertID`),
  KEY `UserID` (`UserID`),
  KEY `BudgetID` (`BudgetID`),
  CONSTRAINT `alert_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `User` (`UserID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `alert_ibfk_2` FOREIGN KEY (`BudgetID`) REFERENCES `Budget` (`BudgetID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Alert`
--

LOCK TABLES `Alert` WRITE;
/*!40000 ALTER TABLE `Alert` DISABLE KEYS */;
INSERT INTO `Alert` VALUES (1,1,'Budget limit exceeded! You have spent $5800.00 out of $5000.00.','2024-12-05','Unread',3),(2,1,'Budget limit exceeded! You have spent $10000.00 out of $5000.00.','2024-12-05','Unread',4),(3,3,'Budget limit exceeded! You have spent $15000.00 out of $10000.00.','2024-12-07','Unread',8),(4,4,'Budget limit exceeded! You have spent $16000.00 out of $15000.00.','2024-12-07','Unread',9),(5,4,'Budget limit exceeded! You have spent $31000.00 out of $15000.00.','2024-12-07','Unread',9);
/*!40000 ALTER TABLE `Alert` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Budget`
--

DROP TABLE IF EXISTS `Budget`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Budget` (
  `BudgetID` int NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `MonthlyLimit` decimal(8,2) DEFAULT NULL,
  `Status` varchar(50) DEFAULT 'Active',
  PRIMARY KEY (`BudgetID`),
  KEY `UserID` (`UserID`),
  CONSTRAINT `budget_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `User` (`UserID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Budget`
--

LOCK TABLES `Budget` WRITE;
/*!40000 ALTER TABLE `Budget` DISABLE KEYS */;
INSERT INTO `Budget` VALUES (3,1,'2024-01-01','2024-12-31',6000.00,'Active'),(4,1,'2024-01-01','2024-12-31',5000.00,'Active'),(6,1,'2024-01-01','2024-12-31',100.00,'Active'),(7,1,'2024-01-01','2024-12-31',5000.00,'Active'),(8,3,'2024-01-01','2024-12-31',15000.00,'Active'),(9,4,'2024-01-01','2024-12-31',15000.00,'Active'),(10,5,'2024-01-01','2024-12-31',1000.00,'Active');
/*!40000 ALTER TABLE `Budget` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Category`
--

DROP TABLE IF EXISTS `Category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Category` (
  `CategoryID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`CategoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Category`
--

LOCK TABLES `Category` WRITE;
/*!40000 ALTER TABLE `Category` DISABLE KEYS */;
INSERT INTO `Category` VALUES (1,'Groceries','Expenses related to food and grocery shopping'),(2,'Car','Car maintenance'),(3,'Bank','Bank Withdraw and deposits'),(5,'Test category','Testing'),(6,'Added category','Testing');
/*!40000 ALTER TABLE `Category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Transaction`
--

DROP TABLE IF EXISTS `Transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Transaction` (
  `TransactionID` int NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  `BudgetID` int DEFAULT NULL,
  `Amount` decimal(8,2) NOT NULL,
  `TransactionDate` date NOT NULL,
  `CategoryID` int NOT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `Type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`TransactionID`),
  KEY `UserID` (`UserID`),
  KEY `CategoryID` (`CategoryID`),
  KEY `FK_Transaction_Budget` (`BudgetID`),
  CONSTRAINT `FK_Transaction_Budget` FOREIGN KEY (`BudgetID`) REFERENCES `Budget` (`BudgetID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `User` (`UserID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `transaction_ibfk_2` FOREIGN KEY (`CategoryID`) REFERENCES `Category` (`CategoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Transaction`
--

LOCK TABLES `Transaction` WRITE;
/*!40000 ALTER TABLE `Transaction` DISABLE KEYS */;
INSERT INTO `Transaction` VALUES (2,1,3,100.00,'2024-12-06',1,'Test Transaction','Expense'),(3,1,3,100.00,'2024-12-06',1,'Test Transaction','Expense'),(4,1,3,100.00,'2024-12-06',1,'New transaction','Expense'),(5,1,3,500.00,'2024-01-01',2,'Car','Expense'),(6,1,3,500.00,'2024-01-01',2,'Car','Expense'),(7,1,4,10000.00,'2024-01-01',2,'Car','Expense'),(8,3,8,5000.00,'2024-01-01',2,'Car expenses','Expense'),(11,4,9,1000.00,'2024-01-01',5,'Home Decor','Expense'),(13,4,9,15000.00,'2024-01-01',6,'Budget over alert','Expense'),(15,5,10,100.00,'2024-01-01',1,'Nobu with girl','Expense');
/*!40000 ALTER TABLE `Transaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `User` (
  `UserID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Age` int DEFAULT NULL,
  `Email` varchar(100) NOT NULL,
  `Password` varchar(100) NOT NULL,
  `Status` varchar(50) DEFAULT 'Active',
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES (1,'Test User',25,'testuser@example.com','password123','Active'),(2,'Test User 2',20,'Test2example.om','default_password','Active'),(3,'Video Tutoril',20,'Testing@example.com','default_password','Inactive'),(4,'Test',12,'Test@gmail.com','default_password','Active'),(5,'Sean Gay Man',21,'Gayman@gmail.com','default_password','Inactive');
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-10 17:03:51
