CREATE DATABASE  IF NOT EXISTS `famora` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `famora`;
-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: gateway01.ap-southeast-1.prod.aws.tidbcloud.com    Database: famora
-- ------------------------------------------------------
-- Server version	5.7.28-TiDB-Serverless

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alerts`
--

DROP TABLE IF EXISTS `alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alerts` (
  `alert_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `message` text NOT NULL,
  `budget_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `read` tinyint(1) NOT NULL,
  PRIMARY KEY (`alert_id`) /*T![clustered_index] CLUSTERED */,
  KEY `fk_1` (`user_id`),
  KEY `fk_2` (`budget_id`),
  CONSTRAINT `fk_1` FOREIGN KEY (`user_id`) REFERENCES `famora`.`users` (`user_id`),
  CONSTRAINT `fk_2` FOREIGN KEY (`budget_id`) REFERENCES `famora`.`budgets` (`budget_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alerts`
--

LOCK TABLES `alerts` WRITE;
/*!40000 ALTER TABLE `alerts` DISABLE KEYS */;
/*!40000 ALTER TABLE `alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `budgets`
--

DROP TABLE IF EXISTS `budgets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `budgets` (
  `budget_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `recurring` tinyint(1) NOT NULL,
  `threshold_value` decimal(10,2) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `family_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`budget_id`) /*T![clustered_index] CLUSTERED */,
  KEY `fk_1` (`category_id`),
  KEY `fk_2` (`user_id`),
  KEY `fk_3` (`family_id`),
  CONSTRAINT `fk_1` FOREIGN KEY (`category_id`) REFERENCES `famora`.`categories` (`category_id`),
  CONSTRAINT `fk_2` FOREIGN KEY (`user_id`) REFERENCES `famora`.`users` (`user_id`),
  CONSTRAINT `fk_3` FOREIGN KEY (`family_id`) REFERENCES `famora`.`families` (`family_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin AUTO_INCREMENT=30002;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `budgets`
--

LOCK TABLES `budgets` WRITE;
/*!40000 ALTER TABLE `budgets` DISABLE KEYS */;
INSERT INTO `budgets` VALUES (1,1,5000.00,'2025-04-24 00:00:00','2025-05-24 00:00:00',1,4510.00,NULL,602469),(2,NULL,5000.00,'2025-04-19 00:00:00','2025-05-19 00:00:00',1,4500.00,1,602469),(3,NULL,6000.00,'2025-04-22 00:00:00','2025-05-01 00:00:00',1,5500.00,8,602469),(4,20,1500.00,'2025-04-25 00:00:00','2025-05-25 00:00:00',1,1000.00,NULL,602469);
/*!40000 ALTER TABLE `budgets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`category_id`) /*T![clustered_index] CLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin AUTO_INCREMENT=30002;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Groceries'),(2,'Utilities'),(3,'Rent'),(4,'Entertainment'),(5,'Transportation'),(6,'Grocery'),(7,'Food'),(8,'Health'),(9,'Education'),(10,'Insurance'),(11,'Dining Out'),(12,'Clothing'),(13,'Household Supplies'),(14,'Gifts & Donations'),(15,'Travel'),(16,'Mobile Recharge'),(17,'Internet'),(18,'Pet Care'),(19,'Loans'),(20,'Subscriptions'),(21,'Childcare'),(22,'Beauty & Wellness'),(23,'Fitness'),(24,'Tax'),(25,'Emergency Fund');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expenses`
--

DROP TABLE IF EXISTS `expenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expenses` (
  `expense_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `date` datetime NOT NULL,
  `description` text DEFAULT NULL,
  `family_id` int(11) DEFAULT NULL,
  `receipt` longblob DEFAULT NULL,
  `budget_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`expense_id`) /*T![clustered_index] CLUSTERED */,
  KEY `fk_1` (`user_id`),
  KEY `fk_2` (`category_id`),
  KEY `fk_3` (`family_id`),
  KEY `fk_4` (`budget_id`),
  CONSTRAINT `fk_1` FOREIGN KEY (`user_id`) REFERENCES `famora`.`users` (`user_id`),
  CONSTRAINT `fk_2` FOREIGN KEY (`category_id`) REFERENCES `famora`.`categories` (`category_id`),
  CONSTRAINT `fk_3` FOREIGN KEY (`family_id`) REFERENCES `famora`.`families` (`family_id`),
  CONSTRAINT `fk_4` FOREIGN KEY (`budget_id`) REFERENCES `famora`.`budgets` (`budget_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin AUTO_INCREMENT=60002;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expenses`
--

LOCK TABLES `expenses` WRITE;
/*!40000 ALTER TABLE `expenses` DISABLE KEYS */;
INSERT INTO `expenses` VALUES (1,1,500.00,1,'2025-04-19 00:00:00','No',602469,NULL,NULL),(2,1,1000.00,3,'2025-04-19 00:00:00','No',602469,NULL,NULL),(3,1,350.00,4,'2025-04-19 00:00:00','No',602469,NULL,NULL),(5,2,600.00,7,'2025-04-19 00:00:00','No',602469,NULL,NULL),(6,8,600.00,3,'2025-04-22 00:00:00','No',602469,NULL,NULL),(7,8,900.00,2,'2025-04-22 00:00:00','No',602469,NULL,NULL),(10,1,500.00,5,'2025-04-22 00:00:00','Bus Pass',602469,NULL,NULL),(11,1,6000.00,19,'2025-04-25 00:00:00',NULL,602469,NULL,NULL),(12,1,10000.00,19,'2025-04-15 00:00:00','Home Loan',602469,NULL,NULL),(30002,1,500.00,18,'2025-04-29 00:00:00',NULL,602469,NULL,NULL);
/*!40000 ALTER TABLE `expenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `families`
--

DROP TABLE IF EXISTS `families`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `families` (
  `family_id` int(11) NOT NULL AUTO_INCREMENT,
  `family_name` varchar(255) NOT NULL,
  PRIMARY KEY (`family_id`) /*T![clustered_index] CLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin AUTO_INCREMENT=632470;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `families`
--

LOCK TABLES `families` WRITE;
/*!40000 ALTER TABLE `families` DISABLE KEYS */;
INSERT INTO `families` VALUES (158060,'Kumbre1'),(602469,'Kumbre');
/*!40000 ALTER TABLE `families` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fixed_investment`
--

DROP TABLE IF EXISTS `fixed_investment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fixed_investment` (
  `investment_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `principal_amount` decimal(15,2) NOT NULL,
  `interest_rate` decimal(5,2) NOT NULL,
  `start_date` date DEFAULT NULL,
  PRIMARY KEY (`investment_id`) /*T![clustered_index] CLUSTERED */,
  KEY `fk_1` (`user_id`),
  CONSTRAINT `fk_1` FOREIGN KEY (`user_id`) REFERENCES `famora`.`users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin AUTO_INCREMENT=30002;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fixed_investment`
--

LOCK TABLES `fixed_investment` WRITE;
/*!40000 ALTER TABLE `fixed_investment` DISABLE KEYS */;
INSERT INTO `fixed_investment` VALUES (1,1,6000.00,10.00,'2025-04-19');
/*!40000 ALTER TABLE `fixed_investment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `joint_goal_participants`
--

DROP TABLE IF EXISTS `joint_goal_participants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `joint_goal_participants` (
  `joint_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `contributed_amount` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`joint_id`,`user_id`) /*T![clustered_index] CLUSTERED */,
  KEY `fk_2` (`user_id`),
  CONSTRAINT `fk_1` FOREIGN KEY (`joint_id`) REFERENCES `famora`.`joint_goals` (`joint_id`),
  CONSTRAINT `fk_2` FOREIGN KEY (`user_id`) REFERENCES `famora`.`users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `joint_goal_participants`
--

LOCK TABLES `joint_goal_participants` WRITE;
/*!40000 ALTER TABLE `joint_goal_participants` DISABLE KEYS */;
INSERT INTO `joint_goal_participants` VALUES (883902,1,6500.00),(883902,2,0.00);
/*!40000 ALTER TABLE `joint_goal_participants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `joint_goals`
--

DROP TABLE IF EXISTS `joint_goals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `joint_goals` (
  `joint_id` int(11) NOT NULL AUTO_INCREMENT,
  `joint_goal_amount` decimal(10,2) NOT NULL,
  `joint_target_amount` decimal(10,2) NOT NULL,
  `deadline` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`joint_id`) /*T![clustered_index] CLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin AUTO_INCREMENT=913903;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `joint_goals`
--

LOCK TABLES `joint_goals` WRITE;
/*!40000 ALTER TABLE `joint_goals` DISABLE KEYS */;
INSERT INTO `joint_goals` VALUES (883902,60000.00,53500.00,'2025-04-19 00:00:00','2025-04-20 00:14:41');
/*!40000 ALTER TABLE `joint_goals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recc_expenses`
--

DROP TABLE IF EXISTS `recc_expenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recc_expenses` (
  `rec_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `amount` float NOT NULL,
  `category_id` int(11) NOT NULL,
  `description` varchar(225) DEFAULT NULL,
  `receipt` varchar(225) DEFAULT NULL,
  `family_id` int(11) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`rec_id`) /*T![clustered_index] CLUSTERED */,
  KEY `fk_1` (`user_id`),
  KEY `fk_2` (`category_id`),
  KEY `fk_3` (`family_id`),
  CONSTRAINT `fk_1` FOREIGN KEY (`user_id`) REFERENCES `famora`.`users` (`user_id`),
  CONSTRAINT `fk_2` FOREIGN KEY (`category_id`) REFERENCES `famora`.`categories` (`category_id`),
  CONSTRAINT `fk_3` FOREIGN KEY (`family_id`) REFERENCES `famora`.`families` (`family_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin AUTO_INCREMENT=30002;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recc_expenses`
--

LOCK TABLES `recc_expenses` WRITE;
/*!40000 ALTER TABLE `recc_expenses` DISABLE KEYS */;
INSERT INTO `recc_expenses` VALUES (1,1,500,5,'Bus Pass',NULL,602469,NULL,NULL),(2,1,10000,19,'Home Loan',NULL,602469,NULL,NULL);
/*!40000 ALTER TABLE `recc_expenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reports`
--

DROP TABLE IF EXISTS `reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reports` (
  `report_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `content` text NOT NULL,
  `generated_at` datetime NOT NULL,
  PRIMARY KEY (`report_id`) /*T![clustered_index] CLUSTERED */,
  KEY `fk_1` (`user_id`),
  CONSTRAINT `fk_1` FOREIGN KEY (`user_id`) REFERENCES `famora`.`users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin AUTO_INCREMENT=30003;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reports`
--

LOCK TABLES `reports` WRITE;
/*!40000 ALTER TABLE `reports` DISABLE KEYS */;
INSERT INTO `reports` VALUES (2,1,'Expense Report\nID, Category, Amount, Date, Description, User Name\n4, Transportation, 500.00, 2025-04-01 00:00:00, Bus Pass, Prasad\n1, Groceries, 500.00, 2025-04-19 00:00:00, No, Prasad\n2, Rent, 1000.00, 2025-04-19 00:00:00, No, Prasad\n3, Entertainment, 350.00, 2025-04-19 00:00:00, No, Prasad\n5, Food, 600.00, 2025-04-19 00:00:00, No, Prasad_2\n','2025-04-22 16:34:19'),(3,1,'Expense Report\nID, Category, Amount, Date, Description, User Name\n1, Groceries, 500.00, 2025-04-19 00:00:00, No, Prasad\n2, Rent, 1000.00, 2025-04-19 00:00:00, No, Prasad\n3, Entertainment, 350.00, 2025-04-19 00:00:00, No, Prasad\n5, Food, 600.00, 2025-04-19 00:00:00, No, Prasad_2\n6, Rent, 600.00, 2025-04-22 00:00:00, No, Prasad_118\n7, Utilities, 900.00, 2025-04-22 00:00:00, No, Prasad_118\n8, Food, 500.00, 2025-04-22 00:00:00, No, Prasad\n10, Transportation, 500.00, 2025-04-22 00:00:00, Bus Pass, Prasad\n','2025-04-22 22:14:25'),(4,1,'Expense Report\nID, Category, Amount, Date, Description, User Name\n12, Loans, 10000.00, 2025-04-15 00:00:00, Home Loan, Prasad\n1, Groceries, 500.00, 2025-04-19 00:00:00, No, Prasad\n2, Rent, 1000.00, 2025-04-19 00:00:00, No, Prasad\n3, Entertainment, 350.00, 2025-04-19 00:00:00, No, Prasad\n5, Food, 600.00, 2025-04-19 00:00:00, No, Prasad_2\n6, Rent, 600.00, 2025-04-22 00:00:00, No, Prasad_118\n7, Utilities, 900.00, 2025-04-22 00:00:00, No, Prasad_118\n10, Transportation, 500.00, 2025-04-22 00:00:00, Bus Pass, Prasad\n11, Loans, 6000.00, 2025-04-25 00:00:00, None, Prasad\n','2025-04-25 14:45:01');
/*!40000 ALTER TABLE `reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `savings_goals`
--

DROP TABLE IF EXISTS `savings_goals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `savings_goals` (
  `goal_id` int(11) NOT NULL AUTO_INCREMENT,
  `family_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_goal` decimal(10,2) NOT NULL,
  `family_goal` decimal(10,2) DEFAULT NULL,
  `user_target_amount` decimal(10,2) NOT NULL,
  `family_target_amount` decimal(10,2) DEFAULT NULL,
  `usergoal_contributed_amount` decimal(10,2) NOT NULL,
  `familygoal_contributed_amount` decimal(10,2) NOT NULL,
  `deadline` datetime NOT NULL,
  PRIMARY KEY (`goal_id`) /*T![clustered_index] CLUSTERED */,
  KEY `fk_1` (`user_id`),
  KEY `fk_2` (`family_id`),
  CONSTRAINT `fk_1` FOREIGN KEY (`user_id`) REFERENCES `famora`.`users` (`user_id`),
  CONSTRAINT `fk_2` FOREIGN KEY (`family_id`) REFERENCES `famora`.`families` (`family_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin AUTO_INCREMENT=30002;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `savings_goals`
--

LOCK TABLES `savings_goals` WRITE;
/*!40000 ALTER TABLE `savings_goals` DISABLE KEYS */;
INSERT INTO `savings_goals` VALUES (1,602469,1,6000.00,NULL,4900.00,NULL,1100.00,0.00,'2025-05-09 00:00:00'),(2,602469,8,6000.00,NULL,6000.00,NULL,0.00,0.00,'2025-04-22 00:00:00');
/*!40000 ALTER TABLE `savings_goals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `bank_acc_no` bigint(20) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone_no` bigint(20) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(100) NOT NULL,
  `family_id` int(11) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  PRIMARY KEY (`user_id`) /*T![clustered_index] CLUSTERED */,
  KEY `fk_1` (`family_id`),
  CONSTRAINT `fk_1` FOREIGN KEY (`family_id`) REFERENCES `famora`.`families` (`family_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin AUTO_INCREMENT=30002;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Prasad_15','Prasad',0,'prasadkumbare2@gmail.com',9325395949,'Demo@1517','HOF',602469,'2002-05-15'),(2,'Prasad_17','Prasad_2',0,'prasadkumbare118@gmail.com',8975785733,'Demo@1517','Member',602469,'2002-05-15'),(8,'Prasad_118','Prasad_118',0,'kumbreprasad@gmail.com',9685848598,'Demo@1517','Member',602469,'2002-05-15');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-14 22:34:37
