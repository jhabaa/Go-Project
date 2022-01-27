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
-- Table structure for table `recepie`
--

DROP TABLE IF EXISTS `recepie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recepie` (
  `name` varchar(120) NOT NULL,
  `time` time DEFAULT NULL,
  `howto` varchar(2500) DEFAULT 'Cuire',
  PRIMARY KEY (`name`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recepie`
--

LOCK TABLES `recepie` WRITE;
/*!40000 ALTER TABLE `recepie` DISABLE KEYS */;
INSERT INTO `recepie` VALUES ('Eru ','10:10:10','Faire cuire les feuilles de Okok'),('Get','10:10:10','Yohgoihoihiouhi'),('Lasagnes','10:10:10','Faire cuire les pâtes'),('Look','10:10:10','Ydfbiobgisvydfbvdfpb pinging; fadbavfdb;'),('Lopo','10:10:10','Yvuygyuvfigiubvouvuiy;nuo'),('OKOK','10:10:10','Voici comment faire '),('Raviolis','10:10:10','Mound the flour and salt together on a work surface and form a well. Beat the teaspoon of olive oil, 2 eggs, and water in a bowl. Pour half the egg mixture into the well. Begin mixing the egg with the flour with one hand; use your other hand to keep the flour mound steady. Add the remaining egg mixture and knead to form a dough.'),('Test2','10:10:10','We try again');
/*!40000 ALTER TABLE `recepie` ENABLE KEYS */;
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
