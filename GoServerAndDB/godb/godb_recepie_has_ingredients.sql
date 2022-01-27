-- MySQL dump 10.13  Distrib 8.0.25, for macos11 (x86_64)
--
-- Host: localhost    Database: godb
-- ------------------------------------------------------
-- Server version	8.0.26

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
-- Table structure for table `recepie_has_ingredients`
--

DROP TABLE IF EXISTS `recepie_has_ingredients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recepie_has_ingredients` (
  `recepie_name` varchar(120) NOT NULL,
  `ingredients_name` varchar(200) NOT NULL,
  `needed_quantity` int DEFAULT '1',
  PRIMARY KEY (`recepie_name`,`ingredients_name`),
  KEY `fk_recepie_has_ingredients_ingredients1_idx` (`ingredients_name`),
  KEY `fk_recepie_has_ingredients_recepie_idx` (`recepie_name`),
  CONSTRAINT `fk_recepie_has_ingredients_ingredients1` FOREIGN KEY (`ingredients_name`) REFERENCES `ingredients` (`name`),
  CONSTRAINT `fk_recepie_has_ingredients_recepie` FOREIGN KEY (`recepie_name`) REFERENCES `recepie` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recepie_has_ingredients`
--

LOCK TABLES `recepie_has_ingredients` WRITE;
/*!40000 ALTER TABLE `recepie_has_ingredients` DISABLE KEYS */;
INSERT INTO `recepie_has_ingredients` VALUES ('Eru ','Oignon',3),('Eru ','Pates',1),('Eru ','Pomme',1),('Get','Poire',3),('Lasagnes','Pates',3),('Lasagnes','Tomate',5),('Look','Oignon',1),('Look','Poivron',2),('OKOK','Oignon',2),('OKOK','Pomme',2),('OKOK','Tomate',1),('Raviolis','Tomate',4);
/*!40000 ALTER TABLE `recepie_has_ingredients` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-01-25 19:45:52
